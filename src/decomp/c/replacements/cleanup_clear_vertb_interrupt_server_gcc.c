__asm__(
    ".globl _CLEANUP_ClearVertbInterruptServer\n"
    "_CLEANUP_ClearVertbInterruptServer:\n"
    "    moveq   #5,%d0\n"
    "    movea.l _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,%a1\n"
    "    movea.l _AbsExecBase,%a6\n"
    "    jsr     _LVORemIntServer(%a6)\n"
    "    pea     0x0c.w\n"
    "    move.l  _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,-(%sp)\n"
    "    pea     57.w\n"
    "    pea     _Global_STR_CLEANUP_C_1\n"
    "    jsr     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory\n"
    "    lea     16(%sp),%sp\n"
    "    rts\n");
