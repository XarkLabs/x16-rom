
CORE_SOURCE_BASE ?= CBM
SERIAL_SOURCE_BASE ?= CBM
# for both also supported
# * OPENROMS

ifdef RELEASE_VERSION
	VERSION_DEFINE="-DRELEASE_VERSION=$(RELEASE_VERSION)"
endif
ifdef PRERELEASE_VERSION
	VERSION_DEFINE="-DPRERELEASE_VERSION=$(PRERELEASE_VERSION)"
endif

CC           = cc65
AS           = ca65
LD           = ld65

# global includes
ASFLAGS     += -I inc
# for monitor
ASFLAGS     += -D CPU_65C02=1
# KERNAL version number
ASFLAGS     +=  $(VERSION_DEFINE)
# put all symbols into .sym files
ASFLAGS     += -g

ASFLAGS     += -D MACHINE_X16=1
# all files are allowed to use 65SC02 features
ASFLAGS     += --cpu 65SC02

BUILD_DIR=build/x16

CFG_DIR=$(BUILD_DIR)/cfg

KERNAL_CORE_CBM_SOURCES = \
	kernal/cbm/editor.s \
	kernal/cbm/channel/channel.s \
	kernal/cbm/init.s \
	kernal/cbm/memory.s \
	kernal/cbm/nmi.s \
	kernal/cbm/irq.s \
	kernal/cbm/util.s

KERNAL_SERIAL_CBM_SOURCES = \
	kernal/cbm/serial.s

KERNAL_SERIAL_OPENROMS_SOURCES = # TODO

KERNAL_CORE_OPENROMS_SOURCES = \
	kernal/open-roms/open-roms.s

KERNAL_CORE_SOURCES = \
	kernal/declare.s \
	kernal/vectors.s \
	kernal/kbdbuf.s \
	kernal/memory.s \
	kernal/lzsa.s \
	kernal/signature.s

ifeq ($(CORE_SOURCE_BASE),CBM)
	KERNAL_CORE_SOURCES += $(KERNAL_CORE_CBM_SOURCES)
else ifeq ($(CORE_SOURCE_BASE),OPENROMS)
	KERNAL_CORE_SOURCES += $(KERNAL_CORE_OPENROMS_SOURCES)
else
$(error Illegal value for CORE_SOURCE_BASE)
endif

ifeq ($(SERIAL_SOURCE_BASE),CBM)
	KERNAL_CORE_SOURCES += $(KERNAL_SERIAL_CBM_SOURCES)
else
	KERNAL_CORE_SOURCES += $(KERNAL_SERIAL_OPENROMS_SOURCES)
endif

KERNAL_GRAPH_SOURCES = \
	kernal/graph/graph.s \
	kernal/fonts/fonts.s \
	kernal/graph/console.s


KERNAL_DRIVER_SOURCES = \
	kernal/drivers/x16/x16.s \
	kernal/drivers/x16/memory.s \
	kernal/drivers/x16/screen.s \
	kernal/drivers/x16/ps2kbd.s \
	kernal/drivers/x16/ps2mouse.s \
	kernal/drivers/x16/joystick.s \
	kernal/drivers/x16/clock.s \
	kernal/drivers/x16/rs232.s \
	kernal/drivers/x16/framebuffer.s \
	kernal/drivers/x16/sprites.s \
	kernal/drivers/x16/entropy.s \
	kernal/drivers/x16/beep.s \
	kernal/drivers/x16/i2c.s \
	kernal/drivers/x16/smc.s \
	kernal/drivers/x16/rtc.s \
	kernal/drivers/generic/softclock_timer.s

KERNAL_SOURCES = \
	$(KERNAL_CORE_SOURCES) \
	$(KERNAL_DRIVER_SOURCES)

KERNAL_SOURCES += \
	$(KERNAL_GRAPH_SOURCES) \
	kernal/ieee_switch.s

KEYMAP_SOURCES = \
	keymap/keymap.s

DOS_SOURCES = \
	dos/fat32/fat32.s \
	dos/fat32/mkfs.s \
	dos/fat32/sdcard.s \
	dos/fat32/text_input.s \
	dos/zeropage.s \
	dos/jumptab.s \
	dos/main.s \
	dos/match.s \
	dos/file.s \
	dos/cmdch.s \
	dos/dir.s \
	dos/parser.s \
	dos/functions.s

FAT32_SOURCES = \
	fat32/main.s

BASIC_SOURCES= \
	kernsup/kernsup_basic.s \
	basic/basic.s \
	math/math.s

MONITOR_SOURCES= \
	kernsup/kernsup_monitor.s \
	monitor/monitor.s \
	monitor/io.s \
	monitor/asm.s

CHARSET_SOURCES= \
	charset/petscii.s \
	charset/iso-8859-15.s \
	charset/petscii2.s \
	charset/iso-8859-15_2.s

GRAPH_SOURCES= \
	graphics/jmptbl.s \
	graphics/kernal.s \
	graphics/graph/graph.s \
	graphics/fonts/fonts.s \
	graphics/graph/console.s \
	graphics/drivers/framebuffer.s \
	graphics/drivers/fb_vectors.s

DEMO_SOURCES= \
	demo/test.s

AUDIO_SOURCES= \
	kernsup/kernsup_audio.s \
	audio/main.s \
	audio/memory.s \
	audio/basic.s \
	audio/fm.s \
	audio/psg.s \
	audio/fmpatchtables.s \
	audio/noteconvert.s \
	audio/audio_luts.s \
	audio/playstring.s

UTIL_SOURCES= \
	kernsup/kernsup_util.s \
	util/main.s \
	util/menu.s \
	util/control.s

BANNEX_SOURCES= \
	kernsup/kernsup_bannex.s \
	bannex/main.s \
	bannex/renumber.s \
	bannex/sleep_cont.s \
	bannex/screen_default_color_from_nvram.s \
	bannex/help.s \
	bannex/splash.s

GENERIC_DEPS = \
	inc/kernal.inc \
	inc/mac.inc \
	inc/io.inc \
	inc/fb.inc \
	inc/banks.inc \
	inc/jsrfar.inc \
	inc/regs.inc \
	kernsup/kernsup.inc

KERNAL_DEPS = \
	$(GENERIC_DEPS) \
	$(GIT_SIGNATURE)

KEYMAP_DEPS = \
	$(GENERIC_DEPS)

DOS_DEPS = \
	$(GENERIC_DEPS) \
	dos/fat32/fat32.inc \
	dos/fat32/lib.inc \
	dos/fat32/regs.inc \
	dos/fat32/sdcard.inc \
	dos/fat32/text_input.inc \
	dos/functions.inc \
	dos/vera.inc

FAT32_DEPS = \
	$(GENERIC_DEPS)

BASIC_DEPS= \
	$(GENERIC_DEPS) \
	math/math.inc \
	$(GIT_SIGNATURE)

MONITOR_DEPS= \
	$(GENERIC_DEPS) \
	monitor/kernal.i

CHARSET_DEPS= \
	$(GENERIC_DEPS)

AUDIO_DEPS= \
	$(GENERIC_DEPS)

UTIL_DEPS= \
	$(GENERIC_DEPS)

BANNEX_DEPS= \
	$(GENERIC_DEPS)


KERNAL_OBJS  = $(addprefix $(BUILD_DIR)/, $(KERNAL_SOURCES:.s=.o))
KEYMAP_OBJS  = $(addprefix $(BUILD_DIR)/, $(KEYMAP_SOURCES:.s=.o))
DOS_OBJS     = $(addprefix $(BUILD_DIR)/, $(DOS_SOURCES:.s=.o))
FAT32_OBJS   = $(addprefix $(BUILD_DIR)/, $(FAT32_SOURCES:.s=.o))
BASIC_OBJS   = $(addprefix $(BUILD_DIR)/, $(BASIC_SOURCES:.s=.o))
MONITOR_OBJS = $(addprefix $(BUILD_DIR)/, $(MONITOR_SOURCES:.s=.o))
CHARSET_OBJS = $(addprefix $(BUILD_DIR)/, $(CHARSET_SOURCES:.s=.o))
GRAPH_OBJS   = $(addprefix $(BUILD_DIR)/, $(GRAPH_SOURCES:.s=.o))
DEMO_OBJS    = $(addprefix $(BUILD_DIR)/, $(DEMO_SOURCES:.s=.o))
AUDIO_OBJS   = $(addprefix $(BUILD_DIR)/, $(AUDIO_SOURCES:.s=.o))
UTIL_OBJS    = $(addprefix $(BUILD_DIR)/, $(UTIL_SOURCES:.s=.o))
BANNEX_OBJS  = $(addprefix $(BUILD_DIR)/, $(BANNEX_SOURCES:.s=.o))

BANK_BINS = \
	$(BUILD_DIR)/kernal.bin \
	$(BUILD_DIR)/keymap.bin \
	$(BUILD_DIR)/dos.bin \
	$(BUILD_DIR)/fat32.bin \
	$(BUILD_DIR)/basic.bin \
	$(BUILD_DIR)/monitor.bin \
	$(BUILD_DIR)/charset.bin \
	$(BUILD_DIR)/codex.bin \
	$(BUILD_DIR)/graph.bin \
	$(BUILD_DIR)/demo.bin \
	$(BUILD_DIR)/audio.bin \
	$(BUILD_DIR)/util.bin \
	$(BUILD_DIR)/bannex.bin

ROM_LABELS=$(BUILD_DIR)/rom_labels.h
ROM_LST=$(BUILD_DIR)/rom_lst.h
GIT_SIGNATURE=$(BUILD_DIR)/../signature.bin

all: $(BUILD_DIR)/rom.bin $(ROM_LABELS) $(ROM_LST)

$(BUILD_DIR)/rom.bin: $(BANK_BINS)
	cat $(BANK_BINS) > $@

clean:
	rm -f $(GIT_SIGNATURE)
	rm -rf $(BUILD_DIR)
	$(MAKE) -C codex clean

$(GIT_SIGNATURE): FORCE
	@mkdir -p $(BUILD_DIR)
	git diff --quiet && /bin/echo -n $$( (git rev-parse --short=8 HEAD || /bin/echo "00000000") | tr '[:lower:]' '[:upper:]') > $(GIT_SIGNATURE) \
	|| /bin/echo -n $$( /bin/echo -n $$(git rev-parse --short=7 HEAD || echo "0000000") | tr '[:lower:]' '[:upper:]'; /bin/echo -n '+') > $(GIT_SIGNATURE)

FORCE:

$(BUILD_DIR)/%.cfg: %.cfgtpl
	@mkdir -p $$(dirname $@)
	$(CC) -E $< -o $@

# TODO: Need a way to control lst file generation through a configuration variable.
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $$(dirname $@)
	$(AS) $(ASFLAGS) -l $(BUILD_DIR)/$*.lst $< -o $@


# TODO: Need a way to control relist generation; don't try to do it if lst files haven't been generated!
# Bank 0 : KERNAL
$(BUILD_DIR)/kernal.bin: $(GIT_SIGNATURE) $(KERNAL_OBJS) $(KERNAL_DEPS) $(CFG_DIR)/kernal-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/kernal-x16.cfg $(KERNAL_OBJS) -o $@ -m $(BUILD_DIR)/kernal.map -Ln $(BUILD_DIR)/kernal.sym
	./scripts/relist.py $(BUILD_DIR)/kernal.map $(BUILD_DIR)/kernal

# Bank 1 : KEYMAP
$(BUILD_DIR)/keymap.bin: $(KEYMAP_OBJS) $(KEYMAP_DEPS) $(CFG_DIR)/keymap-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/keymap-x16.cfg $(KEYMAP_OBJS) -o $@ -m $(BUILD_DIR)/keymap.map -Ln $(BUILD_DIR)/keymap.sym

# Bank 2 : DOS
$(BUILD_DIR)/dos.bin: $(DOS_OBJS) $(DOS_DEPS) $(CFG_DIR)/dos-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/dos-x16.cfg $(DOS_OBJS) -o $@ -m $(BUILD_DIR)/dos.map -Ln $(BUILD_DIR)/dos.sym
	./scripts/relist.py $(BUILD_DIR)/dos.map $(BUILD_DIR)/dos

# Bank 3 : FAT32
$(BUILD_DIR)/fat32.bin: $(FAT32_OBJS) $(FAT32_DEPS) $(CFG_DIR)/fat32-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/fat32-x16.cfg $(FAT32_OBJS) -o $@ -m $(BUILD_DIR)/fat32.map -Ln $(BUILD_DIR)/fat32.sym
	./scripts/relist.py $(BUILD_DIR)/fat32.map $(BUILD_DIR)/fat32

# Bank 4 : BASIC
$(BUILD_DIR)/basic.bin: $(GIT_SIGNATURE) $(BASIC_OBJS) $(BASIC_DEPS) $(CFG_DIR)/basic-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/basic-x16.cfg $(BASIC_OBJS) -o $@ -m $(BUILD_DIR)/basic.map -Ln $(BUILD_DIR)/basic.sym `${BUILD_DIR}/../../findsymbols ${BUILD_DIR}/kernal.sym shflag mode`
	./scripts/relist.py $(BUILD_DIR)/basic.map $(BUILD_DIR)/basic

# Bank 5 : MONITOR
$(BUILD_DIR)/monitor.bin: $(MONITOR_OBJS) $(MONITOR_DEPS) $(CFG_DIR)/monitor-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/monitor-x16.cfg $(MONITOR_OBJS) -o $@ -m $(BUILD_DIR)/monitor.map -Ln $(BUILD_DIR)/monitor.sym `${BUILD_DIR}/../../findsymbols ${BUILD_DIR}/kernal.sym mode`
	./scripts/relist.py $(BUILD_DIR)/monitor.map $(BUILD_DIR)/monitor

# Bank 6 : CHARSET
$(BUILD_DIR)/charset.bin: $(CHARSET_OBJS) $(CHARSET_DEPS) $(CFG_DIR)/charset-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/charset-x16.cfg $(CHARSET_OBJS) -o $@ -m $(BUILD_DIR)/charset.map -Ln $(BUILD_DIR)/charset.sym

# Bank 7 : CodeX
$(BUILD_DIR)/codex.bin: $(CFG_DIR)/codex-x16.cfg
	$(MAKE) -C codex

# Bank 8 : Graphics
$(BUILD_DIR)/graph.bin: $(GRAPH_OBJS) $(KERNAL_DEPS) $(CFG_DIR)/graph.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/graph.cfg $(GRAPH_OBJS) -o $@ -m $(BUILD_DIR)/graph.map -Ln $(BUILD_DIR)/graph.sym `${BUILD_DIR}/../../findsymbols ${BUILD_DIR}/kernal.sym ptr_fg` `${BUILD_DIR}/../../findsymbols ${BUILD_DIR}/kernal.sym -p k_ kbdbuf_get sprite_set_image sprite_set_position`

# Bank 9 : DEMO
$(BUILD_DIR)/demo.bin: $(DEMO_OBJS) $(DEMO_DEPS) $(CFG_DIR)/demo-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/demo-x16.cfg $(DEMO_OBJS) -o $@ -m $(BUILD_DIR)/demo.map -Ln $(BUILD_DIR)/demo.sym
	./scripts/relist.py $(BUILD_DIR)/demo.map $(BUILD_DIR)/demo

# Bank A : Audio
$(BUILD_DIR)/audio.bin: $(AUDIO_OBJS) $(AUDIO_DEPS) $(CFG_DIR)/audio-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/audio-x16.cfg $(AUDIO_OBJS) -o $@ -m $(BUILD_DIR)/audio.map -Ln $(BUILD_DIR)/audio.sym
	./scripts/relist.py $(BUILD_DIR)/audio.map $(BUILD_DIR)/audio

# Bank B : Utilities
$(BUILD_DIR)/util.bin: $(UTIL_OBJS) $(UTIL_DEPS) $(CFG_DIR)/util-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/util-x16.cfg $(UTIL_OBJS) -o $@ -m $(BUILD_DIR)/util.map -Ln $(BUILD_DIR)/util.sym
	./scripts/relist.py $(BUILD_DIR)/util.map $(BUILD_DIR)/util

# Bank C : BASIC Annex
$(BUILD_DIR)/bannex.bin: $(BANNEX_OBJS) $(BANNEX_DEPS) $(CFG_DIR)/bannex-x16.cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C $(CFG_DIR)/bannex-x16.cfg $(BANNEX_OBJS) -o $@ -m $(BUILD_DIR)/bannex.map -Ln $(BUILD_DIR)/bannex.sym
	./scripts/relist.py $(BUILD_DIR)/bannex.map $(BUILD_DIR)/bannex


$(BUILD_DIR)/rom_labels.h: $(BANK_BINS)
	./scripts/symbolize.sh 0 build/x16/kernal.sym   > $@
	./scripts/symbolize.sh 1 build/x16/keymap.sym  >> $@
	./scripts/symbolize.sh 2 build/x16/dos.sym     >> $@
	./scripts/symbolize.sh 3 build/x16/fat32.sym   >> $@
	./scripts/symbolize.sh 4 build/x16/basic.sym   >> $@
	./scripts/symbolize.sh 5 build/x16/monitor.sym >> $@
	./scripts/symbolize.sh 6 build/x16/charset.sym >> $@
	./scripts/symbolize.sh A build/x16/audio.sym   >> $@
	./scripts/symbolize.sh B build/x16/util.sym    >> $@
	./scripts/symbolize.sh C build/x16/bannex.sym  >> $@

$(BUILD_DIR)/rom_lst.h: $(BANK_BINS)
	./scripts/trace_lst.py 0 `find build/x16/kernal/ -name \*.rlst`   > $@
	./scripts/trace_lst.py 2 `find build/x16/dos/ -name \*.rlst`     >> $@
	./scripts/trace_lst.py 3 `find build/x16/fat32/ -name \*.rlst`   >> $@
	./scripts/trace_lst.py 4 `find build/x16/basic/ -name \*.rlst`   >> $@
	./scripts/trace_lst.py 5 `find build/x16/monitor/ -name \*.rlst` >> $@
	./scripts/trace_lst.py A `find build/x16/audio/ -name \*.rlst`   >> $@
	./scripts/trace_lst.py B `find build/x16/util/ -name \*.rlst`    >> $@
	./scripts/trace_lst.py C `find build/x16/bannex/ -name \*.rlst`  >> $@
