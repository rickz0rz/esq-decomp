; ========== CTASKS.c ==========

Global_STR_CTASKS_C_1:
    NStr    "CTASKS.c"
Global_STR_IFF_TASK_1:
    NStr    "iff_task"
Global_STR_CTASKS_C_2:
    NStr    "CTASKS.c"
Global_STR_IFF_TASK_2:
    NStr    "iff_task"
CTASKS_CloseTaskCompletionFlag:
    DC.W    1
CTASKS_CloseTaskFileHandle:
    DS.L    1
Global_STR_CTASKS_C_3:
    NStr    "CTASKS.c"
Global_STR_CTASKS_C_4:
    NStr    "CTASKS.c"
Global_STR_CLOSE_TASK:
    NStr    "close_task"
CTASKS_PrimaryOiWritePendingFlag:
    DS.B    1
CTASKS_SecondaryOiWritePendingFlag:
    DS.B    1
CTASKS_PendingPrimaryOiDiskId:
    DS.B    1
CTASKS_PendingSecondaryOiDiskId:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: CTASKS_STR_TERM_MISSED_RECORD   (termination status text)
; TYPE: cstring
; PURPOSE: User-facing close-task termination reason strings.
; USED BY: DISKIO_DrawTransferErrorMessageIfDiagnostics
; NOTES: CTASKS_STR_TERM_DL_TOO_LARGE_HEAD + CTASKS_TerminationReasonPtrTable intentionally split "Too Large" text and pointer base.
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
    NStr    "Terminated: DL File Too Large"
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
    DC.L    1
DISKIO_BufferControl:
    DS.L    1
    DS.L    1

; Values used for the default configuration.
; https://prevueguide.com/wiki/Prevue_Emulation:Configuration_File
;------------------------------------------------------------------------------
; SYM: CONFIG_RefreshIntervalMinutes/.../CONFIG_ModeCycleEnabledFlag/CONFIG_NewgridPlaceholderBevelFlag   (config byte cluster)
; TYPE: u8 flags/counters
; PURPOSE: Persisted configuration defaults parsed/saved by DISKIO config flows.
; USED BY: DISKIO_ParseConfigBuffer, DISKIO_SaveConfigToFileHandle
; NOTES:
;   Field-to-tag mapping remains partially unresolved.
;   `CONFIG_ModeCycleEnabledFlag` toggles mode-cycle gating in NEWGRID mode selection.
;   `CONFIG_NewgridPlaceholderBevelFlag` toggles beveled placeholder styling in NEWGRID column-3 paths.
;   Remaining unresolved persisted slots (parse/save observed; semantic readers not yet confirmed):
;   `CONFIG_SerializedNumericSlot05`, `CONFIG_SerializedFlagSlot08_DefaultN`,
;   `CONFIG_SerializedNumericSlot10`, `CONFIG_SerializedFlagSlot15_DefaultN`,
;   `CONFIG_SerializedNumericSlot19`, `CONFIG_SerializedNumericSlot20`,
;   `CONFIG_SerializedNumericSlot25`, `CONFIG_SerializedNumericSlot26`.
;   Keep grouped until each byte is tied to a single CONFIG_* semantic.
;------------------------------------------------------------------------------
CONFIG_RefreshIntervalMinutes:
    DC.B    2
CTASKS_STR_C:
    DC.B    "C"
CONFIG_NicheModeCycleBudget_Y:
    DS.B    1
CONFIG_NicheModeCycleBudget_Static:
    DC.B    3
CONFIG_SerializedNumericSlot05:
    DC.B    24
CONFIG_NewgridWindowSpanHalfHoursPrimary:
    DC.B    24
CTASKS_STR_G:
    DC.B    "G"
CONFIG_SerializedFlagSlot08_DefaultN:
    DC.B    "N"
CTASKS_STR_A:
    DC.B    "A"
CTASKS_STR_E:
    DC.B    "E"
CONFIG_SerializedNumericSlot10:
    DS.B    1
CONFIG_NicheModeCycleBudget_Custom:
    DS.B    1
CONFIG_NewgridSelectionCode34PrimaryEnabledFlag:
    DC.B    "Y"
CONFIG_NewgridSelectionCode35EnabledFlag:
    DC.B    "Y"
CONFIG_SerializedFlagSlot15_DefaultN:
    DC.B    "N"
CONFIG_NewgridSelectionCode34AltEnabledFlag:
    DC.B    "N"
CONFIG_NewgridSelectionCode32EnabledFlag:
    DC.B    "Y"
CONFIG_RuntimeMode12BannerJumpEnabledFlag:
    DC.B    "N"
CTASKS_STR_L:
    DC.B    "L"
CONFIG_SerializedNumericSlot19:
    DC.B    29
CONFIG_SerializedNumericSlot20:
    DC.B    6
CONFIG_ModeCycleEnabledFlag:
    DC.B    "Y"
CONFIG_NewgridPlaceholderBevelFlag:
    DC.B    "Y"
CONFIG_NewgridSelectionCode48_49EnabledFlag:
    DC.B    "N"
CONFIG_SerializedNumericSlot25:
    DC.B    23
CONFIG_SerializedNumericSlot26:
    DC.B    36
CONFIG_NewgridWindowSpanHalfHoursAlt:
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
    DC.L    15
CONFIG_ModeCycleGateDuration:
    DC.L    1
CONFIG_NewgridSelectionCode16EnabledFlag:
    DC.B    "Y"
Global_REF_STR_USE_24_HR_CLOCK:
    DC.B    "N"
CONFIG_ParseiniLogoScanEnabledFlag:
    NStr    "Y"
;------------------------------------------------------------------------------
; SYM: CONFIG_BannerCopperHeadByte   (banner copper head byte config)
; TYPE: u16 (packed storage, low byte consumed)
; PURPOSE: Config-backed default byte written into banner copper list head words.
; USED BY: DISKIO_ParseConfigBuffer, DISKIO_SaveConfigToFileHandle,
;   ESQSHARED4_InitializeBannerCopperSystem, GCOMMAND_SeedBannerFromPrefs,
;   SCRIPT banner-transition target selection.
; NOTES:
;   Parse path clamps to 128..220 and falls back to $8E (142) when invalid.
;   Save path masks to low byte before formatting into config.dat.
;------------------------------------------------------------------------------
CONFIG_BannerCopperHeadByte:
    DC.B    0
    DC.B    142
Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES:
    DC.B    8
;------------------------------------------------------------------------------
; SYM: ED_DiagTextModeChar/CONFIG_EnsurePc1GfxAssignedFlag/CONFIG_MsnRuntimeModeSelectorChar_LRBN
; TYPE: u8/u8/u8 (ASCII)
; PURPOSE:
;   `ED_DiagTextModeChar` stores the diagnostics TXT mode selector.
;   `CONFIG_EnsurePc1GfxAssignedFlag` gates DISKIO's PC1 mount + GFX assign path.
;   `CONFIG_MsnRuntimeModeSelectorChar_LRBN` selects MSN runtime shadow bucket using LRBN letters.
; USED BY: ED_DrawDiagnosticModeText, ED2 diagnostic menu action cycling, DISKIO_ParseConfigBuffer, SCRIPT_UpdateRuntimeModeForPlaybackCursor
; NOTES:
;   `ED_DiagTextModeChar` is cycled against the `NRLS` option set.
;   `CONFIG_MsnRuntimeModeSelectorChar_LRBN` is validated against DISKIO_TAG_LRBN ("LRBN").
;------------------------------------------------------------------------------
ED_DiagTextModeChar:
    DC.B    "N"
ED_DiagTextModeChar_Length = CONFIG_EnsurePc1GfxAssignedFlag-ED_DiagTextModeChar
CONFIG_EnsurePc1GfxAssignedFlag:
    DC.B    "N"
CONFIG_MsnRuntimeModeSelectorChar_LRBN:
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
CTASKS_STR_1:
    NStr    "1"

;------------------------------------------------------------------------------
; SYM: CONFIG_RefreshIntervalSeconds   (banner queue preset token ??)
; TYPE: s32
; PURPOSE: Shared preset value injected into banner queue mapping paths.
; USED BY: GCOMMAND_MapKeycodeToPreset, DISKIO config parse/save, ED2 diagnostics
; NOTES: Default value is 120; exact user-facing meaning is still unresolved.
;------------------------------------------------------------------------------
CONFIG_RefreshIntervalSeconds:
    DC.L    120
DISKIO_OpenCount:
    DS.L    1
