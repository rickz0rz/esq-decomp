__asm__(
    ".globl _COI_SelectAnimFieldPointer\n"
    "_COI_SelectAnimFieldPointer:\n"
    "COI_SelectAnimFieldPointer:\n"
    "    BRA.W   COI_GetAnimFieldPointerByMode\n"
);
