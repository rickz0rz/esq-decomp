BEGIN {
    has_entry = 0
    has_defaults = 0
    has_copy_pad = 0
    has_parse_long = 0
    has_charclass_ref = 0
    has_casefold_bit1 = 0
    has_hexclass_bit7 = 0
    has_null_check = 0
    has_empty_check = 0
    has_tail_compare = 0
    has_tail_test = 0
    has_load_command = 0
    has_parse_hex = 0
    has_replace_owned = 0
    has_workflow_ref = 0
    has_cycle_ref = 0
    has_force_mode5_ref = 0
    has_enabled_store = 0
    has_text_pen_store = 0
    has_frame_pen_store = 0
    has_layout_pen_store = 0
    has_row_pen_store = 0
    has_workflow_store = 0
    has_cycle_zero = 0
    has_force_one = 0
    has_cycle_store = 0
    has_force_clear = 0
    has_tail_replace_store = 0
    hex_parse_count = 0
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
    if (u ~ /^BTST #\$?1,/) has_casefold_bit1 = 1
    if (u ~ /^BTST #\$?7,/) has_hexclass_bit7 = 1
    if (u ~ /^MOVE\.L [A-Z0-9]+,D0$/ || index(u, "MOVE.L A3,D0") > 0 || index(u, "MOVE.L A5,D0") > 0) has_null_check = 1
    if (index(u, "TST.B (A3)") > 0 || index(u, "TST.B (A5)") > 0) has_empty_check = 1
    if (index(u, "CMP.L D7,D6") > 0 || index(u, "CMP.L D6,D5") > 0 || index(u, "CMP.L D6,D5") > 0) has_tail_compare = 1
    if (index(u, "TST.B (A0)") > 0 || index(u, "TST.B (A3)") > 0) has_tail_test = 1
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0 && u !~ /^XREF /) {
        has_parse_hex = 1
        hex_parse_count++
    }

    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTRI") > 0) has_replace_owned = 1
    if (index(u, "GCOMMAND_LOADCOMMANDFILE") > 0 &&
        (u ~ /^BSR\.W / || u ~ /^JSR /)) has_load_command = 1

    if (index(u, "GCOMMAND_NICHEWORKFLOWMODE") > 0) has_workflow_ref = 1
    if (index(u, "GCOMMAND_NICHEMODECYCLECOUNT") > 0) has_cycle_ref = 1
    if (index(u, "GCOMMAND_NICHEFORCEMODE5FLAG") > 0) has_force_mode5_ref = 1

    if (index(u, "GCOMMAND_DIGITALNICHEENABLEDFLAG") > 0 && index(u, "MOVE.B") == 1) has_enabled_store = 1
    if (index(u, "GCOMMAND_NICHETEXTPEN") > 0 && index(u, "MOVE.L") == 1) has_text_pen_store = 1
    if (index(u, "GCOMMAND_NICHEFRAMEPEN") > 0 && index(u, "MOVE.L") == 1) has_frame_pen_store = 1
    if (index(u, "GCOMMAND_NICHEEDITORLAYOUTPEN") > 0 && index(u, "MOVE.L") == 1) has_layout_pen_store = 1
    if (index(u, "GCOMMAND_NICHEEDITORROWPEN") > 0 && index(u, "MOVE.L") == 1) has_row_pen_store = 1
    if (index(u, "GCOMMAND_NICHEWORKFLOWMODE") > 0 && index(u, "MOVE.B") == 1) has_workflow_store = 1
    if ((index(u, "CLR.L GCOMMAND_NICHEMODECYCLECOUNT") > 0) ||
        (index(u, "MOVE.L D1,GCOMMAND_NICHEMODECYCLECOUNT") > 0 && last_line ~ /^MOVEQ #0,D1$/)) has_cycle_zero = 1
    if (index(u, "MOVE.L D0,GCOMMAND_NICHEFORCEMODE5FLAG") > 0 || index(u, "MOVE.L D0,GCOMMAND_NICHEFORCEMODE5FLAG(A4)") > 0) has_force_one = 1
    if (index(u, "GCOMMAND_NICHEMODECYCLECOUNT") > 0 &&
        index(u, "MOVE.L D4") == 1) has_cycle_store = 1
    if (index(u, "CLR.L GCOMMAND_NICHEFORCEMODE5FLAG") > 0) has_force_clear = 1
    if (index(u, "GCOMMAND_DIGITALNICHELISTINGSTEMPLATEPTR") > 0 ||
        index(u, "GCOMMAND_DIGITALNICHELISTINGSTEM") > 0) {
        if (index(u, "MOVE.L D0,") == 1) has_tail_replace_store = 1
    }

    if (u == "RTS") has_return = 1
    last_line = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEFAULTS=" has_defaults
    print "HAS_COPY_PAD=" has_copy_pad
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_CHARCLASS_REF=" has_charclass_ref
    print "HAS_CASEFOLD_BIT1=" has_casefold_bit1
    print "HAS_HEXCLASS_BIT7=" has_hexclass_bit7
    print "HAS_NULL_CHECK=" has_null_check
    print "HAS_EMPTY_CHECK=" has_empty_check
    print "HAS_TAIL_COMPARE=" has_tail_compare
    print "HAS_TAIL_TEST=" has_tail_test
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HEX_PARSE_COUNT=" hex_parse_count
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_LOAD_COMMAND=" has_load_command
    print "HAS_WORKFLOW_REF=" has_workflow_ref
    print "HAS_CYCLE_REF=" has_cycle_ref
    print "HAS_FORCE_MODE5_REF=" has_force_mode5_ref
    print "HAS_ENABLED_STORE=" has_enabled_store
    print "HAS_TEXT_PEN_STORE=" has_text_pen_store
    print "HAS_FRAME_PEN_STORE=" has_frame_pen_store
    print "HAS_LAYOUT_PEN_STORE=" has_layout_pen_store
    print "HAS_ROW_PEN_STORE=" has_row_pen_store
    print "HAS_WORKFLOW_STORE=" has_workflow_store
    print "HAS_CYCLE_ZERO=" has_cycle_zero
    print "HAS_FORCE_ONE=" has_force_one
    print "HAS_CYCLE_STORE=" has_cycle_store
    print "HAS_FORCE_CLEAR=" has_force_clear
    print "HAS_TAIL_REPLACE_STORE=" has_tail_replace_store
    print "HAS_RETURN=" has_return
}
