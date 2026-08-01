    XDEF    _Global_ESQPARS2_C_1
    XDEF    _Global_ESQPARS2_C_2
    XDEF    _Global_ESQPARS2_C_3
    XDEF    _Global_ESQPARS2_C_4
    XDEF    _Global_STR_CLOSED_CAPTIONED
    XDEF    _Global_STR_IN_STEREO
    XDEF    _Global_TBL_MOVIE_RATINGS
    XDEF    _ESQPARS2_MovieRatingTokenGlyphMap
    XDEF    _Global_TBL_TV_PROGRAM_RATINGS
    XDEF    _ESQPARS2_TvRatingTokenGlyphMap
    XDEF    _Global_STR_ESQPARS2_C_1
    XDEF    _ESQPARS2_DurationFmt_DecimalWithSpace
    XDEF    _ESQPARS2_DurationFmt_OpenParenHours
    XDEF    _ESQPARS2_DurationFmt_OpenParenMinutes
    XDEF    _ESQPARS2_DurationFmt_CloseParen
    XDEF    _Global_STR_ESQPARS2_C_2
    XDEF    _Global_LONG_PATCH_VERSION_NUMBER
    XDEF    _ESQPARS2_BannerSnapshotPlane0DstPtr
    XDEF    _ESQPARS2_BannerSnapshotPlane0DstPtrLo
    XDEF    _ESQPARS2_BannerSnapshotPlane1DstPtr
    XDEF    _ESQPARS2_BannerSnapshotPlane1DstPtrLo
    XDEF    _ESQPARS2_BannerSnapshotPlane2DstPtr
    XDEF    _ESQPARS2_BannerSnapshotPlane2DstPtrLo
    XDEF    _ESQPARS2_SnapshotLivePlane0Base
    XDEF    _ESQPARS2_SnapshotLivePlane1Base
    XDEF    _ESQPARS2_SnapshotLivePlane2Base
    XDEF    _ESQPARS2_BannerRowOffsetResetPtrPlane0
    XDEF    _ESQPARS2_BannerRowOffsetResetPtrPlane1
    XDEF    _ESQPARS2_BannerRowOffsetResetPtrPlane2Table
    XDEF    _ESQPARS2_CopperProgramPendingFlag
    XDEF    _ESQPARS2_EdDiagResetScratchFlag
    XDEF    _ESQPARS2_BannerSweepEntryGuardCounter
    XDEF    _ESQPARS2_BannerSweepDelayCounter
    XDEF    _ESQPARS2_HighlightTickCountdown
    XDEF    _ESQPARS2_StateIndex
    XDEF    _ESQPARS2_BannerQueueAttentionCountdown
    XDEF    _ESQPARS2_BannerTailBiasValue
    XDEF    _ESQPARS2_BannerSweepBaseColor
    XDEF    _ESQPARS2_BannerSweepOffsetColor
    XDEF    _ESQPARS2_ReadModeFlags
    XDEF    _ESQPARS2_BannerColorStepCounter
    XDEF    _ESQPARS2_BannerColorClampThreshold
    XDEF    _ESQPARS2_BannerQueueBuffer
    XDEF    _ESQPARS2_BannerColorThreshold
    XDEF    _ESQPARS2_BannerColorBaseValue
    XDEF    _ESQPARS2_BannerRowCopyWordCount
    XDEF    _ESQPARS2_BannerRowCopySpanBytes
    XDEF    _ESQPARS2_BannerRowCopyStrideBytes
    XDEF    _ESQPARS2_BannerCopySourceOffset
    XDEF    _ESQPARS2_BannerCopyTailOffset
    XDEF    _ESQSHARED_BlitAddressOffset
    XDEF    _ESQPARS2_ActiveCopperListSelectFlag
    XDEF    _ESQPARS2_BannerRowCount
    XDEF    _ESQPARS2_BannerRowWidthBytes
    XDEF    _ESQPARS2_BannerCopyBlockSpanBytes
    XDEF    _ESQPARS2_BannerCopyBlockWordLimit
    XDEF    _ESQPARS2_BannerQueueAttentionDelayTicks
    XDEF    _ESQPARS2_LogAppendSpinlock
    XDEF    _ESQPARS2_LogTimestampFmt
    XDEF    _ESQPARS2_LogTagPm
    XDEF    _ESQPARS2_LogTagAm
; ========== ESQPARS2.c ==========

_Global_ESQPARS2_C_1:
    NStr    "ESQPARS2.c"
_Global_ESQPARS2_C_2:
    NStr    "ESQPARS2.c"
_Global_ESQPARS2_C_3:
    NStr    "ESQPARS2.c"
_Global_ESQPARS2_C_4:
    NStr    "ESQPARS2.c"
_Global_STR_CLOSED_CAPTIONED:
    NStr    "(CC)"
_Global_STR_IN_STEREO:
    NStr    "In Stereo"

_Global_STR_RATING_R:
    NStr    "(R)"
_Global_STR_RATING_ADULT:
    NStr    "(Adult)"
_Global_STR_RATING_PG:
    NStr    "(PG)"
_Global_STR_RATING_NR:
    NStr    "(NR)"
_Global_STR_RATING_PG_13:
    NStr    "(PG-13)"
_Global_STR_RATING_G:
    NStr    "(G)"
_Global_STR_RATING_NC_17:
    NStr    "(NC-17)"

_Global_TBL_MOVIE_RATINGS:
    DC.L    _Global_STR_RATING_R
    DC.L    _Global_STR_RATING_ADULT
    DC.L    _Global_STR_RATING_PG
    DC.L    _Global_STR_RATING_NR
    DC.L    _Global_STR_RATING_PG_13
    DC.L    _Global_STR_RATING_G
    DC.L    _Global_STR_RATING_NC_17

; A table of the character codes that map to the movie ratings in the font
_ESQPARS2_MovieRatingTokenGlyphMap:
    DC.B    $84
    DC.B    $86
    DC.B    $85
    DC.B    $8C
    DC.B    $87
    DC.B    $8D
    DC.B    $8F
    DC.B    0       ; Table terminator

_Global_STR_TV_Y:
    NStr    "(TV-Y)"
_Global_STR_TV_Y7:
    NStr    "(TV-Y7)"
_Global_STR_TV_PG:
    NStr    "(TV-PG)"
_Global_STR_TV_G:
    NStr    "(TV-G)"
_Global_STR_TV_M:
    NStr    "(TV-M)"
_Global_STR_TV_MA:
    NStr    "(TV-MA)"
_Global_STR_TV_14:
    NStr    "(TV-14)"

_Global_TBL_TV_PROGRAM_RATINGS:
    DC.L    _Global_STR_TV_Y
    DC.L    _Global_STR_TV_Y7
    DC.L    _Global_STR_TV_PG
    DC.L    _Global_STR_TV_G
    DC.L    _Global_STR_TV_M
    DC.L    _Global_STR_TV_MA
    DC.L    _Global_STR_TV_14

; A table of the character codes that map to the TV ratings in the font
_ESQPARS2_TvRatingTokenGlyphMap:
    DC.B    $90
    DC.B    $93
    DC.B    $9b
    DC.B    $99
    DC.B    $A3
    DC.B    $A3
    DC.B    $9A
    DC.B    0       ; Table terminator

_Global_STR_ESQPARS2_C_1:
    NStr    "ESQPARS2.c"
_ESQPARS2_DurationFmt_DecimalWithSpace:
    NStr    "%d "
_ESQPARS2_DurationFmt_OpenParenHours:
    NStr    "(%d "
_ESQPARS2_DurationFmt_OpenParenMinutes:
    NStr    "(%d "
_ESQPARS2_DurationFmt_CloseParen:
    NStr    ")"
_Global_STR_ESQPARS2_C_2:
    NStr    "ESQPARS2.c"
    DS.W    1
_Global_LONG_PATCH_VERSION_NUMBER:
    DC.L    $00000004 ; Patch version number
;------------------------------------------------------------------------------
; SYM: _ESQPARS2_BannerSnapshotPlane0DstPtr.._ESQPARS2_BannerSnapshotPlane2DstPtrLo
; TYPE: pointer array storage (3 x u32 split into hi/lo words)
; PURPOSE: Destination pointers for banner-plane snapshot copy routines.
; USED BY: ESQSHARED4_SetupBannerPlanePointerWords, _ESQSHARED4_CopyPlanesFromContextToSnapshot, _ESQSHARED4_CopyLivePlanesToSnapshot, _GCOMMAND_RefreshBannerTables
; NOTES:
;   Layout is contiguous longwords:
;     plane0 ptr = _ESQPARS2_BannerSnapshotPlane0DstPtr/_ESQPARS2_BannerSnapshotPlane0DstPtrLo
;     plane1 ptr = _ESQPARS2_BannerSnapshotPlane1DstPtr/_ESQPARS2_BannerSnapshotPlane1DstPtrLo
;     plane2 ptr = _ESQPARS2_BannerSnapshotPlane2DstPtr/_ESQPARS2_BannerSnapshotPlane2DstPtrLo
;   Code often accesses this block as a u32[] via post-increment addressing.
;------------------------------------------------------------------------------
_ESQPARS2_BannerSnapshotPlane0DstPtr:
    DS.W    1
_ESQPARS2_BannerSnapshotPlane0DstPtrLo:
    DS.W    1
_ESQPARS2_BannerSnapshotPlane1DstPtr:
    DS.W    1
_ESQPARS2_BannerSnapshotPlane1DstPtrLo:
    DS.W    1
_ESQPARS2_BannerSnapshotPlane2DstPtr:
    DS.W    1
_ESQPARS2_BannerSnapshotPlane2DstPtrLo:
    DS.W    1
_ESQPARS2_SnapshotLivePlane0Base:
    DS.L    1
_ESQPARS2_SnapshotLivePlane1Base:
    DS.L    1
_ESQPARS2_SnapshotLivePlane2Base:
    DS.L    1
_ESQPARS2_BannerRowOffsetResetPtrPlane0:
    DS.L    1
_ESQPARS2_BannerRowOffsetResetPtrPlane1:
    DS.L    1
_ESQPARS2_BannerRowOffsetResetPtrPlane2Table:
    DS.L    9
_ESQPARS2_CopperProgramPendingFlag:
    DS.W    1
_ESQPARS2_EdDiagResetScratchFlag:
    DS.W    1
_ESQPARS2_BannerSweepEntryGuardCounter:
    DS.W    1
_ESQPARS2_BannerSweepDelayCounter:
    DS.L    1
_ESQPARS2_HighlightTickCountdown:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQPARS2_StateIndex   (ESQPARS2 runtime state index)
; TYPE: u16
; PURPOSE: Holds a small parser/UI state index used by ESQPARS2-linked flows.
; USED BY: ESQIFF2_*, ED2_*, ESQSHARED4_*
; NOTES: Typical values are low integers (for example 2, 4).
;------------------------------------------------------------------------------
_ESQPARS2_StateIndex:
    DS.W    1
_ESQPARS2_BannerQueueAttentionCountdown:
    DS.W    1
_ESQPARS2_BannerTailBiasValue:
    DS.W    1
_ESQPARS2_BannerSweepBaseColor:
    DS.W    1
_ESQPARS2_BannerSweepOffsetColor:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQPARS2_ReadModeFlags   (input/read mode flags)
; TYPE: u16
; PURPOSE: Global mode word controlling stream/buffer handling behavior.
; USED BY: DISKIO_*, APP_*, ESQFUNC_*, NEWGRID_*, SCRIPT3_*
; NOTES: Observed values include 0, 5, $0100, $0101, $0102, $0200.
;------------------------------------------------------------------------------
_ESQPARS2_ReadModeFlags:
    DS.W    1
_ESQPARS2_BannerColorStepCounter:
    DS.L    1
_ESQPARS2_BannerColorClampThreshold:
    DS.W    1
_ESQPARS2_BannerQueueBuffer:
    DS.L    25
_ESQPARS2_BannerColorThreshold:
    DS.L    1
_ESQPARS2_BannerColorBaseValue:
    DS.W    1
_ESQPARS2_BannerRowCopyWordCount:
    DS.W    1
_ESQPARS2_BannerRowCopySpanBytes:
    DS.L    1
_ESQPARS2_BannerRowCopyStrideBytes:
    DS.L    1
_ESQPARS2_BannerCopySourceOffset:
    DS.L    1
_ESQPARS2_BannerCopyTailOffset:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQSHARED_BlitAddressOffset   (shared blit address offset)
; TYPE: s32
; PURPOSE: Offset added to paired source/destination pointers before blits/copies.
; USED BY: ESQSHARED4_* drawing/compositing paths
; NOTES: Applied symmetrically to A1/A2 style pointer pairs.
;------------------------------------------------------------------------------
_ESQSHARED_BlitAddressOffset:
    DS.L    1
_ESQPARS2_ActiveCopperListSelectFlag:
    DS.L    1
_ESQPARS2_BannerRowCount:
    DC.L    $00000022
_ESQPARS2_BannerRowWidthBytes:
    DC.W    $0100
_ESQPARS2_BannerCopyBlockSpanBytes:
    DC.W    $00c0
_ESQPARS2_BannerCopyBlockWordLimit:
    DC.W    $0010
_ESQPARS2_BannerQueueAttentionDelayTicks:
    DC.L    $00110000
    DS.L    1
_ESQPARS2_LogAppendSpinlock:
    DS.L    1
_ESQPARS2_LogTimestampFmt:
    NStr    "%02ld:%02ld:%02ld %2.2s"
_ESQPARS2_LogTagPm:
    NStr    "PM"
_ESQPARS2_LogTagAm:
    NStr    "AM"