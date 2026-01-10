        ;; top of ROM
        .org $8000
_start:
        lda #$ff
        sta $6003
        lda #$50
_loop:  
        sta $6001
        ror
        jmp _loop
        
        ;; jump table
        .org $FFFC
        .word $8000
        .word $0000
