BEGIN { has_entry=0; has_boolize=0; has_gate=0; has_snapshot=0; has_call=0; has_thresh3=0; has_clear_pending=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_CHECKCTRLHCHANGE:/ || u ~ /^PARSEINI_CHECKCTRLHCHANG[A-Z0-9_]*:/) has_entry=1
 if (u ~ /^SNE D[0-7]$/ || u ~ /^NEG\.B D[0-7]$/ || u ~ /^EXT\.W D[0-7]$/ || u ~ /^EXT\.L D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$FF,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/) has_boolize=1
 if (n ~ /PARSEINICTRLHCHANGEGATEFLAG/) has_gate=1
 if (n ~ /PARSEINICTRLHCLOCKSNAPSHOT/ || n ~ /GLOBALREFCLOCKDATASTRUCT/) has_snapshot=1
 if (n ~ /SCRIPT3JMPTBLESQDISPUPDATESTATUSMASKANDREFRESH/ || n ~ /SCRIPT3JMPTBLESQDISPUPDATESTA/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRESH/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRES/ || n ~ /ESQDISPUPDATESTATUSMASKANDREFRE/) has_call=1
 if (u ~ /#3/ || u ~ /\$3/) has_thresh3=1
 if (u ~ /^CLR\.W PARSEINI_CTRLHCHANGEPENDINGFLAG/ || n ~ /PARSEINICTRLHCHANGEPENDINGFLAGA4/) has_clear_pending=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_BOOLIZE="has_boolize; print "HAS_GATE="has_gate; print "HAS_SNAPSHOT="has_snapshot; print "HAS_CALL="has_call; print "HAS_THRESH3="has_thresh3; print "HAS_CLEAR_PENDING="has_clear_pending; print "HAS_RETURN="has_return }
