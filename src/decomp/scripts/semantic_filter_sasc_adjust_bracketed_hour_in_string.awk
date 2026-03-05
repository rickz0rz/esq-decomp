BEGIN {
    has_entry = 0
    has_find_left = 0
    has_replace_left = 0
    has_find_right = 0
    has_replace_right = 0
    has_space_check = 0
    has_sub_ascii0 = 0
    has_add_offset = 0
    has_emit_ascii = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /#'\['/ || u ~ /#91/ || u ~ /#\$?5B/) has_find_left = 1
    if (u ~ /#'\('/ || u ~ /#40/ || u ~ /#\$?28/) has_replace_left = 1
    if (u ~ /#'\]'/ || u ~ /#93/ || u ~ /#\$?5D/) has_find_right = 1
    if (u ~ /#'\)'/ || u ~ /#41/ || u ~ /#\$?29/) has_replace_right = 1

    if (u ~ /#' '/ || u ~ /#32/ || u ~ /#\$?20/) has_space_check = 1
    if (u ~ /SUBI\.B #\$?30,D[0-7]/ || u ~ /SUB\.B #48,D[0-7]/ || u ~ /ADD\.B #-48,D[0-7]/ || u ~ /ADD\.B #\$?D0,D[0-7]/ || u ~ /#\$?D0/) has_sub_ascii0 = 1
    if (u ~ /ADD\.B D[0-7],D[0-7]/ || u ~ /ADD\.B D4,D0/ || u ~ /ADD\.W D[0-7],D[0-7]/) has_add_offset = 1
    if (u ~ /ADDI\.B #\$?30,D[0-7]/ || u ~ /ADDI\.B #48,D[0-7]/ || u ~ /ADD\.B #48,D[0-7]/ || u ~ /ADD\.B #\$?30,D[0-7]/) has_emit_ascii = 1

    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_FIND_LEFT=" has_find_left
    print "HAS_REPLACE_LEFT=" has_replace_left
    print "HAS_FIND_RIGHT=" has_find_right
    print "HAS_REPLACE_RIGHT=" has_replace_right
    print "HAS_SPACE_CHECK=" has_space_check
    print "HAS_SUB_ASCII0=" has_sub_ascii0
    print "HAS_ADD_OFFSET=" has_add_offset
    print "HAS_EMIT_ASCII=" has_emit_ascii
    print "HAS_RTS=" has_rts
}
