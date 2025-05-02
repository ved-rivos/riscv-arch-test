import os
import re
import shutil
import subprocess
import shlex
import logging
import random
import string
import json
from string import Template

import riscof.utils as utils
from riscof.pluginTemplate import pluginTemplate
import riscof.constants as constants
from riscv_isac.isac import isac

logger = logging.getLogger()

class sail_cSim(pluginTemplate):
    __model__ = "sail_c_simulator"
    __version__ = "0.5.0"

    def __init__(self, *args, **kwargs):
        sclass = super().__init__(*args, **kwargs)

        config = kwargs.get('config')
        if config is None:
            logger.error("Config node for sail_cSim missing.")
            raise SystemExit(1)
        self.num_jobs = str(config['jobs'] if 'jobs' in config else 1)
        self.pluginpath = os.path.abspath(config['pluginpath'])
        self.sail_exe = { '32' : os.path.join(config['PATH'] if 'PATH' in config else "","riscv_sim_rv32d"),
                '64' : os.path.join(config['PATH'] if 'PATH' in config else "","riscv_sim_rv64d")}
        self.isa_spec = os.path.abspath(config['ispec']) if 'ispec' in config else ''
        self.platform_spec = os.path.abspath(config['pspec']) if 'ispec' in config else ''
        self.make = config['make'] if 'make' in config else 'make'
        logger.debug("SAIL CSim plugin initialised using the following configuration.")
        for entry in config:
            logger.debug(entry+' : '+config[entry])
        return sclass

    def initialise(self, suite, work_dir, archtest_env):
        self.suite = suite
        self.work_dir = work_dir
        self.objdump_cmd = 'riscv{1}-unknown-elf-objdump -D {0} > {2};'
        self.compile_cmd = 'riscv{1}-unknown-elf-gcc -march={0} \
         -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles\
         -T '+self.pluginpath+'/env/link.ld\
         -I '+self.pluginpath+'/env/\
         -I ' + archtest_env

    def build(self, isa_yaml, platform_yaml):
        ispec = utils.load_yaml(isa_yaml)['hart0']
        self.xlen = ('64' if 64 in ispec['supported_xlen'] else '32')
        self.isa_yaml_path = isa_yaml
        self.isa = 'rv' + self.xlen
        self.compile_cmd = self.compile_cmd+' -mabi='+('lp64 ' if 64 in ispec['supported_xlen'] else 'ilp32 ')
        if "I" in ispec["ISA"]:
            self.isa += 'i'
        if "M" in ispec["ISA"]:
            self.isa += 'm'
        if "A" in ispec["ISA"]:
            self.isa += 'a'
        if "F" in ispec["ISA"]:
            self.isa += 'f'
        if "D" in ispec["ISA"]:
            self.isa += 'd'
        if "C" in ispec["ISA"]:
            self.isa += 'c'
        objdump = "riscv{0}-unknown-elf-objdump".format(self.xlen)
        if shutil.which(objdump) is None:
            logger.error(objdump+": executable not found. Please check environment setup.")
            raise SystemExit(1)
        compiler = "riscv{0}-unknown-elf-gcc".format(self.xlen)
        if shutil.which(compiler) is None:
            logger.error(compiler+": executable not found. Please check environment setup.")
            raise SystemExit(1)
        if shutil.which(self.sail_exe[self.xlen]) is None:
            logger.error(self.sail_exe[self.xlen]+ ": executable not found. Please check environment setup.")
            raise SystemExit(1)
        if shutil.which(self.make) is None:
            logger.error(self.make+": executable not found. Please check environment setup.")
            raise SystemExit(1)

    def runTests(self, testList, cgf_file=None, header_file= None):
        if os.path.exists(self.work_dir+ "/Makefile." + self.name[:-1]):
            os.remove(self.work_dir+ "/Makefile." + self.name[:-1])
        make = utils.makeUtil(makefilePath=os.path.join(self.work_dir, "Makefile." + self.name[:-1]))
        make.makeCommand = self.make + ' -j' + self.num_jobs
        for file in testList:
            testentry = testList[file]
            test = testentry['test_path']
            test_dir = testentry['work_dir']
            test_name = test.rsplit('/',1)[1][:-2]

            elf = 'ref.elf'

            execute = "@cd "+testentry['work_dir']+";"

            cmd = self.compile_cmd.format(testentry['isa'].lower(), self.xlen) + ' ' + test + ' -o ' + elf
            compile_cmd = cmd + ' -D' + " -D".join(testentry['macros'])
            execute+=compile_cmd+";"

            execute += self.objdump_cmd.format(elf, self.xlen, 'ref.disass')
            sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")

            isa_yaml = utils.load_yaml(self.isa_yaml_path)
            # Verify the availability of PMP:
            if "PMP" in isa_yaml['hart0']:
                pmp_flags = {}
                if isa_yaml['hart0']["PMP"]["implemented"] == True:
                    if "pmp-grain" in isa_yaml['hart0']["PMP"]:
                        pmp_flags["pmp-grain"] = isa_yaml['hart0']["PMP"]["pmp-grain"]
                    else:
                        logger.error("PMP grain not defined")
                        pmp_flags = ""
                    if "pmp-count" in isa_yaml['hart0']["PMP"]:
                        pmp_flags["pmp-count"] = isa_yaml['hart0']["PMP"]["pmp-count"]
                    else:
                        logger.error("PMP count not defined")
                        pmp_flags = ""
            else:
                pmp_flags = ""

            sail_config_path = os.path.join(self.pluginpath, 'env', 'sail_config.json')

            # Read the JSON configuration from the file
            with open(sail_config_path, 'r', encoding='utf-8') as file:
                config = json.load(file)

            # Update the values for pmp
            config["memory"]["pmp"]["grain"] = pmp_flags["pmp-grain"]
            config["memory"]["pmp"]["count"] = pmp_flags["pmp-count"]

            # Update the values for the ramsize.
            config["platform"]["ram"]["base"] = 2147483648
            config["platform"]["ram"]["size"] = 2147483648
            # config["platform"]["ram"]["size"] = 8796093022208
            # execute += self.sail_exe[self.xlen] + '  -i -v --trace=step {0} --ram-size=8796093022208 --signature-granularity=8  --test-signature={1} {2} > {3}.log 2>&1;'.format(pmp_flags, sig_file, elf, test_name)

            # Write the updated configuration back to the file
            with open(sail_config_path, 'w', encoding='utf-8') as file:
                json.dump(config, file, indent=4)

            execute += self.sail_exe[self.xlen] + ' --config={0} -v --trace=step --signature-granularity=8  --test-signature={1} {2} > {3}.log 2>&1;'.format(sail_config_path, sig_file, elf, test_name)

            cov_str = ' '
            for label in testentry['coverage_labels']:
                cov_str+=' -l '+label

            cgf_mac = ' '
            header_file_flag = ' '
            if header_file is not None:
                header_file_flag = f' -h {header_file} '
                cgf_mac += ' -cm common '
                for macro in testentry['mac']:
                    cgf_mac+=' -cm '+macro

            if cgf_file is not None:
                coverage_cmd = 'riscv_isac --verbose info coverage -d \
                        -t {0}.log --parser-name c_sail -o coverage.rpt  \
                        --sig-label begin_signature  end_signature \
                        -e ref.elf -c {1} -x{2} {3} {4} {5};'.format(\
                        test_name, ' -c '.join(cgf_file), self.xlen, cov_str, header_file_flag, cgf_mac)
            else:
                coverage_cmd = ''


            execute+=coverage_cmd

            make.add_target(execute)
        make.execute_all(self.work_dir)
