.defc PORTB = $6000
.defc PORTA = $6001
.defc DDRB = $6002
.defc DDRA = $6003
.defc ACR = $600B
.defc T1CL = $6004
.defc T1CH = $6005
.defc IFR = $600D
.defc IER = $600E

.defc E = %10000000
.defc RW = %01000000
.defc RS = %00100000

;; top of ROM
.org $8000
_start:
        jsr init_ports

        jsr init_timer
        cli

        jsr init_screen


        ldx #0
print_loop:
        lda message, x
        beq _loop               ;break out of the loop if null terminator encountered
        jsr print_char
        inx
        jmp print_loop

_loop:
        jmp _loop

;; changes port a
print_char:
        jsr lcd_wait
        sta PORTB
        lda #RS                  ;turn on RS
        sta PORTA

        lda #(RS | E)            ;toggle enable and RS
        sta PORTA
        lda #RS                 ;un toggle enable but keep RS
        sta PORTA
        rts

message: .asciiz "erm.. my light                          binking..."

init_ports:
        lda #$ff                ;all pints port b output
        sta DDRB

        lda #$ff                ;top 3 pins port a to output
        sta DDRA

        lda #0
        sta PORTA

        rts

init_timer:
        pha
        lda #%01000000          ;free-run mode
        sta ACR

        lda #$ff
        sta T1CL
        lda #$ff
        sta T1CH                ;init the counters (starts count down)

        lda #%11000000          ;set/clear, timer 1 high
        sta IER

        pla
        rts

;; sreg
lcd_wait:
        pha
        lda #0                  ;set drrb to input to read busy flag
        sta DDRB
reread:
        lda #RW
        sta PORTA
        lda #(E|RW)             ;compile-time constant eval I think
        sta PORTA
        lda PORTB               ;read busy flag
        and #%10000000          ;compare with top bit (bf)
        bne reread

        lda #RW
        sta PORTA

        lda #$ff                ;reset ddrb to output
        sta DDRB
        pla
        rts


init_screen:
        lda #%00000001          ;clear display
        sta PORTB
        jsr lcd_instruction_send

        lda #%00111000          ;function set (set 8-bit mode, 2 line displayt, 5x8 font)
        sta PORTB
        jsr lcd_instruction_send

        lda #0                  ;set control pins to 0
        sta PORTA
        jsr lcd_instruction_send

        lda #%00001111          ;display on, cur on, blink on
        sta PORTB
        jsr lcd_instruction_send

        lda #%00000110          ;entry mode, incr, no scroll
        sta PORTB
        jsr lcd_instruction_send
        rts

;; changes a
lcd_instruction_send:
        jsr lcd_wait
        lda #E                  ;toggle enable
        sta PORTA
        lda #0
        sta PORTA
        rts

_nmi:
        rti

_irq:
        pha
        lda T1CL
        lda #$01
        eor PORTA
        sta PORTA
        pla
        rti

;; jump table
.org $FFFA
.word _nmi
.word _start
.word _irq
