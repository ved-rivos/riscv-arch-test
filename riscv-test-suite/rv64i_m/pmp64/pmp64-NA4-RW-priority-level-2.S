// -----------
// Copyright (c) 2020. RISC-V International. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// -----------
//
// This test belongs to the test plan for RISC-V Privilege Arch Compliance developed by 10xEngineers
// which can be found here: https://docs.google.com/spreadsheets/d/1p13gic7BD6aq7n_dHrqti4QmlGpxY7FkF17RVbG4DC0/edit?usp=sharing
/*	Test Name: pmp-TOR-priority-rw-level-2.S
// Tests the priority by assigning only R,W permissions to the highest priority while no permissions to high priority region and R-W-X to low priority region
// coverpoint definitions are given in coverage/pmp32_translated_coverpoints.cgf or coverage/pmp32_coverpoint_def_format.cgf
*/

#include "model_test.h"
#include "arch_test.h"
RVTEST_ISA("RV64I_Zicsr")
# Test code region
.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
RVMODEL_BOOT
RVTEST_CODE_BEGIN

#ifdef TEST_CASE_1
    RVTEST_CASE(1,"//check ISA:=regex(.*64.*); check ISA:=regex(.*I.*Zicsr.*); def rvtest_mtrap_routine=True; def rvtest_strap_routine=True; def TEST_CASE_1=True; mac PMP_MACROS; mac PMP_helper_Coverpoints",PMP_NA4_priority_rw_level_2)
RVTEST_SIGBASE( x13,signature_x13_1)

	.attribute unaligned_access, 0
	.attribute stack_align, 16
  	.align	3
  	.option norvc 
#define PMPCFG0		0x3A0		// Address of pmpcfg0 	(HAS BEEN USED WHILE ITERATING THE LOOP)
#define PMPADDR0	0x3B0		// Address of pmpaddr0 	(HAS BEEN USED WHILE ITERATING THE LOOP)
/* Define PMP Configuration Fields */
#define PMP0_CFG_SHIFT  0
#define PMP1_CFG_SHIFT  8
#define PMP2_CFG_SHIFT  16
#define PMP3_CFG_SHIFT  24
#define PMP7_CFG_SHIFT  56
#define NOP 		0x13
.macro VERIFICATION_RWX		ADDRESS	
   	LA(a5, \ADDRESS)	// Fetch the address to be checked
		LI(a4, 	NOP)		// Load the new value (NOP Instruction ID)
		sb	a4,0(a5)	// Store the new value (NOT TRAP => W enabled)
		nop
		nop
		sh	a4,0(a5)	// store data
		nop
		nop
		sw	a4,0(a5)	// Load data from it (CHECK FOR READ) ; (NOT TRAP => W enabled)
		nop
		nop
		sd	a4,0(a5)	// Load data from it (CHECK FOR READ) ; (NOT TRAP => W enabled)
		nop
		nop
 	  	lb	a4,0(a5)	// Load data from it (CHECK FOR READ) ; (NOT TRAP => W enabled)
    	nop
    	nop
		RVTEST_SIGUPD(x13,a4)															//verify that the data is stored successfuly
    	lh	a4,0(a5)	// Load data from it (CHECK FOR READ) ; (NOT TRAP => W enabled)
    	nop
    	nop
		RVTEST_SIGUPD(x13,a4)
    	lw	a4,0(a5)	// Load data from it (CHECK FOR READ) ; (NOT TRAP => W enabled)
    	nop
    	nop
    	ld	a4,0(a5)	// Load data from it (CHECK FOR READ) ; (NOT TRAP => W enabled)
    	nop
    	nop
		RVTEST_SIGUPD(x13,a4)
		jal	\ADDRESS	// Test for execution, an instruction is placed at this address
		nop
		nop
jal	\ADDRESS	// Test for execution, an instruction is placed at this address 

.endm

main:
//////////////////////// INITIAL VALUES //////////////////////////////// 
    	LI(a5, -1)		// SEtting up All locked bits (including everyother non-zero bit, which is redundent for this test)
    	LI(x5, 100)		// A rondom number, to check if pmp regs get update after lock bit enable
	// Loop to SET ALL pmpcfg REGs to zero
	.set pmpcfgi, PMPCFG0	// Initialize an iterating variable with the address of pmpcfg0
	.rept 2			// START OF LOOP

	csrw pmpcfgi , x0	// Set all pmpcfg regs to zero (initial value)
	.set pmpcfgi, pmpcfgi+2		// increment variable to next pmpcfg reg	
	.endr			// END OF LOOP BODY
	// Loop to SET ALL pmpaddr REGs to zero
	.set pmpaddri, PMPADDR0	// Initialize an iterating variable with the address of pmpaddr0
	.rept 16		// START OF LOOP
	csrw pmpaddri, x0	// Set all pmpaddr regs to zero (initial value)
	.set pmpaddri, pmpaddri+1		// increment variable pmpaddri to the next pmpaddr reg
	.endr			// END OF LOOP BODY
		
// pmpcfg2 [63:56] value to configure address 0->PMP_region_High in TOR Mode with RWX enabled. This is the low priority region
#define PMPREGION1      ((((PMP_R|PMP_W|PMP_X|PMP_L|PMP_TOR)&0xFF) << PMP7_CFG_SHIFT))
// ------------------------------------------------------------------------------------------------
// pmpcfg0[31:24] value to configure address (RAM_LOCATION_FOR_TEST)->(RETURN_INSTRUCTION). This is the high priority region
// in TOR Mode with nothing enabled
// THIS REGION CONSISTS OF ONLY ONE INSTRUCTION
#define PMPREGION2      ((((PMP_L|PMP_TOR)&0xFF) << PMP3_CFG_SHIFT))
// ------------------------------------------------------------------------------------------------
// pmpcfg0[15:8] value to configure address (TEST_FOR_EXECUTION). This is the high priority region
// in TOR Mode with R enabled =========> THIS IS OUR REGION UNDER OBSERVATION.
// THIS REGION CONSISTS OF ONLY ONE INSTRUCTION
#define PMPREGION3      ((((PMP_R|PMP_W|PMP_L|PMP_NA4)&0xFF) << PMP1_CFG_SHIFT))
// ------------------------------------------------------------------------------------------------
// MACROS TO DECLARE THE VALUES TO BE STORED IN PMPADDR registers
// PMPADDRESS14 = value to be loaded pmpaddr14 to declare lower address of Region-1
#define PMPADDRESS14	0x80000000 		// value to be loaded pmpaddr14 to declare region1
// PMPADDRESS15 = value to be loaded pmpaddr15 to declare upper address of Region-1
#define PMPADDRESS15	PMP_region_High	
// PMPADDRESS2 = value to be loaded pmpaddr2 to declare lower address of Region-2
#define PMPADDRESS2	RAM_LOCATION_FOR_TEST	
// PMPADDRESS3 = value to be loaded pmpaddr3 to declare upper address of Region-2
#define PMPADDRESS3	RETURN_INSTRUCTION
// PMPADDRESS3 = value to be loaded pmpaddr1 to declare upper address of Region-3
#define PMPADDRESS1	TEST_FOR_EXECUTION
                                                                  
    /* SET UP DATA IN THE MEMORY */
	csrw satp, x0			// Disable Address Translation
// PMP Configuration
    /* Assigning addresses to PMP address registers */
    	LI(x4, PMPADDRESS14)		// Value to be stored in pmpaddr14
	srl x4, x4, PMP_SHIFT		// Shift right by 2 times
	csrw 	pmpaddr14, x4		// Updated pmpaddr14
	nop				// Added nop in case of trap
    	LA(x4, PMPADDRESS15)		// Value to be stored in pmpaddr15
	srl x4, x4, PMP_SHIFT		// Shift right by 2 times
	csrw 	pmpaddr15, x4		// Updated pmpaddr15
	nop				// Added nop in case of trap
    	LA(x4, PMPADDRESS2)		// Value to be stored in pmpaddr2
	srl x4, x4, PMP_SHIFT		// Shift right by 2 times
	csrw 	pmpaddr2, x4		// Updated pmpaddr2
	nop				// Added nop in case of trap
    	LA(x4, PMPADDRESS3)		// Value to be stored in pmpaddr3
	srl x4, x4, PMP_SHIFT		// Shift right by 2 times
	csrw 	pmpaddr3, x4		// Updated pmpaddr3
	nop				// Added nop in case of trap
    	LA(x4, PMPADDRESS1)		// Value to be stored in pmpaddr1
	srl x4, x4, PMP_SHIFT		// Shift right by 2 times
	csrw 	pmpaddr1, x4		// Updated pmpaddr1
	nop				// Added nop in case of trap
    /* Decalring pmp configuration register */
	LI(x4, PMPREGION1)	
	// Value to be stored in pmpcfg register
	csrs pmpcfg2, x4		// Updated pmpcfg2
	nop				// Added nop in case of trap
	LI(x4, PMPREGION2)	
	// Value to be stored in pmpcfg1 register
	csrs pmpcfg0, x4		// Updated pmpcfg0
	nop				// Added nop in case of trap
	LI(x4, PMPREGION3)	
	// Value to be stored in pmpcfg register
	csrs pmpcfg0, x4		// Updated pmpcfg0
	nop				// Added nop in case of trap
//////////// ALL PMP REGIONS DECLARED //////////////////////////////////////////////
    /* VERIFICATION in M-mode  */    
	VERIFICATION_RWX	TEST_FOR_EXECUTION	
// VERIFICATION IN S-Mode	
	RVTEST_GOTO_LOWER_MODE	Smode		// SWITCH TO S-mode
	VERIFICATION_RWX	TEST_FOR_EXECUTION	

/////////////////// Switch back to M-mode ////////////////////////////////////////////
	RVTEST_GOTO_MMODE
  	csrr a4, mstatus		// VERIFICATION of M-mode
	nop				// Added nop in case of trap
// VERIFICATION IN U-Mode
	RVTEST_GOTO_LOWER_MODE	Umode		// SWITCH TO U-mode
	VERIFICATION_RWX	TEST_FOR_EXECUTION	
	j exit

RAM_LOCATION_FOR_TEST:
	.fill 0*(XLEN/32),4,NOP
  	.align	3

TEST_FOR_EXECUTION:
	addi x9,x9,0x01		// A TEST INSTRUCTION TO TEST THE EXECUTION CHECK ON PMP REGION
	nop
RETURN_INSTRUCTION:
	nop				// Added nop in case of trap
	nop				// Added nop in case of trap
	nop				// Added nop in case of trap
	nop				// Added nop in case of trap
	jr ra			
// AN instruction to bring back PC to the address where TEST_FOR_EXECUTION was called to check for execution.
exit:
#endif
 # ---------------------------------------------------------------------------------------------
    # HALT
RVTEST_CODE_END
RVMODEL_HALT
RVTEST_DATA_BEGIN
.align 4

rvtest_data:
.word 0xbabecafe
.word 0xbabecafe
.word 0xbabecafe
.word 0xbabecafe
RVTEST_DATA_END


RVMODEL_DATA_BEGIN
rvtest_sig_begin:
sig_begin_canary:
CANARY;
signature_x13_1:
    .fill 32*(XLEN/32),4,0xdeadbeef

#ifdef rvtest_mtrap_routine

tsig_begin_canary:
CANARY;
mtrap_sigptr:
    .fill 128*(XLEN/32),4,0xdeadbeef
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
PMP_region_High:
RVMODEL_DATA_END
