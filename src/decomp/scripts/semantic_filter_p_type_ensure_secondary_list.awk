BEGIN {
    IGNORECASE=1
    label=0; clone=0; primary=0; secondary=0; typew=0; rts=0
}

/^P_TYPE_EnsureSecondaryList:$/ { label=1 }
/P_TYPE_CloneEntry/ { clone=1 }
/P_TYPE_PrimaryGroupListPtr/ { primary=1 }
/P_TYPE_SecondaryGroupListPtr/ { secondary=1 }
/TEXTDISP_SecondaryGroupCode|\(A0\)|type_byte/ { typew=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (clone) print "HAS_CLONE_CALL"
    if (primary) print "HAS_PRIMARY_ACCESS"
    if (secondary) print "HAS_SECONDARY_ACCESS"
    if (typew) print "HAS_TYPE_WRITE"
    if (rts) print "HAS_RTS"
}
