BEGIN { has_rts = 0 }
function trim(s, t) { t=s; sub(/;.*/, "", t); sub(/^[ \t]+/, "", t); sub(/[ \t]+$/, "", t); return t }
{ line=trim($0); if (line=="") next; gsub(/[ \t]+/, " ", line); if (toupper(line)=="RTS") has_rts = 1 }
END { print "HAS_RTS=" has_rts }
