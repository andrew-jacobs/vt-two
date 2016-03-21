;===============================================================================
; Uart Driver
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
; $Id: Uart.s 24 2013-06-29 18:52:40Z andrew $
;-------------------------------------------------------------------------------

        .include "Hardware.inc"

;===============================================================================
; Constants
;-------------------------------------------------------------------------------

        .equiv  RX_SIZE,        128
        .equiv  TX_SIZE,        64

;===============================================================================
; Data Areas
;-------------------------------------------------------------------------------

        .section nbss,bss,near

RXHEAD: .space  2
RXTAIL: .space  2
TXHEAD: .space  2
TXTAIL: .space  2

;-------------------------------------------------------------------------------

        .section bss,bss

RXDATA: .space  RX_SIZE
TXDATA: .space  TX_SIZE

;===============================================================================
; UART Initialisation
;-------------------------------------------------------------------------------

        .text
        .global UartInit
UartInit:
        clr     RXHEAD                  ; Clear the FIFO indexes
        clr     RXTAIL
        clr     TXHEAD
        clr     TXTAIL

        mov     #BRG_57600,w0           ; Configure the UART 
        mov     w0,U1BRG
        mov     #(1<<UARTEN)|(1<<BRGH),w0
        mov     w0,U1MODE
        mov     #(1<<UTXEN),w0
        mov     w0,U1STA

        bset    IPC2,#U1RXIP0           ; Set medium priority (3)
        bset    IPC2,#U1RXIP1
        bclr    IPC2,#U1RXIP2
        bset    IPC3,#U1TXIP0
        bset    IPC3,#U1TXIP1
        bclr    IPC3,#U1TXIP2

        bset    IEC0,#U1RXIE            ; Enable receive
        bclr    IEC0,#U1TXIE            ; .. but not transmit
        return

;-------------------------------------------------------------------------------

; When the UART has received a character extract it and copy it to the tail of
; the receive buffer. If the buffer would overflow then discard the character.

        .global __U1RXInterrupt
__U1RXInterrupt:
        push.d  w0                      ; Save user registers
        push.d  w2
        bclr    IFS0,#U1RXIF            ; Clear the interrupt flag

        mov     #RXDATA,w1              ; Point w1 at the receive buffer
        mov     RXHEAD,w2               ; .. and load indexes
        mov     RXTAIL,w3

1:      btsc    U1STA,#URXDA            ; Does the UART have data?
        bra     2f

        pop.d   w2                      ; Restore user registers
        pop.d   w0
        retfie

2:      mov     U1RXREG,w0              ; Copy received character to buffer
        mov.b   w0,[w1+w3]

        inc     w3,w3                   ; Bump and wrap tail index
        xor     #RX_SIZE,w3
        btss    SR,#Z
        xor     #RX_SIZE,w3

        cpseq   w2,w3                   ; Is the buffer completely full?
        mov     w3,RXTAIL               ; No, update the tail
        bra     1b                      ; And try again

; Extract the first character from the UART RX buffer and return it to the
; caller in w0. If the buffer is empty then switch task.

        .global UartRx
        .extern TaskSwap
UartRx:
        push    w1                      ; Save callers registers
        push.d  w2
1:      mov     #RXDATA,w1              ; Point w1 at the receive buffer
        mov     RXHEAD,w2               ; .. and load indexes
        mov     RXTAIL,w3

        cp      w2,w3                   ; Is receive buffer empty?
        bra     nz,2f
        rcall   TaskSwap                ; Yes, switch tasks for a while
        bra     1b                      ; Then try again

2:      mov.b   [w1+w2],w0              ; Extract the head character
        ze      w0,w0

        inc     w2,w2                   ; Bump and wrap the head
        xor     #RX_SIZE,w2
        btss    SR,#Z
        xor     #RX_SIZE,w2
        mov     w2,RXHEAD               ; Update the index

        pop.d   w2                      ; Restore saved registers
        pop     w1
        return                          ; Done.

;-------------------------------------------------------------------------------

;

        .global __U1TXInterrupt
__U1TXInterrupt:
        push.d  w0                      ; Save user registers
        push.d  w2
        bclr    IFS0,#U1TXIF            ; Clear the interrupt flag

        mov     #TXDATA,w1              ; Point w1 at the buffer
        mov     TXHEAD,w2               ; .. and load indexes
        mov     TXTAIL,w3

1:      cpseq   w2,w3                   ; Any data left to send?
        bra     2f

        bclr    IEC0,#U1TXIE            ; Disable transmission
        pop.d   w2                      ; Restore user registers
        pop.d   w0
        retfie

2:      btss    U1STA,#UTXBF            ; Is the UART full?
        bra     3f                      ; No, add a byte

        pop.d   w2                      ; Restore user registers
        pop.d   w0
        retfie

3:      mov.b   [w1+w2],w0              ; Fetch the next character
        mov     w0,U1TXREG              ; And start transmission

        inc     w2,w2                   ; Bump and wrap index
        xor     #TX_SIZE,w2
        btss    SR,#Z
        xor     #TX_SIZE,w2
        mov     w2,TXHEAD               ; Then update
        bra     1b                      ; And try again

;

        .global UartTx
UartTx:
        push.d  w0                      ; Save callers registers
        push.d  w2
        mov     #TXDATA,w1              ; Point w1 at the buffer
        mov     TXHEAD,w2               ; .. and load indexes
        mov     TXTAIL,w3

        mov.b   w0,[w1+w3]              ; Save the tranmitted character

        inc     w3,w3                   ; Bump and wrap the pointer
        xor     #TX_SIZE,w3
        btss    SR,#Z
        xor     #TX_SIZE,w3

        cpseq   w2,w3                   ; Is the buffer completely full?
        mov     w3,TXTAIL               ; No, update the pointer

;        btss    U1STA,#UTXBF            ; If the UART has space
;        bset    IFS0,#U1TXIF            ; .. force an interrupt
        bset    IEC0,#U1TXIE            ; Ensure TX enabled
        pop.d   w2                      ; Restore callers registers
        pop.d   w0
        return

;------------------------------------------------------------------------------

        .global __U1ErrInterrupt
__U1ErrInterrupt:
        retfie

        .end
