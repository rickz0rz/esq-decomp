BEGIN {
    label=0; updsel=0; addoff=0; alloc=0; refresh=0; write_rtc=0
    pri=0; sec=0; mode=0; day=0; c89=0; c1=0; cm1=0; ret=0
}

/^DST_UpdateBannerQueue:$/ { label=1 }
/DATETIME_UpdateSelectionField/ { updsel=1 }
/DST_AddTimeOffset/ { addoff=1 }
/DST_AllocateBannerStruct/ { alloc=1 }
/DST_RefreshBannerBuffer/ { refresh=1 }
/DST_WriteRtcFromGlobals/ { write_rtc=1 }
/DST_PrimaryCountdown/ { pri=1 }
/DST_SecondaryCountdown/ { sec=1 }
/ESQ_SecondarySlotModeFlagChar/ { mode=1 }
/CLOCK_DaySlotIndex/ { day=1 }
/#\$59|#89|89\.[Ww]/ { c89=1 }
/#\$1|#1|1\.[Ww]/ { c1=1 }
/#-1|#\$ffff|-1\.[Ww]/ { cm1=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (updsel) print "HAS_UPDATE_SELECTION_CALL"
    if (addoff) print "HAS_ADD_OFFSET_CALL"
    if (alloc) print "HAS_ALLOC_CALL"
    if (refresh) print "HAS_REFRESH_CALL"
    if (write_rtc) print "HAS_WRITE_RTC_CALL"
    if (pri) print "HAS_PRIMARY_COUNTDOWN_REF"
    if (sec) print "HAS_SECONDARY_COUNTDOWN_REF"
    if (mode) print "HAS_SECONDARY_MODE_REF"
    if (day) print "HAS_DAY_SLOT_REF"
    if (c89) print "HAS_CONST_89"
    if (c1) print "HAS_CONST_1"
    if (cm1) print "HAS_CONST_NEG1"
    if (ret) print "HAS_RTS"
}
