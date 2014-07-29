# Tiva Makefile
# #####################################
#
# Inspired by the uCtools project
# uctools.github.com
#
#######################################
# user configuration:
#######################################
# TARGET: name of the output file
TARGET = main
# MCU: part number to build for
MCU = TM4C1294NCPDT
# TIVAWARE_PATH: path to tivaware folder
TIVAWARE_PATH = /home/giellamo/GccMode/
# SOURCES: list of input source sources
SOURCES = main.c startup_gcc.c pinout.c uartstdio.c
# VPATH
VPATH = src/ $(TIVAWARE_PATH)/utils $(TIVAWARE_PATH)/examples/boards/ek-tm4c1294xl/drivers
# INCLUDES: list of includes, by default, use Includes directory
INCLUDES = . $(TIVAWARE_PATH)/utils $(TIVAWARE_PATH)/examples/boards/ek-tm4c1294xl/
INC_PARAMS=$(foreach d, $(INCLUDES), -I$d)
# OUTDIR: directory to use for output
OUTDIR = build

# LD_SCRIPT: linker script
LD_SCRIPT = $(MCU).ld

# define flags
CFLAGS = -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS += -ffunction-sections -fdata-sections -MD -std=c99 -Wall
CFLAGS += -pedantic -DPART_$(MCU) -c -I$(TIVAWARE_PATH) $(INC_PARAMS)	
CFLAGS += -DTARGET_IS_TM4C129_RA0 -Dgcc
LDFLAGS = -T $(LD_SCRIPT) --entry ResetISR --gc-sections -ldriver -L$(TIVAWARE_PATH)/driverlib/gcc

#######################################
# end of user configuration
#######################################
#
#######################################
# binaries
#######################################
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
RM      = rm -f
MKDIR	= mkdir -p
#######################################

ifdef DEBUG
$(info DEBUG build)
CFLAGS+=-g -D DEBUG -O0
else
$(info RELEASE build)
CFLAGS+=-Os
endif

ifdef VERBOSE
Q = 
else
Q = @
endif

# list of object files, placed in the build directory regardless of source path
OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(SOURCES:.c=.o)))

# default: build bin
all: $(OUTDIR)/$(TARGET).bin

$(OUTDIR)/%.o: %.c | $(OUTDIR)
	@echo "\t[CC]\t\t $@"
	$(Q)$(CC) -o $@ $^ $(CFLAGS)

$(OUTDIR)/a.out: $(OBJECTS)
	@echo "\t[LD]\t\t ELF $@"
	$(Q)$(LD) -o $@ $^ $(LDFLAGS)

$(OUTDIR)/main.bin: $(OUTDIR)/a.out
	@echo "\t[OBJCOPY]\t $@"
	$(Q)$(OBJCOPY) -O binary $< $@

# create the output directory
$(OUTDIR):
	@echo "\t[MKDIR] $@"
	$(Q)$(MKDIR) $(OUTDIR)

clean:
	@echo "\t[CLEAN] $@"
	$(Q)-$(RM) $(OUTDIR)/*

.PHONY: all clean
