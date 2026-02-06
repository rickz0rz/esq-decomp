; ========== DISKIO.c ==========

GLOB_STR_DISKIO_C_1:
    NStr    "DISKIO.c"
GLOB_STR_DISKIO_C_2:
    NStr    "DISKIO.c"
GLOB_STR_PERCENT_LD:
    NStr    "%ld"
GLOB_STR_DISKIO_C_3:
    NStr    "DISKIO.c"
GLOB_STR_DISKIO_C_4:
    NStr    "DISKIO.c"
GLOB_STR_DISKIO_C_5:
    NStr    "DISKIO.c"
GLOB_STR_DISKIO_C_6:
    NStr    "DISKIO.c"
GLOB_STR_DISKIO_C_7:
    NStr    "DISKIO.c"
GLOB_STR_DISKIO_C_8:
    NStr    "DISKIO.c"
DATA_DISKIO_CONST_LONG_1BD5:
    DC.L    1
DATA_DISKIO_CONST_LONG_1BD6:
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
DATA_DISKIO_TAG_NRLS_1BE3:
    NStr    "NRLS"
DATA_DISKIO_TAG_LRBN_1BE4:
    NStr    "LRBN"
DATA_DISKIO_TAG_MSN_1BE5:
    NStr    "MSN"
DATA_DISKIO_BSS_WORD_1BE6:
    DS.W    1
DISKIO_CMD_MOUNT_PC1:
    NStr    "Mount PC1:"
DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT:
    NStr    "Assign GFX: PC1:"
GLOB_STR_DF0_CONFIG_DAT_1:
    NStr    "df0:config.dat"
GLOB_STR_DEFAULT_CONFIG_FORMATTED:
    DC.B    "%01ld%01lc%01ld%01ld%02ld%02ld%01lc%01lc%01lc%01lc%01ld%01ld%"
    DC.B    "01lc%01lc%01lc%01lc%01lc%01lc%01lc%02ld%02ld%01lc%01lc%01lc%0"
    DC.B    "2ld%02ld%02ld%03ld%01ld%2.2s%01lc%01lc%01lc%01c%01c%01d%01c%0"
    NStr2   "1c%01c%01c%01c%01c",TextLineFeed
GLOB_STR_DF0_CONFIG_DAT_2:
    NStr    "df0:config.dat"
GLOB_STR_DISKIO_C_9:
    NStr    "DISKIO.c"
DATA_DISKIO_FMT_CHANNEL_LINE_UP_PCT_LD_1BED:
    NStr2   "Channel Line Up # %ld",TextLineFeed
DATA_DISKIO_FMT_ETID_PCT_LD_PCT_02LX_1BEE:
    NStr2   "ETID = %ld ($%02lx)",TextLineFeed
DATA_DISKIO_FMT_CHAN_NUM_PCT_S_1BEF:
    NStr2   "chan_num = '%s'",TextLineFeed
DATA_DISKIO_FMT_SOURCE_PCT_S_1BF0:
    NStr2   "source = '%s'",TextLineFeed
DATA_DISKIO_FMT_CALL_LET_PCT_S_1BF1:
    NStr2   "call_let = '%s'",TextLineFeed
DATA_DISKIO_FMT_ATTR_PCT_02LX_1BF2:
    NStr    "attr = $%02lx ("
DATA_DISKIO_STR_NONE_1BF3:
    NStr    " NONE"
DATA_DISKIO_STR_HILITE_SRC_1BF4:
    NStr    " HILITE_SRC"
DATA_DISKIO_STR_SUM_SRC_1BF5:
    NStr    " SUM_SRC"
DATA_DISKIO_STR_VIDEO_TAG_DISABLE_1BF6:
    NStr    " VIDEO_TAG_DISABLE"
DATA_DISKIO_STR_PPV_SRC_1BF7:
    NStr    " PPV_SRC"
DATA_DISKIO_STR_DITTO_1BF8:
    NStr    " DITTO"
DATA_DISKIO_STR_ALTHILITESRC_1BF9:
    NStr    " ALTHILITESRC"
DATA_DISKIO_STR_0X80_1BFA:
    NStr    " 0x80"
DATA_DISKIO_STR_VALUE_1BFB:
    NStr2   " )",TextLineFeed
DATA_DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX_1BFC:
    NStr    "tslt_mask = ($%02lx $%02lx $%02lx $%02lx $%02lx $%02lx) "
DATA_DISKIO_STR_NONE_1BFD:
    NStr2   "(NONE)",TextLineFeed
GLOB_STR_OFF_AIR_2:
    NStr2   "(OFF AIR)",TextLineFeed
DATA_DISKIO_STR_VALUE_1BFF:
    NStr    "("
DATA_DISKIO_FMT_PCT_S_1C00:
    NStr    "%s "
DATA_DISKIO_STR_VALUE_1C01:
    NStr2   ")",TextLineFeed
DATA_DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02_1C02:
    NStr    "blkout_mask = ($%02lx $%02lx $%02lx $%02lx $%02lx $%02lx) "
DATA_DISKIO_STR_NONE_1C03:
    NStr2   "(NONE)",TextLineFeed
DATA_DISKIO_STR_BLACKED_OUT_1C04:
    NStr2   "(BLACKED OUT)",TextLineFeed
DATA_DISKIO_STR_VALUE_1C05:
    NStr    "("
DATA_DISKIO_FMT_PCT_S_1C06:
    NStr    "%s "
DATA_DISKIO_STR_VALUE_1C07:
    NStr2   ")",TextLineFeed
DATA_DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_1C08:
    NStr2   "flag1 = 0x%02X, flag2 = 0x%04X, BgColor = 0x%02X, FgColor = 0x%02X, BrushId = %s",TextLineFeed
DATA_DISKIO_FMT_COI_DASH_PTR_PCT_08LX_1C09:
    NStr2   "COI->Ptr = $%08lx",TextLineFeed
DATA_DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON_1C0A:
    ; 9 probably = tab
    ; 10 probably = line feed
    NStr3   TextHorizontalTab,"def_COI information follows:",TextLineFeed
DATA_DISKIO_STR_DEF_DEFAULT_1C0B:
    NStr3   TextHorizontalTab,"def_default = ""%s""",TextLineFeed
DATA_DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY_1C0C:
    NStr3   TextHorizontalTab,"def_city = $%08lx ; *def_city = ""%s""",TextLineFeed
DATA_DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER_1C0D:
    NStr3   TextHorizontalTab,"def_order = $%08lx ; *def_order = ""%s""",TextLineFeed
DATA_DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE_1C0E:
    NStr3   TextHorizontalTab,"def_price = $%08lx ; *def_price = ""%s""",TextLineFeed
DATA_DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE_1C0F:
    NStr3   TextHorizontalTab,"def_tele = $%08lx ; *def_tele = ""%s""",TextLineFeed
DATA_DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT_1C10:
    NStr3   TextHorizontalTab,"def_event = $%08lx ; *def_event = ""%s""",TextLineFeed
DATA_DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD_1C11:
    NStr3   TextHorizontalTab,"Exception_count is %ld",TextLineFeed
DATA_DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX_1C12:
    NStr3   TextHorizontalTab,"Exception_Block = $%08lx",TextLineFeed
DATA_DISKIO_FMT_CHANNEL_LINE_UP_PCT_D_1C13:
    NStr2   TextLineFeed,"Channel Line Up # %d, "
DATA_DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT_1C14:
    NStr2   "ETID=%d, chan_num='%s', source='%s', call_let='%s'",TextLineFeed
DATA_DISKIO_STR_ATTR_1C15:
    NStr    "  attr=("
DATA_DISKIO_STR_NONE_1C16:
    NStr    " NONE"
DATA_DISKIO_STR_HILITE_SRC_1C17:
    NStr    " HILITE_SRC"
DATA_DISKIO_STR_SUM_SRC_1C18:
    NStr    " SUM_SRC"
DATA_DISKIO_STR_VIDEO_TAG_DISABLE_1C19:
    NStr    " VIDEO_TAG_DISABLE"
DATA_DISKIO_STR_PPV_SRC_1C1A:
    NStr    " PPV_SRC"
DATA_DISKIO_STR_DITTO_1C1B:
    NStr    " DITTO"
DATA_DISKIO_STR_ALTHILITESRC_1C1C:
    NStr    " ALTHILITESRC"
DATA_DISKIO_STR_STEREO_1C1D:
    NStr    " STEREO"
DATA_DISKIO_STR_VALUE_1C1E:
    NStr2   " )",TextLineFeed
DATA_DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC_1C1F:
    NStr    "  tslt_mask=($%02x $%02x $%02x $%02x $%02x $%02x) "
DATA_DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X__1C20:
    NStr2   "blkout_mask=($%02x $%02x $%02x $%02x $%02x $%02x)",TextLineFeed
DATA_DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_1C21:
    NStr2   "  flag1 = 0x%02X, flag2 = 0x%04X, BgColor = 0x%02X, FgColor = 0x%02X, BrushId = %s",TextLineFeed
DATA_DISKIO_FMT_PROGRAM_INFO_PCT_LD_1C22:
    NStr2   "Program Info # %ld",TextLineFeed
DATA_DISKIO_FMT_PROG_SRCE_PCT_S_1C23:
    NStr2   "prog_srce = '%s'",TextLineFeed
DATA_DISKIO_STR_1C24:
    NStr    10
DATA_DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX_1C25:
    NStr    "    (%02ld) [%s]: attr = $%02lx ("
DATA_DISKIO_STR_NONE_1C26:
    NStr    " NONE"
DATA_DISKIO_STR_MOVIE_1C27:
    NStr    " MOVIE"
DATA_DISKIO_STR_ALTHILITE_PROG_1C28:
    NStr    " ALTHILITE_PROG"
DATA_DISKIO_STR_TAG_PROG_1C29:
    NStr    " TAG_PROG"
DATA_DISKIO_STR_0X10_1C2A:
    NStr    " 0x10"
DATA_DISKIO_STR_0X20_1C2B:
    NStr    " 0x20"
DATA_DISKIO_STR_0X40_1C2C:
    NStr    " 0x40"
DATA_DISKIO_STR_PREV_DAYS_DATA_1C2D:
    NStr    " PREV_DAYS_DATA"
DATA_DISKIO_STR_VALUE_1C2E:
    DC.B    " )",TextLineFeed
    NStr    "         prog_str = "
DATA_DISKIO_FMT_PCT_S_1C2F:
    NStr2   "'%s'",TextLineFeed
DATA_DISKIO_TAG_NULL_1C30:
    NStr2   "NULL",TextLineFeed
DATA_DISKIO_STR_1C31:
    NStr    10
DATA_DISKIO_FMT_PROGRAM_INFO_PCT_D_1C32:
    NStr2   "Program Info # %d",TextLineFeed
DATA_DISKIO_STR_1C33:
    NStr    10
DATA_DISKIO_FMT_PROG_SRCE_PCT_S_1C34:
    NStr2   "prog_srce = '%s'",TextLineFeed
DATA_DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR_1C35:
    NStr    "  %02d) [%s]: attr = ("
DATA_DISKIO_STR_NONE_1C36:
    NStr    " NONE"
DATA_DISKIO_STR_MOVIE_1C37:
    NStr    " MOVIE"
DATA_DISKIO_STR_ALTHILITE_PROG_1C38:
    NStr    " ALTHILITE_PROG"
DATA_DISKIO_STR_TAG_PROG_1C39:
    NStr    " TAG_PROG"
DATA_DISKIO_STR_SPORTSPROG_1C3A:
    NStr    " SPORTSPROG"
DATA_DISKIO_STR_0X20_1C3B:
    NStr    " 0x20"
DATA_DISKIO_STR_REPEATPROG_1C3C:
    NStr    " REPEATPROG"
DATA_DISKIO_STR_PREV_DAYS_DATA_1C3D:
    NStr    " PREV_DAYS_DATA"
DATA_DISKIO_STR_VALUE_1C3E:
    DC.B    " )"
    NStr2   TextLineFeed,"    prog_str='"
DATA_DISKIO_TAG_NONE_1C3F:
    NStr    "NONE"
DATA_DISKIO_STR_VALUE_1C40:
    DC.B    "'",TextLineFeed
    NStr2   "    p_type=%03d, movie_cat=%03d, color=0x%02x",TextLineFeed
    DS.W    1
DATA_DISKIO_BSS_WORD_1C41:
    DS.W    1
