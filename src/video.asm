; video.asm
; Gets the memory location corresponding to the scanline.
; The next to the one indicated.
;       010T TSSS LLLC CCCC
; Input:        HL -> current scanline.
; Output:       HL -> scanline next.
; Alters the value of the AF and HL registers.

NextScan:
    inc     h                       ; Increment H to increase the scanline
    ld      a, h                    ; Load the value in A
    and     $07                     ; Keeps the bits of the scanline
    ret     nz                      ; If the value is not 0, end of routine

    ; Calculate the following line
    ld      a, l                    ; Load the value in A
    add     a, $20                  ; Add one to the line (%0010 0000)
    ld      l, a                    ; If there is a carry-over, it has changed its position, the top is already adjusted from above
                                    ; End of routine.

    ; If you get here, you haven't changed your mind and you have to adjust as the first inc h incerase it.
    ld      a, h                    ; Load the value in A
    sub     $08                     ; Subtract one third (%0000 1000)
    ld      h, a                  ; Load the value in H

    ret
