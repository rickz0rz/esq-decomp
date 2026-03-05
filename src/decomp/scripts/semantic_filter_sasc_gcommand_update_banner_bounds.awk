BEGIN {
    has_entry = 0
    has_bounds_store = 0
    has_ui_busy_guard = 0
    has_compute_call = 0
    has_step_store = 0
    has_disable = 0
    has_rebuild_flag = 0
    has_enable = 0
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
    u = toupper(line)

    if (u ~ /^GCOMMAND_UPDATEBANNERBOUNDS:/) has_entry = 1
    if (index(u, "GCOMMAND_BANNERBOUNDLEFT") > 0 || index(u, "GCOMMAND_BANNERBOUNDTOP") > 0 || index(u, "GCOMMAND_BANNERBOUNDRIGHT") > 0 || index(u, "GCOMMAND_BANNERBOUNDBOTTOM") > 0) has_bounds_store = 1
    if (index(u, "GLOBAL_UIBUSYFLAG") > 0 && (u ~ /^TST\.[WL] / || u ~ /^MOVE\.[WL] /)) has_ui_busy_guard = 1
    if (index(u, "GCOMMAND_COMPUTEPRESETINCREMENT") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_compute_call = 1
    if (index(u, "GCOMMAND_BANNERSTEPLEFT") > 0 || index(u, "GCOMMAND_BANNERSTEPTOP") > 0 || index(u, "GCOMMAND_BANNERSTEPRIGHT") > 0 || index(u, "GCOMMAND_BANNERSTEPBOTTOM") > 0) has_step_store = 1
    if (index(u, "_LVODISABLE") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_disable = 1
    if (index(u, "GCOMMAND_BANNERREBUILDPENDINGFLAG") > 0 || index(u, "GCOMMAND_BANNERREBUILDPENDINGFLA") > 0) has_rebuild_flag = 1
    if (index(u, "_LVOENABLE") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_enable = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BOUNDS_STORE=" has_bounds_store
    print "HAS_UI_BUSY_GUARD=" has_ui_busy_guard
    print "HAS_COMPUTE_CALL=" has_compute_call
    print "HAS_STEP_STORE=" has_step_store
    print "HAS_DISABLE=" has_disable
    print "HAS_REBUILD_FLAG=" has_rebuild_flag
    print "HAS_ENABLE=" has_enable
    print "HAS_RETURN=" has_return
}
