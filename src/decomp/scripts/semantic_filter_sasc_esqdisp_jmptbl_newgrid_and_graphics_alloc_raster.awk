BEGIN {
    has_newgrid_entry = 0
    has_newgrid_dispatch = 0
    has_newgrid_exit = 0
    has_graphics_entry = 0
    has_graphics_dispatch = 0
    has_graphics_exit = 0
    current_wrapper = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

function dispatch_target(line, tmp, parts) {
    if (line !~ /^(JMP|JSR|BSR|BSR\.[A-Z]+) /) return ""
    tmp = line
    sub(/^(JMP|JSR|BSR|BSR\.[A-Z]+) /, "", tmp)
    split(tmp, parts, /[^A-Z0-9_]/)
    return parts[1]
}

{
    line = toupper(trim($0))
    if (line == "") next

    if (line ~ /^ESQDISP_JMPTBL_NEWGRID_PROCESSGR/) {
        has_newgrid_entry = 1
        current_wrapper = "newgrid"
        next
    }

    if (line ~ /^ESQDISP_JMPTBL_GRAPHICS_ALLOCRAS/) {
        has_graphics_entry = 1
        current_wrapper = "graphics"
        next
    }

    target = dispatch_target(line)
    if (current_wrapper == "newgrid") {
        if (target == "NEWGRID_PROCESSGRIDMESSAGES") has_newgrid_dispatch = 1
        if (line == "RTS" || target == "NEWGRID_PROCESSGRIDMESSAGES") has_newgrid_exit = 1
    } else if (current_wrapper == "graphics") {
        if (target == "GRAPHICS_ALLOCRASTER") has_graphics_dispatch = 1
        if (line == "RTS" || target == "GRAPHICS_ALLOCRASTER") has_graphics_exit = 1
    }
}

END {
    print "HAS_NEWGRID_ENTRY=" has_newgrid_entry
    print "HAS_NEWGRID_DISPATCH=" has_newgrid_dispatch
    print "HAS_NEWGRID_EXIT=" has_newgrid_exit
    print "HAS_GRAPHICS_ENTRY=" has_graphics_entry
    print "HAS_GRAPHICS_DISPATCH=" has_graphics_dispatch
    print "HAS_GRAPHICS_EXIT=" has_graphics_exit
}
