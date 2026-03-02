BEGIN {
    label=0
    has_sec_flag=0
    has_sec_count=0
    has_prim_flag=0
    has_prim_count=0
    has_const0=0
    has_const1=0
    has_rts=0
}

/^NEWGRID_IsGridReadyForInput:$/ { label=1 }
/TEXTDISP_SecondaryGroupPresentFlag/ { has_sec_flag=1 }
/TEXTDISP_SecondaryGroupEntryCount/ { has_sec_count=1 }
/TEXTDISP_PrimaryGroupPresentFlag/ { has_prim_flag=1 }
/TEXTDISP_PrimaryGroupEntryCount/ { has_prim_count=1 }
/#\$00|#0([^0-9]|$)|\bCLR\./ { has_const0=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { has_const1=1 }
/^RTS$/ { has_rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (has_sec_flag) print "HAS_SECONDARY_FLAG"
    if (has_sec_count) print "HAS_SECONDARY_COUNT"
    if (has_prim_flag) print "HAS_PRIMARY_FLAG"
    if (has_prim_count) print "HAS_PRIMARY_COUNT"
    if (has_const0) print "HAS_CONST_0"
    if (has_const1) print "HAS_CONST_1"
    if (has_rts) print "HAS_RTS"
}
