;===============================================================================
; Peripheral Pin Select 
;-------------------------------------------------------------------------------
; Copyright (C)2012 HandCoded Software Ltd.
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
;===============================================================================
; Revision History:
;
; 2012-06-26 AJ Initial version
;-------------------------------------------------------------------------------
; $Id: PinSelect.inc 13 2013-01-17 20:33:00Z andrew $
;-------------------------------------------------------------------------------

;===============================================================================
; Macros
;-------------------------------------------------------------------------------

; Generates the code to unlock the peripheral pin select control registers so
; the function of the I/O pins can be changed.

        .macro  PPS_UNLOCK
        mov     #OSCCON,w1
        mov     #0x46,w2
        mov     #0x57,w3
        mov.b   w2,[w1]
        mov.b   w3,[w1]
        bclr    OSCCON,#6
        .endm

; Generates the code lock the peripheral pin select control registers.

        .macro  PPS_LOCK
        mov     #0x46,w2
        mov     #0x57,w3
        mov.b   w2,[w1]
        mov.b   w3,[w1]
        bset    OSCCON,#6
        .endm

;-------------------------------------------------------------------------------

        .equiv  PPSI_INT1,      1
        .equiv  PPSI_INT2,      2
        .equiv  PPSI_INT3,      3
        .equiv  PPSI_INT4,      4
        .equiv  PPSI_T2CK,      6
        .equiv  PPSI_T3CK,      7
        .equiv  PPSI_T4CK,      8
        .equiv  PPSI_T5CK,      9
        .equiv  PPSI_IC1,       14
        .equiv  PPSI_IC2,       15
        .equiv  PPSI_IC3,       16
        .equiv  PPSI_IC4,       17
        .equiv  PPSI_IC5,       18
        .equiv  PPSI_IC6,       19
        .equiv  PPSI_IC7,       20
        .equiv  PPSI_IC8,       21
        .equiv  PPSI_OCFA,      22
        .equiv  PPSI_OCFB,      23
        .equiv  PPSI_IC9,       31
        .equiv  PPSI_U3RX,      35
        .equiv  PPSI_U1RX,      36
        .equiv  PPSI_U1CTS,     37
        .equiv  PPSI_U2RX,      38
        .equiv  PPSI_U2CTS,     39
        .equiv  PPSI_SDI1,      40
        .equiv  PPSI_SCK1,      41
        .equiv  PPSI_SS1,       42
        .equiv  PPSI_U3CTS,     43
        .equiv  PPSI_SDI2,      44
        .equiv  PPSI_SCK2,      45
        .equiv  PPSI_SS2,       46
        .equiv  PPSI_U4RX,      54
        .equiv  PPSI_U4CTS,     55
        .equiv  PPSI_SDI3,      56
        .equiv  PPSI_SCK3,      57
        .equiv  PPSI_SS3,       58

; Generates the code to assign the indicated function to the indicated input
; pin.

        .macro PPS_IN,FUNC,PIN
        mov     #\PIN,w2
        mov     #RPINR0+\FUNC,w3
        mov.b   w2,[w3]
        .endm

;-------------------------------------------------------------------------------

        .equiv  PPSO_NULL,      0
        .equiv  PPSO_C1OUT,     1
        .equiv  PPSO_C2OUT,     2
        .equiv  PPSO_U1TX,      3
        .equiv  PPSO_U1RTS,     4
        .equiv  PPSO_U2TX,      5
        .equiv  PPSO_U2RTS,     6
        .equiv  PPSO_SDO1,      7
        .equiv  PPSO_SCK1,      8
        .equiv  PPSO_SS1,       9
        .equiv  PPSO_SDO2,      10
        .equiv  PPSO_SCK2,      11
        .equiv  PPSO_SS2,       12
        .equiv  PPSO_OC1,       18
        .equiv  PPSO_OC2,       19
        .equiv  PPSO_OC3,       20
        .equiv  PPSO_OC4,       21
        .equiv  PPSO_OC5,       22
        .equiv  PPSO_OC6,       23
        .equiv  PPSO_OC7,       24
        .equiv  PPSO_OC8,       25
        .equiv  PPSO_U3TX,      28
        .equiv  PPSO_U3RTS,     29
        .equiv  PPSO_U4TX,      30
        .equiv  PPSO_U4RTS,     31
        .equiv  PPSO_SDO3,      32
        .equiv  PPSO_SCK3,      33
        .equiv  PPSO_SS3OUT,    34
        .equiv  PPSO_OC9,       35
        .equiv  PPSO_C3OUT,     36

; Generates the code to assign the indicated function to the indicated output
; pin.

        .macro PPS_OUT,FUNC,PIN
        mov     #\FUNC,w2
        mov     #RPOR0+\PIN,w3
        mov.b   w2,[w3]
        .endm
