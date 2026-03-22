BEGIN {
    has_stack_arg_load = 0
    has_weather_text_ref = 0
    has_dst_setup = 0
    has_copy_read = 0
    has_copy_write = 0
    has_tst_or_bne_loop = 0
    has_rts = 0
}

{
    u = toupper($0)

    if (u ~ /MOVEA?\.L[ \t]+(\$10|16)\(A7\),A[35]/ || u ~ /MOVEA?\.L[ \t]+8\(A7\),A3/) {
        has_stack_arg_load = 1
    }
    if (u ~ /GLOBAL_STR_WEATHER_UPDATE_FOR/) {
        has_weather_text_ref = 1
    }
    if (u ~ /MOVEA?\.L[ \t]+A[35],A[12]/) {
        has_dst_setup = 1
    }
    if (u ~ /MOVE\.B[ \t]+\((A0|A3)\)\+,D0/ || u ~ /MOVE\.B[ \t]+\((A0|A3)\)\+,\(A1\)\+/) {
        has_copy_read = 1
    }
    if (u ~ /MOVE\.B[ \t]+D0,\(A0\)/ || u ~ /MOVE\.B[ \t]+\((A0|A3)\)\+,\(A1\)\+/) {
        has_copy_write = 1
    }
    if (u ~ /TST\.B[ \t]+D0/ || u ~ /BNE\.[BSW]?[ \t]+\.COPY_LOOP/ || u ~ /BRA\.[BSW]?[ \t]+___SCRIPT_COPYWEATHERUPDATEFORSTRIN__2/) {
        has_tst_or_bne_loop = 1
    }
    if (u ~ /^RTS$/) {
        has_rts = 1
    }
}

END {
    if (has_stack_arg_load) print "HAS_STACK_ARG_LOAD"
    if (has_weather_text_ref) print "HAS_WEATHER_TEXT_REF"
    if (has_dst_setup) print "HAS_DST_SETUP"
    if (has_copy_read) print "HAS_COPY_READ"
    if (has_copy_write) print "HAS_COPY_WRITE"
    if (has_tst_or_bne_loop) print "HAS_COPY_LOOP_TEST"
    if (has_rts) print "HAS_RTS"
}
