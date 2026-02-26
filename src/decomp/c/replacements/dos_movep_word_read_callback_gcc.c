/*
 * Target 083 GCC trial symbol.
 * Keep this as a raw code-label body because callers pass it as a callback/code pointer.
 */
__asm__(
    ".text\n\t"
    ".globl DOS_MovepWordReadCallback\n"
    "DOS_MovepWordReadCallback:\n\t"
    "movep.w 0(%a2),%d6\n\t"
    ".word 0x0000\n\t");
