
// -----------
// This file was generated by riscv_ctg (https://github.com/riscv-software-src/riscv-ctg)
// version   : 0.12.1
// timestamp : Mon Apr  1 19:38:40 2024 GMT
// usage     : riscv_ctg \
//                  -- cgf //                  --cgf /home/cm/src/riscv-ctg/zfa/sample_cgfs/dataset.cgf \
//                  --cgf /home/cm/src/riscv-ctg/zfa/sample_cgfs/zfa/fcvtmod.w.d.cgf \
 \
//                  -- xlen 32  \
// -----------
//
// -----------
// Copyright (c) 2020. RISC-V International. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// -----------
//
// This assembly file tests the fcvtmod.w.d instruction of the RISC-V RV32FD_Zicsr_Zfa,RV64FD_Zicsr_Zfa extension for the fcvtmod.w.d_b1 covergroup.
// 
#include "model_test.h"
#include "arch_test.h"
RVTEST_ISA("RV32IFD_Zicsr_Zfa,RV64IFD_Zicsr_Zfa")

.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
RVMODEL_BOOT
RVTEST_CODE_BEGIN

#ifdef TEST_CASE_1

RVTEST_CASE(0,"//check ISA:=regex(.*I.*D.*Zfa.*);def TEST_CASE_1=True;",fcvtmod.w.d_b1)

RVTEST_FP_ENABLE()
RVTEST_VALBASEUPD(x3,test_dataset_0)
RVTEST_SIGBASE(x1,signature_x1_1)

inst_0:// rs1==f31, rd==x31,fs1 == 0 and fe1 == 0x000 and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f31; dest:x31; op1val:0x0; valaddr_reg:x3;
val_offset:0*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x31, f31, rtz, 0, 0, x3, 0*FLEN/8, x4, x1, x2,FLREG)

inst_1:// rs1==f30, rd==x30,fs1 == 1 and fe1 == 0x000 and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f30; dest:x30; op1val:0x8000000000000000; valaddr_reg:x3;
val_offset:1*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x30, f30, rtz, 0, 0, x3, 1*FLEN/8, x4, x1, x2,FLREG)

inst_2:// rs1==f29, rd==x29,fs1 == 0 and fe1 == 0x000 and fm1 == 0x0000000000001 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f29; dest:x29; op1val:0x1; valaddr_reg:x3;
val_offset:2*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x29, f29, rtz, 0, 0, x3, 2*FLEN/8, x4, x1, x2,FLREG)

inst_3:// rs1==f28, rd==x28,fs1 == 1 and fe1 == 0x000 and fm1 == 0x0000000000001 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f28; dest:x28; op1val:0x8000000000000001; valaddr_reg:x3;
val_offset:3*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x28, f28, rtz, 0, 0, x3, 3*FLEN/8, x4, x1, x2,FLREG)

inst_4:// rs1==f27, rd==x27,fs1 == 0 and fe1 == 0x000 and fm1 == 0x0000000000002 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f27; dest:x27; op1val:0x2; valaddr_reg:x3;
val_offset:4*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x27, f27, rtz, 0, 0, x3, 4*FLEN/8, x4, x1, x2,FLREG)

inst_5:// rs1==f26, rd==x26,fs1 == 1 and fe1 == 0x000 and fm1 == 0x0000000000002 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f26; dest:x26; op1val:0x8000000000000002; valaddr_reg:x3;
val_offset:5*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x26, f26, rtz, 0, 0, x3, 5*FLEN/8, x4, x1, x2,FLREG)

inst_6:// rs1==f25, rd==x25,fs1 == 0 and fe1 == 0x000 and fm1 == 0xfffffffffffff and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f25; dest:x25; op1val:0xfffffffffffff; valaddr_reg:x3;
val_offset:6*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x25, f25, rtz, 0, 0, x3, 6*FLEN/8, x4, x1, x2,FLREG)

inst_7:// rs1==f24, rd==x24,fs1 == 1 and fe1 == 0x000 and fm1 == 0xfffffffffffff and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f24; dest:x24; op1val:0x800fffffffffffff; valaddr_reg:x3;
val_offset:7*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x24, f24, rtz, 0, 0, x3, 7*FLEN/8, x4, x1, x2,FLREG)

inst_8:// rs1==f23, rd==x23,fs1 == 0 and fe1 == 0x001 and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f23; dest:x23; op1val:0x10000000000000; valaddr_reg:x3;
val_offset:8*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x23, f23, rtz, 0, 0, x3, 8*FLEN/8, x4, x1, x2,FLREG)

inst_9:// rs1==f22, rd==x22,fs1 == 1 and fe1 == 0x001 and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f22; dest:x22; op1val:0x8010000000000000; valaddr_reg:x3;
val_offset:9*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x22, f22, rtz, 0, 0, x3, 9*FLEN/8, x4, x1, x2,FLREG)

inst_10:// rs1==f21, rd==x21,fs1 == 0 and fe1 == 0x001 and fm1 == 0x0000000000002 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f21; dest:x21; op1val:0x10000000000002; valaddr_reg:x3;
val_offset:10*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x21, f21, rtz, 0, 0, x3, 10*FLEN/8, x4, x1, x2,FLREG)

inst_11:// rs1==f20, rd==x20,fs1 == 1 and fe1 == 0x001 and fm1 == 0x0000000000002 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f20; dest:x20; op1val:0x8010000000000002; valaddr_reg:x3;
val_offset:11*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x20, f20, rtz, 0, 0, x3, 11*FLEN/8, x4, x1, x2,FLREG)

inst_12:// rs1==f19, rd==x19,fs1 == 0 and fe1 == 0x7fe and fm1 == 0xfffffffffffff and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f19; dest:x19; op1val:0x7fefffffffffffff; valaddr_reg:x3;
val_offset:12*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x19, f19, rtz, 0, 0, x3, 12*FLEN/8, x4, x1, x2,FLREG)

inst_13:// rs1==f18, rd==x18,fs1 == 1 and fe1 == 0x7fe and fm1 == 0xfffffffffffff and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f18; dest:x18; op1val:0xffefffffffffffff; valaddr_reg:x3;
val_offset:13*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x18, f18, rtz, 0, 0, x3, 13*FLEN/8, x4, x1, x2,FLREG)

inst_14:// rs1==f17, rd==x17,fs1 == 0 and fe1 == 0x7ff and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f17; dest:x17; op1val:0x7ff0000000000000; valaddr_reg:x3;
val_offset:14*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x17, f17, rtz, 0, 0, x3, 14*FLEN/8, x4, x1, x2,FLREG)

inst_15:// rs1==f16, rd==x16,fs1 == 1 and fe1 == 0x7ff and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f16; dest:x16; op1val:0xfff0000000000000; valaddr_reg:x3;
val_offset:15*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x16, f16, rtz, 0, 0, x3, 15*FLEN/8, x4, x1, x2,FLREG)

inst_16:// rs1==f15, rd==x15,fs1 == 0 and fe1 == 0x7ff and fm1 == 0x8000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f15; dest:x15; op1val:0x7ff8000000000000; valaddr_reg:x3;
val_offset:16*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x15, f15, rtz, 0, 0, x3, 16*FLEN/8, x4, x1, x2,FLREG)

inst_17:// rs1==f14, rd==x14,fs1 == 1 and fe1 == 0x7ff and fm1 == 0x8000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f14; dest:x14; op1val:0xfff8000000000000; valaddr_reg:x3;
val_offset:17*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x14, f14, rtz, 0, 0, x3, 17*FLEN/8, x4, x1, x2,FLREG)

inst_18:// rs1==f13, rd==x13,fs1 == 0 and fe1 == 0x7ff and fm1 == 0x8000000000001 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f13; dest:x13; op1val:0x7ff8000000000001; valaddr_reg:x3;
val_offset:18*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x13, f13, rtz, 0, 0, x3, 18*FLEN/8, x4, x1, x2,FLREG)

inst_19:// rs1==f12, rd==x12,fs1 == 1 and fe1 == 0x7ff and fm1 == 0x8000000000001 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f12; dest:x12; op1val:0xfff8000000000001; valaddr_reg:x3;
val_offset:19*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x12, f12, rtz, 0, 0, x3, 19*FLEN/8, x4, x1, x2,FLREG)

inst_20:// rs1==f11, rd==x11,fs1 == 0 and fe1 == 0x7ff and fm1 == 0x0000000000001 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f11; dest:x11; op1val:0x7ff0000000000001; valaddr_reg:x3;
val_offset:20*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x11, f11, rtz, 0, 0, x3, 20*FLEN/8, x4, x1, x2,FLREG)

inst_21:// rs1==f10, rd==x10,fs1 == 1 and fe1 == 0x7ff and fm1 == 0x0000000000001 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f10; dest:x10; op1val:0xfff0000000000001; valaddr_reg:x3;
val_offset:21*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x10, f10, rtz, 0, 0, x3, 21*FLEN/8, x4, x1, x2,FLREG)

inst_22:// rs1==f9, rd==x9,fs1 == 0 and fe1 == 0x3ff and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f9; dest:x9; op1val:0x3ff0000000000000; valaddr_reg:x3;
val_offset:22*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x9, f9, rtz, 0, 0, x3, 22*FLEN/8, x4, x1, x2,FLREG)

inst_23:// rs1==f8, rd==x8,fs1 == 1 and fe1 == 0x3f8 and fm1 == 0x0000000000000 and  fcsr == 0x0 and rm_val == 7   
/* opcode: fcvtmod.w.d ; op1:f8; dest:x8; op1val:0xbf80000000000000; valaddr_reg:x3;
val_offset:23*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x8, f8, rtz, 0, 0, x3, 23*FLEN/8, x4, x1, x2,FLREG)
RVTEST_VALBASEUPD(x8,test_dataset_1)

inst_24:// rs1==f7, rd==x7,
/* opcode: fcvtmod.w.d ; op1:f7; dest:x7; op1val:0x0; valaddr_reg:x8;
val_offset:0*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x7, f7, rtz, 0, 0, x8, 0*FLEN/8, x9, x1, x2,FLREG)

inst_25:// rs1==f6, rd==x6,
/* opcode: fcvtmod.w.d ; op1:f6; dest:x6; op1val:0x0; valaddr_reg:x8;
val_offset:1*FLEN/8; rmval:rtz; correctval:??; testreg:x2;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x6, f6, rtz, 0, 0, x8, 1*FLEN/8, x9, x1, x2,FLREG)

inst_26:// rs1==f5, rd==x5,
/* opcode: fcvtmod.w.d ; op1:f5; dest:x5; op1val:0x0; valaddr_reg:x8;
val_offset:2*FLEN/8; rmval:rtz; correctval:??; testreg:x6;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x5, f5, rtz, 0, 0, x8, 2*FLEN/8, x9, x1, x6,FLREG)
RVTEST_SIGBASE(x5,signature_x5_0)

inst_27:// rs1==f4, rd==x4,
/* opcode: fcvtmod.w.d ; op1:f4; dest:x4; op1val:0x0; valaddr_reg:x8;
val_offset:3*FLEN/8; rmval:rtz; correctval:??; testreg:x6;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x4, f4, rtz, 0, 0, x8, 3*FLEN/8, x9, x5, x6,FLREG)

inst_28:// rs1==f3, rd==x3,
/* opcode: fcvtmod.w.d ; op1:f3; dest:x3; op1val:0x0; valaddr_reg:x8;
val_offset:4*FLEN/8; rmval:rtz; correctval:??; testreg:x6;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x3, f3, rtz, 0, 0, x8, 4*FLEN/8, x9, x5, x6,FLREG)

inst_29:// rs1==f2, rd==x2,
/* opcode: fcvtmod.w.d ; op1:f2; dest:x2; op1val:0x0; valaddr_reg:x8;
val_offset:5*FLEN/8; rmval:rtz; correctval:??; testreg:x6;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x2, f2, rtz, 0, 0, x8, 5*FLEN/8, x9, x5, x6,FLREG)

inst_30:// rs1==f1, rd==x1,
/* opcode: fcvtmod.w.d ; op1:f1; dest:x1; op1val:0x0; valaddr_reg:x8;
val_offset:6*FLEN/8; rmval:rtz; correctval:??; testreg:x6;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x1, f1, rtz, 0, 0, x8, 6*FLEN/8, x9, x5, x6,FLREG)

inst_31:// rs1==f0, rd==x0,
/* opcode: fcvtmod.w.d ; op1:f0; dest:x0; op1val:0x0; valaddr_reg:x8;
val_offset:7*FLEN/8; rmval:rtz; correctval:??; testreg:x6;
fcsr_val:0*/
TEST_FPID_OP(fcvtmod.w.d, x0, f0, rtz, 0, 0, x8, 7*FLEN/8, x9, x5, x6,FLREG)
#endif


RVTEST_CODE_END
RVMODEL_HALT

RVTEST_DATA_BEGIN
.align 4
rvtest_data:
.word 0xbabecafe
.word 0xabecafeb
.word 0xbecafeba
.word 0xecafebab
test_dataset_0:
NAN_BOXED(0,64,FLEN)
NAN_BOXED(9223372036854775808,64,FLEN)
NAN_BOXED(1,64,FLEN)
NAN_BOXED(9223372036854775809,64,FLEN)
NAN_BOXED(2,64,FLEN)
NAN_BOXED(9223372036854775810,64,FLEN)
NAN_BOXED(4503599627370495,64,FLEN)
NAN_BOXED(9227875636482146303,64,FLEN)
NAN_BOXED(4503599627370496,64,FLEN)
NAN_BOXED(9227875636482146304,64,FLEN)
NAN_BOXED(4503599627370498,64,FLEN)
NAN_BOXED(9227875636482146306,64,FLEN)
NAN_BOXED(9218868437227405311,64,FLEN)
NAN_BOXED(18442240474082181119,64,FLEN)
NAN_BOXED(9218868437227405312,64,FLEN)
NAN_BOXED(18442240474082181120,64,FLEN)
NAN_BOXED(9221120237041090560,64,FLEN)
NAN_BOXED(18444492273895866368,64,FLEN)
NAN_BOXED(9221120237041090561,64,FLEN)
NAN_BOXED(18444492273895866369,64,FLEN)
NAN_BOXED(9218868437227405313,64,FLEN)
NAN_BOXED(18442240474082181121,64,FLEN)
NAN_BOXED(4607182418800017408,64,FLEN)
NAN_BOXED(13799029258263199744,64,FLEN)
test_dataset_1:
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
NAN_BOXED(0,64,FLEN)
RVTEST_DATA_END

RVMODEL_DATA_BEGIN
rvtest_sig_begin:
sig_begin_canary:
CANARY;



signature_x1_0:
    .fill 0*((SIGALIGN)/4),4,0xdeadbeef


signature_x1_1:
    .fill 54*((SIGALIGN)/4),4,0xdeadbeef


signature_x5_0:
    .fill 10*((SIGALIGN)/4),4,0xdeadbeef

#ifdef rvtest_mtrap_routine
tsig_begin_canary:
CANARY;

mtrap_sigptr:
    .fill 64*XLEN/32,4,0xdeadbeef

tsig_end_canary:
CANARY;
#endif

#ifdef rvtest_gpr_save

gpr_save:
    .fill 32*XLEN/32,4,0xdeadbeef

#endif


sig_end_canary:
CANARY;
rvtest_sig_end:
RVMODEL_DATA_END
