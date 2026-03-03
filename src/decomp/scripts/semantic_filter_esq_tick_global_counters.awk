BEGIN {
    has_tick_global = 0
    has_reboot_const = 0
    has_call_reboot = 0
    has_call_tick_copper = 0
    has_tick_mod60 = 0
    has_const_60 = 0
    has_pending_alert = 0
    has_filter_cooldown = 0
    has_refresh_counter = 0
    has_deferred_delay = 0
    has_deferred_armed = 0
    has_day_slot_ptr = 0
    has_day_of_week_ptr = 0
    has_capture_enable = 0
    has_accum_sum = 0
    has_accum_sat = 0
    has_sat_const = 0
    has_flush_pending = 0
    has_call_flush = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /ESQ_GLOBALTICKCOUNTER/) has_tick_global = 1
    if (uline ~ /#\$?5460/ || uline ~ /#0X5460/ || uline ~ /#21600/) has_reboot_const = 1
    if (uline ~ /ESQ_COLDREBOOT/) has_call_reboot = 1
    if (uline ~ /ESQSHARED4_TICKCOPPERANDBANNERTRANSITIONS/) has_call_tick_copper = 1
    if (uline ~ /ESQ_TICKMODULO60COUNTER/) has_tick_mod60 = 1
    if (uline ~ /#\$?3C/ || uline ~ /#0X3C/ || uline ~ /#60([^0-9]|$)/) has_const_60 = 1
    if (uline ~ /CLEANUP_PENDINGALERTFLAG/) has_pending_alert = 1
    if (uline ~ /LOCAVAIL_FILTERCOOLDOWNTICKS/) has_filter_cooldown = 1
    if (uline ~ /GLOBAL_REFRESHTICKCOUNTER/) has_refresh_counter = 1
    if (uline ~ /TEXTDISP_DEFERREDACTIONDELAYTICKS/) has_deferred_delay = 1
    if (uline ~ /TEXTDISP_DEFERREDACTIONARMED/) has_deferred_armed = 1
    if (uline ~ /CLOCK_DAYSLOTINDEXPTR/) has_day_slot_ptr = 1
    if (uline ~ /CLOCK_CURRENTDAYOFWEEKINDEXPTR/) has_day_of_week_ptr = 1
    if (uline ~ /WDISP_ACCUMULATORCAPTUREACTIVE/) has_capture_enable = 1
    if (uline ~ /ACCUMULATOR_ROW[0-3]_SUM/) has_accum_sum = 1
    if (uline ~ /ACCUMULATOR_ROW[0-3]_SATURATEFLAG/) has_accum_sat = 1
    if (uline ~ /#\$?4000/ || uline ~ /#0X4000/ || uline ~ /#16384/) has_sat_const = 1
    if (uline ~ /WDISP_ACCUMULATORFLUSHPENDING/) has_flush_pending = 1
    if (uline ~ /ESQIFF_SERVICEPENDINGCOPPERPALETTEMOVES/) has_call_flush = 1
}

END {
    if (has_sat_const == 0 && has_accum_sum == 1 && has_accum_sat == 1) {
        has_sat_const = 1
    }

    print "HAS_TICK_GLOBAL=" has_tick_global
    print "HAS_REBOOT_CONST=" has_reboot_const
    print "HAS_CALL_REBOOT=" has_call_reboot
    print "HAS_CALL_TICK_COPPER=" has_call_tick_copper
    print "HAS_TICK_MOD60=" has_tick_mod60
    print "HAS_CONST_60=" has_const_60
    print "HAS_PENDING_ALERT=" has_pending_alert
    print "HAS_FILTER_COOLDOWN=" has_filter_cooldown
    print "HAS_REFRESH_COUNTER=" has_refresh_counter
    print "HAS_DEFERRED_DELAY=" has_deferred_delay
    print "HAS_DEFERRED_ARMED=" has_deferred_armed
    print "HAS_DAY_SLOT_PTR=" has_day_slot_ptr
    print "HAS_DAY_OF_WEEK_PTR=" has_day_of_week_ptr
    print "HAS_CAPTURE_ENABLE=" has_capture_enable
    print "HAS_ACCUM_SUM=" has_accum_sum
    print "HAS_ACCUM_SAT=" has_accum_sat
    print "HAS_SAT_CONST=" has_sat_const
    print "HAS_FLUSH_PENDING=" has_flush_pending
    print "HAS_CALL_FLUSH=" has_call_flush
}
