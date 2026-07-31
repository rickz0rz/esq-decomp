    XDEF    _ESQIFF_ReadNextExternalAssetPathEntry


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_ReadNextExternalAssetPathEntry   (Read next newline-delimited external asset path entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D4/D5/D6/D7
; CALLS:
;   _ESQDISP_ProcessGridMessagesIfIdle
; READS:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_DF0_LOGO_LST_FILESIZE, _Global_REF_LONG_GFX_G_ADS_DATA, _Global_REF_LONG_GFX_G_ADS_FILESIZE, _ESQIFF_LogoListLineIndex, _ESQIFF_GAdsListLineIndex, _ESQIFF_AssetSourceSelect, _ESQIFF_GAdsSourceEnabled
; WRITES:
;   _ESQIFF_LogoListLineIndex, _ESQIFF_GAdsListLineIndex, _ESQIFF_ExternalAssetPathCommaFlag
; DESC:
;   Selects active catalog stream, advances to current line index, then copies one
;   path entry into output buffer stopping on CR/LF/space or comma delimiters.
; NOTES:
;   Comma delimiter sets _ESQIFF_ExternalAssetPathCommaFlag and returns empty string.
;------------------------------------------------------------------------------
_ESQIFF_ReadNextExternalAssetPathEntry:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .select_gads_catalog

    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    MOVE.W  _ESQIFF_LogoListLineIndex,D6
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetPathCommaFlag
    BRA.S   .begin_line_seek

.select_gads_catalog:
    MOVE.W  _ESQIFF_GAdsSourceEnabled,D0
    BEQ.S   .return_no_catalog_enabled

    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)
    MOVE.W  _ESQIFF_GAdsListLineIndex,D6
    BRA.S   .begin_line_seek

.return_no_catalog_enabled:
    MOVEQ   #0,D0
    BRA.W   .return

.begin_line_seek:
    MOVEQ   #0,D7

.loop_seek_to_target_line:
    CMP.W   D6,D7
    BGE.S   .begin_entry_copy

    TST.L   D4
    BLE.S   .begin_entry_copy

    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BNE.S   .consume_seek_char

    ADDQ.W  #1,D7

.consume_seek_char:
    SUBQ.L  #1,D4
    BRA.S   .loop_seek_to_target_line

.begin_entry_copy:
    TST.L   D4
    BNE.S   .advance_line_index_counter

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .reload_gads_catalog_start

    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    BRA.S   .reset_line_index_to_one

.reload_gads_catalog_start:
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)

.reset_line_index_to_one:
    MOVEQ   #1,D6
    BRA.S   .store_updated_line_index

.advance_line_index_counter:
    ADDQ.W  #1,D6

.store_updated_line_index:
    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .store_gads_line_index

    MOVE.W  D6,_ESQIFF_LogoListLineIndex
    BRA.S   .loop_copy_entry_chars

.store_gads_line_index:
    MOVE.W  D6,_ESQIFF_GAdsListLineIndex

.loop_copy_entry_chars:
    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVEQ   #13,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVEQ   #32,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVE.L  D4,D0
    SUBQ.L  #1,D4
    TST.L   D0
    BLE.S   .terminate_and_return_entry

    MOVEQ   #44,D0
    CMP.B   D0,D5
    BNE.S   .append_entry_char

    CLR.B   (A3)
    MOVE.W  #1,_ESQIFF_ExternalAssetPathCommaFlag
    BRA.S   .terminate_and_return_entry

.append_entry_char:
    MOVE.B  D5,(A3)+
    BRA.S   .loop_copy_entry_chars

.terminate_and_return_entry:
    CLR.B   (A3)
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======