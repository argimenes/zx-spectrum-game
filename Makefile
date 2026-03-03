# --- tools ---
PASMO   ?= flatpak-spawn --host /usr/bin/pasmo
ZESARUX ?= flatpak-spawn --host /usr/local/bin/zesarux

# --- emulator ---
MACHINE := 48k
ROMFILE := /usr/local/share/zesarux/roms/48.rom

# --- project ---
NAME := Main
SRC  := src/main.asm
OUTDIR := dist
TAP  := $(OUTDIR)/main.tap
LOG  := $(OUTDIR)/main.log

.PHONY: all build run debug clean

all: build

$(OUTDIR):
	mkdir -p $(OUTDIR)

# Build TAP + capture assembler log into dist/helloworld.log
build: | $(OUTDIR)
	$(PASMO) --name $(NAME) --tapbas $(SRC) $(TAP) --log > $(LOG) 2>&1
	@echo "Built: $(TAP)"
	@echo "Log:   $(LOG)"

# Run in ZEsarUX (basic)
run: build
	$(ZESARUX) --machine $(MACHINE) --romfile $(ROMFILE) --tape $(TAP)

# Run with ZEsarUX debugger visible (ZEsarUX has an integrated debugger)
debug: build
	$(ZESARUX) --machine $(MACHINE) --romfile $(ROMFILE) --tape $(TAP) --enabledebugger

clean:
	rm -rf $(OUTDIR)