MEMORY
        {
        reset   : ORIGIN = 0x00000000, LENGTH = 0x00000200 
        vectors : ORIGIN = 0x00000800, LENGTH = 0x00000100 
        ram     : ORIGIN = 0x00002000, LENGTH = 0x00200000 - 0x00002000
        }
 
SECTIONS
{
        .reset :
        {
        *(.reset)
        } > reset

        .vectors :
        {
        *(.vectors)
        } > vectors

        .text :
        {
        *(.text)
        } > ram

        .data :
        {
        *(.data)
        } > ram

        .bss :
        {
        *(.bss)
        } > ram
}
