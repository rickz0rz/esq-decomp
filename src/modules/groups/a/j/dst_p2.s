    XDEF    DST_LoadBannerPairFromFiles


;------------------------------------------------------------------------------
; FUNC: DST_LoadBannerPairFromFiles   (Load G2/G3 banner fragments and refresh queue)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +18: arg_2 (via 22(A5))
;   stack +40: arg_3 (via 44(A5))
;   stack +44: arg_4 (via 48(A5))
;   stack +48: arg_5 (via 52(A5))
;   stack +60: arg_6 (via 64(A5))
; RET:
;   D0: 1 on success, 0 on failure
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   _DST_RebuildBannerPair, _DISKIO_LoadFileToWorkBuffer, GROUP_AJ_JMPTBL_STRING_FindSubstring, DATETIME_ParseString, DATETIME_CopyPairAndRecalc, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, DST_UpdateBannerQueue
; READS:
;   DST_DefaultDatPathPtr, Global_STR_G2, Global_STR_G3
; WRITES:
;   (A3), 4(A3)
; DESC:
;   Rebuilds the pair, loads G2/G3 fragments, and updates the banner queue.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_LoadBannerPairFromFiles:
    LINK.W  A5,#-56
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    ; Reset buffers and load G2/G3 banner fragments.
    MOVE.L  A3,-(A7)
    BSR.S   _DST_RebuildBannerPair

    MOVE.L  DST_DefaultDatPathPtr,(A7)
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .init_ok

    MOVEQ   #0,D0
    BRA.W   .return

.init_ok:
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    PEA     Global_STR_G2
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-48(A5)
    JSR     GROUP_AJ_JMPTBL_STRING_FindSubstring(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   .skip_g2

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  4(A3),-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7

.skip_g2:
    PEA     Global_STR_G3
    MOVE.L  -48(A5),-(A7)
    JSR     GROUP_AJ_JMPTBL_STRING_FindSubstring(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   .skip_g3

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  (A3),-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7

.skip_g3:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -48(A5),-(A7)
    PEA     889.W
    PEA     Global_STR_DST_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVE.L  A3,(A7)
    BSR.W   DST_UpdateBannerQueue

    MOVEQ   #1,D0

.return:
    MOVEM.L -64(A5),D7/A3
    UNLK    A5
    RTS
