
MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x00100000
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00040000
}

STACK_SIZE   = 2048;

SECTIONS
{
    .text :
    {
        _text = .;
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        _etext = .;
    } > FLASH

    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        _data = .;
        *(vtable)
        *(.data*)
        _edata = .;
    } > SRAM

    .bss :
    {
        _bss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > SRAM
    
    .guard : {
    	__guard_start_ =  . ;
    	
    	. += 32;
    	
    	__guard_end_ =  . ;
    }
    
    .stack : {
        __stack_start__ = . ;
        
        . += STACK_SIZE;
        . = ALIGN (4);
        
        __stack_end__ = .;
    } >SRAM
    
}
