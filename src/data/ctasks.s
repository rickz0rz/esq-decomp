; ========== CTASKS.c ==========

GLOB_STR_CTASKS_C_1:
    NStr    "CTASKS.c"
GLOB_STR_IFF_TASK_1:
    NStr    "iff_task"
GLOB_STR_CTASKS_C_2:
    NStr    "CTASKS.c"
GLOB_STR_IFF_TASK_2:
    NStr    "iff_task"
LAB_1B8A:
    DC.W    1
LAB_1B8B:
    DS.L    1
GLOB_STR_CTASKS_C_3:
    NStr    "CTASKS.c"
GLOB_STR_CTASKS_C_4:
    NStr    "CTASKS.c"
GLOB_STR_CLOSE_TASK:
    NStr    "close_task"
LAB_1B8F:
    DS.B    1
LAB_1B90:
    DS.B    1
LAB_1B91:
    DS.B    1
LAB_1B92:
    DS.B    1
LAB_1B93:
    NStr    "Terminated: Missed Record"
LAB_1B94:
    NStr    "Terminated: Error Writing to Disk 1"
LAB_1B95:
    NStr    "Terminated: Error Writing to Disk 2"
LAB_1B96:
    NStr    "Terminated: Batch OFF Found"
LAB_1B97:
    NStr    "Terminated: Error Opening file"
LAB_1B98:
    DC.B    "Terminated: DL File Too La"
LAB_1B99:
    NStr    "rge"   ; Clearly continuing from the line above
    DC.L    LAB_1B93
    DC.L    LAB_1B94
    DC.L    LAB_1B95
    DC.L    LAB_1B96
    DC.L    LAB_1B97
    DC.L    LAB_1B98
; For some reason these strings are off alignment and screw up when forcing
; them on a boundary of a word/2 bytes. It almost feels like this is
; some kind of struct instead...
LAB_1B9A:
    DC.B    ".GRF",0
LAB_1B9B:
    DC.B    "df0:curday.dat",0
LAB_1B9C:
    DC.B    "df0:qtable.ini",0
LAB_1B9D:
    DC.B    "df0:oinfo.dat",0
GLOB_STR_DF0_NXTDAY_DAT:
    DC.B    "df0:nxtday.dat",0
LAB_1B9F:
    DC.L    $00000001
DISKIO_BufferControl:
DISKIO_BufferBase:
    DS.L    1
DISKIO_BufferErrorFlag:
    DS.L    1

; Values used for the default configuration.
; https://prevueguide.com/wiki/Prevue_Emulation:Configuration_File
LAB_1BA2:
    DC.B    2
LAB_1BA3:
    DC.B    "C"
LAB_1BA4:
    DS.B    1
LAB_1BA5:
    DC.B    3
LAB_1BA6:
    DC.B    24
LAB_1BA7:
    DC.B    24
LAB_1BA8:
    DC.B    "G"
LAB_1BA9:
    DC.B    "N"
LAB_1BAA:
    DC.B    "A"
LAB_1BAB:
    DC.B    "E"
LAB_1BAC:
    DS.B    1
LAB_1BAD:
    DS.B    1
LAB_1BAE:
    DC.B    "Y"
LAB_1BAF:
    DC.B    "Y"
LAB_1BB0:
    DC.B    "N"
LAB_1BB1:
    DC.B    "N"
LAB_1BB2:
    DC.B    "Y"
LAB_1BB3:
    DC.B    "N"
LAB_1BB4:
    DC.B    "L"
LAB_1BB5:
    DC.B    29
LAB_1BB6:
    DC.B    6
LAB_1BB7:
    DC.B    "Y"
LAB_1BB8:
    DC.B    "Y"
LAB_1BB9:
    DC.B    "N"
LAB_1BBA:
    DC.B    23
LAB_1BBB:
    DC.B    36
LAB_1BBC:
    DC.B    12
    DC.B    0
LAB_1BBD:
    DC.L    $0000000f
LAB_1BBE:
    DC.L    $00000001
LAB_1BBF:
    DC.B    "Y"
GLOB_REF_STR_USE_24_HR_CLOCK:
    DC.B    "N"
LAB_1BC1:
    NStr    "Y"
GLOB_REF_WORD_HEX_CODE_8E:
    DC.B    0
    DC.B    142
GLOB_REF_BYTE_NUMBER_OF_COLOR_PALETTES:
    DC.B    8
LAB_1BC4:
    DC.B    "N"
LAB_1BC5:
    DC.B    "N"
LAB_1BC6:
    DC.B    "N"
LAB_1BC7:
    DC.B    "Y"
LAB_1BC8:
    DC.B    "N"
LAB_1BC9:
    NStr    "1"

LAB_1BCA:
    DC.L    120
DISKIO_OpenCount:
    DS.L    1