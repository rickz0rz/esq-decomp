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
A4_Base = Global_REF_LONG_FILE_SCRATCH   ; 32768



    include "modules/c-exports.s"
    include "modules/groups/_main/a/a.s"
    include "modules/groups/_main/a/xjump.s"
    include "modules/groups/_main/b/b.s"
    include "modules/groups/_main/b/b_esqcheckcompatiblevideochip.s"
    include "modules/groups/_main/b/bb.s"
    include "modules/groups/_main/b/xjump.s"

    include "modules/groups/a/a/app.s"
    include "modules/groups/a/a/app2.s"
    include "modules/groups/a/a/app3.s"
    include "modules/groups/a/a/bevel.s"
    include "modules/groups/a/a/bitmap.s"
    include "modules/groups/a/a/brush.s"
    include "modules/groups/a/a/xjump.s"

    include "modules/groups/a/b/cleanup.s"
    include "modules/groups/a/b/xjump.s"

    include "modules/groups/a/c/cleanup2.s"
    include "modules/groups/a/c/xjump.s"

    include "modules/groups/a/d/cleanup3.s"
    include "modules/groups/a/d/xjump.s"

    include "modules/groups/a/e/cleanup4.s"
    include "modules/groups/a/e/coi.s"
    include "modules/groups/a/e/xjump.s"

    include "modules/groups/a/f/ctasks.s"
    include "modules/groups/a/f/xjump.s"

    include "modules/groups/a/g/diskio.s"
    include "modules/groups/a/g/diskio1.s"
    include "modules/groups/a/g/xjump.s"

    include "modules/groups/a/h/diskio2.s"
    include "modules/groups/a/h/diskio2_diskio2reloaddatafilesandrebuildindex.s"
    include "modules/groups/a/h/xjump.s"

    include "modules/groups/a/i/displib.s"
    include "modules/groups/a/i/displib_displibresetlinetables.s"
    include "modules/groups/a/i/displibb.s"
    include "modules/groups/a/i/disptext.s"
    include "modules/groups/a/i/disptext_disptextsetcurrentlineindex.s"
    include "modules/groups/a/i/disptextb.s"
    include "modules/groups/a/i/xjump.s"

    include "modules/groups/a/j/disptext2.s"
    include "modules/groups/a/j/dst.s"
    include "modules/groups/a/j/dst2.s"
    include "modules/groups/a/j/xjump.s"

    include "modules/groups/a/k/ed.s"
    include "modules/groups/a/k/ed1.s"
    include "modules/groups/a/k/ed1_ed1clearescmenumode.s"
    include "modules/groups/a/k/ed1b.s"
    include "modules/groups/a/k/ed2.s"
    include "modules/groups/a/k/xjump.s"
    include "modules/groups/a/k/xjump2.s"

    include "modules/groups/a/l/ed3.s"
    include "modules/groups/a/l/ed3_edisconfirmkey.s"
    include "modules/groups/a/l/ed3b_eddrawescmenubottomhelp.s"
    include "modules/groups/a/l/ed3bb.s"
    include "modules/groups/a/l/ed3bb_edincrementadnumber.s"
    include "modules/groups/a/l/ed3bbb_eddecrementadnumber.s"
    include "modules/groups/a/l/ed3bbbb.s"
    include "modules/groups/a/l/xjump.s"

    include "modules/groups/a/m/esq.s"
    include "modules/groups/a/m/xjump.s"

    include "modules/groups/a/n/esqdisp.s"
    include "modules/groups/a/n/esqdisp_esqdisprefreshstatusindicatorsfromcurrentmask.s"
    include "modules/groups/a/n/esqdispb.s"
    include "modules/groups/a/n/esqfunc.s"
    include "modules/groups/a/n/esqiff.s"
    include "modules/groups/a/n/esqiff_esqiffrestorebasepalettetriples.s"
    include "modules/groups/a/n/esqiffb_esqiffruncopperrisetransition.s"
    include "modules/groups/a/n/esqiffb_esqiffruncopperdroptransition.s"
    include "modules/groups/a/n/esqiffbb.s"

    include "modules/groups/a/o/esqiff2.s"
    include "modules/groups/a/o/esqpars.s"

    include "modules/groups/a/p/esqshared.s"
    include "modules/groups/a/q/esqshared4.s"

    include "modules/groups/a/r/flib.s"
    include "modules/groups/a/r/xjump.s"

    include "modules/groups/a/s/flib2.s"
    include "modules/groups/a/s/gcommand.s"
    include "modules/groups/a/s/xjump.s"

    include "modules/groups/a/t/gcommand2.s"
    include "modules/groups/a/t/xjump.s"

    include "modules/groups/a/u/gcommand3.s"
    include "modules/groups/a/u/gcommand3_gcommandenablehighlight.s"
    include "modules/groups/a/u/gcommand3b.s"
    include "modules/groups/a/u/gcommand4.s"
    include "modules/groups/a/u/xjump.s"

    include "modules/groups/a/v/gcommand5.s"
    include "modules/groups/a/v/kybd.s"
    include "modules/groups/a/v/xjump.s"

    include "modules/groups/a/w/ladfunc.s"
    include "modules/groups/a/w/ladfunc_ladfuncgetpackedpenhighnibble.s"
    include "modules/groups/a/w/ladfuncb.s"
    include "modules/groups/a/w/xjump.s"

    include "modules/groups/a/x/ladfunc2.s"
    include "modules/groups/a/x/xjump.s"

    include "modules/groups/a/y/locavail.s"
    include "modules/groups/a/y/xjump.s"

    include "modules/groups/a/z/locavail2.s"
    include "modules/groups/a/z/xjump.s"

    include "modules/groups/b/a/newgrid.s"
    include "modules/groups/b/a/newgrid1.s"
    include "modules/groups/b/a/newgrid1_getgridmodeindex.s"
    include "modules/groups/b/a/newgrid1b.s"
    include "modules/groups/b/a/newgrid1b_newgridinitshowtimebuckets.s"
    include "modules/groups/b/a/newgrid1bb.s"
    include "modules/groups/b/a/newgrid2.s"
    include "modules/groups/b/a/p_type.s"
    include "modules/groups/b/a/p_type_ptyperesetlistsandloadpromoids.s"
    include "modules/groups/b/a/p_typeb.s"
    include "modules/groups/b/a/p_typeb_ptypepromotesecondarylist.s"
    include "modules/groups/b/a/p_typebb.s"
    include "modules/groups/b/a/parseini.s"
    include "modules/groups/b/a/parseini2.s"
    include "modules/groups/b/a/parseini3.s"
    include "modules/groups/b/a/script.s"
    include "modules/groups/b/a/script2.s"
    include "modules/groups/b/a/script2_scriptwritectrlshadowtoserdat.s"
    include "modules/groups/b/a/script2b.s"
    include "modules/groups/b/a/script3.s"
    include "modules/groups/b/a/script3_scriptinitctrlcontext.s"
    include "modules/groups/b/a/script3b2.s"
    include "modules/groups/b/a/script3_scriptclearsearchtextsandchannels.s"
    include "modules/groups/b/a/script3b.s"
    include "modules/groups/b/a/script4_scriptresetbannerchardefaults.s"
    include "modules/groups/b/a/script4b.s"
    include "modules/groups/b/a/textdisp.s"
    include "modules/groups/b/a/textdisp2.s"
    include "modules/groups/b/a/textdisp3.s"
    include "modules/groups/b/a/tliba1.s"
    include "modules/groups/b/a/tliba2.s"
    include "modules/groups/b/a/tliba3.s"
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
