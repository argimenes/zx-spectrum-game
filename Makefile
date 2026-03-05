# Cross-platform Makefile for assembling a ZX Spectrum TAP with Pasmo and (optionally) running it in ZEsarUX.
#
# Supported environments:
# - Windows: use Git Bash (or WSL) in VS Code/VS Codium so POSIX tools like rm/mkdir are available.
# - Linux: works both on host installs and in VS Codium/VS Code Flatpak terminals (uses flatpak-spawn --host when available).
# - macOS: works with host installs (Homebrew/MacPorts/etc).
#
# You can override any variable at the command line, e.g.:
#   make build PASMO_BIN=/path/to/pasmo
#   make run  ZESARUX_BIN=/path/to/zesarux ROMFILE=

SHELL := /bin/sh

# --- Flatpak host escape (Linux VS Codium/VS Code Flatpak) ---
FLATPAK_SPAWN := $(shell command -v flatpak-spawn 2>/dev/null)

ifeq ($(FLATPAK_SPAWN),)
HOST :=
else
HOST := flatpak-spawn --host
endif

# --- tools (override these if needed) ---
PASMO_BIN   ?= pasmo
ifeq ($(OS),Windows_NT)
PASMO_BIN := /c/Tools/pasmo/pasmo.exe
endif
ZESARUX_BIN ?= zesarux
ifeq ($(OS),Windows_NT)
PASMO_BIN := /c/Tools/pasmo/pasmo.exe
endif
ifeq ($(OS),Windows_NT)
ZESARUX_BIN := /c/Tools/zesarux/zesarux.exe
endif

PASMO   ?= $(HOST) $(PASMO_BIN)
ZESARUX ?= $(HOST) $(ZESARUX_BIN)

# --- emulator ---
MACHINE ?= 48k

# Default ROM path for many Linux installs; leave blank to let ZEsarUX use its own defaults/config.
ROMFILE ?= /usr/local/share/zesarux/roms/48.rom
ROMFILE_EXISTS := $(wildcard $(ROMFILE))
ROMFLAG := $(if $(ROMFILE_EXISTS),--romfile $(ROMFILE),)

# --- project ---
NAME   ?= ZX-Pong
SRCDIR ?= src/pong/step01
SRC    ?= $(SRCDIR)/main.asm
OUTDIR ?= dist
TAP    ?= $(OUTDIR)/pong.tap
LOG    ?= $(OUTDIR)/pong.log

.PHONY: all build run debug clean

all: build

$(OUTDIR):
	mkdir -p $(OUTDIR)

# Build TAP + capture assembler log into dist/pong.log
build: | $(OUTDIR)
	cd $(SRCDIR)
	$(PASMO) -I $(SRCDIR) --name $(NAME) --tapbas $(SRC) $(TAP) --log > $(LOG) 2>&1
	@echo "Built: $(TAP)"
	@echo "Log:   $(LOG)"

# Run in ZEsarUX (basic)
run: build
	$(ZESARUX) --machine $(MACHINE) $(ROMFLAG) --tape $(TAP)

# Run with ZEsarUX debugger visible (ZEsarUX has an integrated debugger)
debug: build
	$(ZESARUX) --machine $(MACHINE) $(ROMFLAG) --tape $(TAP) --enabledebugger

clean:
	rm -rf $(OUTDIR)
