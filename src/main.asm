; main.asm
; Gets the memory location corresponding to the scanline.
; The next to the one indicated.
;       010T TSSS LLLC CCCC
; Input:        HL -> current scanline.
; Output:       HL -> scanline next.
; Alters the value of the AF and HL registers.
;   pasmo --name main --tapbas main.asm main.tap --log

        ORG     $8000           ; common start address for machine-code programs

        ld      hl, $4000
        ld      b, $c0

loop:
        ld      (hl), $3c
        call    NextScan
        ; halt
        djnz    loop

        ret
        
        INCLUDE "video.asm"
        END     $8000