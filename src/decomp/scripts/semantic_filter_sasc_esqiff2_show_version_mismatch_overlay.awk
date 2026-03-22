BEGIN {
    has_entry = 0
    saw_recordbuffer = 0
    saw_clear_offset_20 = 0
    has_recordbuffer_clear = 0
    saw_patch_version = 0
    saw_version_label_1 = 0
    saw_patch_fmt = 0
    saw_sprintf = 0
    has_patch_sprintf = 0
    has_wildcard_call = 0
    saw_plus1_arg = 0
    has_wildcard_arg_plus1 = 0
    has_early_return_branch = 0
    saw_ui_busy = 0
    saw_diag_flag = 0
    has_ui_guard = 0
    saw_disable = 0
    saw_enable = 0
    has_disable_enable = 0
    has_readmode_0x100 = 0
    has_seed_banner = 0
    saw_rastport = 0
    saw_bitmap = 0
    has_bitmap_swap = 0
    has_diag_reset = 0
    saw_pen2 = 0
    has_pen2 = 0
    saw_rectfill = 0
    saw_rectfill_y1 = 0
    saw_rectfill_x2 = 0
    saw_rectfill_y2 = 0
    has_rectfill_bounds = 0
    saw_pen3 = 0
    has_pen3 = 0
    saw_msg1_text = 0
    saw_msg1_y = 0
    saw_msg1_x = 0
    has_msg_line1 = 0
    saw_version_label_2 = 0
    saw_version_fmt_2 = 0
    saw_msg2_y = 0
    saw_msg2_x = 0
    has_msg_line2 = 0
    has_copy_loop = 0
    has_copy_terminator = 0
    saw_append = 0
    has_append_record = 0
    has_append_apostrophe = 0
    saw_msg3_y = 0
    saw_msg3_x = 0
    has_msg_line3 = 0
    has_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function squash(s, t) {
    t = trim(s)
    gsub(/[^A-Z0-9]/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    flat = squash($0)

    if (line ~ /^ESQIFF2_SHOWVERSIONMISMATCHOVERLAY:/ || line ~ /^ESQIFF2_SHOWVERSIONMISMATCHO[A-Z0-9_]*:/) has_entry = 1

    if (flat ~ /ESQIFFRECORDBUFFERPTR/) saw_recordbuffer = 1
    if (flat ~ /CLRB14A0/ || flat ~ /CLRB20A0/ || flat ~ /CLR20A0/) saw_clear_offset_20 = 1
    if (flat ~ /GLOBALLONGPATCHVERSIONNUMBER/) saw_patch_version = 1
    if (flat ~ /GLOBALSTRMAJORMINORVERSION1/ || flat ~ /MAJORMINORVERSION1/) saw_version_label_1 = 1
    if (flat ~ /ESQIFFFMTPCTSDOTPCTLD/ || flat ~ /PCTS/ && flat ~ /PCTLD/) saw_patch_fmt = 1
    if (flat ~ /WDISPSPRINTF/) saw_sprintf = 1
    if (flat ~ /WILDCARDMATCH/) has_wildcard_call = 1
    if (flat ~ /ADDQL1A0/ || flat ~ /ADDQ1A0/) saw_plus1_arg = 1
    if (line ~ /^BEQ\.[SWB] ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/ || line ~ /^BEQ\.[SWB] ___ESQIFF2_SHOWVERSIONMISMATCHO/ || line ~ /^BRA\.[SWB] ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/ || line ~ /^JMP ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/) has_early_return_branch = 1
    if (flat ~ /GLOBALUIBUSYFLAG/) saw_ui_busy = 1
    if (flat ~ /EDDIAGNOSTICSSCREENACTIVE/) saw_diag_flag = 1
    if (flat ~ /LVODISABLE/ || flat ~ /BSRWDISABLE/) saw_disable = 1
    if (flat ~ /LVOENABLE/ || flat ~ /BSRWENABLE/) saw_enable = 1
    if (flat ~ /ESQPARS2READMODEFLAGS/ && (flat ~ /100/ || flat ~ /0100/)) has_readmode_0x100 = 1
    if (flat ~ /GCOMMANDSEEDBANNERFROMPREFS/) has_seed_banner = 1
    if (flat ~ /GLOBALREFRASTPORT1/) saw_rastport = 1
    if (flat ~ /GLOBALREF696400BITMAP/) saw_bitmap = 1
    if (flat ~ /EDDIAGNOSTICSSCREENACTIVE/ && (flat ~ /CLRW/ || flat ~ /MOVEW0/)) has_diag_reset = 1
    if ((flat ~ /MOVEQ2D0/ || flat ~ /PEA2W/) && flat !~ /2A7/ && flat !~ /ESQPARS2READMODEFLAGS/) saw_pen2 = 1
    if (flat ~ /RECTFILL/) saw_rectfill = 1
    if (flat ~ /MOVEQ60D1/ || flat ~ /PEA3CW/) saw_rectfill_y1 = 1
    if (flat ~ /679/ || flat ~ /2A7/) saw_rectfill_x2 = 1
    if (flat ~ /NOTBD3/ || flat ~ /9BW/) saw_rectfill_y2 = 1
    if ((flat ~ /MOVEQ3D0/ || flat ~ /PEA3W/) && flat !~ /3C/ && flat !~ /13/) saw_pen3 = 1
    if (flat ~ /INCORRECTVERSIONPLE/ || flat ~ /INCORRECTVERSIONPLEASECORRECTASA/) saw_msg1_text = 1
    if (flat ~ /90W/ || flat ~ /5AW/) saw_msg1_y = 1
    if (flat ~ /30W/ || flat ~ /1EW/) saw_msg1_x = 1
    if (flat ~ /GLOBALSTRMAJORMINORVERSION2/ || flat ~ /MAJORMINORVERSION2/) saw_version_label_2 = 1
    if (flat ~ /YOURVERSIONIS/) saw_version_fmt_2 = 1
    if (flat ~ /120W/ || flat ~ /78W/) saw_msg2_y = 1
    if (flat ~ /30W/ || flat ~ /1EW/) saw_msg2_x = 1
    if (flat ~ /MOVEQ4D0/ || flat ~ /MOVEQL4D0/) saw_copy_count = 1
    if (flat ~ /DBFD0/ || flat ~ /ASLL2D1/) saw_copy_iter = 1
    if (flat ~ /CORRECTVERSIONIS/) saw_copy_src = 1
    if (flat ~ /CLRBA1/ || flat ~ /CLRBA5/) has_copy_terminator = 1
    if (flat ~ /APPENDATNULL/) saw_append = 1
    if (flat ~ /GLOBALSTRAPOSTROPHE/) has_append_apostrophe = 1
    if (flat ~ /150W/ || flat ~ /96W/) saw_msg3_y = 1
    if (flat ~ /30W/ || flat ~ /1EW/) saw_msg3_x = 1
    if (line == "RTS") has_rts = 1
}

END {
    has_recordbuffer_clear = (saw_recordbuffer && saw_clear_offset_20)
    has_patch_sprintf = (saw_patch_version && saw_version_label_1 && saw_patch_fmt && saw_sprintf)
    has_wildcard_arg_plus1 = (saw_recordbuffer && saw_plus1_arg)
    has_ui_guard = (saw_ui_busy && saw_diag_flag)
    has_disable_enable = (saw_disable && saw_enable)
    has_bitmap_swap = (saw_rastport && saw_bitmap)
    has_pen2 = saw_pen2
    has_rectfill_bounds = (saw_rectfill && saw_rectfill_y1 && saw_rectfill_x2 && saw_rectfill_y2)
    has_pen3 = saw_pen3
    has_msg_line1 = (saw_msg1_text && saw_msg1_y && saw_msg1_x)
    has_msg_line2 = (saw_patch_version && saw_version_label_2 && saw_version_fmt_2 && saw_sprintf && saw_msg2_y && saw_msg2_x)
    has_copy_loop = (saw_copy_count && saw_copy_iter && saw_copy_src)
    has_append_record = (saw_append && saw_recordbuffer)
    has_msg_line3 = (saw_append && has_append_apostrophe && saw_msg3_y && saw_msg3_x)

    print "HAS_ENTRY=" has_entry
    print "HAS_RECORDBUFFER_CLEAR=" has_recordbuffer_clear
    print "HAS_PATCH_SPRINTF=" has_patch_sprintf
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_WILDCARD_ARG_PLUS1=" has_wildcard_arg_plus1
    print "HAS_EARLY_RETURN_BRANCH=" has_early_return_branch
    print "HAS_UI_GUARD=" has_ui_guard
    print "HAS_DISABLE_ENABLE=" has_disable_enable
    print "HAS_READMODE_0X100=" has_readmode_0x100
    print "HAS_SEED_BANNER=" has_seed_banner
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_DIAG_RESET=" has_diag_reset
    print "HAS_SETAPEN_2=" has_pen2
    print "HAS_RECTFILL_BOUNDS=" has_rectfill_bounds
    print "HAS_SETAPEN_3=" has_pen3
    print "HAS_MSG_LINE1=" has_msg_line1
    print "HAS_MSG_LINE2=" has_msg_line2
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_COPY_TERMINATOR=" has_copy_terminator
    print "HAS_APPEND_RECORD=" has_append_record
    print "HAS_APPEND_APOSTROPHE=" has_append_apostrophe
    print "HAS_MSG_LINE3=" has_msg_line3
    print "HAS_RTS=" has_rts
}
