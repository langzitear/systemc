MEMORY
        {
        flash   : ORIGIN = 0x04000000, LENGTH = 0x00100000
        vectors : ORIGIN = 0x00000800, LENGTH = 0x00000100 
        ram     : ORIGIN = 0x00002000, LENGTH = 0x00200000 - 0x00002000
        }
 
SECTIONS
{
        .reset :
        {
        *(.reset)
        } > flash
        .text :
        {
        *(.text)
        _src_beg = .;
        } > flash
        .vectors :
        AT ( ADDR (.text) + SIZEOF (.text))
        {
        _vec_start = .;
        *(.vectors)
        _vec_end = .;
        } > vectors
        .data :
        AT ( ADDR (.text) + SIZEOF (.text) + SIZEOF (.vectors))
        {
        _dst_beg = .;
        *(.data)
        _dst_end = .;
        } > ram
        .bss :
        {
        *(.bss)
        } > ram
}
