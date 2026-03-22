BEGIN {
 has_entry=0
 has_open_find=0; has_colon_find=0; has_close_find=0; has_quote_find=0
 has_parse=0; parse_calls=0
 has_first_output=0; has_second_output=0
 has_success=0; has_return=0
 has_null_source_guard=0
 quote_guard_cmp=0; has_strict_lt_quote_guard=0
 has_space_cmp=0; has_space_skip_2=0; has_space_skip_1=0
 has_clear_colon=0; has_restore_colon=0
 has_clear_close=0; has_restore_close=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA2_PARSEENTRYTIMEWINDOW:/ || u ~ /^TLIBA2_PARSEENTRYTIMEWINDO[A-Z0-9_]*:/) has_entry=1
 if (u ~ /PEA 40\.W/ || u ~ /PEA \(\$28\)\.W/) has_open_find=1
 if (u ~ /PEA 58\.W/ || u ~ /PEA \(\$3A\)\.W/) has_colon_find=1
 if (u ~ /PEA 41\.W/ || u ~ /PEA \(\$29\)\.W/) has_close_find=1
 if (u ~ /PEA 34\.W/ || u ~ /PEA \(\$22\)\.W/) has_quote_find=1
 if (u ~ /^BEQ(\.[BWL])? / || n ~ /^BEQ/ || u ~ /^BNE(\.[BWL])? / || n ~ /^BNE/) {
  if (!has_null_source_guard) has_null_source_guard=1
 }
 if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3AL/ || n ~ /PARSEREADSIGNEDLONG/) {
  has_parse=1
  parse_calls++
 }
 if (u ~ /MOVE\.L D0,\(A2\)/ || u ~ /MOVE\.L D0,\(A3\)/ || n ~ /MOVELD0A2/ || n ~ /MOVELD0A3/) has_first_output=1
 if (u ~ /MOVE\.L D0,4\(A2\)/ || u ~ /MOVE\.L D0,\$4\(A3\)/ || n ~ /MOVELD04A2/ || n ~ /MOVELD04A3/) has_second_output=1
 if (u ~ /MOVEQ #1,D6/ || u ~ /MOVEQ.L #$1,D6/ || n ~ /MOVEQL1D6/) has_success=1
 if (u ~ /^CMP\.B 1\(A0\),D0$/ || u ~ /^CMP\.B \$1\(A0\),D0$/ || n ~ /^CMPB1A0D0$/) has_space_cmp=1
 if (u ~ /^LEA 2\(A0\),A1$/ || u ~ /^LEA \$2\(A0\),A1$/ || n ~ /^LEA2A0A1$/) has_space_skip_2=1
 if (u ~ /^LEA 1\(A0\),A1$/ || u ~ /^LEA \$1\(A0\),A1$/ || n ~ /^LEA1A0A1$/) has_space_skip_1=1
 if (u ~ /^CLR\.B \(A0\)$/ && !has_clear_colon) has_clear_colon=1
 else if (u ~ /^CLR\.B \(A0\)$/) has_clear_close=1
 if (u ~ /^MOVE\.B #\$3A,\(A0\)$/ || u ~ /^MOVE\.B #\$3a,\(A0\)$/) has_restore_colon=1
 if (u ~ /^MOVE\.B #\$29,\(A0\)$/ || u ~ /^MOVE\.B #\$29,\(A0\)$/) has_restore_close=1
 if (u ~ /^CMPA?\.L D0,A0$/ || n ~ /^CMPALD0A0$/ || n ~ /^CMPLD0A0$/) {
  quote_guard_cmp=1
  next
 }
 if (quote_guard_cmp && (u ~ /^BCC(\.[BWL])? / || n ~ /^BCC/ || u ~ /^BCS(\.[BWL])? / || n ~ /^BCS/)) has_strict_lt_quote_guard=1
 if (u=="RTS") has_return=1
}
END {
 print "HAS_ENTRY="has_entry
 print "HAS_OPEN_FIND="has_open_find
 print "HAS_COLON_FIND="has_colon_find
 print "HAS_CLOSE_FIND="has_close_find
 print "HAS_QUOTE_FIND="has_quote_find
 print "HAS_NULL_SOURCE_GUARD="has_null_source_guard
 print "HAS_PARSE="has_parse
 print "PARSE_CALLS="parse_calls
 print "HAS_FIRST_OUTPUT="has_first_output
 print "HAS_SECOND_OUTPUT="has_second_output
 print "HAS_SPACE_CMP="has_space_cmp
 print "HAS_SPACE_SKIP_2="has_space_skip_2
 print "HAS_SPACE_SKIP_1="has_space_skip_1
 print "HAS_CLEAR_COLON="has_clear_colon
 print "HAS_RESTORE_COLON="has_restore_colon
 print "HAS_CLEAR_CLOSE="has_clear_close
 print "HAS_RESTORE_CLOSE="has_restore_close
 print "HAS_SUCCESS="has_success
 print "HAS_STRICT_LT_QUOTE_GUARD="has_strict_lt_quote_guard
 print "HAS_RETURN="has_return
}
