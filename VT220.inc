;===============================================================================
; VT220 Definitions
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
; 2013-01-14 AJ Initial version
;-------------------------------------------------------------------------------
; $Id: VT220.inc 30 2014-05-31 21:01:09Z andrew $
;-------------------------------------------------------------------------------

;===============================================================================
; Control Codes
;-------------------------------------------------------------------------------

        .equiv  NUL,            0x00
        .equiv  SOH,            0x01
        .equiv  STX,            0x02
        .equiv  ETX,            0x03
        .equiv  EOT,            0x04
        .equiv  ENQ,            0x05
        .equiv  ACK,            0x06
        .equiv  BEL,            0x07
        .equiv  BS,             0x08
        .equiv  HT,             0x09
        .equiv  LF,             0x0a
        .equiv  VT,             0x0b
        .equiv  FF,             0x0c
        .equiv  CR,             0x0d
        .equiv  SO,             0x0e
        .equiv  SI,             0x0f

        .equiv  DLE,            0x10
        .equiv  DC1,            0x11
        .equiv  DC2,            0x12
        .equiv  DC3,            0x13
        .equiv  DC4,            0x14
        .equiv  NAK,            0x15
        .equiv  SYN,            0x16
        .equiv  ETB,            0x17
        .equiv  CAN,            0x18
        .equiv  EM,             0x19
        .equiv  SUB,            0x1a
        .equiv  ESC,            0x1b
        .equiv  FS,             0x1c
        .equiv  GS,             0x1d
        .equiv  RS,             0x1e
        .equiv  US,             0x1f

        .equiv  DEL,            0x7f

        .equiv  IND,            0x84
        .equiv  NEL,            0x85
        .equiv  SSA,            0x86
        .equiv  ESA,            0x87
        .equiv  HTS,            0x88
        .equiv  HTJ,            0x89
        .equiv  VTS,            0x8a
        .equiv  PLD,            0x8b
        .equiv  PLU,            0x8c
        .equiv  RI,             0x8d
        .equiv  SS2,            0x8e
        .equiv  SS3,            0x8f

        .equiv  DCS,            0x90
        .equiv  PU1,            0x91
        .equiv  PU2,            0x92
        .equiv  STS,            0x93
        .equiv  CCH,            0x94
        .equiv  MW,             0x95
        .equiv  SPA,            0x96
        .equiv  EPA,            0x97
        .equiv  CSI,            0x9b
        .equiv  ST,             0x9c
        .equiv  OSC,            0x9d
        .equiv  PM,             0x9e
        .equiv  APC,            0x9f

;===============================================================================
; Constants
;-------------------------------------------------------------------------------

; The size of the visible area of the screen. An extra row is kept above or
; below the display for scrolling.

        .equiv  ROWS,           24
        .equiv  COLS,           80

; Each character in screen memory is represented by a 16 bit value with display
; attributes in the MSB and the character code in the LSB.
;
; Note that underscore will be treated as part of the character code (0-511)
; during pixel generation.

        .equiv  ATTR_FLASH,     15
        .equiv  ATTR_INVERT,    14
        .equiv  ATTR_BOLD,      12
        .equiv  ATTR_USCORE,     9

; Row types

        .equiv  TYPE_NORM,      0
        .equiv  TYPE_DOUB,      1
        .equiv  TYPE_DTOP,      2
        .equiv  TYPE_DBOT,      3

