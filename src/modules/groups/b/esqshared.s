;!======

LAB_0BFC:
    JMP     LAB_1378

LAB_0BFD:
    JMP     LAB_02CE

LAB_0BFE:
    JMP     DST_UpdateBannerQueue

LAB_0BFF:
    JMP     LAB_18EF

LAB_0C00:
    JMP     LAB_18F5

LAB_0C01:
    JMP     LAB_03E0

ESQPARS_JMP_TBL_CLEANUP_ParseAlignedListingBlock:
LAB_0C02:
    JMP     CLEANUP_ParseAlignedListingBlock

LAB_0C03:
    JMP     LAB_14AF

JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1:
    JMP     GENERATE_CHECKSUM_BYTE_INTO_D0

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
