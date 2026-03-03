BEGIN {
    has_loop_seed = 0
    has_decode_call = 0
    has_cmp4 = 0
    has_cmp1c = 0
    has_table_a = 0
    has_table_b = 0
    has_anchor_a = 0
    has_anchor_b = 0
    has_tail_a = 0
    has_tail_b = 0
    has_d3_step = 0
    has_dbf = 0
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

    if (u ~ /^MOVEQ #7,D4$/ || u ~ /^MOVE\.[WL] #7,D4$/) has_loop_seed = 1
    if (u ~ /ESQSHARED4_DECODERGBNIBBLETRIPLET/) has_decode_call = 1
    if (u ~ /^CMPI\.[WL] #4,D3$/ || u ~ /^CMP\.[WL] #4,D3$/) has_cmp4 = 1
    if (u ~ /^CMPI\.[WL] #\$?1C,D3$/ || u ~ /^CMP\.[WL] #28,D3$/) has_cmp1c = 1

    if (u ~ /^MOVE\.W D0,0\(A2,D3\.W\)$/) has_table_a = 1
    if (u ~ /^MOVE\.W D0,0\(A3,D3\.W\)$/) has_table_b = 1

    if (u ~ /ESQ_BANNERCOLORSWEEPPROGRAMA_ANCHORCOLORWORD/) has_anchor_a = 1
    if (u ~ /ESQ_BANNERCOLORSWEEPPROGRAMB_ANCHORCOLORWORD/) has_anchor_b = 1
    if (u ~ /ESQ_BANNERCOLORSWEEPPROGRAMA_TAILCOLORWORD/) has_tail_a = 1
    if (u ~ /ESQ_BANNERCOLORSWEEPPROGRAMB_TAILCOLORWORD/) has_tail_b = 1

    if (u ~ /^ADDQ\.[WL] #4,D3$/ || u ~ /^ADDI\.[WL] #4,D3$/) has_d3_step = 1
    if (u ~ /^DBF D4,/) has_dbf = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LOOP_SEED=" has_loop_seed
    print "HAS_DECODE_CALL=" has_decode_call
    print "HAS_CMP4=" has_cmp4
    print "HAS_CMP1C=" has_cmp1c
    print "HAS_TABLE_A=" has_table_a
    print "HAS_TABLE_B=" has_table_b
    print "HAS_ANCHOR_A=" has_anchor_a
    print "HAS_ANCHOR_B=" has_anchor_b
    print "HAS_TAIL_A=" has_tail_a
    print "HAS_TAIL_B=" has_tail_b
    print "HAS_D3_STEP=" has_d3_step
    print "HAS_DBF=" has_dbf
    print "HAS_RTS=" has_rts
}
