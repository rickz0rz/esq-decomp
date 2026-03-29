BEGIN {
    has_label = 0

    saw_reset_ui_busy = 0
    saw_reset_parse_count = 0
    saw_reset_ctrl_count = 0
    saw_reset_primary_count = 0
    saw_reset_secondary_count = 0
    saw_reset_status_ready = 0
    saw_reset_mutation = 0
    saw_reset_serial_fill = 0
    saw_reset_data_errs = 0
    saw_reset_checksum_err = 0
    saw_reset_length_err = 0
    saw_reset_preamble = 0
    saw_reset_preamble55 = 0
    saw_reset_phase_shift = 0
    saw_reset_reset_armed = 0
    saw_reset_cached_checksum = 0
    saw_reset_secondary_present = 0

    has_seed_secondary_group = 0
    has_seed_phase = 0
    has_seed_half_hour = 0
    has_seed_ctrl_checksum = 0
    has_seed_banner_index = 0

    status_stage = 0
    status_reset_count = 0
    has_status_chain = 0

    library_stage = 0
    has_library_chain = 0

    font_stage = 0
    font_fallback_count = 0
    has_font_fallback_chain = 0

    serial_stage = 0
    serial_interrupt_count = 0
    has_serial_bootstrap = 0

    startup_banner_stage = 0
    startup_banner_draws = 0
    has_startup_banner_sequence = 0

    post_banner_stage = 0
    post_banner_ini_count = 0
    has_post_banner_load_sequence = 0

    availability_stage = 0
    availability_reset_count = 0
    has_availability_bootstrap = 0

    disable_stage = 0
    disable_reset_hits = 0
    has_disable_reset = 0

    ravesc_stage = 0
    has_ravesc_restore = 0

    loop_stage = 0
    shutdown_flag_refs = 0
    has_loop_flow = 0
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

    if (u ~ /^ESQ_MAININITANDRUN[A-Z0-9_]*:/) has_label = 1

    if (u ~ /GLOBAL_UIBUSYFLAG/) saw_reset_ui_busy = 1
    if (u ~ /ESQIFF_PARSEATTEMPTCOUNT/) saw_reset_parse_count = 1
    if (u ~ /SCRIPT_CTRLCMDCOUNT/) saw_reset_ctrl_count = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/) saw_reset_primary_count = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/) saw_reset_secondary_count = 1
    if (u ~ /ESQIFF_STATUSPACKETREADYFLAG/) saw_reset_status_ready = 1
    if (u ~ /TEXTDISP_GROUPMUTATIONSTATE/) saw_reset_mutation = 1
    if (u ~ /ESQ_SERIALRBFFILLLEVEL/) saw_reset_serial_fill = 1
    if (u ~ /DATACERRS/) saw_reset_data_errs = 1
    if (u ~ /SCRIPT_CTRLCMDCHECKSUMERRORCOUNT/) saw_reset_checksum_err = 1
    if (u ~ /SCRIPT_CTRLCMDLENGTHERRORCOUNT/) saw_reset_length_err = 1
    if (u ~ /ESQPARS_COMMANDPREAMBLEARMEDFLAG/) saw_reset_preamble = 1
    if (u ~ /ESQPARS_PREAMBLE55SEENFLAG/) saw_reset_preamble55 = 1
    if (u ~ /WDISP_BANNERCHARPHASESHIFT/) saw_reset_phase_shift = 1
    if (u ~ /ESQPARS_RESETARMEDFLAG/) saw_reset_reset_armed = 1
    if (u ~ /ESQIFF_USECACHEDCHECKSUMFLAG/) saw_reset_cached_checksum = 1
    if (u ~ /TEXTDISP_SECONDARYGROUPPRESENTFLAG/) saw_reset_secondary_present = 1

    if (u ~ /TEXTDISP_SECONDARYGROUPCODE/ && (u ~ /#1/ || u ~ /#\$1/)) has_seed_secondary_group = 1
    if (u ~ /ESQ_STARTUPPHASESEED225E/ && (u ~ /#7/ || u ~ /#\$7/)) has_seed_phase = 1
    if (u ~ /CLOCK_HALFHOURSLOTINDEX/ && (u ~ /#2/ || u ~ /#\$2/)) has_seed_half_hour = 1
    if (u ~ /SCRIPT_CTRL_CHECKSUM/ && (u ~ /#\$FF/ || u ~ /#255/)) has_seed_ctrl_checksum = 1
    if (u ~ /WDISP_BANNERCHARRANGESTART/ && u ~ /WDISP_BANNERCHARINDEX/) has_seed_banner_index = 1

    if (u ~ /GLOBAL_STR_GRAPHICS_LIBRARY/) {
        library_stage = advance_stage(library_stage, 1)
    }
    if (u ~ /GLOBAL_STR_DISKFONT_LIBRARY/) {
        library_stage = advance_stage(library_stage, 2)
    }
    if (u ~ /GLOBAL_STR_DOS_LIBRARY/) {
        library_stage = advance_stage(library_stage, 3)
    }
    if (u ~ /GLOBAL_STR_INTUITION_LIBRARY/) {
        library_stage = advance_stage(library_stage, 4)
    }
    if (u ~ /GLOBAL_STR_UTILITY_LIBRARY/) {
        library_stage = advance_stage(library_stage, 5)
    }
    if (u ~ /GLOBAL_STR_BATTCLOCK_RESOURCE/ && library_stage >= 5) {
        has_library_chain = 1
    }

    if (u ~ /GLOBAL_STRUCT_TEXTATTR_TOPAZ_FON/) {
        font_stage = advance_stage(font_stage, 1)
    }
    if (u ~ /GLOBAL_STRUCT_TEXTATTR_PREVUEC_F/) {
        font_stage = advance_stage(font_stage, 2)
    }
    if ((u ~ /GLOBAL_HANDLE_TOPAZ_FONT/ && u ~ /GLOBAL_HANDLE_PREVUEC_FONT/) ||
        (u ~ /GLOBAL_HANDLE_TOPAZ_FONT/ && u ~ /GLOBAL_HANDLE_H26F_FONT/) ||
        (u ~ /GLOBAL_HANDLE_TOPAZ_FONT/ && u ~ /GLOBAL_HANDLE_PREVUE_FONT/)) {
        font_fallback_count++
    }
    if (u ~ /GLOBAL_STRUCT_TEXTATTR_H26F_FONT/) {
        font_stage = advance_stage(font_stage, 3)
    }
    if (u ~ /GLOBAL_STRUCT_TEXTATTR_PREVUE_FO/) {
        font_stage = advance_stage(font_stage, 4)
    }
    if (font_stage >= 4 && font_fallback_count >= 3) {
        has_font_fallback_chain = 1
    }

    if (u ~ /SIGNAL_CREATEMSGPORTWITHSIGNAL/ || u ~ /CREATEMSGPORTWITHSIGNAL/) {
        serial_stage = advance_stage(serial_stage, 1)
    }
    if (u ~ /STRUCT_ALLOCWITHOWNER/ || u ~ /ALLOCWITHOWNER/) {
        serial_stage = advance_stage(serial_stage, 2)
    }
    if (u ~ /OPENDEVICE/ && serial_stage >= 2) {
        serial_stage = advance_stage(serial_stage, 3)
    }
    if (u ~ /DOIO/ && serial_stage >= 3) {
        serial_stage = advance_stage(serial_stage, 4)
    }
    if (u ~ /SETUP_INTERRUPT_INTB_RBF|SETUP_INTERRUPT_INTB_AUD1/) {
        serial_interrupt_count++
    }
    if (u ~ /SCRIPT_INITCTRLCONTEXT|INITCTRLCONTEXT/) {
        serial_stage = advance_stage(serial_stage, 5)
    }
    if (u ~ /KYBD_INITIALIZEINPUTDEVICES|INITIALIZEINPUTDEVICES/) {
        serial_stage = advance_stage(serial_stage, 6)
    }
    if (u ~ /ESQFUNC_ALLOCATELINETEXTBUFFERS|ALLOCATELINETEXTBUFFERS/) {
        if (serial_stage >= 6 && serial_interrupt_count >= 2) {
            has_serial_bootstrap = 1
        }
    }

    if (u ~ /WDISP_SPRINTF|SPRINTF/) {
        startup_banner_stage = advance_stage(startup_banner_stage, 1)
    }
    if (u ~ /PRIMEBANNERTRANSITIONFROMHEXCODE|PRIMEBANNERTRANSITIONFROM/) {
        startup_banner_stage = advance_stage(startup_banner_stage, 2)
    }
    if (u ~ /GCOMMAND_INITPRESETDEFAULTS|INITPRESETDEFAULTS/) {
        startup_banner_stage = advance_stage(startup_banner_stage, 3)
    }
    if (u ~ /GLOBAL_STR_DF0_GRADIENT_INI_2/) {
        startup_banner_stage = advance_stage(startup_banner_stage, 4)
    }
    if (u ~ /GCOMMAND_RESETBANNERFADESTATE|RESETBANNERFADESTATE/) {
        startup_banner_stage = advance_stage(startup_banner_stage, 5)
    }
    if (u ~ /ESQ_SELECTCODEBUFFER|ESQ_STARTUPVERSIONBANNERBUFFER|ESQ_STR_SYSTEMINITIALIZING|ESQ_STR_PLEASESTANDBYELLIPSIS/) {
        startup_banner_draws++
    }
    if (startup_banner_stage >= 5 && startup_banner_draws >= 4) {
        has_startup_banner_sequence = 1
    }

    if (u ~ /RUNCOPPERRISETRANSITION/) {
        post_banner_stage = advance_stage(post_banner_stage, 1)
    }
    if (u ~ /LADFUNC_ALLOCBANNERRECTENTRIES|ALLOCBANNERRECTENTRIES/) {
        post_banner_stage = advance_stage(post_banner_stage, 2)
    }
    if (u ~ /LADFUNC_CLEARBANNERRECTENTRIES|CLEARBANNERRECTENTRIES/) {
        post_banner_stage = advance_stage(post_banner_stage, 3)
    }
    if (u ~ /DISKIO2_RELOADDATAFILESANDREBUIL|RELOADDATAFILESANDREBUIL/) {
        post_banner_stage = advance_stage(post_banner_stage, 4)
    }
    if (u ~ /TEXTDISP_LOADSOURCECONFIG|LOADSOURCECONFIG/) {
        post_banner_stage = advance_stage(post_banner_stage, 5)
    }
    if (u ~ /GLOBAL_STR_DF0_DEFAULT_INI_1|GLOBAL_STR_DF0_BRUSH_INI_1|GLOBAL_STR_DF0_BANNER_INI_1/) {
        post_banner_ini_count++
    }
    if (u ~ /FLIB2_RESETANDLOADLISTINGTEMPLAT|RESETANDLOADLISTINGTEMPLAT/) {
        post_banner_stage = advance_stage(post_banner_stage, 6)
    }
    if (u ~ /LADFUNC_LOADTEXTADSFROMFILE|LOADTEXTADSFROMFILE/) {
        post_banner_stage = advance_stage(post_banner_stage, 7)
    }
    if (u ~ /LADFUNC_UPDATEHIGHLIGHTSTATE|UPDATEHIGHLIGHTSTATE/) {
        if (post_banner_stage >= 7 && post_banner_ini_count >= 3) {
            has_post_banner_load_sequence = 1
        }
    }

    if (u ~ /ESQDISP_UPDATESTATUSMASKANDREFRESH|UPDATESTATUSMASKANDREFRESH|UPDATESTATUSMASKANDREFRE/) {
        availability_stage = advance_stage(availability_stage, 1)
    }
    if (u ~ /P_TYPE_RESETLISTSANDLOADPROMOIDS|RESETLISTSANDLOADPROMOIDS/) {
        availability_stage = advance_stage(availability_stage, 2)
    }
    if (u ~ /LOCAVAIL_RESETFILTERSTATESTRUCT|RESETFILTERSTATESTRUCT/) {
        availability_reset_count++
        if (availability_stage >= 2 && availability_reset_count >= 2) {
            availability_stage = 3
        }
    }
    if (u ~ /LOCAVAIL_LOADAVAILABILITYDATAFIL|LOADAVAILABILITYDATAFIL/) {
        availability_stage = advance_stage(availability_stage, 4)
    }
    if (u ~ /DST_LOADBANNERPAIRFROMFILES|LOADBANNERPAIRFROMFILES/) {
        availability_stage = advance_stage(availability_stage, 5)
    }
    if (u ~ /ESQFUNC_UPDATEDISKWARNINGANDREFR|UPDATEDISKWARNINGANDREFR/) {
        if (availability_stage >= 5) {
            has_availability_bootstrap = 1
        }
    }

    if (u ~ /ESQDISP_UPDATESTATUSMASKANDREFRESH/ ||
        u ~ /UPDATESTATUSMASKANDREFRESH/ ||
        u ~ /UPDATESTATUSMASKANDREFRE/) {
        status_stage = advance_stage(status_stage, 1)
    }
    if (u ~ /P_TYPE_RESETLISTSANDLOADPROMOIDS/ || u ~ /RESETLISTSANDLOADPROMOIDS/) {
        status_stage = advance_stage(status_stage, 2)
    }
    if (u ~ /LOCAVAIL_RESETFILTERSTATESTRUCT/ || u ~ /RESETFILTERSTATESTRUCT/) {
        status_reset_count++
        if (status_stage >= 2 && status_reset_count >= 2) {
            has_status_chain = 1
        }
    }

    if (u ~ /_LVODISABLE/) {
        disable_stage = advance_stage(disable_stage, 1)
    }
    if (disable_stage >= 1 &&
        (u ~ /ESQ_SERIALRBFFILLLEVEL/ || u ~ /GLOBAL_WORD_MAX_VALUE/ ||
         u ~ /GLOBAL_WORD_T_VALUE/ || u ~ /GLOBAL_WORD_H_VALUE/)) {
        disable_reset_hits++
        if (disable_reset_hits >= 4 && disable_stage == 1) {
            disable_stage = 2
        }
    }
    if (u ~ /_LVOENABLE/ && disable_stage >= 2) {
        has_disable_reset = 1
    }

    if (u ~ /GLOBAL_WORD_SELECT_CODE_IS_RAVES/ &&
        (u ~ /TST\.W/ || u ~ /MOVE\.W/)) {
        ravesc_stage = advance_stage(ravesc_stage, 1)
    }
    if (u ~ /SETCOPPEREFFECT_ONENABLEHIGHLIGHT/ || u ~ /SETCOPPEREFFECT_ONENABLEHIGH/) {
        ravesc_stage = advance_stage(ravesc_stage, 2)
    }
    if (u ~ /TEXTDISP_SETRASTFORMODE/ || u ~ /TEXTDISP_SETRASTFORMOD/) {
        if (ravesc_stage >= 2) {
            has_ravesc_restore = 1
        }
    }

    if (u ~ /ESQ_MAINLOOPUITICKENABLEDFLAG/ && (u ~ /#1/ || u ~ /#\$1/)) {
        loop_stage = advance_stage(loop_stage, 1)
    }
    if (u ~ /ESQFUNC_SERVICEUITICKIFRUNNING/ || u ~ /SERVICEUITICKIFRUNN/) {
        loop_stage = advance_stage(loop_stage, 2)
    }
    if (u ~ /PARSEINI_MONITORCLOCKCHANGE/ || u ~ /MONITORCLOCKCHANGE/) {
        loop_stage = advance_stage(loop_stage, 3)
    }
    if (u ~ /ESQ_SHUTDOWNREQUESTEDFLAG/) {
        shutdown_flag_refs++
    }
    if (u ~ /ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAND/ || u ~ /CONSUMERBFBYTEANDDISPATC/) {
        loop_stage = advance_stage(loop_stage, 4)
    }
    if (u ~ /CLEANUP_SHUTDOWNSYSTEM/ || u ~ /SHUTDOWNSYSTEM/) {
        if (loop_stage >= 3 && shutdown_flag_refs >= 2) {
            has_loop_flow = 1
        }
    }
}

END {
    reset_count = 0
    reset_count += saw_reset_ui_busy
    reset_count += saw_reset_parse_count
    reset_count += saw_reset_ctrl_count
    reset_count += saw_reset_primary_count
    reset_count += saw_reset_secondary_count
    reset_count += saw_reset_status_ready
    reset_count += saw_reset_mutation
    reset_count += saw_reset_serial_fill
    reset_count += saw_reset_data_errs
    reset_count += saw_reset_checksum_err
    reset_count += saw_reset_length_err
    reset_count += saw_reset_preamble
    reset_count += saw_reset_preamble55
    reset_count += saw_reset_phase_shift
    reset_count += saw_reset_reset_armed
    reset_count += saw_reset_cached_checksum
    reset_count += saw_reset_secondary_present

    has_reset_cluster = (reset_count >= 15) ? 1 : 0
    has_seed_bundle = (has_seed_secondary_group &&
        has_seed_phase &&
        has_seed_half_hour &&
        has_seed_ctrl_checksum &&
        has_seed_banner_index) ? 1 : 0

    print "HAS_LABEL=" has_label
    print "HAS_RESET_CLUSTER=" has_reset_cluster
    print "HAS_SEED_BUNDLE=" has_seed_bundle
    print "HAS_STATUS_CHAIN=" has_status_chain
    print "HAS_LIBRARY_CHAIN=" has_library_chain
    print "HAS_FONT_FALLBACK_CHAIN=" has_font_fallback_chain
    print "HAS_SERIAL_BOOTSTRAP=" has_serial_bootstrap
    print "HAS_STARTUP_BANNER_SEQUENCE=" has_startup_banner_sequence
    print "HAS_POST_BANNER_LOAD_SEQUENCE=" has_post_banner_load_sequence
    print "HAS_AVAILABILITY_BOOTSTRAP=" has_availability_bootstrap
    print "HAS_DISABLE_RESET=" has_disable_reset
    print "HAS_RAVESC_RESTORE=" has_ravesc_restore
    print "HAS_LOOP_FLOW=" has_loop_flow
}
