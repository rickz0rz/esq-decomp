BEGIN {
    has_entry = 0
    has_defaults = 0
    has_copy_pad = 0
    has_parse_long = 0
    has_charclass_ref = 0
    has_parse_hex = 0
    has_replace_owned = 0
    has_load_command = 0
    has_workflow_ref = 0
    has_cycle_ref = 0
    has_force_mode5_ref = 0
    has_return = 0
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

    if (u ~ /^GCOMMAND_PARSECOMMANDOPTIONS[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "FLIB2_LOADDIGITALNICHEDEFAULTS") > 0) has_defaults = 1
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0 || index(u, "STRING_COPYPADNUL") > 0 || index(u, "STRING_COPYPAD") > 0) has_copy_pad = 1
    if (index(u, "ESQPARS_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(u, "ESQPARS_JMPTBL_PARSE_READSIGNE") > 0 || index(u, "PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 || index(u, "PARSE_READSIGNEDLONGSKIPCL") > 0) has_parse_long = 1

    if (index(u, "WDISP_CHARCLASSTABLE") > 0) has_charclass_ref = 1
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) has_parse_hex = 1

    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) has_replace_owned = 1
    if (index(u, "GCOMMAND_LOADCOMMANDFILE") > 0) has_load_command = 1

    if (index(u, "GCOMMAND_NICHEWORKFLOWMODE") > 0) has_workflow_ref = 1
    if (index(u, "GCOMMAND_NICHEMODECYCLECOUNT") > 0) has_cycle_ref = 1
    if (index(u, "GCOMMAND_NICHEFORCEMODE5FLAG") > 0) has_force_mode5_ref = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_COPY_PAD=" has_copy_pad
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_CHARCLASS_REF=" has_charclass_ref
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_LOAD_COMMAND=" has_load_command
    print "HAS_WORKFLOW_REF=" has_workflow_ref
    print "HAS_CYCLE_REF=" has_cycle_ref
    print "HAS_FORCE_MODE5_REF=" has_force_mode5_ref
    print "HAS_RETURN=" has_return
}
