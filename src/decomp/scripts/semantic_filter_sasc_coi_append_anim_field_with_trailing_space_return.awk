BEGIN { has_label=0; has_returnish=0; has_rts=0 }
function t(s,x){x=s; sub(/;.*/,"",x); sub(/^[ \t]+/,"",x); sub(/[ \t]+$/,"",x); return x}
{ l=t($0); if(l=="")next; gsub(/[ \t]+/," ",l); u=toupper(l); if(u ~ /^COI_APPENDANIMFIELDWITHTRAILINGSPACE_RETURN:/ || u ~ /^COI_APPENDANIMFIELDWITHTRAILINGSPACE_RE/ || u ~ /^COI_APPENDANIMFIELDWITHTRAILINGS:/) has_label=1; if(u ~ /MOVE\.L .*D0/ || u ~ /^UNLK A5$/) has_returnish=1; if(u=="RTS") has_rts=1 }
END { print "HAS_LABEL=" has_label; print "HAS_RETURNISH=" has_returnish; print "HAS_RTS=" has_rts }
