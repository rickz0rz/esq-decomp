; ========== DISKIO.c ==========

Global_STR_DISKIO_C_1:
    NStr    "DISKIO.c"
Global_STR_DISKIO_C_2:
    NStr    "DISKIO.c"
Global_STR_PERCENT_LD:
    NStr    "%ld"
Global_STR_DISKIO_C_3:
    NStr    "DISKIO.c"
Global_STR_DISKIO_C_4:
    NStr    "DISKIO.c"
Global_STR_DISKIO_C_5:
    NStr    "DISKIO.c"
Global_STR_DISKIO_C_6:
    NStr    "DISKIO.c"
Global_STR_DISKIO_C_7:
    NStr    "DISKIO.c"
Global_STR_DISKIO_C_8:
    NStr    "DISKIO.c"
DISKIO_Drive0Dh2AssignDoneFlag:
    DC.L    1
DISKIO_Drive1GfxAssignDoneFlag:
    DC.L    1
;------------------------------------------------------------------------------
; SYM: DISKIO_STR_TRACKDISK_DEVICE   (trackdisk.device)
; TYPE: cstring
; PURPOSE: Device name used when probing floppy units via OpenDevice.
; USED BY: DISKIO_ProbeDrivesAndAssignPaths
; NOTES: Companion assign/mount command strings follow in this block.
;------------------------------------------------------------------------------
DISKIO_STR_TRACKDISK_DEVICE:
    NStr    "trackdisk.device"
DISKIO_CMD_ASSIGN_FONTS_DH2:
    NStr    "ram:assign >nil: FONTS: DH2:FONTS"
DISKIO_CMD_ASSIGN_ENV_DH2:
    NStr    "ram:assign >nil: ENV: DH2:"
DISKIO_CMD_ASSIGN_SYS_DH2:
    NStr    "ram:assign >nil: SYS: DH2:"
DISKIO_CMD_ASSIGN_S_DH2:
    NStr    "ram:assign >nil: S: DH2:S"
DISKIO_CMD_ASSIGN_C_DH2:
    NStr    "ram:assign >nil: C: DH2:C"
DISKIO_CMD_ASSIGN_L_DH2:
    NStr    "ram:assign >nil: L: DH2:L"
DISKIO_CMD_ASSIGN_LIBS_DH2:
    NStr    "ram:assign >nil: LIBS: DH2:LIBS"
DISKIO_CMD_ASSIGN_DEVS_DH2:
    NStr    "ram:assign >nil: DEVS: DH2:DEVS"
DISKIO_PATH_DF1_G_ADS:
    NStr    "df1:g.ads"
DISKIO_CMD_ASSIGN_GFX_DF1:
    NStr    "ram:assign >nil: gfx: DF1:"
DISKIO_CMD_ASSIGN_GFX_PC1:
    NStr    "ram:assign >nil: gfx: PC1:"
DISKIO_TAG_NRLS:
    NStr    "NRLS"
DISKIO_TAG_LRBN:
    NStr    "LRBN"
DISKIO_TAG_MSN:
    NStr    "MSN"
DISKIO_Pc1MountAssignFlag:
    DS.W    1
DISKIO_CMD_MOUNT_PC1:
    NStr    "Mount PC1:"
DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT:
    NStr    "Assign GFX: PC1:"
Global_STR_DF0_CONFIG_DAT_1:
    NStr    "df0:config.dat"
Global_STR_DEFAULT_CONFIG_FORMATTED:
    DC.B    "%01ld%01lc%01ld%01ld%02ld%02ld%01lc%01lc%01lc%01lc%01ld%01ld%"
    DC.B    "01lc%01lc%01lc%01lc%01lc%01lc%01lc%02ld%02ld%01lc%01lc%01lc%0"
    DC.B    "2ld%02ld%02ld%03ld%01ld%2.2s%01lc%01lc%01lc%01c%01c%01d%01c%0"
    NStr2   "1c%01c%01c%01c%01c",TextLineFeed
Global_STR_DF0_CONFIG_DAT_2:
    NStr    "df0:config.dat"
Global_STR_DISKIO_C_9:
    NStr    "DISKIO.c"
DISKIO_FMT_CHANNEL_LINE_UP_PCT_LD:
    NStr2   "Channel Line Up # %ld",TextLineFeed
DISKIO_FMT_ETID_PCT_LD_PCT_02LX:
    NStr2   "ETID = %ld ($%02lx)",TextLineFeed
DISKIO_FMT_CHAN_NUM_PCT_S:
    NStr2   "chan_num = '%s'",TextLineFeed
DISKIO_FMT_SOURCE_PCT_S:
    NStr2   "source = '%s'",TextLineFeed
DISKIO_FMT_CALL_LET_PCT_S:
    NStr2   "call_let = '%s'",TextLineFeed
DISKIO_FMT_ATTR_PCT_02LX:
    NStr    "attr = $%02lx ("
DISKIO_STR_NONE_CompactSourceAttrFlags:
    NStr    " NONE"
DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags:
    NStr    " HILITE_SRC"
DISKIO_STR_SUM_SRC_CompactSourceAttrFlags:
    NStr    " SUM_SRC"
DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags:
    NStr    " VIDEO_TAG_DISABLE"
DISKIO_STR_PPV_SRC_CompactSourceAttrFlags:
    NStr    " PPV_SRC"
DISKIO_STR_DITTO_CompactSourceAttrFlags:
    NStr    " DITTO"
DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags:
    NStr    " ALTHILITESRC"
DISKIO_STR_0X80:
    NStr    " 0x80"
DISKIO_STR_AttrFlagsCloseParenNewline_A:
    NStr2   " )",TextLineFeed
DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX:
    NStr    "tslt_mask = ($%02lx $%02lx $%02lx $%02lx $%02lx $%02lx) "
DISKIO_STR_NONE_TimeSlotMaskAllSet:
    NStr2   "(NONE)",TextLineFeed
Global_STR_OFF_AIR_2:
    NStr2   "(OFF AIR)",TextLineFeed
DISKIO_STR_TimeSlotListOpenParen:
    NStr    "("
DISKIO_FMT_PCT_S_TimeSlotMaskEntry:
    NStr    "%s "
DISKIO_STR_TimeSlotListCloseParenNewline:
    NStr2   ")",TextLineFeed
DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02:
    NStr    "blkout_mask = ($%02lx $%02lx $%02lx $%02lx $%02lx $%02lx) "
DISKIO_STR_NONE_BlackoutMaskEmpty:
    NStr2   "(NONE)",TextLineFeed
DISKIO_STR_BLACKED_OUT:
    NStr2   "(BLACKED OUT)",TextLineFeed
DISKIO_STR_BlackoutListOpenParen:
    NStr    "("
DISKIO_FMT_PCT_S_BlackoutMaskEntry:
    NStr    "%s "
DISKIO_STR_BlackoutListCloseParenNewline:
    NStr2   ")",TextLineFeed
DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump:
    NStr2   "flag1 = 0x%02X, flag2 = 0x%04X, BgColor = 0x%02X, FgColor = 0x%02X, BrushId = %s",TextLineFeed
DISKIO_FMT_COI_DASH_PTR_PCT_08LX:
    NStr2   "COI->Ptr = $%08lx",TextLineFeed
DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON:
    ; 9 probably = tab
    ; 10 probably = line feed
    NStr3   TextHorizontalTab,"def_COI information follows:",TextLineFeed
DISKIO_STR_DEF_DEFAULT:
    NStr3   TextHorizontalTab,"def_default = ""%s""",TextLineFeed
DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY:
    NStr3   TextHorizontalTab,"def_city = $%08lx ; *def_city = ""%s""",TextLineFeed
DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER:
    NStr3   TextHorizontalTab,"def_order = $%08lx ; *def_order = ""%s""",TextLineFeed
DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE:
    NStr3   TextHorizontalTab,"def_price = $%08lx ; *def_price = ""%s""",TextLineFeed
DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE:
    NStr3   TextHorizontalTab,"def_tele = $%08lx ; *def_tele = ""%s""",TextLineFeed
DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT:
    NStr3   TextHorizontalTab,"def_event = $%08lx ; *def_event = ""%s""",TextLineFeed
DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD:
    NStr3   TextHorizontalTab,"Exception_count is %ld",TextLineFeed
DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX:
    NStr3   TextHorizontalTab,"Exception_Block = $%08lx",TextLineFeed
DISKIO_FMT_CHANNEL_LINE_UP_PCT_D:
    NStr2   TextLineFeed,"Channel Line Up # %d, "
DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT:
    NStr2   "ETID=%d, chan_num='%s', source='%s', call_let='%s'",TextLineFeed
DISKIO_STR_ATTR:
    NStr    "  attr=("
DISKIO_STR_NONE_VerboseSourceAttrFlags:
    NStr    " NONE"
DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags:
    NStr    " HILITE_SRC"
DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags:
    NStr    " SUM_SRC"
DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags:
    NStr    " VIDEO_TAG_DISABLE"
DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags:
    NStr    " PPV_SRC"
DISKIO_STR_DITTO_VerboseSourceAttrFlags:
    NStr    " DITTO"
DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags:
    NStr    " ALTHILITESRC"
DISKIO_STR_STEREO:
    NStr    " STEREO"
DISKIO_STR_ProgramAttrCloseParenNewline:
    NStr2   " )",TextLineFeed
DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC:
    NStr    "  tslt_mask=($%02x $%02x $%02x $%02x $%02x $%02x) "
DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_:
    NStr2   "blkout_mask=($%02x $%02x $%02x $%02x $%02x $%02x)",TextLineFeed
DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord:
    NStr2   "  flag1 = 0x%02X, flag2 = 0x%04X, BgColor = 0x%02X, FgColor = 0x%02X, BrushId = %s",TextLineFeed
DISKIO_FMT_PROGRAM_INFO_PCT_LD:
    NStr2   "Program Info # %ld",TextLineFeed
DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo:
    NStr2   "prog_srce = '%s'",TextLineFeed
DISKIO_STR_NewlineOnly_A:
    NStr    10
DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX:
    NStr    "    (%02ld) [%s]: attr = $%02lx ("
DISKIO_STR_NONE_VerboseProgramAttrFlags:
    NStr    " NONE"
DISKIO_STR_MOVIE_VerboseProgramAttrFlags:
    NStr    " MOVIE"
DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags:
    NStr    " ALTHILITE_PROG"
DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags:
    NStr    " TAG_PROG"
DISKIO_STR_0X10:
    NStr    " 0x10"
DISKIO_STR_0X20_VerboseProgramAttrFlags:
    NStr    " 0x20"
DISKIO_STR_0X40:
    NStr    " 0x40"
DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags:
    NStr    " PREV_DAYS_DATA"
DISKIO_STR_ProgramAttrCloseAndProgPrefix:
    DC.B    " )",TextLineFeed
    NStr    "         prog_str = "
DISKIO_FMT_PCT_S_VerboseProgramStringLine:
    NStr2   "'%s'",TextLineFeed
DISKIO_STR_NullLine:
    NStr2   "NULL",TextLineFeed
DISKIO_STR_NewlineOnly_B:
    NStr    10
DISKIO_FMT_PROGRAM_INFO_PCT_D:
    NStr2   "Program Info # %d",TextLineFeed
DISKIO_STR_NewlineOnly_C:
    NStr    10
DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable:
    NStr2   "prog_srce = '%s'",TextLineFeed
DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR:
    NStr    "  %02d) [%s]: attr = ("
DISKIO_STR_NONE_ProgramInfoAttrTable:
    NStr    " NONE"
DISKIO_STR_MOVIE_ProgramInfoAttrTable:
    NStr    " MOVIE"
DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable:
    NStr    " ALTHILITE_PROG"
DISKIO_STR_TAG_PROG_ProgramInfoAttrTable:
    NStr    " TAG_PROG"
DISKIO_STR_SPORTSPROG:
    NStr    " SPORTSPROG"
DISKIO_STR_0X20_ProgramInfoAttrTable:
    NStr    " 0x20"
DISKIO_STR_REPEATPROG:
    NStr    " REPEATPROG"
DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable:
    NStr    " PREV_DAYS_DATA"
DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix:
    DC.B    " )"
    NStr2   TextLineFeed,"    prog_str='"
DISKIO_TAG_NONE:
    NStr    "NONE"
DISKIO_FMT_ProgramStringSuffixWithTypeFields:
    DC.B    "'",TextLineFeed
    NStr2   "    p_type=%03d, movie_cat=%03d, color=0x%02x",TextLineFeed
    DS.W    1
DISKIO_CurrentDriveRevisionIndex:
    DS.W    1
