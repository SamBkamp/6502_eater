PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
ACR = $600B
T1CL = $6004
T1CH = $6005
IFR = $600D        
IER = $600E
        
E = %10000000
RW = %01000000
RS = %00100000


        .org $8000
_start:
        lda #$ff
        sta DDRA
        
        lda #%00000000          ;one shot mode, pb7 disabled
        sta ACR
        sta PORTA
        jsr delay

_loop:  
        inc PORTA
        jsr delay
        dec PORTA
        jsr delay
        jmp _loop

delay:
        lda #$50
        sta T1CL
        lda #$ca
        sta T1CH
delay_more:
        bit IFR
        bvc delay_more
        lda T1CL
        rts

irq:    
        rti
        
        ;; jump table
        .org $FFFC
        .word $8000
        .word irq
