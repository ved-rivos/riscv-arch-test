// -----------
// Copyright (c) 2023. RISC-V International. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// -----------
//
// This assembly file tests the Smctr extension
//

#include "model_test.h"
#include "arch_test.h"

RVTEST_ISA("RV64I_Zicsr")

# Test code region
.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
RVMODEL_BOOT
RVTEST_CODE_BEGIN

RVTEST_SIGBASE(x15, signature_x15_m)

#ifdef TEST_CASE_1
RVTEST_CASE(0,"//check ISA:=regex(.*64.*I.*Zicsr.*Smctr); def rvtest_mtrap_routine=True; def TEST_CASE_1=True",smctr)

  # Update initial values to Smctr CSRs to signature`
  RVTEST_SIGUPD_CSR(x15, x1, CSR_MCTRCTL)
  RVTEST_SIGUPD_CSR(x15, x1, CSR_SCTRCTL)
  RVTEST_SIGUPD_CSR(x15, x1, CSR_SCTRDEPTH)
  RVTEST_SIGUPD_CSR(x15, x1, CSR_SCTRSTATUS)

  # WARL discovery of mctrctl
  li x1, 0xFFFFFFFFFFFFFFFF
  csrw CSR_MCTRCTL, x1
  RVTEST_SIGUPD_CSR(x15, x1, CSR_MCTRCTL)
  RVTEST_SIGUPD_CSR(x15, x1, CSR_SCTRCTL)
 
  # discover maximum depth in x14
  li x1, 0xFFFFFFFFFFFFFFFF
try_next_depth:
  addi x1, x1, 1 
  csrw CSR_SCTRDEPTH, x1
  csrr x14, CSR_SCTRDEPTH
  beq x1, x14, try_next_depth
  csrr x14, CSR_SCTRDEPTH
  addi x14, x14, 4
  li x1, 1
  sll x14, x1, x14

  # init wrptr and frozen to 0 and clear all CTR
  csrw CSR_SCTRSTATUS, x0
  .word MATCH_SCTRCLR  // sctrclr
  RVTEST_SIGUPD_CSR(x15, x1, CSR_SCTRSTATUS)
 
  # disable CTR at M mode 
  li x1, 0

redo: 
  csrw CSR_MCTRCTL, x1
  .word MATCH_SCTRCLR  // sctrclr
  csrw CSR_SCTRSTATUS, x0

  # direct jmp with linkage
  li x4, MCTRCTL_DIRLJMPINH
  jal x9, dirljmp0
dirljmp0:
  csrs CSR_MCTRCTL, x4
  jal x9, dirljmp1
dirljmp1:
  csrc CSR_MCTRCTL, x4

  # indirect jmp with linkage
  li x4, MCTRCTL_INDLJMPINH
  la x3, indljmp0
  jalr x9, x3
indljmp0:
  csrs CSR_MCTRCTL, x4
  la x3, indljmp1
  jalr x9, x3
indljmp1:
  csrc CSR_MCTRCTL, x4

  # function return
  li x4, MCTRCTL_RETINH
  la x5, ret0
  jalr x0, x5
ret0:
  csrs CSR_MCTRCTL, x4
  la x5, ret1
  jalr x0, x5
ret1:
  csrc CSR_MCTRCTL, x4

  # coroutine
  li x4, MCTRCTL_CORSWAPINH
  la x5, cor0
  jalr x1, x5
cor0:
  csrs CSR_MCTRCTL, x4
  la x5, cor1
  jalr x1, x5
cor1:
  csrc CSR_MCTRCTL, x4

  # direct jump without linkage
  li x4, MCTRCTL_DIRJMPINH
  jal x0, dirjmp0
dirjmp0:
  csrs CSR_MCTRCTL, x4
  jal x0, dirjmp1
dirjmp1:
  csrc CSR_MCTRCTL, x4

  # indirect jmp without linkage
  li x4, MCTRCTL_INDJMPINH
  la x3, indjmp0
  jalr x0, x3
indjmp0:
  csrs CSR_MCTRCTL, x4
  la x3, indjmp1
  jalr x0, x3
indjmp1:
  csrc CSR_MCTRCTL, x4

  # direct call
  li x4, MCTRCTL_DIRCALLINH
  jal x1, dircall0
dircall0:
  csrs CSR_MCTRCTL, x4
  jal x1, dircall1
dircall1:
  csrc CSR_MCTRCTL, x4

  # indirect call
  li x4, MCTRCTL_INDCALLINH
  la x3, indcall0
  jalr x1, x3
indcall0:
  csrs CSR_MCTRCTL, x4
  la x3, indcall1
  jalr x1, x3
indcall1:
  csrc CSR_MCTRCTL, x4

  # taken branch
  li x4, MCTRCTL_TKBRINH
  beq x0, x0, taken_branch_0
taken_branch_0:
  csrs CSR_MCTRCTL, x4
  beq x0, x0, taken_branch_1
taken_branch_1:
  csrc CSR_MCTRCTL, x4

  # not taken branch
  li x4, MCTRCTL_NTBREN
  csrs CSR_MCTRCTL, x4
  bgt x0, x0, not_taken_branch_0
not_taken_branch_0:
  csrc CSR_MCTRCTL, x4
  bgt x0, x0, not_taken_branch_1
not_taken_branch_1:

  # trap return
  li x4, MCTRCTL_TRETINH
  li x1, MSTATUS_MPP
  csrs CSR_MSTATUS, x1
  li x1, MSTATUS_MPIE
  csrc CSR_MSTATUS, x1
  la x1, trap_return_0
  csrw CSR_MEPC, x1 
  mret
trap_return_0:
  csrs CSR_MCTRCTL, x4
  li x1, MSTATUS_MPP
  csrs CSR_MSTATUS, x1
  la x1, trap_return_1
  csrw CSR_MEPC, x1 
  mret
trap_return_1:
  csrc CSR_MCTRCTL, x4

  # exception
  li x4, MCTRCTL_EXCINH
  csrs CSR_MCTRCTL, x4
  csrr x9, CSR_MTVEC
  la x1, exc_0
  csrw CSR_MTVEC, x1 
  ecall
exc_0:
  csrc CSR_MCTRCTL, x4
  la x1, exc_1
  csrw CSR_MTVEC, x1 
  ecall
exc_1:
  csrw CSR_MTVEC, x9

  csrr x1, CSR_MCTRCTL
  andi x1, x1, MCTRCTL_M
  csrw CSR_MCTRCTL, x0
  bne x1, x0, done

  RVTEST_SIGUPD_ALL_CTR(x15, x1)

  csrr x1, CSR_MCTRCTL
  ori  x1, x1, MCTRCTL_M
  j redo

done:
  csrw CSR_MCTRCTL, x0
  RVTEST_SIGUPD_ALL_CTR(x15, x1)

#endif
RVTEST_CODE_END
RVMODEL_HALT

# Input data section.
RVTEST_DATA_BEGIN
    .align 4
RVTEST_DATA_END

# Output data section.
RVMODEL_DATA_BEGIN
rvtest_sig_begin:
sig_begin_canary:
CANARY;

signature_x15_m:
    .fill 2048*(XLEN/32),4,0xdeadbeef

#ifdef rvtest_mtrap_routine

tsig_begin_canary:
CANARY;
mtrap_sigptr:
    .fill 64*(XLEN/32),4,0xdeadbeef
tsig_end_canary:
CANARY;

#endif

#ifdef rvtest_gpr_save

gpr_save:
    .fill 32*(XLEN/32),4,0xdeadbeef

#endif


sig_end_canary:
CANARY;
rvtest_sig_end:
RVMODEL_DATA_END
