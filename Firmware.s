;===============================================================================
; Power On Device Initialisation
;-------------------------------------------------------------------------------
; Copyright (C)2012-2013 HandCoded Software Ltd.
; All rights reserved.
;
; This software is the confidential and proprietary information of HandCoded
; Software Ltd. ("Confidential Information").  You shall not disclose such
; Confidential Information and shall use it only in accordance with the terms
; of the license agreement you entered into with HandCoded Software.
;
; HANDCODED SOFTWARE MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE
; SUITABILITY OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
; LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
; PARTICULAR PURPOSE, OR NON-INFRINGEMENT. HANDCODED SOFTWARE SHALL NOT BE
; LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING
; OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
;-------------------------------------------------------------------------------
;
; Notes:
;
;
;
;===============================================================================
; Revision History:
;
; 2012-12-31 AJ Initial version
;-------------------------------------------------------------------------------
; $Id: Firmware.s 25 2013-06-29 21:03:21Z andrew $
;-------------------------------------------------------------------------------

        .include "Hardware.inc"

;===============================================================================
; Fuse Configuration
;-------------------------------------------------------------------------------

        .ifdef  __24EP128GP202
        config __FGS, GCP_OFF & GWRP_OFF
        config __FOSCSEL, FNOSC_PRIPLL & IESO_OFF
        config __FOSC, POSCMD_HS & FCKSM_CSDCMD & OSCIOFNC_OFF
        config __FWDT, FWDTEN_OFF & WINDIS_OFF
        config __FPOR, ALTI2C1_OFF & ALTI2C2_OFF & WDTWIN_WIN25
        config __FICD, JTAGEN_OFF & ICS_PGD3
        .endif

;===============================================================================
; Data Areas
;-------------------------------------------------------------------------------

        .section nbss,bss,near
TASKSTK:
        .space  2                       ; Stack pointer for other stack

;===============================================================================
; Power On Reset
;-------------------------------------------------------------------------------

        .text
        .global __reset
        .extern KeybdSuspend
        .extern VideoInit
        .extern KeybdInit
        .extern Keyboard
        .extern Terminal
__reset:
        mov     #__SP_init,w15          ; Initialise the stack
        mov     #__SPLIM_init,w0
        mov     w0,SPLIM

;-------------------------------------------------------------------------------

        clr     ANSELA                  ; Turn off analog
        clr     ANSELB

        clr     LATA                    ; Clear output latches
        clr     LATB
        clr     R_SHADOW                ; Clear LATA shadow register
        mov     #INIT_TRISA,w0          ; Set pin directions
        mov     w0,TRISA        
        mov     #INIT_TRISB,w0
        mov     w0,TRISB

        bset    MODE_CNPU,#MODE_PIN     ; Enable pullup on MODE jumper

        bset    CLOCK_ODC,#CLOCK_PIN    ; Make keyboard pins open drain
        bset    DATA_ODC,#DATA_PIN

        bset    SYNC_LAT,#SYNC_PIN      ; Initialise SYNC signal HI

        rcall   KeybdSuspend            ; Suspend keyboard

;-------------------------------------------------------------------------------

        setm    PMD1                    ; Disable all peripherals
        setm    PMD2
        setm    PMD3

        bclr    PMD1,#T2MD              ; Enable Timer 2
        bclr    PMD1,#T4MD              ; Enable Timer 4
        bclr    PMD1,#T5MD              ; Enable Timer 5
        bclr    PMD1,#U1MD              ; Enable UART 1

;-------------------------------------------------------------------------------

; Change the oscillator to its operational speed

        bclr    CLKDIV,#PLLPRE0         ; Set PLLPRE = 2
        bclr    CLKDIV,#PLLPRE1
        bclr    CLKDIV,#PLLPRE2
        bclr    CLKDIV,#PLLPRE3
        bclr    CLKDIV,#PLLPRE4

        bclr    CLKDIV,#PLLPOST0        ; Set PLLPOST = 2
        bclr    CLKDIV,#PLLPOST1

        mov     #PLLDIV-2,w0            ; Set PLLDIV = 32
        mov     w0,PLLFBD

;-------------------------------------------------------------------------------
; Remap I/O pins to make required peripherals accessable

        mov     #OSCCON,w1
        mov     #0x46,w2
        mov     #0x57,w3
        mov.b   w2,[w1]
        mov.b   w3,[w1]
        bclr    OSCCON,#6


        .ifdef  __24EP128GP202
        mov     #RXD_RP,w2              ; Assign UART RX_
        mov     #RPINR18+0,w3
        mov.b   w2,[w3]

        mov     #PPSO_U1TX,w2
        mov     #RPOR2+0,w3
        mov.b   w2,[w3]
        .endif

        mov     #0x46,w2
        mov     #0x57,w3
        mov.b   w2,[w1]
        mov.b   w3,[w1]
        bset    OSCCON,#6

;-------------------------------------------------------------------------------

        rcall   VideoInit               ; Initialise video generation
        rcall   UartInit                ; And UART module
        rcall   KeybdInit               ; And PS/2 keyboard

        rcall   TaskInit                ; Set up task stacks
        bra     Keyboard                ; And start other tasks

;===============================================================================
; Task Switching
;-------------------------------------------------------------------------------

TaskInit:
        mov     w15,TASKSTK             ; Save the original stack frame
        mov     #128,w0                 ; Reserve a few bytes
        add     w15,w0,w15
        bra     Terminal                ; Then start 

; Swaps the stack pointer of the running task with the idle task and gives it a
; chance to run for a while.

        .global TaskSwap
TaskSwap:
        mov     TASKSTK,w0              ; Switch current and saved stack
        exch    w0,w15                  ; .. pointers
        mov     w0,TASKSTK
        return                          ; And go back

;===============================================================================
; Error Traps
;-------------------------------------------------------------------------------

        .global __OscillatorFail
__OscillatorFail:
        bra     $

        .global __AddressError
__AddressError:
        bra     $

        .global __HardTrapError
__HardTrapError:
        bra     $

        .global __StackError
__StackError:
        bra     $

        .global __SoftTrapError
__SoftTrapError:
        bra     $

        .end
