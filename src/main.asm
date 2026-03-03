; helloworld.asm
; Minimal ZX Spectrum "Hello World" using ROM RST 16 (print char in A)
; Assemble with:
;   pasmo --name HelloWorld --tapbas helloworld.asm helloworld.tap --log

        ORG     32768           ; common start address for machine-code programs

Start:
        LD      HL, Message
PrintLoop:
        LD      A, (HL)
        OR      A               ; sets Z if A == 0 (end of string)
        JR      Z, Done
        RST     16              ; ROM routine: print char in A
        INC     HL
        JR      PrintLoop

Done:
        RET                     ; return to BASIC

Message:
        DEFM    "HELLO King Cat!"
        DEFB    13              ; newline (ENTER)
        DEFB    0               ; string terminator (our loop stops on 0)

END     32768