    XDEF    _ESQFUNC_DrawEscMenuVersion


; Draw the contents of the ESC -> Version screen
;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_DrawEscMenuVersion   (Draw ESC->Version screen text and prompt)
; ARGS:
;   stack +77: arg_1 (via 81(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, _GROUP_AM_JMPTBL_WDISP_SPrintf, _LVOSetAPen, _LVOSetDrMd
; READS:
;   _Global_LONG_BUILD_NUMBER, _Global_LONG_ROM_VERSION_CHECK, _Global_PTR_STR_BUILD_ID, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _Global_STR_BUILD_NUMBER_FORMATTED, _Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1, _Global_STR_ROM_VERSION_1_3, _Global_STR_ROM_VERSION_2_04, _Global_STR_ROM_VERSION_FORMATTED
; WRITES:
;   _ED_DiagnosticsScreenActive
; DESC:
;   Renders build-number and ROM-version lines using sprintf scratch text, then
;   draws the “push any key” prompt and restores normal APen state.
; NOTES:
;   Uses a shared 81-byte local printf buffer at -81(A5) for both lines.
;   _WDISP_SPrintf has no destination-length parameter.
;------------------------------------------------------------------------------
_ESQFUNC_DrawEscMenuVersion:

.versionLineBuffer = -81

    LINK.W  A5,#-84

    CLR.W   _ED_DiagnosticsScreenActive

    ; _Global_REF_RASTPORT_1 seems to be a rastport that's used a lot in here.
    MOVEA.L _Global_REF_RASTPORT_1,A1

    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    ; Build "Build Number: '%ld%s'" string
    MOVE.L  _Global_PTR_STR_BUILD_ID,-(A7)     ; parameter 2
    MOVE.L  _Global_LONG_BUILD_NUMBER,-(A7)    ; parameter 1
    PEA     _Global_STR_BUILD_NUMBER_FORMATTED ; format string
    PEA     .versionLineBuffer(A5)          ; result string pointer
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)            ; call printf

    ; Display string at position
    PEA     .versionLineBuffer(A5)          ; string
    PEA     330.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

    MOVEQ   #1,D0                           ; Set D0 to 1
    CMP.L   _Global_LONG_ROM_VERSION_CHECK,D0  ; And compare _Global_LONG_ROM_VERSION_CHECK with it.
    BNE.S   .setRomVersion2_04              ; If it's not equal, jump to LAB_098F

    LEA     _Global_STR_ROM_VERSION_1_3,A0     ; Load the effective address of the 1.3 string to A0
    BRA.S   .format_rom_version_line

.setRomVersion2_04:
    LEA     _Global_STR_ROM_VERSION_2_04,A0    ; Load the effective address of the 2.04 string to A0

.format_rom_version_line:
    MOVE.L  A0,-(A7)                        ; parameter 1
    PEA     _Global_STR_ROM_VERSION_FORMATTED  ; format string
    PEA     .versionLineBuffer(A5)          ; result string pointer
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)            ; call printf

    PEA     .versionLineBuffer(A5)          ; string
    PEA     360.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1 ; string
    PEA     390.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======