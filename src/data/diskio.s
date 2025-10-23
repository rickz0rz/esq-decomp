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
LAB_1BD5:
    DC.L    1
LAB_1BD6:
    DC.L    1
LAB_1BD7:
    NStr    "trackdisk.device"
LAB_1BD8:
    NStr    "ram:assign >nil: FONTS: DH2:FONTS"
LAB_1BD9:
    NStr    "ram:assign >nil: ENV: DH2:"
LAB_1BDA:
    NStr    "ram:assign >nil: SYS: DH2:"
LAB_1BDB:
    NStr    "ram:assign >nil: S: DH2:S"
LAB_1BDC:
    NStr    "ram:assign >nil: C: DH2:C"
LAB_1BDD:
    NStr    "ram:assign >nil: L: DH2:L"
LAB_1BDE:
    NStr    "ram:assign >nil: LIBS: DH2:LIBS"
LAB_1BDF:
    NStr    "ram:assign >nil: DEVS: DH2:DEVS"
LAB_1BE0:
    NStr    "df1:g.ads"
LAB_1BE1:
    NStr    "ram:assign >nil: gfx: DF1:"
LAB_1BE2:
    NStr    "ram:assign >nil: gfx: PC1:"
LAB_1BE3:
    NStr    "NRLS"
LAB_1BE4:
    NStr    "LRBN"
LAB_1BE5:
    NStr    "MSN"
LAB_1BE6:
    DS.W    1
LAB_1BE7:
    NStr    "Mount PC1:"
LAB_1BE8:
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
LAB_1BED:
    NStr2   "Channel Line Up # %ld",TextLineFeed
LAB_1BEE:
    NStr2   "ETID = %ld ($%02lx)",TextLineFeed
LAB_1BEF:
    NStr2   "chan_num = '%s'",TextLineFeed
LAB_1BF0:
    NStr2   "source = '%s'",TextLineFeed
LAB_1BF1:
    NStr2   "call_let = '%s'",TextLineFeed
LAB_1BF2:
    NStr    "attr = $%02lx ("
LAB_1BF3:
    NStr    " NONE"
LAB_1BF4:
    NStr    " HILITE_SRC"
LAB_1BF5:
    NStr    " SUM_SRC"
LAB_1BF6:
    NStr    " VIDEO_TAG_DISABLE"
LAB_1BF7:
    NStr    " PPV_SRC"
LAB_1BF8:
    NStr    " DITTO"
LAB_1BF9:
    NStr    " ALTHILITESRC"
LAB_1BFA:
    NStr    " 0x80"
LAB_1BFB:
    NStr2   " )",TextLineFeed
LAB_1BFC:
    NStr    "tslt_mask = ($%02lx $%02lx $%02lx $%02lx $%02lx $%02lx) "
LAB_1BFD:
    NStr2   "(NONE)",TextLineFeed
GLOB_STR_OFF_AIR_2:
    NStr2   "(OFF AIR)",TextLineFeed
LAB_1BFF:
    NStr    "("
LAB_1C00:
    NStr    "%s "
LAB_1C01:
    NStr2   ")",TextLineFeed
LAB_1C02:
    NStr    "blkout_mask = ($%02lx $%02lx $%02lx $%02lx $%02lx $%02lx) "
LAB_1C03:
    NStr2   "(NONE)",TextLineFeed
LAB_1C04:
    NStr2   "(BLACKED OUT)",TextLineFeed
LAB_1C05:
    NStr    "("
LAB_1C06:
    NStr    "%s "
LAB_1C07:
    NStr2   ")",TextLineFeed
LAB_1C08:
    NStr2   "flag1 = 0x%02X, flag2 = 0x%04X, BgColor = 0x%02X, FgColor = 0x%02X, BrushId = %s",TextLineFeed
LAB_1C09:
    NStr2   "COI->Ptr = $%08lx",TextLineFeed
LAB_1C0A:
    ; 9 probably = tab
    ; 10 probably = line feed
    NStr3   TextHorizontalTab,"def_COI information follows:",TextLineFeed
LAB_1C0B:
    NStr3   TextHorizontalTab,"def_default = ""%s""",TextLineFeed
LAB_1C0C:
    NStr3   TextHorizontalTab,"def_city = $%08lx ; *def_city = ""%s""",TextLineFeed
LAB_1C0D:
    NStr3   TextHorizontalTab,"def_order = $%08lx ; *def_order = ""%s""",TextLineFeed
LAB_1C0E:
    NStr3   TextHorizontalTab,"def_price = $%08lx ; *def_price = ""%s""",TextLineFeed
LAB_1C0F:
    NStr3   TextHorizontalTab,"def_tele = $%08lx ; *def_tele = ""%s""",TextLineFeed
LAB_1C10:
    NStr3   TextHorizontalTab,"def_event = $%08lx ; *def_event = ""%s""",TextLineFeed
LAB_1C11:
    NStr3   TextHorizontalTab,"Exception_count is %ld",TextLineFeed
LAB_1C12:
    NStr3   TextHorizontalTab,"Exception_Block = $%08lx",TextLineFeed
LAB_1C13:
    NStr2   TextLineFeed,"Channel Line Up # %d, "
LAB_1C14:
    NStr2   "ETID=%d, chan_num='%s', source='%s', call_let='%s'",TextLineFeed
LAB_1C15:
    NStr    "  attr=("
LAB_1C16:
    NStr    " NONE"
LAB_1C17:
    NStr    " HILITE_SRC"
LAB_1C18:
    NStr    " SUM_SRC"
LAB_1C19:
    NStr    " VIDEO_TAG_DISABLE"
LAB_1C1A:
    NStr    " PPV_SRC"
LAB_1C1B:
    NStr    " DITTO"
LAB_1C1C:
    NStr    " ALTHILITESRC"
LAB_1C1D:
    NStr    " STEREO"
LAB_1C1E:
    NStr2   " )",TextLineFeed
LAB_1C1F:
    NStr    "  tslt_mask=($%02x $%02x $%02x $%02x $%02x $%02x) "
LAB_1C20:
    NStr2   "blkout_mask=($%02x $%02x $%02x $%02x $%02x $%02x)",TextLineFeed
LAB_1C21:
    NStr2   "  flag1 = 0x%02X, flag2 = 0x%04X, BgColor = 0x%02X, FgColor = 0x%02X, BrushId = %s",TextLineFeed
LAB_1C22:
    NStr2   "Program Info # %ld",TextLineFeed
LAB_1C23:
    NStr2   "prog_srce = '%s'",TextLineFeed
LAB_1C24:
    NStr    10
LAB_1C25:
    NStr    "    (%02ld) [%s]: attr = $%02lx ("
LAB_1C26:
    NStr    " NONE"
LAB_1C27:
    NStr    " MOVIE"
LAB_1C28:
    NStr    " ALTHILITE_PROG"
LAB_1C29:
    NStr    " TAG_PROG"
LAB_1C2A:
    NStr    " 0x10"
LAB_1C2B:
    NStr    " 0x20"
LAB_1C2C:
    NStr    " 0x40"
LAB_1C2D:
    NStr    " PREV_DAYS_DATA"
LAB_1C2E:
    DC.B    " )",TextLineFeed
    NStr    "         prog_str = "
LAB_1C2F:
    NStr2   "'%s'",TextLineFeed
LAB_1C30:
    NStr2   "NULL",TextLineFeed
LAB_1C31:
    NStr    10
LAB_1C32:
    NStr2   "Program Info # %d",TextLineFeed
LAB_1C33:
    NStr    10
LAB_1C34:
    NStr2   "prog_srce = '%s'",TextLineFeed
LAB_1C35:
    NStr    "  %02d) [%s]: attr = ("
LAB_1C36:
    NStr    " NONE"
LAB_1C37:
    NStr    " MOVIE"
LAB_1C38:
    NStr    " ALTHILITE_PROG"
LAB_1C39:
    NStr    " TAG_PROG"
LAB_1C3A:
    NStr    " SPORTSPROG"
LAB_1C3B:
    NStr    " 0x20"
LAB_1C3C:
    NStr    " REPEATPROG"
LAB_1C3D:
    NStr    " PREV_DAYS_DATA"
LAB_1C3E:
    DC.B    " )"
    NStr2   TextLineFeed,"    prog_str='"
LAB_1C3F:
    NStr    "NONE"
LAB_1C40:
    DC.B    "'",TextLineFeed
    NStr2   "    p_type=%03d, movie_cat=%03d, color=0x%02x",TextLineFeed
    DS.W    1
LAB_1C41:
    DS.W    1
