BEGIN {
    label=0; parse_count=0; copy_count=0; update=0; c32=0; c33=0; c4=0; c19=0; pri=0; sec=0; ret=0
}

/^DST_HandleBannerCommand32_33:$/ { label=1 }
/DATETIME_ParseString/ { parse_count++ }
/DATETIME_CopyPairAndRecalc/ { copy_count++ }
/DST_UpdateBannerQueue/ { update=1 }
/#\$32|#50|50\.[Ww]/ { c32=1 }
/#\$33|#51|51\.[Ww]/ { c33=1 }
/^SUBQ\.[Ww][[:space:]]+#1,[dD][0-7]$/ { c33=1 }
/#\$4|#4|4\.[Ww]/ { c4=1 }
/#\$13|#19|19\.[Ww]/ { c19=1 }
/DST_BannerWindowPrimary/ { pri=1 }
/DST_BannerWindowSecondary/ { sec=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (parse_count >= 2) print "HAS_PARSE_CALLS"
    if (copy_count >= 1) print "HAS_COPY_CALLS"
    if (update) print "HAS_UPDATE_CALL"
    if (c32) print "HAS_CMD_32"
    if (c33) print "HAS_CMD_33"
    if (c4) print "HAS_CONST_4"
    if (c19) print "HAS_CONST_19"
    if (pri) print "HAS_PRIMARY_REF"
    if (sec) print "HAS_SECONDARY_REF"
    if (ret) print "HAS_RTS"
}
