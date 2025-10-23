; ========== GCOMMAND.c ==========

LAB_1F66:
    NStr    "DF0:Digital_Niche.dat"
GLOB_STR_GCOMMAND_C_1:
    NStr    "GCOMMAND.c"
LAB_1F68:
    NStr    "DF0:Digital_Niche.dat"
LAB_1F69:
    DS.W    1
LAB_1F6A:
    NStr    "DF0:Digital_Mplex.dat"
GLOB_STR_GCOMMAND_C_2:
    NStr    "GCOMMAND.c"
LAB_1F6C:
    NStr    "%T"
LAB_1F6D:
    NStr    "DF0:Digital_Mplex.dat"
LAB_1F6E:
    DC.L    $12001200
LAB_1F6F:
    DS.W    1
LAB_1F70:
    NStr    "%T"
LAB_1F71:
    NStr    "DF0:Digital_PPV3.dat"
LAB_1F72:
    NStr    "DF0:Digital_PPV.dat"
LAB_1F73:
    NStr    "DF0:Digital_PPV.dat"
GLOB_STR_GCOMMAND_C_3:
    NStr    "GCOMMAND.c"
LAB_1F75:
    NStr    "DF0:Digital_PPV3.dat"
LAB_1F76:
    DC.L    $12001200
LAB_1F77:
    DS.L    1
    DC.L    $00000067,$00000069,$00000072,$00000073
    DC.L    $00000074,$00000075,$00000076,$00000077
    DC.L    $00000078,$00000079,$0000007a,$000000c9
    DC.L    $000000ca,$000000cb,$000000cc,$000000cd
    DC.L    $000000ce,$000000cf,$000000d1,$000000d2
    DC.L    $000000d3,$000000d4,$000000d5,$000000d6
    DC.L    $000000d7,$000000d8,$000000d9,$000000da
    DC.L    $000000db,$000000dc,$000000dd,$000000de
    DC.L    $000000df,$000000e0,$000000e1,$000000e2
    DC.L    $000000e8,$ffffffff
LAB_1F78:
    NStr    "NO_FREE_STORE"
LAB_1F79:
    NStr    "TASK_TABLE_FULL"
LAB_1F7A:
    NStr    "BAD_TEMPLATE"
LAB_1F7B:
    NStr    "BAD_NUMBER"
LAB_1F7C:
    NStr    "REQUIRED_ARG_MISSING"
LAB_1F7D:
    NStr    "KEY_NEEDS_ARG"
LAB_1F7E:
    NStr    "TOO_MANY_ARGS"
LAB_1F7F:
    NStr    "UNMATCHED_QUOTES"
LAB_1F80:
    NStr    "LINE_TOO_LONG"
LAB_1F81:
    NStr    "FILE_NOT_OBJECT"
LAB_1F82:
    NStr    "INVALID_RESIDENT_LIBRARY"
LAB_1F83:
    NStr    "NO_DEFAULT_DIR"
LAB_1F84:
    NStr    "OBJECT_IN_USE"
LAB_1F85:
    NStr    "OBJECT_EXISTS"
LAB_1F86:
    NStr    "DIR_NOT_FOUND"
LAB_1F87:
    NStr    "OBJECT_NOT_FOUND"
LAB_1F88:
    NStr    "BAD_STREAM_NAME"
LAB_1F89:
    NStr    "OBJECT_TOO_LARGE"
LAB_1F8A:
    NStr    "ACTION_NOT_KNOWN"
LAB_1F8B:
    NStr    "INVALID_COMPONENT_NAME"
LAB_1F8C:
    NStr    "INVALID_LOCK"
LAB_1F8D:
    NStr    "OBJECT_WRONG_TYPE"
LAB_1F8E:
    NStr    "DISK_NOT_VALIDATED"
LAB_1F8F:
    NStr    "DISK_WRITE_PROTECTED"
LAB_1F90:
    NStr    "RENAME_ACROSS_DEVICES"
LAB_1F91:
    NStr    "DIRECTORY_NOT_EMPTY"
LAB_1F92:
    NStr    "TOO_MANY_LEVELS"
LAB_1F93:
    NStr    "DEVICE_NOT_MOUNTED"
LAB_1F94:
    NStr    "SEEK_ERROR"
LAB_1F95:
    NStr    "COMMENT_TOO_BIG"
LAB_1F96:
    NStr    "DISK_FULL"
LAB_1F97:
    NStr    "DELETE_PROTECTED"
LAB_1F98:
    NStr    "WRITE_PROTECTED"
LAB_1F99:
    NStr    "READ_PROTECTED"
LAB_1F9A:
    NStr    "NOT_A_DOS_DISK"
LAB_1F9B:
    NStr    "NO_DISK"
LAB_1F9C:
    NStr    "NO_MORE_ENTRIES"
LAB_1F9D:
    NStr    "UNKNOWN!"

    DC.L    LAB_1F78
    DC.L    LAB_1F79
    DC.L    LAB_1F7A
    DC.L    LAB_1F7B
    DC.L    LAB_1F7C
    DC.L    LAB_1F7D
    DC.L    LAB_1F7E
    DC.L    LAB_1F7F
    DC.L    LAB_1F80
    DC.L    LAB_1F81
    DC.L    LAB_1F82
    DC.L    LAB_1F83
    DC.L    LAB_1F84
    DC.L    LAB_1F85
    DC.L    LAB_1F86
    DC.L    LAB_1F87
    DC.L    LAB_1F88
    DC.L    LAB_1F89
    DC.L    LAB_1F8A
    DC.L    LAB_1F8B
    DC.L    LAB_1F8C
    DC.L    LAB_1F8D
    DC.L    LAB_1F8E
    DC.L    LAB_1F8F
    DC.L    LAB_1F90
    DC.L    LAB_1F91
    DC.L    LAB_1F92
    DC.L    LAB_1F93
    DC.L    LAB_1F94
    DC.L    LAB_1F95
    DC.L    LAB_1F96
    DC.L    LAB_1F97
    DC.L    LAB_1F98
    DC.L    LAB_1F99
    DC.L    LAB_1F9A
    DC.L    LAB_1F9B
    DC.L    LAB_1F9C
    DC.L    LAB_1F9D

LAB_1F9E:
    NStr    "GFX:"
LAB_1F9F:
    NStr    "WORK:"
LAB_1FA0:
    NStr    "COPY >NIL: GFX:LOGO.LST DH2: CLONE"
LAB_1FA1:
    NStr    "COPY >NIL: GFX:#? WORK: CLONE ALL"
LAB_1FA2:
    DC.L    $00030000
    DS.L    14
    DC.L    $00000aaa
    DS.L    15
    DC.L    $01110000
    DS.L    14
    DC.L    $00000cc0
    DS.L    15
    DC.L    $05120512,$04000500,$06000700,$08000900
    DC.L    $0a000b00,$0b110b22,$0b330b44,$0b550b66
    DC.L    $0b770f44,$0f550f66,$0f770f88,$0f990faa
    DC.L    $0fbb0fcc,$0fdd0fff,$01000200,$0300016a
    DC.L    $016a0075,$00860187,$01970298,$03a903ba
    DC.L    $04bb05cc,$06cc07dd,$08de09de,$0aef0f0f
    DC.L    $0f1f0f2f,$0f3f0f4f,$0f5f0f6f,$0f7f0f8f
    DC.L    $0f9f0faf,$0fbf0fcf,$0fdf0fff,$05550555
    DC.L    $01010202,$03030404,$05050606,$07070808
    DC.L    $09090a0a,$0b0b0c0c,$0d0d0e0e,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0003,$00030116
    DC.L    $01170118,$0119011a,$011b011c,$011d011e
    DC.L    $011f022f,$033f044f,$055f066f,$066f077f
    DC.L    $088f099f,$0aaf0bbf,$0ccf0ddf,$0fff0001
    DC.L    $00020003,$00040005
    DS.L    1
    DC.L    $04140515,$06260727,$08280929,$09390a3a
    DC.L    $0b3b0b3c,$0b4c0b4d,$0b5d0b5e,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
    DS.L    1
    DC.L    $01200131,$01410252,$02620373,$04840594
    DC.L    $05950696,$07a708b8,$09b90aca,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
    DS.L    1
    DC.L    $01200131,$01410252,$02620373,$04840594
    DC.L    $05950696,$07a708b8,$09b90aca,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
    DS.L    1
    DC.L    $01200131,$01410252,$02620373,$04840594
    DC.L    $05950696,$07a708b8,$09b90aca,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
LAB_1FA3:
    DS.W    1
LAB_1FA4:
    DS.W    1
LAB_1FA5:
    DS.W    1
LAB_1FA6:
    DS.L    1
LAB_1FA7:
    DC.L    $00001760
LAB_1FA8:
    DS.L    1
LAB_1FA9:
    DS.W    1
LAB_1FAA:
    NStr2   "%s:",TextLineFeed
LAB_1FAB:
    NStr2   "[GRADIENT]",TextLineFeed
LAB_1FAC:
    NStr3   TextLineFeed,"COLOR%d = %d",TextLineFeed
LAB_1FAD:
    NStr2   "   %d = %03X",TextLineFeed
LAB_1FAE:
    DC.B    10
    NStr3   "TABLE = DONE",TextLineFeed,TextLineFeed
LAB_1FAF:
    DC.L    $00010000
LAB_1FB0:
    DC.W    $0001
GLOB_STR_INPUTDEVICE:
    NStr    "inputdevice"
GLOB_STR_CONSOLEDEVICE:
    NStr    "consoledevice"
GLOB_STR_INPUT_DEVICE:
    NStr    "input.device"
GLOB_STR_CONSOLE_DEVICE:
    NStr    "console.device"
