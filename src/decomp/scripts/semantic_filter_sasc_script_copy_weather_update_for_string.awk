BEGIN {
    has_weather_text_ref = 0
    has_rts = 0
}

{
    u = toupper($0)

    if (u ~ /GLOBAL_STR_WEATHER_UPDATE_FOR/) {
        has_weather_text_ref = 1
    }
    if (u ~ /^RTS$/) {
        has_rts = 1
    }
}

END {
    if (has_weather_text_ref) print "HAS_WEATHER_TEXT_REF"
    if (has_rts) print "HAS_RTS"
}
