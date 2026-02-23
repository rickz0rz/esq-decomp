; ========== ESQPARS2.c ==========

Global_ESQPARS2_C_1:
    NStr    "ESQPARS2.c"
Global_ESQPARS2_C_2:
    NStr    "ESQPARS2.c"
Global_ESQPARS2_C_3:
    NStr    "ESQPARS2.c"
Global_ESQPARS2_C_4:
    NStr    "ESQPARS2.c"
Global_STR_CLOSED_CAPTIONED:
    NStr    "(CC)"
Global_STR_IN_STEREO:
    NStr    "In Stereo"

Global_STR_RATING_R:
    NStr    "(R)"
Global_STR_RATING_ADULT:
    NStr    "(Adult)"
Global_STR_RATING_PG:
    NStr    "(PG)"
Global_STR_RATING_NR:
    NStr    "(NR)"
Global_STR_RATING_PG_13:
    NStr    "(PG-13)"
Global_STR_RATING_G:
    NStr    "(G)"
Global_STR_RATING_NC_17:
    NStr    "(NC-17)"

Global_TBL_MOVIE_RATINGS:
    DC.L    Global_STR_RATING_R
    DC.L    Global_STR_RATING_ADULT
    DC.L    Global_STR_RATING_PG
    DC.L    Global_STR_RATING_NR
    DC.L    Global_STR_RATING_PG_13
    DC.L    Global_STR_RATING_G
    DC.L    Global_STR_RATING_NC_17

; A table of the character codes that map to the movie ratings in the font
ESQPARS2_MovieRatingTokenGlyphMap:
    DC.B    $84
    DC.B    $86
    DC.B    $85
    DC.B    $8C
    DC.B    $87
    DC.B    $8D
    DC.B    $8F
    DC.B    0       ; Table terminator

Global_STR_TV_Y:
    NStr    "(TV-Y)"
Global_STR_TV_Y7:
    NStr    "(TV-Y7)"
Global_STR_TV_PG:
    NStr    "(TV-PG)"
Global_STR_TV_G:
    NStr    "(TV-G)"
Global_STR_TV_M:
    NStr    "(TV-M)"
Global_STR_TV_MA:
    NStr    "(TV-MA)"
Global_STR_TV_14:
    NStr    "(TV-14)"

Global_TBL_TV_PROGRAM_RATINGS:
    DC.L    Global_STR_TV_Y
    DC.L    Global_STR_TV_Y7
    DC.L    Global_STR_TV_PG
    DC.L    Global_STR_TV_G
    DC.L    Global_STR_TV_M
    DC.L    Global_STR_TV_MA
    DC.L    Global_STR_TV_14

; A table of the character codes that map to the TV ratings in the font
ESQPARS2_TvRatingTokenGlyphMap:
    DC.B    $90
    DC.B    $93
    DC.B    $9b
    DC.B    $99
    DC.B    $A3
    DC.B    $A3
    DC.B    $9A
    DC.B    0       ; Table terminator

Global_STR_ESQPARS2_C_1:
    NStr    "ESQPARS2.c"
ESQPARS2_DurationFmt_DecimalWithSpace:
    NStr    "%d "
ESQPARS2_DurationFmt_OpenParenHours:
    NStr    "(%d "
ESQPARS2_DurationFmt_OpenParenMinutes:
    NStr    "(%d "
ESQPARS2_DurationFmt_CloseParen:
    NStr    ")"
Global_STR_ESQPARS2_C_2:
    NStr    "ESQPARS2.c"
    DS.W    1
Global_LONG_PATCH_VERSION_NUMBER:
    DC.L    $00000004 ; Patch version number
;------------------------------------------------------------------------------
; SYM: ESQPARS2_BannerSnapshotPlane0DstPtr..ESQPARS2_BannerSnapshotPlane2DstPtrLo
; TYPE: pointer array storage (3 x u32 split into hi/lo words)
; PURPOSE: Destination pointers for banner-plane snapshot copy routines.
; USED BY: ESQSHARED4_SetupBannerPlanePointerWords, ESQSHARED4_CopyPlanesFromContextToSnapshot, ESQSHARED4_CopyLivePlanesToSnapshot, GCOMMAND_RefreshBannerTables
; NOTES:
;   Layout is contiguous longwords:
;     plane0 ptr = ESQPARS2_BannerSnapshotPlane0DstPtr/ESQPARS2_BannerSnapshotPlane0DstPtrLo
;     plane1 ptr = ESQPARS2_BannerSnapshotPlane1DstPtr/ESQPARS2_BannerSnapshotPlane1DstPtrLo
;     plane2 ptr = ESQPARS2_BannerSnapshotPlane2DstPtr/ESQPARS2_BannerSnapshotPlane2DstPtrLo
;   Code often accesses this block as a u32[] via post-increment addressing.
;------------------------------------------------------------------------------
ESQPARS2_BannerSnapshotPlane0DstPtr:
    DS.W    1
ESQPARS2_BannerSnapshotPlane0DstPtrLo:
    DS.W    1
ESQPARS2_BannerSnapshotPlane1DstPtr:
    DS.W    1
ESQPARS2_BannerSnapshotPlane1DstPtrLo:
    DS.W    1
ESQPARS2_BannerSnapshotPlane2DstPtr:
    DS.W    1
ESQPARS2_BannerSnapshotPlane2DstPtrLo:
    DS.W    1
ESQPARS2_SnapshotLivePlane0Base:
    DS.L    1
ESQPARS2_SnapshotLivePlane1Base:
    DS.L    1
ESQPARS2_SnapshotLivePlane2Base:
    DS.L    1
ESQPARS2_BannerRowOffsetResetPtrPlane0:
    DS.L    1
ESQPARS2_BannerRowOffsetResetPtrPlane1:
    DS.L    1
ESQPARS2_BannerRowOffsetResetPtrPlane2Table:
    DS.L    9
ESQPARS2_CopperProgramPendingFlag:
    DS.W    1
ESQPARS2_EdDiagResetScratchFlag:
    DS.W    1
ESQPARS2_BannerSweepEntryGuardCounter:
    DS.W    1
ESQPARS2_BannerSweepDelayCounter:
    DS.L    1
ESQPARS2_HighlightTickCountdown:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS2_StateIndex   (ESQPARS2 runtime state index)
; TYPE: u16
; PURPOSE: Holds a small parser/UI state index used by ESQPARS2-linked flows.
; USED BY: ESQIFF2_*, ED2_*, ESQSHARED4_*
; NOTES: Typical values are low integers (for example 2, 4).
;------------------------------------------------------------------------------
ESQPARS2_StateIndex:
    DS.W    1
ESQPARS2_BannerQueueAttentionCountdown:
    DS.W    1
ESQPARS2_BannerTailBiasValue:
    DS.W    1
ESQPARS2_BannerSweepBaseColor:
    DS.W    1
ESQPARS2_BannerSweepOffsetColor:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS2_ReadModeFlags   (input/read mode flags)
; TYPE: u16
; PURPOSE: Global mode word controlling stream/buffer handling behavior.
; USED BY: DISKIO_*, APP_*, ESQFUNC_*, NEWGRID_*, SCRIPT3_*
; NOTES: Observed values include 0, 5, $0100, $0101, $0102, $0200.
;------------------------------------------------------------------------------
ESQPARS2_ReadModeFlags:
    DS.W    1
ESQPARS2_BannerColorStepCounter:
    DS.L    1
ESQPARS2_BannerColorClampThreshold:
    DS.W    1
ESQPARS2_BannerQueueBuffer:
    DS.L    25
ESQPARS2_BannerColorThreshold:
    DS.L    1
ESQPARS2_BannerColorBaseValue:
    DS.W    1
ESQPARS2_BannerRowCopyWordCount:
    DS.W    1
ESQPARS2_BannerRowCopySpanBytes:
    DS.L    1
ESQPARS2_BannerRowCopyStrideBytes:
    DS.L    1
ESQPARS2_BannerCopySourceOffset:
    DS.L    1
ESQPARS2_BannerCopyTailOffset:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQSHARED_BlitAddressOffset   (shared blit address offset)
; TYPE: s32
; PURPOSE: Offset added to paired source/destination pointers before blits/copies.
; USED BY: ESQSHARED4_* drawing/compositing paths
; NOTES: Applied symmetrically to A1/A2 style pointer pairs.
;------------------------------------------------------------------------------
ESQSHARED_BlitAddressOffset:
    DS.L    1
ESQPARS2_ActiveCopperListSelectFlag:
    DS.L    1
ESQPARS2_BannerRowCount:
    DC.L    $00000022
ESQPARS2_BannerRowWidthBytes:
    DC.W    $0100
ESQPARS2_BannerCopyBlockSpanBytes:
    DC.W    $00c0
ESQPARS2_BannerCopyBlockWordLimit:
    DC.W    $0010
ESQPARS2_BannerQueueAttentionDelayTicks:
    DC.L    $00110000
    DS.L    1
ESQPARS2_LogAppendSpinlock:
    DS.L    1
ESQPARS2_LogTimestampFmt:
    NStr    "%02ld:%02ld:%02ld %2.2s"
ESQPARS2_LogTagPm:
    NStr    "PM"
ESQPARS2_LogTagAm:
    NStr    "AM"
ESQPARS2_LogFieldTab:
    DC.W    $0900
ESQPARS2_LogLineTerminator:
    DC.L    $0d0a0000
