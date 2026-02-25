BEGIN {
    mode = toupper(mode)
    size_reg = ""
    attr_reg = ""
    block_reg = ""
    seen_size_load = 0
    seen_attr_load = 0
    seen_block_load = 0
    seen_set_d0 = 0
    seen_set_d1 = 0
    seen_add_bytes = 0
    seen_sub_bytes = 0
    seen_inc_alloc = 0
    seen_inc_dealloc = 0
    seen_alloc_call = 0
    seen_free_call = 0
    pre_call_branches = 0
    seen_call = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function is_frame_arg(src) {
    return (src ~ /A5\)/ || src ~ /SP\)/)
}

function parse_move_to_dn(line,    tmp, parts, src, dst) {
    if (line !~ /^MOVE\.L .*,D[0-7]$/) return 0
    tmp = line
    sub(/^MOVE\.L /, "", tmp)
    src = tmp
    sub(/,[^,]*$/, "", src)
    dst = tmp
    sub(/^.*,/, "", dst)
    parsed_src = src
    parsed_dst = dst
    return 1
}

function parse_move_to_an(line,    tmp, parts, src, dst) {
    if (line !~ /^MOVEA?\.L .*,A[0-7]$/) return 0
    tmp = line
    sub(/^MOVEA?\.L /, "", tmp)
    src = tmp
    sub(/,[^,]*$/, "", src)
    dst = tmp
    sub(/^.*,/, "", dst)
    parsed_src = src
    parsed_dst = dst
    return 1
}

function parse_add_to_global(line,    tmp, parts, src) {
    if (line !~ /^ADD\.L .*,GLOBAL_MEM_BYTES_ALLOCATED$/) return 0
    tmp = line
    sub(/^ADD\.L /, "", tmp)
    src = tmp
    sub(/,[^,]*$/, "", src)
    parsed_src = src
    return 1
}

function parse_sub_to_global(line,    tmp, parts, src) {
    if (line !~ /^SUB\.L .*,GLOBAL_MEM_BYTES_ALLOCATED$/) return 0
    tmp = line
    sub(/^SUB\.L /, "", tmp)
    src = tmp
    sub(/,[^,]*$/, "", src)
    parsed_src = src
    return 1
}

{
    line = $0

    sub(/;.*/, "", line)
    line = trim(line)
    if (line == "") next

    gsub(/[ \t]+/, " ", line)
    line = toupper(line)

    # Normalize common naming/syntax variants from different assemblers.
    gsub(/_LVO/, "LVO", line)
    gsub(/_GLOBAL_/, "GLOBAL_", line)
    gsub(/\(/, "(", line)
    gsub(/\)/, ")", line)

    if (line ~ /^[A-Z0-9_.]+:$/) next
    if (line ~ /^#/) next
    if (line ~ /^\| /) next

    if (mode == "ALLOCATE") {
        if (parse_move_to_dn(line)) {
            src = parsed_src
            dst = parsed_dst

            if (is_frame_arg(src)) {
                if (size_reg == "") {
                    size_reg = dst
                    seen_size_load = 1
                } else if (attr_reg == "") {
                    attr_reg = dst
                    seen_attr_load = 1
                }
            }

            if (dst == "D0" && src == size_reg) {
                seen_set_d0 = 1
            }
            if (dst == "D1" && (src == attr_reg || is_frame_arg(src))) {
                seen_set_d1 = 1
            }
        }

        if (line ~ /^JSR .*LVOALLOCMEM\(/) {
            seen_alloc_call = 1
        }

        if (parse_add_to_global(line)) {
            seen_add_bytes = 1
        }

        if (line ~ /^ADDQ\.L #1,GLOBAL_MEM_ALLOC_COUNT$/) {
            seen_inc_alloc = 1
        }
    }

    if (mode == "DEALLOCATE") {
        if (!seen_call && (line ~ /^BEQ(\.S)? / || line ~ /^JEQ(\.S)? /)) {
            pre_call_branches++
        }

        if (parse_move_to_an(line)) {
            src = parsed_src
            dst = parsed_dst
            if (is_frame_arg(src)) {
                if (block_reg == "") {
                    block_reg = dst
                    seen_block_load = 1
                }
            }
        }

        if (parse_move_to_dn(line)) {
            src = parsed_src
            dst = parsed_dst
            if (is_frame_arg(src)) {
                if (size_reg == "") {
                    size_reg = dst
                    seen_size_load = 1
                }
            }
        }

        if (line ~ /^JSR .*LVOFREEMEM\(/) {
            seen_call = 1
            seen_free_call = 1
        }

        if (parse_sub_to_global(line)) {
            seen_sub_bytes = 1
        }

        if (line ~ /^ADDQ\.L #1,GLOBAL_MEM_DEALLOC_COUNT$/) {
            seen_inc_dealloc = 1
        }
    }
}

END {
    if (mode == "ALLOCATE") {
        print "ARG_SIZE_LOAD=" seen_size_load
        print "ARG_ATTR_LOAD=" seen_attr_load
        print "SET_D0_FOR_CALL=" seen_set_d0
        print "SET_D1_FOR_CALL=" seen_set_d1
        print "CALL_ALLOCMEM=" seen_alloc_call
        print "ADD_BYTES_COUNTER=" seen_add_bytes
        print "INC_ALLOC_COUNTER=" seen_inc_alloc
    }

    if (mode == "DEALLOCATE") {
        print "ARG_BLOCK_LOAD=" seen_block_load
        print "ARG_SIZE_LOAD=" seen_size_load
        print "PRECALL_BRANCH_COUNT=" pre_call_branches
        print "CALL_FREEMEM=" seen_free_call
        print "SUB_BYTES_COUNTER=" seen_sub_bytes
        print "INC_DEALLOC_COUNTER=" seen_inc_dealloc
    }
}
