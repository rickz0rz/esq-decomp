BEGIN {
    step_count = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!(tag in seen)) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ESQ_TICKCLOCKANDFLAGEVENTS/) {
        mark("ENTRY")
    }

    if (uline ~ /^MOVE\.W (\$C|12)\(A[05]\),D0$/) {
        mark("LOAD_SECOND")
    }

    if (uline ~ /^CMP\.W D[34],D0$/ || uline ~ /^CMP\.W D[01],D1$/) {
        mark("SECOND_GUARD")
    }

    if (uline ~ /^SUB\.W D[34],(\$C|12)\(A[05]\)$/) {
        mark("ROLL_SECOND")
    }

    if (uline ~ /^MOVE\.W D0,(\$A|10)\(A[05]\)$/) {
        mark("STORE_MINUTE")
    }

    if (uline ~ /^CMPI?\.W #\$1E,D0$/ || uline ~ /^CMPI?\.W #30,D0$/ || uline ~ /^MOVEQ(\.L)? #\$1E,D[01]$/) {
        mark("CHECK_30")
    }

    if (uline ~ /^MOVEQ(\.L)? #\$?2,D[47]$/) {
        mark("STATUS2")
    }

    if ((uline ~ /^CMP\.W D[34],D0$/ || uline ~ /^CMP\.W D0,D1$/) && ("STORE_MINUTE" in seen)) {
        mark("CHECK_MINUTE_OVERFLOW")
    }

    if (uline ~ /CLOCK_MINUTETRIGGERBASEOFFSET/ && uline !~ /PLUS30/) {
        mark("CHECK_TRIGGER5_BASE")
    }

    if (uline ~ /CLOCK_MINUTETRIGGERBASEOFFSETPLUS30/ || uline ~ /CLOCK_MINUTETRIGGERBASEOFFSETPLU/) {
        mark("CHECK_TRIGGER5_HALF")
    }

    if (uline ~ /^MOVEQ(\.L)? #\$?5,D[47]$/) {
        mark("STATUS5")
    }

    if (uline ~ /^CMPI?\.W #20,D0$/ || uline ~ /^CMPI?\.W #\$14,D0$/ || uline ~ /^MOVEQ(\.L)? #\$14,D0$/) {
        mark("CHECK_20")
    }

    if (uline ~ /^CMPI?\.W #\$32,D0$/ || uline ~ /^CMPI?\.W #50,D0$/ || uline ~ /^MOVEQ(\.L)? #\$32,D0$/) {
        mark("CHECK_50")
    }

    if (uline ~ /^MOVEQ(\.L)? #\$?4,D[47]$/) {
        mark("STATUS4")
    }

    if (uline ~ /CLOCK_MINUTETRIGGER30MINUSBASE/) {
        mark("CHECK_TRIGGER3_BASE")
    }

    if (uline ~ /CLOCK_MINUTETRIGGER60MINUSBASE/) {
        mark("CHECK_TRIGGER3_ALT")
    }

    if (uline ~ /^MOVEQ(\.L)? #\$?3,D[47]$/) {
        mark("STATUS3")
    }

    if (uline ~ /^MOVE\.W D[26],(\$A|10)\(A[05]\)$/ || uline ~ /^CLR\.W (\$A|10)\(A[05]\)$/) {
        mark("RESET_MINUTE")
    }

    if (uline ~ /^MOVE\.W (\$8|8)\(A[05]\),D[01]$/) {
        mark("LOAD_HOUR")
    }

    if (uline ~ /^MOVE\.W D[01],(\$8|8)\(A[05]\)$/) {
        mark("STORE_HOUR")
    }

    if (uline ~ /^MOVEQ(\.L)? #(12|\$?C),D[03]$/ || uline ~ /^CMPI?\.W #(\$?C|12),D[01]$/ || uline ~ /^CMP\.W D0,D1$/ || uline ~ /^CMP\.W D3,D0$/) {
        mark("CHECK_12")
    }

    if (uline ~ /^MOVE\.W D[15],(\$8|8)\(A[05]\)$/) {
        mark("WRAP_HOUR_TO_ONE")
    }

    if (uline ~ /^EORI?\.W #\$?FFFF,(\$12|18)\(A[05]\)$/ || uline ~ /^EOR\.W #-1,(\$12|18)\(A[05]\)$/ || uline ~ /^NOT\.W (\$12|18)\(A[05]\)$/) {
        mark("TOGGLE_AMPM")
    }

    if (uline ~ /^MOVE\.W (\(A[05]\)|0\(A[05]\)),D0$/) {
        mark("LOAD_WEEKDAY")
    }

    if (uline ~ /^MOVE\.W D0,(\(A[05]\)|0\(A[05]\))$/) {
        mark("STORE_WEEKDAY")
    }

    if (uline ~ /^MOVEQ(\.L)? #\$?7,D3$/ || uline ~ /^SUBQ?\.W #\$?7,D0$/ || uline ~ /^CMPI?\.W #\$?7,D0$/) {
        mark("CHECK_WEEKDAY_WRAP")
    }

    if (uline ~ /^MOVE\.W D[26],(\(A[05]\)|0\(A[05]\))$/ || uline ~ /^CLR\.W (\(A[05]\)|0\(A[05]\))$/) {
        mark("WRAP_WEEKDAY")
    }

    if (uline ~ /^MOVE\.W (\$10|16)\(A[05]\),D0$/) {
        mark("LOAD_DAY_OF_YEAR")
    }

    if (uline ~ /^MOVE\.W D0,(\$10|16)\(A[05]\)$/) {
        mark("STORE_DAY_OF_YEAR")
    }

    if (uline ~ /^MOVE\.W #\$16E,D[13]$/ || uline ~ /^MOVE\.W #366,D[13]$/ || uline ~ /^MOVE\.W #\$16F,D[13]$/ || uline ~ /^MOVE\.W #367,D[13]$/) {
        mark("LOAD_YEAR_LIMIT")
    }

    if (uline ~ /^TST\.W (\$14|20)\(A[05]\)$/) {
        mark("TEST_LEAP_FLAG")
    }

    if (uline ~ /^ADD\.W D1,D3$/ || uline ~ /^ADD\.W D5,\$14\(A7\)$/ || uline ~ /^ADD\.W D5,D3$/) {
        mark("LEAP_LIMIT_BUMP")
    }

    if ((uline ~ /^CMP\.W D[13],D0$/ || uline ~ /^CMP\.W \$14\(A7\),D0$/) && ("LOAD_YEAR_LIMIT" in seen)) {
        mark("CHECK_DAY_OF_YEAR_LIMIT")
    }

    if (uline ~ /^MOVE\.W (\$6|6)\(A[05]\),D[01]$/) {
        mark("LOAD_YEAR")
    }

    if (uline ~ /^MOVE\.W D[15],(\$10|16)\(A[05]\)$/) {
        mark("RESET_DAY_OF_YEAR")
    }

    if (uline ~ /^MOVE\.W D[01],(\$6|6)\(A[05]\)$/) {
        mark("STORE_YEAR")
    }

    if (uline ~ /^ANDI\.W #(\$?3),D[01]$/) {
        mark("TEST_YEAR_MOD4")
    }

    if (uline ~ /^MOVE\.W #\(-1\),D1$/ || uline ~ /^MOVEQ(\.L)? #-1,D1$/ || uline ~ /^MOVE\.W #\$FFFFFFFF,(\$14|20)\(A[05]\)$/) {
        mark("SET_LEAP_TRUE")
    }

    if (uline ~ /^MOVE\.W D1,(\$14|20)\(A[05]\)$/ || uline ~ /^MOVE\.W D6,\$14\(A5\)$/) {
        mark("STORE_LEAP_FLAG")
    }

    if (uline ~ /ESQ_UPDATEMONTHDAYFROMDAYOFYEAR/) {
        mark("CALL_UPDATE_MONTH_DAY")
    }

    if (uline ~ /^MOVE\.W D[47],D0$/) {
        mark("RETURN_STATUS")
    }

    if (uline == "RTS") {
        mark("RTS")
    }
}

END {
    split("ENTRY LOAD_SECOND SECOND_GUARD ROLL_SECOND STORE_MINUTE CHECK_30 STATUS2 CHECK_MINUTE_OVERFLOW CHECK_TRIGGER5_BASE CHECK_TRIGGER5_HALF STATUS5 CHECK_20 CHECK_50 STATUS4 CHECK_TRIGGER3_BASE CHECK_TRIGGER3_ALT STATUS3 RESET_MINUTE LOAD_HOUR STORE_HOUR CHECK_12 WRAP_HOUR_TO_ONE TOGGLE_AMPM LOAD_WEEKDAY STORE_WEEKDAY CHECK_WEEKDAY_WRAP WRAP_WEEKDAY LOAD_DAY_OF_YEAR STORE_DAY_OF_YEAR LOAD_YEAR_LIMIT TEST_LEAP_FLAG LEAP_LIMIT_BUMP CHECK_DAY_OF_YEAR_LIMIT LOAD_YEAR STORE_YEAR RESET_DAY_OF_YEAR TEST_YEAR_MOD4 SET_LEAP_TRUE STORE_LEAP_FLAG CALL_UPDATE_MONTH_DAY RETURN_STATUS RTS", order, " ")
    idx = 0
    for (i = 1; i <= length(order); i++) {
        if (order[i] in seen) {
            idx++
            print idx ":" order[i]
        }
    }
}
