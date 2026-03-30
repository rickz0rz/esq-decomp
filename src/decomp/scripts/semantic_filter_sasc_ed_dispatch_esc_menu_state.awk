BEGIN{
    h_gate=0; h_key=0; h_busy=0; h_switch=0; h_calls=0; h_wrap=0; h_reentry=0; h_rts=0;
    saw_ring_index=0; saw_ring_write=0; saw_guard_test=0; saw_guard_clear=0;
    saw_state_table=0; saw_last_key=0; saw_busy_flag=0;
    saw_setapen=0; saw_setbpen=0; saw_setdrmd=0;
    saw_menu_state=0; saw_bound_check=0; saw_jump_table=0;
    saw_menu_actions=0; saw_esc_input=0; saw_attr_menu=0; saw_editor_input=0;
    saw_attr_input=0; saw_scroll_speed=0; saw_diag_actions=0; saw_update_menu=0;
    saw_enter_text=0; saw_special_menu=0; saw_save_all=0; saw_save_prevue=0;
    saw_load_ads=0; saw_reboot=0; saw_diag_nibble=0; saw_capture=0;
    saw_wrap_inc=0; saw_wrap_cmp=0; saw_wrap_clear=0;
    saw_reentry_seed=0; saw_reentry_store=0;
}

function t(s, x){
    x=s;
    sub(/;.*/,"",x);
    sub(/^[ \t]+/,"",x);
    sub(/[ \t]+$/,"",x);
    gsub(/[ \t]+/," ",x);
    return toupper(x);
}

{
    l=t($0);
    if(l=="")next;

    if(l~/ED_STATERINGINDEX/)saw_ring_index=1;
    if(l~/ED_STATERINGWRITEINDEX/)saw_ring_write=1;
    if(l~/TST\.L ED_MENUDISPATCHREENTRYGUARD/ || l~/ED_MENUDISPATCHREENTRYGUARD\(A4\)/)saw_guard_test=1;
    if(l~/CLR\.L ED_MENUDISPATCHREENTRYGUARD/)saw_guard_clear=1;

    if(l~/ED_STATERINGTABLE/)saw_state_table=1;
    if(l~/ED_LASTKEYCODE/)saw_last_key=1;

    if(l~/GLOBAL_UIBUSYFLAG/)saw_busy_flag=1;
    if(l~/(JSR|BSR).*_LVOSETAPEN/)saw_setapen=1;
    if(l~/(JSR|BSR).*_LVOSETBPEN/)saw_setbpen=1;
    if(l~/(JSR|BSR).*_LVOSETDRMD/)saw_setdrmd=1;

    if(l~/ED_MENUSTATEID/)saw_menu_state=1;
    if(l~/CMPI\.[WL] #\$?19,D0/ || l~/CMP\.W D2,D1/)saw_bound_check=1;
    if(l~/DISPATCH_TABLE/ || l~/__SWITCH_ED_DISPATCHESCMENUSTATE_/ || l~/JMP .*\(PC,D0\.W\)/)saw_jump_table=1;

    if(l~/(JSR|BSR).*ED2_HANDLEMENUACTIONS/)saw_menu_actions=1;
    if(l~/(JSR|BSR).*ED1_HANDLEESCMENUINPUT/)saw_esc_input=1;
    if(l~/(JSR|BSR).*ED_HANDLEEDITATTRIBUTESMENU/)saw_attr_menu=1;
    if(l~/(JSR|BSR).*ED_HANDLEEDITORINPUT/)saw_editor_input=1;
    if(l~/(JSR|BSR).*ED_HANDLEEDITATTRIBUTESINPUT/)saw_attr_input=1;
    if(l~/(JSR|BSR).*ED2_HANDLESCROLLSPEEDSELECTION/)saw_scroll_speed=1;
    if(l~/(JSR|BSR).*ED2_HANDLEDIAGNOSTICSMENUACTIONS/)saw_diag_actions=1;
    if(l~/(JSR|BSR).*ED1_UPDATEESCMENUSELECTION/)saw_update_menu=1;
    if(l~/(JSR|BSR).*ED_ENTERTEXTEDITMODE/)saw_enter_text=1;
    if(l~/(JSR|BSR).*ED_HANDLESPECIALFUNCTIONSMENU/)saw_special_menu=1;
    if(l~/(JSR|BSR).*ED_SAVEEVERYTHINGTODISK/)saw_save_all=1;
    if(l~/(JSR|BSR).*ED_SAVEPREVUEDATATODISK/)saw_save_prevue=1;
    if(l~/(JSR|BSR).*ED_LOADTEXTADSFROMDH2/)saw_load_ads=1;
    if(l~/(JSR|BSR).*ED_REBOOTCOMPUTER/)saw_reboot=1;
    if(l~/(JSR|BSR).*ED_HANDLEDIAGNOSTICNIBBLEEDIT/)saw_diag_nibble=1;
    if(l~/(JSR|BSR).*ED_CAPTUREKEYSEQUENCE/)saw_capture=1;

    if(l~/ADDQ\.[WL] #\$?1,ED_STATERINGINDEX/)saw_wrap_inc=1;
    if(l~/CMPI\.L #\$?14,ED_STATERINGINDEX/)saw_wrap_cmp=1;
    if(l~/CLR\.L ED_STATERINGINDEX/)saw_wrap_clear=1;

    if(l~/MOVEQ(\.L)? #\$?1,D0/)saw_reentry_seed=1;
    if(l~/MOVE\.L D0,ED_MENUDISPATCHREENTRYGUARD/ || l~/MOVE\.L #\$?1,ED_MENUDISPATCHREENTRYGUARD/)saw_reentry_store=1;

    if(l=="RTS")h_rts=1;
}

END{
    h_gate=saw_ring_index && saw_ring_write && saw_guard_test && saw_guard_clear;
    h_key=saw_state_table && saw_last_key;
    h_busy=saw_busy_flag && saw_setapen && saw_setbpen && saw_setdrmd;
    h_switch=saw_menu_state && saw_bound_check && saw_jump_table;
    h_calls=saw_menu_actions && saw_esc_input && saw_attr_menu && saw_editor_input && saw_attr_input &&
            saw_scroll_speed && saw_diag_actions && saw_update_menu && saw_enter_text &&
            saw_special_menu && saw_save_all && saw_save_prevue && saw_load_ads &&
            saw_reboot && saw_diag_nibble && saw_capture;
    h_wrap=saw_wrap_inc && saw_wrap_cmp && saw_wrap_clear;
    h_reentry=saw_reentry_seed && saw_reentry_store;

    print"HAS_GATE="h_gate;
    print"HAS_KEY="h_key;
    print"HAS_BUSY="h_busy;
    print"HAS_SWITCH="h_switch;
    print"HAS_CALLS="h_calls;
    print"HAS_WRAP="h_wrap;
    print"HAS_REENTRY="h_reentry;
    print"HAS_RTS="h_rts;
}
