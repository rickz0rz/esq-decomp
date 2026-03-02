BEGIN {
    label=0; tick=0; add=0; day=0; cur=0; phase=0; fmt=0; ret=0
}

/^DST_RefreshBannerBuffer:$/ { label=1 }
/DST_TickBannerCounters/ { tick=1 }
/DST_AddTimeOffset/ { add=1 }
/CLOCK_DaySlotIndex/ { day=1 }
/CLOCK_CurrentDayOfWeekIndex/ { cur=1 }
/WDISP_BannerCharPhaseShift/ { phase=1 }
/CLOCK_FormatVariantCode/ { fmt=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (tick) print "HAS_TICK_CALL"
    if (add) print "HAS_ADD_OFFSET_CALL"
    if (day) print "HAS_DAY_SLOT_REF"
    if (cur) print "HAS_CURRENT_SLOT_REF"
    if (phase) print "HAS_PHASE_SHIFT_REF"
    if (fmt) print "HAS_FORMAT_VARIANT_REF"
    if (ret) print "HAS_RTS"
}
