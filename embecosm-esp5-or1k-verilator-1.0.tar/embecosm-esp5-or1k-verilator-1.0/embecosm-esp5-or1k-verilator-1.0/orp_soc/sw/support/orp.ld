MEMORY
        {
        vectors : ORIGIN = 0x00000000, LENGTH = 0x00002000
        flash   : ORIGIN = 0x04000000, LENGTH = 0x00200000
        ram     : ORIGIN = 0x00002000, LENGTH = 0x001fe000
        icm     : ORIGIN = 0x00800000, LENGTH = 0x00004000
        }
 
SECTIONS
{
      .reset :
        {
        *(.reset)
        } > flash

        .text ALIGN(0x04):
        {
        *(.text)
        } > flash

      .rodata :
        {
        *(.rodata)
	*(.rodata.*)
        } > flash
 
      .dummy ALIGN(0x04):
        {
        _src_beg = .;
        } > flash
 
      .vectors :
        AT ( ADDR (.dummy) )
        {
        _vec_start = .;
        *(.vectors)
        _vec_end = .;
        } > vectors

     .icm :
        AT ( ADDR (.dummy) + SIZEOF (.vectors) )
        {
        _icm_start = .;
        *(.icm)
        _icm_end = .;
        } > icm

     .data :
        AT ( ADDR (.dummy) + SIZEOF (.vectors) + SIZEOF(.icm) )
        {
        _dst_beg = .;
        *(.data)
        _dst_end = .;
        } > ram
 
      .bss :
        {
        *(.bss)
        } > ram
 
      .stack (NOLOAD) :
        {
        *(.stack)
        _src_addr = .;
        } > ram

}
