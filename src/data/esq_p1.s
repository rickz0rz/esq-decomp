    XDEF    _ESQ_CopperEffectListB
    XDEF    _ESQ_CopperEffectListA_PtrHiWord
    XDEF    _ESQ_CopperEffectListA_PtrLoWord
    XDEF    _ESQ_CopperEffectTemplateRowsSet1
    XDEF    _ESQ_CopperStatusDigitsB
    XDEF    _ESQ_CopperStatusDigitsB_ColorRegistersA
    XDEF    _ESQ_CopperStatusDigitsB_TailColorWord
    XDEF    _ESQ_CopperListBannerB
    XDEF    _ESQ_BannerWorkRasterPtrB_HiWord
    XDEF    _ESQ_BannerWorkRasterPtrB_LoWord
    XDEF    _ESQ_BannerPaletteWordsB
    XDEF    _ESQ_BannerSweepWaitRowB
    XDEF    _ESQ_BannerPlane0ScratchPtrAlt_HiWord
    XDEF    _ESQ_BannerPlane0ScratchPtrAlt_LoWord
    XDEF    _ESQ_BannerPlane1ScratchPtrAlt_HiWord
    XDEF    _ESQ_BannerPlane1ScratchPtrAlt_LoWord
    XDEF    _ESQ_BannerPlane2ScratchPtrAlt_HiWord
    XDEF    _ESQ_BannerPlane2ScratchPtrAlt_LoWord
    XDEF    _ESQ_BannerColorSweepProgramB
    XDEF    _ESQ_BannerSweepWaitStartProgramB
    XDEF    _ESQ_BannerWorkRasterPtrMirrorB_HiWord
    XDEF    _ESQ_BannerWorkRasterPtrMirrorB_LoWord
    XDEF    _ESQ_BannerSweepWaitEndProgramB
    XDEF    _ESQ_BannerSweepSrcPlane0Ptr_HiWord
    XDEF    _ESQ_BannerSweepSrcPlane0Ptr_LoWord
    XDEF    _ESQ_BannerSweepSrcPlane1Ptr_HiWord
    XDEF    _ESQ_BannerSweepSrcPlane1Ptr_LoWord
    XDEF    _ESQ_BannerSweepSrcPlane2Ptr_HiWord
    XDEF    _ESQ_BannerSweepSrcPlane2Ptr_LoWord
    XDEF    _ESQ_CopperEffectJumpTargetB_HiWord
    XDEF    _ESQ_CopperEffectJumpTargetB_LoWord
    XDEF    _ESQ_BannerColorSweepProgramB_AnchorColorWord
    XDEF    _ESQ_BannerColorSweepProgramB_TailColorWord
    XDEF    _ESQ_BannerColorClampValueB
    XDEF    _ESQ_BannerColorClampWaitRowB
    XDEF    _ESQ_BannerSweepSrcPlane0PtrReset_HiWord
    XDEF    _ESQ_BannerSweepSrcPlane0PtrReset_LoWord
    XDEF    _ESQ_BannerSweepSrcPlane1PtrReset_HiWord
    XDEF    _ESQ_BannerSweepSrcPlane1PtrReset_LoWord
    XDEF    _ESQ_BannerSweepSrcPlane2PtrReset_HiWord
    XDEF    _ESQ_BannerSweepSrcPlane2PtrReset_LoWord
    XDEF    _ESQ_CopperEffectSwitchWaitWordB
    XDEF    _ESQ_CopperBannerTailListB
    XDEF    _ESQ_BannerWorkRasterPtrTailB_HiWord
    XDEF    _ESQ_CopperBannerRasterPointerListB
    XDEF    _Global_PTR_AUD1_DMA
_ESQ_CopperEffectListB:
    DC.L    $055bfffe,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$065bfffe,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $03d9fffe
    DC.W    $0080
_ESQ_CopperEffectListA_PtrHiWord:
    DC.L    $00000082
_ESQ_CopperEffectListA_PtrLoWord:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: _ESQ_CopperEffectTemplateRowsSet1   (copper effect list A body template ??)
; TYPE: u32[] + tail word
; PURPOSE: Backing storage for effect-list A command payload words.
; USED BY: ESQSHARED4 banner/copper setup and update paths
; NOTES:
;   Mirrors _ESQ_CopperEffectTemplateRowsSet0 for the alternate effect list.
;------------------------------------------------------------------------------
_ESQ_CopperEffectTemplateRowsSet1:
    DS.L    19
    DC.W    $0180
;------------------------------------------------------------------------------
; SYM: _ESQ_CopperStatusDigitsB   (copper status digit list B)
; TYPE: u32[]
; PURPOSE: Alternate status-digit copperlist template.
; USED BY: APP2_*, ESQFUNC_*, ESQSHARED4_*
; NOTES: Mirrors _ESQ_CopperStatusDigitsA structure with companion data set.
;------------------------------------------------------------------------------
_ESQ_CopperStatusDigitsB:
    DC.L    $00030182
_ESQ_CopperStatusDigitsB_ColorRegistersA:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
_ESQ_CopperStatusDigitsB_TailColorWord:
    DC.W    $0003
;------------------------------------------------------------------------------
; SYM: _ESQ_CopperListBannerB   (banner copper list B)
; TYPE: u32[]
; PURPOSE: Copper command template for banner/digital overlay variant B.
; USED BY: GCOMMAND3_*, APP2_*, ESQSHARED4_*
; NOTES: Companion to _ESQ_CopperListBannerA.
;------------------------------------------------------------------------------
_ESQ_CopperListBannerB:
    DC.L    $00d9fffe,$00920030,$009400d8,$008e1769
    DC.L    $0090ffc5,$01080058,$010a0058,$01009306
    DC.L    $01020000,$01820003
    DC.W    $00e0
;------------------------------------------------------------------------------
; SYM: _ESQ_BannerWorkRasterPtrB_HiWord.._ESQ_BannerWorkRasterPtrTailB_HiWord   (banner copper color-sweep cluster B ??)
; TYPE: u32/u16 mixed command templates
; PURPOSE: Runtime-patched copper command words used by banner color sweep (B path).
; USED BY: _ESQSHARED4_InitializeBannerCopperSystem, ESQSHARED4_ApplyBannerColorStep
; NOTES:
;   Companion set to cluster A above; many entries are structural mirrors.
;   Retain anonymous per-entry labels until row/register mapping is fully traced.
;------------------------------------------------------------------------------
_ESQ_BannerWorkRasterPtrB_HiWord:
    DC.L    $000000e2
_ESQ_BannerWorkRasterPtrB_LoWord:
    DC.L    $00000180
_ESQ_BannerPaletteWordsB:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
_ESQ_BannerSweepWaitRowB:
    DC.L    $00dffffe
    DC.W    $00e0
_ESQ_BannerPlane0ScratchPtrAlt_HiWord:
    DC.L    $000000e2
_ESQ_BannerPlane0ScratchPtrAlt_LoWord:
    DC.L    $000000e4
_ESQ_BannerPlane1ScratchPtrAlt_HiWord:
    DC.L    $000000e6
_ESQ_BannerPlane1ScratchPtrAlt_LoWord:
    DC.L    $000000e8
_ESQ_BannerPlane2ScratchPtrAlt_HiWord:
    DC.L    $000000ea
_ESQ_BannerPlane2ScratchPtrAlt_LoWord:
    DC.L    $00000182
_ESQ_BannerColorSweepProgramB:
    DC.L    $0aaa018e,$03330100,$b30680d5,$80fe0188
    DC.L    $0100018a,$0000018c,$0000018e,$000180d5
    DC.L    $80fe0188,$0200018a,$0011018c,$0111018e
    DC.L    $000280d5,$80fe0188,$0300018a,$0022018c
    DC.L    $0222018e,$000380d5,$80fe0188,$0400018a
    DC.L    $0033018c,$0333018e,$000480d5,$80fe0188
    DC.L    $0500018a,$0044018c,$0444018e,$000580d5
    DC.L    $80fe0188,$0600018a,$0055018c,$0555018e
    DC.L    $000680d5,$80fe0188,$0700018a,$0066018c
    DC.L    $0666018e,$000780d5,$80fe0188,$0800018a
    DC.L    $0077018c,$0777018e,$000880d5,$80fe0188
    DC.L    $0900018a,$0088018c,$0888018e,$000980d5
    DC.L    $80fe0188,$0a00018a,$0099018c,$0999018e
    DC.L    $000a00d5,$80fe0188,$0b00018a,$00aa018c
    DC.L    $0aaa018e,$000b80d5,$80fe0188,$0c00018a
    DC.L    $00bb018c,$0bbb018e,$000c80d5,$80fe0188
    DC.L    $0d00018a,$00cc018c,$0ccc018e,$000d80d5
    DC.L    $80fe0188,$0e00018a,$00dd018c,$0ddd018e
    DC.L    $000e80d5,$80fe0188,$0f00018a,$00ee018c
    DC.L    $0eee018e,$000f80d5,$80fe0188,$0512018a
    DC.L    $016a018c,$0555018e
    DC.W    $0003
_ESQ_BannerSweepWaitStartProgramB:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
_ESQ_BannerWorkRasterPtrMirrorB_HiWord:
    DC.L    $000000e2
_ESQ_BannerWorkRasterPtrMirrorB_LoWord:
    DC.W    0
_ESQ_BannerSweepWaitEndProgramB:
    DC.L    $00dffffe
    DC.W    $00e0
_ESQ_BannerSweepSrcPlane0Ptr_HiWord:
    DC.L    $000000e2
_ESQ_BannerSweepSrcPlane0Ptr_LoWord:
    DC.L    $000000e4
_ESQ_BannerSweepSrcPlane1Ptr_HiWord:
    DC.L    $000000e6
_ESQ_BannerSweepSrcPlane1Ptr_LoWord:
    DC.L    $000000e8
_ESQ_BannerSweepSrcPlane2Ptr_HiWord:
    DC.L    $000000ea
_ESQ_BannerSweepSrcPlane2Ptr_LoWord:
    DC.L    $00000100,$b3060084
_ESQ_CopperEffectJumpTargetB_HiWord:
    DC.L    $00000086
_ESQ_CopperEffectJumpTargetB_LoWord:
    DC.L    $00000182
_ESQ_BannerColorSweepProgramB_AnchorColorWord:
    DC.L    $0aaa018e
_ESQ_BannerColorSweepProgramB_TailColorWord:
    DC.W    $0003
_ESQ_BannerColorClampValueB:
    DC.B    0
_ESQ_BannerColorClampWaitRowB:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
_ESQ_BannerSweepSrcPlane0PtrReset_HiWord:
    DC.L    $000000e2
_ESQ_BannerSweepSrcPlane0PtrReset_LoWord:
    DC.L    $000000e4
_ESQ_BannerSweepSrcPlane1PtrReset_HiWord:
    DC.L    $000000e6
_ESQ_BannerSweepSrcPlane1PtrReset_LoWord:
    DC.L    $000000e8
_ESQ_BannerSweepSrcPlane2PtrReset_HiWord:
    DC.L    $000000ea
_ESQ_BannerSweepSrcPlane2PtrReset_LoWord:
    DC.W    0
_ESQ_CopperEffectSwitchWaitWordB:
    DC.L    $009c8010
_ESQ_CopperBannerTailListB:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
_ESQ_BannerWorkRasterPtrTailB_HiWord:
    DC.L    $000000e2
_ESQ_CopperBannerRasterPointerListB:
    DC.L    $0000ffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff
    DC.W    $fffe
_Global_PTR_AUD1_DMA:
    DC.L    76
