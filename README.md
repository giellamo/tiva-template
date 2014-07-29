Tiva Template
==================


You will need an ARM bare-metal toolchain to build code for Tiva targets.
You can get a toolchain from the
[gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded) project that is
pre-built for your platform. Extract the package and add the `bin` folder to
your PATH.

The TivaWare package contains all of the header files and drivers for
Tiva parts. Grab the file *SW-TM4C-1.1.exe* from
[here](http://software-dl.ti.com/tiva-c/SW-TM4C/latest/index_FDS.html) and unzip it into a directory
then run `make` to build TivaWare.

    mkdir tivaware
    cd tivaware
    unzip SW-TM4C-1.1.exe
    make

Note: for the Tiva Connected Launchpad get [SW-EK-TM4C1294XL-2.1.0.12573.exe](http://www.ti.com/tool/sw-ek-tm4c1294xl).

## Writing and Building Firmware

1. Clone the
   [tiva-template](https://github.com/uctools/tiva-template)
   repository (or fork it and clone your own repository).

	git clone git@github.com:uctools/tiva-template

2. Modify the Makefile:
    * Set TARGET to the desired name of the output file (eg: TARGET = main)
    * Set SOURCES to a list of your sources (eg: SOURCES = main.c
      startup\_gcc.c)
    * Set TIVAWARE\_PATH to the full path to where you extracted and built
      TivaWare (eg: TIVAWARE_PATH = /home/eric/code/tivaware)

3. Run `make`

4. The output files will be created in the 'build' folder

## Flashing

The easiest way to flash your device is using lm4flash. First, grab lm4tools
from Git.

    git clone git://github.com/utzig/lm4tools.git

Then build lm4flash and run it:

    cd lm4tools/lm4flash
    make
    lm4flash /path/to/executable.bin

## Debugging with gdb

[Karl Palsson just posted](http://sourceforge.net/p/openocd/mailman/message/32139143/) support for
the board in openocd. Instructions to build openocd using his patch:
```
git clone http://openocd.zylin.com/openocd
cd openocd
git fetch http://openocd.zylin.com/openocd refs/changes/63/2063/1
git checkout FETCH_HEAD
git submodule init
git submodule update
./bootstrap
./configure --enable-ti-icdi --prefix=`pwd`/..
make -j3
make install
```

Then run gdb with this command:
```
arm-none-eabi-gdb -ex 'target extended-remote | openocd -f board/ek-tm4c1294xl.cfg -c "gdb_port pipe; log_output openocd.log"; monitor reset; monitor halt'
```
lmicdi can also support gdb but it appears openocd has better support for breakpoints and source-level debugging right now. You may want to check back later for updates on the situation.

## Credits

Thanks to Recursive Labs for their
[guide](http://recursive-labs.com/blog/2012/10/28/stellaris-launchpad-gnu-linux-getting-started/)
which this template is based on.

Thanks to [Rob Stoddard](http://www.robstoddard.com/stellaris.php) for digging into the issue on soft FP versus hardware FP.
