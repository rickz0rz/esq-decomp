; ==========================================
; ESQ-3.asm disassembly + annotation
; ==========================================

; Set this to 1 to include Ari's custom assembly for dumping debug output.
includeCustomAriAssembly = 0

    include "lvo-offsets.s"
    include "hardware-addresses.s"
    include "exec-constants.s"
    include "data-offsets.s"
    include "data-lengths.s"
    include "structs.s"
    include "macros.s"
    include "string-macros.s"
    include "text-formatting.s"
    include "interrupts/constants.s"

    SECTION S_0,CODE

; Some values of importance
DesiredMemoryAvailability        = 8388608  ; 8 MiBytes

Global_ScratchPtr_592            = -592
Global_UNKNOWN36_MessagePtr      = Global_ScratchPtr_592                         ; -592
Global_WBStartupWindowPtr        = Global_ScratchPtr_592-Type_Long_Size          ; -596
Global_SavedStackPointer         = Global_WBStartupWindowPtr-Type_Long_Size      ; -600
Global_SavedMsg                  = Global_SavedStackPointer-Type_Long_Size       ; -604
Global_SavedExecBase             = Global_SavedMsg-Type_Long_Size                ; -608
Global_SavedDirLock              = Global_SavedExecBase-Type_Long_Size           ; -612
Global_SignalCallbackPtr         = Global_SavedDirLock-Type_Long_Size            ; -616
Global_ExitHookPtr               = Global_SignalCallbackPtr-Type_Long_Size       ; -620
Global_DosIoErr                  = -640
Global_CommandLineSize           = -660
Global_WBStartupCmdBuffer        = Global_CommandLineSize-Type_Long_Size         ; -664
Global_UNKNOWN36_RequesterText2  = -684
Global_UNKNOWN36_RequesterText1  = -704
Global_UNKNOWN36_RequesterOutPtr = -712
Global_UNKNOWN36_RequesterText0  = -724
Global_StreamBufferAllocSize      = -748
Global_CharClassTable            = -1007
Global_AllocBlockSize            = -1012
Global_DefaultHandleFlags        = Global_AllocBlockSize-Type_Long_Size          ; -1016
;------------------------------------------------------------------------------
; SYM: Global_PreallocHandleNode0/1/2   (startup preallocated handle nodes)
; TYPE: struct array (34-byte node stride)
; PURPOSE: Early handle-state nodes used before/alongside dynamic handle nodes.
; USED BY: ESQ_ParseCommandLineAndRun, HANDLE_OpenWithMode,
;          BUFFER_FlushAllAndCloseWithCode, STREAM_BufferedWriteString
; NOTES: Field meanings are partial/inferred:
;        +0 next, +4 cursor, +8 read remaining, +12 write remaining,
;        +16 base ptr, +20 capacity, +24 open flags, +26 mode flags byte,
;        +27 status flags byte, +28 handle index, +32 inline-byte scratch.
;        IMPORTANT: +26/+27 are byte overlays inside +24 (open-flags long),
;        not independent storage.
;        Confidence:
;        - Confirmed by direct multi-caller usage: +0/+4/+8/+12/+16/+20/+24/+28.
;        - Provisional naming: +26 ModeFlags and +27 StateFlags bit semantics.
;        Open-mask constants below are behavior-derived from STREAM paths and
;        should stay conservative until additional traces validate intent.
;------------------------------------------------------------------------------
Struct_PreallocHandleNode__Next          = 0
Struct_PreallocHandleNode__BufferCursor  = 4
Struct_PreallocHandleNode__ReadRemaining = 8
Struct_PreallocHandleNode__WriteRemaining = 12
Struct_PreallocHandleNode__BufferBase    = 16
Struct_PreallocHandleNode__BufferCapacity = 20
Struct_PreallocHandleNode__OpenFlags     = 24 ; longword flags; low bytes are aliased below
Struct_PreallocHandleNode__ModeFlags     = 26 ; OpenFlags byte at +2 (bits 15..8)
Struct_PreallocHandleNode__StateFlags    = 27 ; OpenFlags byte at +3 (bits 7..0)
Struct_PreallocHandleNode__HandleIndex   = 28
Struct_PreallocHandleNode__InlineByte    = 32
Struct_PreallocHandleNode_Size           = 34
Struct_PreallocHandleNode_OpenFlagsLowBit0_ReadRefillIssued_Bit = 0
Struct_PreallocHandleNode_OpenFlagsLowBit1_WritePending_Bit = 1
Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit = 2
Struct_PreallocHandleNode_OpenFlagsLowBit3_ForceRealloc_Bit = 3 ; reserved/dead in stock image (no in-tree producer found)
Struct_PreallocHandleNode_OpenFlagsLowBit4_EofOrShort_Bit = 4
Struct_PreallocHandleNode_OpenFlagsLowBit5_IoError_Bit = 5
Struct_PreallocHandleNode_OpenFlagsLowBit6_PreReadFlushGateLo_Bit = 6 ; reserved/dead in stock image (no in-tree producer found)
Struct_PreallocHandleNode_OpenFlagsLowBit7_PreReadFlushGateHi_Bit = 7
Struct_PreallocHandleNode_ModeFlag_TextTranslate_Bit = 7
Struct_PreallocHandleNode_ModeFlag_PreWriteScan_Bit = 6
Struct_PreallocHandleNode_OpenMask_WriteReject = $31
Struct_PreallocHandleNode_OpenMask_FlushReject = $30
Struct_PreallocHandleNode_OpenMask_ReadReject = $32
Global_PreallocHandleNode0              = -1120
Global_HandleTableFlags                 = Global_PreallocHandleNode0-Type_Long_Size ; -1124
Global_AllocBytesTotal           = Global_HandleTableFlags-Type_Long_Size        ; -1128
Global_AllocListHead             = Global_AllocBytesTotal-Type_Long_Size         ; -1132
Global_MemListFirstAllocNode     = -1144
Global_HandleTableCount          = Global_MemListFirstAllocNode-Type_Long_Size   ; -1148
Global_PreallocHandleNode0_OpenFlags = Global_PreallocHandleNode0+Struct_PreallocHandleNode__OpenFlags ; -1096
Global_PreallocHandleNode0_HandleIndex = Global_PreallocHandleNode0+Struct_PreallocHandleNode__HandleIndex ; -1092
Global_PreallocHandleNode1       = Global_PreallocHandleNode0+Struct_PreallocHandleNode_Size ; -1086
Global_PreallocHandleNode1_BufferCursor = Global_PreallocHandleNode1+Struct_PreallocHandleNode__BufferCursor ; -1082
Global_PreallocHandleNode1_WriteRemaining = Global_PreallocHandleNode1+Struct_PreallocHandleNode__WriteRemaining ; -1074
Global_PreallocHandleNode1_BufferBudget = Global_PreallocHandleNode1_WriteRemaining ; legacy alias
Global_PreallocHandleNode1_OpenFlags = Global_PreallocHandleNode1+Struct_PreallocHandleNode__OpenFlags ; -1062
Global_PreallocHandleNode1_HandleIndex = Global_PreallocHandleNode1+Struct_PreallocHandleNode__HandleIndex ; -1058
Global_PreallocHandleNode2       = Global_PreallocHandleNode1+Struct_PreallocHandleNode_Size ; -1052
Global_PreallocHandleNode2_OpenFlags = Global_PreallocHandleNode2+Struct_PreallocHandleNode__OpenFlags ; -1028
Global_PreallocHandleNode2_HandleIndex = Global_PreallocHandleNode2+Struct_PreallocHandleNode__HandleIndex ; -1024
Global_GraphicsLibraryBase_A4    = -22440
; Keep canonical literal, but verify provenance at assemble time.

    ; These values should be equal.
    PRINTV 22492
    PRINTV ESQFUNC_VideoInsertionStateString_StopPtr
Global_HandleTableBase           = 22492

Global_HandleEntry0_Flags        = Global_HandleTableBase+Struct_HandleEntry__Flags
Global_HandleEntry0_Ptr          = Global_HandleTableBase+Struct_HandleEntry__Ptr
Global_HandleEntry1_Flags        = Global_HandleTableBase+Struct_HandleEntry_Size+Struct_HandleEntry__Flags
Global_HandleEntry1_Ptr          = Global_HandleTableBase+Struct_HandleEntry_Size+Struct_HandleEntry__Ptr
Global_HandleEntry2_Flags        = Global_HandleEntry1_Flags+Struct_HandleEntry_Size
Global_HandleEntry2_Ptr          = Global_HandleEntry1_Ptr+Struct_HandleEntry_Size
Global_PrintfBufferPtr           = Global_HandleTableBase+320                    ; 22812
Global_PrintfByteCount           = Global_PrintfBufferPtr+Type_Long_Size         ; 22816
Global_FormatCallbackBufferPtr   = Global_PrintfByteCount+Type_Long_Size         ; 22820
Global_FormatCallbackByteCount   = Global_FormatCallbackBufferPtr+Type_Long_Size ; 22824
Global_AppErrorCode              = Global_FormatCallbackByteCount+Type_Long_Size ; 22828
Global_DosLibrary                = Global_AppErrorCode+Type_Long_Size            ; 22832
Global_MemListHead               = Global_DosLibrary+Type_Long_Size              ; 22836
Global_MemListTail               = Global_MemListHead+Type_Long_Size             ; 22840
Global_FormatBufferPtr2          = Global_MemListTail+8                          ; 22848
Global_FormatByteCount2          = Global_FormatBufferPtr2+Type_Long_Size        ; 22852
Global_ConsoleNameBuffer         = Global_FormatByteCount2+Type_Long_Size        ; 22856
Global_ArgCount                  = Global_ConsoleNameBuffer+58                   ; 22914
Global_ArgvPtr                   = Global_ArgCount+Type_Long_Size                ; 22918
Global_ArgvStorage               = Global_ArgvPtr+Type_Long_Size                 ; 22922

; A4-based globals (WDISP/TEXTDISP/SCRIPT/ESQIFF offsets).
A4_Base = _Global_REF_LONG_FILE_SCRATCH   ; 32768



    include "modules/c-exports.s"
    include "modules/groups/_main/a/a.s"
    include "modules/groups/_main/a/xjump.s"
    include "modules/groups/_main/b/b.s"
    include "modules/groups/_main/b/b_esqcheckcompatiblevideochip.s"
    include "modules/groups/_main/b/bb.s"
    include "modules/groups/_main/b/bb_esq_formatdiskerrormessage.s"
    include "modules/groups/_main/b/bb_p1.s"
    include "modules/groups/_main/b/xjump.s"

    include "modules/groups/a/a/app.s"
    include "modules/groups/a/a/app_esq_handleserialrbfinterrupt.s"
    include "modules/groups/a/a/app_esq_readserialrbfbyte.s"
    include "modules/groups/a/a/app_esq_initaudio1dma.s"
    include "modules/groups/a/a/app_p0.s"
    include "modules/groups/a/a/app_get_bit_3_of_ciab_pra_into_d1.s"
    include "modules/groups/a/a/app_get_bit_4_of_ciab_pra_into_d1.s"
    include "modules/groups/a/a/app_esq_pollctrlinput.s"
    include "modules/groups/a/a/app_p1.s"
    include "modules/groups/a/a/app_esq_capturectrlbit4streambufferbyte.s"
    include "modules/groups/a/a/app_p2.s"
    include "modules/groups/a/a/app2.s"
    include "modules/groups/a/a/app2_esq_storectrlsampleentry.s"
    include "modules/groups/a/a/app2_esq_setcoppereffect_default.s"
    include "modules/groups/a/a/app2_esq_setcoppereffect_custom.s"
    include "modules/groups/a/a/app2_p0.s"
    include "modules/groups/a/a/app2_esq_setcoppereffect_offdisablehighlight.s"
    include "modules/groups/a/a/app2_esq_setcoppereffect_onenablehighlight.s"
    include "modules/groups/a/a/app2_esq_setcoppereffectparams.s"
    include "modules/groups/a/a/app2_p1.s"
    include "modules/groups/a/a/app2_esq_noop.s"
    include "modules/groups/a/a/app2_p2.s"
    include "modules/groups/a/a/app2_esq_movecopperentrytowardstart.s"
    include "modules/groups/a/a/app2_esq_movecopperentrytowardend.s"
    include "modules/groups/a/a/app2_p3.s"
    include "modules/groups/a/a/app2_esq_deccolorstep.s"
    include "modules/groups/a/a/app2_p4.s"
    include "modules/groups/a/a/app2_esq_bumpcolortowardtargets.s"
    include "modules/groups/a/a/app2_p5.s"
    include "modules/groups/a/a/app2_esq_updatemonthdayfromdayofyear.s"
    include "modules/groups/a/a/app2_esq_calcdayofyearfrommonthday.s"
    include "modules/groups/a/a/app2_p6.s"
    include "modules/groups/a/a/app2_esq_gethalfhourslotindex.s"
    include "modules/groups/a/a/app2_esq_clampbannercharrange.s"
    include "modules/groups/a/a/app2_p7.s"
    include "modules/groups/a/a/app2_esq_testbit1based.s"
    include "modules/groups/a/a/app2_esq_setbit1based.s"
    include "modules/groups/a/a/app2_esq_reversebitsin6bytes.s"
    include "modules/groups/a/a/app2_esq_generatexorchecksumbyte.s"
    include "modules/groups/a/a/app2_esq_terminateaftersecondquote.s"
    include "modules/groups/a/a/app2_esq_wildcardmatch.s"
    include "modules/groups/a/a/app2_esq_findsubstringcasefold.s"
    include "modules/groups/a/a/app2_esq_packbitsdecode.s"
    include "modules/groups/a/a/app2_p8.s"
    include "modules/groups/a/a/app2_esq_seedminuteeventthresholds.s"
    include "modules/groups/a/a/app2_p9.s"
    include "modules/groups/a/a/app3.s"
    include "modules/groups/a/a/app3_esqtryromwritetest.s"
    include "modules/groups/a/a/app3b.s"
    include "modules/groups/a/a/bevel.s"
    include "modules/groups/a/a/bevel_bevel_drawbevelframewithtop.s"
    include "modules/groups/a/a/bevel_p1.s"
    include "modules/groups/a/a/bitmap.s"
    include "modules/groups/a/a/brush.s"
    include "modules/groups/a/a/brush_brush_loadcolortextfont.s"
    include "modules/groups/a/a/brush_p0.s"
    include "modules/groups/a/a/brush_brush_freebrushlist.s"
    include "modules/groups/a/a/brush_p1.s"
    include "modules/groups/a/a/brush_brush_findbrushbypredicate.s"
    include "modules/groups/a/a/brush_brush_findtype3brush.s"
    include "modules/groups/a/a/brush_p2.s"
    include "modules/groups/a/a/brush_brush_freebrushresources.s"
    include "modules/groups/a/a/brush_brush_normalizebrushnames.s"
    include "modules/groups/a/a/brush_p3.s"
    include "modules/groups/a/a/brush_brush_appendbrushnode.s"
    include "modules/groups/a/a/brush_brush_popbrushhead.s"
    include "modules/groups/a/a/xjump.s"

    include "modules/groups/a/b/cleanup.s"
    include "modules/groups/a/b/cleanup_cleanup_clearvertbinterruptserver.s"
    include "modules/groups/a/b/cleanup_p0.s"
    include "modules/groups/a/b/cleanup_cleanup_clearrbfinterruptandserial.s"
    include "modules/groups/a/b/cleanup_p1.s"
    include "modules/groups/a/b/xjump.s"

    include "modules/groups/a/c/cleanup2.s"
    include "modules/groups/a/c/cleanup2_cleanup_drawclockformatframe.s"
    include "modules/groups/a/c/cleanup2_p1.s"
    include "modules/groups/a/c/xjump.s"

    include "modules/groups/a/d/cleanup3.s"
    include "modules/groups/a/d/xjump.s"

    include "modules/groups/a/e/cleanup4.s"
    include "modules/groups/a/e/coi.s"
    include "modules/groups/a/e/coi_coi_clearanimobjectstrings.s"
    include "modules/groups/a/e/coi_coi_freesubentrytableentries.s"
    include "modules/groups/a/e/coi_coi_countescape14beforenull.s"
    include "modules/groups/a/e/coi_p1.s"
    include "modules/groups/a/e/coi_coi_allocsubentrytable.s"
    include "modules/groups/a/e/coi_p2.s"
    include "modules/groups/a/e/coi_coi_ensureanimobjectallocated.s"
    include "modules/groups/a/e/coi_p3.s"
    include "modules/groups/a/e/coi_coi_computeentrytimedeltaminutes.s"
    include "modules/groups/a/e/coi_p4.s"
    include "modules/groups/a/e/xjump.s"

    include "modules/groups/a/f/ctasks.s"
    include "modules/groups/a/f/ctasks_ctasks_ifftaskcleanup.s"
    include "modules/groups/a/f/ctasks_ctasks_startifftaskprocess.s"
    include "modules/groups/a/f/ctasks_ctasks_closetaskteardown.s"
    include "modules/groups/a/f/ctasks_ctasks_startclosetaskprocess.s"
    include "modules/groups/a/f/ctasks_p1.s"
    include "modules/groups/a/f/xjump.s"

    include "modules/groups/a/g/diskio.s"
    include "modules/groups/a/g/diskio_diskio_closebufferedfileandflush.s"
    include "modules/groups/a/g/diskio_diskio_writebufferedbytes.s"
    include "modules/groups/a/g/diskio_p1.s"
    include "modules/groups/a/g/diskio_diskio_getfilesizefromhandle.s"
    include "modules/groups/a/g/diskio_p2.s"
    include "modules/groups/a/g/diskio_diskio_consumecstringfromworkbuffer.s"
    include "modules/groups/a/g/diskio_diskio_parselongfromworkbuffer.s"
    include "modules/groups/a/g/diskio_p3.s"
    include "modules/groups/a/g/diskio_diskio_querydiskusagepercentandsetbuffersize.s"
    include "modules/groups/a/g/diskio_p4.s"
    include "modules/groups/a/g/diskio_diskio_forceuirefreshifidle.s"
    include "modules/groups/a/g/diskio_diskio_resetctrlinputstateifidle.s"
    include "modules/groups/a/g/diskio_diskio_probedrivesandassignpaths.s"
    include "modules/groups/a/g/diskio_diskio_drawtransfererrormessageifdiagnostics.s"
    include "modules/groups/a/g/diskio_p5.s"
    include "modules/groups/a/g/diskio1.s"
    include "modules/groups/a/g/xjump.s"

    include "modules/groups/a/h/diskio2.s"
    include "modules/groups/a/h/diskio2_diskio2_writeqtableinifile.s"
    include "modules/groups/a/h/diskio2_diskio2_parseinifilefromdisk.s"
    include "modules/groups/a/h/diskio2_diskio2_writeoinfodatafile.s"
    include "modules/groups/a/h/diskio2_diskio2_loadoinfodatafile.s"
    include "modules/groups/a/h/diskio2_p1.s"
    include "modules/groups/a/h/diskio2_diskio2_copyandsanitizeslotstring.s"
    include "modules/groups/a/h/diskio2_p2.s"
    include "modules/groups/a/h/diskio2_diskio2reloaddatafilesandrebuildindex.s"
    include "modules/groups/a/h/xjump.s"

    include "modules/groups/a/i/displib.s"
    include "modules/groups/a/i/displib_displib_normalizevaluebystep.s"
    include "modules/groups/a/i/displib_p1.s"
    include "modules/groups/a/i/displib_displibresetlinetables.s"
    include "modules/groups/a/i/displibb.s"
    include "modules/groups/a/i/displibb_displib_resettextbufferandlinetables.s"
    include "modules/groups/a/i/displibb_p0.s"
    include "modules/groups/a/i/disptext.s"
    include "modules/groups/a/i/disptext_disptext_finalizelinetable.s"
    include "modules/groups/a/i/disptext_p1.s"
    include "modules/groups/a/i/disptext_disptext_setlayoutparams.s"
    include "modules/groups/a/i/disptext_p2.s"
    include "modules/groups/a/i/disptext_disptext_buildlayoutforsource.s"
    include "modules/groups/a/i/disptext_p3.s"
    include "modules/groups/a/i/disptext_disptextsetcurrentlineindex.s"
    include "modules/groups/a/i/disptextb.s"
    include "modules/groups/a/i/xjump.s"

    include "modules/groups/a/j/disptext2.s"
    include "modules/groups/a/j/disptext2_datetime_buildfromglobals.s"
    include "modules/groups/a/j/disptext2_p1.s"
    include "modules/groups/a/j/disptext2_datetime_updateselectionfield.s"
    include "modules/groups/a/j/disptext2_p2.s"
    include "modules/groups/a/j/dst.s"
    include "modules/groups/a/j/dst_dst_freebannerpair.s"
    include "modules/groups/a/j/dst_p1.s"
    include "modules/groups/a/j/dst_dst_rebuildbannerpair.s"
    include "modules/groups/a/j/dst_p2.s"
    include "modules/groups/a/j/dst2.s"
    include "modules/groups/a/j/dst2_dst_normalizedayofyear.s"
    include "modules/groups/a/j/dst2_p1.s"
    include "modules/groups/a/j/dst2_dst_tickbannercounters.s"
    include "modules/groups/a/j/dst2_dst_addtimeoffset.s"
    include "modules/groups/a/j/dst2_dst_formatbannerdatetime.s"
    include "modules/groups/a/j/dst2_dst_refreshbannerbuffer.s"
    include "modules/groups/a/j/dst2_datetime_isleapyear.s"
    include "modules/groups/a/j/dst2_datetime_adjustmonthindex.s"
    include "modules/groups/a/j/dst2_datetime_normalizemonthrange.s"
    include "modules/groups/a/j/dst2_p2.s"
    include "modules/groups/a/j/xjump.s"

    include "modules/groups/a/k/ed.s"
    include "modules/groups/a/k/ed_ed_entertexteditmode.s"
    include "modules/groups/a/k/ed_ed_capturekeysequence.s"
    include "modules/groups/a/k/ed_ed_findnextcharintable.s"
    include "modules/groups/a/k/ed_ed_handlediagnosticnibbleedit.s"
    include "modules/groups/a/k/ed_ed_handlespecialfunctionsmenu.s"
    include "modules/groups/a/k/ed_ed_saveeverythingtodisk.s"
    include "modules/groups/a/k/ed_ed_saveprevuedatatodisk.s"
    include "modules/groups/a/k/ed_ed_loadtextadsfromdh2.s"
    include "modules/groups/a/k/ed_ed_rebootcomputer.s"
    include "modules/groups/a/k/ed_ed_handleeditattributesmenu.s"
    include "modules/groups/a/k/ed_p1.s"
    include "modules/groups/a/k/ed1.s"
    include "modules/groups/a/k/ed1_ed1_updateescmenuselection.s"
    include "modules/groups/a/k/ed1_ed1_enterescmenu.s"
    include "modules/groups/a/k/ed1_p1.s"
    include "modules/groups/a/k/ed1_ed1_drawdiagnosticsscreen.s"
    include "modules/groups/a/k/ed1_p2.s"
    include "modules/groups/a/k/ed1_ed1clearescmenumode.s"
    include "modules/groups/a/k/ed1b.s"
    include "modules/groups/a/k/ed2.s"
    include "modules/groups/a/k/ed2_ed2_handlediagnosticsmenuactions.s"
    include "modules/groups/a/k/ed2_ed2_handlescrollspeedselection.s"
    include "modules/groups/a/k/xjump.s"
    include "modules/groups/a/k/xjump2.s"

    include "modules/groups/a/l/ed3.s"
    include "modules/groups/a/l/ed3_edisconfirmkey.s"
    include "modules/groups/a/l/ed3b_eddrawescmenubottomhelp.s"
    include "modules/groups/a/l/ed3bb.s"
    include "modules/groups/a/l/ed3bb_ed_initrastport2pens.s"
    include "modules/groups/a/l/ed3bb_ed_drawbottomhelpbarbackground.s"
    include "modules/groups/a/l/ed3bb_p0.s"
    include "modules/groups/a/l/ed3bb_ed_drawhelppanels.s"
    include "modules/groups/a/l/ed3bb_p1.s"
    include "modules/groups/a/l/ed3bb_ed_drawspecialfunctionsmenu.s"
    include "modules/groups/a/l/ed3bb_ed_drawdiagnosticregistervalues.s"
    include "modules/groups/a/l/ed3bb_p2.s"
    include "modules/groups/a/l/ed3bb_ed_redrawcursorchar.s"
    include "modules/groups/a/l/ed3bb_p3.s"
    include "modules/groups/a/l/ed3bb_ed_drawcurrentcolorindicator.s"
    include "modules/groups/a/l/ed3bb_p4.s"
    include "modules/groups/a/l/ed3bb_edincrementadnumber.s"
    include "modules/groups/a/l/ed3bbb_eddecrementadnumber.s"
    include "modules/groups/a/l/ed3bbbb.s"
    include "modules/groups/a/l/xjump.s"

    include "modules/groups/a/m/esq.s"
    include "modules/groups/a/m/xjump.s"

    include "modules/groups/a/n/esqdisp.s"
    include "modules/groups/a/n/esqdisp_esqdisp_allocatehighlightbitmaps.s"
    include "modules/groups/a/n/esqdisp_p0.s"
    include "modules/groups/a/n/esqdisp_esqdisp_queuehighlightdrawmessage.s"
    include "modules/groups/a/n/esqdisp_esqdisp_processgridmessagesifidle.s"
    include "modules/groups/a/n/esqdisp_p1.s"
    include "modules/groups/a/n/esqdisp_esqdisprefreshstatusindicatorsfromcurrentmask.s"
    include "modules/groups/a/n/esqdispb.s"
    include "modules/groups/a/n/esqdispb_esqdisp_computescheduleoffsetforrow.s"
    include "modules/groups/a/n/esqdispb_p0.s"
    include "modules/groups/a/n/esqdispb_esqdisp_promotesecondarylineheadtailifmarked.s"
    include "modules/groups/a/n/esqdispb_p1.s"
    include "modules/groups/a/n/esqfunc.s"
    include "modules/groups/a/n/esqfunc_setup_interrupt_intb_vertb.s"
    include "modules/groups/a/n/esqfunc_setup_interrupt_intb_aud1.s"
    include "modules/groups/a/n/esqfunc_setup_interrupt_intb_rbf.s"
    include "modules/groups/a/n/esqfunc_esqfunc_allocatelinetextbuffers.s"
    include "modules/groups/a/n/esqfunc_esqfunc_freelinetextbuffers.s"
    include "modules/groups/a/n/esqfunc_esqfunc_updatediskwarningandrefreshtick.s"
    include "modules/groups/a/n/esqfunc_esqfunc_waitforclockchangeandserviceui.s"
    include "modules/groups/a/n/esqfunc_p1.s"
    include "modules/groups/a/n/esqfunc_esqfunc_serviceuitickifrunning.s"
    include "modules/groups/a/n/esqfunc_p2.s"
    include "modules/groups/a/n/esqfunc_esqfunc_freeextratitletextpointers.s"
    include "modules/groups/a/n/esqfunc_p3.s"
    include "modules/groups/a/n/esqfunc_esqfunc_drawescmenuversion.s"
    include "modules/groups/a/n/esqfunc_p4.s"
    include "modules/groups/a/n/esqfunc_esqfunc_rebuildpwbrushlistfromtagtable.s"
    include "modules/groups/a/n/esqfunc_p5.s"
    include "modules/groups/a/n/esqiff.s"
    include "modules/groups/a/n/esqiff_esqiff_reloadexternalassetcatalogbuffers.s"
    include "modules/groups/a/n/esqiff_p1.s"
    include "modules/groups/a/n/esqiff_esqiffrestorebasepalettetriples.s"
    include "modules/groups/a/n/esqiffb_esqiffruncopperrisetransition.s"
    include "modules/groups/a/n/esqiffb_esqiffruncopperdroptransition.s"
    include "modules/groups/a/n/esqiffbb.s"
    include "modules/groups/a/n/esqiffbb_esqiff_servicependingcopperpalettemoves.s"
    include "modules/groups/a/n/esqiffbb_p0.s"
    include "modules/groups/a/n/esqiffbb_esqiff_runpendingcopperanimations.s"
    include "modules/groups/a/n/esqiffbb_p1.s"

    include "modules/groups/a/o/esqiff2.s"
    include "modules/groups/a/o/esqiff2_esqiff2_validateasciinumericbyte.s"
    include "modules/groups/a/o/esqiff2_esqiff2_clearlineheadtailbymode.s"
    include "modules/groups/a/o/esqiff2_p1.s"
    include "modules/groups/a/o/esqiff2_esqiff2_padentriestomaxtitlewidth.s"
    include "modules/groups/a/o/esqiff2_p2.s"
    include "modules/groups/a/o/esqiff2_esqiff2_readserialrecordintobuffer.s"
    include "modules/groups/a/o/esqiff2_esqiff2_readserialsizedtextrecord.s"
    include "modules/groups/a/o/esqiff2_p3.s"
    include "modules/groups/a/o/esqiff2_esqiff2_showattentionoverlay.s"
    include "modules/groups/a/o/esqiff2_p4.s"
    include "modules/groups/a/o/esqpars.s"
    include "modules/groups/a/o/esqpars_esqpars_persiststatedataaftercommand.s"
    include "modules/groups/a/o/esqpars_p1.s"

    include "modules/groups/a/p/esqshared.s"
    include "modules/groups/a/p/esqshared_esqshared_initentrydefaults.s"
    include "modules/groups/a/p/esqshared_p1.s"
    include "modules/groups/a/p/esqshared_esqshared_applyprogramtitletextfilters.s"
    include "modules/groups/a/p/esqshared_p2.s"
    include "modules/groups/a/p/esqshared_esqshared_replacemovieratingtoken.s"
    include "modules/groups/a/p/esqshared_esqshared_replacetvratingtoken.s"
    include "modules/groups/a/p/esqshared_p3.s"
    include "modules/groups/a/q/esqshared4.s"
    include "modules/groups/a/q/esqshared4_esqshared4_resetbannercolorsweepstate.s"
    include "modules/groups/a/q/esqshared4_p1.s"
    include "modules/groups/a/q/esqshared4_esqshared4_setbannercolorbaseandlimit.s"
    include "modules/groups/a/q/esqshared4_p2.s"
    include "modules/groups/a/q/esqshared4_esqshared4_clearbannerworkrasterwithones.s"
    include "modules/groups/a/q/esqshared4_p3.s"
    include "modules/groups/a/q/esqshared4_esqshared4_snapshotdisplaybufferbases.s"
    include "modules/groups/a/q/esqshared4_esqshared4_copyplanesfromcontexttosnapshot.s"
    include "modules/groups/a/q/esqshared4_esqshared4_copylongwordblockdbfloop.s"
    include "modules/groups/a/q/esqshared4_esqshared4_computebannerrowblitgeometry.s"
    include "modules/groups/a/q/esqshared4_p4.s"
    include "modules/groups/a/q/esqshared4_esqshared4_decodergbnibbletriplet.s"
    include "modules/groups/a/q/esqshared4_esqshared4_loaddefaultpalettetocopper_noop.s"
    include "modules/groups/a/q/esqshared4_p5.s"

    include "modules/groups/a/r/flib.s"
    include "modules/groups/a/r/xjump.s"

    include "modules/groups/a/s/flib2.s"
    include "modules/groups/a/s/flib2_flib2_loaddigitalnichedefaults.s"
    include "modules/groups/a/s/flib2_flib2_loaddigitalmplexdefaults.s"
    include "modules/groups/a/s/flib2_flib2_loaddigitalppvdefaults.s"
    include "modules/groups/a/s/flib2_flib2_resetandloadlistingtemplates.s"
    include "modules/groups/a/s/gcommand.s"
    include "modules/groups/a/s/gcommand_gcommand_loadmplexfile.s"
    include "modules/groups/a/s/gcommand_p1.s"
    include "modules/groups/a/s/gcommand_gcommand_loadppvtemplate.s"
    include "modules/groups/a/s/gcommand_p2.s"
    include "modules/groups/a/s/xjump.s"

    include "modules/groups/a/t/gcommand2.s"
    include "modules/groups/a/t/gcommand2_gcommand_copygfxtoworkifavailable.s"
    include "modules/groups/a/t/gcommand2_p1.s"
    include "modules/groups/a/t/xjump.s"

    include "modules/groups/a/u/gcommand3.s"
    include "modules/groups/a/u/gcommand3_gcommand_mapkeycodetopreset.s"
    include "modules/groups/a/u/gcommand3_p1.s"
    include "modules/groups/a/u/gcommand3_gcommandenablehighlight.s"
    include "modules/groups/a/u/gcommand3b.s"
    include "modules/groups/a/u/gcommand3b_gcommand_computepresetincrement.s"
    include "modules/groups/a/u/gcommand3b_p1.s"
    include "modules/groups/a/u/gcommand3b_gcommand_loadpresetworkentries.s"
    include "modules/groups/a/u/gcommand3b_p2.s"
    include "modules/groups/a/u/gcommand3b_gcommand_consumebannerqueueentry.s"
    include "modules/groups/a/u/gcommand3b_p3.s"
    include "modules/groups/a/u/gcommand3b_gcommand_resetbannerfadestate.s"
    include "modules/groups/a/u/gcommand3b_p4.s"
    include "modules/groups/a/u/gcommand4.s"
    include "modules/groups/a/u/xjump.s"

    include "modules/groups/a/v/gcommand5.s"
    include "modules/groups/a/v/kybd.s"
    include "modules/groups/a/v/xjump.s"

    include "modules/groups/a/w/ladfunc.s"
    include "modules/groups/a/w/ladfunc_ladfunc_updatehighlightstate.s"
    include "modules/groups/a/w/ladfunc_ladfunc_allocbannerrectentries.s"
    include "modules/groups/a/w/ladfunc_ladfunc_freebannerrectentries.s"
    include "modules/groups/a/w/ladfunc_ladfunc_clearbannerrectentries.s"
    include "modules/groups/a/w/ladfunc_p0.s"
    include "modules/groups/a/w/ladfunc_ladfunc_buildhighlightlinesfromtext.s"
    include "modules/groups/a/w/ladfunc_ladfunc_parsehexdigit.s"
    include "modules/groups/a/w/ladfunc_p1.s"
    include "modules/groups/a/w/ladfunc_ladfunc_composepackedpenbyte.s"
    include "modules/groups/a/w/ladfunc_ladfunc_setpackedpenhighnibble.s"
    include "modules/groups/a/w/ladfunc_ladfunc_setpackedpenlownibble.s"
    include "modules/groups/a/w/ladfunc_p2.s"
    include "modules/groups/a/w/ladfunc_ladfuncgetpackedpenhighnibble.s"
    include "modules/groups/a/w/ladfuncb.s"
    include "modules/groups/a/w/xjump.s"

    include "modules/groups/a/x/ladfunc2.s"
    include "modules/groups/a/x/ladfunc2_ladfunc2_emitescapedstringtoscratch.s"
    include "modules/groups/a/x/ladfunc2_ladfunc2_emitescapedchartoscratch.s"
    include "modules/groups/a/x/ladfunc2_p1.s"
    include "modules/groups/a/x/xjump.s"

    include "modules/groups/a/y/locavail.s"
    include "modules/groups/a/y/locavail_locavail_freenoderecord.s"
    include "modules/groups/a/y/locavail_locavail_freenodeatpointer.s"
    include "modules/groups/a/y/locavail_locavail_resetfilterstatestruct.s"
    include "modules/groups/a/y/locavail_p0.s"
    include "modules/groups/a/y/locavail_locavail_copyfilterstatestructretainrefs.s"
    include "modules/groups/a/y/locavail_p1.s"
    include "modules/groups/a/y/locavail_locavail_resetfiltercursorstate.s"
    include "modules/groups/a/y/locavail_locavail_setfiltermodeandresetstate.s"
    include "modules/groups/a/y/locavail_p2.s"
    include "modules/groups/a/y/locavail_locavail_getnodedurationbyindex.s"
    include "modules/groups/a/y/locavail_p3.s"
    include "modules/groups/a/y/locavail_locavail_getfilterwindowhalfspan.s"
    include "modules/groups/a/y/locavail_p4.s"
    include "modules/groups/a/y/locavail_locavail_syncsecondaryfilterforcurrentgroup.s"
    include "modules/groups/a/y/locavail_locavail_rebuildfilterstatefromcurrentgroup.s"
    include "modules/groups/a/y/xjump.s"

    include "modules/groups/a/z/locavail2.s"
    include "modules/groups/a/z/locavail2_override_intuition_funcs.s"
    include "modules/groups/a/z/locavail2_locavail2_autorequestnoop.s"
    include "modules/groups/a/z/locavail2_locavail2_displayalertdelayandreboot.s"
    include "modules/groups/a/z/locavail2_p0.s"
    include "modules/groups/a/z/xjump.s"

    include "modules/groups/b/a/newgrid.s"
    include "modules/groups/b/a/newgrid_newgrid_shutdowngridresources.s"
    include "modules/groups/b/a/newgrid_newgrid_clearhighlightarea.s"
    include "modules/groups/b/a/newgrid_newgrid_isgridreadyforinput.s"
    include "modules/groups/b/a/newgrid_p1.s"
    include "modules/groups/b/a/newgrid_newgrid_drawdatebanner.s"
    include "modules/groups/b/a/newgrid_p2.s"
    include "modules/groups/b/a/newgrid_newgrid_drawtopborderline.s"
    include "modules/groups/b/a/newgrid_p3.s"
    include "modules/groups/b/a/newgrid_newgrid_drawgridtopbars.s"
    include "modules/groups/b/a/newgrid_p4.s"
    include "modules/groups/b/a/newgrid1.s"
    include "modules/groups/b/a/newgrid1_newgrid_resetrowtable.s"
    include "modules/groups/b/a/newgrid1_p0.s"
    include "modules/groups/b/a/newgrid1_newgrid_apply24hourformatting.s"
    include "modules/groups/b/a/newgrid1_p1.s"
    include "modules/groups/b/a/newgrid1_getgridmodeindex.s"
    include "modules/groups/b/a/newgrid1b.s"
    include "modules/groups/b/a/newgrid1b_newgrid_drawgridheaderrows.s"
    include "modules/groups/b/a/newgrid1b_p1.s"
    include "modules/groups/b/a/newgrid1b_newgrid_selectentrypen.s"
    include "modules/groups/b/a/newgrid1b_p2.s"
    include "modules/groups/b/a/newgrid1b_newgridinitshowtimebuckets.s"
    include "modules/groups/b/a/newgrid1bb.s"
    include "modules/groups/b/a/newgrid2.s"
    include "modules/groups/b/a/newgrid2_newgrid2_dispatchoperationdefault.s"
    include "modules/groups/b/a/newgrid2_p1.s"
    include "modules/groups/b/a/newgrid2_newgrid2_freebuffersifallocated.s"
    include "modules/groups/b/a/newgrid2_p2.s"
    include "modules/groups/b/a/p_type.s"
    include "modules/groups/b/a/p_type_p_type_allocateentry.s"
    include "modules/groups/b/a/p_type_p_type_freeentry.s"
    include "modules/groups/b/a/p_type_p0.s"
    include "modules/groups/b/a/p_type_ptyperesetlistsandloadpromoids.s"
    include "modules/groups/b/a/p_typeb.s"
    include "modules/groups/b/a/p_typeb_p_type_ensuresecondarylist.s"
    include "modules/groups/b/a/p_typeb_p1.s"
    include "modules/groups/b/a/p_typeb_ptypepromotesecondarylist.s"
    include "modules/groups/b/a/p_typebb.s"
    include "modules/groups/b/a/parseini.s"
    include "modules/groups/b/a/parseini_parseini_loadweatherstrings.s"
    include "modules/groups/b/a/parseini_p1.s"
    include "modules/groups/b/a/parseini_parseini_parsecolortable.s"
    include "modules/groups/b/a/parseini_p2.s"
    include "modules/groups/b/a/parseini2.s"
    include "modules/groups/b/a/parseini2_parseini_adjusthoursto24hrformat.s"
    include "modules/groups/b/a/parseini2_p1.s"
    include "modules/groups/b/a/parseini3.s"
    include "modules/groups/b/a/parseini3_parseini_writeerrorlogentry.s"
    include "modules/groups/b/a/parseini3_parseini_computehtcmaxvalues.s"
    include "modules/groups/b/a/parseini3_p0.s"
    include "modules/groups/b/a/parseini3_parseini_updatectrlhdeltamax.s"
    include "modules/groups/b/a/parseini3_p1.s"
    include "modules/groups/b/a/script.s"
    include "modules/groups/b/a/script_script_deallocatebufferarray.s"
    include "modules/groups/b/a/script_p1.s"
    include "modules/groups/b/a/script2.s"
    include "modules/groups/b/a/script2_script_updateserialshadowfromctrlbyte.s"
    include "modules/groups/b/a/script2_script_assertctrlline.s"
    include "modules/groups/b/a/script2_script_assertctrllineifenabled.s"
    include "modules/groups/b/a/script2_script_deassertctrlline.s"
    include "modules/groups/b/a/script2_script_clearctrllineifenabled.s"
    include "modules/groups/b/a/script2_p1.s"
    include "modules/groups/b/a/script2_script_pollhandshakeandapplytimeout.s"
    include "modules/groups/b/a/script2_script_readhandshakebit3flag.s"
    include "modules/groups/b/a/script2_script_readhandshakebit5mask.s"
    include "modules/groups/b/a/script2_script_getctrllineflag.s"
    include "modules/groups/b/a/script2_p2.s"
    include "modules/groups/b/a/script2_scriptwritectrlshadowtoserdat.s"
    include "modules/groups/b/a/script2b.s"
    include "modules/groups/b/a/script3.s"
    include "modules/groups/b/a/script3_script_checkpathexists.s"
    include "modules/groups/b/a/script3_p1.s"
    include "modules/groups/b/a/script3_script_primebannertransitionfromhexcode.s"
    include "modules/groups/b/a/script3_p2.s"
    include "modules/groups/b/a/script3_scriptinitctrlcontext.s"
    include "modules/groups/b/a/script3b2.s"
    include "modules/groups/b/a/script3_scriptclearsearchtextsandchannels.s"
    include "modules/groups/b/a/script3b.s"
    include "modules/groups/b/a/script3b_script_resetctrlcontextandclearstatusline.s"
    include "modules/groups/b/a/script3b_p1.s"
    include "modules/groups/b/a/script4_scriptresetbannerchardefaults.s"
    include "modules/groups/b/a/script4b.s"
    include "modules/groups/b/a/script4b_script_getbannercharorfallback.s"
    include "modules/groups/b/a/script4b_p0.s"
    include "modules/groups/b/a/textdisp.s"
    include "modules/groups/b/a/textdisp_textdisp_getgroupentrycount.s"
    include "modules/groups/b/a/textdisp_textdisp_resetselectionstate.s"
    include "modules/groups/b/a/textdisp_textdisp_setentrytextfields.s"
    include "modules/groups/b/a/textdisp_p1.s"
    include "modules/groups/b/a/textdisp_textdisp_skipcontrolcodes.s"
    include "modules/groups/b/a/textdisp_p2.s"
    include "modules/groups/b/a/textdisp_textdisp_addsourceconfigentry.s"
    include "modules/groups/b/a/textdisp_p3.s"
    include "modules/groups/b/a/textdisp2.s"
    include "modules/groups/b/a/textdisp2_textdisp_resetselectionandrefresh.s"
    include "modules/groups/b/a/textdisp2_p0.s"
    include "modules/groups/b/a/textdisp3.s"
    include "modules/groups/b/a/textdisp3_textdisp_findaliasindexbyname.s"
    include "modules/groups/b/a/textdisp3_p1.s"
    include "modules/groups/b/a/tliba1.s"
    include "modules/groups/b/a/tliba1_tliba1_parsestylecodechar.s"
    include "modules/groups/b/a/tliba1_p1.s"
    include "modules/groups/b/a/tliba2.s"
    include "modules/groups/b/a/tliba2_tliba2_findlastcharinstring.s"
    include "modules/groups/b/a/tliba2_p0.s"
    include "modules/groups/b/a/tliba2_tliba2_resolveentrywindowwithdefaultrange.s"
    include "modules/groups/b/a/tliba2_p1.s"
    include "modules/groups/b/a/tliba2_tliba2_parseentrytimewindow.s"
    include "modules/groups/b/a/tliba2_p2.s"
    include "modules/groups/b/a/tliba3.s"
    include "modules/groups/b/a/tliba3_tliba3_drawverticalscaleticks.s"
    include "modules/groups/b/a/tliba3_p1.s"
    include "modules/groups/b/a/tliba3_tliba3_getviewmodeheight.s"
    include "modules/groups/b/a/tliba3_p2.s"
    include "modules/groups/b/a/tliba3_tliba3_clearviewmoderastport.s"
    include "modules/groups/b/a/tliba3_tliba3_getviewmoderastport.s"
    include "modules/groups/b/a/tliba3_p3.s"
    include "modules/groups/b/a/tliba3_tliba3_selectnextviewmode.s"
    include "modules/groups/b/a/tliba3_p4.s"
    include "modules/groups/b/a/tliba3_tliba3_initruntimeentry.s"
    include "modules/groups/b/a/tliba3_p5.s"
    include "modules/groups/b/a/wdisp.s"

    include "modules/submodules/unknown.s"
    include "modules/submodules/unknown2a.s"
    include "modules/submodules/memory.s"
    include "modules/submodules/unknown2b.s"
    include "modules/submodules/unknown3.s"
    include "modules/submodules/unknown4.s"
    include "modules/submodules/unknown5.s"
    include "modules/submodules/unknown6.s"
    include "modules/submodules/unknown7.s"
    include "modules/submodules/unknown8.s"
    include "modules/submodules/unknown9.s"
    include "modules/submodules/unknown10.s"
    include "modules/submodules/unknown11.s"
    include "modules/submodules/unknown12.s"
    include "modules/submodules/unknown13.s"
    include "modules/submodules/unknown14.s"
    include "modules/submodules/unknown15.s"
    include "modules/submodules/unknown16.s"
    include "modules/submodules/unknown17.s"
    include "modules/submodules/unknown18.s"
    include "modules/submodules/unknown19.s"
    include "modules/submodules/unknown20.s"
    include "modules/submodules/unknown21.s"
    include "modules/submodules/unknown22.s"
    include "modules/submodules/unknown23.s"
    include "modules/submodules/unknown24.s"
    include "modules/submodules/unknown25.s"
    include "modules/submodules/unknown26.s"
    include "modules/submodules/unknown27.s"
    include "modules/submodules/unknown28.s"
    include "modules/submodules/unknown29.s"
    include "modules/submodules/unknown30.s"
    include "modules/submodules/unknown31.s"
    include "modules/submodules/unknown32.s"
    include "modules/submodules/unknown33.s"
    include "modules/submodules/unknown34.s"
    include "modules/submodules/unknown35.s"
    include "modules/submodules/unknown36.s"
    include "modules/submodules/unknown37.s"
    include "modules/submodules/unknown38.s"
    include "modules/submodules/unknown39.s"
    include "modules/submodules/unknown40.s"
    include "modules/submodules/unknown41.s"
    include "modules/submodules/unknown42.s"

;!================
; Data Section
;!================

    SECTION S_1,DATA,CHIP

    include "data/common.s"
    include "data/brush.s"
    include "data/cleanup.s"
    include "data/clock.s"
    include "data/coi.s"
    include "data/ctasks.s"
    include "data/diskio.s"
    include "data/diskio2.s"
    include "data/displib.s"
    include "data/disptext.s"
    include "data/dst.s"
    include "data/ed2.s"
    include "data/esq.s"
    include "data/esqdisp.s"
    include "data/esqfunc.s"
    include "data/esqiff.s"
    include "data/esqpars.s"
    include "data/esqpars2.s"
    include "data/flib.s"
    include "data/gcommand.s"
    include "data/kybd.s"
    include "data/ladfunc.s"
    include "data/locavail.s"
    include "data/newgrid.s"
    include "data/newgrid2.s"
    include "data/p_type.s"
    include "data/parseini.s"
    include "data/script.s"
    include "data/textdisp.s"
    include "data/tliba1.s"
    include "data/wdisp.s"

    END
