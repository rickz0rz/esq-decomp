BEGIN{h_entry=0;h_guard=0;h_prefix=0;h_24h=0;h_render_variant=0;h_layout_append=0;h_find_char=0;h_find_any=0;h_skip=0;h_layout_lines=0;h_missing=0;h_empty=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_DRAWGRIDENTRY:/ || l ~ /^NEWGRID_DRAWGRIDENTRY[A-Z0-9_]*:/)h_entry=1
    if(l ~ /SCRIPT_PTRNODATAPLACEHOLDER/ || l ~ /DRAW_MISSING_ENTRY/ || l ~ /BLE\.W .*DRAW_MISSING_ENTRY/)h_guard=1
    if(l ~ /#\$28/ || l ~ /#\$3A/ || l ~ /ADD\.L D0,-16\(A5\)/)h_prefix=1
    if(l ~ /(JSR|BSR).*NEWGRID_APPLY24HOURFORMATTING/ || l ~ /APPLY24HOURFORMATTING/)h_24h=1
    if(l ~ /(JSR|BSR).*RENDERCLOCKFORMATENTRYVARIANT/ || l ~ /RENDERCLOCKFORMATENTRYVAR/ || l ~ /RENDERCLOCKF/)h_render_variant=1
    if(l ~ /(JSR|BSR).*LAYOUTANDAPPENDTOBUFFER/ || l ~ /LAYOUTANDAPPENDTOBUF/ || l ~ /DISPTEXT_LAYOUTA/ || l ~ /LAYOUTA/)h_layout_append=1
    if(l ~ /(JSR|BSR).*STR_FINDCHARPTR/ || l ~ /FINDCHARPTR/)h_find_char=1
    if(l ~ /(JSR|BSR).*STR_FINDANYCHARPTR/ || l ~ /FINDANYCHARPTR/ || l ~ /FINDANYCHARP/)h_find_any=1
    if(l ~ /(JSR|BSR).*STR_SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CH/)h_skip=1
    if(l ~ /(JSR|BSR).*LAYOUTSOURCETOLINES/ || l ~ /LAYOUTSOURCETOLIN/ || l ~ /DISPTEXT_LAYOUTS/ || l ~ /LAYOUTS/)h_layout_lines=1
    if(l ~ /SCRIPT_PTRNODATAPLACEHOLDER/)h_missing=1
    if(l ~ /DRAW_EMPTY_ENTRY/ || l ~ /ENTRYTEXTSCRATCHPTR/)h_empty=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_GUARD_CHAIN="h_guard
    print "HAS_TIME_PREFIX_SKIP="h_prefix
    print "HAS_24H_FORMAT="h_24h
    print "HAS_CLOCK_RENDER_VARIANT="h_render_variant
    print "HAS_LAYOUT_APPEND="h_layout_append
    print "HAS_FIND_CHAR="h_find_char
    print "HAS_FIND_ANY_CHAR="h_find_any
    print "HAS_SKIP_CLASS3="h_skip
    print "HAS_LAYOUT_TO_LINES="h_layout_lines
    print "HAS_MISSING_FALLBACK="h_missing
    print "HAS_EMPTY_FALLBACK="h_empty
    print "HAS_RTS="h_rts
}
