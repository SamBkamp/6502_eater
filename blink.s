        .org $8000
_start:
        lda #$ff
        sta $6003
_loop:  
        lda #$55
        sta $6001
        lda #$AA
        sta $6001
        jmp _loop

        .org $FFFC
        .word $8000
        .word $0000
