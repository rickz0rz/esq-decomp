BEGIN {
    has_entry = 0
    has_read_serial = 0
    has_clear_preamble = 0

    saw_sync_55 = 0
    saw_sync_aa = 0
    saw_preamble55_ref = 0
    saw_armed_ref = 0
    has_sync_flow = 0

    saw_select_match = 0
    saw_status_refresh = 0
    saw_transfer_arm = 0
    saw_verify_record = 0
    saw_verify_list = 0
    has_select_flow = 0

    saw_replace_owned = 0
    saw_program_info_parse = 0
    saw_reverse_bits = 0
    saw_test_bit = 0
    saw_parse_digit = 0
    saw_copy_label = 0
    saw_line_head_tail = 0
    has_dispatch_family = 0

    saw_status_packet = 0
    saw_rtc_apply = 0
    saw_clear_primary = 0
    has_status_flow = 0

    saw_font_command = 0
    saw_group_record = 0
    saw_version_overlay = 0
    saw_parse_config = 0
    saw_save_config = 0
    saw_filter_state = 0
    saw_banner_command = 0
    saw_banner_sized_text = 0
    saw_type_record = 0
    saw_cmd_options = 0
    saw_cmd_string = 0
    saw_ppv_command = 0
    has_config_flow = 0

    saw_transfer_handler = 0
    saw_persist_state = 0
    saw_reset_overlay = 0
    saw_aligned_listing = 0
    saw_banner_entry = 0
    saw_diagnostics = 0
    saw_boxoff_persist_flag = 0
    saw_boxoff_persist_call = 0
    saw_boxoff_selection_clear = 0
    saw_boxoff_status_clear = 0
    has_tail_flow = 0

    has_wait_for_clock = 0
    has_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAND:/ ||
        u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAN[A-Z0-9_]*:/ ||
        u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATC[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /READNEXTRBFBYTE/ || n ~ /READSERIALRBFBYTE/) {
        has_read_serial = 1
    }
    if (n ~ /WAITFORCLOCKCHANGEANDSER/ || n ~ /WAITFORCLOCKCHANGEANDSERVICEUI/) {
        has_wait_for_clock = 1
    }
    if (u == "RTS") {
        has_rts = 1
    }

    if (u ~ /#\$55/ || u ~ /#85([^0-9]|$)/) {
        saw_sync_55 = 1
    }
    if (u ~ /#\$AA/ || u ~ /#170([^0-9]|$)/) {
        saw_sync_aa = 1
    }
    if (n ~ /PREAMBLE55SEENFLAG/) {
        saw_preamble55_ref = 1
        has_clear_preamble = 1
    }
    if (n ~ /COMMANDPREAMBLEARMEDFLAG/) {
        saw_armed_ref = 1
        has_clear_preamble = 1
    }
    if (saw_sync_55 && saw_preamble55_ref && saw_armed_ref) {
        has_sync_flow = 1
    }

    if (n ~ /MATCHSELECTIONCODEWITH/) {
        saw_select_match = 1
    }
    if (n ~ /UPDATESTATUSMASKANDREFRE/) {
        saw_status_refresh = 1
    }
    if (n ~ /INTERACTIVETRANSFERARMED/) {
        saw_transfer_arm = 1
    }
    if (n ~ /VERIFYCHECKSUMANDPARSER/) {
        saw_verify_record = 1
    }
    if (n ~ /VERIFYCHECKSUMANDPARSEL/) {
        saw_verify_list = 1
    }
    if (saw_select_match && saw_status_refresh && saw_transfer_arm &&
        saw_verify_record && saw_verify_list) {
        has_select_flow = 1
    }

    if (n ~ /REPLACEOWNEDSTRING/) {
        saw_replace_owned = 1
    }
    if (n ~ /PARSEPROGRAMINFOCOMMANDRECORD/ || n ~ /PARSEPROGRAMINFOCOMM/) {
        saw_program_info_parse = 1
    }
    if (n ~ /REVERSEBITSIN6BYTES/) {
        saw_reverse_bits = 1
    }
    if (n ~ /TESTBIT1BASED/) {
        saw_test_bit = 1
    }
    if (n ~ /PARSEDIGITLABELANDDISPL/) {
        saw_parse_digit = 1
    }
    if (n ~ /COPYLABELTOGLOBAL/) {
        saw_copy_label = 1
    }
    if (n ~ /PARSELINEHEADTAILRECORD/) {
        saw_line_head_tail = 1
    }
    if (saw_replace_owned && saw_program_info_parse && saw_reverse_bits && saw_test_bit &&
        saw_parse_digit && saw_copy_label && saw_line_head_tail) {
        has_dispatch_family = 1
    }

    if (n ~ /APPLYINCOMINGSTATUSPACK/) {
        saw_status_packet = 1
    }
    if (n ~ /APPLYRTCBYTESANDPERSIST/) {
        saw_rtc_apply = 1
    }
    if (n ~ /CLEARPRIMARYENTRYFLAGS34/) {
        saw_clear_primary = 1
    }
    if (saw_status_packet && saw_rtc_apply && saw_clear_primary) {
        has_status_flow = 1
    }

    if (n ~ /HANDLEFONTCOMMAND/) {
        saw_font_command = 1
    }
    if (n ~ /PARSEGROUPRECORDANDREFRE/) {
        saw_group_record = 1
    }
    if (n ~ /SHOWVERSIONMISMATCHOVERL/) {
        saw_version_overlay = 1
    }
    if (n ~ /PARSECONFIGBUFFER/) {
        saw_parse_config = 1
    }
    if (n ~ /SAVECONFIGTOFILEHANDLE/) {
        saw_save_config = 1
    }
    if (n ~ /PARSEFILTERSTATEFROMBUF/) {
        saw_filter_state = 1
    }
    if (n ~ /HANDLEBANNERCOMMAND3233/) {
        saw_banner_command = 1
    }
    if (n ~ /READSERIALSIZEDTEXTRECORD/ || n ~ /READSERIALSIZEDTEXTREC/) {
        saw_banner_sized_text = 1
    }
    if (n ~ /PARSEANDSTORETYPERECORD/) {
        saw_type_record = 1
    }
    if (n ~ /PARSECOMMANDOPTIONS/) {
        saw_cmd_options = 1
    }
    if (n ~ /PARSECOMMANDSTRING/) {
        saw_cmd_string = 1
    }
    if (n ~ /PARSEPPVCOMMAND/) {
        saw_ppv_command = 1
    }
    if (saw_font_command && saw_group_record && saw_version_overlay &&
        saw_parse_config && saw_save_config && saw_filter_state &&
        saw_banner_command && saw_banner_sized_text &&
        saw_type_record && saw_cmd_options &&
        saw_cmd_string && saw_ppv_command) {
        has_config_flow = 1
    }

    if (n ~ /HANDLEINTERACTIVEFILETRA/) {
        saw_transfer_handler = 1
    }
    if (n ~ /PERSISTSTATEDATAAFTERCOM/) {
        saw_persist_state = 1
    }
    if (n ~ /DISPLAYTEXTATPOSITION/) {
        saw_reset_overlay = 1
    }
    if (n ~ /PARSEALIGNEDLISTINGBLOCK/) {
        saw_aligned_listing = 1
    }
    if (n ~ /PARSEBANNERENTRYDATA/) {
        saw_banner_entry = 1
    }
    if ((n ~ /READRBFBYTESTOBUFFER/ || n ~ /READRBFBYTESTOBUFF/) &&
        (u ~ /#\$100/ || u ~ /\(\$100\)/ || u ~ /#256([^0-9]|$)/ ||
         u ~ /PEA 256\.W/ || n ~ /256W/)) {
        saw_diagnostics = 1
    }
    if (n ~ /PERSISTONNEXTBOXOFFFLAG/) {
        saw_boxoff_persist_flag = 1
    }
    if (n ~ /PERSISTSTATEDATAAFTERCOM/) {
        saw_boxoff_persist_call = 1
    }
    if (n ~ /SELECTIONMATCHCODE/ && (n ~ /CLRW/ || n ~ /MOVEW0/)) {
        saw_boxoff_selection_clear = 1
    }
    if (n ~ /UPDATESTATUSMASKANDREFRE/) {
        saw_boxoff_status_clear = 1
    }
    if (saw_transfer_handler && saw_persist_state && saw_reset_overlay &&
        saw_aligned_listing && saw_banner_entry && saw_diagnostics &&
        saw_boxoff_persist_flag && saw_boxoff_persist_call &&
        saw_boxoff_selection_clear && saw_boxoff_status_clear) {
        has_tail_flow = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_SYNC_FLOW=" has_sync_flow
    print "HAS_SELECT_FLOW=" has_select_flow
    print "HAS_DISPATCH_FAMILY=" has_dispatch_family
    print "HAS_STATUS_FLOW=" has_status_flow
    print "HAS_CONFIG_FLOW=" has_config_flow
    print "HAS_TAIL_FLOW=" has_tail_flow
    print "HAS_WAIT_FOR_CLOCK=" has_wait_for_clock
    print "HAS_CLEAR_PREAMBLE=" has_clear_preamble
    print "HAS_RTS=" has_rts
}
