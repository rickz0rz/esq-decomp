/^ESQFUNC_DrawEscMenuVersion:$/ {
    print
    next
}

{
    line = $0

    if (line ~ /CLR\.W ED_DiagnosticsScreenActive/) {
        print "clear_diag_flag"
        next
    }

    if (line ~ /MOVEQ(\.L)? #1,D0/ || line ~ /PEA \(\$1\)\.w/) {
        pending_value = "1"
        next
    }

    if (line ~ /MOVEQ #3,D0/ || line ~ /PEA \(\$3\)\.w/) {
        pending_value = "3"
        next
    }

    if (line ~ /_LVOSetAPen/) {
        print "set_apen_" pending_value
        next
    }

    if (line ~ /_LVOSetDrMd/) {
        print "set_drmd_" pending_value
        next
    }

    if (line ~ /Global_STR_BUILD_NUMBER_FORMATTE(D)?/) {
        pending_format = "build"
        next
    }

    if (line ~ /Global_STR_ROM_VERSION_FORMATTED/) {
        pending_format = "rom"
        next
    }

    if (line ~ /GROUP_AM_JMPTBL_WDISP_SPrintf/) {
        print "sprintf_" pending_format
        pending_display = pending_format
        next
    }

    if (line ~ /CMP\.L Global_LONG_ROM_VERSION_CHECK/ || line ~ /CMP\.L Global_LONG_ROM_VERSION_CHECK\(A4\)/) {
        print "check_rom_version"
        next
    }

    if (line ~ /Global_STR_ROM_VERSION_1_3/) {
        print "rom_string_1_3"
        next
    }

    if (line ~ /Global_STR_ROM_VERSION_2_04/) {
        print "rom_string_2_04"
        next
    }

    if (line ~ /Global_STR_PUSH_ANY_KEY_TO_CONTI(NUE_1)?/) {
        pending_display = "prompt"
        next
    }

    if (line ~ /ESQPARS_JMPTBL_DISPLIB_DisplayTe/ || line ~ /ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition/) {
        if (pending_display == "")
            pending_display = "unknown"
        print "display_" pending_display
        pending_display = ""
        next
    }

    if (line ~ /RTS$/) {
        print "RTS"
        next
    }
}
