BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_move_call = 0
    has_strlen_loop = 0
    saw_suba_len = 0
    saw_store_len = 0
    has_text_call = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^DISPLIB_DISPLAYTEXTATPOSITION:/) has_entry = 1
    if (uline ~ /MOVE\.L A2,D0/ || uline ~ /BEQ\.S \.RETURN/) has_null_guard = 1
    if (uline ~ /LVO?MOVE\(A6\)/) has_move_call = 1
    if (uline ~ /^\.CURRENTCHARACTERISNOTNULL:/ || uline ~ /TST\.B \(A0\)\+/) has_strlen_loop = 1
    if (uline ~ /SUBA\.L A2,A0/) saw_suba_len = 1
    if (uline ~ /MOVE\.L A0,16\(A7\)/) saw_store_len = 1
    if (uline ~ /LVO?TEXT\(A6\)/) has_text_call = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_length_compute = (saw_suba_len && saw_store_len) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_MOVE_CALL=" has_move_call
    print "HAS_STRLEN_LOOP=" has_strlen_loop
    print "HAS_LENGTH_COMPUTE=" has_length_compute
    print "HAS_TEXT_CALL=" has_text_call
    print "HAS_RETURN=" has_return
}
