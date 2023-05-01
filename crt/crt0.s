   	.module crt0
    .globl _main

    .area _HEADER (ABS)
    .org 0x00
    jp init

    .org 0x08
    .db 0x49    ;; LIS prefix
    rst 0x08
    ret

    .org 0x10
    .db 0x49    ;; LIS prefix
    rst 0x10
    ret

    .org 0x18
    .db 0x49    ;; LIS prefix
    rst 0x18
    ret

    .org 0x38
    ei
    reti 

    .org 0x40   ;; HEADER
    .db "M"
    .db "O"
    .db "S"
    .db 0
    .db 0


init:
    .db 0x5b ;; LIL prefix
    push ix

    .db 0x5b
    push iy ;; .LIL

    call	gsinit
    call _main


    .db 0x5b ;; LIL prefix
    pop iy

    .db 0x5b ;; LIL prefix
    pop ix

    .db 0x5b ;; LIL prefix
    ld hl, #0
    .db 0

    .db 0x49 ;; LIS prefix
    ret
    

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
	.area	_INITIALIZER
	.area   _GSINIT
	.area   _GSFINAL

	.area	_DATA
	.area	_INITIALIZED
	.area	_BSEG
	.area   _BSS
	.area   _HEAP

	.area   _CODE

	.area   _GSINIT
gsinit::

	; Default-initialized global variables.
        ld      bc, #l__DATA
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      hl, #s__DATA
        ld      (hl), #0x00
        dec     bc
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      e, l
        ld      d, h
        inc     de
        ldir
zeroed_data:

	; Explicitly initialized global variables.
	ld	bc, #l__INITIALIZER
	ld	a, b
	or	a, c
	jr	Z, gsinit_next
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER
	ldir

gsinit_next:

	.area   _GSFINAL
	ret


