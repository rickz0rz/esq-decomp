    XDEF    STR_CopyUntilAnyDelimN
    XDEF    STR_FindAnyCharInSet
    XDEF    STR_FindAnyCharPtr
    XDEF    STR_FindChar
    XDEF    STR_FindCharPtr
    XDEF    STR_SkipClass3Chars

;!======
;------------------------------------------------------------------------------
; FUNC: STR_CopyUntilAnyDelimN   (Copy until delimiter or length)
; ARGS:
;   stack +8: A3 = source string
;   stack +12: A0 = destination buffer
;   stack +16: D7 = max length
;   stack +20: A2 = delimiter set (NUL-terminated)
; RET:
;   D0: pointer into source where copy stopped
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   none
; READS:
;   A3 (source), A2 (delimiter set)
; WRITES:
;   destination buffer (NUL-terminated)
; DESC:
;   Copies bytes from source into destination until a delimiter is hit,
;   the source ends, or max length is reached.
; NOTES:
;   Stops before D7-1; always writes a trailing NUL.
;------------------------------------------------------------------------------
STR_CopyUntilAnyDelimN:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 36(A7),A3
    MOVE.L  44(A7),D7
    MOVEA.L 48(A7),A2
    MOVEQ   #0,D6

.scan_source:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.S   .finish_copy

    TST.B   0(A3,D6.L)
    BEQ.S   .finish_copy

    MOVEQ   #0,D5

.scan_delims:
    TST.B   0(A2,D5.L)
    BEQ.S   .check_delim_end

    MOVE.B  0(A3,D6.L),D0
    CMP.B   0(A2,D5.L),D0
    BEQ.S   .check_delim_end

    ADDQ.L  #1,D5
    BRA.S   .scan_delims

.check_delim_end:
    TST.B   0(A2,D5.L)
    BNE.S   .finish_copy              ; stop if matched a delimiter

    MOVEA.L 12(A5),A0
    MOVE.B  0(A3,D6.L),0(A0,D6.L)     ; copy byte into destination
    ADDQ.L  #1,D6
    BRA.S   .scan_source

.finish_copy:
    MOVEA.L 12(A5),A0
    CLR.B   0(A0,D6.L)
    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  A0,D0

    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STR_FindChar   (Find first occurrence of byte)
; ARGS:
;   stack +8: A3 = string
;   stack +12: D7 = byte to find
; RET:
;   D0: pointer to match, or 0 if not found
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   none
; READS:
;   A3
; WRITES:
;   none
; DESC:
;   Scans the string for the first occurrence of a byte.
; NOTES:
;   Returns 0 if NUL terminator is reached with no match.
;------------------------------------------------------------------------------
STR_FindChar:
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7

.scan_string:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMP.L   D7,D0
    BNE.S   .advance_or_done

    MOVE.L  A3,D0                      ; match found
    BRA.S   .return

.advance_or_done:
    MOVE.B  (A3)+,D0
    TST.B   D0
    BNE.S   .scan_string

    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STR_FindCharPtr   (Wrapper around STR_FindChar)
; ARGS:
;   stack +8: A3 = string
;   stack +12: D7 = byte to find
; RET:
;   D0: pointer to match, or 0 if not found
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   STR_FindChar (STR_FindChar)
; READS:
;   A3
; WRITES:
;   none
; DESC:
;   Convenience wrapper around STR_FindChar.
; NOTES:
;   Equivalent behavior to a `strchr` helper with this ABI:
;     D0 = STR_FindCharPtr(stringPtr, targetByte)
;   Commonly used both for delimiter search and "is byte in set-string" tests
;   by checking whether D0 is non-zero.
;   This symbol is the canonical target behind multiple jump-table aliases
;   (`GROUP_AS_JMPTBL_STR_FindCharPtr`, `GROUP_AI_JMPTBL_STR_FindCharPtr`,
;   `PARSEINI_JMPTBL_STR_FindCharPtr`) used across parser/grid/disk paths.
;------------------------------------------------------------------------------
STR_FindCharPtr:
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.S   STR_FindChar

    ADDQ.W  #8,A7

    MOVEM.L (A7)+,D7/A3
    RTS

;------------------------------------------------------------------------------
; SYM: STR_FindCharPtr_UnreachableLastMatchStub   (post-RTS legacy scan stub)
; TYPE: code block (unreachable in current control flow)
; PURPOSE: Legacy/stranded implementation that tracks the last matching byte.
; USED BY: none confirmed (no branch/call sites in current linked paths)
; NOTES: Starts immediately after STR_FindCharPtr returns; behaves like
;   a `strrchr`-style scan (`A2 = last match`) but is not entered by current
;   callers or in-file branches.
;------------------------------------------------------------------------------
STR_FindCharPtr_UnreachableLastMatchStub:
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    SUBA.L  A2,A2

.scan_string:
    TST.B   (A3)
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMP.L   D7,D0
    BNE.S   .advance_char

    MOVEA.L A3,A2                      ; remember last match

.advance_char:
    ADDQ.L  #1,A3
    BRA.S   .scan_string

.return:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STR_FindAnyCharInSet   (Find first occurrence of any byte in set)
; ARGS:
;   stack +8: A3 = string
;   stack +12: A2 = charset (NUL-terminated)
; RET:
;   D0: pointer to first matching byte, or 0 if none
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   none
; READS:
;   A3, A2
; WRITES:
;   none
; DESC:
;   Searches the string for the first byte that appears in the charset.
; NOTES:
;   Equivalent to strpbrk.
;------------------------------------------------------------------------------
STR_FindAnyCharInSet:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2

.scan_input:
    TST.B   (A3)
    BEQ.S   .not_found

    MOVE.L  A2,-4(A5)

.scan_charset:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .advance_input

    MOVE.B  (A0),D0
    CMP.B   (A3),D0
    BNE.S   .advance_charset

    MOVE.L  A3,D0                      ; match found
    BRA.S   .return

.advance_charset:
    ADDQ.L  #1,-4(A5)
    BRA.S   .scan_charset

.advance_input:
    ADDQ.L  #1,A3
    BRA.S   .scan_input

.not_found:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STR_FindAnyCharPtr   (Wrapper around STR_FindAnyCharInSet)
; ARGS:
;   stack +8: A3 = string
;   stack +12: A2 = charset
; RET:
;   D0: pointer to first matching byte, or 0 if none
; CLOBBERS:
;   D0/A2-A3
; CALLS:
;   STR_FindAnyCharInSet (STR_FindAnyCharInSet)
; READS:
;   A3, A2
; WRITES:
;   none
; DESC:
;   Convenience wrapper around STR_FindAnyCharInSet.
; NOTES:
;   ABI-preserving shim used by older jump tables and callsites.
;------------------------------------------------------------------------------
STR_FindAnyCharPtr:
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.S   STR_FindAnyCharInSet

    ADDQ.W  #8,A7

    MOVEM.L (A7)+,A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STR_SkipClass3Chars   (Skip chars with class bit 3 set)
; ARGS:
;   stack +8: A3 = string
; RET:
;   D0: pointer to first char not in class
; CLOBBERS:
;   D0/A0/A3
; CALLS:
;   none
; READS:
;   char-class table at Global_CharClassTable(A4)
; WRITES:
;   none
; DESC:
;   Advances A3 while the current character is marked with bit 3 in the
;   global character-class table.
; NOTES:
;   In observed parser paths this behaves as a "skip whitespace class" helper.
;------------------------------------------------------------------------------
STR_SkipClass3Chars:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

.skip_class3:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     Global_CharClassTable(A4),A0
    BTST    #3,0(A0,D0.L)
    BEQ.S   .return_ptr

    ADDQ.L  #1,A3
    BRA.S   .skip_class3

.return_ptr:
    MOVE.L  A3,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
