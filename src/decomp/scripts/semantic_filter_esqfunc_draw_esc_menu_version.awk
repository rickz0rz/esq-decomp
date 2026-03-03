BEGIN {
    has_entry = 0
    has_link = 0
    has_diag_clear = 0
    has_setapen_1 = 0
    has_setapen_call = 0
    has_setdrmd_1 = 0
    has_sprintf_build = 0
    has_display_build = 0
    has_rom_check = 0
    has_sprintf_rom = 0
    has_display_rom = 0
    has_setapen_3 = 0
    has_display_prompt = 0
    has_setapen_restore = 0
    has_unlk = 0
    has_rts = 0
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

    if (uline ~ /^ESQFUNC_DRAWESCMENUVERSION:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-84$/) has_link = 1
    if (uline ~ /^CLR\.W ED_DIAGNOSTICSSCREENACTIVE$/) has_diag_clear = 1
    if (uline ~ /^MOVEQ #1,D0$/) has_setapen_1 = 1
    if (uline ~ /LVOSETAPEN\(A6\)/) has_setapen_call = 1
    if (uline ~ /LVOSETDRMD\(A6\)/) has_setdrmd_1 = 1
    if (uline ~ /GLOBAL_STR_BUILD_NUMBER_FORMATTED/) has_sprintf_build = 1
    if (uline ~ /PEA 330\.W/) has_display_build = 1
    if (uline ~ /^CMP\.L GLOBAL_LONG_ROM_VERSION_CHECK,D0$/) has_rom_check = 1
    if (uline ~ /GLOBAL_STR_ROM_VERSION_FORMATTED/) has_sprintf_rom = 1
    if (uline ~ /PEA 360\.W/) has_display_rom = 1
    if (uline ~ /^MOVEQ #3,D0$/) has_setapen_3 = 1
    if (uline ~ /GLOBAL_STR_PUSH_ANY_KEY_TO_CONTINUE_1/) has_display_prompt = 1
    if (uline ~ /^MOVEQ #1,D0$/ && uline ~ /SETAPEN/) has_setapen_restore = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_DIAG_CLEAR=" has_diag_clear
    print "HAS_SETAPEN_1=" has_setapen_1
    print "HAS_SETAPEN_CALL=" has_setapen_call
    print "HAS_SETDRMD_1=" has_setdrmd_1
    print "HAS_SPRINTF_BUILD=" has_sprintf_build
    print "HAS_DISPLAY_BUILD=" has_display_build
    print "HAS_ROM_CHECK=" has_rom_check
    print "HAS_SPRINTF_ROM=" has_sprintf_rom
    print "HAS_DISPLAY_ROM=" has_display_rom
    print "HAS_SETAPEN_3=" has_setapen_3
    print "HAS_DISPLAY_PROMPT=" has_display_prompt
    print "HAS_SETAPEN_RESTORE=" has_setapen_restore
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
