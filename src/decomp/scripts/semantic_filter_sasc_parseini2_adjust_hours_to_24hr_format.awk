BEGIN { has_entry=0; has_cmp12=0; has_zero_case=0; has_pm_check=0; has_add12=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_ADJUSTHOURSTO24HRFORMAT:/ || u ~ /^PARSEINI_ADJUSTHOURSTO24HRFORMA[A-Z0-9_]*:/) has_entry=1
 if (u ~ /#12/ || u ~ /\$C/) has_cmp12=1
 if (u ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/ || u ~ /^MOVEQ #0,D[0-7]$/) has_zero_case=1
 if (u ~ /^MOVEQ(\.L)? #\$FF,D[0-7]$/ || u ~ /^MOVEQ #-1,D[0-7]$/ || u ~ /^CMPI?\.W #\(-1\),D[0-7]$/ || u ~ /^CMP\.W D[0-7],D[0-7]$/) has_pm_check=1
 if (u ~ /ADDI\.W #12/ || u ~ /ADDQ\.W #12/ || u ~ /ADD\.W #\$C,D[0-7]/ || u ~ /ADD\.W D[0-7],D[0-7]/) has_add12=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_CMP12="has_cmp12; print "HAS_ZERO_CASE="has_zero_case; print "HAS_PM_CHECK="has_pm_check; print "HAS_ADD12="has_add12; print "HAS_RETURN="has_return }
