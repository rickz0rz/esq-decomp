BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^DISKIO_DRAWTRANSFERERRORMESSAGEIFDIAGNOSTICS:/)h1=1; if(l~/^TST\.W ED_DIAGNOSTICSSCREENACTIVE$/)h2=1; if(l~/^JSR _LVOSETAPEN\(A6\)$/)h3=1; if(l~/^JSR DISPLIB_DISPLAYTEXTATPOSITION(\(PC\))?$/)h4=1; if(l~/^MOVE\.L \(A7\)\+,D7$/)h5=1; if(l~/^RTS$/)h6=1}
END{print "HAS_ENTRY="h1;print "HAS_DIAG_GUARD="h2;print "HAS_SETAPEN="h3;print "HAS_DISP_CALL="h4;print "HAS_RESTORE="h5;print "HAS_RTS="h6}
