; ========== WDISP.c ==========
; weather display?

Global_STR_WDISP_C:
    NStr    "WDISP.c"
;------------------------------------------------------------------------------
; SYM: WDISP_STR_UNKNOWN_NUM_WITH_SLASH   (unknown numeric placeholder with slash)
; TYPE: cstring
; PURPOSE: Display fallback when sentinel value indicates missing first numeric field.
; USED BY: LAB_188C
; NOTES: Rendered instead of formatted "%d/" text.
;------------------------------------------------------------------------------
WDISP_STR_UNKNOWN_NUM_WITH_SLASH:
    NStr3   '?','?','?/'
Global_STR_PERCENT_D_SLASH:
    NStr    "%d/"
;------------------------------------------------------------------------------
; SYM: WDISP_STR_UNKNOWN_NUM   (unknown numeric placeholder)
; TYPE: cstring
; PURPOSE: Display fallback when sentinel value indicates missing second numeric field.
; USED BY: LAB_188C
; NOTES: Rendered instead of formatted "%d" text.
;------------------------------------------------------------------------------
WDISP_STR_UNKNOWN_NUM:
    NStr3   '?','?','?'
Global_STR_PERCENT_D:
    NStr    "%d"
Global_MEM_BYTES_ALLOCATED:
    DS.L    1
Global_MEM_ALLOC_COUNT:
    DS.L    1
Global_MEM_DEALLOC_COUNT:
    DS.L    1
Global_STR_DF1_DEBUG_LOG:
    NStr    "df1:debug.log"
Global_STR_A_PLUS:
    NStr    "a+"
    DS.L    1
    DC.L    $00280000
    DS.L    5
    DC.W    $8000
    DC.L    DATA_WDISP_CONST_LONG_21A6
    DS.L    7
    DS.W    1
DATA_WDISP_CONST_LONG_21A6:
    DC.L    DATA_WDISP_BSS_LONG_21A7
    DS.L    7
    DS.W    1
DATA_WDISP_BSS_LONG_21A7:
    DS.L    9
    DC.L    $00008000,$00000400
    DS.B    1
;------------------------------------------------------------------------------
; SYM: WDISP_CharClassTable   (character classification lookup table)
; TYPE: u8[?]
; PURPOSE: Classifies input bytes for parser/tokenizer style routines.
; USED BY: TEXTDISP_*, PARSEINI_*, P_TYPE_* text parsing paths
; NOTES: Table-driven classifier (bit/flag encoding still partially unknown).
;------------------------------------------------------------------------------
WDISP_CharClassTable:
    DC.B    $20
    DC.L    $20202020,$20202020,$28282828,$28202020
    DC.L    $20202020,$20202020,$20202020,$20202048
    DC.L    $10101010,$10101010,$10101010,$10101084
    DC.L    $84848484,$84848484,$84101010,$10101010
    DC.L    $81818181,$81810101,$01010101,$01010101
    DC.L    $01010101,$01010101,$01011010,$10101010
    DC.L    $82828282,$82820202,$02020202,$02020202
    DC.L    $02020202,$02020202,$02021010,$10102020
    DC.L    $20202020,$20202020,$28282828,$28202020
    DC.L    $20202020,$20202020,$20202020,$20202048
    DC.L    $10101010,$10101010,$10101010,$10101084
    DC.L    $84848484,$84848484,$84101010,$10101010
    DC.L    $81818181,$81810101,$01010101,$01010101
    DC.L    $01010101,$01010101,$01011010,$10101010
    DC.L    $82828282,$82820202,$02020202,$02020202
    DC.L    $02020202,$02020202,$02021010,$10102000
    DS.L    1
    DC.W    $0200
DATA_WDISP_CONST_LONG_21A9:
    DC.L    $ffff0000,$000e000e
    DS.L    1
    DC.L    DEBUG_STR_UserAbortRequested
    DS.L    1
    DC.L    $ffff0000,$00040004
    DS.L    2
    DC.L    DATA_WDISP_CONST_LONG_21A9
    DC.L    $ffff0000,$00040004
    DS.L    1
    DC.L    DEBUG_STR_Continue
    DS.L    1
    DC.L    $ffff0000,$00040004
    DS.L    1
    DC.L    DEBUG_STR_Abort
    DS.L    1
BUFFER_5929_LONGWORDS:
    DS.L    19
; Pointer to the most recently allocated brush node (BRUSH_AllocBrushNode).
BRUSH_LastAllocatedNode:
    DS.L    1
; Scratch buffer used by BRUSH_SelectBrushByLabel during comparisons.
BRUSH_LabelScratch:
    DS.W    1
    DS.B    1
BRUSH_SnapshotHeader:
    DS.B    1
    DS.L    8
; Cached brush width captured while BRUSH_PendingAlertCode is set.
BRUSH_SnapshotWidth:
    DS.L    1
; Cached brush depth (planes) captured alongside BRUSH_SnapshotWidth.
BRUSH_SnapshotDepth:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: CLEANUP_AlignedStatusAltTimeBuffer   (aligned status alt time text buffer)
; TYPE: char[512]
; PURPOSE: Scratch buffer for alternate time/label text in aligned status flow.
; USED BY: CLEANUP_RenderAlignedStatusScreen, TLIBA1_BuildClockFormatEntryIfVisible
; NOTES: Cleared to NUL before formatting when template code 'O' is selected.
;------------------------------------------------------------------------------
CLEANUP_AlignedStatusAltTimeBuffer:
    DS.L    128
;------------------------------------------------------------------------------
; SYM: DISPTEXT_InsetNibblePrimary   (inline inset nibble A)
; TYPE: u8
; PURPOSE: Parsed hex nibble from entry flag byte 6 used for inset rendering.
; USED BY: CLEANUP_UpdateEntryFlagBytes, DISPTEXT_*, TLIBA1_DrawTextWithInsetSegments
; NOTES: Set to $FF when entry flag byte is not a valid hex digit.
;------------------------------------------------------------------------------
DISPTEXT_InsetNibblePrimary:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_InsetNibbleSecondary   (inline inset nibble B)
; TYPE: u8
; PURPOSE: Parsed hex nibble from entry flag byte 7 used for inset rendering.
; USED BY: CLEANUP_UpdateEntryFlagBytes, DISPTEXT_*, TLIBA1_DrawTextWithInsetSegments
; NOTES: Set to $FF when entry flag byte is not a valid hex digit.
;------------------------------------------------------------------------------
DISPTEXT_InsetNibbleSecondary:
DATA_WDISP_BSS_BYTE_21B2:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: CLEANUP_AlignedInsetNibblePrimary   (aligned status inset nibble A)
; TYPE: u8
; PURPOSE: Parsed hex nibble for aligned status inset rendering (entry flag byte 6).
; USED BY: CLEANUP_BuildAlignedStatusLine, TLIBA1_DrawInlineStyledText, SCRIPT_DrawInsetTextWithFrame
; NOTES: Set to $FF when entry flag byte is not a valid hex digit.
;------------------------------------------------------------------------------
CLEANUP_AlignedInsetNibblePrimary:
DATA_WDISP_BSS_BYTE_21B3:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: CLEANUP_AlignedInsetNibbleSecondary   (aligned status inset nibble B)
; TYPE: u8
; PURPOSE: Parsed hex nibble for aligned status inset rendering (entry flag byte 7).
; USED BY: CLEANUP_BuildAlignedStatusLine, TLIBA1_DrawInlineStyledText, SCRIPT_DrawInsetTextWithFrame
; NOTES: Set to $FF when entry flag byte is not a valid hex digit.
;------------------------------------------------------------------------------
CLEANUP_AlignedInsetNibbleSecondary:
DATA_WDISP_BSS_BYTE_21B4:
    DS.B    1
Global_REF_LIST_IFF_TASK_PROC:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: CTASKS_IffTaskSegListBPTR   (IFF task seglist BPTR)
; TYPE: u32 (BPTR)
; PURPOSE: BPTR to segment list passed into CreateProc for the IFF task.
; USED BY: CTASKS_StartIffTaskProcess
; NOTES: Derived from Global_REF_LIST_IFF_TASK_PROC + 4, then shifted right by 2.
;------------------------------------------------------------------------------
CTASKS_IffTaskSegListBPTR:
DATA_WDISP_BSS_LONG_21B6:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: CTASKS_IffTaskProcPtr   (IFF task process pointer)
; TYPE: pointer
; PURPOSE: Holds the process/task pointer returned by CreateProc for IFF loading.
; USED BY: CTASKS_StartIffTaskProcess
; NOTES: Nonzero indicates the IFF task was successfully spawned.
;------------------------------------------------------------------------------
CTASKS_IffTaskProcPtr:
DATA_WDISP_BSS_LONG_21B7:
    DS.L    1
Global_REF_LIST_CLOSE_TASK_PROC:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: CTASKS_CloseTaskSegListBPTR   (close-task seglist BPTR)
; TYPE: u32 (BPTR)
; PURPOSE: BPTR to segment list passed into CreateProc for the close-task process.
; USED BY: CTASKS_StartCloseTaskProcess
; NOTES: Derived from Global_REF_LIST_CLOSE_TASK_PROC + 4, then shifted right by 2.
;------------------------------------------------------------------------------
CTASKS_CloseTaskSegListBPTR:
DATA_WDISP_BSS_LONG_21B9:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: CTASKS_CloseTaskProcPtr   (close-task process pointer)
; TYPE: pointer
; PURPOSE: Holds the process/task pointer returned by CreateProc for CLOSE_TASK.
; USED BY: CTASKS_StartCloseTaskProcess
; NOTES: Nonzero indicates the CLOSE_TASK process was successfully spawned.
;------------------------------------------------------------------------------
CTASKS_CloseTaskProcPtr:
DATA_WDISP_BSS_LONG_21BA:
    DS.L    1
Global_REF_LONG_FILE_SCRATCH:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: Global_PTR_WORK_BUFFER   (shared file/work buffer cursor)
; TYPE: pointer
; PURPOSE: Tracks the active read/write position in the shared work buffer.
; USED BY: DISKIO_*, GCOMMAND_*, COI_*, PARSEINI_*, LOCAVAIL_*
; NOTES: Frequently incremented while parsing streamed records.
;------------------------------------------------------------------------------
Global_PTR_WORK_BUFFER:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_InteractiveTransferArmedFlag   (interactive transfer armed flag)
; TYPE: u32
; PURPOSE: Gates whether ESQPARS will dispatch interactive file-transfer handling.
; USED BY: ESQPARS command parsing, DISKIO2_HandleInteractiveFileTransfer
; NOTES: Set to 1 when transfer handshake begins; cleared on completion or error.
;------------------------------------------------------------------------------
DISKIO2_InteractiveTransferArmedFlag:
DATA_WDISP_BSS_LONG_21BD:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_OutputFileHandle   (disk output file handle)
; TYPE: pointer/handle
; PURPOSE: File handle used while writing the CurDay data export in DISKIO2.
; USED BY: DISKIO2_WriteCurdayDataFile
; NOTES: Set from DISKIO_OpenFileWithBuffer and consumed by DISKIO_WriteBufferedBytes/DISKIO_WriteDecimalField/DISKIO_CloseBufferedFileAndFlush write helpers.
;------------------------------------------------------------------------------
DISKIO2_OutputFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_QTableIniFileHandle   (QTABLE.INI output handle)
; TYPE: pointer/handle
; PURPOSE: File handle used while writing CTASKS_PATH_QTABLE_INI.
; USED BY: DISKIO2 writer DISKIO2_WriteQTableIniFile
; NOTES: Passed to DISKIO_WriteBufferedBytes/DISKIO_CloseBufferedFileAndFlush for sequential writes and close.
;------------------------------------------------------------------------------
DISKIO2_QTableIniFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_OinfoFileHandle   (OINFO.DAT read/write handle)
; TYPE: pointer/handle
; PURPOSE: File handle used while serializing and parsing CTASKS_PATH_OINFO_DAT.
; USED BY: DISKIO2 writer/reader DISKIO2_WriteOinfoDataFile and DISKIO2_LoadOinfoDataFile
; NOTES: Carries the single-byte header plus two optional NUL-terminated strings.
;------------------------------------------------------------------------------
DISKIO2_OinfoFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_NxtDayFileHandle   (NXTDAY.DAT output handle)
; TYPE: pointer/handle
; PURPOSE: File handle used while serializing NXTDAY.DAT records.
; USED BY: DISKIO2_WriteNextDayDataFile
; NOTES: Opened with MODE_NEWFILE and passed to DISKIO_WriteBufferedBytes/DISKIO_WriteDecimalField/DISKIO_CloseBufferedFileAndFlush writer helpers.
;------------------------------------------------------------------------------
DISKIO2_NxtDayFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferFilenameBuffer   (serial transfer filename buffer)
; TYPE: u8[32]
; PURPOSE: Scratch buffer for incoming/outgoing filename text in DISKIO2 serial transfer paths.
; USED BY: DISKIO2 serial read/write handlers (DISKIO2_HandleInteractiveFileTransfer/DISKIO2_ReceiveTransferBlocksToFile)
; NOTES: Filled byte-by-byte with running XOR checksum; copied into BRUSH_SnapshotHeader on accepted updates.
;------------------------------------------------------------------------------
DISKIO2_TransferFilenameBuffer:
    DS.L    2
    DS.B    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferFilenameExtPtr   (filename extension pointer)
; TYPE: pointer (within DISKIO2_TransferFilenameBuffer)
; PURPOSE: Points at the extension portion of the 8.3-style filename buffer.
; USED BY: DISKIO2_HandleInteractiveFileTransfer (wildcard match on extension)
; NOTES: Label sits at offset 9 (after 8 chars + '.').
;------------------------------------------------------------------------------
DISKIO2_TransferFilenameExtPtr:
DATA_WDISP_BSS_BYTE_21C3:
    DS.B    1
    DS.L    5
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferSizeTokenBuffer   (transfer size token buffer)
; TYPE: char[16]
; PURPOSE: Holds the optional size token parsed during interactive transfer setup.
; USED BY: DISKIO2_HandleInteractiveFileTransfer
; NOTES: Filled byte-by-byte from serial input; NUL-terminated before parsing.
;------------------------------------------------------------------------------
DISKIO2_TransferSizeTokenBuffer:
DATA_WDISP_BSS_LONG_21C4:
    DS.L    4
;------------------------------------------------------------------------------
; SYM: DISKIO_WriteFileHandle   (active DOS write handle)
; TYPE: pointer/handle
; PURPOSE: Active file handle used by shared write helper DISKIO_WriteBytesToOutputHandleGuarded and serial transfer paths.
; USED BY: DISKIO/DISKIO_WriteBytesToOutputHandleGuarded, DISKIO2 serial receive/write flow
; NOTES: Opened by DISKIO2 before streaming blocks; closed when transfer completes.
;------------------------------------------------------------------------------
DISKIO_WriteFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferBlockLength   (incoming transfer block length)
; TYPE: u8
; PURPOSE: Current payload-byte count for the active serial transfer block.
; USED BY: DISKIO2/DISKIO2_ReceiveTransferBlocksToFile block receive loop
; NOTES: Zero-length block is treated as a flush/finalize marker.
;------------------------------------------------------------------------------
DISKIO2_TransferBlockLength:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferXorChecksumByte   (serial transfer XOR checksum byte)
; TYPE: u8
; PURPOSE: Running XOR accumulator used during DISKIO2 serial receive/send transfer blocks.
; USED BY: DISKIO2_HandleInteractiveFileTransfer, DISKIO2_ReceiveTransferBlocksToFile
; NOTES: Seeded to mode-dependent constants (`$C2`/`$B7`) before folding incoming bytes.
;------------------------------------------------------------------------------
DISKIO2_TransferXorChecksumByte:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferBlockSequence   (transfer block sequence byte)
; TYPE: u8 (stored in word slot)
; PURPOSE: Expected sequence id for the next incoming serial transfer block.
; USED BY: DISKIO2/DISKIO2_ReceiveTransferBlocksToFile
; NOTES: Incremented modulo 256 after each accepted block.
;------------------------------------------------------------------------------
DISKIO2_TransferBlockSequence:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferBlockBufferPtr   (transfer block staging buffer pointer)
; TYPE: pointer
; PURPOSE: Heap buffer used to stage incoming serial transfer payload bytes before disk writes.
; USED BY: DISKIO2/DISKIO2_HandleInteractiveFileTransfer, DISKIO2/DISKIO2_ReceiveTransferBlocksToFile
; NOTES: Allocated as 4352 bytes during transfer setup.
;------------------------------------------------------------------------------
DISKIO2_TransferBlockBufferPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferBufferedByteCount   (staged byte count)
; TYPE: u16
; PURPOSE: Number of staged bytes currently queued in DISKIO2_TransferBlockBufferPtr.
; USED BY: DISKIO2/DISKIO2_ReceiveTransferBlocksToFile
; NOTES: Flushed through DISKIO_WriteBytesToOutputHandleGuarded at block boundaries or when reaching 0x1000.
;------------------------------------------------------------------------------
DISKIO2_TransferBufferedByteCount:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISKIO_SavedReadModeFlags   (saved ESQPARS2 read mode flags)
; TYPE: u16
; PURPOSE: Temporary save slot while DISKIO/DISKIO2 force ESQPARS2_ReadModeFlags to `$0100`.
; USED BY: DISKIO/DISKIO_WriteBytesToOutputHandleGuarded, DISKIO2 transfer setup/teardown
; NOTES: Restored immediately after disk I/O calls.
;------------------------------------------------------------------------------
DISKIO_SavedReadModeFlags:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferCrcErrorCount   (transfer CRC mismatch counter)
; TYPE: s32
; PURPOSE: Counts serial-transfer blocks that fail CRC/validation checks.
; USED BY: DISKIO2/DISKIO2_ReceiveTransferBlocksToFile
; NOTES: Reset on accepted blocks; incremented when checksum/CRC verification fails.
;------------------------------------------------------------------------------
DISKIO2_TransferCrcErrorCount:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO_TrackdiskMsgPortPtr   (trackdisk message port pointer)
; TYPE: pointer
; PURPOSE: Message-port object allocated for trackdisk.device probing/IOSTDREQ setup.
; USED BY: DISKIO media probe/init path (DISKIO_ProbeDrivesAndAssignPaths)
; NOTES: Created by GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal and released via IOSTDREQ cleanup helper.
;------------------------------------------------------------------------------
DISKIO_TrackdiskMsgPortPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO_TrackdiskIoReqPtr   (trackdisk I/O request pointer)
; TYPE: pointer
; PURPOSE: Shared IOSTDREQ pointer used while probing trackdisk.device units.
; USED BY: DISKIO media probe/init path (DISKIO_ProbeDrivesAndAssignPaths)
; NOTES: Allocated via IOSTDREQ setup helper, reused for OpenDevice/DoIO/CloseDevice.
;------------------------------------------------------------------------------
DISKIO_TrackdiskIoReqPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO_BufferState   (DiskIoBufferState_uncertain)
; TYPE: struct
; PURPOSE: Global disk I/O buffer state used by DISKIO_OpenFileWithBuffer and writers.
; USED BY: DISKIO_OpenFileWithBuffer, DISKIO_WriteBufferedBytes, DISKIO_CloseBufferedFileAndFlush
; NOTES: Layout matches Struct_DiskIoBufferState__* offsets.
;------------------------------------------------------------------------------
DISKIO_BufferState:
    DS.L    1
    DS.L    1
; Struct_DiskIoBufferState__Remaining
    DS.L    1
; Struct_DiskIoBufferState__SavedF45
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_TextBufferPtr   (disptext text buffer pointer)
; TYPE: pointer
; PURPOSE: Base pointer to the active text buffer consumed by DISPTEXT routines.
; USED BY: DISPTEXT_*, DISPLIB_*
; NOTES: Updated when loading/swapping text content buffers.
;------------------------------------------------------------------------------
DISPTEXT_TextBufferPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_LinePtrTable/DISPTEXT_LineLengthTable/DISPTEXT_LinePenTable   (disptext line metadata)
; TYPE: pointer[20]/u16[20]/u32[20]
; PURPOSE: Per-line pointer, measured length, and render-pen metadata used during DISPTEXT layout/render.
; USED BY: DISPTEXT_*, DISPLIB_*
; NOTES: Initialized/reset by DISPLIB_ResetLineTables; length table is accessed as words.
;------------------------------------------------------------------------------
DISPTEXT_LinePtrTable:
    DS.L    20
;------------------------------------------------------------------------------
; SYM: DISPTEXT_TargetLineIndex   (disptext target line index)
; TYPE: u16
; PURPOSE: Requested/target line index for scroll/selection movement.
; USED BY: DISPTEXT_*, DISPLIB_*
; NOTES: Compared with DISPTEXT_CurrentLineIndex to detect pending movement.
;------------------------------------------------------------------------------
DISPTEXT_TargetLineIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_CurrentLineIndex   (disptext current line index)
; TYPE: u16
; PURPOSE: Current line index within disptext buffer/window.
; USED BY: DISPTEXT_*, DISPLIB_*
; NOTES: Adjusted during scroll and cursor advance operations.
;------------------------------------------------------------------------------
DISPTEXT_CurrentLineIndex:
    DS.W    1
DISPTEXT_LineLengthTable:
    DS.L    10
DISPTEXT_LinePenTable:
    DS.L    20
;------------------------------------------------------------------------------
; SYM: DISPTEXT_LineWidthPx   (disptext layout width in pixels)
; TYPE: s32
; PURPOSE: Maximum line width used by DISPTEXT layout/build functions.
; USED BY: DISPTEXT_SetLayoutParams, DISPTEXT_LayoutSourceToLines, DISPTEXT_LayoutAndAppendToBuffer
; NOTES: Clamped to 0..624 by DISPTEXT_SetLayoutParams.
;------------------------------------------------------------------------------
DISPTEXT_LineWidthPx:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_ControlMarkerWidthPx   (combined control-marker width)
; TYPE: s32
; PURPOSE: Stores combined pixel width of optional control markers/prefixes.
; USED BY: DISPTEXT_ComputeMarkerWidths, DISPTEXT_LayoutSourceToLines
; NOTES: Subtracted from available line width during layout passes.
;------------------------------------------------------------------------------
DISPTEXT_ControlMarkerWidthPx:
DATA_WDISP_BSS_LONG_21DA:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_LineTableLockFlag   (disptext line-table lock flag)
; TYPE: s32
; PURPOSE: Gates line-table rebuild/layout calls while table updates are in progress.
; USED BY: DISPTEXT_BuildLinePointerTable, DISPTEXT_FinalizeLineTable, DISPTEXT_LayoutSourceToLines
; NOTES: Nonzero suppresses rebuild/selection mutation operations.
;------------------------------------------------------------------------------
DISPTEXT_LineTableLockFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISPTEXT_ControlMarkersEnabledFlag   (control marker enable flag)
; TYPE: u16
; PURPOSE: Enables rendering/measurement of 0x13/0x14 control marker sequences.
; USED BY: DISPLIB_ResetLineTables, DISPTEXT_*, TLIBA1_DrawTextWithInsetSegments
; NOTES: When set, inline inset markers are parsed and add padding.
;------------------------------------------------------------------------------
DISPTEXT_ControlMarkersEnabledFlag:
    DS.W    1
Global_REF_1000_BYTES_ALLOCATED_1:
    DS.L    1
Global_REF_1000_BYTES_ALLOCATED_2:
    DS.L    1
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DST_BannerWindowPrimary/DST_BannerWindowSecondary   (banner time windows)
; TYPE: struct/struct
; PURPOSE: Primary and secondary time-window descriptors used by DST banner scheduling logic.
; USED BY: DST_HandleBannerCommand32_33, DST_UpdateBannerQueue, CLEANUP_ProcessAlerts, ESQDISP_DrawStatusBanner
; NOTES: Command $33 updates primary; command $32 updates secondary/alternate window.
;------------------------------------------------------------------------------
DST_BannerWindowPrimary:
    DS.L    1
DST_BannerWindowSecondary:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_CurrentChar   (editor current character)
; TYPE: u16
; PURPOSE: Holds the character at the current edit cursor.
; USED BY: ED_HandleEditorInput, ED editor redraw/preview helpers
; NOTES: Stored as word, but usually treated as byte character data.
;------------------------------------------------------------------------------
ED_CurrentChar:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_SavedScrollSpeedIndex   (saved scroll-speed menu index)
; TYPE: s32
; PURPOSE: Stores the scroll-speed selection index to restore when returning to the ESC menu.
; USED BY: ED1_HandleEscMenuInput, ED2_HandleScrollSpeedSelection
; NOTES: Loaded into ED_EditCursorOffset when the scroll-speed menu is shown.
;------------------------------------------------------------------------------
ED_SavedScrollSpeedIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_SavedDiagGraphModeChar   (saved diagnostics graph-mode char)
; TYPE: u8 (stored in word slot)
; PURPOSE: Captures ED_DiagGraphModeChar on ESC menu entry for mode-change checks.
; USED BY: ED1_EnterEscMenu, ED1_ExitEscMenu
; NOTES: Compared against ED_DiagGraphModeChar to decide whether to wait/cleanup.
;------------------------------------------------------------------------------
ED_SavedDiagGraphModeChar:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_SaveTextAdsOnExitFlag   (save text ads on exit flag)
; TYPE: u32[2]
; PURPOSE: Signals that text ads should be saved when exiting the ESC editor flows.
; USED BY: ED_HandleEditAttributesInput, ED ad-number paths, ED1_ExitEscMenu
; NOTES: Only the first long is observed in use; second long may be padding or a companion flag.
;------------------------------------------------------------------------------
ED_SaveTextAdsOnExitFlag:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: ED2_SelectedEntryIndex/ED2_SelectedFlagByteOffset   (ED2 selection indices)
; TYPE: u16/u16
; PURPOSE: Current selected entry index and selected byte-offset within that entry in ED2 views.
; USED BY: ED2_DrawEntrySummaryPanel, ED2_DrawEntryDetailsPanel, ED2_HandleDiagnosticKeyActions
; NOTES: `ED2_SelectedFlagByteOffset` is clamped in ED2 flows before field-byte probing.
;------------------------------------------------------------------------------
ED2_SelectedEntryIndex:
    DS.W    1
ED2_SelectedFlagByteOffset:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_SavedCtasksIntervalByte   (saved CTASKS interval byte)
; TYPE: u8 (stored in long slot)
; PURPOSE: Temporarily stores DATA_CTASKS_CONST_BYTE_1BA2 while toggling.
; USED BY: ED2 diagnostic toggle handler
; NOTES: Restored when the toggle is released.
;------------------------------------------------------------------------------
ED_SavedCtasksIntervalByte:
DATA_WDISP_BSS_LONG_21E7:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_EditCursorOffset   (editor cursor offset into live buffer)
; TYPE: s32
; PURPOSE: Index of the active edit position in ED_EditBufferLive.
; USED BY: ED_*, ED2_*, ED3_* editor movement and redraw routines
; NOTES: Clamped against visible ranges with ED_ViewportOffset.
;------------------------------------------------------------------------------
ED_EditCursorOffset:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_ViewportOffset   (editor viewport offset)
; TYPE: s32
; PURPOSE: Start offset of the visible editor window.
; USED BY: ED_*, ED3_* viewport/clamp logic
; NOTES: Maintained alongside ED_EditCursorOffset.
;------------------------------------------------------------------------------
ED_ViewportOffset:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_AdActiveFlag   (editor active/inactive toggle)
; TYPE: u32
; PURPOSE: Tracks whether the currently edited ad is marked active.
; USED BY: ED_HandleEditorInput, ED_HandleEditAttributesInput, ED_UpdateAdNumberDisplay, ED_ApplyActiveFlagToAdData, ED_UpdateActiveInactiveIndicator
; NOTES: Treated as boolean; when set, ad record gets word0=1 and word2=$30.
;------------------------------------------------------------------------------
ED_AdActiveFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_BlockOffset   (editor block/base offset)
; TYPE: s32
; PURPOSE: Base byte offset into editor text buffers for the active block/page.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*
; NOTES: Commonly derived from ED_TextLimit * 40 during ESC editor setup.
;------------------------------------------------------------------------------
ED_BlockOffset:
    DS.L    1
Global_REF_BOOL_IS_LINE_OR_PAGE:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_LastKeyCode   (last editor key code)
; TYPE: u16
; PURPOSE: Stores the most recently processed editor key/input code.
; USED BY: ED_*, ED2_*, ED3_* key dispatch logic
; NOTES: Compared against control codes to choose edit actions.
;------------------------------------------------------------------------------
ED_LastKeyCode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_TempCopyOffset   (temporary copy/shift offset)
; TYPE: s32
; PURPOSE: Scratch offset used while shifting/copying edit buffer text.
; USED BY: ED_* text insert/delete paths
; NOTES: Acts as a transient cursor during memmove-like loops.
;------------------------------------------------------------------------------
ED_TempCopyOffset:
    DS.L    88
    DS.B    1
DATA_WDISP_BSS_BYTE_21EF:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: ED_EditBufferScratch   (editor scratch text buffer)
; TYPE: u8[]
; PURPOSE: Temporary staging buffer for text before committing to live data.
; USED BY: ED_*, ED3_* formatting and redraw helpers
; NOTES: Typically paired with ED_EditBufferLive.
;------------------------------------------------------------------------------
ED_EditBufferScratch:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: ED_EditBufferScratchShiftBase   (editor scratch shift-window base)
; TYPE: u8*
; PURPOSE: Base used by delete/insert memmove paths for scratch text rows.
; USED BY: ED_* delete/insert paths
; NOTES: Preserves legacy label DATA_WDISP_BSS_BYTE_21F1 for compatibility.
;------------------------------------------------------------------------------
ED_EditBufferScratchShiftBase:
DATA_WDISP_BSS_BYTE_21F1:
    DS.B    1
    DS.L    2
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_AdNumberInputDigitTens   (ad-number tens digit char)
; TYPE: u8
; PURPOSE: First editable digit in the "enter ad number" prompt.
; USED BY: ED_HandleEditAttributesMenu
; NOTES: ASCII digit or space (' ').
;------------------------------------------------------------------------------
ED_AdNumberInputDigitTens:
DATA_WDISP_BSS_BYTE_21F2:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: ED_AdNumberInputDigitOnes   (ad-number ones digit char)
; TYPE: u8
; PURPOSE: Second editable digit in the "enter ad number" prompt.
; USED BY: ED_HandleEditAttributesMenu
; NOTES: ASCII digit or space (' ').
;------------------------------------------------------------------------------
ED_AdNumberInputDigitOnes:
DATA_WDISP_BSS_BYTE_21F3:
    DS.B    1
DATA_WDISP_BSS_LONG_21F4:
    DS.L    6
    DS.W    1
DATA_WDISP_BSS_LONG_21F5:
    DS.L    79
    DS.W    1
    DS.B    1
DATA_WDISP_BSS_BYTE_21F6:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: ED_EditBufferLive   (editor live text buffer)
; TYPE: u8[]
; PURPOSE: Canonical editable text storage used by on-screen editor flows.
; USED BY: ED_*, ED2_*, ED3_*
; NOTES: Indexed by ED_EditCursorOffset.
;------------------------------------------------------------------------------
ED_EditBufferLive:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: ED_EditBufferLiveShiftBase   (editor live-attr shift-window base)
; TYPE: u8*
; PURPOSE: Base used by delete/insert memmove paths for live attribute rows.
; USED BY: ED_* delete/insert paths
; NOTES: Preserves legacy label DATA_WDISP_BSS_BYTE_21F8 for compatibility.
;------------------------------------------------------------------------------
ED_EditBufferLiveShiftBase:
DATA_WDISP_BSS_BYTE_21F8:
    DS.B    1
    DS.L    9
    DS.W    1
DATA_WDISP_BSS_LONG_21F9:
    DS.L    80
;------------------------------------------------------------------------------
; SYM: ED_LastMenuInputChar   (last secondary menu input byte)
; TYPE: u8 (stored in word slot)
; PURPOSE: Caches the second byte from the current ED state-ring entry.
; USED BY: ED_GetEscMenuActionCode, ED2_HandleScrollSpeedSelection, ED menu/edit handlers
; NOTES: Compared against ASCII-like codes (e.g., 'A'/'C'/'D') in menu switch paths.
;------------------------------------------------------------------------------
ED_LastMenuInputChar:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_TextLimit   (editor text length/limit)
; TYPE: s32
; PURPOSE: Upper bound/limit used by editor text navigation and copy operations.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, LADFUNC_*
; NOTES: Compared against cursor/offset values during edit operations.
;------------------------------------------------------------------------------
ED_TextLimit:
    DS.L    16
Global_REF_LONG_CURRENT_EDITING_AD_NUMBER:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_MaxAdNumber   (maximum selectable ad number)
; TYPE: s32
; PURPOSE: Upper bound for ad-number selection validation.
; USED BY: ED_DrawAdNumberPrompt, ED_HandleEditAttributesMenu, ED3_* ad-index sync paths
; NOTES: Parsed from startup tag bytes in ED1 init flow.
;------------------------------------------------------------------------------
ED_MaxAdNumber:
DATA_WDISP_BSS_LONG_21FD:
    DS.L    1
DATA_WDISP_BSS_LONG_21FE:
    DS.L    16
DATA_WDISP_BSS_LONG_21FF:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_CursorColumnIndex   (cursor column within current 40-char row)
; TYPE: s32
; PURPOSE: Stores row-relative cursor column derived from linear edit index.
; USED BY: ED_UpdateCursorPosFromIndex, ED_DrawCursorChar
; NOTES: Set from DivS32 remainder with divisor 40.
;------------------------------------------------------------------------------
ED_CursorColumnIndex:
DATA_WDISP_BSS_LONG_2200:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_ActiveIndicatorCachedState   (cached active/inactive draw state)
; TYPE: s32
; PURPOSE: Memoized copy of ED_AdActiveFlag used to skip redundant indicator redraws.
; USED BY: ED_UpdateAdNumberDisplay, ED_UpdateActiveInactiveIndicator
; NOTES: Initialized to -1 when ad context changes to force first redraw.
;------------------------------------------------------------------------------
ED_ActiveIndicatorCachedState:
DATA_WDISP_BSS_LONG_2201:
    DS.L    1
DATA_WDISP_BSS_LONG_2202:
    DS.L    2
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQ_StartupStateWord2203   (startup state word ??)
; TYPE: u16
; PURPOSE: Startup-cleared state slot in the early ESQ global init sequence.
; USED BY: ESQ_MainInitAndRun
; NOTES: Semantics unresolved; currently only observed being reset to zero.
;------------------------------------------------------------------------------
ESQ_StartupStateWord2203:
DATA_WDISP_BSS_WORD_2203:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQ_StartupVersionBannerBuffer   (startup version/status text buffer)
; TYPE: u8[]
; PURPOSE: Scratch output buffer for formatted version/build startup text.
; USED BY: ESQ_MainInitAndRun startup banner formatting/display
; NOTES: 80-byte backing store (`DS.L 20`).
;   WDISP_SPrintf has no destination length parameter, so writers rely on
;   external format/input discipline.
;------------------------------------------------------------------------------
ESQ_StartupVersionBannerBuffer:
DATA_WDISP_BSS_LONG_2204:
    DS.L    20
;------------------------------------------------------------------------------
; SYM: ESQ_TickModulo60Counter   (global frame tick modulo 60)
; TYPE: u16
; PURPOSE: Counts scheduler ticks until per-second rollover work runs.
; USED BY: ESQ_MainInitAndRun, ESQ_TickGlobalCounters
; NOTES: Incremented each tick and reset to 0 on reaching 60.
;------------------------------------------------------------------------------
ESQ_TickModulo60Counter:
DATA_WDISP_BSS_WORD_2205:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_UseCachedChecksumFlag   (checksum override gate)
; TYPE: u8 (stored in word slot)
; PURPOSE: When non-zero, ESQ_GenerateXorChecksumByte returns cached checksum.
; USED BY: ESQ_MainInitAndRun, ESQ_GenerateXorChecksumByte
; NOTES: Cleared during startup global-state initialization.
;------------------------------------------------------------------------------
ESQIFF_UseCachedChecksumFlag:
DATA_WDISP_BSS_WORD_2206:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQSHARED_LivePlaneBase0/ESQSHARED_LivePlaneBase1/ESQSHARED_LivePlaneBase2
; TYPE: pointer triplet
; PURPOSE: Current live display plane base pointers used for snapshot/copy paths.
; USED BY: ESQ_MainInitAndRun, ESQSHARED4_SnapshotDisplayBufferBases, ESQSHARED4_CopyLivePlanesToSnapshot
; NOTES: Seeded from the 696x2 raster allocation table (`2220`..`2222`).
;------------------------------------------------------------------------------
ESQSHARED_LivePlaneBase0:
DATA_WDISP_BSS_LONG_2207:
    DS.L    1
ESQSHARED_LivePlaneBase1:
DATA_WDISP_BSS_LONG_2208:
    DS.L    1
ESQSHARED_LivePlaneBase2:
DATA_WDISP_BSS_LONG_2209:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQSHARED_DisplayContextPlaneBase0..4   (display-context plane base set)
; TYPE: pointer array
; PURPOSE: Secondary plane-base snapshot copied from `2224`..`2228` during init.
; USED BY: ESQ_MainInitAndRun
; NOTES: First three entries are seeded via +$5C20 offsets; later entries may
;   be direct 696x241 raster allocations.
;------------------------------------------------------------------------------
ESQSHARED_DisplayContextPlaneBase0:
DATA_WDISP_BSS_LONG_220A:
    DS.L    1
ESQSHARED_DisplayContextPlaneBase1:
DATA_WDISP_BSS_LONG_220B:
    DS.L    1
ESQSHARED_DisplayContextPlaneBase2:
DATA_WDISP_BSS_LONG_220C:
    DS.L    1
ESQSHARED_DisplayContextPlaneBase3:
DATA_WDISP_BSS_LONG_220D:
    DS.L    1
ESQSHARED_DisplayContextPlaneBase4:
DATA_WDISP_BSS_LONG_220E:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: WDISP_ReservedLong220F   (reserved long slot near interrupt state)
; TYPE: u32
; PURPOSE: Unresolved/reserved storage between display-context plane pointers and interrupt globals.
; USED BY: ?? (no direct callsite reads/writes identified yet)
; NOTES: Keep layout unchanged; treat as reserved until a concrete usage is confirmed.
;------------------------------------------------------------------------------
WDISP_ReservedLong220F:
DATA_WDISP_BSS_LONG_220F:
    DS.L    1
Global_REF_INTERRUPT_STRUCT_INTB_VERTB:
    DS.L    1
Global_REF_INTERRUPT_STRUCT_INTB_AUD1:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: WDISP_SerialIoRequestPtr/WDISP_SerialMessagePortPtr   (serial I/O request + msg port)
; TYPE: pointer/pointer
; PURPOSE: Startup serial-open state used to configure and later close serial.device.
; USED BY: ESQ_MainInitAndRun, CLEANUP_ClearRbfInterruptAndSerial
; NOTES: Serial IORequest is configured via _LVOOpenDevice/_LVODoIO and freed during cleanup.
;------------------------------------------------------------------------------
WDISP_SerialIoRequestPtr:
LAB_2211_SERIAL_PORT_MAYBE:
    DS.L    1
WDISP_SerialMessagePortPtr:
DATA_WDISP_BSS_LONG_2212:
    DS.L    1
Global_REF_INTB_RBF_64K_BUFFER:
    DS.L    1
Global_REF_INTERRUPT_STRUCT_INTB_RBF:
    DS.L    1
Global_REF_96_BYTES_ALLOCATED:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: WDISP_DisplayContextBase   (display context base pointer)
; TYPE: pointer
; PURPOSE: Base pointer to a shared display context containing rastport refs/state.
; USED BY: WDISP_*, TEXTDISP_*, ESQ_*, LADFUNC_*, SCRIPT4_*
; NOTES: Callers derive related fields via fixed offsets from this base.
;------------------------------------------------------------------------------
WDISP_DisplayContextBase:
    DS.L    1
Global_REF_RASTPORT_1:
    DS.L    1
Global_REF_RASTPORT_2:
    DS.L    1
Global_REF_320_240_BITMAP:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: WDISP_352x240RasterPtrTable   (352x240 raster pointer table)
; TYPE: pointer[4]
; PURPOSE: Stores four 352x240 raster allocations used by display setup/teardown.
; USED BY: ESQ_MainInitAndRun, CLEANUP_ReleaseDisplayResources
; NOTES: Each entry is allocated via GRAPHICS_AllocRaster and zero-cleared.
;------------------------------------------------------------------------------
WDISP_352x240RasterPtrTable:
DATA_WDISP_BSS_LONG_221A:
    DS.L    8
Global_REF_696_400_BITMAP:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: WDISP_BannerRowScratchRasterTable0/1/2   (696x509 scratch raster bases)
; TYPE: pointer/pointer/pointer
; PURPOSE: Primary 696x509 raster bases used to derive display-context plane pointers and banner row copies.
; USED BY: ESQ_MainInitAndRun, GCOMMAND_RefreshBannerTables, ESQSHARED4_*, CLEANUP_ReleaseDisplayResources
; NOTES: Label `DATA_WDISP_BSS_LONG_221E` spans additional contiguous longs; first long is table entry #2.
;------------------------------------------------------------------------------
WDISP_BannerRowScratchRasterTable0:
DATA_WDISP_BSS_LONG_221C:
    DS.L    1
WDISP_BannerRowScratchRasterTable1:
DATA_WDISP_BSS_LONG_221D:
    DS.L    1
WDISP_BannerRowScratchRasterTable2:
DATA_WDISP_BSS_LONG_221E:
    DS.L    6
;------------------------------------------------------------------------------
; SYM: WDISP_BannerGridBitmapStruct/WDISP_LivePlaneRasterTable0..2   (696x2 bitmap + live plane bases)
; TYPE: struct + pointer fields
; PURPOSE: BitMap struct and live-plane raster pointers for the 696x2 working bitmap used by ESQSHARED copy paths.
; USED BY: ESQ_MainInitAndRun, ESQSHARED4_*, CLEANUP_ReleaseDisplayResources
; NOTES: Plane pointer aliases map into the BitMap plane-pointer region.
;------------------------------------------------------------------------------
WDISP_BannerGridBitmapStruct:
DATA_WDISP_BSS_LONG_221F:
    DS.L    2
WDISP_LivePlaneRasterTable0:
DATA_WDISP_BSS_LONG_2220:
    DS.L    1
WDISP_LivePlaneRasterTable1:
DATA_WDISP_BSS_LONG_2221:
    DS.L    1
WDISP_LivePlaneRasterTable2:
DATA_WDISP_BSS_LONG_2222:
    DS.L    6
Global_REF_696_241_BITMAP:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: WDISP_DisplayContextPlanePointer0..4   (display-context plane pointer set)
; TYPE: pointer array
; PURPOSE: Plane pointers installed into ESQSHARED display-context state during startup.
; USED BY: ESQ_MainInitAndRun, TLIBA3_* display-context VM paths, CLEANUP_ReleaseDisplayResources
; NOTES: Initial entries may be seeded from +$5C20 offsets; later entries come from 696x241 raster allocs.
;------------------------------------------------------------------------------
WDISP_DisplayContextPlanePointer0:
DATA_WDISP_BSS_LONG_2224:
    DS.L    1
WDISP_DisplayContextPlanePointer1:
DATA_WDISP_BSS_LONG_2225:
    DS.L    1
WDISP_DisplayContextPlanePointer2:
DATA_WDISP_BSS_LONG_2226:
    DS.L    1
WDISP_DisplayContextPlanePointer3:
DATA_WDISP_BSS_LONG_2227:
    DS.L    1
WDISP_DisplayContextPlanePointer4:
DATA_WDISP_BSS_LONG_2228:
    DS.L    4
;------------------------------------------------------------------------------
; SYM: WDISP_BannerWorkRasterPtr   (banner work raster pointer)
; TYPE: pointer
; PURPOSE: Allocated 696x15 raster used as a shared banner/copper work surface.
; USED BY: ESQ init/cleanup, GCOMMAND_CopyImageDataToBitmap, ESQSHARED4 raster fill helpers
; NOTES: Freed during cleanup with width 696 and height 15.
;------------------------------------------------------------------------------
WDISP_BannerWorkRasterPtr:
    DS.L    1
WDISP_HighlightBufferMode:
DATA_WDISP_BSS_WORD_222A:
    DS.W    1
WDISP_HighlightRasterHeightPx:
DATA_WDISP_BSS_WORD_222B:
    DS.W    1
WDISP_ExecBaseHookPtr:
DATA_WDISP_BSS_LONG_222C:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryGroupCode   (secondary group discriminator byte)
; TYPE: u8
; PURPOSE: Input/group code used to route records into the secondary group.
; USED BY: ESQIFF2_*, TEXTDISP3_*
; NOTES: Compared against incoming record prefix bytes.
;------------------------------------------------------------------------------
TEXTDISP_SecondaryGroupCode:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryGroupPresentFlag   (secondary group present flag)
; TYPE: u8
; PURPOSE: Indicates whether secondary-group entries are currently available.
; USED BY: NEWGRID_*, NEWGRID1_* rendering/visibility paths
; NOTES: Treated as boolean (zero/non-zero).
;------------------------------------------------------------------------------
TEXTDISP_SecondaryGroupPresentFlag:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryGroupEntryCount   (secondary group entry count)
; TYPE: u16
; PURPOSE: Number of entries in secondary text/display group.
; USED BY: TEXTDISP_GetGroupEntryCount, NEWGRID_* consumers
; NOTES: Paired with TEXTDISP_PrimaryGroupEntryCount.
;------------------------------------------------------------------------------
TEXTDISP_SecondaryGroupEntryCount:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryGroupCode   (primary group discriminator byte)
; TYPE: u16 (low byte used)
; PURPOSE: Input/group code used to route records into the primary group.
; USED BY: ESQIFF2_*, TEXTDISP3_*
; NOTES: Compared to record prefix bytes, similar to secondary-group code.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryGroupCode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryGroupEntryCount   (primary group entry count)
; TYPE: u16
; PURPOSE: Number of entries in primary text/display group.
; USED BY: TEXTDISP find/filter/draw flows
; NOTES: Used as loop upper bound across entry-table scans.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryGroupEntryCount:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_RecordLength   (current record payload length)
; TYPE: u16
; PURPOSE: Length of the active parsed record buffer payload.
; USED BY: ESQIFF2_*, UNKNOWN_* checksum/parse wrappers
; NOTES: Often used to index the trailing control/check byte.
;------------------------------------------------------------------------------
ESQIFF_RecordLength:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryEntryPtrTable   (primary entry pointer table)
; TYPE: pointer[]
; PURPOSE: Array of pointers to primary-group entry structs.
; USED BY: TEXTDISP3_*, NEWGRID1_*, ESQIFF2_*
; NOTES: Indexed by entry id; paired with TEXTDISP_PrimaryTitlePtrTable.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryEntryPtrTable:
    DS.L    301
TEXTDISP_SecondaryEntryPtrTablePreSlot:
DATA_WDISP_BSS_LONG_2234:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryEntryPtrTable   (secondary entry pointer table)
; TYPE: pointer[]
; PURPOSE: Array of pointers to secondary-group entry structs.
; USED BY: NEWGRID1_*, TEXTDISP3_*, ESQIFF2_*
; NOTES: Companion table to TEXTDISP_PrimaryEntryPtrTable.
;------------------------------------------------------------------------------
TEXTDISP_SecondaryEntryPtrTable:
    DS.L    302
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryTitlePtrTable   (primary title pointer table)
; TYPE: pointer[]
; PURPOSE: Per-entry title/name pointers for primary-group entries.
; USED BY: TEXTDISP3_*, NEWGRID1_*
; NOTES: Indexed in lockstep with TEXTDISP_PrimaryEntryPtrTable.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryTitlePtrTable:
    DS.L    302
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryTitlePtrTable   (secondary title pointer table)
; TYPE: pointer[]
; PURPOSE: Per-entry title/name pointers for secondary-group entries.
; USED BY: TEXTDISP3_*, NEWGRID1_*
; NOTES: Indexed in lockstep with TEXTDISP_SecondaryEntryPtrTable.
;------------------------------------------------------------------------------
TEXTDISP_SecondaryTitlePtrTable:
    DS.L    302
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryGroupHeaderCode/TEXTDISP_SecondaryGroupHeaderCode   (group header code mirrors)
; TYPE: u8/u8
; PURPOSE: Stores group-code bytes copied from primary/secondary payload headers.
; USED BY: DISKIO2 load paths, ESQSHARED entry-allocation paths, ESQFUNC diagnostics
; NOTES: Typically mirrors TEXTDISP_PrimaryGroupCode/TEXTDISP_SecondaryGroupCode after successful loads.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryGroupHeaderCode:
    DS.B    1
TEXTDISP_SecondaryGroupHeaderCode:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: CLOCK_DaySlotIndex   (clock-derived day slot index)
; TYPE: u16
; PURPOSE: Stores day-slot index computed from current clock/time state.
; USED BY: NEWGRID_*, NEWGRID1_*, DISPTEXT_*, DST2_*
; NOTES: Updated by NEWGRID_ComputeDaySlotFromClock* helpers.
;------------------------------------------------------------------------------
CLOCK_DaySlotIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CLOCK_CacheMonthIndex0/CLOCK_CacheDayIndex0/CLOCK_CacheYear/CLOCK_CacheHour/CLOCK_CacheMinuteOrSecond/Global_REF_CLOCKDATA_STRUCT/CLOCK_CacheAmPmFlag
; TYPE: u16/u16/u16/u16/u16/u16/s16
; PURPOSE: Cached clock/date fields consumed by diagnostics, log formatters, and RTC write/read helpers.
; USED BY: PARSEINI_*, ESQFUNC_*, FLIB_*, ESQDISP_*, SCRIPT3_*
; NOTES: Month/day are stored as 0-based indexes for table lookups and normalized by PARSEINI_NormalizeClockData.
;        Global_REF_CLOCKDATA_STRUCT is treated as a seconds/clock snapshot field in multiple call sites.
;        CLOCK_CacheAmPmFlag uses 0 for AM and non-zero (typically -1) for PM.
;------------------------------------------------------------------------------
CLOCK_CacheMonthIndex0:
DATA_WDISP_BSS_WORD_223B:
    DS.W    1
CLOCK_CacheDayIndex0:
DATA_WDISP_BSS_WORD_223C:
    DS.W    1
CLOCK_CacheYear:
DATA_WDISP_BSS_WORD_223D:
    DS.W    1
CLOCK_CacheHour:
DATA_WDISP_BSS_WORD_223E:
    DS.W    1
CLOCK_CacheMinuteOrSecond:
DATA_WDISP_BSS_WORD_223F:
    DS.W    1
Global_REF_CLOCKDATA_STRUCT:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DST_PrimaryCountdown   (primary DST/banner countdown)
; TYPE: u16
; PURPOSE: Countdown used by DST queue slot 0 when advancing/releasing the primary banner entry.
; USED BY: DST_UpdateBannerQueue, DST_TickBannerCounters, DATETIME_BuildFromGlobals, DISKIO2_*
; NOTES: Copied into slot field +16 during updates; decremented when no active slot-0 entry exists.
;------------------------------------------------------------------------------
DST_PrimaryCountdown:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_BannerSlotCursor   (banner slot cursor/index)
; TYPE: u16
; PURPOSE: Cached slot index used by DST/diagnostic banner date calculations.
; USED BY: DST_BuildBannerTimeEntry, ESQDISP_DrawStatusBanner_Impl
; NOTES: Read-only in current code scan; treated as an index-like value (with $FF checks).
;------------------------------------------------------------------------------
WDISP_BannerSlotCursor:
DATA_WDISP_BSS_WORD_2242:
    DS.W    1
CLOCK_CacheAmPmFlag:
DATA_WDISP_BSS_WORD_2243:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQFUNC_CListLinePointer   (diagnostic C-list line pointer/value)
; TYPE: u16
; PURPOSE: Value printed in ESQFUNC memory/status diagnostics as the C-list line pointer field.
; USED BY: ESQFUNC_DrawMemoryStatusScreen
; NOTES: Naming is diagnostic-format driven; keep conservative until more writers are identified.
;------------------------------------------------------------------------------
ESQFUNC_CListLinePointer:
DATA_WDISP_BSS_WORD_2244:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusLabelBuffer   (weather/status label buffer)
; TYPE: char[13]
; PURPOSE: Stores a short label used for wildcard match tests and serialized status text.
; USED BY: UNKNOWN_ParseRecordAndUpdateDisplay, ESQPROTO_ParseDigitLabelAndDisplay, DISKIO2_*
; NOTES: Backed by `DS.L 2` + `DS.W 1` + `DS.B 1`; copied as a NUL-terminated byte string.
;------------------------------------------------------------------------------
WDISP_WeatherStatusLabelBuffer:
DATA_WDISP_BSS_LONG_2245:
    DS.L    2
    DS.W    1
    DS.B    1
;------------------------------------------------------------------------------
; SYM: WDISP_StatusListMatchPattern   (status list wildcard pattern buffer)
; TYPE: char[11]
; PURPOSE: Stores a short wildcard/match pattern for status-list record parsing.
; USED BY: UNKNOWN_ParseListAndUpdateEntries, ESQPROTO_CopyLabelToGlobal
; NOTES: Backed by `DS.B 1` + `DS.L 2` + `DS.W 1`; written as a NUL-terminated byte string.
;------------------------------------------------------------------------------
WDISP_StatusListMatchPattern:
DATA_WDISP_BSS_BYTE_2246:
    DS.B    1
    DS.L    2
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryGroupRecordChecksum   (primary group record checksum cache)
; TYPE: u8 (stored in word slot)
; PURPOSE: Caches checksum byte from the latest primary-group payload header.
; USED BY: ESQIFF2 refresh checks, DISKIO2 read/write serialization, ESQDISP secondary->primary promotion
; NOTES: Compared against ESQIFF_RecordChecksumByte to detect changed primary-group data.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryGroupRecordChecksum:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryGroupRecordLength   (primary group record length cache)
; TYPE: u16
; PURPOSE: Caches parsed record length for the active primary-group payload.
; USED BY: ESQIFF2 refresh checks, DISKIO2 read/write serialization, ESQDISP secondary->primary promotion
; NOTES: Paired with TEXTDISP_PrimaryGroupRecordChecksum.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryGroupRecordLength:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISKIO_ErrorMessageScratch   (disk I/O error message scratch buffer)
; TYPE: u8[41]
; PURPOSE: Temporary formatted message storage for disk/load/save status text.
; USED BY: MAINB_* disk error display path, ESQ_*, DISKIO2_*
; NOTES: Backed by 10 longs plus trailing byte.
;   Frequently written via WDISP_SPrintf (no destination length parameter).
;------------------------------------------------------------------------------
DISKIO_ErrorMessageScratch:
    DS.L    10
    DS.B    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryGroupPresentFlag   (primary group present flag)
; TYPE: u8
; PURPOSE: Indicates whether primary-group entries are currently available.
; USED BY: NEWGRID_*, NEWGRID1_* rendering/visibility paths
; NOTES: Treated as boolean (zero/non-zero).
;------------------------------------------------------------------------------
TEXTDISP_PrimaryGroupPresentFlag:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_GroupMutationState   (group mutation state id)
; TYPE: u16
; PURPOSE: Tracks which group changed while parsing/updating entry payloads.
; USED BY: ESQSHARED entry-insert path, ESQDISP group promotion path, DISKIO2 load path
; NOTES: Observed values: 0=none/reset, 1=primary touched, 2=secondary touched, 3=secondary promoted to primary.
;------------------------------------------------------------------------------
TEXTDISP_GroupMutationState:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_MaxEntryTitleLength   (max entry-title length cache)
; TYPE: u16
; PURPOSE: Tracks longest normalized entry title length across active groups.
; USED BY: DISKIO2 group load, ESQSHARED entry insertion, ESQIFF2 fixed-width text formatting
; NOTES: Reset to 0 when payload metadata changes; used to space-pad shorter titles.
;------------------------------------------------------------------------------
TEXTDISP_MaxEntryTitleLength:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryGroupRecordChecksum   (secondary group record checksum cache)
; TYPE: u8 (stored in word slot)
; PURPOSE: Caches checksum byte from the latest secondary-group payload header.
; USED BY: ESQIFF2 refresh checks, DISKIO2 read/write serialization, ESQDISP group promotion
; NOTES: Paired with TEXTDISP_SecondaryGroupRecordLength.
;------------------------------------------------------------------------------
TEXTDISP_SecondaryGroupRecordChecksum:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SecondaryGroupRecordLength   (secondary group record length cache)
; TYPE: u16
; PURPOSE: Caches the parsed record length for the active secondary group payload.
; USED BY: ESQIFF2 refresh checks, DISKIO2 read/write serialization, ESQDISP group promotion
; NOTES: Works in tandem with TEXTDISP_SecondaryGroupRecordChecksum (secondary checksum byte cache).
;------------------------------------------------------------------------------
TEXTDISP_SecondaryGroupRecordLength:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_AliasPtrTable   (text-display alias pointer table)
; TYPE: pointer[]
; PURPOSE: Stores alias/string pointers used by text display and list serialization paths.
; USED BY: ESQPARS_*, PARSEINI_*, TEXTDISP3_*, DISKIO2_*
; NOTES: Sized as 303 longwords to preserve original layout.
;------------------------------------------------------------------------------
TEXTDISP_AliasPtrTable:
    DS.L    303
;------------------------------------------------------------------------------
; SYM: ED_AdRecordPtrTable   (ad record pointer table base)
; TYPE: pointer[]
; PURPOSE: Base pointer table used by ED ad-edit routines to access per-ad records.
; USED BY: ED_UpdateAdNumberDisplay, ED_ApplyActiveFlagToAdData
; NOTES: Indexed by current ad number (`index*4`); declared as layout anchor to preserve offsets.
;------------------------------------------------------------------------------
ED_AdRecordPtrTable:
DATA_WDISP_BSS_LONG_2250:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: LADFUNC_EntryPtrTable   (ladfunc entry pointer table)
; TYPE: pointer[46]
; PURPOSE: Pointer table for LADFUNC-managed entries/list items.
; USED BY: LADFUNC_*, TEXTDISP2_*
; NOTES: Entry count is tracked by LADFUNC_EntryCount.
;------------------------------------------------------------------------------
LADFUNC_EntryPtrTable:
    DS.L    46
;------------------------------------------------------------------------------
; SYM: ED_DiagnosticsScreenActive   (diagnostics screen active flag)
; TYPE: u16
; PURPOSE: Gates diagnostic/attention overlays and related status text draws.
; USED BY: ED1_*, ESQIFF2_*, ESQFUNC_*, DISKIO2_*, UNKNOWN_*
; NOTES: Set when diagnostics UI is shown; cleared when overlays are dismissed.
;------------------------------------------------------------------------------
ED_DiagnosticsScreenActive:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_RecordChecksumByte   (record checksum byte)
; TYPE: u16 (low byte used)
; PURPOSE: Stores checksum/CRC byte associated with the current record payload.
; USED BY: ESQIFF2_*, UNKNOWN_* verification helpers
; NOTES: Compared against generated checksum values before parse dispatch.
;------------------------------------------------------------------------------
ESQIFF_RecordChecksumByte:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: LADFUNC_LineSlotWriteIndex   (line-slot ring index)
; TYPE: u16
; PURPOSE: Current write index into LADFUNC line-text/control tables.
; USED BY: LADFUNC_BuildHighlightLinesFromText, ESQFUNC_InitLineTextBuffers
; NOTES: Wraps in a 20-slot ring (0..19).
;------------------------------------------------------------------------------
LADFUNC_LineSlotWriteIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISPLIB_PreviousSearchWrappedFlag   (displib previous-search wrapped flag)
; TYPE: u16
; PURPOSE: Latches whether previous-index scan hit the lower-bound clamp path.
; USED BY: DISPLIB_FindPreviousValidEntryIndex
; NOTES: Set when non-wide scans keep decrementing and clear when clamped to index 0.
;   No external readers found yet; likely a legacy/debug side-channel.
;------------------------------------------------------------------------------
DISPLIB_PreviousSearchWrappedFlag:
DATA_WDISP_BSS_WORD_2255:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQ_BannerCharResetPulse   (banner-char reset pulse latch)
; TYPE: u16
; PURPOSE: Set to 1 whenever banner-char index is forced back to range start.
; USED BY: ESQ_AdvanceBannerCharIndex
; NOTES: No direct readers found in current scan; likely legacy telemetry/state.
;------------------------------------------------------------------------------
ESQ_BannerCharResetPulse:
DATA_WDISP_BSS_WORD_2256:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_BannerCharIndex   (current banner char index)
; TYPE: u16
; PURPOSE: Holds the active 1..48 banner character index for cycling/animation logic.
; USED BY: ESQ_AdvanceBannerCharIndex, ESQ startup/init helpers
; NOTES: Updated every tick and reset from `WDISP_BannerCharRangeStart` when range bounds are hit.
;------------------------------------------------------------------------------
WDISP_BannerCharIndex:
DATA_WDISP_BSS_WORD_2257:
    DS.W    1
    DS.B    1
DATA_WDISP_BSS_BYTE_2258:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_ChannelLabelBuffer   (channel label text buffer)
; TYPE: char[450] (storage-backed)
; PURPOSE: Scratch/output buffer for labels such as "On Channel <name>" used in banner rendering.
; USED BY: TEXTDISP_BuildChannelLabel, TEXTDISP_DrawChannelBanner, CLEANUP3_*
; NOTES: Backed by 112 longs + trailing word storage; treated as a byte string buffer.
;------------------------------------------------------------------------------
TEXTDISP_ChannelLabelBuffer:
    DS.L    112
    DS.W    1
;------------------------------------------------------------------------------
; SYM: LADFUNC_LineTextBufferPtrs/LADFUNC_LineControlCodeTable   (line buffer tables)
; TYPE: pointer[20]/u16[20]
; PURPOSE: Stores per-line text buffers and parsed control-code metadata for LADFUNC text wrapping.
; USED BY: LADFUNC_BuildHighlightLinesFromText, ESQFUNC_InitLineTextBuffers, ESQFUNC_FreeLineTextBuffers
; NOTES: Buffer pointers are individually allocated/freed in ESQFUNC (60 bytes each).
;------------------------------------------------------------------------------
LADFUNC_LineTextBufferPtrs:
    DS.L    20
LADFUNC_LineControlCodeTable:
    DS.L    10
;------------------------------------------------------------------------------
; SYM: WDISP_BannerCharPhaseShift   (banner char phase-shift value)
; TYPE: s16
; PURPOSE: Per-tick phase/step value applied by banner-char index advance logic.
; USED BY: DST_TickBannerCounters, ESQ_AdvanceBannerCharIndex, ESQFUNC_DrawMemoryStatusScreen
; NOTES: Derived from DST counters and applied as +/- two-step adjustments in index math.
;------------------------------------------------------------------------------
WDISP_BannerCharPhaseShift:
DATA_WDISP_BSS_WORD_225C:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: LADFUNC_LineSlotSecondaryIndex   (line-slot secondary index)
; TYPE: u16
; PURPOSE: Companion line-slot index reset alongside LADFUNC_LineSlotWriteIndex.
; USED BY: ESQFUNC_AllocateLineTextBuffers
; NOTES: Cleared during line-buffer allocation; no reader confirmed yet.
;------------------------------------------------------------------------------
LADFUNC_LineSlotSecondaryIndex:
DATA_WDISP_BSS_WORD_225D:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DATA_WDISP_BSS_LONG_225E   (reserved state long @225E)
; TYPE: u32
; PURPOSE: Reserved state slot; currently only initialized during startup.
; USED BY: ESQ startup init
; NOTES: Set to 7 in ESQ init; no read sites identified yet.
;------------------------------------------------------------------------------
DATA_WDISP_BSS_LONG_225E:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_RefreshStateFlag   (newgrid refresh/init state)
; TYPE: u32
; PURPOSE: Cross-module signal controlling NEWGRID reinitialization/refresh behavior.
; USED BY: NEWGRID_ProcessGridMessages, ESQDISP_*, ESQIFF2_*, ESQFUNC_*
; NOTES: Observed states: 0/1 trigger reinit path, 2 after NEWGRID init completes.
;------------------------------------------------------------------------------
NEWGRID_RefreshStateFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_MessagePumpSuspendFlag/NEWGRID_ModeSelectorState/NEWGRID_LastRefreshRequest
; TYPE: u32/u32/u32
; PURPOSE: Companion refresh-state globals used to gate NEWGRID message processing and mode transitions.
; USED BY: ESQFUNC_UpdateRefreshModeState, ESQDISP_ProcessGridMessagesIfIdle, NEWGRID_GetGridModeIndex, ED1_ExitEscMenu
; NOTES: `NEWGRID_MessagePumpSuspendFlag` blocks grid message pumping while set.
;   `NEWGRID_ModeSelectorState` is written as 0 or 2 by current paths.
;   `NEWGRID_LastRefreshRequest` caches the last refresh-mode request argument.
;------------------------------------------------------------------------------
NEWGRID_MessagePumpSuspendFlag:
DATA_WDISP_BSS_LONG_2260:
    DS.L    1
NEWGRID_ModeSelectorState:
DATA_WDISP_BSS_LONG_2261:
    DS.L    1
NEWGRID_LastRefreshRequest:
DATA_WDISP_BSS_LONG_2262:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: Global_UIBusyFlag   (global UI busy/modal flag)
; TYPE: u16
; PURPOSE: Indicates UI/modal sections where interactive updates are gated.
; USED BY: ESQ_*, ED1_*, DISKIO_*, TEXTDISP2_*, NEWGRID_*, GCOMMAND3_*
; NOTES: Typically checked as boolean (non-zero = busy/modal).
;------------------------------------------------------------------------------
Global_UIBusyFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CLEANUP_PendingAlertFlag   (pending alert tick flag)
; TYPE: u16
; PURPOSE: One-shot flag raised by global tick logic and consumed by alert processing.
; USED BY: ESQ_TickGlobalCounters, CLEANUP_ProcessAlerts, ESQFUNC_*
; NOTES: Set when modulo-60 tick rolls and cleared after CLEANUP_ProcessAlerts runs.
;------------------------------------------------------------------------------
CLEANUP_PendingAlertFlag:
DATA_WDISP_BSS_WORD_2264:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: LADFUNC_EntryCount   (ladfunc entry count)
; TYPE: u16
; PURPOSE: Number of active entries in LADFUNC_EntryPtrTable.
; USED BY: LADFUNC_*, TEXTDISP2_*, SCRIPT2_*, ED1_*
; NOTES: Common values observed include $24 and $2E.
;------------------------------------------------------------------------------
LADFUNC_EntryCount:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: PARSEINI_CtrlHChangeGateFlag   (CTRL_H change gate flag)
; TYPE: u16
; PURPOSE: Enables/disables CTRL_H-change processing and related status refresh actions.
; USED BY: PARSEINI_CheckCtrlHChange, ED2_HandleMenuActions, ESQ startup init
; NOTES: Toggled via ED2 menu action path; checked as boolean gate in PARSEINI.
;------------------------------------------------------------------------------
PARSEINI_CtrlHChangeGateFlag:
DATA_WDISP_BSS_WORD_2266:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQSHARED_BannerRowScratchRasterBase0/1/2   (banner row scratch raster bases)
; TYPE: pointer/pointer/pointer
; PURPOSE: Cached raster bases for the three banner row scratch planes used by ESQSHARED blit helpers.
; USED BY: ESQ startup init, ESQSHARED4_*
; NOTES: Seeded from `WDISP_BannerRowScratchRasterTable0..2` during startup.
;------------------------------------------------------------------------------
ESQSHARED_BannerRowScratchRasterBase0:
DATA_WDISP_BSS_LONG_2267:
    DS.L    1
ESQSHARED_BannerRowScratchRasterBase1:
DATA_WDISP_BSS_LONG_2268:
    DS.L    1
ESQSHARED_BannerRowScratchRasterBase2:
DATA_WDISP_BSS_LONG_2269:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_DiagnosticsViewMode   (diagnostics view mode)
; TYPE: u16
; PURPOSE: Selects which diagnostics screen page is drawn/updated.
; USED BY: ED2_HandleDiagnosticsMenuActions, ESQFUNC_DrawMemoryStatusScreen, ESQPARS processCommand_K_Clock gate
; NOTES: Value 0 draws memory/status view; value 1 enables calendar-style diagnostics view.
;------------------------------------------------------------------------------
ED_DiagnosticsViewMode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQ_SelectCodeBuffer   (startup select-code text buffer)
; TYPE: u8[10]
; PURPOSE: Stores argv[1] select-code text shown in startup/diagnostics paths.
; USED BY: ESQ_MainInitAndRun, ED1_DrawDiagnosticsScreen, ESQSHARED_MatchSelectionCodeWithOptionalSuffix
; NOTES: Backed by `DS.L 2` + `DS.W 1` (10 bytes total, including NUL).
;   Current startup copy path writes bytewise until source NUL with no local
;   destination bound check.
;------------------------------------------------------------------------------
ESQ_SelectCodeBuffer:
Global_PTR_STR_SELECT_CODE:
    DS.L    2
    DS.W    1
Global_REF_BAUD_RATE:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQSHARED_BannerColorModeWord   (banner color mode word)
; TYPE: u16
; PURPOSE: Mode/selector word passed into legacy ESQSHARED4 banner-color setup stubs.
; USED BY: ED1_ExitEscMenu, ESQSHARED4 stubs
; NOTES: Cleared on ESC-menu exit; no direct non-zero writer identified yet.
;   Can be clobbered indirectly by ESQ argv[1] copy overflow from ESQ_SelectCodeBuffer.
;------------------------------------------------------------------------------
ESQSHARED_BannerColorModeWord:
DATA_WDISP_BSS_WORD_226D:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_Rastport2PenModeSelector   (rastport2 pen-mode selector)
; TYPE: u32
; PURPOSE: Optional selector controlling alternate pen setup in ED_InitRastport2Pens.
; USED BY: ED_InitRastport2Pens
; NOTES: Compared against literal 14; no direct producer identified in current scan.
;   Can be clobbered indirectly by ESQ argv[1] copy overflow from ESQ_SelectCodeBuffer.
;------------------------------------------------------------------------------
ED_Rastport2PenModeSelector:
DATA_WDISP_BSS_LONG_226E:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: WDISP_BannerCharRangeStart   (banner char range start index)
; TYPE: u16
; PURPOSE: Start index for the active banner char window/range.
; USED BY: ESQ_ClampBannerCharRange, CLEANUP_ProcessAlerts, ESQ_AdvanceBannerCharIndex
; NOTES: Paired with `DATA_WDISP_BSS_WORD_2280` (range end) for 1..48 wrapping behavior.
;------------------------------------------------------------------------------
WDISP_BannerCharRangeStart:
DATA_WDISP_BSS_WORD_226F:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CLOCK_HalfHourSlotIndex   (half-hour slot index)
; TYPE: u16
; PURPOSE: Current half-hour slot index derived from clock/time state.
; USED BY: ESQDISP_*, ESQFUNC_*, TEXTDISP_*, COI_*, CLEANUP2_*
; NOTES: Produced by ESQ_GetHalfHourSlotIndex-style helpers.
;------------------------------------------------------------------------------
CLOCK_HalfHourSlotIndex:
    DS.W    1
DATA_WDISP_BSS_WORD_2271:
    DS.W    1
DATA_WDISP_BSS_LONG_2272:
    DS.L    1
DATA_WDISP_BSS_WORD_2273:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CLOCK_CurrentDayOfWeekIndex/CLOCK_CurrentMonthIndex/CLOCK_CurrentDayOfMonth/CLOCK_CurrentYearValue   (current calendar tuple)
; TYPE: u16/u16/u16/u16
; PURPOSE: Holds day-of-week, month, day-of-month, and year values used by date formatters.
; USED BY: GENERATE_GRID_DATE_STRING, RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY, DST_*, NEWGRID_*
; NOTES: Day/month values are used as direct indexes into day/month pointer tables.
;------------------------------------------------------------------------------
CLOCK_CurrentDayOfWeekIndex:
    DS.W    1
CLOCK_CurrentMonthIndex:
    DS.W    1
CLOCK_CurrentDayOfMonth:
    DS.W    1
CLOCK_CurrentYearValue:
    DS.W    1
Global_WORD_CURRENT_HOUR:
    DS.W    1
Global_WORD_CURRENT_MINUTE:
    DS.W    1
Global_WORD_CURRENT_SECOND:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DST_SecondaryCountdown   (secondary DST/banner countdown)
; TYPE: u16
; PURPOSE: Companion countdown for DST queue slot 1 / alternate banner window flow.
; USED BY: DST_UpdateBannerQueue, DST_TickBannerCounters, DATETIME_BuildFromGlobals
; NOTES: Used only when secondary-slot mode is enabled (e.g., `DATA_ESQ_STR_N_1DD2 == 'Y'` paths).
;------------------------------------------------------------------------------
DST_SecondaryCountdown:
    DS.W    1
DATA_WDISP_BSS_WORD_227C:
    DS.W    1
Global_WORD_USE_24_HR_FMT:
    DS.W    1
DATA_WDISP_BSS_WORD_227E:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusCountdown   (weather status countdown)
; TYPE: u16 (low byte used)
; PURPOSE: Countdown gate controlling timed weather-status overlay/banner rendering.
; USED BY: WDISP weather draw paths, CLEANUP_ProcessAlerts, ED2 weather setup
; NOTES: Commonly initialized to `0x3C` and decremented in periodic update loops.
;------------------------------------------------------------------------------
WDISP_WeatherStatusCountdown:
    DS.W    1
DATA_WDISP_BSS_WORD_2280:
    DS.W    1
CTRL_H:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CTRL_HPreviousSample/CTRL_HDeltaMax   (CTRL_H sampling state)
; TYPE: u16/u16
; PURPOSE: Previous CTRL_H sample and the observed maximum wrapped delta.
; USED BY: PARSEINI_CheckCtrlHChange, PARSEINI_UpdateCtrlHDeltaMax, ESQFUNC_DrawMemoryStatusScreen, APP_*
; NOTES: Delta is computed modulo 500 (`+500` wrap for negative differences).
;------------------------------------------------------------------------------
CTRL_HPreviousSample:
    DS.W    1
CTRL_HDeltaMax:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CTRL_BufferedByteCount   (CTRL buffer byte count)
; TYPE: u16
; PURPOSE: Tracks the current number of bytes stored in CTRL_BUFFER.
; USED BY: ESQ_CaptureCtrlBit4Stream, DISKIO_ResetCtrlInputStateIfIdle, ESQ init/reset
; NOTES: Computed as wrapped delta between CTRL_H and CTRL_HPreviousSample (mod 500).
;------------------------------------------------------------------------------
CTRL_BufferedByteCount:
DATA_WDISP_BSS_WORD_2284:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_ParseAttemptCount   (record parse attempt counter)
; TYPE: u16
; PURPOSE: Counts checksum/parse attempts on incoming ESQIFF records.
; USED BY: ESQPROTO_VerifyChecksumAndParseRecord, ESQPROTO_VerifyChecksumAndParseList
; NOTES: Incremented before checksum verification.
;------------------------------------------------------------------------------
ESQIFF_ParseAttemptCount:
    DS.W    1
DATACErrs:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_LineErrorCount   (record line/length error counter)
; TYPE: u16
; PURPOSE: Counts record-line validation failures that are not checksum mismatches.
; USED BY: ESQPARS_*, ESQFUNC_DrawMemoryStatusScreen, ED2 diagnostics reset path
; NOTES: Displayed alongside data command/checksum counters on diagnostics screens.
;------------------------------------------------------------------------------
ESQIFF_LineErrorCount:
    DS.W    1
Global_WORD_H_VALUE:
    DS.W    1
Global_WORD_T_VALUE:
    DS.W    1
DATA_WDISP_BSS_WORD_228A:
    DS.W    1
Global_WORD_MAX_VALUE:
    DS.W    1
DATA_WDISP_BSS_WORD_228C:
    DS.W    1
; Flag indicating a UI banner/key highlight is active.
WDISP_HighlightActive:
    DS.W    1
; Index of the highlighted entry (if used by callers).
WDISP_HighlightIndex:
    DS.W    1
DATA_WDISP_BSS_WORD_228F:
    DS.W    1
DATA_WDISP_BSS_LONG_2290:
    DS.L    1
DATA_WDISP_BSS_WORD_2291:
    DS.W    1
DATA_WDISP_BSS_WORD_2292:
    DS.W    1
DATA_WDISP_BSS_WORD_2293:
    DS.W    1
DATA_WDISP_BSS_WORD_2294:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_PaletteTriplesRBase/WDISP_PaletteTriplesGBase/WDISP_PaletteTriplesBBase   (palette RGB triplet stream)
; TYPE: u8 stream
; PURPOSE: Packed RGB triplets used by highlight/weather palette-selection routines.
; USED BY: WDISP_*, ESQIFF_*, ESQFUNC_*, LADFUNC_*, ED1_*, APP2_*, TEXTDISP2_*
; NOTES: Callers iterate with a step of 3 bytes (R/G/B) across contiguous entries.
;------------------------------------------------------------------------------
WDISP_PaletteTriplesRBase:
    DS.B    1
WDISP_PaletteTriplesGBase:
    DS.B    1
WDISP_PaletteTriplesBBase:
    DS.L    23
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS_SelectionSuffixBuffer   (selection suffix buffer)
; TYPE: char[4]
; PURPOSE: Stores the optional selection suffix pattern for ESQ selection matching.
; USED BY: ESQPARS command 'E' handler, ESQSHARED_MatchSelectionCodeWithOptionalSuffix
; NOTES: NUL-terminated; size inferred from DS.L allocation.
;------------------------------------------------------------------------------
ESQPARS_SelectionSuffixBuffer:
DATA_WDISP_BSS_LONG_2298:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_StatusPacketReadyFlag   (status packet ready flag)
; TYPE: u16
; PURPOSE: Gates group-record parsing until a status packet has been applied.
; USED BY: ESQIFF2_ApplyIncomingStatusPacket_Return, ESQPARS command 'C' handler
; NOTES: Set to 1 after status packet parse; checked before group refresh.
;------------------------------------------------------------------------------
ESQIFF_StatusPacketReadyFlag:
DATA_WDISP_BSS_WORD_2299:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_RecordBufferPtr   (current ESQIFF record buffer pointer)
; TYPE: pointer
; PURPOSE: Points at the active incoming record buffer for checksum/parse routines.
; USED BY: ESQIFF2_*, UNKNOWN_* parse/checksum paths
; NOTES: Passed into parser/checksum helpers as source pointer.
;------------------------------------------------------------------------------
ESQIFF_RecordBufferPtr:
    DS.L    1
DATA_WDISP_BSS_BYTE_229B:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusBrushIndex/WDISP_WeatherStatusDigitChar   (weather status style fields)
; TYPE: u8/u16
; PURPOSE: Brush/style selector plus leading digit character used by weather-status banner rendering.
; USED BY: ESQPROTO_ParseDigitLabelAndDisplay, WDISP weather drawing routines, ED2 setup paths
; NOTES: Digit char is clamped to ASCII `'0'..'9'`; `'0'` is treated as a suppress/idle value in some paths.
;------------------------------------------------------------------------------
WDISP_WeatherStatusBrushIndex:
    DS.B    1
WDISP_WeatherStatusDigitChar:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS_Preamble55SeenFlag/ESQPARS_CommandPreambleArmedFlag   (serial preamble parser flags)
; TYPE: u16/u16
; PURPOSE: Tracks 0x55/0xAA preamble recognition before command payload dispatch.
; USED BY: ESQPARS serial command parser state machine (ESQPARS_ConsumeRbfByteAndDispatchCommand)
; NOTES: Cleared on parse errors and after command handling.
;------------------------------------------------------------------------------
ESQPARS_Preamble55SeenFlag:
    DS.W    1
ESQPARS_CommandPreambleArmedFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS_SelectionMatchCode   (selection match code)
; TYPE: u16
; PURPOSE: Stores the match result from ESQSHARED_MatchSelectionCodeWithOptionalSuffix.
; USED BY: ESQPARS command preamble handling, ESQ init/reset
; NOTES: Value 1 enables command-table dispatch; other values block.
;------------------------------------------------------------------------------
ESQPARS_SelectionMatchCode:
DATA_WDISP_BSS_WORD_22A0:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS_ResetArmedFlag   (reset command armed gate)
; TYPE: u16
; PURPOSE: Indicates that remote reset handling is armed for subsequent command bytes.
; USED BY: ESQPARS command parser paths (`processCommand_R_Reset`, binary/command transitions)
; NOTES: Cleared by most command branches after command handling completes.
;------------------------------------------------------------------------------
ESQPARS_ResetArmedFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_CTRL_CMD_BUFFER/SCRIPT_CTRL_READ_INDEX/SCRIPT_CTRL_CHECKSUM   (CTRL packet assembly state)
; TYPE: u8[200]/u16/u16
; PURPOSE: Collects inbound CTRL command bytes and tracks packet length + XOR checksum.
; USED BY: SCRIPT_HandleSerialCtrlCmd, SCRIPT_HandleBrushCommand
; NOTES: Current parser resets when SCRIPT_CTRL_READ_INDEX exceeds 198, keeping
;   packet body within the 200-byte backing store before NUL termination.
;------------------------------------------------------------------------------
SCRIPT_CTRL_CMD_BUFFER:
    DS.L    50
SCRIPT_CTRL_READ_INDEX:
    DS.W    1
SCRIPT_CTRL_CHECKSUM:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_DeferredActionDelayTicks   (deferred action delay ticks)
; TYPE: s16
; PURPOSE: Countdown used to arm deferred refresh actions and CTRL-line clears.
; USED BY: TEXTDISP_TickDisplayState, ESQ_TickGlobalCounters, CLEANUP_ProcessAlerts
; NOTES: Loaded from LOCAVAIL_GetFilterWindowHalfSpan; -1 indicates idle.
;------------------------------------------------------------------------------
TEXTDISP_DeferredActionDelayTicks:
DATA_WDISP_BSS_WORD_22A5:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_HighlightMessageSlotTable   (highlight message slot table)
; TYPE: struct[4]
; PURPOSE: Stores highlight message slot state and per-slot RastPort data.
; USED BY: GCOMMAND_ResetHighlightMessages, PARSEINI set-font loop
; NOTES: Slot stride is 160 bytes; RastPort for each slot is at offset +60.
;------------------------------------------------------------------------------
GCOMMAND_HighlightMessageSlotTable:
DATA_WDISP_BSS_LONG_22A6:
    DS.L    160
;------------------------------------------------------------------------------
; SYM: ESQDISP_HighlightBitmapTable   (highlight bitmap table)
; TYPE: struct BitMap[4]
; PURPOSE: BitMap structs used for highlight row rendering and cleanup.
; USED BY: ESQ init, ESQDISP_AllocateHighlightBitmaps, CLEANUP_ShutdownSystem
; NOTES: Each entry is a BitMap; height comes from WDISP_HighlightRasterHeightPx.
;------------------------------------------------------------------------------
ESQDISP_HighlightBitmapTable:
DATA_WDISP_BSS_LONG_22A7:
    DS.L    65
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_PendingExternalBrushNode   (pending external brush node)
; TYPE: pointer
; PURPOSE: Tracks the most recently allocated brush node for external assets.
; USED BY: ESQIFF_QueueNextExternalAssetIffJob
; NOTES: Forwarded to CTASKS pending descriptors when spawning the IFF task.
;------------------------------------------------------------------------------
ESQIFF_PendingExternalBrushNode:
DATA_WDISP_BSS_LONG_22A8:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_ExternalAssetFlags   (external asset availability bitmask)
; TYPE: u16 (bitfield)
; PURPOSE: Tracks which optional external data blobs loaded successfully.
; USED BY: ESQIFF_*, ESQFUNC_*, ED1_*, SCRIPT2_*
; NOTES: bit0 = `gfx/g_ads.data` loaded, bit1 = `df0:logo.lst` loaded.
;------------------------------------------------------------------------------
ESQIFF_ExternalAssetFlags:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_AccumulatorCaptureActive/WDISP_AccumulatorFlushPending   (display accumulator state flags)
; TYPE: u16/u16
; PURPOSE: Coordinates when accumulator buckets are updated and when the flush pass should run.
; USED BY: WDISP_*, APP2_*, ESQIFF_*, TEXTDISP_*, SCRIPT4_*
; NOTES: Common pattern is set capture active during copy/update, then clear it and set flush pending.
;------------------------------------------------------------------------------
WDISP_AccumulatorCaptureActive:
    DS.W    1
WDISP_AccumulatorFlushPending:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_LogoListLineIndex   (logo list line index)
; TYPE: u16
; PURPOSE: Tracks the current line index within df0:logo.lst.
; USED BY: ESQIFF_ReadNextExternalAssetPathEntry, ESQIFF_ReloadExternalAssetCatalogBuffers
; NOTES: Incremented when newline-delimited entries are consumed.
;------------------------------------------------------------------------------
ESQIFF_LogoListLineIndex:
DATA_WDISP_BSS_WORD_22AC:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_GAdsListLineIndex   (g_ads list line index)
; TYPE: struct (u16 + padding/unknown)
; PURPOSE: Tracks the current line index within gfx/g_ads.data.
; USED BY: ESQIFF_ReadNextExternalAssetPathEntry, ESQIFF_ReloadExternalAssetCatalogBuffers
; NOTES: Only the leading word is referenced so far.
;------------------------------------------------------------------------------
ESQIFF_GAdsListLineIndex:
DATA_WDISP_BSS_LONG_22AD:
    DS.L    3
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_PaletteDepthLog2   (palette depth log2)
; TYPE: u8 (stored in long slot)
; PURPOSE: Log2 palette size used when scanning palette triples for brightest entry.
; USED BY: ESQIFF_SetApenToBrightestPaletteIndex
; NOTES: Interpreted as `1 << value` for the palette entry count.
;------------------------------------------------------------------------------
WDISP_PaletteDepthLog2:
DATA_WDISP_BSS_LONG_22AE:
    DS.L    3
;------------------------------------------------------------------------------
; SYM: WDISP_AccumulatorRowTable   (accumulator row table)
; TYPE: u8[32]
; PURPOSE: Captures four 8-byte rows copied from brush accumulator data.
; USED BY: WDISP_DrawWeatherStatusOverlay, WDISP_DrawWeatherStatusDayEntry, ESQIFF_ShowExternalAssetWithCopperFx
; NOTES:
;   Row layout (8 bytes each, 4 rows):
;   rowN: word0 (unknown), word1 (value), word2 (move flags), byte3/byte4 (copper indices).
;------------------------------------------------------------------------------
WDISP_AccumulatorRowTable:
    DS.W    1
WDISP_AccumulatorRow0_Value:
    DS.W    1
WDISP_AccumulatorRow0_MoveFlags:
    DS.W    1
WDISP_AccumulatorRow0_CopperIndexStart:
    DS.B    1
WDISP_AccumulatorRow0_CopperIndexEnd:
    DS.B    1
WDISP_AccumulatorRow1_UnknownWord:
    DS.W    1
WDISP_AccumulatorRow1_Value:
    DS.W    1
WDISP_AccumulatorRow1_MoveFlags:
    DS.W    1
WDISP_AccumulatorRow1_CopperIndexStart:
    DS.B    1
WDISP_AccumulatorRow1_CopperIndexEnd:
    DS.B    1
WDISP_AccumulatorRow2_UnknownWord:
    DS.W    1
WDISP_AccumulatorRow2_Value:
    DS.W    1
WDISP_AccumulatorRow2_MoveFlags:
    DS.W    1
WDISP_AccumulatorRow2_CopperIndexStart:
    DS.B    1
WDISP_AccumulatorRow2_CopperIndexEnd:
    DS.B    1
WDISP_AccumulatorRow3_UnknownWord:
    DS.W    1
WDISP_AccumulatorRow3_Value:
    DS.W    1
WDISP_AccumulatorRow3_MoveFlags:
    DS.W    1
WDISP_AccumulatorRow3_CopperIndexStart:
    DS.B    1
WDISP_AccumulatorRow3_CopperIndexEnd:
    DS.B    1
    DS.L    20
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_AssetSourceSelect/ESQIFF_GAdsSourceEnabled   (asset source selection flags)
; TYPE: s16/s16
; PURPOSE: Selects which external asset stream is scanned and whether the g.ads stream is enabled.
; USED BY: ESQIFF_*, CTASKS_StartIffTaskProcess
; NOTES: `ESQIFF_AssetSourceSelect` steers logo-list vs g.ads handling in ESQIFF flows.
;------------------------------------------------------------------------------
ESQIFF_AssetSourceSelect:
    DS.W    1
ESQIFF_GAdsSourceEnabled:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_ExternalAssetStateTable   (external asset state table)
; TYPE: u32[21]
; PURPOSE: Scratch/state table for external asset (logo/g_ads) handling.
; USED BY: ESQIFF_QueueNextExternalAssetIffJob, ESQIFF_PlayNextExternalAssetFrame
; NOTES: Low word is used as a TEXTDISP_CurrentMatchIndex snapshot.
;------------------------------------------------------------------------------
ESQIFF_ExternalAssetStateTable:
DATA_WDISP_BSS_LONG_22C2:
    DS.L    21
;------------------------------------------------------------------------------
; SYM: ESQIFF_ExternalAssetPathCommaFlag   (external asset path comma flag)
; TYPE: u16 (stored in long slot)
; PURPOSE: Marks when a comma delimiter is encountered in the asset path entry.
; USED BY: ESQIFF_ReadNextExternalAssetPathEntry, ESQIFF_QueueNextExternalAssetIffJob, ESQIFF_PlayNextExternalAssetFrame
; NOTES: Set to 1 on comma; cleared when starting a new logo-list scan.
;------------------------------------------------------------------------------
ESQIFF_ExternalAssetPathCommaFlag:
DATA_WDISP_BSS_LONG_22C3:
    DS.L    5
;------------------------------------------------------------------------------
; SYM: ESQIFF_ParseField0Buffer/ESQIFF_ParseField1Buffer/ESQIFF_ParseField2Buffer/ESQIFF_ParseField3Buffer   (ESQIFF parsed-field scratch buffers)
; TYPE: u8[10]/u8[10]/u8[10]/u8[10]
; PURPOSE: Temporary per-field text/metadata buffers assembled while parsing incoming ESQIFF records.
; USED BY: ESQIFF2 parser state machine (ESQIFF2_ParseGroupRecordAndRefresh), ESQSHARED entry builder (ESQSHARED_CreateGroupEntryAndTitle)
; NOTES: Field starts are at labels 22C4/22C6/22C8/22C9 with an effective 10-byte stride.
;------------------------------------------------------------------------------
ESQIFF_ParseField0Buffer:
    DS.L    1
    DS.W    1
ESQIFF_ParseField0TailBuffer:
    DS.L    1
ESQIFF_ParseField1Buffer:
    DS.L    2
    DS.B    1
ESQIFF_ParseField1TailByte:
    DS.B    1
ESQIFF_ParseField2Buffer:
    DS.L    2
    DS.W    1
ESQIFF_ParseField3Buffer:
    DS.L    1
    DS.W    1
ESQIFF_ParseField3TailBuffer:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: FLIB_LogEntryScratchBuffer   (formatted log-entry scratch buffer)
; TYPE: u8[112]
; PURPOSE: Temporary buffer used while composing timestamped FLIB log/error entries.
; USED BY: FLIB FLIB_AppendClockStampedLogEntry/FLIB_AppendClockStampedLogEntry_Return path
; NOTES: Passed to FLIB_AppendClockStampedLogEntry before ParseIni_WriteErrorLogEntry appends the entry.
;------------------------------------------------------------------------------
FLIB_LogEntryScratchBuffer:
    DS.L    28
;------------------------------------------------------------------------------
; SYM: GCOMMAND_DigitalNicheEnabledFlag/GCOMMAND_DigitalNicheListingsTemplatePtr   (Digital Niche option state)
; TYPE: u8/pointer
; PURPOSE: Stores enable flag and template text pointer for the Digital Niche listings mode.
; USED BY: GCOMMAND_ParseCommandOptions, GCOMMAND_LoadDefaultTable, FLIB2_InitDefaults, NEWGRID_ValidateSelectionCode, NEWGRID_HandleGridEditorState
; NOTES: Enable flag is normalized to 'Y'/'N'; template pointer is built/appended via ESQPARS_ReplaceOwnedString.
;------------------------------------------------------------------------------
GCOMMAND_DigitalNicheEnabledFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_NicheTextPen/GCOMMAND_NicheFramePen/GCOMMAND_NicheEditorLayoutPen/GCOMMAND_NicheEditorRowPen/GCOMMAND_NicheModeCycleCount/GCOMMAND_NicheForceMode5Flag/GCOMMAND_NicheWorkflowMode   (Digital Niche rendering/workflow params)
; TYPE: s32/s32/s32/s32/s32/s32/u8
; PURPOSE: Stores Niche pen/layout and mode-selection parameters parsed from command options.
; USED BY: GCOMMAND_ParseCommandOptions, FLIB2_LoadDigitalNicheDefaults, NEWGRID_DrawGridCellText, NEWGRID_SelectNextMode, NEWGRID_MapSelectionToMode, NEWGRID_ProcessSecondaryState
; NOTES: WorkflowMode stores uppercase 'F'/'B'/'L'/'N'; ForceMode5Flag toggles one mode-selection branch.
;------------------------------------------------------------------------------
GCOMMAND_NicheTextPen:
DATA_WDISP_BSS_LONG_22CD:
    DS.L    1
GCOMMAND_NicheFramePen:
DATA_WDISP_BSS_LONG_22CE:
    DS.L    1
GCOMMAND_NicheEditorLayoutPen:
DATA_WDISP_BSS_LONG_22CF:
    DS.L    1
GCOMMAND_NicheEditorRowPen:
DATA_WDISP_BSS_LONG_22D0:
    DS.L    1
GCOMMAND_NicheModeCycleCount:
DATA_WDISP_BSS_LONG_22D1:
    DS.L    1
GCOMMAND_NicheForceMode5Flag:
DATA_WDISP_BSS_LONG_22D2:
    DS.L    1
GCOMMAND_NicheWorkflowMode:
DATA_WDISP_BSS_WORD_22D3:
    DS.W    1
GCOMMAND_DigitalNicheListingsTemplatePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_DigitalMplexEnabledFlag   (Digital Mplex enable flag)
; TYPE: u8
; PURPOSE: Enables/disables Digital Mplex option paths in grid validation/workflows.
; USED BY: FLIB2_InitDefaults, NEWGRID_ValidateSelectionCode, NEWGRID1_Mplex workflows
; NOTES: Stored as uppercase 'Y'/'N'.
;------------------------------------------------------------------------------
GCOMMAND_DigitalMplexEnabledFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_MplexModeCycleCount/GCOMMAND_MplexSearchRowLimit/GCOMMAND_MplexClockOffsetMinutes/GCOMMAND_MplexMessageTextPen/GCOMMAND_MplexMessageFramePen/GCOMMAND_MplexEditorLayoutPen/GCOMMAND_MplexEditorRowPen/GCOMMAND_MplexDetailLayoutPen/GCOMMAND_MplexDetailInitialLineIndex/GCOMMAND_MplexDetailRowPen/GCOMMAND_MplexWorkflowMode/GCOMMAND_MplexDetailLayoutFlag   (Digital Mplex rendering/workflow params)
; TYPE: s32/s32/s32/s32/s32/s32/s32/s32/s32/s32/u8/u8
; PURPOSE: Stores Mplex timing, pen, and workflow controls parsed from command options.
; USED BY: GCOMMAND_ParseCommandString, FLIB2_LoadDigitalMplexDefaults, NEWGRID_SelectNextMode, NEWGRID_DrawStatusMessage, NEWGRID_HandleDetailGridState, NEWGRID_ProcessScheduleState
; NOTES: WorkflowMode stores uppercase 'F'/'B'/'L'/'N'; DetailLayoutFlag stores uppercase 'Y'/'N'.
;------------------------------------------------------------------------------
GCOMMAND_MplexModeCycleCount:
DATA_WDISP_BSS_LONG_22D6:
    DS.L    1
GCOMMAND_MplexSearchRowLimit:
DATA_WDISP_BSS_LONG_22D7:
    DS.L    1
GCOMMAND_MplexClockOffsetMinutes:
DATA_WDISP_BSS_LONG_22D8:
    DS.L    1
GCOMMAND_MplexMessageTextPen:
DATA_WDISP_BSS_LONG_22D9:
    DS.L    1
GCOMMAND_MplexMessageFramePen:
DATA_WDISP_BSS_LONG_22DA:
    DS.L    1
GCOMMAND_MplexEditorLayoutPen:
DATA_WDISP_BSS_LONG_22DB:
    DS.L    1
GCOMMAND_MplexEditorRowPen:
DATA_WDISP_BSS_LONG_22DC:
    DS.L    1
GCOMMAND_MplexDetailLayoutPen:
DATA_WDISP_BSS_LONG_22DD:
    DS.L    1
GCOMMAND_MplexDetailInitialLineIndex:
DATA_WDISP_BSS_LONG_22DE:
    DS.L    1
GCOMMAND_MplexDetailRowPen:
DATA_WDISP_BSS_LONG_22DF:
    DS.L    1
GCOMMAND_MplexWorkflowMode:
DATA_WDISP_BSS_BYTE_22E0:
    DS.B    1
GCOMMAND_MplexDetailLayoutFlag:
DATA_WDISP_BSS_BYTE_22E1:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_MplexListingsTemplatePtr/GCOMMAND_MplexAtTemplatePtr   (Digital Multiplex template strings)
; TYPE: pointer/pointer
; PURPOSE: Owns the assembled "Digital Multiplex Listings" and "Digital Multiplex at %s" template strings.
; USED BY: GCOMMAND_LoadMplexTemplate, GCOMMAND_ParseCommandString, FLIB2 init helpers
; NOTES: Both pointers are rebuilt when command templates are reloaded.
;------------------------------------------------------------------------------
GCOMMAND_MplexListingsTemplatePtr:
    DS.L    1
GCOMMAND_MplexAtTemplatePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_DigitalPpvEnabledFlag   (Digital PPV enable flag)
; TYPE: u8
; PURPOSE: Enables/disables Digital PPV option paths in grid validation/workflows.
; USED BY: FLIB2_InitDefaults, NEWGRID_ValidateSelectionCode, NEWGRID1_Ppv workflows
; NOTES: Stored as uppercase 'Y'/'N'.
;------------------------------------------------------------------------------
GCOMMAND_DigitalPpvEnabledFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvModeCycleCount   (PPV mode cycle count)
; TYPE: s32
; PURPOSE: Optional cycle/repeat interval used by NEWGRID PPV mode-selection loops.
; USED BY: GCOMMAND_ParsePPVCommand, FLIB2_LoadDigitalPpvDefaults, NEWGRID_SelectNextMode
; NOTES: Zero disables delay behavior; positive values seed per-mode countdown bytes.
;------------------------------------------------------------------------------
GCOMMAND_PpvModeCycleCount:
DATA_WDISP_BSS_LONG_22E5:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvSelectionWindowMinutes/GCOMMAND_PpvSelectionToleranceMinutes   (PPV selection timing params)
; TYPE: s32/s32
; PURPOSE: Minute-based timing parameters consumed by COI/NEWGRID selection and showtimes scans.
; USED BY: GCOMMAND_ParsePPVCommand, FLIB2 defaults, NEWGRID_* selection workflows, COI_ProcessEntrySelectionState
; NOTES: Defaults to 60/30; parsed as three-digit numeric options in PPV command handler.
;------------------------------------------------------------------------------
GCOMMAND_PpvSelectionWindowMinutes:
    DS.L    1
GCOMMAND_PpvSelectionToleranceMinutes:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvMessageTextPen/GCOMMAND_PpvMessageFramePen   (PPV message pen pair)
; TYPE: s32/s32
; PURPOSE: Pen indices used by NEWGRID_DrawGridMessageAlt for text and frame colors.
; USED BY: GCOMMAND_ParsePPVCommand, FLIB2_LoadDigitalPpvDefaults, NEWGRID_DrawGridMessageAlt
; NOTES: Text pen is constrained to 1..3 by parser defaults; frame pen accepts hex-digit values.
;------------------------------------------------------------------------------
GCOMMAND_PpvMessageTextPen:
DATA_WDISP_BSS_LONG_22E8:
    DS.L    1
GCOMMAND_PpvMessageFramePen:
DATA_WDISP_BSS_LONG_22E9:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvEditorLayoutPen/GCOMMAND_PpvEditorRowPen   (PPV editor/detail pen pair)
; TYPE: s32/s32
; PURPOSE: Pen indices forwarded to NEWGRID_HandleGridEditorState for PPV detail/editor rendering.
; USED BY: GCOMMAND_ParsePPVCommand, FLIB2_LoadDigitalPpvDefaults, NEWGRID_ProcessShowtimesWorkflow
; NOTES: Layout pen feeds DISPTEXT_SetLayoutParams commit-pen arg; row pen feeds NEWGRID_DrawGridFrameAndRows.
;------------------------------------------------------------------------------
GCOMMAND_PpvEditorLayoutPen:    ; 22EA
    DS.L    1
GCOMMAND_PpvEditorRowPen:       ; 22EB
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvShowtimesLayoutPen/GCOMMAND_PpvShowtimesInitialLineIndex/GCOMMAND_PpvShowtimesRowPen   (PPV showtimes layout params)
; TYPE: s32/s32/s32
; PURPOSE: Controls showtimes layout/render setup in NEWGRID showtimes flows.
; USED BY: GCOMMAND_ParsePPVCommand, FLIB2_LoadDigitalPpvDefaults, NEWGRID_HandleShowtimesState, NEWGRID_DrawGridFrameVariant3
; NOTES: InitialLineIndex is passed to DISPTEXT_SetCurrentLineIndex; row pen also participates in grid-operation pen fallback.
;------------------------------------------------------------------------------
GCOMMAND_PpvShowtimesLayoutPen:         ; 22EC
    DS.L    1
GCOMMAND_PpvShowtimesInitialLineIndex:  ; 22ED
    DS.L    1
GCOMMAND_PpvShowtimesRowPen:            ; 22EE
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvShowtimesWorkflowMode/GCOMMAND_PpvDetailLayoutFlag   (PPV showtimes mode flags)
; TYPE: u8/u8
; PURPOSE: Stores PPV showtimes workflow mode (`F`/`B`/`L`/`N`) and detail layout toggle (`Y`/`N`).
; USED BY: GCOMMAND_ParsePPVCommand, FLIB2_LoadDigitalPpvDefaults, NEWGRID showtimes state machine
; NOTES: Flags are case-folded to uppercase before storage.
;------------------------------------------------------------------------------
GCOMMAND_PpvShowtimesWorkflowMode:
DATA_WDISP_BSS_BYTE_22EF:
    DS.B    1
GCOMMAND_PpvDetailLayoutFlag:
DATA_WDISP_BSS_BYTE_22F0:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PPVListingsTemplatePtr/GCOMMAND_PPVPeriodTemplatePtr   (Digital PPV template strings)
; TYPE: pointer/pointer
; PURPOSE: Owns the assembled PPV listings and PPV period template strings.
; USED BY: FLIB2 init helpers, GCOMMAND_PPV parsing/formatting paths
; NOTES: Reinitialized alongside other command template pointers.
;------------------------------------------------------------------------------
GCOMMAND_PPVListingsTemplatePtr:
    DS.L    1
GCOMMAND_PPVPeriodTemplatePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvShowtimesRowSpan   (PPV showtimes row span)
; TYPE: s32
; PURPOSE: Additional row span added to the current row when NEWGRID builds PPV showtimes buckets.
; USED BY: FLIB2_LoadDigitalPpvDefaults, GCOMMAND_ParsePPVCommand, NEWGRID_BuildShowtimesText
; NOTES: Parsed from a 2-char numeric option and clamped to <= 96 by parser logic.
;------------------------------------------------------------------------------
GCOMMAND_PpvShowtimesRowSpan:
DATA_WDISP_BSS_LONG_22F3:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_DefaultPresetTable   (default preset table)
; TYPE: u16[16]
; PURPOSE: Default preset values consumed by GCOMMAND preset increment/validation paths.
; USED BY: GCOMMAND_InitPresetDefaults, GCOMMAND_ComputePresetIncrement, GCOMMAND_ValidatePresetTable
; NOTES: Copied from validated preset sources and used as fallback baseline values.
;------------------------------------------------------------------------------
GCOMMAND_DefaultPresetTable:
    DS.L    8
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PresetValueTable   (preset value matrix)
; TYPE: u16[16][64]
; PURPOSE: Stores preset curve/value rows consumed by banner build/update logic.
; USED BY: GCOMMAND_SetPresetEntry, GCOMMAND_ExpandPresetBlock, GCOMMAND_BuildBannerBlock
; NOTES: Rows are addressed with `ASL #7` (128-byte stride); values are read as words.
;------------------------------------------------------------------------------
GCOMMAND_PresetValueTable:
    DS.L    512
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PresetWorkEntryTable   (highlight preset work entries)
; TYPE: struct[4]
; PURPOSE: Runtime table for preset timing/accumulator state used by banner highlight updates.
; USED BY: GCOMMAND_ResetPresetWorkTables, GCOMMAND_LoadPresetWorkEntries, GCOMMAND_TickPresetWorkEntries
; NOTES: Four entries, each 24 bytes.
;        Entry0 starts at GCOMMAND_PresetWorkEntryTable; entry1/2/3 start at
;        GCOMMAND_PresetWorkEntry1/2/3. The *_ValueIndex aliases map to offset +8
;        in each entry and are read by banner rebuild/draw paths.
;------------------------------------------------------------------------------
GCOMMAND_PresetWorkEntryTable:
    DS.L    2
GCOMMAND_PresetWorkEntry0_ValueIndex:
    DS.L    4
GCOMMAND_PresetWorkEntry1:  
    DS.L    2
GCOMMAND_PresetWorkEntry1_ValueIndex:
    DS.L    4
GCOMMAND_PresetWorkEntry2:
    DS.L    2
GCOMMAND_PresetWorkEntry2_ValueIndex:
    DS.L    4
GCOMMAND_PresetWorkEntry3:
    DS.L    2
GCOMMAND_PresetWorkEntry3_ValueIndex:
    DS.L    4
; Tracks whether the digital banner highlight is enabled (0/1).
GCOMMAND_HighlightFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerBoundLeft/GCOMMAND_BannerBoundTop/GCOMMAND_BannerBoundRight/GCOMMAND_BannerBoundBottom   (cached banner bounds)
; TYPE: s32/s32/s32/s32
; PURPOSE: Cached geometry bounds supplied through GCOMMAND_UpdateBannerBounds.
; USED BY: GCOMMAND_UpdateBannerBounds, GCOMMAND_RebuildBannerTablesFromBounds
; NOTES: Updated atomically before requesting a banner-table rebuild.
;------------------------------------------------------------------------------
GCOMMAND_BannerBoundLeft:
    DS.L    1
GCOMMAND_BannerBoundTop:
    DS.L    1
GCOMMAND_BannerBoundRight:
    DS.L    1
GCOMMAND_BannerBoundBottom:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerStepLeft/GCOMMAND_BannerStepTop/GCOMMAND_BannerStepRight/GCOMMAND_BannerStepBottom   (cached preset increments)
; TYPE: s32/s32/s32/s32
; PURPOSE: Precomputed per-bound increments derived from cached banner bounds.
; USED BY: GCOMMAND_UpdateBannerBounds, GCOMMAND_RebuildBannerTablesFromBounds
; NOTES: Produced by GCOMMAND_ComputePresetIncrement with a mode-dependent seed.
;------------------------------------------------------------------------------
GCOMMAND_BannerStepLeft:
    DS.L    1
GCOMMAND_BannerStepTop:
    DS.L    1
GCOMMAND_BannerStepRight:
    DS.L    1
GCOMMAND_BannerStepBottom:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerRowByteOffsetCurrent/GCOMMAND_BannerRowByteOffsetPrevious   (banner row byte offsets)
; TYPE: s32/s32
; PURPOSE: Tracks current/previous byte offsets used when rebuilding banner rows.
; USED BY: GCOMMAND_RefreshBannerTables, GCOMMAND_TickHighlightState, ESQSHARED4 blit helpers
; NOTES: Current offset advances in fixed strides and wraps with the highlight cycle.
;------------------------------------------------------------------------------
GCOMMAND_BannerRowByteOffsetCurrent:
    DS.L    1
GCOMMAND_BannerRowByteOffsetPrevious:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerQueueSlotPrevious/GCOMMAND_BannerQueueSlotCurrent   (banner queue slot indices)
; TYPE: u16/u16
; PURPOSE: Tracks previous/current byte slot indices into DATA_ESQPARS2_BSS_LONG_1F48 banner queue storage.
; USED BY: GCOMMAND_MapKeycodeToPreset, GCOMMAND_ConsumeBannerQueueEntry, GCOMMAND_TickHighlightState
; NOTES: Decrements each tick with wrap at 97 (`$61`).
;------------------------------------------------------------------------------
GCOMMAND_BannerQueueSlotPrevious:
    DS.W    1
GCOMMAND_BannerQueueSlotCurrent:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerRowIndexPrevious/GCOMMAND_BannerRowIndexCurrent   (banner row indices)
; TYPE: s32/s32
; PURPOSE: Tracks previous/current row indices while rotating banner copper row pointers.
; USED BY: GCOMMAND_UpdateBannerRowPointers, GCOMMAND_UpdateBannerOffset, GCOMMAND_BuildBannerTables
; NOTES: Current index wraps in range 0..97; previous snapshots prior value for pointer updates.
;------------------------------------------------------------------------------
GCOMMAND_BannerRowIndexPrevious:
    DS.L    1
GCOMMAND_BannerRowIndexCurrent:
    DS.L    1
DATA_WDISP_BSS_LONG_230D:
    DS.L    1
DATA_WDISP_BSS_LONG_230E:
    DS.L    1
DATA_WDISP_BSS_LONG_230F:
    DS.L    1
DATA_WDISP_BSS_LONG_2310:
    DS.L    1
DATA_WDISP_BSS_LONG_2311:
    DS.L    1
DATA_WDISP_BSS_LONG_2312:
    DS.L    1
    DS.W    1
Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE:
    DS.L    1
Global_REF_DATA_INPUT_BUFFER:
    DS.L    1
Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE:
    DS.L    1
Global_REF_INPUTDEVICE_MSGPORT:
    DS.L    1
Global_REF_CONSOLEDEVICE_MSGPORT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO_Drive0WriteProtectedCode   (drive 0 write-protect status code)
; TYPE: s32
; PURPOSE: Nonzero status when drive 0 is detected as write-protected.
; USED BY: DISKIO media probe/init path, ESQFUNC warning-display gate
; NOTES: Value is treated as boolean in most callers.
;------------------------------------------------------------------------------
DISKIO_Drive0WriteProtectedCode:
    DS.L    1
DATA_WDISP_BSS_LONG_2319:
    DS.L    3
DATA_WDISP_BSS_LONG_231A:
    DS.L    4
;------------------------------------------------------------------------------
; SYM: ED_StateRingWriteIndex   (editor state-ring write index)
; TYPE: s32
; PURPOSE: Producer index into ED_StateRingTable for newly queued control/input events.
; USED BY: GCOMMAND_ProcessCtrlCommand, APP2 input staging, ED dispatcher gate
; NOTES: Advanced modulo $14; ED_StateRingIndex is the consumer side.
;------------------------------------------------------------------------------
ED_StateRingWriteIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_StateRingIndex   (editor state ring index)
; TYPE: s32
; PURPOSE: Current write/read index into ED_StateRingTable.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, KYBD_*
; NOTES: Advanced modulo $14 in editor dispatch paths.
;------------------------------------------------------------------------------
ED_StateRingIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_StateRingTable   (editor state ring table)
; TYPE: s32[]
; PURPOSE: Ring buffer backing store for editor state/history entries.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, KYBD_*
; NOTES: Indexed via ED_StateRingIndex.
;------------------------------------------------------------------------------
ED_StateRingTable:
    DS.L    25
DATA_WDISP_BSS_LONG_231E:
    DS.L    1
DATA_WDISP_BSS_LONG_231F:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: LADFUNC_SaveAdsFileHandle   (LAD text-ads save file handle)
; TYPE: pointer/handle
; PURPOSE: File handle used while serializing LAD text ads to `df0:local.ads`.
; USED BY: LADFUNC_SaveTextAdsToFile
; NOTES: Opened via DISKIO_OpenFileWithBuffer and consumed by DISKIO_WriteBufferedBytes/DISKIO_WriteDecimalField/DISKIO_CloseBufferedFileAndFlush I/O helpers.
;------------------------------------------------------------------------------
LADFUNC_SaveAdsFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: LOCAVAIL_PrimaryFilterState/LOCAVAIL_SecondaryFilterState   (locavail filter state structs)
; TYPE: struct/struct
; PURPOSE: Persistent filter/scan state blocks for primary and secondary locavail group handling.
; USED BY: LOCAVAIL_*, ESQPARS_*, ESQFUNC_*, CLEANUP_*, ED1_*, SCRIPT3_*
; NOTES: Accessed via struct-style offsets (e.g. +8/+12/+20), so adjacent storage is part of the layout.
;------------------------------------------------------------------------------
LOCAVAIL_PrimaryFilterState:
    DS.L    2
LOCAVAIL_PrimaryFilterState_Field08:
DATA_WDISP_BSS_LONG_2322:
    DS.L    1
LOCAVAIL_PrimaryFilterState_Field0C:
DATA_WDISP_BSS_LONG_2323:
    DS.L    1
LOCAVAIL_PrimaryFilterState_Field10:
    DS.L    1
LOCAVAIL_PrimaryFilterState_Field14:
    DS.L    1
LOCAVAIL_SecondaryFilterState:
    DS.L    6
LOCAVAIL_FilterCooldownTicks:
DATA_WDISP_BSS_LONG_2325:
    DS.L    1
Global_REF_BACKED_UP_INTUITION_AUTOREQUEST:
    DS.L    1
Global_REF_BACKED_UP_INTUITION_DISPLAYALERT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_RowHeightPx   (grid row height in pixels)
; TYPE: u16
; PURPOSE: Pixel height of one NEWGRID row cell.
; USED BY: NEWGRID_* layout and rendering helpers
; NOTES: Derived from active font metrics during grid initialization.
;------------------------------------------------------------------------------
NEWGRID_RowHeightPx:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SampleTimeTextWidthPx   (sample "44:44:44" text width)
; TYPE: u16
; PURPOSE: Cached width of sample time text used during grid geometry setup.
; USED BY: NEWGRID_InitGridResources
; NOTES: Baseline used to compute NEWGRID_ColumnStartXPx.
;------------------------------------------------------------------------------
NEWGRID_SampleTimeTextWidthPx:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ColumnStartXPx   (left edge of first data column)
; TYPE: u16
; PURPOSE: Horizontal pixel offset where NEWGRID data columns begin.
; USED BY: NEWGRID_DrawClockFormatHeader, NEWGRID date/header rendering
; NOTES: Computed from NEWGRID_SampleTimeTextWidthPx plus padding.
;------------------------------------------------------------------------------
NEWGRID_ColumnStartXPx:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ColumnWidthPx   (per-column width in pixels)
; TYPE: u16
; PURPOSE: Width of each day/time column in the NEWGRID header/body.
; USED BY: NEWGRID_* column layout loops
; NOTES: Computed from available width and number of columns.
;------------------------------------------------------------------------------
NEWGRID_ColumnWidthPx:
    DS.W    1
DATA_WDISP_BSS_LONG_232C:
    DS.L    1
DATA_WDISP_BSS_LONG_232D:
    DS.L    1
DATA_WDISP_BSS_LONG_232E:
    DS.L    1
DATA_WDISP_BSS_LONG_232F:
    DS.L    2
DATA_WDISP_BSS_LONG_2330:
    DS.L    3
DATA_WDISP_BSS_LONG_2331:
    DS.L    1
    DS.W    1
DATA_WDISP_BSS_LONG_2332:
    DS.L    6
    DS.W    1
DATA_WDISP_BSS_LONG_2333:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_OverridePenIndex   (newgrid override pen index)
; TYPE: s32
; PURPOSE: Holds temporary color/pen override selected while drawing current grid entry.
; USED BY: NEWGRID_SelectEntryPen, NEWGRID_ProcessGridEntries
; NOTES: Clamped to 1..3 by NEWGRID_SelectEntryPen before cell drawing consumes it.
;------------------------------------------------------------------------------
NEWGRID_OverridePenIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_EntryTextScratchPtr   (newgrid entry text scratch pointer)
; TYPE: pointer
; PURPOSE: Heap buffer used as staging text while NEWGRID formats/splits per-entry display lines.
; USED BY: NEWGRID_DrawGridEntry, NEWGRID2_EnsureBuffersAllocated, NEWGRID2_FreeBuffersIfAllocated
; NOTES: Allocated as 1000 bytes in NEWGRID2_EnsureBuffersAllocated.
;------------------------------------------------------------------------------
NEWGRID_EntryTextScratchPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ShowtimeBucketEntryTable/NEWGRID_ShowtimeBucketPtrTable   (showtime bucket storage)
; TYPE: struct[10]/pointer[10]
; PURPOSE: Stores normalized showtime bucket records and a sortable pointer index table.
; USED BY: NEWGRID_ResetShowtimeBuckets, NEWGRID_AddShowtimeBucketEntry, NEWGRID_AppendShowtimeBuckets
; NOTES: Entry records contain a packed key plus text pointer; pointer table supports insertion-sorted ordering.
;------------------------------------------------------------------------------
NEWGRID_ShowtimeBucketEntryTable:
    DS.L    19
DATA_WDISP_BSS_LONG_2337:
    DS.L    1
NEWGRID_ShowtimeBucketPtrTable:
    DS.L    10
;------------------------------------------------------------------------------
; SYM: NEWGRID_ShowtimeBucketCount   (showtime bucket count)
; TYPE: s32
; PURPOSE: Current number of active entries in NEWGRID showtime bucket arrays.
; USED BY: NEWGRID_ResetShowtimeBuckets, NEWGRID_AddShowtimeBucketEntry, NEWGRID_AppendShowtimeBuckets
; NOTES: Clamped to a max of 10 entries.
;------------------------------------------------------------------------------
NEWGRID_ShowtimeBucketCount:
    DS.L    1
DATA_WDISP_BSS_LONG_233A:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: P_TYPE_PrimaryGroupListPtr/P_TYPE_SecondaryGroupListPtr   (p_type group list pointers)
; TYPE: pointer/pointer
; PURPOSE: Holds parsed P_TYPE list objects for the primary and secondary group codes.
; USED BY: P_TYPE_*
; NOTES: Secondary may be staged then promoted into primary during list rollover.
;------------------------------------------------------------------------------
P_TYPE_PrimaryGroupListPtr:
    DS.L    1
P_TYPE_SecondaryGroupListPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: PARSEINI_CurrentWeatherBlockPtr   (current weather block struct pointer)
; TYPE: pointer
; PURPOSE: Points to the weather/display config block currently being populated.
; USED BY: PARSEINI_ProcessWeatherBlocks
; NOTES: Set by brush-node allocation when parsing filename/loadcolor blocks.
;------------------------------------------------------------------------------
PARSEINI_CurrentWeatherBlockPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: PARSEINI_WeatherBrushNodePtr   (weather brush node pointer)
; TYPE: pointer
; PURPOSE: Tracks the most recently allocated weather brush node during parsing.
; USED BY: PARSEINI_LoadWeatherStrings
; NOTES: Cleared when the banner brush resource list is empty.
;------------------------------------------------------------------------------
PARSEINI_WeatherBrushNodePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_GradientPresetTable   (gradient preset table)
; TYPE: s32[520]
; PURPOSE: Stores gradient preset values parsed from the [gradient] INI section.
; USED BY: PARSEINI_ParseIniBufferAndDispatch, GCOMMAND_InitPresetTableFromPalette
; NOTES: Table length is 520 longs (2080 bytes).
;------------------------------------------------------------------------------
GCOMMAND_GradientPresetTable:
    DS.L    520
CTRL_BUFFER:
    DS.L    125
;------------------------------------------------------------------------------
; SYM: SCRIPT_SerialShadowWord/SCRIPT_SerialInputLatch   (serial control shadow)
; TYPE: u16/u16
; PURPOSE: Shadow copy of serial control word plus most recent latched input bits.
; USED BY: SCRIPT_AssertCtrlLine*, SCRIPT_DeassertCtrlLine*, SCRIPT_WriteCtrlShadowToSerdat
; NOTES: CTRL-line assert/deassert toggles bit 5 in SCRIPT_SerialShadowWord before writing SERDAT.
;------------------------------------------------------------------------------
SCRIPT_SerialShadowWord:
    DS.W    1
SCRIPT_SerialInputLatch:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_CtrlLineAssertedTicks   (ctrl-line asserted tick counter)
; TYPE: s16 (stored in long slot)
; PURPOSE: Counts ticks while the CTRL line remains asserted.
; USED BY: SCRIPT_PollHandshakeAndApplyTimeout
; NOTES: Reset to 0 after reaching the timeout threshold.
;------------------------------------------------------------------------------
SCRIPT_CtrlLineAssertedTicks:
    DS.L    1
Global_WORD_CLOCK_SECONDS:
    DS.W    1
SCRIPT_CTRL_STATE:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_RuntimeMode   (script runtime mode/state)
; TYPE: u16
; PURPOSE: Current script engine mode used by SCRIPT3/TEXTDISP2 flows.
; USED BY: SCRIPT3_*, TEXTDISP2_*, ED1_*, ESQFUNC_*, ESQIFF2_*
; NOTES: Frequently switched among small integer mode ids.
;------------------------------------------------------------------------------
SCRIPT_RuntimeMode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_CtrlCmdCount/SCRIPT_CtrlCmdChecksumErrorCount/SCRIPT_CtrlCmdLengthErrorCount   (CTRL command counters)
; TYPE: u16/u16/u16
; PURPOSE: Tracks CTRL command totals plus checksum and length error counts.
; USED BY: SCRIPT_HandleSerialCtrlCmd, ESQFUNC_DrawMemoryStatusScreen, ED2_HandleDiagnosticsMenuActions
; NOTES: "LERRS" increments when CTRL buffer length exceeds 198 bytes.
;------------------------------------------------------------------------------
SCRIPT_CtrlCmdCount:
DATA_WDISP_BSS_WORD_2347:
    DS.W    1
SCRIPT_CtrlCmdChecksumErrorCount:
DATA_WDISP_BSS_WORD_2348:
    DS.W    1
SCRIPT_CtrlCmdLengthErrorCount:
DATA_WDISP_BSS_WORD_2349:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: Global_RefreshTickCounter   (global refresh tick counter)
; TYPE: s16
; PURPOSE: Tick counter for periodic refresh/redraw scheduling.
; USED BY: TEXTDISP2_*, SCRIPT3_*, ESQFUNC_*, DISKIO_*, APP2_*
; NOTES: Uses -1 sentinel in several callers.
;------------------------------------------------------------------------------
Global_RefreshTickCounter:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimarySearchText/TEXTDISP_SecondarySearchText   (search text buffers)
; TYPE: char[200]/char[200]
; PURPOSE: Stores primary and secondary search text used by text display filtering.
; USED BY: TEXTDISP_*, SCRIPT3_*, CLEANUP3_*
; NOTES: Declared as 50 longs each (200 bytes); treated as C-style byte strings.
;------------------------------------------------------------------------------
TEXTDISP_PrimarySearchText:
    DS.L    50
TEXTDISP_SecondarySearchText:
    DS.L    50
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryChannelCode/TEXTDISP_SecondaryChannelCode   (active channel-code pair)
; TYPE: u16/u16
; PURPOSE: Stores active primary/secondary channel code values used by text/display script flows.
; USED BY: TEXTDISP_*, SCRIPT3_*, CLEANUP3_*
; NOTES: Defaults and clamping are applied in TEXTDISP dispatch code before channel-table lookups.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryChannelCode:
    DS.W    1
TEXTDISP_SecondaryChannelCode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_ChannelRangeDigitChar   (channel-range digit char)
; TYPE: u8 (stored in word slot)
; PURPOSE: Captures the channel-range digit parsed from script control buffers.
; USED BY: SCRIPT_HandleBrushCommand, playback aligned-status render paths
; NOTES: Stored as ASCII digit; '0' disables the channel-range path.
;------------------------------------------------------------------------------
SCRIPT_ChannelRangeDigitChar:
DATA_WDISP_BSS_WORD_234F:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_SearchMatchCountOrIndex   (search match count/index ??)
; TYPE: s32
; PURPOSE: Stores the selection argument passed into SCRIPT_SelectPlaybackCursorFromSearchText.
; USED BY: SCRIPT_SelectPlaybackCursorFromSearchText, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot
; NOTES: Passed through to CLEANUP_RenderAlignedStatusScreen (usage uncertain).
;------------------------------------------------------------------------------
SCRIPT_SearchMatchCountOrIndex:
DATA_WDISP_BSS_LONG_2350:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_PlaybackCursor   (script playback cursor/state value)
; TYPE: s32
; PURPOSE: Tracks active script playback/progression position/state.
; USED BY: SCRIPT3_* state handlers
; NOTES: Saved/restored with SCRIPT context structs.
;------------------------------------------------------------------------------
SCRIPT_PlaybackCursor:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_BannerTransitionTargetChar/SCRIPT_BannerTransitionStepDelta/SCRIPT_BannerTransitionStepSign   (banner transition params)
; TYPE: u8/s16/s16
; PURPOSE: Stores the target banner character plus per-tick step data.
; USED BY: SCRIPT_BeginBannerCharTransition, SCRIPT_UpdateBannerCharTransition, SCRIPT_PrimeBannerTransitionFromHexCode
; NOTES: Step delta is signed after applying the sign value.
;------------------------------------------------------------------------------
SCRIPT_BannerTransitionTargetChar:
DATA_WDISP_BSS_WORD_2352:
    DS.W    1
SCRIPT_BannerTransitionStepDelta:
DATA_WDISP_BSS_WORD_2353:
    DS.W    1
SCRIPT_BannerTransitionStepSign:
DATA_WDISP_BSS_WORD_2354:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_CTRL_CONTEXT   (CtrlContextStruct_uncertain)
; TYPE: struct
; PURPOSE: Control/script context storage used by script control handlers.
; USED BY: SCRIPT_InitCtrlContext, SCRIPT_SetCtrlContextMode, SCRIPT_ResetCtrlContext
; NOTES: Size = 112 longs (448 bytes). Field meanings largely unknown.
;------------------------------------------------------------------------------
SCRIPT_CTRL_CONTEXT:
    DS.L    112
;------------------------------------------------------------------------------
; SYM: SCRIPT_PrimarySearchFirstFlag   (script search-order flag)
; TYPE: u16
; PURPOSE: Selects whether script-driven lookup checks primary search first.
; USED BY: SCRIPT3 state/serialization handlers, TEXTDISP_SelectGroupAndEntry dispatch wrapper
; NOTES: Toggled by script command bytes (`L`/`R`) and persisted in script state blobs.
;------------------------------------------------------------------------------
SCRIPT_PrimarySearchFirstFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_ChannelRangeArmedFlag   (channel-range gate)
; TYPE: u16 (stored in long slot)
; PURPOSE: Enables channel-range parsing when set by script search selection.
; USED BY: SCRIPT_SelectPlaybackCursorFromSearchText, SCRIPT_HandleBrushCommand
; NOTES: Cleared when selection fails or playback cursor is forced.
;------------------------------------------------------------------------------
SCRIPT_ChannelRangeArmedFlag:
DATA_WDISP_BSS_LONG_2357:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_FilterCandidateCursor/TEXTDISP_FilterChannelSlotIndex/TEXTDISP_FilterMatchCount/TEXTDISP_FilterPpvSbeMatchFlag/TEXTDISP_FilterSportsMatchFlag   (filter state)
; TYPE: u16/u16/u16/u16/u16
; PURPOSE: Tracks filter scan cursor, channel slot, and match flags/counts.
; USED BY: TEXTDISP_FilterAndSelectEntry
; NOTES: Channel slot advances up to $31 when scanning the candidate list.
;------------------------------------------------------------------------------
TEXTDISP_FilterCandidateCursor:
DATA_WDISP_BSS_WORD_2358:
    DS.W    1
TEXTDISP_FilterChannelSlotIndex:
DATA_WDISP_BSS_WORD_2359:
    DS.W    1
TEXTDISP_FilterMatchCount:
DATA_WDISP_BSS_WORD_235A:
    DS.W    1
TEXTDISP_FilterPpvSbeMatchFlag:
DATA_WDISP_BSS_WORD_235B:
    DS.W    1
TEXTDISP_FilterSportsMatchFlag:
DATA_WDISP_BSS_WORD_235C:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_StatusGroupId   (status line group id)
; TYPE: u16
; PURPOSE: Stores the group id used when building now/next status lines.
; USED BY: TEXTDISP_HandleScriptCommand
; NOTES: Set to TEXTDISP_ActiveGroupId or 0/1 fallback ids.
;------------------------------------------------------------------------------
TEXTDISP_StatusGroupId:
DATA_WDISP_BSS_WORD_235D:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SourceConfigEntryTable/TEXTDISP_SourceConfigEntryCount   (SourceCfg table)
; TYPE: pointer[302]/s32
; PURPOSE: Stores SourceCfg entry pointers and the active entry count.
; USED BY: TEXTDISP_LoadSourceConfig, TEXTDISP_ClearSourceConfig, TEXTDISP_ApplySourceConfigToEntry
; NOTES: Each entry points to a 6-byte SourceCfg record.
;------------------------------------------------------------------------------
TEXTDISP_SourceConfigEntryTable:
DATA_WDISP_BSS_LONG_235E:
    DS.L    302
TEXTDISP_SourceConfigEntryCount:
DATA_WDISP_BSS_LONG_235F:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_PrimaryFirstMatchIndex/TEXTDISP_SecondaryFirstMatchIndex   (first match indices)
; TYPE: u16/u16
; PURPOSE: Stores the first candidate index found for primary/secondary groups.
; USED BY: TEXTDISP_SelectGroupAndEntry
; NOTES: Written from TEXTDISP_CandidateIndexList[0] when matches exist.
;------------------------------------------------------------------------------
TEXTDISP_PrimaryFirstMatchIndex:
DATA_WDISP_BSS_WORD_2360:
    DS.W    1
TEXTDISP_SecondaryFirstMatchIndex:
DATA_WDISP_BSS_WORD_2361:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_EntryTextBaseWidthPx   (entry text base width)
; TYPE: s32
; PURPOSE: Base pixel width used when populating entry short/long name fields.
; USED BY: TEXTDISP_SetEntryTextFields
; NOTES: Derived from CONFIG_LRBN_FlagChar and Global_REF_WORD_HEX_CODE_8E.
;------------------------------------------------------------------------------
TEXTDISP_EntryTextBaseWidthPx:
DATA_WDISP_BSS_LONG_2362:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQ_GlobalTickCounter   (global tick counter)
; TYPE: s16 (stored in long slot)
; PURPOSE: Global tick counter used to trigger periodic resets/reboots.
; USED BY: ESQ_TickGlobalCounters, TEXTDISP_TickDisplayState, ESQPARS Reset command
; NOTES: ESQ_ColdReboot is invoked when the counter reaches $5460.
;------------------------------------------------------------------------------
ESQ_GlobalTickCounter:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_CurrentMatchIndex   (current selected/matched entry index)
; TYPE: u16
; PURPOSE: Tracks the active entry index for text search/highlight operations.
; USED BY: TEXTDISP_FindEntryIndexByWildcard and related draw/selection flows
; NOTES: Preserved/restored around searches via companion state words.
;------------------------------------------------------------------------------
TEXTDISP_CurrentMatchIndex:
    DS.W    1
DATA_WDISP_BSS_WORD_2365:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CLEANUP_AlignedStatusSuffixBuffer/CLEANUP_AlignedStatusMatchIndex   (aligned status text state)
; TYPE: char[]/s16
; PURPOSE: Scratch suffix text and associated match index used by aligned status rendering.
; USED BY: CLEANUP_RenderAlignedStatusScreen, SCRIPT_HandleSerialCtrlCmd
; NOTES: Match index stores the fallback/current entry when TEXTDISP_CurrentMatchIndex is temporarily invalid.
;------------------------------------------------------------------------------
CLEANUP_AlignedStatusSuffixBuffer:
    DS.L    20
    DS.B    1
DATA_WDISP_BSS_BYTE_2367:
    DS.B    1
    DS.L    128
CLEANUP_AlignedStatusMatchIndex:
    DS.W    1
DATA_WDISP_BSS_WORD_2369:
    DS.W    1
DATA_WDISP_BSS_LONG_236A:
    DS.L    151
DATA_WDISP_BSS_LONG_236B:
    DS.L    20
DATA_WDISP_BSS_WORD_236C:
    DS.W    1
DATA_WDISP_BSS_WORD_236D:
    DS.W    1
DATA_WDISP_BSS_WORD_236E:
    DS.W    1
DATA_WDISP_BSS_WORD_236F:
    DS.W    1
DATA_WDISP_BSS_WORD_2370:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_CandidateIndexList   (filtered entry index list)
; TYPE: u32[75]
; PURPOSE: Holds candidate entry indices produced by wildcard/filter searches.
; USED BY: TEXTDISP_FindEntryIndexByWildcard, TEXTDISP_BuildNowShowingStatusLine, SCRIPT3_*
; NOTES: Built during search passes, then consumed by status/banner rendering code.
;------------------------------------------------------------------------------
TEXTDISP_CandidateIndexList:
    DS.L    75
    DS.W    1
DATA_WDISP_BSS_BYTE_2372:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_BannerCharFallback/TEXTDISP_BannerCharSelected   (status banner chars)
; TYPE: u8/u8
; PURPOSE: Character pair used when composing text display "now showing" status banners.
; USED BY: TEXTDISP_BuildNowShowingStatusLine, SCRIPT4_*
; NOTES: Selected char falls back to fallback char when selected value is sentinel 100.
;------------------------------------------------------------------------------
TEXTDISP_BannerCharFallback:
    DS.B    1
DATA_WDISP_BSS_BYTE_2374:
    DS.B    1
DATA_WDISP_BSS_BYTE_2375:
    DS.B    1
DATA_WDISP_BSS_BYTE_2376:
    DS.B    1
TEXTDISP_BannerCharSelected:
    DS.B    1
DATA_WDISP_BSS_BYTE_2378:
    DS.B    1
DATA_WDISP_BSS_BYTE_2379:
    DS.B    1
DATA_WDISP_BSS_LONG_237A:
    DS.L    1
    DS.W    1
DATA_WDISP_BSS_LONG_237B:
    DS.L    2
DATA_WDISP_BSS_LONG_237C:
    DS.L    2
    DS.W    1
DATA_WDISP_BSS_LONG_237D:
    DS.L    1
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TLIBA3_VmArrayRuntimeTable/TLIBA3_VmArrayPatternTable   (VM array runtime + pattern tables)
; TYPE: struct[9]/struct[9]
; PURPOSE: Backing tables for TLIBA3 VM-array setup, raster context snapshots, and pattern register layouts.
; USED BY: TLIBA3_InitPatternTable, TLIBA3_BuildDisplayContextForViewMode, TLIBA3_InitRuntimeEntry, TLIBA3_SetFontForAllViewModes
; NOTES: Runtime table is 9 entries x 154 bytes; pattern table is 9 entries x 76 bytes.
;------------------------------------------------------------------------------
TLIBA3_VmArrayRuntimeTable:
    DS.L    346
    DS.W    1
TLIBA3_VmArrayPatternTable:
    DS.L    171
    DS.W    1
DATA_WDISP_BSS_LONG_2380:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: FORMAT_ScratchBuffer   (shared RawDoFmt scratch buffer)
; TYPE: u8[856]
; PURPOSE: Temporary output buffer for formatter wrappers and optional debug-log writes.
; USED BY: FORMAT_RawDoFmtWithScratchBuffer, UNKNOWN2A dead-code formatting wrappers
; NOTES: Sized as 214 longwords.
;------------------------------------------------------------------------------
FORMAT_ScratchBuffer:
    DS.L    214
; Through a bit of manual work, I was able to figure out this points to dos.library
Global_REF_DOS_LIBRARY_2:
    DS.L    55

    if includeCustomAriAssembly
LAB_CTRLHTCMAX:
    NStr    "CTRL H:%04ld Cnt:%ld CRC:%02x State:%ld Byte:%02x"
    endif
