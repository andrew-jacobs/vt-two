;===============================================================================
; VT220 Emulation
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
; $Id: VT220.s 30 2014-05-31 21:01:09Z andrew $
;-------------------------------------------------------------------------------

        .include "Hardware.inc"
        .include "VT220.inc"

;===============================================================================
; Constants
;-------------------------------------------------------------------------------

        .equiv  MODE_VT52,      0
        .equiv  MODE_VT100,     1
        .equiv  MODE_VT200,     2

        .equiv  ROW_OFFSET,     2

        .equiv  SET_DEC_C0,     0x000
        .equiv  SET_DEC_C1,     0x080
        .equiv  SET_DEC_GR,     0x100


;===============================================================================
; Data Areas
;-------------------------------------------------------------------------------

        .section nbss,bss,near

MODE:   .space  2                       ; Emulation mode
WRAP:   .space  2                       ; Auto wrap mode

ROW:    .space  2                       ; The cursor position on screen
COL:    .space  2

TOP:    .space  2                       ; Top margin
BOT:    .space  2                       ; Bottom margin

WHERE:  .space  2                       ; Pointer to the character at the cursor
UNDER:  .space  2                       ; And its orginal stare

CURSOR: .space  2                       ; The cursor attribute pattern
STYLES: .space  2                       ; Attributes added to normal characters

COUNT:  .space  2                       ; Parameter count
VALUE:  .space  20                      ; Actual values

        .section bss,bss

TABS:   .space  COLS                    ; Tab column flags

;===============================================================================
; Terminal Emulation
;-------------------------------------------------------------------------------

        .text
        .global Terminal
        .extern UartRx
        .extern UartTx
        .extern ROWTAB
        .extern ROWEND
        .extern STATUS
Terminal:
        clr     MODE                    ; Assume VT100 emulation
        bset    MODE,#MODE_VT100
        clr     WRAP                    ; Turn wrap mode off

        clr     ROW                     ; Home the cursor
        clr     COL

        mov     #0,w0                   ; Set the scroll margin
        mov     w0,TOP
        mov     #ROWS-1,w0
        mov     w0,BOT

        mov     #(1<<ATTR_FLASH)|(1<<ATTR_INVERT),w0
        mov     w0,CURSOR               ; Set default cursor attributes
        clr     STYLES

GetUnder:
        mov     ROW,w0                  ; Get row number (0-23)
        sl      w0,#2,w0                ; .. convert to offset
        mov     #ROWTAB,w1              ; .. and finally address
        add     w1,w0,w1
        mov     [w1],w1                 ; Get the data pointer
        mov     COL,w0                  ; .. and add the column
        sl      w0,#1,w0
        add     w0,w1,w1
        mov     w1,WHERE                ; Save the character address
        mov     [w1],w0
        mov     w0,UNDER                ; And the character there
        ior     CURSOR,WREG             ; Add the cursor attributes
        mov     w0,[w1]

        mov     #STATUS+ROW_OFFSET,w4   ; Load pointer to status line
        mov     #(1<<ATTR_INVERT)|'0',w5
        mov     #10,w2

        inc     ROW,WREG                ; Convert row number to ASCII
        repeat  #17
        div.u   w0,w2
        ior     w0,w5,[w4++]
        ior     w1,w5,[w4++]

        mov     #(1<<ATTR_INVERT)|'/',w0
        mov     w0,[w4++]

        inc     COL,WREG                ; Convert column number to ASCII
        repeat  #17
        div.u   w0,w2
        ior     w0,w5,[w4++]
        ior     w1,w5,[w4++]

NextChar:
        rcall   UartRx                  ; Wait for a character
        bra     w0                      ; And branch to handler

        bra     NextChar                ; 00 - NUL
        bra     NextChar                ; 01 - SOH
        bra     NextChar                ; 02
        bra     NextChar                ; 03
        bra     NextChar                ; 04
        bra     NextChar                ; 05
        bra     NextChar                ; 06
        bra     NextChar                ; 07
        bra     DoBS                    ; 08 - BS
        bra     NextChar                ; 09
        bra     DoLF                    ; 0a - LF
        bra     NextChar                ; 0b
        bra     DoFF                    ; 0c - FF 
        bra     DoCR                    ; 0d - CR
        bra     NextChar                ; 0e
        bra     NextChar                ; 0f

        bra     NextChar                ; 10
        bra     NextChar                ; 11
        bra     NextChar                ; 12
        bra     NextChar                ; 13
        bra     NextChar                ; 14
        bra     NextChar                ; 15
        bra     NextChar                ; 16
        bra     NextChar                ; 17
        bra     NextChar                ; 18
        bra     NextChar                ; 19
        bra     NextChar                ; 1a
        bra     DoESC                   ; 1b - ESC
        bra     NextChar                ; 1c
        bra     NextChar                ; 1d
        bra     NextChar                ; 1e
        bra     NextChar                ; 1f
        .rept   95
        bra     Printable               ; 20-7e
        .endr
        bra     NextChar                ; 7f DEL

        bra     NextChar                ; 80
        bra     NextChar                ; 81
        bra     NextChar                ; 82
        bra     NextChar                ; 83
        bra     NextChar                ; 84
        bra     NextChar                ; 85
        bra     NextChar                ; 86
        bra     NextChar                ; 87
        bra     NextChar                ; 88
        bra     NextChar                ; 89
        bra     NextChar                ; 8a
        bra     NextChar                ; 8b
        bra     NextChar                ; 8c
        bra     NextChar                ; 8d
        bra     NextChar                ; 8e
        bra     NextChar                ; 8f

        bra     NextChar                ; 90
        bra     NextChar                ; 91
        bra     NextChar                ; 92
        bra     NextChar                ; 93
        bra     NextChar                ; 94
        bra     NextChar                ; 95
        bra     NextChar                ; 96
        bra     NextChar                ; 97
        bra     NextChar                ; 98
        bra     NextChar                ; 99
        bra     NextChar                ; 9a
        bra     NextChar                ; 9b
        bra     NextChar                ; 9c
        bra     NextChar                ; 9d
        bra     NextChar                ; 9e
        bra     NextChar                ; 9f
        .rept   96
        bra     Printable               ; a0-ff
        .endr

;-------------------------------------------------------------------------------

PutUnder:
        mov     WHERE,w1                ; Load the character address
        mov     UNDER,w0                ; .. and original value
        mov     w0,[w1]                 ; And put back as was
        return

;-------------------------------------------------------------------------------

; BS

DoBS:
        rcall   PutUnder                ; Restore character under cursor
        dec     COL
        ; MORE HERE
        bra     GetUnder                ; And redisplay the cursor   
    
; LF or FF
    
DoLF:
DoFF:
        rcall   PutUnder                ; Restore character under cursor

LineFeed:
        mov     ROW,w0                  ; On the bottom row of scroll region?
        cp      BOT
        bra     z,1f                    ; Yes
        inc     ROW                     ; No, move down to the next row
        bra     GetUnder

1:      mov     #ROWTAB,w1              ; Get row pointer for scroll top
        mov     TOP,w2
        sl      w2,#2,w0
        add     w0,w1,w1

        mov     [w1+0],w0               ; Save top row data pointer
        push    w0

2:      mov     w2,w0                   ; Reached the last row?
        cp      BOT
        bra     z,3f

        mov     [w1+4],w0               ; Copy next line data up
        mov     w0,[w1+0]
        mov     [w1+6],w0
        mov     w0,[w1+2]
        add     w1,#4,w1                ; Bump row pointer
        inc     w2,w2                   ; Bump row counter
        bra     2b

3:      mov     ROWEND,w0               ; Use off-screen row for new line
        mov     w0,[w1+0]
        mov     #TYPE_NORM,w0
        mov     w0,[w1+2]
        pop     w0                      ; Make first row the new off-screen
        mov     w0,ROWEND

        mov     #0x000,w1               ; Erase the off-screen line
        repeat  #COLS-1
        mov     w1,[w0++]
        bra     GetUnder                ; And redisplay the cursor

; CR

DoCR:
        rcall   PutUnder                ; Restore character under cursor
        clr     COL                     ; Move to start of line
        bra     GetUnder                ; And redisplay the cursor   

DoESC:
        rcall   UartRx
        bra     w0

        bra     NextChar                ; 00
        bra     NextChar                ; 01
        bra     NextChar                ; 02
        bra     NextChar                ; 03
        bra     NextChar                ; 04
        bra     NextChar                ; 05
        bra     NextChar                ; 06
        bra     NextChar                ; 07
        bra     NextChar                ; 08
        bra     NextChar                ; 09
        bra     NextChar                ; 0a
        bra     NextChar                ; 0b
        bra     NextChar                ; 0c
        bra     NextChar                ; 0d
        bra     NextChar                ; 0e
        bra     NextChar                ; 0f

        bra     NextChar                ; 10
        bra     NextChar                ; 11
        bra     NextChar                ; 12
        bra     NextChar                ; 13
        bra     NextChar                ; 14
        bra     NextChar                ; 15
        bra     NextChar                ; 16
        bra     NextChar                ; 17
        bra     NextChar                ; 18
        bra     NextChar                ; 19
        bra     NextChar                ; 1a
        bra     NextChar                ; 1b
        bra     NextChar                ; 1c
        bra     NextChar                ; 1d
        bra     NextChar                ; 1e
        bra     NextChar                ; 1f

        bra     NextChar                ; 20
        bra     NextChar                ; 21
        bra     NextChar                ; 22
        bra     DoLineAttr              ; 23 - ESC #
        bra     NextChar                ; 24
        bra     NextChar                ; 25
        bra     NextChar                ; 26
        bra     NextChar                ; 27
        bra     NextChar                ; 28
        bra     NextChar                ; 29
        bra     NextChar                ; 2a
        bra     NextChar                ; 2b
        bra     NextChar                ; 2c
        bra     NextChar                ; 2d
        bra     NextChar                ; 2e
        bra     NextChar                ; 2f

        bra     NextChar                ; 30
        bra     NextChar                ; 31
        bra     NextChar                ; 32
        bra     NextChar                ; 33
        bra     NextChar                ; 34
        bra     NextChar                ; 35
        bra     NextChar                ; 36
        bra     DoDECSC                 ; 37 - ESC 7
        bra     DoDECRC                 ; 38 - ESC 8
        bra     NextChar                ; 39
        bra     NextChar                ; 3a
        bra     NextChar                ; 3b
        bra     NextChar                ; 3c
        bra     NextChar                ; 3d
        bra     NextChar                ; 3e
        bra     NextChar                ; 3f

        bra     NextChar                ; 40
        bra     NextChar                ; 41
        bra     NextChar                ; 42
        bra     NextChar                ; 43
        bra     NextChar                ; 44
        bra     DoNEL                   ; 45 - ESC E
        bra     NextChar                ; 46
        bra     NextChar                ; 47
        bra     DoHTS                   ; 48 - ESC H
        bra     NextChar                ; 49
        bra     NextChar                ; 4a
        bra     NextChar                ; 4b
        bra     NextChar                ; 4c
        bra     DoRI                    ; 4d - ESC M
        bra     NextChar                ; 4e
        bra     NextChar                ; 4f

        bra     NextChar                ; 50
        bra     NextChar                ; 51
        bra     NextChar                ; 52
        bra     NextChar                ; 53
        bra     NextChar                ; 54
        bra     NextChar                ; 55
        bra     NextChar                ; 56
        bra     NextChar                ; 57
        bra     NextChar                ; 58
        bra     NextChar                ; 59
        bra     NextChar                ; 5a
        bra     DoBracket               ; 5b - ESC [
        bra     NextChar                ; 5c
        bra     NextChar                ; 5d
        bra     NextChar                ; 5e
        bra     NextChar                ; 5f

        bra     NextChar                ; 60
        bra     NextChar                ; 61
        bra     NextChar                ; 62
        bra     NextChar                ; 63
        bra     NextChar                ; 64
        bra     NextChar                ; 65
        bra     NextChar                ; 66
        bra     NextChar                ; 67
        bra     NextChar                ; 68
        bra     NextChar                ; 69
        bra     NextChar                ; 6a
        bra     NextChar                ; 6b
        bra     NextChar                ; 6c
        bra     NextChar                ; 6d
        bra     NextChar                ; 6e
        bra     NextChar                ; 6f

        bra     NextChar                ; 70
        bra     NextChar                ; 71
        bra     NextChar                ; 72
        bra     NextChar                ; 73
        bra     NextChar                ; 74
        bra     NextChar                ; 75
        bra     NextChar                ; 76
        bra     NextChar                ; 77
        bra     NextChar                ; 78
        bra     NextChar                ; 79
        bra     NextChar                ; 7a
        bra     NextChar                ; 7b
        bra     NextChar                ; 7c
        bra     NextChar                ; 7d
        bra     NextChar                ; 7e
        bra     NextChar                ; 7f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

        bra     NextChar                ; 0
        bra     NextChar                ; 1
        bra     NextChar                ; 2
        bra     NextChar                ; 3
        bra     NextChar                ; 4
        bra     NextChar                ; 5
        bra     NextChar                ; 6
        bra     NextChar                ; 7
        bra     NextChar                ; 8
        bra     NextChar                ; 9
        bra     NextChar                ; a
        bra     NextChar                ; b
        bra     NextChar                ; c
        bra     NextChar                ; d
        bra     NextChar                ; e
        bra     NextChar                ; f

; Line Attribute (ESC # 3, ESC # 4, ESC # 5, ESC # 6)

DoLineAttr:
        rcall   UartRx                  ; Get line type
        mov     #'3',w1                 ; Double height top?
        mov     #TYPE_DTOP,w2
        cpsne   w0,w1
        bra     1f
        mov     #'4',w1                 ; Double height bottom?
        mov     #TYPE_DBOT,w2
        cpsne   w0,w1
        bra     1f
        mov     #'5',w1                 ; Single width?
        mov     #TYPE_NORM,w2
        cpsne   w0,w1
        bra     1f
        mov     #'6',w1                 ; Double width?
        mov     #TYPE_DOUB,w2
        cpsne   w0,w1
        bra     1f
        bra     NextChar                ; Invalid code - ignore

1:      mov     ROW,w0                  ; Work out offset of current row              
        sl      w0,#2,w0
        mov     #ROWTAB,w1              ; And add table base address
        add     w0,w1,w1
        mov     w2,[w1+2]               ; Update line attribute
        bra     NextChar                ; Done.


; Save Cursor (ESC 7)

DoDECSC:
        bra     NextChar

; Restore Cursor (ESC 8)

DoDECRC:
        bra     NextChar


DoNEL:
        ;
        bra     NextChar

; Horizontal Tab Set (HTS | ESC H)

DoHTS:
        mov     #TABS,w0                ; Set a tab at the current column
        add     COL,WREG
        setm.b  [w0]
        bra     NextChar

DoRI:
        ; 
        bra     NextChar


;

DoBracket:
        clr     COUNT                   ; Reset the parameter count
1:      clr     w3                      ; Clear current value

        rcall   UartRx                  ; Read next character
2:      mov     #'9',w1                 ; Got a digit?
        cp      w0,w1
        bra     gtu,3f                  ; No.
        mov     #'0',w1
        cp      w0,w1
        bra     ltu,3f                  ; No.
        sub     w0,w1,w1                ; Yes, make binary
        sl      w3,#2,w0                ; x4
        add     w0,w3,w0                ; x5
        sl      w0,#1,w0                ; x10
        add     w0,w3,w3
        rcall   UartRx                  ; Read the next character
        mov     #';',w1
        cpseq   w0,w1                   ; Value separator?
        bra     2b                      ; No

        mov     #VALUE,w0               ; Work out where to save
        add     COUNT,WREG
        add     COUNT,WREG
        mov     w3,[w0]                 ; Save the value
        inc     COUNT
        bra     1b
        
3:      mov     #'J',w1
        cpsne   w0,w1
        bra     DoBracketJ
        mov     #'K',w1
        cpsne   w0,w1
        bra     DoBracketK

        bra     NextChar

DoBracketJ:
        bra     NextChar


DoBracketK:
        cp      w3,#0
        bra     z,DoEraseEOL
        cp      w3,#1
        bra     z,DoEraseSOL
        cp      w3,#2
        bra     z,DoEraseLine
        bra     NextChar

DoEraseEOL:

DoEraseSOL:

; ESC [ 2 K

DoEraseLine:
        rcall   PutUnder                ; Restore the screen
EraseLine:
        mov     #ROWTAB,w1              ; Work put row table pointer
        mov     ROW,w0
        sl      w0,#2,w0
        add     w0,w1,w1
        mov     [w1+0],w1               ; Fetch the data pointer

        mov     #0x000,w0               ; Erase while line to spaces
        repeat  #COLS-1
        mov     w0,[w1++]
        bra     GetUnder                ; And put cursor back

;-------------------------------------------------------------------------------

Printable:
        rcall   ToGlyph                 ; Convert code to glyph

        mov     WHERE,w1                ; Get pointer to character under cursor
        ior     STYLES,WREG             ; Add default character styles
        mov     w0,[w1]                 ; And put on display

        mov     #ROWTAB,w1              ; Get row pointer for current line
        mov     ROW,w0
        sl      w0,#2,w0
        add     w0,w1,w1
        inc2    w1,w1                   ; And adjust to access row type
        mov     #COLS,w0                ; Assume a full character row
        cp0     [w1]                    ; Then test the row type
        btss    SR,#Z
        lsr     w0,#1,w0                ; Adjust if double width

        mov     COL,w1                  ; Bump the column number
        inc     w1,w1
        cpseq   w0,w1                   ; Reached the end of the row?
        bra     1f
        btss    WRAP,#0                 ; Are we in wrap around mode?
        bra     GetUnder                ; No, cursor does not move            

        clr     COL                     ; Yes, move to first column
        bra     LineFeed                ; Then do a line feed

1:      mov     w1,COL                  ; Update the column number
        bra     GetUnder
        


;===============================================================================
; Character to Glyph Mapping
;-------------------------------------------------------------------------------


ToGlyph:
        mov     #0x0000,w1
        btsc    w0,#7
        mov     #0x0080,w1

MapGlyph:
        and     #0x7f,w0
        ior     w0,w1,w0
        bra     w0

;-------------------------------------------------------------------------------
; DEC Multinational Character Set (C0 and GL codes)

        retlw   #0x000,w0       ; 0x00
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0

        retlw   #0x000,w0       ; 0x10
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0

        retlw   #0x000,w0       ; 0x20
        retlw   #0x021,w0
        retlw   #0x022,w0
        retlw   #0x023,w0
        retlw   #0x024,w0
        retlw   #0x025,w0
        retlw   #0x026,w0
        retlw   #0x027,w0
        retlw   #0x028,w0
        retlw   #0x029,w0
        retlw   #0x02a,w0
        retlw   #0x02b,w0
        retlw   #0x02c,w0
        retlw   #0x02d,w0
        retlw   #0x02e,w0
        retlw   #0x02f,w0

        retlw   #0x030,w0       ; 0x30
        retlw   #0x031,w0
        retlw   #0x032,w0
        retlw   #0x033,w0
        retlw   #0x034,w0
        retlw   #0x035,w0
        retlw   #0x036,w0
        retlw   #0x037,w0
        retlw   #0x038,w0
        retlw   #0x039,w0
        retlw   #0x03a,w0
        retlw   #0x03b,w0
        retlw   #0x03c,w0
        retlw   #0x03d,w0
        retlw   #0x03e,w0
        retlw   #0x03f,w0

        retlw   #0x040,w0       ; 0x40
        retlw   #0x041,w0
        retlw   #0x042,w0
        retlw   #0x043,w0
        retlw   #0x044,w0
        retlw   #0x045,w0
        retlw   #0x046,w0
        retlw   #0x047,w0
        retlw   #0x048,w0
        retlw   #0x049,w0
        retlw   #0x04a,w0
        retlw   #0x04b,w0
        retlw   #0x04c,w0
        retlw   #0x04d,w0
        retlw   #0x04e,w0
        retlw   #0x04f,w0

        retlw   #0x050,w0       ; 0x50
        retlw   #0x051,w0
        retlw   #0x052,w0
        retlw   #0x053,w0
        retlw   #0x054,w0
        retlw   #0x055,w0
        retlw   #0x056,w0
        retlw   #0x057,w0
        retlw   #0x058,w0
        retlw   #0x059,w0
        retlw   #0x05a,w0
        retlw   #0x05b,w0
        retlw   #0x05c,w0
        retlw   #0x05d,w0
        retlw   #0x05e,w0
        retlw   #0x05f,w0

        retlw   #0x060,w0       ; 0x60
        retlw   #0x061,w0
        retlw   #0x062,w0
        retlw   #0x063,w0
        retlw   #0x064,w0
        retlw   #0x065,w0
        retlw   #0x066,w0
        retlw   #0x067,w0
        retlw   #0x068,w0
        retlw   #0x069,w0
        retlw   #0x06a,w0
        retlw   #0x06b,w0
        retlw   #0x06c,w0
        retlw   #0x06d,w0
        retlw   #0x06e,w0
        retlw   #0x06f,w0

        retlw   #0x070,w0       ; 0x70
        retlw   #0x071,w0
        retlw   #0x072,w0
        retlw   #0x073,w0
        retlw   #0x074,w0
        retlw   #0x075,w0
        retlw   #0x076,w0
        retlw   #0x077,w0
        retlw   #0x078,w0
        retlw   #0x079,w0
        retlw   #0x07a,w0
        retlw   #0x07b,w0
        retlw   #0x07c,w0
        retlw   #0x07d,w0
        retlw   #0x07e,w0
        retlw   #0x07f,w0

;-------------------------------------------------------------------------------
; DEC Multinational Character Set (C1 and GR codes)

        retlw   #0x000,w0       ; 0x80
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0

        retlw   #0x000,w0       ; 0x90
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0

        retlw   #0x000,w0       ; 0xa0
        retlw   #0x0a1,w0
        retlw   #0x0a2,w0
        retlw   #0x0a3,w0
        retlw   #0x000,w0
        retlw   #0x0a5,w0
        retlw   #0x000,w0
        retlw   #0x0a6,w0
        retlw   #0x0a7,w0
        retlw   #0x0a8,w0
        retlw   #0x0a9,w0
        retlw   #0x0aa,w0
        retlw   #0x0ab,w0
        retlw   #0x000,w0
        retlw   #0x000,w0
        retlw   #0x000,w0

        retlw   #0x0b0,w0       ; 0xb0
        retlw   #0x0b1,w0
        retlw   #0x0b2,w0
        retlw   #0x0b3,w0
        retlw   #0x000,w0
        retlw   #0x0b5,w0
        retlw   #0x0b6,w0
        retlw   #0x0b7,w0
        retlw   #0x000,w0
        retlw   #0x0b9,w0
        retlw   #0x0ba,w0
        retlw   #0x0bb,w0
        retlw   #0x0bc,w0
        retlw   #0x0bd,w0
        retlw   #0x000,w0
        retlw   #0x0bf,w0

        retlw   #0x0c0,w0       ; 0xc0
        retlw   #0x0c1,w0
        retlw   #0x0c2,w0
        retlw   #0x0c3,w0
        retlw   #0x0c4,w0
        retlw   #0x0c5,w0
        retlw   #0x0c6,w0
        retlw   #0x0c7,w0
        retlw   #0x0c8,w0
        retlw   #0x0c9,w0
        retlw   #0x0ca,w0
        retlw   #0x0cb,w0
        retlw   #0x0cc,w0
        retlw   #0x0cd,w0
        retlw   #0x0ce,w0
        retlw   #0x0cf,w0

        retlw   #0x000,w0       ; 0xd0
        retlw   #0x0d1,w0
        retlw   #0x0d2,w0
        retlw   #0x0d3,w0
        retlw   #0x0d4,w0
        retlw   #0x0d5,w0
        retlw   #0x0d6,w0
        retlw   #0x0d7,w0
        retlw   #0x0d8,w0
        retlw   #0x0d9,w0
        retlw   #0x0da,w0
        retlw   #0x0db,w0
        retlw   #0x0dc,w0
        retlw   #0x0dd,w0
        retlw   #0x000,w0
        retlw   #0x0df,w0

        retlw   #0x0e0,w0       ; 0xe0
        retlw   #0x0e1,w0
        retlw   #0x0e2,w0
        retlw   #0x0e3,w0
        retlw   #0x0e4,w0
        retlw   #0x0e5,w0
        retlw   #0x0e6,w0
        retlw   #0x0e7,w0
        retlw   #0x0e8,w0
        retlw   #0x0e9,w0
        retlw   #0x0ea,w0
        retlw   #0x0eb,w0
        retlw   #0x0ec,w0
        retlw   #0x0ed,w0
        retlw   #0x0ee,w0
        retlw   #0x0ef,w0

        retlw   #0x000,w0       ; 0xf0
        retlw   #0x0f1,w0
        retlw   #0x0f2,w0
        retlw   #0x0f3,w0
        retlw   #0x0f4,w0
        retlw   #0x0f5,w0
        retlw   #0x0f6,w0
        retlw   #0x0f7,w0
        retlw   #0x0f8,w0
        retlw   #0x0f9,w0
        retlw   #0x0fa,w0
        retlw   #0x0fb,w0
        retlw   #0x0fc,w0
        retlw   #0x0fd,w0
        retlw   #0x000,w0
        retlw   #0x000,w0





        .end
