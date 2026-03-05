BEGIN { has_entry=0; has_topaz_cmp=0; has_probe=0; has_open=0; has_fallback=0; has_fail=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_TESTMEMORYANDOPENTOPAZFONT:/ || u ~ /^PARSEINI_TESTMEMORYANDOPENTOPAZF[A-Z0-9_]*:/) has_entry=1
 if (n ~ /GLOBALHANDLETOPAZFONT/ || u ~ /CMPA?\.L .*A[01]/) has_topaz_cmp=1
 if (n ~ /DESIREDMEMORYAVAILABILITY/ || n ~ /LVOALLOCMEM/ || n ~ /LVOFREEMEM/ || n ~ /LVOFORBID/ || n ~ /LVOPERMIT/) has_probe=1
 if (n ~ /LVOOPENDISKFONT/) has_open=1
 if (u ~ /MOVE\.L GLOBAL_HANDLE_TOPAZ_FONT/ || n ~ /GLOBALHANDLETOPAZFONT/) has_fallback=1
 if (u ~ /^MOVEQ(\.L)? #1,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$1,D[0-7]$/ || u ~ /^MOVEQ #1,D[0-7]$/) has_fail=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_TOPAZ_CMP="has_topaz_cmp; print "HAS_PROBE="has_probe; print "HAS_OPEN="has_open; print "HAS_FALLBACK="has_fallback; print "HAS_FAIL="has_fail; print "HAS_RETURN="has_return }
