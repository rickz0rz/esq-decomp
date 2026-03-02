BEGIN {
    label=0; mode_tbl=0; cfg_en=0; cfg_gate=0; cnt_down=0; cand_idx=0;
    niche_y=0; niche_s=0; niche_c=0; niche_cnt=0; mplex_cnt=0; ppv_cnt=0;
    budg_y=0; budg_s=0; budg_c=0; budg_g=0; budg_m=0; budg_p=0;
    c12=0; c5=0; c8=0; c48=0; c89=0; c1=0; c0=0; rts=0
}

/^NEWGRID_SelectNextMode:$/ { label=1 }
/NEWGRID_ModeSelectionTable/ { mode_tbl=1 }
/CONFIG_ModeCycleEnabledFlag/ { cfg_en=1 }
/CONFIG_ModeCycleGateDuration/ { cfg_gate=1 }
/NEWGRID_ModeCycleCountdown/ { cnt_down=1 }
/NEWGRID_ModeCandidateIndex/ { cand_idx=1 }
/CONFIG_NicheModeCycleBudget_Y/ { niche_y=1 }
/CONFIG_NicheModeCycleBudget_Static/ { niche_s=1 }
/CONFIG_NicheModeCycleBudget_Custom/ { niche_c=1 }
/GCOMMAND_NicheModeCycleCount/ { niche_cnt=1 }
/GCOMMAND_MplexModeCycleCount/ { mplex_cnt=1 }
/GCOMMAND_PpvModeCycleCount/ { ppv_cnt=1 }
/NEWGRID_NicheModeCycleBudget_Y/ { budg_y=1 }
/NEWGRID_NicheModeCycleBudget_Static/ { budg_s=1 }
/NEWGRID_NicheModeCycleBudget_Custom/ { budg_c=1 }
/NEWGRID_NicheModeCycleBudget_Global/ { budg_g=1 }
/NEWGRID_MplexModeCycleBudget/ { budg_m=1 }
/NEWGRID_PpvModeCycleBudget/ { budg_p=1 }
/#\$0c|#12([^0-9]|$)|12\.[Ww]/ { c12=1 }
/#\$05|#5([^0-9]|$)|5\.[Ww]/ { c5=1 }
/#\$08|#8([^0-9]|$)|8\.[Ww]/ { c8=1 }
/#\$30|#48([^0-9]|$)|48\.[Ww]/ { c48=1 }
/#89([^0-9]|$)|#\$59|89\.[Ww]|#'Y'/ { c89=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/#\$00|#0([^0-9]|$)|\bCLR\./ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (mode_tbl) print "HAS_MODE_TABLE"
    if (cfg_en) print "HAS_CFG_ENABLED"
    if (cfg_gate) print "HAS_CFG_GATE_DURATION"
    if (cnt_down) print "HAS_COUNTDOWN"
    if (cand_idx) print "HAS_CANDIDATE_INDEX"
    if (niche_y) print "HAS_CFG_NICHE_Y"
    if (niche_s) print "HAS_CFG_NICHE_STATIC"
    if (niche_c) print "HAS_CFG_NICHE_CUSTOM"
    if (niche_cnt) print "HAS_CNT_NICHE"
    if (mplex_cnt) print "HAS_CNT_MPLEX"
    if (ppv_cnt) print "HAS_CNT_PPV"
    if (budg_y) print "HAS_BUDGET_Y"
    if (budg_s) print "HAS_BUDGET_STATIC"
    if (budg_c) print "HAS_BUDGET_CUSTOM"
    if (budg_g) print "HAS_BUDGET_GLOBAL"
    if (budg_m) print "HAS_BUDGET_MPLEX"
    if (budg_p) print "HAS_BUDGET_PPV"
    if (c12) print "HAS_CONST_12"
    if (c5) print "HAS_CONST_5"
    if (c8) print "HAS_CONST_8"
    if (c48) print "HAS_CONST_48"
    if (c89) print "HAS_CONST_89"
    if (c1) print "HAS_CONST_1"
    if (c0) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}
