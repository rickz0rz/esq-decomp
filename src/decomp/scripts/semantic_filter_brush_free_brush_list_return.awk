BEGIN {
    label = 0
    has_epilogue_or_ret = 0
}

/^BRUSH_FreeBrushList_Return:$/ { label = 1 }

{
    line = toupper($0)
    if (line ~ /^RTS$/ || line ~ /UNLK[[:space:]]+A5/ || line ~ /MOVEM\.L[[:space:]]+\(A7\)\+/) {
        has_epilogue_or_ret = 1
    }
}

END {
    if (label) print "HAS_LABEL"
    if (has_epilogue_or_ret) print "HAS_EPILOGUE_OR_RTS"
}
