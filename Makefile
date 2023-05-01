rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRC=$(call rwildcard,src,*.h) src/main.c
INC=$(call rwildcard,include,*.h) $(call rwildcard,src,*.h)
MOSLIBSRC=$(call rwildcard,include,*.s)

CRT=out/crt0.rel
MOSLIB=out/mos.rel

CC=sdcc
LD=sdcc
AS=sdasz80
CLD=sdldz80
OBJCPY=sdobjcopy

ASFLAGS=-plosgff
CFLAGS=-mez80_z80 -Iinclude/ -Isrc/include/ --reserve-regs-iy --std-c11 --fomit-frame-pointer
CLINK=--no-std-crt0 -mez80_z80 --code-loc 100

all: a.bin

$(CRT): crt/crt0.s
		$(AS) $(ASFLAGS) -o $(CRT) crt/crt0.s

$(MOSLIB): $(MOSLIBSRC)
		$(AS) $(ASFLAGS) -o $(MOSLIB) lib/mos.s

a.bin: $(SRC) $(INC) $(CRT) $(MOSLIB) 
		$(CC) $(CFLAGS) $(MOSLIB) src/main.c -o out/main.ihx
		$(LD) $(CLINK) $(CRT) $(MOSLIB) out/main.rel -o out/a.ihx
		$(CLD) -nf out/a.lk
		$(OBJCPY) -I ihex -O binary out/a.ihx main.bin

clean:
		rm -rf out/*.* out/*  main.bin