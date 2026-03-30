BEGIN {
    has_entry = 0
    has_mode_table_seed = 0
    has_cycle_gate_setup = 0
    has_force_mode12 = 0
    has_countdown_decrement = 0
    has_candidate_fetch = 0
    has_candidate_wrap = 0
    has_group1_dispatch = 0
    has_group1_sources = 0
    has_group1_source_set = 0
    has_cycle_gate_fallback = 0
    has_group2_dispatch = 0
    has_group2_budget_workflow = 0
    has_group2_source_set = 0
    has_group2_case7 = 0
    has_return = 0

    mode_table_hits = 0
    const12_hits = 0
    countdown_hits = 0
    candidate_hits = 0
    group1_jump_hits = 0
    group2_jump_hits = 0
    budget_dec_hits = 0
    budget_reset_hits = 0
    group1_source_hits = 0
    group2_source_hits = 0
    has_group1_src_niche = 0
    has_group1_src_cfg_y = 0
    has_group1_src_cfg_static = 0
    has_group1_src_cfg_custom = 0
    has_group1_src_mplex = 0
    has_group1_src_ppv = 0
    has_group2_src_global = 0
    has_group2_src_y = 0
    has_group2_src_static = 0
    has_group2_src_custom = 0
    has_group2_src_mplex = 0
    has_group2_src_ppv = 0
    prev = ""
    prev2 = ""
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") {
        next
    }

    if (line ~ /^NEWGRID_SELECTNEXTMODE:/ || line ~ /^NEWGRID_SELECTNEXTMOD[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (line ~ /NEWGRID_MODESELECTIONTABLE/ || line ~ /NEWGRIDMODESELECTIONTABLE/) {
        mode_table_hits++
    }
    if ((line ~ /^DBF / && prev ~ /^\.(COPY_MODE_TABLE|COPY_MODE_TABL)/) ||
        mode_table_hits >= 2) {
        has_mode_table_seed = 1
    }

    if (line ~ /CONFIG_MODECYCLEENABLEDFLAG/ || line ~ /CONFIGMODECYCLEENABLEDFLAG/) {
        if (line ~ /#\$59/ || line ~ /#89/ || line ~ /#'Y'/ ||
            prev ~ /#\$59/ || prev ~ /#89/ || prev ~ /#'Y'/ ||
            prev2 ~ /#\$59/ || prev2 ~ /#89/ || prev2 ~ /#'Y'/) {
            has_cycle_gate_setup = 1
        }
    }
    if (line ~ /CONFIG_MODECYCLEGATEDURATION/ || line ~ /CONFIGMODECYCLEGATEDURATION/ ||
        line ~ /NEWGRID_MODECYCLECOUNTDOWN/ || line ~ /NEWGRIDMODECYCLECOUNTDOWN/) {
        countdown_hits++
    }
    if (countdown_hits >= 3) {
        has_cycle_gate_setup = 1
    }

    if (line ~ /#\$C/ || line ~ /#12([^0-9]|$)/ || line ~ /\(\$C\)\.W/ || line ~ /12\.W/) {
        const12_hits++
    }
    if (const12_hits >= 2) {
        has_force_mode12 = 1
    }

    if ((line ~ /SUBQ\.L #\$1,NEWGRID_MODECYCLECOUNTDOWN/ ||
         line ~ /SUBQ\.L #1,NEWGRID_MODECYCLECOUNTDOWN/ ||
         line ~ /SUBQ\.L #\$1,NEWGRIDMODECYCLECOUNTDOWN/ ||
         line ~ /SUBQ\.L #1,NEWGRIDMODECYCLECOUNTDOWN/ ||
         line ~ /NEWGRID_MODECYCLECOUNTDOWN -= 1/)) {
        has_countdown_decrement = 1
    }

    if (line ~ /NEWGRID_MODECANDIDATEINDEX/ || line ~ /NEWGRIDMODECANDIDATEINDEX/) {
        candidate_hits++
    }
    if (candidate_hits >= 4) {
        has_candidate_fetch = 1
    }
    if (line ~ /CLR\.L NEWGRID_MODECANDIDATEINDEX/ ||
        line ~ /CLR\.L NEWGRIDMODECANDIDATEINDEX/) {
        has_candidate_wrap = 1
    }
    if (line ~ /ADDQ\.L #\$1,NEWGRID_MODECANDIDATEINDEX/ ||
        line ~ /ADDQ\.L #1,NEWGRID_MODECANDIDATEINDEX/ ||
        line ~ /ADDQ\.L #\$1,NEWGRIDMODECANDIDATEINDEX/ ||
        line ~ /ADDQ\.L #1,NEWGRIDMODECANDIDATEINDEX/) {
        has_candidate_wrap = 1
    }

    if (line ~ /^JMP / && line ~ /\(PC,D0\.W\)/) {
        if (!has_group1_dispatch) {
            group1_jump_hits++
            has_group1_dispatch = 1
        } else {
            group2_jump_hits++
            has_group2_dispatch = 1
        }
    }
    if (group1_jump_hits >= 1 && group2_jump_hits >= 1) {
        has_group1_dispatch = 1
        has_group2_dispatch = 1
    }

    if (!has_group1_src_niche &&
        (line ~ /GCOMMAND_NICHEMODECYCLECOUNT/ || line ~ /GCOMMANDNICHEMODECYCLECOUNT/)) {
        has_group1_src_niche = 1
        group1_source_hits++
    }
    if (!has_group1_src_cfg_y &&
        (line ~ /CONFIG_NICHEMODECYCLEBUDGET_Y/ || line ~ /CONFIGNICHEMODECYCLEBUDGETY/)) {
        has_group1_src_cfg_y = 1
        group1_source_hits++
    }
    if (!has_group1_src_cfg_static &&
        (line ~ /CONFIG_NICHEMODECYCLEBUDGET_STA/ || line ~ /CONFIGNICHEMODECYCLEBUDGETSTA/ ||
         line ~ /CONFIG_NICHEMODECYCLEBUDGET_STATIC/ || line ~ /CONFIGNICHEMODECYCLEBUDGETSTATIC/)) {
        has_group1_src_cfg_static = 1
        group1_source_hits++
    }
    if (!has_group1_src_cfg_custom &&
        (line ~ /CONFIG_NICHEMODECYCLEBUDGET_CUS/ || line ~ /CONFIGNICHEMODECYCLEBUDGETCUS/ ||
         line ~ /CONFIG_NICHEMODECYCLEBUDGET_CUSTOM/ || line ~ /CONFIGNICHEMODECYCLEBUDGETCUSTOM/)) {
        has_group1_src_cfg_custom = 1
        group1_source_hits++
    }
    if (!has_group1_src_mplex &&
        (line ~ /GCOMMAND_MPLEXMODECYCLECOUNT/ || line ~ /GCOMMANDMPLEXMODECYCLECOUNT/)) {
        has_group1_src_mplex = 1
        group1_source_hits++
    }
    if (!has_group1_src_ppv &&
        (line ~ /GCOMMAND_PPVMODECYCLECOUNT/ || line ~ /GCOMMANDPPVMODECYCLECOUNT/)) {
        has_group1_src_ppv = 1
        group1_source_hits++
    }
    if (group1_source_hits >= 6) {
        has_group1_sources = 1
        has_group1_source_set = 1
    }

    if ((line ~ /CMP\.L D7,D0/ || line ~ /CMP\.L D0,D7/ ||
         line ~ /CMP\.L D5,D1/ || line ~ /CMP\.L D1,D5/ ||
         line ~ /CMP\.L NEWGRID_MODECANDIDATEINDEX/ ||
         line ~ /CMP\.L NEWGRIDMODECANDIDATEINDEX/) &&
        const12_hits >= 2) {
        has_cycle_gate_fallback = 1
    }

    if ((line ~ /SUBQ\.B #\$1/ || line ~ /SUBQ\.B #1/ || line ~ /MOVE\.B D2,/) &&
        line ~ /NEWGRID_.*MODECYCLEBUDGET/) {
        budget_dec_hits++
    }
    if (line ~ /MOVE\.B D0,NEWGRID_.*MODECYCLEBUDGET/) {
        budget_reset_hits++
    }
    if (!has_group2_src_global &&
        (line ~ /NEWGRID_NICHEMODECYCLEBUDGET_GLO/ || line ~ /NEWGRIDNICHEMODECYCLEBUDGETGLO/)) {
        has_group2_src_global = 1
        group2_source_hits++
    }
    if (!has_group2_src_y &&
        (line ~ /NEWGRID_NICHEMODECYCLEBUDGET_Y/ || line ~ /NEWGRIDNICHEMODECYCLEBUDGETY/)) {
        has_group2_src_y = 1
        group2_source_hits++
    }
    if (!has_group2_src_static &&
        (line ~ /NEWGRID_NICHEMODECYCLEBUDGET_STA/ || line ~ /NEWGRIDNICHEMODECYCLEBUDGETSTA/ ||
         line ~ /NEWGRID_NICHEMODECYCLEBUDGET_STATIC/ || line ~ /NEWGRIDNICHEMODECYCLEBUDGETSTATIC/)) {
        has_group2_src_static = 1
        group2_source_hits++
    }
    if (!has_group2_src_custom &&
        (line ~ /NEWGRID_NICHEMODECYCLEBUDGET_CUS/ || line ~ /NEWGRIDNICHEMODECYCLEBUDGETCUS/ ||
         line ~ /NEWGRID_NICHEMODECYCLEBUDGET_CUSTOM/ || line ~ /NEWGRIDNICHEMODECYCLEBUDGETCUSTOM/)) {
        has_group2_src_custom = 1
        group2_source_hits++
    }
    if (!has_group2_src_mplex &&
        (line ~ /NEWGRID_MPLEXMODECYCLEBUDGET/ || line ~ /NEWGRIDMPLEXMODECYCLEBUDGET/)) {
        has_group2_src_mplex = 1
        group2_source_hits++
    }
    if (!has_group2_src_ppv &&
        (line ~ /NEWGRID_PPVMODECYCLEBUDGET/ || line ~ /NEWGRIDPPVMODECYCLEBUDGET/)) {
        has_group2_src_ppv = 1
        group2_source_hits++
    }
    if (group2_source_hits >= 6) {
        has_group2_source_set = 1
    }
    if (budget_dec_hits >= 6 && budget_reset_hits >= 6 && has_group2_source_set) {
        has_group2_budget_workflow = 1
    }

    if ((line ~ /MOVEQ #1,D5/ || line ~ /MOVEQ\.L #\$1,D5/ || line ~ /MOVEQ\.L #1,D5/ ||
         line ~ /MOVEQ #1,D7/ || line ~ /MOVEQ\.L #\$1,D7/ || line ~ /MOVEQ\.L #1,D7/) &&
        has_group2_dispatch) {
        has_group2_case7 = 1
    }

    if (line == "RTS") {
        has_return = 1
    }

    prev2 = prev
    prev = line
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_TABLE_SEED=" has_mode_table_seed
    print "HAS_CYCLE_GATE_SETUP=" has_cycle_gate_setup
    print "HAS_FORCE_MODE12=" has_force_mode12
    print "HAS_COUNTDOWN_DECREMENT=" has_countdown_decrement
    print "HAS_CANDIDATE_FETCH=" has_candidate_fetch
    print "HAS_CANDIDATE_WRAP=" has_candidate_wrap
    print "HAS_GROUP1_DISPATCH=" has_group1_dispatch
    print "HAS_GROUP1_SOURCES=" has_group1_sources
    print "HAS_GROUP1_SOURCE_SET=" has_group1_source_set
    print "HAS_CYCLE_GATE_FALLBACK=" has_cycle_gate_fallback
    print "HAS_GROUP2_DISPATCH=" has_group2_dispatch
    print "HAS_GROUP2_BUDGET_WORKFLOW=" has_group2_budget_workflow
    print "HAS_GROUP2_SOURCE_SET=" has_group2_source_set
    print "HAS_GROUP2_CASE7=" has_group2_case7
    print "HAS_RETURN=" has_return
}
