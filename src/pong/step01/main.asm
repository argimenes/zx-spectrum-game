; Draw two vertical lines, one from bottom to top
; and one from top to bottom. Top to bottom to test
; the NextScan and PreviousScan routines.

        org $8000

        ld hl, $4000                            ; HL = scanline 0, line 0, third 0 and column 0
                                                ; (column from 0 to 31)        
        ld b, $c0                               ; B = 192. Scanlines that the display has

loop:
        ld (hl), $3c                            ; Paint on screen 00111100
        call NextScan                           ; Goes to the next scanline
        ; halt                                  ; Uncomment to see the painting process
        djnz loop                               ; Until B = 0
        ld hl, $57ff                            ; HL = last scanline, line, third and column 31
        ld b, $c0                               ; B = 192. Scanlines that the display has

loopUp:
        ld (hl), $3c                            ; Paint on screen 001111000
        call PreviousScan                       ; Goes to the previous scanline
        ; halt                                  ; Uncomment to see the painting process
        djnz loopUp                             ; Until B = 0
        ret
        
        include "video.asm"
        end $8000