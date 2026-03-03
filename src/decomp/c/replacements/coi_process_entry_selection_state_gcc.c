__asm__(
    ".globl _COI_ProcessEntrySelectionState\n"
    "_COI_ProcessEntrySelectionState:\n"
    "COI_ProcessEntrySelectionState:\n"
    "    BRA.W   COI_TestEntryWithinTimeWindow\n"
);
