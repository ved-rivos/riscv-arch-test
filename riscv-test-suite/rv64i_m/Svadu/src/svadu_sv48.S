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
RVTEST_ISA("RV32I_Svadu")

# Test code region
.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
RVMODEL_BOOT
RVTEST_CODE_BEGIN

#ifdef TEST_CASE_1
  RVTEST_CASE(1,"//check ISA:=regex(.*64.*); check ISA:=regex(.*I.*); check ISA:=regex(.*Svadu.*); def TEST_CASE_1=True", svadu)

  RVTEST_SIGBASE(x1, signature_x1_0)

  # enable pmp to cover 4 GiB address space
  li t0, -1
  csrw pmpaddr0, t0
  li t0, PMP_TOR | PMP_X | PMP_W | PMP_R
  csrw pmpcfg0, t0

  # enable vm in sv48 mode
  li t1, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV48
  la t0, sv48_level_3
  srli t0, t0, RISCV_PGSHIFT
  or t0, t0, t1
  csrw satp, t0
  sfence.vma

  # setup trap handler
  la t0, mtvec_handler
  csrw mtvec, t0

  # setup non-leaf ptes
  la t0, sv48_level_2
  srli t0, t0, RISCV_PGSHIFT
  slli t0, t0, PTE_PPN_SHIFT
  or t0, t0, PTE_V
  la t1, sv48_level_3
  sd t0, (t1)

  la t0, sv48_level_1
  srli t0, t0, RISCV_PGSHIFT
  slli t0, t0, PTE_PPN_SHIFT
  or t0, t0, PTE_V
  la t1, sv48_level_2
  sd t0, (t1)

  la t0, sv48_level_0
  srli t0, t0, RISCV_PGSHIFT
  slli t0, t0, PTE_PPN_SHIFT
  or t0, t0, PTE_V
  la t1, sv48_level_1
  sd t0, (t1)

  # setup up a leaf-pte mapping va:0 -> page_4k
  la t0, page_4k
  srli t0, t0, RISCV_PGSHIFT
  slli t0, t0, PTE_PPN_SHIFT
  ori t0, t0, PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A
  la t1, sv48_level_0
  sd t0, (t1)

  # Set up MPRV with MPP=S, so loads and stores use S-mode
  li t0, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_MPRV
  csrs mstatus, t0

  # Store 0 to va 0 to test a fault (SUM is 0)
  # Skip instruction after fault, dont set A/D bits
  li a0, 4
  li a1, PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A
  sw x0, (x0)

  # clear MPRV
  li t0, MSTATUS_MPRV
  csrc mstatus, t0

  # Store pte to signature
  la t0, sv48_level_0
  ld t0, (t0)
  RVTEST_SIGUPD(x1,t0,offset)

  # Set SUM=1, MPRV=1, reset MPP to S
  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_SUM | MSTATUS_MPRV
  csrs mstatus, a1

  # store to va 0 - should cause page fault due to A=D=0
  # request trap handler to set A=D=1 and retry
  # no page fault should occur on retry 
  li a0, 0
  li a1, PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A | PTE_D
  sw x0, (x0)

  # clear MPRV
  li t0, MSTATUS_MPRV
  csrc mstatus, t0

  # Store pte to signature
  la t0, sv48_level_0
  ld t0, (t0)
  RVTEST_SIGUPD(x1,t0,offset)

  # Clear A/D bits from PTE
  la t0, sv48_level_0
  ld t0, (t0)
  li t1, PTE_A | PTE_D
  not t1, t1
  and t1, t2, t1
  sd t1, (t0)

  # Set MPRV=1
  li t0, MSTATUS_MPRV
  csrs mstatus, t0

  # set HADE to enable HW A/D updating
#if __riscv_xlen == 64
  li t0, MENVCFG_HADE
  csrs 0x30a, t0
#else
  li t0, MENVCFGH_HADE
  csrs 0x31a, t0
#endif

  # store to va 0 - should not cause page fault due to A=D=0
  li a0, 0
  li a1, 0
  sw x0, (x0)

  # clear MPRV
  li t0, MSTATUS_MPRV
  csrc mstatus, t0

  # Store pte to signature
  la t0, sv48_level_0
  ld t0, (t0)
  RVTEST_SIGUPD(x1,t0,offset)

  RVMODEL_HALT

  .align 2
  .global mtvec_handler
mtvec_handler:
  # update PTE as requested in a1
  la t1, sv48_level_0
  ld t0, (t1)
  or t0, t0, a1
  sd t0, (t1)
  # reset MPP to S-mode
  li t0, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_M)
  csrc mstatus, t0
  # advanced pc if requested in x30
  csrr t0, mepc
  add t0, t0, a0
  sfence.vma
  jr t0
#endif
RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END
  .align 12
  sv48_level_3:
  .fill   4096/REGWIDTH, REGWIDTH, PTE_V
  .align 12
  sv48_level_2:
  .fill   4096/REGWIDTH, REGWIDTH, PTE_V
  sv48_level_1:
  .fill   4096/REGWIDTH, REGWIDTH, PTE_V
  sv48_level_0:
  .fill   4096/REGWIDTH, REGWIDTH, PTE_V | PTE_U | PTE_R | PTE_W | PTE_X | PTE_A
  .align 12
   page_4k:
  .fill   4096/REGWIDTH, REGWIDTH, 0

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
