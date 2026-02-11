; ========== CTASKS.c ==========

Global_STR_CTASKS_C_1:
    NStr    "CTASKS.c"
Global_STR_IFF_TASK_1:
    NStr    "iff_task"
Global_STR_CTASKS_C_2:
    NStr    "CTASKS.c"
Global_STR_IFF_TASK_2:
    NStr    "iff_task"
DATA_CTASKS_CONST_WORD_1B8A:
    DC.W    1
DATA_CTASKS_BSS_LONG_1B8B:
    DS.L    1
Global_STR_CTASKS_C_3:
    NStr    "CTASKS.c"
Global_STR_CTASKS_C_4:
    NStr    "CTASKS.c"
Global_STR_CLOSE_TASK:
    NStr    "close_task"
DATA_CTASKS_BSS_BYTE_1B8F:
    DS.B    1
DATA_CTASKS_BSS_BYTE_1B90:
    DS.B    1
DATA_CTASKS_BSS_BYTE_1B91:
    DS.B    1
DATA_CTASKS_BSS_BYTE_1B92:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: CTASKS_STR_TERM_MISSED_RECORD   (termination status text)
; TYPE: cstring
; PURPOSE: User-facing close-task termination reason strings.
; USED BY: DISKIO_DrawTransferErrorMessageIfDiagnostics
; NOTES: CTASKS_STR_TERM_DL_TOO_LARGE_HEAD + CTASKS_STR_TERM_DL_TOO_LARGE_TAIL intentionally split "Too Large" text and pointer base.
;------------------------------------------------------------------------------
CTASKS_STR_TERM_MISSED_RECORD:
    NStr    "Terminated: Missed Record"
CTASKS_STR_TERM_WRITE_DISK1:
    NStr    "Terminated: Error Writing to Disk 1"
CTASKS_STR_TERM_WRITE_DISK2:
    NStr    "Terminated: Error Writing to Disk 2"
CTASKS_STR_TERM_BATCH_OFF:
    NStr    "Terminated: Batch OFF Found"
CTASKS_STR_TERM_OPEN_FILE:
    NStr    "Terminated: Error Opening file"
CTASKS_STR_TERM_DL_TOO_LARGE_HEAD:
    DC.B    "Terminated: DL File Too La"
CTASKS_STR_TERM_DL_TOO_LARGE_TAIL:
    NStr    "rge"   ; Clearly continuing from the line above
CTASKS_TerminationReasonPtrTable:
    DC.L    CTASKS_STR_TERM_MISSED_RECORD
    DC.L    CTASKS_STR_TERM_WRITE_DISK1
    DC.L    CTASKS_STR_TERM_WRITE_DISK2
    DC.L    CTASKS_STR_TERM_BATCH_OFF
    DC.L    CTASKS_STR_TERM_OPEN_FILE
    DC.L    CTASKS_STR_TERM_DL_TOO_LARGE_HEAD
; For some reason these strings are off alignment and screw up when forcing
; them on a boundary of a word/2 bytes. It almost feels like this is
; some kind of struct instead...
;------------------------------------------------------------------------------
; SYM: CTASKS_EXT_GRF   (file extension and task data paths)
; TYPE: cstring
; PURPOSE: Disk filename constants used by disk I/O save/load routines.
; USED BY: LAB_04D8, LAB_04EC, DISKIO2_WriteOinfoDataFile, DISKIO2_LoadOinfoDataFile
; NOTES: Stored as DC.B to preserve original packing/alignment.
;------------------------------------------------------------------------------
CTASKS_EXT_GRF:
    DC.B    ".GRF",0
CTASKS_PATH_CURDAY_DAT:
    DC.B    "df0:curday.dat",0
CTASKS_PATH_QTABLE_INI:
    DC.B    "df0:qtable.ini",0
CTASKS_PATH_OINFO_DAT:
    DC.B    "df0:oinfo.dat",0
Global_STR_DF0_NXTDAY_DAT:
    DC.B    "df0:nxtday.dat",0
;------------------------------------------------------------------------------
; SYM: DISKIO_SaveOperationReadyFlag   (save-operation gate flag)
; TYPE: u32
; PURPOSE: Global gate used by save/export flows before opening output files.
; USED BY: DISKIO2_WriteCurdayDataFile, LADFUNC_SaveTextAdsToFile
; NOTES: Initialized to 1; routines clear while active and restore to 1 on completion/error.
;------------------------------------------------------------------------------
DISKIO_SaveOperationReadyFlag:
    DC.L    $00000001
DISKIO_BufferControl:
    DS.L    1
    DS.L    1

; Values used for the default configuration.
; https://prevueguide.com/wiki/Prevue_Emulation:Configuration_File
DATA_CTASKS_CONST_BYTE_1BA2:
    DC.B    2
DATA_CTASKS_STR_C_1BA3:
    DC.B    "C"
DATA_CTASKS_BSS_BYTE_1BA4:
    DS.B    1
DATA_CTASKS_CONST_BYTE_1BA5:
    DC.B    3
DATA_CTASKS_CONST_BYTE_1BA6:
    DC.B    24
DATA_CTASKS_CONST_BYTE_1BA7:
    DC.B    24
DATA_CTASKS_STR_G_1BA8:
    DC.B    "G"
DATA_CTASKS_STR_N_1BA9:
    DC.B    "N"
DATA_CTASKS_STR_A_1BAA:
    DC.B    "A"
DATA_CTASKS_STR_E_1BAB:
    DC.B    "E"
DATA_CTASKS_BSS_BYTE_1BAC:
    DS.B    1
DATA_CTASKS_BSS_BYTE_1BAD:
    DS.B    1
DATA_CTASKS_STR_Y_1BAE:
    DC.B    "Y"
DATA_CTASKS_STR_Y_1BAF:
    DC.B    "Y"
DATA_CTASKS_STR_N_1BB0:
    DC.B    "N"
DATA_CTASKS_STR_N_1BB1:
    DC.B    "N"
DATA_CTASKS_STR_Y_1BB2:
    DC.B    "Y"
DATA_CTASKS_STR_N_1BB3:
    DC.B    "N"
DATA_CTASKS_STR_L_1BB4:
    DC.B    "L"
DATA_CTASKS_CONST_BYTE_1BB5:
    DC.B    29
DATA_CTASKS_CONST_BYTE_1BB6:
    DC.B    6
DATA_CTASKS_STR_Y_1BB7:
    DC.B    "Y"
DATA_CTASKS_STR_Y_1BB8:
    DC.B    "Y"
DATA_CTASKS_STR_N_1BB9:
    DC.B    "N"
DATA_CTASKS_CONST_BYTE_1BBA:
    DC.B    23
DATA_CTASKS_CONST_BYTE_1BBB:
    DC.B    36
DATA_CTASKS_CONST_BYTE_1BBC:
    DC.B    12
    DC.B    0
;------------------------------------------------------------------------------
; SYM: CONFIG_TimeWindowMinutes   (time-window minutes config)
; TYPE: s32
; PURPOSE: Runtime-configurable minute window used in schedule/time filtering checks.
; USED BY: DISKIO config parse/save, TEXTDISP time-gating, COI/TLIBA1 schedule helpers
; NOTES: Initialized to 15 and persisted in `config.dat` as a 3-digit numeric field.
;------------------------------------------------------------------------------
CONFIG_TimeWindowMinutes:
    DC.L    $0000000f
DATA_CTASKS_CONST_LONG_1BBE:
    DC.L    $00000001
DATA_CTASKS_STR_Y_1BBF:
    DC.B    "Y"
Global_REF_STR_USE_24_HR_CLOCK:
    DC.B    "N"
DATA_CTASKS_STR_Y_1BC1:
    NStr    "Y"
Global_REF_WORD_HEX_CODE_8E:
    DC.B    0
    DC.B    142
Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES:
    DC.B    8
;------------------------------------------------------------------------------
; SYM: ED_DiagTextModeChar   (diagnostic TXT mode selector char)
; TYPE: u8 (ASCII)
; PURPOSE: Current single-char mode shown under the "TXT" diagnostics column.
; USED BY: ED_DrawDiagnosticModeText, ED2 diagnostic menu action cycling, LADFUNC_/DISKIO_ config flows
; NOTES: Cycled against the `NRLS` option set in ED diagnostics handlers.
;------------------------------------------------------------------------------
ED_DiagTextModeChar:
    DC.B    "N"
DATA_CTASKS_STR_N_1BC5:
    DC.B    "N"
DATA_CTASKS_STR_N_1BC6:
    DC.B    "N"
;------------------------------------------------------------------------------
; SYM: CONFIG_LRBN_FlagChar/CONFIG_MSN_FlagChar   (config tag flag chars)
; TYPE: u8/u8 (ASCII)
; PURPOSE: Persisted Y/N-like flag chars associated with `LRBN` and `MSN` config tags.
; USED BY: DISKIO config parse/write flows, SCRIPT3 menu toggles, TEXTDISP/ED2 status draws
; NOTES: Values are validated/clamped in DISKIO config parsing paths.
;------------------------------------------------------------------------------
CONFIG_LRBN_FlagChar:
    DC.B    "Y"
CONFIG_MSN_FlagChar:
    DC.B    "N"
DATA_CTASKS_STR_1_1BC9:
    NStr    "1"

DATA_CTASKS_CONST_LONG_1BCA:
    DC.L    120
DISKIO_OpenCount:
    DS.L    1
