; ==========================================
; ESQ-3.asm disassembly + annotation
; ==========================================

    include "lvo-offsets.s"
    include "hardware-addresses.s"
    include "structs.s"
    include "macros.s"
    include "string-macros.s"
    include "text-formatting.s"
    include "interrupts/constants.s"

includeCustomAriAssembly = 0

    SECTION S_0,CODE

; Some values of importance
DesiredMemoryAvailability   = $00800000 ; 8388608 bytes/8 MiBytes

savedStackPointer   = -600
savedMsg            = -604
savedExecBase       = -608
Global_ScratchPtr_592            = -592
Global_WBStartupWindowPtr        = -596
Global_SavedDirLock              = -612
Global_CommandLineSize           = -660
Global_WBStartupCmdBuffer        = -664
Global_UNKNOWN36_MessagePtr      = Global_ScratchPtr_592
Global_UNKNOWN36_RequesterOutPtr = -712
Global_UNKNOWN36_RequesterText0  = -724
Global_UNKNOWN36_RequesterText1  = -704
Global_UNKNOWN36_RequesterText2  = -684
Global_ExitHookPtr               = -620
Global_SignalCallbackPtr         = -616
Global_DosIoErr                  = -640
Global_A4_748_Ptr                = -748
Global_CharClassTable            = -1007
Global_AllocBlockSize            = -1012
Global_DefaultHandleFlags        = -1016
Global_A4_1024_State0            = -1024
Global_A4_1028_State1            = -1028
Global_A4_1058_State2            = -1058
Global_A4_1062_State3            = -1062
Global_A4_1074_Counter           = -1074
Global_A4_1082_Ptr               = -1082
Global_A4_1086_Buffer            = -1086
Global_A4_1092_State4            = -1092
Global_A4_1096_State5            = -1096
Global_A4_1120_Base              = -1120
Global_HandleTableFlags          = -1124
Global_AllocBytesTotal           = -1128
Global_AllocListHead             = -1132
Global_A4_1144_Ptr               = -1144
Global_HandleTableCount          = -1148
Global_GraphicsLibraryBase_A4    = -22440
Global_HandleTableBase           = 22492
Global_HandleEntry0_Flags        = Global_HandleTableBase+Struct_HandleEntry__Flags
Global_HandleEntry0_Ptr          = Global_HandleTableBase+Struct_HandleEntry__Ptr
Global_HandleEntry1_Flags        = Global_HandleTableBase+Struct_HandleEntry_Size+Struct_HandleEntry__Flags
Global_HandleEntry1_Ptr          = Global_HandleTableBase+Struct_HandleEntry_Size+Struct_HandleEntry__Ptr
Global_HandleEntry2_Flags        = Global_HandleEntry1_Flags+Struct_HandleEntry_Size
Global_HandleEntry2_Ptr          = Global_HandleEntry1_Ptr+Struct_HandleEntry_Size
Global_PrintfBufferPtr           = 22812
Global_PrintfByteCount           = 22816
Global_FormatCallbackBufferPtr   = 22820
Global_FormatCallbackByteCount   = 22824
Global_AppErrorCode              = 22828
Global_DosLibrary                = 22832
Global_MemListHead               = 22836
Global_MemListTail               = 22840
Global_FormatBufferPtr2          = 22848
Global_FormatByteCount2          = 22852
Global_ConsoleNameBuffer         = 22856
Global_ArgCount                  = 22914
Global_ArgvPtr                   = 22918
Global_ArgvStorage               = 22922

    include "modules/groups/_main/a/a.s"
    include "modules/groups/_main/a/xjump.s"
    include "modules/groups/_main/b/b.s"
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
    include "modules/groups/a/h/xjump.s"

    include "modules/groups/a/i/displib.s"
    include "modules/groups/a/i/disptext.s"
    include "modules/groups/a/i/xjump.s"

    include "modules/groups/a/j/disptext2.s"
    include "modules/groups/a/j/dst.s"
    include "modules/groups/a/j/dst2.s"
    include "modules/groups/a/j/xjump.s"

    include "modules/groups/a/k/ed.s"
    include "modules/groups/a/k/ed1.s"
    include "modules/groups/a/k/ed2.s"
    include "modules/groups/a/k/xjump.s"
    include "modules/groups/a/k/xjump2.s"

    include "modules/groups/a/l/ed3.s"
    include "modules/groups/a/l/xjump.s"

    include "modules/groups/a/m/esq.s"
    include "modules/groups/a/m/xjump.s"

    include "modules/groups/a/n/esqdisp.s"
    include "modules/groups/a/n/esqfunc.s"
    include "modules/groups/a/n/esqiff.s"

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
    include "modules/groups/a/u/gcommand4.s"
    include "modules/groups/a/u/xjump.s"

    include "modules/groups/a/v/gcommand5.s"
    include "modules/groups/a/v/kybd.s"
    include "modules/groups/a/v/xjump.s"

    include "modules/groups/a/w/ladfunc.s"
    include "modules/groups/a/w/xjump.s"

    include "modules/groups/a/x/ladfunc2.s"
    include "modules/groups/a/x/xjump.s"

    include "modules/groups/a/y/locavail.s"
    include "modules/groups/a/y/xjump.s"

    include "modules/groups/a/z/locavail2.s"
    include "modules/groups/a/z/xjump.s"

    include "modules/groups/b/a/newgrid.s"
    include "modules/groups/b/a/newgrid1.s"
    include "modules/groups/b/a/newgrid2.s"
    include "modules/groups/b/a/p_type.s"
    include "modules/groups/b/a/parseini.s"
    include "modules/groups/b/a/parseini2.s"
    include "modules/groups/b/a/parseini3.s"
    include "modules/groups/b/a/script.s"
    include "modules/groups/b/a/script2.s"
    include "modules/groups/b/a/script3.s"
    include "modules/groups/b/a/script4.s"
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
