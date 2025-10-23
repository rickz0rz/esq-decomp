; ========== TLIBA1.c ==========

GLOB_STR_TLIBA1_C_1:
    NStr    "TLIBA1.c"
GLOB_STR_TLIBA1_C_2:
    NStr    "TLIBA1.c"
GLOB_STR_TLIBA1_C_3:
    NStr    "TLIBA1.c"
LAB_2164:
    DC.B    "TLIBA1.c",0
LAB_2165:
    DS.B    1
    DS.W    1
LAB_2166:
    DS.W    1
LAB_2167:
    DS.W    1
LAB_2168:
    DS.W    1
LAB_2169:
    DS.W    1
LAB_216A:
    NStr    "%c%s"
LAB_216B:
    NStr2   "struct TLFormat @ 0x%x =",TextLineFeed
LAB_216C:
    NStr2   "{",TextLineFeed
LAB_216D:
    NStr3   TextHorizontalTab,"tlf_Color =   %d",TextLineFeed
LAB_216E:
    NStr3   TextHorizontalTab,"tlf_Offset =  %d",TextLineFeed
LAB_216F:
    NStr3   TextHorizontalTab,"tlf_FontSel = %d",TextLineFeed
LAB_2170:
    NStr3   TextHorizontalTab,"tlf_Align =   %d",TextLineFeed
LAB_2171:
    NStr3   TextHorizontalTab,"tlf_Pregap =  %d",TextLineFeed
LAB_2172:
    NStr2   "}",TextLineFeed
LAB_2173:
    DS.W    1
LAB_2174:
    DC.B    1,"("
LAB_2175:
    NStr    "%03ld"
LAB_2176:
    NStr    "%03ld"
LAB_2177:
    NStr    "ViewMode = %ld"
LAB_2178:
    DS.L    1
LAB_2179:
    DS.W    1
LAB_217A:
    DS.W    1
LAB_217B:
    DS.W    1
LAB_217C:
    NStr2   "%s: diwoffset=$%04lx, ddfoffset=$%04lx, bplcon1=$%04lx",TextLineFeed
LAB_217D:
    NStr2   "DIWSTRT: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_217E:
    NStr2   "DIWSTOP: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_217F:
    NStr2   "DDFSTRT: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2180:
    NStr2   "DDFSTOP: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2181:
    NStr2   "BPL1MOD: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2182:
    NStr2   "BPL2MOD: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2183:
    NStr2   "BPLCON0: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2184:
    NStr2   "BPLCON1: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2185:
    NStr2   "BPLCON2: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
LAB_2186:
    NStr2   "BPL1PTH: 0x%04lx 0x%04lx",TextLineFeed
LAB_2187:
    NStr2   "BPL1PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
LAB_2188:
    NStr2   "BPL2PTH: 0x%04lx 0x%04lx",TextLineFeed
LAB_2189:
    NStr2   "BPL2PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
LAB_218A:
    NStr2   "BPL3PTH: 0x%04lx 0x%04lx",TextLineFeed
LAB_218B:
    NStr2   "BPL3PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
LAB_218C:
    NStr2   "BPL4PTH: 0x%04lx 0x%04lx",TextLineFeed
LAB_218D:
    NStr2   "BPL4PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
LAB_218E:
    NStr2   "BPL5PTH: 0x%04lx 0x%04lx",TextLineFeed
LAB_218F:
    NStr2   "BPL5PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
LAB_2190:
    NStr    10
GLOB_STR_VM_ARRAY_1:
    NStr    "VM[ARRAY[%ld]"
GLOB_STR_VM_ARRAY_2:
    NStr    "VM[ARRAY[%ld]"
LAB_2193:
    NStr    10
    DS.W    1
LAB_2194:
    DS.L    1
LAB_2195:
    DS.L    1
LAB_2196:
    DS.W    1
LAB_2197:
    DS.L    1
    DC.L    $00000001
    DS.L    2
    DC.L    $00000001
LAB_2198:
    DS.L    1
    DC.L    $00000001
    DS.L    2
    DC.L    $00000001
LAB_2199:
    DS.L    1
    DC.L    $00000001
    DS.L    2
    DC.L    $00000001
LAB_219A:
    DS.L    1
    DC.L    $00000001
    DS.L    2
LAB_219B:
    DC.L    $00000001
