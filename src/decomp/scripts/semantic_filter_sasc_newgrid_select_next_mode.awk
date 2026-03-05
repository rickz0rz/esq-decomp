BEGIN {
    has_entry=0
    has_mode_table=0
    has_cfg_enabled=0
    has_cfg_gate_duration=0
    has_countdown=0
    has_candidate_index=0
    has_cfg_niche_y=0
    has_cfg_niche_static=0
    has_cfg_niche_custom=0
    has_cnt_niche=0
    has_cnt_mplex=0
    has_cnt_ppv=0
    has_budget_y=0
    has_budget_static=0
    has_budget_custom=0
    has_budget_global=0
    has_budget_mplex=0
    has_budget_ppv=0
    has_const12=0
    has_const5=0
    has_const8=0
    has_const48=0
    has_const89=0
    has_const1=0
    has_const0=0
    has_return=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_SELECTNEXTMODE:/ || u ~ /^NEWGRID_SELECTNEXTMOD[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDMODESELECTIONTABLE/ || n ~ /NEWGRIDMODESELECTIONTABL/) has_mode_table=1
    if (n ~ /CONFIGMODECYCLEENABLEDFLAG/ || n ~ /CONFIGMODECYCLEENABLED/) has_cfg_enabled=1
    if (n ~ /CONFIGMODECYCLEGATEDURATION/ || n ~ /CONFIGMODECYCLEGATEDURAT/) has_cfg_gate_duration=1
    if (n ~ /NEWGRIDMODECYCLECOUNTDOWN/ || n ~ /NEWGRIDMODECYCLECOUNTDO/) has_countdown=1
    if (n ~ /NEWGRIDMODECANDIDATEINDEX/ || n ~ /NEWGRIDMODECANDIDATEIN/) has_candidate_index=1
    if (n ~ /CONFIGNICHEMODECYCLEBUDGETY/ || n ~ /CONFIGNICHEMODECYCLEBUDGET/) has_cfg_niche_y=1
    if (n ~ /CONFIGNICHEMODECYCLEBUDGETSTATIC/ || n ~ /CONFIGNICHEMODECYCLEBUDGETST/) has_cfg_niche_static=1
    if (n ~ /CONFIGNICHEMODECYCLEBUDGETCUSTOM/ || n ~ /CONFIGNICHEMODECYCLEBUDGETCU/) has_cfg_niche_custom=1
    if (n ~ /GCOMMANDNICHEMODECYCLECOUNT/ || n ~ /GCOMMANDNICHEMODECYCLECOU/) has_cnt_niche=1
    if (n ~ /GCOMMANDMPLEXMODECYCLECOUNT/ || n ~ /GCOMMANDMPLEXMODECYCLECOU/) has_cnt_mplex=1
    if (n ~ /GCOMMANDPPVMODECYCLECOUNT/ || n ~ /GCOMMANDPPVMODECYCLECOU/) has_cnt_ppv=1
    if (n ~ /NEWGRIDNICHEMODECYCLEBUDGETY/ || n ~ /NEWGRIDNICHEMODECYCLEBUDG/) has_budget_y=1
    if (n ~ /NEWGRIDNICHEMODECYCLEBUDGETSTATIC/ || n ~ /NEWGRIDNICHEMODECYCLEBUDGETST/) has_budget_static=1
    if (n ~ /NEWGRIDNICHEMODECYCLEBUDGETCUSTOM/ || n ~ /NEWGRIDNICHEMODECYCLEBUDGETCU/) has_budget_custom=1
    if (n ~ /NEWGRIDNICHEMODECYCLEBUDGETGLOBAL/ || n ~ /NEWGRIDNICHEMODECYCLEBUDGETGL/) has_budget_global=1
    if (n ~ /NEWGRIDMPLEXMODECYCLEBUDGET/ || n ~ /NEWGRIDMPLEXMODECYCLEBUD/) has_budget_mplex=1
    if (n ~ /NEWGRIDPPVMODECYCLEBUDGET/ || n ~ /NEWGRIDPPVMODECYCLEBUD/) has_budget_ppv=1
    if (u ~ /#12([^0-9]|$)/ || u ~ /#\$0C/ || u ~ /#\$C([^0-9A-F]|$)/ || u ~ /12\.[Ww]/ || u ~ /\(\$c\)\.[Ww]/) has_const12=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)\.[Ww]/) has_const5=1
    if (u ~ /#8([^0-9]|$)/ || u ~ /#\$08/ || u ~ /#\$8([^0-9A-F]|$)/ || u ~ /8\.[Ww]/ || u ~ /\(\$8\)\.[Ww]/) has_const8=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)\.[Ww]/) has_const48=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /#'Y'/) has_const89=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)\.[Ww]/) has_const1=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || n ~ /CLR/) has_const0=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MODE_TABLE="has_mode_table
    print "HAS_CFG_ENABLED="has_cfg_enabled
    print "HAS_CFG_GATE_DURATION="has_cfg_gate_duration
    print "HAS_COUNTDOWN="has_countdown
    print "HAS_CANDIDATE_INDEX="has_candidate_index
    print "HAS_CFG_NICHE_Y="has_cfg_niche_y
    print "HAS_CFG_NICHE_STATIC="has_cfg_niche_static
    print "HAS_CFG_NICHE_CUSTOM="has_cfg_niche_custom
    print "HAS_CNT_NICHE="has_cnt_niche
    print "HAS_CNT_MPLEX="has_cnt_mplex
    print "HAS_CNT_PPV="has_cnt_ppv
    print "HAS_BUDGET_Y="has_budget_y
    print "HAS_BUDGET_STATIC="has_budget_static
    print "HAS_BUDGET_CUSTOM="has_budget_custom
    print "HAS_BUDGET_GLOBAL="has_budget_global
    print "HAS_BUDGET_MPLEX="has_budget_mplex
    print "HAS_BUDGET_PPV="has_budget_ppv
    print "HAS_CONST_12="has_const12
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_8="has_const8
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_0="has_const0
    print "HAS_RETURN="has_return
}
