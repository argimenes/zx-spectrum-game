org $8000               ; Address where the code is loaded

; System variable: permanent display attributes.
; Format: FlASH, BRIGHT, PAPER, INK (FBPPPIII)
ATTR_S: equ $5c8d

; System varaible: current attribute (FBPPPIII)
ATTR_T: equ $5c8f

; ROM Routine similar to BASIC AT

LOCATE: equ $0dd9

CLS: equ $0daf

Main:
    ld  a, $0e                  ; A = colour attributes
    ld  hl, ATTR_T              ; HL = address current attributes
    ld (hl), a                  ; Load into memory
    ld hl, ATTR_S               ; HL = address permanent attributes
    ld (hl), a                  ; Load into memory

    call CLS                    ; Clear screen: use ATTR_S

    ld b, $18-$0a               ; B = Y coordinate
    ld c, $21-$03               ; C = X coordinate
    call LOCATE                 ; Position cursor

    ld hl, msg                  ; HL = message address

Loop:
    ld  a, (hl)                 ; A = string character
    or  a                       ; Does A = 0?
    jr  z, Exit                 ; If A = 0, skip
    rst $10                     ; Prints character
    inc hl                      ; HL = address of the next character
    jr Loop                     ; Loop until A = 0

Exit:
    jr Exit                     ; Infinite loop

msg: defm 'Hello ZX Spectrum Assembly', $00
; String ending in 0 = null

end $8000