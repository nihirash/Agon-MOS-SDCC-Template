    .area _CODE
    .globl _putchar
    .globl __putchar

    .globl _getchar
    .globl __getchar

    .ascii "MOS LIBRARY (c) Nihirash"

_putchar:
__putchar:
    ld hl, #2
    add hl, sp
    ld a, (hl)
    rst 0x10
    ret


_getchar:
__getchar:
    xor a
    rst 0x08
    ld l, a
    ret

