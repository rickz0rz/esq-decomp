; ========== SCRIPT.c ==========

GLOB_STR_SCRIPT_C_1:
    NStr    "SCRIPT.c"
GLOB_STR_SCRIPT_C_2:
    NStr    "SCRIPT.c"
LAB_20AB:
    DS.L    1
LAB_20AC:
    DS.L    1
GLOB_STR_NO_CURRENT_WEATHER_DATA_AVIALABLE:
    NStr    "No Current Weather Data Available"
GLOB_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE:
    DC.L    GLOB_STR_NO_CURRENT_WEATHER_DATA_AVIALABLE
LAB_20AF:
    NStr    "No Forecast Weather Data Available"
LAB_20B0:
    DC.L    LAB_20AF
LAB_20B1:
    NStr    "May not be available in all areas."
LAB_20B2:
    DC.L    LAB_20B1
LAB_20B3:
    NStr    "Continued"
    DC.L    LAB_20B3

GLOB_STR_JANUARY:
    NStr    "January"
GLOB_STR_FEBRUARY:
    NStr    "February"
GLOB_STR_MARCH:
    NStr    "March"
GLOB_STR_APRIL:
    NStr    "April"
GLOB_STR_MAY:
    NStr    "May"
GLOB_STR_JUNE:
    NStr    "June"
GLOB_STR_JULY:
    NStr    "July"
GLOB_STR_AUGUST:
    NStr    "August"
GLOB_STR_SEPTEMBER:
    NStr    "September"
GLOB_STR_OCTOBER:
    NStr    "October"
GLOB_STR_NOVEMBER:
    NStr    "November"
GLOB_STR_DECEMBER:
    NStr    "December"

GLOB_JMPTBL_MONTHS:
    DC.L    GLOB_STR_JANUARY
    DC.L    GLOB_STR_FEBRUARY
    DC.L    GLOB_STR_MARCH
    DC.L    GLOB_STR_APRIL
    DC.L    GLOB_STR_MAY
    DC.L    GLOB_STR_JUNE
    DC.L    GLOB_STR_JULY
    DC.L    GLOB_STR_AUGUST
    DC.L    GLOB_STR_SEPTEMBER
    DC.L    GLOB_STR_OCTOBER
    DC.L    GLOB_STR_NOVEMBER
    DC.L    GLOB_STR_DECEMBER

LAB_20C1:
    NStr    "Jan "
LAB_20C2:
    NStr    "Feb "
LAB_20C3:
    NStr    "Mar "
LAB_20C4:
    NStr    "Apr "
LAB_20C5:
    NStr    "May "
LAB_20C6:
    NStr    "Jun "
LAB_20C7:
    NStr    "Jul "
LAB_20C8:
    NStr    "Aug "
LAB_20C9:
    NStr    "Sep "
LAB_20CA:
    NStr    "Oct "
LAB_20CB:
    NStr    "Nov "
LAB_20CC:
    NStr    "Dec "

GLOB_JMPTBL_SHORT_MONTHS:
    DC.L    LAB_20C1
    DC.L    LAB_20C2
    DC.L    LAB_20C3
    DC.L    LAB_20C4
    DC.L    LAB_20C5
    DC.L    LAB_20C6
    DC.L    LAB_20C7
    DC.L    LAB_20C8
    DC.L    LAB_20C9
    DC.L    LAB_20CA
    DC.L    LAB_20CB
    DC.L    LAB_20CC

GLOB_STR_SUNDAY_1:
    NStr    "Sunday"
GLOB_STR_MONDAY_1:
    NStr    "Monday"
GLOB_STR_TUESDAY_1:
    NStr    "Tuesday"
GLOB_STR_WEDNESDAY_1:
    NStr    "Wednesday"
GLOB_STR_THURSDAY_1:
    NStr    "Thursday"
GLOB_STR_FRIDAY_1:
    NStr    "Friday"
GLOB_STR_SATURDAY_1:
    NStr    "Saturday"

GLOB_JMPTBL_DAYS_OF_WEEK:
    DC.L    GLOB_STR_SUNDAY_1
    DC.L    GLOB_STR_MONDAY_1
    DC.L    GLOB_STR_TUESDAY_1
    DC.L    GLOB_STR_WEDNESDAY_1
    DC.L    GLOB_STR_THURSDAY_1
    DC.L    GLOB_STR_FRIDAY_1
    DC.L    GLOB_STR_SATURDAY_1

LAB_20D6:
    NStr    "Sun "
LAB_20D7:
    NStr    "Mon "
LAB_20D8:
    NStr    "Tue "
LAB_20D9:
    NStr    "Wed "
LAB_20DA:
    NStr    "Thu "
LAB_20DB:
    NStr    "Fri "
LAB_20DC:
    NStr    "Sat "
GLOB_JMPTBL_SHORT_DAYS_OF_WEEK:
    DC.L    LAB_20D6
    DC.L    LAB_20D7
    DC.L    LAB_20D8
    DC.L    LAB_20D9
    DC.L    LAB_20DA
    DC.L    LAB_20DB
    DC.L    LAB_20DC
LAB_20DE:
    NStr    "Monday"
LAB_20DF:
    NStr    "Tuesday"
LAB_20E0:
    NStr    "Wednesday"
LAB_20E1:
    NStr    "Thursday"
LAB_20E2:
    NStr    "Friday"
LAB_20E3:
    NStr    "Saturday"
LAB_20E4:
    NStr    "Sunday"
LAB_20E5:
    NStr    "Weekdays"
LAB_20E6:
    NStr    "Weeknights"
LAB_20E7:
    NStr    "Coming Soon"
LAB_20E8:
    NStr    "This Month"
LAB_20E9:
    NStr    "Next Month"
LAB_20EA:
    NStr    "This Fall"
LAB_20EB:
    NStr    "This Summer"
LAB_20EC:
    DC.W    "Tu"
LAB_20ED:
    NStr    "esdays & Fridays"
LAB_20EE:
    NStr    "Mondays & Saturdays"
LAB_20EF:
    NStr    "Weekends"
LAB_20F0:
    NStr    "Every Night"
LAB_20F1:
    NStr    "Every Day"
LAB_20F2:
    DS.W    1
LAB_20F3:
    DS.W    1
LAB_20F4:
    DS.W    1
LAB_20F5:
    DS.W    1
LAB_20F6:
    NStr    "Mondays thru Saturdays"
LAB_20F7:
    NStr    "Mondays thru Thursdays"
LAB_20F8:
    NStr    "Weekday Mornings"
LAB_20F9:
    NStr    "Weekday Afternoons"
LAB_20FA:
    NStr    "Tuesdays & Thursdays"
LAB_20FB:
    NStr    "This Week"
    DC.L    LAB_20DE
    DC.L    LAB_20DF
    DC.L    LAB_20E0
    DC.L    LAB_20E1
    DC.L    LAB_20E2
    DC.L    LAB_20E3
    DC.L    LAB_20E4
    DC.L    LAB_20E5
    DC.L    LAB_20E6
    DC.L    LAB_20E7
    DC.L    LAB_20E8
    DC.L    LAB_20E9
    DC.L    LAB_20EA
    DC.L    LAB_20EB
    DC.L    LAB_20EC
    DC.L    LAB_20EE
    DC.L    LAB_20EF
    DC.L    LAB_20F0
    DC.L    LAB_20F1
    DC.L    LAB_20F2
    DC.L    LAB_20F3
    DC.L    LAB_20F4
    DC.L    LAB_20F5
    DC.L    LAB_20F6
    DC.L    LAB_20F7
    DC.L    LAB_20F8
    DC.L    LAB_20F9
    DC.L    LAB_20FA
    DC.L    LAB_20FB

; Another struct?
GLOB_STR_ALIGNED_NOW_SHOWING:
    DC.B    TextAlignCenter,"Now showing",0
GLOB_STR_ALIGNED_NEXT_SHOWING:
    DC.B    TextAlignCenter,"Next showing ",0
GLOB_STR_ALIGNED_TODAY_AT:
    DC.B    TextAlignCenter,"Today at ",0
GLOB_STR_ALIGNED_TOMORROW_AT:
    DC.B    TextAlignCenter,"Tomorrow at ",0
GLOB_STR_SHOWTIMES_AND_SINGLE_SPACE:
    NStr    "Showtimes "
GLOB_STR_SHOWING_AT_AND_SINGLE_SPACE:
    NStr    "Showing at "
LAB_2102:
    DC.B    "hrs ",0
LAB_2103:
    DC.B    "hr ",0
LAB_2104:
    DC.B    "min)",0
GLOB_STR_ALIGNED_TONIGHT_AT:
    DC.B    TextAlignCenter,"Tonight at ",0
GLOB_STR_ALIGNED_ON:
    DC.B    TextAlignCenter,"on",0
GLOB_STR_ALIGNED_CHANNEL_1:
    NStr2   TextAlignCenter,"Channel "
LAB_2108:
    NStr    "Sports on "
LAB_2109:
    DC.L    LAB_2108
LAB_210A:
    NStr    "Movie Summary for "
LAB_210B:
    DC.L    LAB_210A
LAB_210C:
    NStr    "Summary of "
LAB_210D:
    DC.L    LAB_210C
LAB_210E:
    NStr    " channel "
LAB_210F:
    DC.L    LAB_210E
LAB_2110:
    NStr    "No Data."
LAB_2111:
    DC.L    LAB_2110
GLOB_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    NStr    "Please Stand By for your Local Listings.  ER007"
GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    DC.L    GLOB_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
GLOB_STR_OFF_AIR_1:
    NStr    "Off Air."
LAB_2115:
    DC.L    GLOB_STR_OFF_AIR_1
GLOB_STR_GRID_DATE_FORMAT_STRING:
    NStr    "%s %s %ld %04ld"
GLOB_STR_WEATHER_UPDATE_FOR:
    NStr    "Weather Update for "
LAB_2118:
    DS.W    1
LAB_2119:
    DS.W    1
LAB_211A:
    DS.W    1
LAB_211B:
    DS.W    1
LAB_211C:
    DS.W    1
LAB_211D:
    DS.W    1
LAB_211E:
    DC.W    $ffff
LAB_211F:
    DS.W    1
LAB_2120:
    DS.W    1
LAB_2121:
    DS.W    1
LAB_2122:
    DS.W    1
; Brush pointers exposed to scripting (primary/secondary selections).
BRUSH_ScriptPrimarySelection:
    DS.L    1
BRUSH_ScriptSecondarySelection:
    DS.L    1
LAB_2125:
    DS.L    1
LAB_2126:
    DC.B    "x"
LAB_2127:
    DS.B    1
LAB_2128:
    DS.W    1
LAB_2129:
    DS.L    1
LAB_212A:
    DS.W    1
LAB_212B:
    DS.W    1
LAB_212C:
    NStr    "00"
LAB_212D:
    NStr    "00"
LAB_212E:
    NStr    "11"
LAB_212F:
    NStr    "11"
LAB_2130:
    NStr    "yl"
    DS.W    1
LAB_2131:
    DS.W    1
GLOB_STR_PREVUESPORTS:
    NStr    "PrevueSports"
LAB_2133:
    DC.L    GLOB_STR_PREVUESPORTS
LAB_2134:
    NStr    TextAlignCenter
LAB_2135:
    NStr    TextAlignCenter
LAB_2136:
    NStr    "   "
LAB_2137:
    NStr2   TextAlignCenter,"Ch. "
LAB_2138:
    NStr    "   "
LAB_2139:
    NStr2   TextAlignCenter,"%c"
LAB_213A:
    NStr    TextAlignCenter
LAB_213B:
    NStr    TextAlignCenter
LAB_213C:
    NStr    "   "
LAB_213D:
    NStr    TextAlignCenter
LAB_213E:
    NStr    TextAlignCenter
LAB_213F:
    NStr2   TextAlignCenter,"%s"
LAB_2140:
    NStr    " at "
LAB_2141:
    NStr    " vs. "
LAB_2142:
    NStr    " vs "
LAB_2143:
    NStr    TextAlignCenter
GLOB_STR_ALIGNED_CHANNEL_2:
    NStr2   TextAlignCenter,"Channel "
LAB_2145:
    DC.W    $0300
LAB_2146:
    NStr    "PPV"
LAB_2147:
    NStr    "SBE"
LAB_2148:
    NStr    "SPORTS"
LAB_2149:
    DC.W    $ffff
LAB_214A:
    DC.B    0,"1"
LAB_214B:
    DS.L    1
LAB_214C:
    NStr3   "xx%s",18,"TEMPO"