BEGIN {
    has_diwstrt = 0
    has_diwstop = 0
    has_ddfstrt = 0
    has_ddfstop = 0
    has_bpl1mod = 0
    has_bpl2mod = 0
    has_palette_call = 0
    has_ptr_list_a = 0
    has_ptr_list_b = 0
    has_jump_a = 0
    has_jump_b = 0
    has_vposr = 0
    has_cop1lch = 0
    has_copjmp1 = 0
    has_dmacon_20 = 0
    has_dmacon_8180 = 0
    has_rts = 0
}

function trim(s,    t) {
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

    if (u ~ /DIWSTRT/) has_diwstrt = 1
    if (u ~ /DIWSTOP/) has_diwstop = 1
    if (u ~ /DDFSTRT/) has_ddfstrt = 1
    if (u ~ /DDFSTOP/) has_ddfstop = 1
    if (u ~ /BPL1MOD/) has_bpl1mod = 1
    if (u ~ /BPL2MOD/) has_bpl2mod = 1

    if (u ~ /ESQSHARED4_LOADDEFAULTPALETTETOCOPPER_NOOP/) has_palette_call = 1

    if (u ~ /ESQ_COPPEREFFECTLISTA_PTRLOWORD/ || u ~ /ESQ_COPPEREFFECTLISTA_PTRHIWORD/) has_ptr_list_a = 1
    if (u ~ /ESQ_COPPEREFFECTLISTB_PTRLOWORD/ || u ~ /ESQ_COPPEREFFECTLISTB_PTRHIWORD/) has_ptr_list_b = 1
    if (u ~ /ESQ_COPPEREFFECTJUMPTARGETA_LOWORD/ || u ~ /ESQ_COPPEREFFECTJUMPTARGETA_HIWORD/) has_jump_a = 1
    if (u ~ /ESQ_COPPEREFFECTJUMPTARGETB_LOWORD/ || u ~ /ESQ_COPPEREFFECTJUMPTARGETB_HIWORD/) has_jump_b = 1

    if (u ~ /VPOSR/) has_vposr = 1
    if (u ~ /COP1LCH/) has_cop1lch = 1
    if (u ~ /COPJMP1/) has_copjmp1 = 1

    if (u ~ /DMACON/ && (u ~ /#\$?20/ || u ~ /#32/)) has_dmacon_20 = 1
    if (u ~ /DMACON/ && (u ~ /#\$?8180/ || u ~ /#33152/ || u ~ /#-32384/)) has_dmacon_8180 = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_DIWSTRT=" has_diwstrt
    print "HAS_DIWSTOP=" has_diwstop
    print "HAS_DDFSTRT=" has_ddfstrt
    print "HAS_DDFSTOP=" has_ddfstop
    print "HAS_BPL1MOD=" has_bpl1mod
    print "HAS_BPL2MOD=" has_bpl2mod
    print "HAS_PALETTE_CALL=" has_palette_call
    print "HAS_PTR_LIST_A=" has_ptr_list_a
    print "HAS_PTR_LIST_B=" has_ptr_list_b
    print "HAS_JUMP_A=" has_jump_a
    print "HAS_JUMP_B=" has_jump_b
    print "HAS_VPOSR=" has_vposr
    print "HAS_COP1LCH=" has_cop1lch
    print "HAS_COPJMP1=" has_copjmp1
    print "HAS_DMACON_20=" has_dmacon_20
    print "HAS_DMACON_8180=" has_dmacon_8180
    print "HAS_RTS=" has_rts
}
