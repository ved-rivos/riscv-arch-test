// -----------
// Copyright (c) 2020. RISC-V International. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// -----------
//
// This assembly file tests the Svadu extension
// 
#include "model_test.h"
#include "arch_test.h"

# Test Virtual Machine (TVM) used by program.
RVTEST_ISA("RV64I_Svadu")

# Test code region
.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
RVMODEL_BOOT
RVTEST_CODE_BEGIN

#ifdef TEST_CASE_1
  RVTEST_CASE(1,"//check ISA:=regex(.*64.*); check ISA:=regex(.*I.*); check ISA:=regex(.*Svadu.*); def TEST_CASE_1=True", svadu)

  RVTEST_SIGBASE(x1, signature_x1_0)

  # update ppn in pte
  la t2, pte_sv32
  lw t0, (t2)
  la t1, page
  srli t1, t1, (RISCV_PGSHIFT - PTE_PPN_SHIFT)
  or t0, t0, t1 
  sw t0, (t2)

  # enable vm in sv32 mode
  li a0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la a1, pte_sv32
  srl a1, a1, RISCV_PGSHIFT
  or a1, a1, a0
  csrw sptbr, a1
  sfence.vma

  # setup trap handler
  la a0, mtvec_handler
  csrw mtvec, a0

  # Set up MPRV with MPP=S, so loads and stores use S-mode
  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_MPRV
  csrs mstatus, a1

  # Store 0 to va 0 to test a fault (SUM is 0)
  # Skip instruction after fault, dont set A/D bits
  li x30, 4
  li x29, 0
  sw x0, (x0)

  # clear MPRV
  li a1, MSTATUS_MPRV
  csrc mstatus, a1

  # Store pte to signature
  lw t0, pte_sv32
  RVTEST_SIGUPD(x1,t0,offset)

  # Set SUM=1, MPRV=1, reset MPP to S
  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_SUM | MSTATUS_MPRV
  csrs mstatus, a1

  # store to va 0 - should cause page fault due to A=D=0
  # request trap handler to set A=D=1 and retry
  # no page fault should occur on retry 
  li x30, 0
  li x29, PTE_A | PTE_D
  sw x0, (x0)

  # clear MPRV
  li a1, MSTATUS_MPRV
  csrc mstatus, a1
  # Store pte to signature
  lw t0, pte_sv32
  RVTEST_SIGUPD(x1,t0,offset)

  # Clear A/D bits from PTE
  la t0, pte_sv32
  lw t2, (t0)
  li t1, PTE_A | PTE_D
  not t1, t1
  and t1, t2, t1
  sw t1, (t0)

  # Set SUM=1, MPRV=1, reset MPP to S
  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_SUM | MSTATUS_MPRV
  csrs mstatus, a1

  # set HADE to enable HW A/D updating
#if __riscv_xlen == 64
  li a1, MENVCFG_HADE
  csrc menvcfg, a1
#else
  li a1, MENVCFGH_HADE
  csrc menvcfgh, a1
#endif

  # store to va 0 - should not cause page fault due to A=D=0
  li x30, 0
  li x29, 0
  sw x0, (x0)

  # Store pte to signature
  lw t0, pte_sv32
  RVTEST_SIGUPD(x1,t0,offset)
  
#endif
  RVMODEL_HALT

  .align 2
  .global mtvec_handler
mtvec_handler:
  # Set D bit in pte_sv32 if requested in x29
  la t1, pte_sv32
  lw t0, (t1)
  or t0, t0, x29
  sw t0, (t1)
  sfence.vma
  # advanced pc if requested in x30
  csrr t0, mepc
  add t0, t0, x30
  csrw mepc, t0
  mret

RVTEST_CODE_END

RVTEST_DATA_BEGIN
  .data
  .align 12
  page:  .fill 4096, 1, 0

  .align 12
  pte_sv32: 
  .dword  PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A
RVTEST_DATA_END

# Output data section.
RVMODEL_DATA_BEGIN
rvtest_sig_begin:
sig_begin_canary:
CANARY;

signature_x1_0:
  .fill 64*(XLEN/32),4,0xdeadbeef

sig_end_canary:
CANARY;
rvtest_sig_end:
RVMODEL_DATA_END
