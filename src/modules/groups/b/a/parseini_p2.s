    XDEF    _PARSEINI_TestMemoryAndOpenTopazFont



;------------------------------------------------------------------------------
; FUNC: TEST_MEMORY_AND_OPEN_TOPAZ_FONT   (Test memory then open Topaz)
; ARGS:
;   stack +8: A3 = pointer to font handle storage
;   stack +12: A2 = TextAttr for desired font
; RET:
;   D0: 0 on success, 1 on failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOCloseFont, _LVOForbid/_LVOPermit, _LVOAllocMem/_LVOFreeMem, _LVOOpenDiskFont
; READS:
;   _Global_HANDLE_TOPAZ_FONT
; WRITES:
;   (A3) font handle
; DESC:
;   Ensures a Topaz font is open, first probing for a small alloc; closes an
;   existing non-Topaz handle, tries to open the requested font, otherwise falls
;   back to the global Topaz handle.
; NOTES:
;   Sets D0=1 when it could not load the desired font.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: _PARSEINI_TestMemoryAndOpenTopazFont   (Routine at _PARSEINI_TestMemoryAndOpenTopazFont)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _LVOAllocMem, _LVOCloseFont, _LVOForbid, _LVOFreeMem, _LVOOpenDiskFont, _LVOPermit
; READS:
;   AbsExecBase, DesiredMemoryAvailability, _Global_HANDLE_TOPAZ_FONT, _Global_REF_DISKFONT_LIBRARY, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSEINI_TestMemoryAndOpenTopazFont:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #0,D7
    TST.L   (A3)
    BEQ.S   .return

    MOVEA.L (A3),A0
    MOVEA.L _Global_HANDLE_TOPAZ_FONT,A1
    CMPA.L  A0,A1
    BEQ.S   .testDesiredMemoryAvailability

    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.testDesiredMemoryAvailability:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  #DesiredMemoryAvailability,D0
    MOVEQ   #1,D1
    JSR     _LVOAllocMem(A6)

    MOVE.L  D0,-4(A5)
    BEQ.S   .openTopazFont

    MOVEA.L D0,A1
    MOVE.L  #DesiredMemoryAvailability,D0
    JSR     _LVOFreeMem(A6)

.openTopazFont:
    JSR     _LVOPermit(A6)

    MOVEA.L A2,A0
    MOVEA.L _Global_REF_DISKFONT_LIBRARY,A6
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,(A3)
    BNE.S   .couldNotLoadTopazFont

    MOVE.L  _Global_HANDLE_TOPAZ_FONT,(A3)
    BRA.S   .return

.couldNotLoadTopazFont:
    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======