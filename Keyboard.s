;===============================================================================
; PS/2 Keyboard Interface
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
; 2013-04-09 AJ Initial version
;-------------------------------------------------------------------------------
; $Id: Keyboard.s 27 2013-10-10 12:44:04Z andrew $
;-------------------------------------------------------------------------------

        .include "Hardware.inc"

;===============================================================================
; Constants
;-------------------------------------------------------------------------------

        .equiv  KB_SIZE,        16

        .equiv  KB_SHIFT,       0
        .equiv  KB_CTRL,        1
        .equiv  KB_ALT,         2
        .equiv  KB_ALTGR,       3
        .equiv  KB_CAPLOCK,     4
        .equiv  KB_NUMLOCK,     5
        .equiv  KB_SCLLOCK,     6

;===============================================================================
; Data Areas
;-------------------------------------------------------------------------------

        .section nbss,bss,near

STATE:  .space  2                       ; Receive state
DATA:   .space  2                       ; Received data bits

KBMODS: .space  2                       ; Keyboard modifiers

KBHEAD: .space  2                       ; Index to head of keyboard queue
KBTAIL: .space  2                       ; Index to tail of keyboard queue

;-------------------------------------------------------------------------------

        .section bss,bss

KBDATA: .space  KB_SIZE                 ; Keyboard data queue

        .text

;===============================================================================
;-------------------------------------------------------------------------------

        .global KeybdInit
KeybdInit:
        clr     KBHEAD                  ; Reset buffer indexes
        clr     KBTAIL
        clr     KBMODS

        bset    CLOCK_CNEN,#CLOCK_PIN   ; Enable interrupt on change on clock

        bclr    IPC4,#CNIP0             ; Set high priority (6)
        bset    IPC4,#CNIP1
        bset    IPC4,#CNIP2

;-------------------------------------------------------------------------------

        .global KeybdRelease
KeybdRelease:
        bset    CLOCK_TRIS,#CLOCK_PIN   ; Release keyboard from reset
        clr     STATE                   ; Reset the state machine
        mov     CLOCK_PORT,w0           ; Read current state

        bclr    IFS1,#CNIF              ; Clear any pending interrupts
        bset    IEC1,#CNIE              ; .. and enable
        return

;-------------------------------------------------------------------------------

        .global KeybdSuspend
KeybdSuspend:
        bclr    CLOCK_TRIS,#CLOCK_PIN   ; Hold keyboard in RESET state
        return

;===============================================================================
; Interrupt Handler
;-------------------------------------------------------------------------------

        .global __CNInterrupt
__CNInterrupt:
        bclr    IFS1,#CNIF              ; Clear the condition

        btsc    CLOCK_PORT,#CLOCK_PIN   ; Is the clock pin low?
        retfie                          ; No. 

        push.d  w0                      ; Save some work registers
        mov     STATE,w0                ; Fetch the current state
        bra     w0                      ; .. and jump to it

        bra     ReadStart
        bra     ReadBit0
        bra     ReadBit1
        bra     ReadBit2
        bra     ReadBit3
        bra     ReadBit4
        bra     ReadBit5
        bra     ReadBit6
        bra     ReadBit7
        bra     ReadParity
        bra     ReadStop

ReadStart:
        clr     DATA                    ; Clear the data buffer
        btss    DATA_PORT,#DATA_PIN     ; Is the data pin HI?
        bra     BumpState               ; No, shoul be LO start bit

        pop.d   w0                      ; Otherwise ignore the pulse
        retfie

ReadBit0:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#0                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state
            
ReadBit1:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#1                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadBit2:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#2                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadBit3:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#3                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadBit4:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#4                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadBit5:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#5                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadBit6:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#6                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadBit7:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#7                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

ReadParity:
        btsc    DATA_PORT,#DATA_PIN     ; If the data pin LO?
        bset    DATA,#8                 ; No, set a bit in the value
        bra     BumpState               ; Then update the state

BumpState:
        inc     STATE                   ; Bump the state offset
        pop.d   w0                      ; Restore the users registers
        retfie                          ; .. and go back to user code

ReadStop:
        clr     STATE                   ; Reset the state machine

        mov     DATA,w0                 ; Fetch the last keyboard code
        push.d  w2
        mov     #KBDATA,w1              ; Load the buffer address
        mov     KBHEAD,w2               ; .. and indexes
        mov     KBTAIL,w3
        mov.b   w0,[w1+w3]              ; Save the key code
        
        inc     w3,w3                   ; Bump and wrap the pointer
        xor     #KB_SIZE,w3
        btss    SR,#Z
        xor     #KB_SIZE,w3

        cpseq   w2,w3                   ; Is the buffer completely full?
        mov     w3,KBTAIL               ; No, update the pointer
        
        pop.d   w2                      ; Restore the users registers
        pop.d   w0                      
        retfie
        
;===============================================================================
; Keyboard Task
;-------------------------------------------------------------------------------

        .global Keyboard
        .extern TaskSwap
        .extern UartTx
Keyboard:
       
        .if     0
        rcall   GetRaw
        push    w0
        mov     #'[',w0
        rcall   UartTx
        pop     w0
        rcall   Hex2
        mov     #']',w0
        rcall   UartTx
        .else
        rcall   GetKey                 ; Wait for next keyboard code
        rcall   UartTx
        .endif
        
        bra     Keyboard

;===============================================================================
; Raw Keyboard Access
;-------------------------------------------------------------------------------

; Gets the next raw keyboard scan code from the input buffer. If none are
; available then yield to the other task.

GetRaw:
        mov     #KBDATA,w1              ; Load data buffer
        mov     KBHEAD,w2               ; .. and indexes
        mov     KBTAIL,w3
        
        cpseq   w2,w3                   ; Any data in the keyboard buffer?
        bra     1f                      ; Yes, need to remove a byte

        rcall   TaskSwap                ; Allow the terminal task to run
        bra     GetRaw                  ; Then try again.

1:      mov.b   [w1+w2],w0              ; Take a code from the head
        ze      w0,w0                   ; .. ensuring hi byte is zero

        inc     w2,w2                   ; Bump and wrap the pointer
        xor     #KB_SIZE,w2
        btss    SR,#Z
        xor     #KB_SIZE,w2

        mov     w2,KBHEAD               ; Then save new value
        return                          ; All done.

;===============================================================================
; Keyboard Decoding
;-------------------------------------------------------------------------------

        .global GetKey
GetKey:
        rcall   GetRaw                  ; Get the next raw key press

        mov     #0xaa,w1                ; Keyboard reset code?
        cpsne   w0,w1
        bra     GetKey                  ; Yes, ignore it
        mov     #0xfc,w1                ; Keyboard error code?
        cpsne   w0,w1
        bra     GetKey                  ; Yes, ignore it

        mov     #0xe0,w1                ; Is this an extended code?
        cpsne   w0,w1
        bra     ExtendedPress           ; Yes.

        mov     #0xf0,w1                ; Normal break code?
        cpseq   w0,w1
        bra     NormalPress             ; No, its a normal code    
        bra     NormalBreak

;-------------------------------------------------------------------------------

ExtendedPress:
        rcall   GetRaw                  ; Get the next scan code
        
        mov     #0xf0,w1                ; Extended break code?
        cpsne   w0,w1
        bra     ExtendedBreak           ; Yes, important codes 

        mov     #0x6b,w1                ; Check for cursor keys    
        cpsne   w0,w1
        bra     CursorLeft              ; Left?
        mov     #0x74,w1
        cpsne   w0,w1
        bra     CursorRight             ; Right?
        mov     #0x75,w1
        cpsne   w0,w1
        bra     CursorUp                ; Up?
        mov     #0x72,w1
        cpsne   w0,w1
        bra     CursorDown              ; Down?
        
        bra     GetKey                  ; Ignore other keys

CursorLeft:
        mov     #0x0100,w0
        return

CursorRight:
        mov     #0x0101,w0
        return

CursorUp:
        mov     #0x0102,w0
        return

CursorDown:
        mov     #0x0103,w0
        return

;-------------------------------------------------------------------------------

ExtendedBreak:
        rcall   GetRaw                  ; Get the next scan code
        bra     GetKey

;-------------------------------------------------------------------------------

NormalPress:
        mov     #0x12,w1                ; Test for SHIFT keys
        cpsne   w0,w1
        bra     ShiftPress
        mov     #0x59,w1
        cpsne   w0,w1
        bra     ShiftPress

        mov     #0x14,w1                ; Test for CTRL keys
        cpsne   w0,w1
        bra     CtrlPress

        mov     #0x11,w1                ; Test for ALT keys
        cpsne   w0,w1
        bra     AltPress

        mov     #0x58,w1                ; Test for CAPS lock
        cpsne   w0,w1
        bra     CapToggle
        mov     #0x77,w1                ; Test for NUM lock
        cpsne   w0,w1
        bra     NumToggle
        mov     #0x7e,w1                ; Test for SCL lock
        cpsne   w0,w1
        bra     SclToggle

        mov     #0x05,w1                ; Test for function keys
        cpsne   w0,w1
        bra     FunctionKey1            ; F1?
        mov     #0x06,w1
        cpsne   w0,w1
        bra     FunctionKey2            ; F2?
        mov     #0x04,w1
        cpsne   w0,w1
        bra     FunctionKey3            ; F3?
        mov     #0x0c,w1
        cpsne   w0,w1
        bra     FunctionKey4            ; F4?
        mov     #0x03,w1
        cpsne   w0,w1
        bra     FunctionKey5            ; F5?
        mov     #0x0b,w1
        cpsne   w0,w1
        bra     FunctionKey6            ; F6?
        mov     #0x83,w1
        cpsne   w0,w1
        bra     FunctionKey7            ; F7?
        mov     #0x0a,w1
        cpsne   w0,w1
        bra     FunctionKey8            ; F8?
        mov     #0x01,w1
        cpsne   w0,w1
        bra     FunctionKey9            ; F9?
        mov     #0x09,w1
        cpsne   w0,w1
        bra     FunctionKey10           ; F10?
        mov     #0x78,w1
        cpsne   w0,w1
        bra     FunctionKey11           ; F11?
        mov     #0x07,w1
        cpsne   w0,w1
        bra     FunctionKey12           ; F12?

        mov     #0x70,w1                ; Test for keypad
        cpsne   w0,w1
        bra     KeyPad0                 ; 0?
        mov     #0x69,w1
        cpsne   w0,w1
        bra     KeyPad1                 ; 1?
        mov     #0x72,w1
        cpsne   w0,w1
        bra     KeyPad2                 ; 2?
        mov     #0x7a,w1
        cpsne   w0,w1
        bra     KeyPad3                 ; 3?
        mov     #0x6b,w1
        cpsne   w0,w1
        bra     KeyPad4                 ; 4?
        mov     #0x73,w1
        cpsne   w0,w1
        bra     KeyPad5                 ; 5?
        mov     #0x74,w1
        cpsne   w0,w1
        bra     KeyPad6                 ; 6?
        mov     #0x6c,w1
        cpsne   w0,w1
        bra     KeyPad7                 ; 7?
        mov     #0x75,w1
        cpsne   w0,w1
        bra     KeyPad8                 ; 8?
        mov     #0x7d,w1
        cpsne   w0,w1
        bra     KeyPad9                 ; 9?

        mov     #0x7c,w1
        cpsne   w0,w1
        retlw   #'*',w0                 ; *
        mov     #0x7b,w1
        cpsne   w0,w1
        retlw   #'-',w0                 ; -
        mov     #0x79,w1
        cpsne   w0,w1
        retlw   #'+',w0                 ; +

        mov     #tblpage(EnGB),w1       ; Set up to access the mapping
        mov     w1,TBLPAG               ; .. table
        mov     #tbloffset(EnGB),w2     ; Load offsets of table ends
        mov     #tbloffset(EnGB_),w3

1:      sub     w3,w2,w1                ; Calculate middle point
        lsr     w1,#3,w1
        sl      w1,#2,w1
        add     w2,w1,w1
        tblrdl  [w1],w4                 ; And fetch the code byte
        ze      w4,w4

        cp.b    w0,w4                   ; Have we found the scan code? 
        bra     z,2f

        cpsne   w2,w3                   ; Any table left to search?
        retlw   #0,w0                   ; No.

        cpslt   w0,w4                   ; Is the scan code in the lower half?
        mov     w1,w2
        cpsgt   w0,w4                   ; Is the scan code in the upper half?
        mov     w1,w3
        bra     1b                      ; And search again

2:      btsc    KBMODS,#KB_ALTGR        ; Alternate graphic key pressed?
        bra     AltGraphic

        btsc    KBMODS,#KB_CAPLOCK      ; Is the CAPS long on?
        bra     3f                      ; Yes.

        btsc    KBMODS,#KB_SHIFT        ; Is a SHIFT pressed?
        bra     UpperCase               ; Yes.
        bra     LowerCase               ; No.

3:      btsc    KBMODS,#KB_SHIFT
        bra     LowerCase
        bra     UpperCase

LowerCase:
        tblrdl [w1],w0                  ; Fetch lower case character
        lsr     w0,#8,w0
        bra     Control

UpperCase:
        inc2    w1,w1                   ; Fetch upper case characger
        tblrdl  [w1],w0
        ze      w0,w0
        bra     Control

AltGraphic:
        inc2    w1,w1                   ; Fetch alternate graphic
        tblrdl  [w1],w0
        lsr     w0,#8,w0

Control:
        btsc    KBMODS,#KB_CTRL         ; Is the control key pressed
        and     #0x1f,w0                ; Yes, strip to control range
        return

FunctionKey1:
        mov     #0x0201,w0
        return

FunctionKey2:
        mov     #0x0202,w0
        return

FunctionKey3:
        mov     #0x0203,w0
        return

FunctionKey4:
        mov     #0x0204,w0
        return

FunctionKey5:
        mov     #0x0205,w0
        return

FunctionKey6:
        mov     #0x0206,w0
        return

FunctionKey7:
        mov     #0x0207,w0
        return

FunctionKey8:
        mov     #0x0208,w0
        return

FunctionKey9:
        mov     #0x0209,w0
        return

FunctionKey10:
        mov     #0x020a,w0
        return

FunctionKey11:
        mov     #0x020b,w0
        return

FunctionKey12:
        mov     #0x020c,w0
        return

KeyPad0:
        btss    KBMODS,#KB_NUMLOCK
        nop
        retlw   #'0',w0

KeyPad1:
        btss    KBMODS,#KB_NUMLOCK
        nop
        retlw   #'1',w0

KeyPad2:
        btss    KBMODS,#KB_NUMLOCK
        bra     CursorDown
        retlw   #'2',w0

KeyPad3:
        btss    KBMODS,#KB_NUMLOCK
        nop
        retlw   #'3',w0

KeyPad4:
        btss    KBMODS,#KB_NUMLOCK
        bra     CursorLeft
        retlw   #'4',w0

KeyPad5:
        btss    KBMODS,#KB_NUMLOCK
        nop
        retlw   #'5',w0

KeyPad6:
        btss    KBMODS,#KB_NUMLOCK
        bra     CursorRight
        retlw   #'6',w0

KeyPad7:
        btss    KBMODS,#KB_NUMLOCK
        nop
        retlw   #'7',w0

KeyPad8:
        btss    KBMODS,#KB_NUMLOCK
        bra     CursorUp
        retlw   #'8',w0

KeyPad9:
        btss    KBMODS,#KB_NUMLOCK
        nop
        retlw   #'9',w0

;-------------------------------------------------------------------------------

NormalBreak:
        rcall   GetRaw                  ; Get the next scan code

        mov     #0x12,w1                ; Test for SHIFT keys
        cpsne   w0,w1
        bra     ShiftBreak
        mov     #0x59,w1
        cpsne   w0,w1
        bra     ShiftBreak

        mov     #0x14,w1                ; Test for CTRL keys
        cpsne   w0,w1
        bra     CtrlBreak

        mov     #0x11,w1                ; Test for ALT keys
        cpsne   w0,w1
        bra     AltBreak

        bra     GetKey                  ; Ignore everything else

;-------------------------------------------------------------------------------

ShiftPress:
        bset    KBMODS,#KB_SHIFT
        bra     GetKey

ShiftBreak:
        bclr    KBMODS,#KB_SHIFT
        bra     GetKey

CtrlPress:
        bset    KBMODS,#KB_CTRL
        bra     GetKey

CtrlBreak:
        bclr    KBMODS,#KB_CTRL
        bra     GetKey

AltPress:
        bset    KBMODS,#KB_ALT
        bra     GetKey

AltBreak:
        bclr    KBMODS,#KB_ALT
        bra     GetKey

AltGrPress:
        bset    KBMODS,#KB_ALTGR
        bra     GetKey

AltGrBreak:
        bclr    KBMODS,#KB_ALTGR
        bra     GetKey

;-------------------------------------------------------------------------------

CapToggle:
        btg     KBMODS,#KB_CAPLOCK
        bra     UpdateLeds

NumToggle:
        btg     KBMODS,#KB_NUMLOCK
        bra     UpdateLeds

SclToggle:
        btg     KBMODS,#KB_SCLLOCK

UpdateLeds:

        bra     GetKey

;===============================================================================
; Character Mapping Tables
;-------------------------------------------------------------------------------

EnGB:
        .byte   0x0d,'\t','\t',0
        .byte   0x0e,'`','¬','¦'
        .byte   0x15,'q','Q',0
        .byte   0x16,'1','!',0
        .byte   0x1a,'z','Z',0
        .byte   0x1b,'s','S',0
        .byte   0x1c,'a','A','á'
        .byte   0x1d,'w','W',0
        .byte   0x1e,'2','"',0
        .byte   0x21,'c','C',0
        .byte   0x22,'x','X',0
        .byte   0x23,'d','D',0
        .byte   0x24,'e','E','é'
        .byte   0x25,'4','$','€'
        .byte   0x26,'3','£',0
        .byte   0x29,' ',' ',0
        .byte   0x2a,'v','V',0
        .byte   0x2b,'f','F',0
        .byte   0x2c,'t','T',0
        .byte   0x2d,'r','R',0
        .byte   0x2e,'5','%',0
        .byte   0x31,'n','N',0
        .byte   0x32,'b','B',0
        .byte   0x33,'h','H',0
        .byte   0x34,'g','G',0
        .byte   0x35,'y','Y',0
        .byte   0x36,'6','^',0
        .byte   0x3a,'m','M',0
        .byte   0x3b,'j','J',0
        .byte   0x3c,'u','U','ú'
        .byte   0x3d,'7','&',0
        .byte   0x3e,'8','*',0
        .byte   0x41,',','<',0
        .byte   0x42,'k','K',0
        .byte   0x43,'i','I','í'
        .byte   0x44,'o','O','ó'
        .byte   0x45,'0',')',0
        .byte   0x46,'9','(',0
        .byte   0x49,'.','>',0
        .byte   0x4a,'/','?',0
        .byte   0x4b,'l','L',0
        .byte   0x4c,';',':',0
        .byte   0x4d,'p','P',0
        .byte   0x4e,'-','_',0
        .byte   0x52,'\'','@',0
        .byte   0x54,'[','{',0
        .byte   0x55,'=','+',0
        .byte   0x5a,'\r','\r',0
        .byte   0x5b,']','}',0
        .byte   0x5d,'#','~',0
        .byte   0x61,'\\','|',0
        .byte   0x66,0x7f,0x7f,0
;        .byte   0x66,0x08,0x08,0
EnGB_:  .byte   0x76,0x1b,0x1b,0



        .if     1
Hex2:
        push    w0
        lsr     w0,#4,w0
        rcall   Hex
        pop     w0

Hex:
        push    w0
        rcall   ToHexDigit
        rcall   UartTx
        pop     w0
        return

ToHexDigit:
        and     #0x000f,w0
        bra     w0

        retlw   #'0',w0
        retlw   #'1',w0
        retlw   #'2',w0
        retlw   #'3',w0
        retlw   #'4',w0
        retlw   #'5',w0
        retlw   #'6',w0
        retlw   #'7',w0
        retlw   #'8',w0
        retlw   #'9',w0
        retlw   #'A',w0
        retlw   #'B',w0
        retlw   #'C',w0
        retlw   #'D',w0
        retlw   #'E',w0
        retlw   #'F',w0

        .endif

        .end
