BEGIN {
    has_entry = 0
    has_body = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^DOS_MOVEPWORDREADCALLBACK:/ || l ~ /^DOS_MOVEPWORDREADCALLBAC[A-Z0-9_]*:/) has_entry = 1
    if (l !~ /^[A-Z0-9_]+:$/ && l !~ /^_?[A-Z0-9_]+:$/) has_body = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BODY=" has_body
}
