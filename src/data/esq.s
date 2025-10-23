; ========== ESQ.c ==========

GLOB_REF_GRAPHICS_LIBRARY:
    DS.L    1
GLOB_REF_INTUITION_LIBRARY:
    DS.L    1
GLOB_REF_UTILITY_LIBRARY:
    DS.L    1
GLOB_REF_BATTCLOCK_RESOURCE:
    DS.L    1

GLOB_STR_PREVUEC_FONT:
    NStr    "PrevueC.font"          ; 14 bytes
GLOB_STRUCT_TEXTATTR_PREVUEC_FONT:
    DC.L    GLOB_STR_PREVUEC_FONT
    DC.W    25      ; Size 25 font
    DC.B    $40
    DC.B    $20

GLOB_STR_H26F_FONT:
    NStr    "h26f.font"             ; 10 bytes
GLOB_STRUCT_TEXTATTR_H26F_FONT:
    DC.L    GLOB_STR_H26F_FONT
    DC.W    26      ; Size 26 font
    DC.B    0       ; Style: 0
    DC.B    0       ; Flags: 0

GLOB_STR_TOPAZ_FONT:
    NStr    "topaz.font"            ; 12 bytes
GLOB_STRUCT_TEXTATTR_TOPAZ_FONT:
    DC.L    GLOB_STR_TOPAZ_FONT
    DC.W    8      ; Size 8 font
    DC.B    0      ; Style: 0
    DC.B    1      ; Flags: 1

GLOB_STR_PREVUE_FONT:
    NStr    "Prevue.font"           ; 12 bytes
GLOB_STRUCT_TEXTATTR_PREVUE_FONT:
    DC.L    GLOB_STR_PREVUE_FONT
    DC.W    13      ; Size 13 font
    DC.B    $40     ;
    DC.B    $20     ;

GLOB_HANDLE_PREVUE_FONT:
    DS.L    1
GLOB_REF_DISKFONT_LIBRARY:
    DS.L    1
GLOB_REF_DOS_LIBRARY:
    DS.L    1
LAB_1DC5:
    DS.L    1
LAB_1DC6:
    DS.L    1
LAB_1DC7:
    DS.L    1
LAB_1DC7_Length = 1
LAB_1DC8:
    DC.B    "B"
LAB_1DC8_Length = 1
LAB_1DC9:
    DC.B    "E"
LAB_1DC9_Length = 1
GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED:
    DC.B    "3"
GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length    = 1
LAB_1DCB:
    DC.B    "36"
LAB_1DCB_Length = 2
LAB_1DCD:
    DC.B    "6"
LAB_1DCD_Length = 1
LAB_1DCE:
    DC.B    "N"
LAB_1DCF:
    DC.B    1
LAB_1DD0:
    DC.B    1
LAB_1DD1:
    DC.B    "6"
LAB_1DD2:
    DC.B    "N"
LAB_1DD3:
    DC.B    "Y"
    DC.B    "N"
LAB_1DD4:
    DC.B    "N"
LAB_1DD5:
    DC.B    "N"
    DC.B    "YA"
LAB_1DD6:
    DC.B    "N"
LAB_1DD7:
    DC.B    "N"
LAB_1DD8:
    DS.B    1
LAB_1DD8_RASTPORT:
    DS.W    1
LAB_1DD9:
    DS.L    1
LAB_1DDA:
    DS.W    1
LAB_1DDB:
    DS.L    1
LAB_1DDC:
    DS.L    1
GLOB_REF_STR_CLOCK_FORMAT:
    DS.L    1
LAB_1DDE:
    DS.W    1
LAB_1DDF:
    DS.W    1
LAB_1DE0:
    DS.B    1
LAB_1DE1:
    DS.B    1
LAB_1DE2:
    DC.B    $03
LAB_1DE3:
    ; Could be a bunch of carriage returns in a row...
    DC.B    $0c
    DC.L    $0c0c0000,$000c0c00,$05010201,$060a0505
    DC.L    $05000003,$00080007,$00070007,$07000c00
    DC.L    $0c000c00,$0c0c0c00,$0000000c
LAB_1DE4:
    DS.W    1
LAB_1DE5:
    DS.W    1
GLOB_HANDLE_PREVUEC_FONT:
    DS.L    1
GLOB_HANDLE_H26F_FONT:
    DS.L    1
GLOB_HANDLE_TOPAZ_FONT:
    DS.L    1
    DS.L    2
    DS.W    1
LAB_1DE9:
    DS.W    1
LAB_1DE9_B:
    DS.W    1
LAB_1DEA:
    DS.L    1
LAB_1DEB:
    NStr    "A"
LAB_1DEC:
    DS.L    1
GLOB_LONG_ROM_VERSION_CHECK:
    DC.L    1
LAB_1DEE:
    DS.B    1
LAB_1DEF:
    DS.B    1
LAB_1DF0:
    DS.W    1
    DS.B    1
LAB_1DF1:
    DS.B    1
LAB_1DF2:
    DS.W    1
LAB_1DF3:
    DS.W    1
LAB_1DF4:
    DS.W    1
GLOB_WORD_SELECT_CODE_IS_RAVESC:
    DS.W    1
LAB_1DF6:
    DS.W    1
HAS_REQUESTED_FAST_MEMORY:
    DS.W    1
IS_COMPATIBLE_VIDEO_CHIP:
    DC.L    $00000001
GLOB_STR_RAVESC:
    NStr    "RAVESC"
GLOB_STR_COPY_NIL_ASSIGN_RAM:
    NStr    "copy >NIL: C:assign ram:"
GLOB_STR_GRAPHICS_LIBRARY:
    NStr    "graphics.library"
GLOB_STR_DISKFONT_LIBRARY:
    NStr    "diskfont.library"
GLOB_STR_DOS_LIBRARY:
    NStr    "dos.library"
GLOB_STR_INTUITION_LIBRARY:
    NStr    "intuition.library"
GLOB_STR_UTILITY_LIBRARY:
    NStr    "utility.library"
GLOB_STR_BATTCLOCK_RESOURCE:
    NStr    "battclock.resource"
GLOB_STR_ESQ_C_1:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_2:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_3:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_4:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_5:
    NStr    "ESQ.c"
GLOB_STR_CART:
    NStr    "CART"
GLOB_STR_ESQ_C_6:
    NStr    "ESQ.c"
GLOB_STR_SERIAL_READ:
    NStr    "Serial.Read"
GLOB_STR_SERIAL_DEVICE:
    NStr    "serial.device"
GLOB_STR_ESQ_C_7:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_8:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_9:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_10:
    NStr    "ESQ.c"
GLOB_STR_ESQ_C_11:
    NStr    "ESQ.c"
LAB_1E0F:
    NStr    "no df1 present"
GLOB_STR_GUIDE_START_VERSION_AND_BUILD:
    NStr    "Ver %s.%ld Build %ld %s"
GLOB_STR_MAJOR_MINOR_VERSION:
    NStr    "9.0"   ; Major/minor version string
LAB_1E12:
    NStr    "                                       "
GLOB_STR_DF0_GRADIENT_INI_2:
    NStr    "df0:Gradient.ini"
LAB_1E14:
    NStr    "System Initializing"
LAB_1E15:
    NStr    "Please Stand By..."
LAB_1E16:
    NStr    "ATTENTION SYSTEM ENGINEER!"
LAB_1E17:
    NStr    "Report Error Code ER011 to TV Guide Technical Services."
LAB_1E18:
    NStr    "Report Error Code ER012 to TV Guide Technical Services."
GLOB_STR_DF0_DEFAULT_INI_1:
    NStr    "df0:default.ini"
GLOB_STR_DF0_BRUSH_INI_1:
    NStr    "df0:brush.ini"
LAB_1E1B:
    NStr    "DT"
LAB_1E1C:
    NStr    "DITHER"
GLOB_STR_DF0_BANNER_INI_1:
    NStr    "df0:banner.ini"
LAB_1E1E:
    NStr    "GRANADA"
GLOB_LONG_BUILD_NUMBER:
    DC.L    $00000015   ; 21
GLOB_STR_BUILD_ID:
    NStr    "JGT"   ; build id string
GLOB_PTR_STR_BUILD_ID:
    DC.L    GLOB_STR_BUILD_ID
LAB_1E22:
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
LAB_1E23:
    DC.L    $00000082
LAB_1E24:
    DS.W    1
LAB_1E25:
    DS.L    19
    DC.W    $0180
LAB_1E26:
    DC.L    $00030182
LAB_1E27:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
LAB_1E28:
    DC.L    $00030190,$00030192,$00030194,$00030196
    DC.L    $00030198,$0003019a,$0003019c,$0003019e
LAB_1E29:
    DC.L    $000301a0,$000301a2,$000301a4,$000301a6
    DC.L    $000301a8,$000301aa,$000301ac,$000301ae
    DC.L    $000301b0,$000301b2,$000301b4,$000301b6
    DC.L    $000301b8,$000301ba,$000301bc,$000301be
LAB_1E2A:
    DC.W    $0003
LAB_1E2B:
    DC.L    $00d9fffe,$00920030,$009400d8,$008e1769
    DC.L    $0090ffc5,$01080058,$010a0058,$01009306
    DC.L    $01020000,$01820003
    DC.W    $00e0
LAB_1E2C:
    DC.L    $000000e2
LAB_1E2D:
    DC.L    $00000180
LAB_1E2E:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
LAB_1E2F:
    DC.L    $00dffffe
    DC.W    $00e0
LAB_1E30:
    DC.L    $000000e2
LAB_1E31:
    DC.L    $000000e4
LAB_1E32:
    DC.L    $000000e6
LAB_1E33:
    DC.L    $000000e8
LAB_1E34:
    DC.L    $000000ea
LAB_1E35:
    DC.L    $00000182
LAB_1E36:
    DC.L    $0aaa0100,$b30680d5,$80fe0188,$0100018a
    DC.L    $0000018c,$0000018e,$000180d5,$80fe0188
    DC.L    $0200018a,$0011018c,$0111018e,$000280d5
    DC.L    $80fe0188,$0300018a,$0022018c,$0222018e
    DC.L    $000380d5,$80fe0188,$0400018a,$0033018c
    DC.L    $0333018e,$000480d5,$80fe0188,$0500018a
    DC.L    $0044018c,$0444018e,$000580d5,$80fe0188
    DC.L    $0600018a,$0055018c,$0555018e,$000680d5
    DC.L    $80fe0188,$0700018a,$0066018c,$0666018e
    DC.L    $000780d5,$80fe0188,$0800018a,$0077018c
    DC.L    $0777018e,$000880d5,$80fe0188,$0900018a
    DC.L    $0088018c,$0888018e,$000980d5,$80fe0188
    DC.L    $0a00018a,$0099018c,$0999018e,$000a00d5
    DC.L    $80fe0188,$0b00018a,$00aa018c,$0aaa018e
    DC.L    $000b80d5,$80fe0188,$0c00018a,$00bb018c
    DC.L    $0bbb018e,$000c80d5,$80fe0188,$0d00018a
    DC.L    $00cc018c,$0ccc018e,$000d80d5,$80fe0188
    DC.L    $0e00018a,$00dd018c,$0ddd018e,$000e80d5
    DC.L    $80fe0188,$0f00018a,$00ee018c,$0eee018e
    DC.L    $000f80d5,$80fe0188,$0512018a,$016a018c
    DC.L    $0555018e
    DC.W    $0003
LAB_1E37:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
LAB_1E38:
    DC.L    $000000e2
LAB_1E39:
    DS.W    1
LAB_1E3A:
    DC.L    $00dffffe
    DC.W    $00e0
LAB_1E3B:
    DC.L    $000000e2
LAB_1E3C:
    DC.L    $000000e4
LAB_1E3D:
    DC.L    $000000e6
LAB_1E3E:
    DC.L    $000000e8
LAB_1E3F:
    DC.L    $000000ea
LAB_1E40:
    DC.L    $00000100,$b3060084
LAB_1E41:
    DC.L    $00000086
LAB_1E42:
    DC.L    $00000182
LAB_1E43:
    DC.L    $0aaa018e
LAB_1E44:
    DC.W    $0003
LAB_1E45:
    DS.B    1
LAB_1E46:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
LAB_1E47:
    DC.L    $000000e2
LAB_1E48:
    DC.L    $000000e4
LAB_1E49:
    DC.L    $000000e6
LAB_1E4A:
    DC.L    $000000e8
LAB_1E4B:
    DC.L    $000000ea
LAB_1E4C:
    DS.W    1
LAB_1E4D:
    DC.L    $009c8010
LAB_1E4E:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
LAB_1E4F:
    DC.L    $000000e2
LAB_1E50:
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
LAB_1E51:
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
LAB_1E52:
    DC.L    $00000082
LAB_1E53:
    DS.W    1
LAB_1E54:
    DS.L    19
    DC.W    $0180
LAB_1E55:
    DC.L    $00030182
LAB_1E56:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
LAB_1E57:
    DC.W    $0003
LAB_1E58:
    DC.L    $00d9fffe,$00920030,$009400d8,$008e1769
    DC.L    $0090ffc5,$01080058,$010a0058,$01009306
    DC.L    $01020000,$01820003
    DC.W    $00e0
LAB_1E59:
    DC.L    $000000e2
LAB_1E5A:
    DC.L    $00000180
LAB_1E5B:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
LAB_1E5C:
    DC.L    $00dffffe
    DC.W    $00e0
LAB_1E5D:
    DC.L    $000000e2
LAB_1E5E:
    DC.L    $000000e4
LAB_1E5F:
    DC.L    $000000e6
LAB_1E60:
    DC.L    $000000e8
LAB_1E61:
    DC.L    $000000ea
LAB_1E62:
    DC.L    $00000182
LAB_1E63:
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
LAB_1E64:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
LAB_1E65:
    DC.L    $000000e2
LAB_1E66:
    DS.W    1
LAB_1E67:
    DC.L    $00dffffe
    DC.W    $00e0
LAB_1E68:
    DC.L    $000000e2
LAB_1E69:
    DC.L    $000000e4
LAB_1E6A:
    DC.L    $000000e6
LAB_1E6B:
    DC.L    $000000e8
LAB_1E6C:
    DC.L    $000000ea
LAB_1E6D:
    DC.L    $00000100,$b3060084
LAB_1E6E:
    DC.L    $00000086
LAB_1E6F:
    DC.L    $00000182
LAB_1E70:
    DC.L    $0aaa018e
LAB_1E71:
    DC.W    $0003
LAB_1E72:
    DS.B    1
LAB_1E73:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
LAB_1E74:
    DC.L    $000000e2
LAB_1E75:
    DC.L    $000000e4
LAB_1E76:
    DC.L    $000000e6
LAB_1E77:
    DC.L    $000000e8
LAB_1E78:
    DC.L    $000000ea
LAB_1E79:
    DS.W    1
LAB_1E7A:
    DC.L    $009c8010
LAB_1E7B:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
LAB_1E7C:
    DC.L    $000000e2
LAB_1E7D:
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
GLOB_PTR_AUD1_DMA:
    DC.L    76
