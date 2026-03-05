BEGIN { has_entry=0; has_init_minus1=0; has_terminator_cmp=0; has_clear_input=0; has_store_index=0; has_fill_gate=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^SCRIPT_BUILDTOKENINDEXMAP:/ || u ~ /^SCRIPT_BUILDTOKENINDEXM[A-Z0-9_]*:/) has_entry=1
 if (u ~ /MOVE\.W #\(-1\)/ || u ~ /MOVEQ\.L #-1/ || u ~ /MOVEQ #-1/ || u ~ /MOVE\.W #\$FFFF/ || u ~ /MOVE\.W #\$FFFFFFFF/) has_init_minus1=1
 if (u ~ /^CMP\.B D[0-7],D[0-7]$/ || u ~ /^CMP\.B [^,]+,D[0-7]$/) has_terminator_cmp=1
 if (u ~ /^CLR\.B 0\(A3,D0\.W\)$/ || u ~ /^MOVE\.B #\$0,\$0\(A[0-7],D[0-7]\.[WL]\)$/ || u ~ /^CLR\.B \$0\(A[0-7],D[0-7]\.[WL]\)$/) has_clear_input=1
 if (u ~ /^MOVE\.W D[0-7],0\(A2,D[0-7]\.L\)$/ || u ~ /^MOVE\.W D[0-7],\$0\(A[0-7],D[0-7]\.L\)$/) has_store_index=1
 if (u ~ /^TST\.W [0-9-]+\((A5|A6)\)$/ || u ~ /^TST\.W D[0-7]$/) has_fill_gate=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_INIT_MINUS1="has_init_minus1; print "HAS_TERMINATOR_CMP="has_terminator_cmp; print "HAS_CLEAR_INPUT="has_clear_input; print "HAS_STORE_INDEX="has_store_index; print "HAS_FILL_GATE="has_fill_gate; print "HAS_RETURN="has_return }
