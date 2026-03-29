BEGIN{
    h_entry=0
    h_guard=0
    h_prefix=0
    h_24h=0
    h_render_variant=0
    c_render_variant=0
    h_layout_append=0
    c_layout_append=0
    h_find_char=0
    c_find_char=0
    h_find_any=0
    c_find_any=0
    h_skip=0
    c_skip=0
    h_layout_lines=0
    c_layout_lines=0
    h_missing=0
    h_empty=0
    h_primary_quote_rescan=0
    h_primary_delim_mask=0
    h_primary_split_null=0
    h_secondary_paren=0
    h_secondary_close=0
    h_secondary_lines=0
    h_secondary_layout_append=0
    h_subtitle_comma=0
    h_subtitle_period=0
    h_subtitle_alt=0
    h_subtitle_alt_lines=0
    h_subtitle_alt_retry=0
    h_post_split_loop=0
    h_post_split_append=0
    h_final_clockfmt_minus1=0
    h_final_scratch_clear=0
    h_rts=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_DRAWGRIDENTRY:/ || l ~ /^NEWGRID_DRAWGRIDENTRY[A-Z0-9_]*:/)h_entry=1
    if(l ~ /SCRIPT_PTRNODATAPLACEHOLDER/ || l ~ /DRAW_MISSING_ENTRY/ || l ~ /BLE\.W .*DRAW_MISSING_ENTRY/)h_guard=1
    if(l ~ /#\$28/ || l ~ /#\$3A/ || l ~ /ADD\.L D0,-16\(A5\)/)h_prefix=1
    if(l ~ /(JSR|BSR).*NEWGRID_APPLY24HOURFORMATTING/ || l ~ /APPLY24HOURFORMATTING/)h_24h=1
    if(l ~ /(JSR|BSR).*RENDERCLOCKFORMATENTRYVARIANT/ || l ~ /RENDERCLOCKFORMATENTRYVAR/ || l ~ /RENDERCLOCKF/)h_render_variant=1
    if(l ~ /^(JSR|BSR)(\.[WL])? .*RENDERCLOCKFORMATENTRYVARIANT/ || l ~ /^(JSR|BSR)(\.[WL])? .*RENDERCLOCKFORMATENTRYVAR/ || l ~ /^(JSR|BSR)(\.[WL])? .*RENDERCLOCKF/)c_render_variant++
    if(l ~ /(JSR|BSR).*LAYOUTANDAPPENDTOBUFFER/ || l ~ /LAYOUTANDAPPENDTOBUF/ || l ~ /DISPTEXT_LAYOUTA/ || l ~ /LAYOUTA/)h_layout_append=1
    if(l ~ /^(JSR|BSR)(\.[WL])? .*LAYOUTANDAPPENDTOBUFFER/ || l ~ /^(JSR|BSR)(\.[WL])? .*LAYOUTANDAPPENDTOBUF/ || l ~ /^(JSR|BSR)(\.[WL])? .*DISPTEXT_LAYOUTA/ || l ~ /^(JSR|BSR)(\.[WL])? .*LAYOUTA/)c_layout_append++
    if(l ~ /(JSR|BSR).*STR_FINDCHARPTR/ || l ~ /FINDCHARPTR/)h_find_char=1
    if(l ~ /^(JSR|BSR)(\.[WL])? .*STR_FINDCHARPTR/ || l ~ /^(JSR|BSR)(\.[WL])? .*FINDCHARPTR/)c_find_char++
    if(l ~ /(JSR|BSR).*STR_FINDANYCHARPTR/ || l ~ /FINDANYCHARPTR/ || l ~ /FINDANYCHARP/)h_find_any=1
    if(l ~ /^(JSR|BSR)(\.[WL])? .*STR_FINDANYCHARPTR/ || l ~ /^(JSR|BSR)(\.[WL])? .*FINDANYCHARPTR/ || l ~ /^(JSR|BSR)(\.[WL])? .*FINDANYCHARP/)c_find_any++
    if(l ~ /(JSR|BSR).*STR_SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CH/)h_skip=1
    if(l ~ /^(JSR|BSR)(\.[WL])? .*STR_SKIPCLASS3CHARS/ || l ~ /^(JSR|BSR)(\.[WL])? .*SKIPCLASS3CH/)c_skip++
    if(l ~ /(JSR|BSR).*LAYOUTSOURCETOLINES/ || l ~ /LAYOUTSOURCETOLIN/ || l ~ /DISPTEXT_LAYOUTS/ || l ~ /LAYOUTS/)h_layout_lines=1
    if(l ~ /^(JSR|BSR)(\.[WL])? .*LAYOUTSOURCETOLINES/ || l ~ /^(JSR|BSR)(\.[WL])? .*LAYOUTSOURCETOLIN/ || l ~ /^(JSR|BSR)(\.[WL])? .*DISPTEXT_LAYOUTS/ || l ~ /^(JSR|BSR)(\.[WL])? .*LAYOUTS/)c_layout_lines++
    if(l ~ /PEA 40\.W/ || l ~ /PEA \(\$28\)\.W/)h_secondary_paren=1
    if(l ~ /CMP\.B 5\(A0\),D1/ || l ~ /CMP\.B \$5\(A0\),D1/)h_secondary_close=1
    if(l ~ /LEA 6\(A0\),A1/ || l ~ /LEA \$6\(A0\),A1/)h_secondary_lines=1
    if(l ~ /MOVE\.L -8\(A5\),-\(A7\)/ || l ~ /MOVE\.L \$24\(A7\),-\(A7\)/)h_secondary_layout_append=1
    if(l ~ /PEA 44\.W/ || l ~ /PEA \(\$2C\)\.W/)h_subtitle_comma=1
    if(l ~ /PEA 46\.W/ || l ~ /PEA \(\$2E\)\.W/)h_subtitle_period=1
    if(l ~ /MOVE\.B #\$2E,\(A0\)/ || l ~ /MOVE\.B #46,\(A0\)/)h_subtitle_alt=1
    if(l ~ /CLR\.B 1\(A0\)/ || l ~ /CLR\.B \$1\(A0\)/ || l ~ /ADDQ\.L #\$2,\$18\(A7\)/)h_subtitle_alt_lines=1
    if(l ~ /CLR\.B 1\(A0\)/ || l ~ /CLR\.B \$1\(A0\)/)h_subtitle_alt_retry=1
    if(l ~ /PEA 34\.W/ || l ~ /PEA \(\$22\)\.W/)h_primary_quote_rescan=1
    if(l ~ /NEWGRID_ENTRYSPLITDELIMITERMASK/)h_primary_delim_mask=1
    if(l ~ /CLR\.B \(A0\)\+/ || l ~ /CLR\.L -4\(A5\)/ || l ~ /CLR\.L \$30\(A7\)/)h_primary_split_null=1
    if(l ~ /\.SPLIT_LOOP/ || l ~ /MOVE\.L D0,\$20\(A7\)/)h_post_split_loop=1
    if(l ~ /MOVE\.L -8\(A5\),-\(A7\)/ || l ~ /MOVE\.L \$24\(A7\),-\(A7\)/)h_post_split_append=1
    if(l ~ /MOVEQ #\-1,D1/ || l ~ /MOVEQ\.L #\$FF,D0/)h_final_clockfmt_minus1=1
    if(l ~ /MOVEA\.L NEWGRID_ENTRYTEXTSCRATCHPTR,A0/ || l ~ /MOVE\.L NEWGRID_ENTRYTEXTSCRATCHPTR\(A4\),A0/){h_empty=1; h_final_scratch_clear=1}
    if(l ~ /SCRIPT_PTRNODATAPLACEHOLDER/)h_missing=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_GUARD_CHAIN="h_guard
    print "HAS_TIME_PREFIX_SKIP="h_prefix
    print "HAS_24H_FORMAT="h_24h
    print "HAS_CLOCK_RENDER_VARIANT="h_render_variant
    print "COUNT_CLOCK_RENDER_VARIANT="c_render_variant
    print "HAS_LAYOUT_APPEND="h_layout_append
    print "HAS_LAYOUT_APPEND_CLUSTER="(c_layout_append >= 10)
    print "HAS_FIND_CHAR="h_find_char
    print "COUNT_FIND_CHAR="c_find_char
    print "HAS_FIND_ANY_CHAR="h_find_any
    print "COUNT_FIND_ANY_CHAR="c_find_any
    print "HAS_SKIP_CLASS3="h_skip
    print "COUNT_SKIP_CLASS3="c_skip
    print "HAS_LAYOUT_TO_LINES="h_layout_lines
    print "COUNT_LAYOUT_TO_LINES="c_layout_lines
    print "HAS_MISSING_FALLBACK="h_missing
    print "HAS_EMPTY_FALLBACK="h_empty
    print "HAS_PRIMARY_QUOTE_RESCAN="h_primary_quote_rescan
    print "HAS_PRIMARY_DELIM_MASK="h_primary_delim_mask
    print "HAS_PRIMARY_SPLIT_NULL_TERM="h_primary_split_null
    print "HAS_SECONDARY_PAREN_SEARCH="h_secondary_paren
    print "HAS_SECONDARY_CLOSE_CHECK="h_secondary_close
    print "HAS_SECONDARY_SPLIT_ADVANCE="h_secondary_lines
    print "HAS_SECONDARY_LAYOUT_APPEND="h_secondary_layout_append
    print "HAS_SUBTITLE_COMMA_SEARCH="h_subtitle_comma
    print "HAS_SUBTITLE_PERIOD_SEARCH="h_subtitle_period
    print "HAS_SUBTITLE_ALT_REWRITE="h_subtitle_alt
    print "HAS_SUBTITLE_ALT_LAYOUT="h_subtitle_alt_lines
    print "HAS_SUBTITLE_ALT_RETRY="h_subtitle_alt_retry
    print "HAS_POST_SPLIT_LOOP="h_post_split_loop
    print "HAS_POST_SPLIT_APPEND="h_post_split_append
    print "HAS_FINAL_CLOCKFMT_MINUS1="h_final_clockfmt_minus1
    print "HAS_FINAL_SCRATCH_CLEAR="h_final_scratch_clear
    print "HAS_RTS="h_rts
}
