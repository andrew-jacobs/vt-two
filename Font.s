;===============================================================================
; VT220 Font
;-------------------------------------------------------------------------------
; Copyright (C)2012-2014 HandCoded Software Ltd.
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
; $Id$
;-------------------------------------------------------------------------------

        .include "Hardware.inc"
        .include "VT220.inc"

;===============================================================================
; 8x10 Font Glyphs
;-------------------------------------------------------------------------------

        .section .font,psv,align(256)

        .global FontData
FontData:
        .byte   0b00000000              ; 000 - Space
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 001 - Diamond
        .byte   0b00010000
        .byte   0b00111000
        .byte   0b01111100
        .byte   0b11111110
        .byte   0b01111100
        .byte   0b00111000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 002 - Pattern
        .byte   0b10010010
        .byte   0b01000100
        .byte   0b10010010
        .byte   0b01000100
        .byte   0b10010010
        .byte   0b01000100
        .byte   0b10010010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 003 - HT
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10111110
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000	

        .byte   0b00000000              ; 004 - FF
        .byte   0b11110000
        .byte   0b10000000
        .byte   0b11100000
        .byte   0b10000000
        .byte   0b10011110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 005 - CR
        .byte   0b01110000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00010010
        .byte   0b00011100
        .byte   0b00010010
        .byte   0b00010010

        .byte   0b00000000              ; 006 - LF
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 007 - Degree
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 008 - Plus/Minus
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 009 - NL
        .byte   0b10001000
        .byte   0b11001000
        .byte   0b10101000
        .byte   0b10011000
        .byte   0b00011000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00011110

        .byte   0b00000000              ; 00A - VT
        .byte   0b10001000
        .byte   0b10001000
        .byte   0b01010000
        .byte   0b01010000
        .byte   0b00111110
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000

        .byte   0b00010000              ; 00B - NW
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11110000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 00C - SW
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 00D - SE
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00011111
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00010000              ; 00E - NE
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00011111
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00010000              ; 00F - NESW
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111111
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b11111111              ; 010 - Row 0
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 011 - Row 2
        .byte   0b00000000
        .byte   0b11111111
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 012 - Row 4
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111111
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 013 - Row 6
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111111
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 014 - Row 7
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111111
        .byte   0b00000000

        .byte   0b00010000              ; 015 - NES
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00011111
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00010000              ; 016 - NSW
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00010000              ; 017 - NEW
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111111
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 018 - ESW
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111111
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00010000              ; 019 - NS
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 01A - LTE
        .byte   0b00000010
        .byte   0b00001000
        .byte   0b00100000
        .byte   0b10000000
        .byte   0b00100000
        .byte   0b00001000
        .byte   0b00000010
        .byte   0b11111110
        .byte   0b00000000

        .byte   0b00000000              ; 01B - GTE
        .byte   0b10000000
        .byte   0b00100000
        .byte   0b00001000
        .byte   0b00000010
        .byte   0b00001000
        .byte   0b00100000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000

        .byte   0b00000000              ; 01C - Pi
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00100100
        .byte   0b00100100
        .byte   0b00100100
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 01D - NE
        .byte   0b00000010
        .byte   0b00000100
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b01000000
        .byte   0b10000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 01E - £
        .byte   0b00011100
        .byte   0b00100010
        .byte   0b00100000
        .byte   0b11111000
        .byte   0b00100000
        .byte   0b01111000
        .byte   0b10100110
        .byte   0b01000000
        .byte   0b00000000

        .byte   0b00000000              ; 01F - Centre Dot
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 020 - Flipped ?
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b01100000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 021 - !
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 022 - "
        .byte   0b01001000
        .byte   0b01001000
        .byte   0b01001000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 023 - #
        .byte   0b01001000
        .byte   0b01001000
        .byte   0b11111100
        .byte   0b01001000
        .byte   0b11111100
        .byte   0b01001000
        .byte   0b01001000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 024 - $
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b10010000
        .byte   0b01111100
        .byte   0b00010010
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 025 - %
        .byte   0b01000010
        .byte   0b10100100
        .byte   0b01001000
        .byte   0b00010000
        .byte   0b00100100
        .byte   0b01001010
        .byte   0b10000100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 026 - &
        .byte   0b01110000
        .byte   0b10001000
        .byte   0b10001000
        .byte   0b01110000
        .byte   0b10001010
        .byte   0b10000100
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 027 - '
        .byte   0b00011000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 028 - (
        .byte   0b00001000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00010000
        .byte   0b00001000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 029 - )
        .byte   0b00100000
        .byte   0b00010000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 02A - *
        .byte   0b00000000
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b11111110
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 02B - +
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 02C - ,
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00100000
        .byte   0b01000000
        .byte   0b00000000

        .byte   0b00000000              ; 02D - -
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 02E -  .
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00110000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 02F - /
        .byte   0b00000010
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b01000000
        .byte   0b10000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 030 - 0
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 031 - 1
        .byte   0b00010000
        .byte   0b00110000
        .byte   0b01010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 032 - 2
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b00000010
        .byte   0b00011100
        .byte   0b01100000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 033 - 3
        .byte   0b11111110
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00011100
        .byte   0b00000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 034 - 4
        .byte   0b00001000
        .byte   0b00011000
        .byte   0b00101000
        .byte   0b01001000
        .byte   0b11111110
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 035 - 5
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b00000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 036 - 6
        .byte   0b00111100
        .byte   0b01000000
        .byte   0b10000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 037 - 7
        .byte   0b11111110
        .byte   0b00000010
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 038 - 8
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 039 - 9
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000010
        .byte   0b00000100
        .byte   0b01111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 03A - :
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00110000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00110000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 03B - ;
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00110000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00100000
        .byte   0b01000000
        .byte   0b00000000

        .byte   0b00000000              ; 03C - <
        .byte   0b00000010
        .byte   0b00001000
        .byte   0b00100000
        .byte   0b10000000
        .byte   0b00100000
        .byte   0b00001000
        .byte   0b00000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 03D - =
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 03E = >
        .byte   0b10000000
        .byte   0b00100000
        .byte   0b00001000
        .byte   0b00000010
        .byte   0b00001000
        .byte   0b00100000
        .byte   0b10000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 03F - ?
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b00001100
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 040 - @
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10011110
        .byte   0b10100110
        .byte   0b10011010
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 041 - A
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 042 - B
        .byte   0b11111100
        .byte   0b01000010
        .byte   0b01000010
        .byte   0b01111100
        .byte   0b01000010
        .byte   0b01000010
        .byte   0b11111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 043 - C
        .byte   0b00111100
        .byte   0b01000010
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b01000010
        .byte   0b00111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 044 - D
        .byte   0b11111000
        .byte   0b01000100
        .byte   0b01000010
        .byte   0b01000010
        .byte   0b01000010
        .byte   0b01000100
        .byte   0b11111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 045 - E
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 046 - F
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 047 - G
        .byte   0b00111100
        .byte   0b01000010
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10001110
        .byte   0b01000010
        .byte   0b00111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 048 - H
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 049 - I
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 04A - J
        .byte   0b00001110
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b10000100
        .byte   0b01111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 04B - K
        .byte   0b10000010
        .byte   0b10001100
        .byte   0b10110000
        .byte   0b11000000
        .byte   0b10110000
        .byte   0b10001100
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 04C - L
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 04D - M
        .byte   0b10000010
        .byte   0b11000110
        .byte   0b10101010
        .byte   0b10010010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 04E - N
        .byte   0b10000010
        .byte   0b11000010
        .byte   0b10100010
        .byte   0b10010010
        .byte   0b10001010
        .byte   0b10000110
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 04F - O
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 050 - P
        .byte   0b11111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b11111100
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 051 - Q
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10001010
        .byte   0b10000100
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 052 - R
        .byte   0b11111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b11111100
        .byte   0b10001000
        .byte   0b10000100
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 053 - S
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 054 - T
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 055 - U
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 056 - V
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b00101000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 057 - W
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10010010
        .byte   0b10010010
        .byte   0b10101010
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 058 - X
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 059 - Y
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 05A - Z
        .byte   0b11111110
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b01000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 05B - [
        .byte   0b00111100
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 05C - \
        .byte   0b10000000
        .byte   0b01000000
        .byte   0b00100000
        .byte   0b00010000
        .byte   0b00001000
        .byte   0b00000100
        .byte   0b00000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 05D - ]
        .byte   0b01111000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b00001000
        .byte   0b01111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 05E - ^
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 05F - _
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 060 - '
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00001000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 061 - a
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 062 - b
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b10000010
        .byte   0b11000010
        .byte   0b10111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 063 - c
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b01111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 064 - d
        .byte   0b00000010
        .byte   0b00000010
        .byte   0b01111010
        .byte   0b10000110
        .byte   0b10000010
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 065 - e
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 066 - f
        .byte   0b00011100
        .byte   0b00100010
        .byte   0b00100000
        .byte   0b11111000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 067 - g
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111010
        .byte   0b10000100
        .byte   0b01111000
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b01111100

        .byte   0b00000000              ; 068 - h
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 069 - i
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 06a - j
        .byte   0b00000100
        .byte   0b00000000
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b10000100
        .byte   0b10000100
        .byte   0b01111000

        .byte   0b00000000              ; 06b - k
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10001000
        .byte   0b10010000
        .byte   0b11100000
        .byte   0b10011000
        .byte   0b10000100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 06c - l
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 06d - m
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11000100
        .byte   0b10101010
        .byte   0b10010010
        .byte   0b10010010
        .byte   0b10010010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 06e - n
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 06f - o
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 070 - p
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b11000010
        .byte   0b10111100
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000

        .byte   0b00000000              ; 071 - q
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111010
        .byte   0b10000110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000010
        .byte   0b00000010
        .byte   0b00000010

        .byte   0b00000000              ; 072 - r
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10011100
        .byte   0b01100010
        .byte   0b01000000
        .byte   0b01000000
        .byte   0b01000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 073 - s
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b11111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 074 - t
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b11111000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100100
        .byte   0b00011000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 075 - u
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10000100
        .byte   0b10000100
        .byte   0b10000100
        .byte   0b10000100
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 076 - v
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 077 - w
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10010010
        .byte   0b10101010
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 078 - x
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10000100
        .byte   0b01001000
        .byte   0b00110000
        .byte   0b01001000
        .byte   0b10000100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 079 - y
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b10000100
        .byte   0b10000100
        .byte   0b10001100
        .byte   0b01110100
        .byte   0b00000100
        .byte   0b10000100
        .byte   0b01111000

        .byte   0b00000000              ; 07a - z
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000100
        .byte   0b00011000
        .byte   0b00100000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 07b - {
        .byte   0b00001110
        .byte   0b00010000
        .byte   0b00001000
        .byte   0b00110000
        .byte   0b00001000
        .byte   0b00010000
        .byte   0b00001110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 07c - |
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 07d - }
        .byte   0b11100000
        .byte   0b00010000
        .byte   0b00100000
        .byte   0b00011000
        .byte   0b00100000
        .byte   0b00010000
        .byte   0b11100000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 07e - ~
        .byte   0b01100010
        .byte   0b10010010
        .byte   0b10001100
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 07f - DEL
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b11111000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b00100000

        .byte   0b00000000              ; 080 - 80
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01101100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 081 - 81
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100100
        .byte   0b00001100
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b00001110

        .byte   0b00000000              ; 082 - 82
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01101100
        .byte   0b00010010
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00011110

        .byte   0b00000000              ; 083 - 83
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111110
        .byte   0b00000010
        .byte   0b00001100
        .byte   0b00000010
        .byte   0b00011100

        .byte   0b00000000              ; 084 - 84
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100100
        .byte   0b00001100
        .byte   0b00010100
        .byte   0b00111110
        .byte   0b00000100

        .byte   0b00000000              ; 085 - 85
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00000010
        .byte   0b00011100

        .byte   0b00000000              ; 086 - 86
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100110
        .byte   0b00001000
        .byte   0b00011100
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 087 - 87
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111110
        .byte   0b00000010
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00001000

        .byte   0b00000000              ; 088 - 88
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01101100
        .byte   0b00010010
        .byte   0b00001100
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 089 - 89
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01101100
        .byte   0b00010010
        .byte   0b00001110
        .byte   0b00000100
        .byte   0b00011000

        .byte   0b00000000              ; 08a - 8a
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01101100
        .byte   0b00010010
        .byte   0b00011110
        .byte   0b00010010
        .byte   0b00010010

        .byte   0b00000000              ; 08b - 8b
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111100
        .byte   0b00010010
        .byte   0b00011100
        .byte   0b00010010
        .byte   0b00011100

        .byte   0b00000000              ; 08c - 8c
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01101110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00001110

        .byte   0b00000000              ; 08d - 8d
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00011100

        .byte   0b00000000              ; 08e - 8e
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00011110

        .byte   0b00000000              ; 08f - 8f
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01111110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 090 - 90
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11001100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 091 - 91
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11000100
        .byte   0b00001100
        .byte   0b00000100
        .byte   0b00000100
        .byte   0b00001110

        .byte   0b00000000              ; 092 - 92
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11001100
        .byte   0b00010010
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00011110

        .byte   0b00000000              ; 093 - 93
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011110
        .byte   0b00000010
        .byte   0b00001100
        .byte   0b00000010
        .byte   0b00011100

        .byte   0b00000000              ; 094 - 94
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11000100
        .byte   0b00001100
        .byte   0b00010100
        .byte   0b00111110
        .byte   0b00000100

        .byte   0b00000000              ; 095 - 95
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00000010
        .byte   0b00011100

        .byte   0b00000000              ; 096 - 96
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11000110
        .byte   0b00001000
        .byte   0b00011100
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 097 - 97
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011110
        .byte   0b00000010
        .byte   0b00000100
        .byte   0b00001000
        .byte   0b00001000

        .byte   0b00000000              ; 098 - 98
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11001100
        .byte   0b00010010
        .byte   0b00001100
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 099 - 99
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11001100
        .byte   0b00010010
        .byte   0b00001110
        .byte   0b00000100
        .byte   0b00011000

        .byte   0b00000000              ; 09a - 9a
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11001100
        .byte   0b00010010
        .byte   0b00011110
        .byte   0b00010010
        .byte   0b00010010

        .byte   0b00000000              ; 09b - 9b
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011100
        .byte   0b00010010
        .byte   0b00011100
        .byte   0b00010010
        .byte   0b00011100

        .byte   0b00000000              ; 09c - 9c
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11001110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00001110

        .byte   0b00000000              ; 09d - 9d
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00011100

        .byte   0b00000000              ; 09e - 9e
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00011110

        .byte   0b00000000              ; 09f - 9f
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b01110000
        .byte   0b00100000
        .byte   0b11011110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 0a0 - a0
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10011100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 0a1 - i
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0a2 - cent
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b10010010
        .byte   0b10010000
        .byte   0b10010010
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00000000

        .byte   0b00000000              ; 0a3 - £
        .byte   0b00011100
        .byte   0b00100000
        .byte   0b00100000
        .byte   0b11111000
        .byte   0b00100000
        .byte   0b01111000
        .byte   0b10100110
        .byte   0b01000000
        .byte   0b00000000

        .byte   0b00000000              ; 0a4 - a4
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10010100
        .byte   0b00001100
        .byte   0b00010100
        .byte   0b00111110
        .byte   0b00000100

        .byte   0b00000000              ; 0a5 - yen
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0a6 - a6
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10010110
        .byte   0b00001000
        .byte   0b00011100
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00000000              ; 0a7 - section
        .byte   0b00111100
        .byte   0b01000000
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b00000100
        .byte   0b01111000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0a8 -
        .byte   0b00000000
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b01000100
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0a9 - (c)
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b10011010
        .byte   0b10100010
        .byte   0b10100010
        .byte   0b10011010
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b00000000

        .byte   0b00000000              ; 0aa - a
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0ab - <<
        .byte   0b00010010
        .byte   0b00100100
        .byte   0b01001000
        .byte   0b10010000
        .byte   0b01001000
        .byte   0b00100100
        .byte   0b00010010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0ac - ac
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10011110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00001110

        .byte   0b00000000              ; 0ad - ad
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10011100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00011100

        .byte   0b00000000              ; 0ae - ae
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10011110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00011110

        .byte   0b00000000              ; 0af - af
        .byte   0b01100000
        .byte   0b10010000
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10011110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00010000

        .byte   0b00000000              ; 0b0 - degree
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0b1 - -+
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0b2 - super 2
        .byte   0b01000100
        .byte   0b00011000
        .byte   0b00100000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01111100              ; 0b3 - auper 3
        .byte   0b00000100
        .byte   0b00011000
        .byte   0b00000100
        .byte   0b01111000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0b4 - b4
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b11100100
        .byte   0b00001100
        .byte   0b00010100
        .byte   0b00111110
        .byte   0b00000100

        .byte   0b00000000              ; 0b5 - micro
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01000010
        .byte   0b01000010
        .byte   0b01000010
        .byte   0b01100110
        .byte   0b01011010
        .byte   0b01000000
        .byte   0b10000000

        .byte   0b00000000              ; 0b6 - para
        .byte   0b01111110
        .byte   0b11001010
        .byte   0b11001010
        .byte   0b01111110
        .byte   0b00001010
        .byte   0b00001010
        .byte   0b00001010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0b7 - dot
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00110000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0b8 - b8
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b11101100
        .byte   0b00010010
        .byte   0b00001100
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00010000              ; 0b9 - super 1
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00111000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0ba - o
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0bb - >>
        .byte   0b10010000
        .byte   0b01001000
        .byte   0b00100100
        .byte   0b00010010
        .byte   0b00100100
        .byte   0b01001000
        .byte   0b10010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0bc - 1/4
        .byte   0b01000000
        .byte   0b11000100
        .byte   0b01001000
        .byte   0b01010000
        .byte   0b00100100
        .byte   0b01001100
        .byte   0b10010100
        .byte   0b00111110
        .byte   0b00000100

        .byte   0b00000000              ; 0bd - 1/2
        .byte   0b01000000
        .byte   0b11000100
        .byte   0b01001000
        .byte   0b01010000
        .byte   0b00101100
        .byte   0b01010010
        .byte   0b10000100
        .byte   0b00001000
        .byte   0b00011110

        .byte   0b00000000              ; 0be - be
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00011110

        .byte   0b00000000              ; 0bf
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01100000
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00110000              ; 0c0 - A
        .byte   0b00001100
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00011000              ; 0c1 - A
        .byte   0b01100000
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0c2 - A
        .byte   0b01000100
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00110010              ; 0c3 - A
        .byte   0b01001100
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01000100              ; 0c4 - A
        .byte   0b00000000
        .byte   0b00010000
        .byte   0b00101000
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0c5 - A
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0c6 - AE
        .byte   0b00111110
        .byte   0b01010000
        .byte   0b10010000
        .byte   0b10011100
        .byte   0b11110000
        .byte   0b10010000
        .byte   0b10011110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0c7 - C
        .byte   0b00111100
        .byte   0b01000010
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b01000010
        .byte   0b00111100
        .byte   0b00001000
        .byte   0b00111000

        .byte   0b01100000              ; 0c8 - E
        .byte   0b00011000
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b11111000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00001100              ; 0c9 - E
        .byte   0b00110000
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b11111000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0ca - E
        .byte   0b01000100
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b11111000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01000100              ; 0cb - E
        .byte   0b00000000
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b11111000
        .byte   0b10000000
        .byte   0b10000000
        .byte   0b11111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00110000              ; 0cc - I
        .byte   0b00001100
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00011000              ; 0cd - I
        .byte   0b01100000
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0ce - I
        .byte   0b01000100
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01000100              ; 0cf - I
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0d0 - d0
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b11101100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b00110010              ; 0d1 - N
        .byte   0b01001100
        .byte   0b11000010
        .byte   0b10100010
        .byte   0b10010010
        .byte   0b10001010
        .byte   0b10000110
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00110000              ; 0d2 - O
        .byte   0b00001100
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00011000              ; 0d3 - O
        .byte   0b01100000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0d4 - O
        .byte   0b01000100
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01100100              ; 0d5 - O
        .byte   0b10011000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01000100              ; 0d6- O
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0d7 - OE
        .byte   0b01101110
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b10011100
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b01101110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000010              ; 0d8 - O
        .byte   0b01111100
        .byte   0b10000110
        .byte   0b10001010
        .byte   0b10010010
        .byte   0b10100010
        .byte   0b11000010
        .byte   0b01111100
        .byte   0b10000000
        .byte   0b00000000

        .byte   0b01100000              ; 0d9 - U
        .byte   0b00011000
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00001100              ; 0da - U
        .byte   0b00110000
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00010000              ; 0db - U
        .byte   0b00101000
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01000100              ; 0dc - U
        .byte   0b00000000
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b01000100              ; 0dd - Y
        .byte   0b00000000
        .byte   0b10000010
        .byte   0b01000100
        .byte   0b00101000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0de - de
        .byte   0b11100000
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b10010000
        .byte   0b11111110
        .byte   0b00010000
        .byte   0b00011100
        .byte   0b00010000
        .byte   0b00011110

        .byte   0b00000000              ; 0df - B
        .byte   0b00111000
        .byte   0b01000100
        .byte   0b10000100
        .byte   0b10111000
        .byte   0b10000100
        .byte   0b10100010
        .byte   0b10011100
        .byte   0b10000000
        .byte   0b00000000

        .byte   0b00000000              ; 0e0 - a
        .byte   0b00110000
        .byte   0b00001100
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0e1 - a
        .byte   0b00011000
        .byte   0b01100000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0e2 - a
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00110010              ; 0e3 - a
        .byte   0b01001100
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0e4 - a
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0e5 - a
        .byte   0b01000100
        .byte   0b00111000
        .byte   0b01111100
        .byte   0b00000010
        .byte   0b01111110
        .byte   0b10000110
        .byte   0b01111010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0e6 - ae
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01101100
        .byte   0b00010010
        .byte   0b01111110
        .byte   0b10010000
        .byte   0b01111110
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0e7 - c
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000000
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00001000
        .byte   0b00111000

        .byte   0b00000000              ; 0e8 - e
        .byte   0b00110000
        .byte   0b00001100
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0e9 - e
        .byte   0b00011000
        .byte   0b01100000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0ea - e
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0eb - e
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b11111110
        .byte   0b10000000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0ec - i
        .byte   0b01100000
        .byte   0b00011000
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0ed - i
        .byte   0b00011000
        .byte   0b01100000
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00111000              ; 0ee - i
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0ef - i
        .byte   0b01000100
        .byte   0b00000000
        .byte   0b00110000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b00010000
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f0 - f0
        .byte   0b11110000
        .byte   0b10000000
        .byte   0b11100000
        .byte   0b10000000
        .byte   0b10001100
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00010010
        .byte   0b00001100

        .byte   0b01100100              ; 0f1 - n
        .byte   0b10011000
        .byte   0b00000000
        .byte   0b10111100
        .byte   0b11000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f2 - o
        .byte   0b00110000
        .byte   0b00001100
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f3 - o
        .byte   0b00011000
        .byte   0b01100000
        .byte   0b01111100
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b10000010
        .byte   0b01111100
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 0f
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 10
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .byte   0b00000000              ; 11
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000
        .byte   0b00000000

        .end
