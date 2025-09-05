DeallocateMemory2 macro
    PEA     \4
    MOVE.L  \3,-(A7)
    PEA     \2
    PEA     \1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)
endm