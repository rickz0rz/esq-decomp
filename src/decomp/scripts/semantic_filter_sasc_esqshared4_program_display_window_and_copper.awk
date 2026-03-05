BEGIN {
    has_entry = 0
    has_diwstrt = 0
    has_diwstop = 0
    has_ddfstrt = 0
    has_ddfstop = 0
    has_bplmod = 0
    has_call_palette = 0
    has_list_ptr_a = 0
    has_list_ptr_b = 0
    has_jump_a = 0
    has_jump_b = 0
    has_vposr = 0
    has_cop1lch = 0
    has_dmacon_20 = 0
    has_dmacon_8180 = 0
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

    if (uline ~ /^ESQSHARED4_PROGRAMDISPLAYWINDOWANDCOPPER:/ || uline ~ /^ESQSHARED4_PROGRAMDISPLAYWINDOWA[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "DIWSTRT") > 0 || uline ~ /#(\$)?1761/) has_diwstrt = 1
    if (index(uline, "DIWSTOP") > 0 || uline ~ /#(\$)?FFC5/) has_diwstop = 1
    if (index(uline, "DDFSTRT") > 0 || uline ~ /#(\$)?38/) has_ddfstrt = 1
    if (index(uline, "DDFSTOP") > 0 || uline ~ /#(\$)?D0/) has_ddfstop = 1
    if (index(uline, "BPL1MOD") > 0 || index(uline, "BPL2MOD") > 0 || uline ~ /#(\$)?58/) has_bplmod = 1
    if (index(uline, "ESQSHARED4_LOADDEFAULTPALETTETOCOPPER_NOOP") > 0 || index(uline, "LOADDEFAULTPALETTETOCOPPER") > 0 || index(uline, "LOADDEFAULTPALETTETOC") > 0) has_call_palette = 1
    if (index(uline, "ESQ_COPPEREFFECTLISTA_PTRLOWORD") > 0 || index(uline, "ESQ_COPPEREFFECTLISTA_PTRHIWORD") > 0 || index(uline, "ESQ_COPPEREFFECTLISTA_P") > 0) has_list_ptr_a = 1
    if (index(uline, "ESQ_COPPEREFFECTLISTB_PTRLOWORD") > 0 || index(uline, "ESQ_COPPEREFFECTLISTB_PTRHIWORD") > 0 || index(uline, "ESQ_COPPEREFFECTLISTB_P") > 0) has_list_ptr_b = 1
    if (index(uline, "ESQ_COPPEREFFECTJUMPTARGETA_LOWORD") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETA_HIWORD") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETA_LOWO") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETA_HIWO") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETA") > 0) has_jump_a = 1
    if (index(uline, "ESQ_COPPEREFFECTJUMPTARGETB_LOWORD") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETB_HIWORD") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETB_LOWO") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETB_HIWO") > 0 || index(uline, "ESQ_COPPEREFFECTJUMPTARGETB") > 0) has_jump_b = 1
    if (index(uline, "VPOSR") > 0) has_vposr = 1
    if (index(uline, "COP1LCH") > 0) has_cop1lch = 1
    if (index(uline, "DMACON") > 0 && (uline ~ /#(\$)?20/ || uline ~ /#32/)) has_dmacon_20 = 1
    if (index(uline, "DMACON") > 0 && (uline ~ /#(\$)?8180/ || uline ~ /#33152/)) has_dmacon_8180 = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DIWSTRT=" has_diwstrt
    print "HAS_DIWSTOP=" has_diwstop
    print "HAS_DDFSTRT=" has_ddfstrt
    print "HAS_DDFSTOP=" has_ddfstop
    print "HAS_BPLMOD=" has_bplmod
    print "HAS_CALL_PALETTE=" has_call_palette
    print "HAS_LIST_PTR_A=" has_list_ptr_a
    print "HAS_LIST_PTR_B=" has_list_ptr_b
    print "HAS_JUMP_A=" has_jump_a
    print "HAS_JUMP_B=" has_jump_b
    print "HAS_VPOSR=" has_vposr
    print "HAS_COP1LCH=" has_cop1lch
    print "HAS_DMACON_20=" has_dmacon_20
    print "HAS_DMACON_8180=" has_dmacon_8180
    print "HAS_RTS=" has_rts
}
