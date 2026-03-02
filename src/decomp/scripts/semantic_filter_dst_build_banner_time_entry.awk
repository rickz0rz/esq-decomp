BEGIN {
    label=0; leap=0; build=0; classify=0; sec2struct=0; divs=0; mulu=0
    day=0; cacheyear=0; mode=0; pri=0; sec=0; fmt=0
    c54=0; c60=0; c89=0; c30=0; c12=0; c24=0; ce10=0; ret=0
}

/^DST_BuildBannerTimeEntry:$/ { label=1 }
/DATETIME_IsLeapYear/ { leap=1 }
/DATETIME_BuildFromBaseDay/ { build=1 }
/DATETIME_ClassifyValueInRange/ { classify=1 }
/DATETIME_SecondsToStruct/ { sec2struct=1 }
/GROUP_AG_JMPTBL_MATH_DivS32/ { divs=1 }
/GROUP_AG_JMPTBL_MATH_Mulu32/ { mulu=1 }
/CLOCK_DaySlotIndex/ { day=1 }
/CLOCK_CacheYear/ { cacheyear=1 }
/ESQ_SecondarySlotModeFlagChar/ { mode=1 }
/DST_BannerWindowPrimary/ { pri=1 }
/DST_BannerWindowSecondary/ { sec=1 }
/CLOCK_FormatVariantCode/ { fmt=1 }
/#\$36|#54|54\.[Ww]/ { c54=1 }
/#\$3c|#60|60\.[Ww]/ { c60=1 }
/#\$59|#89|89\.[Ww]/ { c89=1 }
/#\$1e|#30|30\.[Ww]/ { c30=1 }
/#\$c|#12|12\.[Ww]/ { c12=1 }
/#\$18|#24|24\.[Ww]/ { c24=1 }
/#\$e10|#3600|3600\.[Ww]/ { ce10=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (leap) print "HAS_LEAP_CALL"
    if (build) print "HAS_BUILD_FROM_BASE_DAY_CALL"
    if (classify) print "HAS_CLASSIFY_CALL"
    if (sec2struct) print "HAS_SECONDS_TO_STRUCT_CALL"
    if (divs) print "HAS_DIVS_CALL"
    if (mulu) print "HAS_MULU_CALL"
    if (day) print "HAS_DAY_SLOT_REF"
    if (cacheyear) print "HAS_CACHE_YEAR_REF"
    if (mode) print "HAS_MODE_REF"
    if (pri) print "HAS_PRIMARY_REF"
    if (sec) print "HAS_SECONDARY_REF"
    if (fmt) print "HAS_FORMAT_VARIANT_REF"
    if (c54) print "HAS_CONST_54"
    if (c60) print "HAS_CONST_60"
    if (c89) print "HAS_CONST_89"
    if (c30) print "HAS_CONST_30"
    if (c12) print "HAS_CONST_12"
    if (c24) print "HAS_CONST_24"
    if (ce10) print "HAS_CONST_E10"
    if (ret) print "HAS_RTS"
}
