BEGIN {
    has_entry = 0
    has_empty_return49 = 0
    has_primary_setup = 0
    has_secondary_setup = 0
    has_mode_next = 0
    has_mode_prev = 0
    has_mode_prev_before = 0
    has_blocked_fallback = 0
    has_input_parse = 0
    has_slot_loop = 0
    has_title_guard = 0
    has_mask_guard = 0
    has_selection_guard = 0
    has_token_gate = 0
    has_quoted_exact = 0
    has_substring = 0
    has_restore_entry = 0
    has_restore_input = 0
    has_return_slot = 0
    has_rts = 0
    prev1 = ""
    prev2 = ""
    prev3 = ""
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_FINDENTRYMATCHINDEX:/ || u ~ /^TEXTDISP_FINDENTRYMATCHINDE[A-Z0-9_]*:/) has_entry = 1

    if ((u ~ /TST\.B \(A0\)/ || u ~ /MOVE\.B \(A5\),D0/) &&
        (u ~ /MOVEQ(\.L)? #\$31,D0/ || prev1 ~ /MOVEQ(\.L)? #\$31,D0/ || prev2 ~ /MOVEQ(\.L)? #49,D0/)) {
        has_empty_return49 = 1
    }

    if ((u ~ /PEA 1\.W/ || u ~ /MOVE\.L D5,-\(A7\)/) &&
        (u ~ /(JSR|BSR).*GETENTRYAUXPOINTERBYMODE/ || u ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/ ||
         prev1 ~ /(JSR|BSR).*GETENTRYAUXPOINTERBYMODE/ || prev1 ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/)) {
        has_primary_setup = 1
    }
    if ((u ~ /PEA 2\.W/ || u ~ /MOVE\.L \$94\(A7\),-\(A7\)/ || u ~ /MOVE\.L \$9C\(A7\),\(A7\)/) &&
        (u ~ /(JSR|BSR).*GETENTRYAUXPOINTERBYMODE/ || u ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/ ||
         prev1 ~ /(JSR|BSR).*GETENTRYAUXPOINTERBYMODE/ || prev1 ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/)) {
        has_secondary_setup = 1
    }

    if ((u ~ /CLOCK_HALFHOURSLOTINDEX/ || prev1 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
        (u ~ /ADDQ\.L #\$1,D[01]/ || u ~ /ADDQ\.L #1,D[01]/)) {
        has_mode_next = 1
    }
    if ((u ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || u ~ /DISPLIB_FINDPREVIOUSVALIDENTRYIN/) &&
        !(prev1 ~ /SUBQ\.[LW] #\$1,D[01]/ || prev1 ~ /SUBQ\.[LW] #1,D[01]/)) {
        has_mode_prev = 1
    }
    if ((u ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || u ~ /DISPLIB_FINDPREVIOUSVALIDENTRYIN/) &&
        (prev1 ~ /SUBQ\.[LW] #\$1,D[01]/ || prev1 ~ /SUBQ\.[LW] #1,D[01]/ ||
         prev2 ~ /SUBQ\.[LW] #\$1,D[01]/ || prev2 ~ /SUBQ\.[LW] #1,D[01]/)) {
        has_mode_prev_before = 1
    }
    if ((u ~ /BTST #7,7\(A3,D5\.W\)/ || u ~ /AND\.B \$78\(A7\),D0/ || u ~ /AND\.B D1,D2/) &&
        (u ~ /CLOCK_HALFHOURSLOTINDEX/ || prev1 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/ ||
         prev3 ~ /CLOCK_HALFHOURSLOTINDEX/)) {
        has_blocked_fallback = 1
    }

    if ((u ~ /(JSR|BSR).*TEXTDISP_FINDCONTROLTOKEN/ || u ~ /TEXTDISP_FINDCONTROLTOKEN/) &&
        (u ~ /(JSR|BSR).*TEXTDISP_FINDQUOTEDSPAN/ || prev1 ~ /(JSR|BSR).*TEXTDISP_FINDQUOTEDSPAN/ ||
         prev2 ~ /(JSR|BSR).*TEXTDISP_FINDQUOTEDSPAN/ || u ~ /TEXTDISP_FINDQUOTEDSPAN/)) {
        has_input_parse = 1
    }

    if (u ~ /CMP\.W D0,D5/ || u ~ /CMP\.L \$80\(A7\),D0/ || u ~ /BGE\.W .*RESTOREINPUTCHAR/) has_slot_loop = 1
    if (u ~ /TST\.L 56\(A3,D0\.L\)/ || u ~ /TST\.L \$38\(A3,D1\.L\)/) has_title_guard = 1
    if ((u ~ /AND\.B D6,D0/ || u ~ /AND\.B D1,D2/) &&
        (u ~ /CMP\.B D6,D0/ || prev1 ~ /CMP\.B D6,D0/ || u ~ /CMP\.B D1,D2/ || prev1 ~ /CMP\.B D1,D2/)) {
        has_mask_guard = 1
    }
    if ((u ~ /(JSR|BSR).*ESQ_TESTBIT1BASED/ || u ~ /ESQ_TESTBIT1BASED/) &&
        (u ~ /ADDQ\.L #1,D0/ || prev1 ~ /ADDQ\.L #1,D0/ || u ~ /CMP\.L \$34\(A7\),D0/ || prev1 ~ /CMP\.L \$34\(A7\),D0/)) {
        has_selection_guard = 1
    }

    if ((u ~ /TST\.L -52\(A5\)/ || u ~ /TST\.L \$70\(A7\)/) &&
        (u ~ /CMP\.B \(A0\),D1/ || u ~ /CMP\.B \(A1\),D1/ || prev1 ~ /CMP\.B \(A0\),D1/ || prev1 ~ /CMP\.B \(A1\),D1/)) {
        has_token_gate = 1
    }

    if ((u ~ /TST\.L -26\(A5\)/ || u ~ /TST\.L \$5C\(A7\)/) &&
        (u ~ /TST\.L -30\(A5\)/ || prev1 ~ /TST\.L -30\(A5\)/ || u ~ /TST\.L \$58\(A7\)/ || prev1 ~ /TST\.L \$58\(A7\)/) &&
        (u ~ /STRING_COMPARENOCASE/ || u ~ /STRINGCOMPARENOCASE/ || prev1 ~ /STRING_COMPARENOCASE/ || prev1 ~ /STRINGCOMPARENOCASE/) &&
        (u ~ /CMP\.L D0,D1/ || prev1 ~ /CMP\.L D0,D1/ || prev2 ~ /CMP\.L D0,D1/)) {
        has_quoted_exact = 1
    }

    if ((u ~ /TST\.L -26\(A5\)/ || u ~ /TST\.L \$5C\(A7\)/) &&
        (u ~ /ESQ_FINDSUBSTRINGCASEFOLD/ || u ~ /FINDSUBSTRINGCASEFOLD/ || prev1 ~ /ESQ_FINDSUBSTRINGCASEFOLD/ || prev1 ~ /FINDSUBSTRINGCASEFOLD/) &&
        (u ~ /CMP\.L D0,D1/ || prev1 ~ /CMP\.L D0,D1/ || prev2 ~ /CMP\.L D0,D1/)) {
        has_substring = 1
    }

    if ((u ~ /MOVE\.B -40\(A5\),D0/ || u ~ /MOVE\.B \$38\(A7\),\(A0\)/ || u ~ /MOVE\.B \$40\(A7\),\(A0\)/) &&
        (u ~ /MOVEA\.L -38\(A5\),A0/ || prev1 ~ /MOVEA\.L -38\(A5\),A0/ || u ~ /MOVE\.L \$60\(A7\),A0/ || prev1 ~ /MOVE\.L \$60\(A7\),A0/)) {
        has_restore_entry = 1
    }
    if ((u ~ /MOVE\.B -39\(A5\),D0/ || u ~ /MOVE\.B \$40\(A7\),D0/ || u ~ /MOVE\.B \$40\(A7\),\(A0\)/) &&
        (u ~ /MOVEA\.L -34\(A5\),A0/ || prev1 ~ /MOVEA\.L -34\(A5\),A0/ || u ~ /MOVE\.L \$6C\(A7\),A0/ || prev1 ~ /MOVE\.L \$6C\(A7\),A0/)) {
        has_restore_input = 1
    }
    if ((u ~ /MOVE\.L D5,D0/ || u ~ /MOVE\.L \$4C\(A7\),D0/) &&
        (prev1 ~ /MOVE\.B .*\,\(A0\)/ || prev2 ~ /MOVE\.B .*\,\(A0\)/)) {
        has_return_slot = 1
    }
    if (u == "RTS") has_rts = 1

    prev3 = prev2
    prev2 = prev1
    prev1 = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_EMPTY_RETURN49=" has_empty_return49
    print "HAS_PRIMARY_SETUP=" has_primary_setup
    print "HAS_SECONDARY_SETUP=" has_secondary_setup
    print "HAS_MODE_NEXT=" has_mode_next
    print "HAS_MODE_PREV=" has_mode_prev
    print "HAS_MODE_PREV_BEFORE=" has_mode_prev_before
    print "HAS_BLOCKED_FALLBACK=" has_blocked_fallback
    print "HAS_INPUT_PARSE=" has_input_parse
    print "HAS_SLOT_LOOP=" has_slot_loop
    print "HAS_TITLE_GUARD=" has_title_guard
    print "HAS_MASK_GUARD=" has_mask_guard
    print "HAS_SELECTION_GUARD=" has_selection_guard
    print "HAS_TOKEN_GATE=" has_token_gate
    print "HAS_QUOTED_EXACT=" has_quoted_exact
    print "HAS_SUBSTRING=" has_substring
    print "HAS_RESTORE_ENTRY=" has_restore_entry
    print "HAS_RESTORE_INPUT=" has_restore_input
    print "HAS_RETURN_SLOT=" has_return_slot
    print "HAS_RTS=" has_rts
}
