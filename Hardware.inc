;===============================================================================
; Hardware Configuration
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
; $Id: Hardware.inc 25 2013-06-29 21:03:21Z andrew $
;-------------------------------------------------------------------------------

        .ifdef __24EP128GP202
        .include "P24EP128GP202.inc"

        .equiv  PLLPRE,         2
        .equiv  PLLDIV,         60
        .equiv  PLLPOST,        2
        .endif

;===============================================================================
; Oscillator
;-------------------------------------------------------------------------------

; Derive the operating clock frequency once the PLL is configured

        .equiv  OSC_HZ,         10000000
        .equiv  FOSC,           (OSC_HZ * PLLDIV) / (PLLPRE * PLLPOST)

;===============================================================================
; Timers
;-------------------------------------------------------------------------------

; Timer 2 is used to create a regular interrupt every 32uSec to drive the video
; signals.

        .equiv  PAL_HZ,         625 * 50
        .equiv  NTSC_HZ,        525 * 60
        .equiv  TMR2_PRE,       1
        .equiv  PAL_PERIOD,    FOSC / (2 * PAL_HZ  * TMR2_PRE)
        .equiv  NTSC_PERIOD,   FOSC / (2 * NTSC_HZ * TMR2_PRE)

;-------------------------------------------------------------------------------

; Timers 4 & 5 create an 8Hz interrupt used to for character flashing and screen
; scrolling.

        .equiv  TMR4_HZ,        8
        .equiv  TMR4_PRE,       1
        .equiv  TMR4_PERIOD,    FOSC / (2 * TMR4_HZ * TMR4_PRE)

        .equiv  TMR4_PERIOD_LSW, ((TMR4_PERIOD - 1) >>  0) & 0xffff
        .equiv  TMR5_PERIOD_MSW, ((TMR4_PERIOD - 1) >> 16) & 0xffff

;===============================================================================
; UART
;-------------------------------------------------------------------------------

        .equiv  BRG_300,        FOSC / (2 * 4 *    300) - 1
        .equiv  BRG_600,        FOSC / (2 * 4 *    600) - 1
        .equiv  BRG_1200,       FOSC / (2 * 4 *   1200) - 1
        .equiv  BRG_2400,       FOSC / (2 * 4 *   2400) - 1
        .equiv  BRG_4800,       FOSC / (2 * 4 *   4800) - 1
        .equiv  BRG_9600,       FOSC / (2 * 4 *   9600) - 1
        .equiv  BRG_14400,      FOSC / (2 * 4 *  14400) - 1
        .equiv  BRG_19200,      FOSC / (2 * 4 *  19200) - 1
        .equiv  BRG_28800,      FOSC / (2 * 4 *  28800) - 1
        .equiv  BRG_38400,      FOSC / (2 * 4 *  38400) - 1
        .equiv  BRG_57600,      FOSC / (2 * 4 *  57600) - 1
        .equiv  BRG_115200,     FOSC / (2 * 4 * 115200) - 1

;===============================================================================
; I/O Pins
;-------------------------------------------------------------------------------

; The following three pins are used to generate the video signals 

        .equiv  BOLD_PIN,       0
        .equiv  BOLD_LAT,       LATA
        .equiv  BOLD_TRIS,      TRISA

        .equiv  NORM_PIN,       1
        .equiv  NORM_LAT,       LATA
        .equiv  NORM_TRIS,      TRISA

        .equiv  SYNC_PIN,       2
        .equiv  SYNC_LAT,       LATB
        .equiv  SYNC_TRIS,      TRISB

;-------------------------------------------------------------------------------

; The mode pin is used to find out if a PAL or NTSC signal is required

        .equiv  MODE_PIN,       12
        .equiv  MODE_PORT,      PORTB
        .equiv  MODE_TRIS,      TRISB
        .equiv  MODE_CNPU,      CNPUB

;-------------------------------------------------------------------------------

        .equiv  RXD_PIN,        5
        .equiv  RXD_PORT,       PORTB
        .equiv  RXD_TRIS,       TRISB
        .equiv  RXD_RP,         37

        .equiv  TXD_PIN,        6
        .equiv  TXD_PORT,       LATB
        .equiv  TXD_TRIS,       TRISB
        .equiv  TXD_RP,         38

        .equiv  PPSO_U1TX,      0x01

;------------------------------------------------------------------------------

        .equiv  CLOCK_PIN,      13
        .equiv  CLOCK_LAT,      LATB
        .equiv  CLOCK_PORT,     PORTB
        .equiv  CLOCK_TRIS,     TRISB
        .equiv  CLOCK_ODC,      ODCB
        .equiv  CLOCK_CNEN,     CNENB

        .equiv  DATA_PIN,       14
        .equiv  DATA_LAT,       LATB
        .equiv  DATA_PORT,      PORTB
        .equiv  DATA_TRIS,      TRISB
        .equiv  DATA_ODC,       ODCB

;-------------------------------------------------------------------------------

        .equiv  INIT_TRISA,     0
        .equiv  INIT_TRISB,     (1<<MODE_PIN)|(1<<RXD_PIN)|(1<<CLOCK_PIN)|(1<<DATA_PIN)

;===============================================================================
; Permanent Register Assignments
;-------------------------------------------------------------------------------

; Some registers are used to hold values that must remain constant at all times
; to minimise the time needed to change the video pins.

        .equiv  R_SHADOW,       w14     ; Shadow register for LATA
