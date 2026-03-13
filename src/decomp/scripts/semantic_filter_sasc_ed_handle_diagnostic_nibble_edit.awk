BEGIN{h_help=0;h_index3=0;h_inc=0;h_dec=0;h_state_ring=0;h_palette=0;h_draw_regs=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_help=1
    if(l~/LSL\.L #\$?2,D0/ || l~/SUB\.L ED_TEMPCOPYOFFSET,D0/ || l~/(JSR|BSR).*ED_DIAGINDEX3/)h_index3=1
    if(l~/ADDQ\.B #\$?1,\(A1\)/ || l~/(JSR|BSR).*ED_INCNIBBLE/)h_inc=1
    if(l~/SUBQ\.B #\$?1,\(A1\)/ || l~/(JSR|BSR).*ED_DECNIBBLE/)h_dec=1
    if(l~/ED_STATERINGINDEX/ || l~/ED_STATERINGTABLE/ || l~/ED_LASTMENUINPUTCHAR/)h_state_ring=1
    if(l~/(JSR|BSR).*(ED1_JMPTBL_ESQSHARED4_LOADDEFAULTPALETTETOCOPPER_NO_OP|ESQSHARED4_LOADDEFAULTPALETTETOCOPPER_NO_OP)/ || l~/(JSR|BSR).*(ED1_JMPTBL_ESQSHARED4_LOADDEFAULT|ESQSHARED4_LOADDEFAULT)/ || l~/(JSR|BSR).*(ED1_JMPTBL_ESQSHARED4_LOADDEFAUL|ESQSHARED4_LOADDEFAUL)/)h_palette=1
    if(l~/(JSR|BSR).*ED_DRAWDIAGNOSTICREGISTERVALUES/)h_draw_regs=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_HELP_CASE="h_help
    print "HAS_INDEX_TIMES3="h_index3
    print "HAS_INC_PATH="h_inc
    print "HAS_DEC_PATH="h_dec
    print "HAS_RING_ADJUST_PATH="h_state_ring
    print "HAS_PALETTE_REFRESH="h_palette
    print "HAS_DRAW_REGS="h_draw_regs
    print "HAS_RTS="h_rts
}
