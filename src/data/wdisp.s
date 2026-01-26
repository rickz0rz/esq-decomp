; ========== WDISP.c ==========
; weather display?

GLOB_STR_WDISP_C:
    NStr    "WDISP.c"
LAB_219D:
    NStr    "???/"
GLOB_STR_PERCENT_D_SLASH:
    NStr    "%d/"
LAB_219F:
    NStr    "???"
GLOB_STR_PERCENT_D:
    NStr    "%d"
GLOB_MEM_BYTES_ALLOCATED:
    DS.L    1
GLOB_MEM_ALLOC_COUNT:
    DS.L    1
GLOB_MEM_DEALLOC_COUNT:
    DS.L    1
GLOB_STR_DF1_DEBUG_LOG:
    NStr    "df1:debug.log"
GLOB_STR_A_PLUS:
    NStr    "a+"
    DS.L    1
    DC.L    $00280000
    DS.L    5
    DC.W    $8000
    DC.L    LAB_21A6
    DS.L    7
    DS.W    1
LAB_21A6:
    DC.L    LAB_21A7
    DS.L    7
    DS.W    1
LAB_21A7:
    DS.L    9
    DC.L    $00008000,$00000400
    DS.B    1
LAB_21A8:
    DC.B    $20
    DC.L    $20202020,$20202020,$28282828,$28202020
    DC.L    $20202020,$20202020,$20202020,$20202048
    DC.L    $10101010,$10101010,$10101010,$10101084
    DC.L    $84848484,$84848484,$84101010,$10101010
    DC.L    $81818181,$81810101,$01010101,$01010101
    DC.L    $01010101,$01010101,$01011010,$10101010
    DC.L    $82828282,$82820202,$02020202,$02020202
    DC.L    $02020202,$02020202,$02021010,$10102020
    DC.L    $20202020,$20202020,$28282828,$28202020
    DC.L    $20202020,$20202020,$20202020,$20202048
    DC.L    $10101010,$10101010,$10101010,$10101084
    DC.L    $84848484,$84848484,$84101010,$10101010
    DC.L    $81818181,$81810101,$01010101,$01010101
    DC.L    $01010101,$01010101,$01011010,$10101010
    DC.L    $82828282,$82820202,$02020202,$02020202
    DC.L    $02020202,$02020202,$02021010,$10102000
    DS.L    1
    DC.W    $0200
LAB_21A9:
    DC.L    $ffff0000,$000e000e
    DS.L    1
    DC.L    LAB_1AC7
    DS.L    1
    DC.L    $ffff0000,$00040004
    DS.L    2
    DC.L    LAB_21A9
    DC.L    $ffff0000,$00040004
    DS.L    1
    DC.L    LAB_1AC8
    DS.L    1
    DC.L    $ffff0000,$00040004
    DS.L    1
    DC.L    LAB_1AC9
    DS.L    1
BUFFER_5929_LONGWORDS:
    DS.L    19
; Pointer to the most recently allocated brush node (BRUSH_AllocBrushNode).
BRUSH_LastAllocatedNode:
LAB_21AB:
    DS.L    1
; Scratch buffer used by BRUSH_SelectBrushByLabel during comparisons.
BRUSH_LabelScratch:
LAB_21AC:
    DS.W    1
    DS.B    1
BRUSH_SnapshotHeader:
LAB_21AD:
    DS.B    1
    DS.L    8
; Cached brush width captured while BRUSH_PendingAlertCode is set.
BRUSH_SnapshotWidth:
LAB_21AE:
    DS.L    1
; Cached brush depth (planes) captured alongside BRUSH_SnapshotWidth.
BRUSH_SnapshotDepth:
LAB_21AF:
    DS.L    1
LAB_21B0:
    DS.L    128
LAB_21B1:
    DS.B    1
LAB_21B2:
    DS.B    1
LAB_21B3:
    DS.B    1
LAB_21B4:
    DS.B    1
GLOB_REF_LIST_IFF_TASK_PROC:
    DS.L    1
LAB_21B6:
    DS.L    1
LAB_21B7:
    DS.L    1
GLOB_REF_LIST_CLOSE_TASK_PROC:
    DS.L    1
LAB_21B9:
    DS.L    1
LAB_21BA:
    DS.L    1
GLOB_REF_LONG_FILE_SCRATCH:
    DS.L    1
LAB_21BC:
    DS.L    1
LAB_21BD:
    DS.L    1
LAB_21BE:
    DS.L    1
LAB_21BF:
    DS.L    1
LAB_21C0:
    DS.L    1
LAB_21C1:
    DS.L    1
LAB_21C2:
    DS.L    2
    DS.B    1
LAB_21C3:
    DS.B    1
    DS.L    5
    DS.W    1
LAB_21C4:
    DS.L    4
LAB_21C5:
    DS.L    1
LAB_21C6:
    DS.B    1
LAB_21C7:
    DS.B    1
LAB_21C8:
    DS.W    1
LAB_21C9:
    DS.L    1
LAB_21CA:
    DS.W    1
LAB_21CB:
    DS.W    1
LAB_21CC:
    DS.L    1
LAB_21CD:
    DS.L    1
LAB_21CE:
    DS.L    1
LAB_21CF:
    DS.L    1
LAB_21D0:
    DS.L    1
LAB_21D1:
    DS.L    1
LAB_21D2:
    DS.L    1
LAB_21D3:
    DS.L    1
LAB_21D4:
    DS.L    20
LAB_21D5:
    DS.W    1
LAB_21D6:
    DS.W    1
LAB_21D7:
    DS.L    10
LAB_21D8:
    DS.L    20
LAB_21D9:
    DS.L    1
LAB_21DA:
    DS.L    1
LAB_21DB:
    DS.L    1
LAB_21DC:
    DS.W    1
GLOB_REF_1000_BYTES_ALLOCATED_1:
    DS.L    1
GLOB_REF_1000_BYTES_ALLOCATED_2:
    DS.L    1
    DS.W    1
LAB_21DF:
    DS.L    1
LAB_21E0:
    DS.L    1
LAB_21E1:
    DS.W    1
LAB_21E2:
    DS.L    1
LAB_21E3:
    DS.W    1
LAB_21E4:
    DS.L    2
LAB_21E5:
    DS.W    1
LAB_21E6:
    DS.W    1
LAB_21E7:
    DS.L    1
LAB_21E8:
    DS.L    1
LAB_21E9:
    DS.L    1
LAB_21EA:
    DS.L    1
LAB_21EB:
    DS.L    1
GLOB_REF_BOOL_IS_LINE_OR_PAGE:
    DS.L    1
LAB_21ED:
    DS.W    1
LAB_21EE:
    DS.L    88
    DS.B    1
LAB_21EF:
    DS.B    1
LAB_21F0:
    DS.B    1
LAB_21F1:
    DS.B    1
    DS.L    2
    DS.W    1
LAB_21F2:
    DS.B    1
LAB_21F3:
    DS.B    1
LAB_21F4:
    DS.L    6
    DS.W    1
LAB_21F5:
    DS.L    79
    DS.W    1
    DS.B    1
LAB_21F6:
    DS.B    1
LAB_21F7:
    DS.B    1
LAB_21F8:
    DS.B    1
    DS.L    9
    DS.W    1
LAB_21F9:
    DS.L    80
LAB_21FA:
    DS.W    1
LAB_21FB:
    DS.L    16
GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER:
    DS.L    1
LAB_21FD:
    DS.L    1
LAB_21FE:
    DS.L    16
LAB_21FF:
    DS.L    1
LAB_2200:
    DS.L    1
LAB_2201:
    DS.L    1
LAB_2202:
    DS.L    2
    DS.W    1
LAB_2203:
    DS.W    1
LAB_2204:
    DS.L    20
LAB_2205:
    DS.W    1
LAB_2206:
    DS.W    1
LAB_2207:
    DS.L    1
LAB_2208:
    DS.L    1
LAB_2209:
    DS.L    1
LAB_220A:
    DS.L    1
LAB_220B:
    DS.L    1
LAB_220C:
    DS.L    1
LAB_220D:
    DS.L    1
LAB_220E:
    DS.L    2
GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB:
    DS.L    1
GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1:
    DS.L    1
LAB_2211_SERIAL_PORT_MAYBE:
    DS.L    1
LAB_2212:
    DS.L    1
GLOB_REF_INTB_RBF_64K_BUFFER:
    DS.L    1
GLOB_REF_INTERRUPT_STRUCT_INTB_RBF:
    DS.L    1
GLOB_REF_96_BYTES_ALLOCATED:
    DS.L    1
LAB_2216:
    DS.L    1
GLOB_REF_RASTPORT_1:
    DS.L    1
GLOB_REF_RASTPORT_2:
    DS.L    1
GLOB_REF_320_240_BITMAP:
    DS.L    2
LAB_221A:
    DS.L    8
GLOB_REF_696_400_BITMAP:
    DS.L    2
LAB_221C:
    DS.L    1
LAB_221D:
    DS.L    1
LAB_221E:
    DS.L    6
LAB_221F:
    DS.L    2
LAB_2220:
    DS.L    1
LAB_2221:
    DS.L    1
LAB_2222:
    DS.L    6
GLOB_REF_696_241_BITMAP:
    DS.L    2
LAB_2224:
    DS.L    1
LAB_2225:
    DS.L    1
LAB_2226:
    DS.L    1
LAB_2227:
    DS.L    1
LAB_2228:
    DS.L    4
LAB_2229:
    DS.L    1
LAB_222A:
    DS.W    1
LAB_222B:
    DS.W    1
LAB_222C:
    DS.L    1
LAB_222D:
    DS.B    1
LAB_222E:
    DS.B    1
LAB_222F:
    DS.W    1
LAB_2230:
    DS.W    1
LAB_2231:
    DS.W    1
LAB_2232:
    DS.W    1
LAB_2233:
    DS.L    301
LAB_2234:
    DS.L    1
LAB_2235:
    DS.L    302
LAB_2236:
    DS.L    302
LAB_2237:
    DS.L    302
LAB_2238:
    DS.B    1
LAB_2239:
    DS.B    1
LAB_223A:
    DS.W    1
LAB_223B:
    DS.W    1
LAB_223C:
    DS.W    1
LAB_223D:
    DS.W    1
LAB_223E:
    DS.W    1
LAB_223F:
    DS.W    1
GLOB_REF_CLOCKDATA_STRUCT:
    DS.W    1
LAB_2241:
    DS.W    1
LAB_2242:
    DS.W    1
LAB_2243:
    DS.W    1
LAB_2244:
    DS.W    1
LAB_2245:
    DS.L    2
    DS.W    1
    DS.B    1
LAB_2246:
    DS.B    1
    DS.L    2
    DS.W    1
LAB_2247:
    DS.W    1
LAB_2248:
    DS.W    1
LAB_2249:
    DS.L    10
    DS.B    1
LAB_224A:
    DS.B    1
LAB_224B:
    DS.W    1
LAB_224C:
    DS.W    1
LAB_224D:
    DS.W    1
LAB_224E:
    DS.W    1
LAB_224F:
    DS.L    303
LAB_2250:
    DS.L    1
LAB_2251:
    DS.L    46
LAB_2252:
    DS.W    1
LAB_2253:
    DS.W    1
LAB_2254:
    DS.W    1
LAB_2255:
    DS.W    1
LAB_2256:
    DS.W    1
LAB_2257:
    DS.W    1
    DS.B    1
LAB_2258:
    DS.B    1
LAB_2259:
    DS.L    112
    DS.W    1
LAB_225A:
    DS.L    20
LAB_225B:
    DS.L    10
LAB_225C:
    DS.W    1
LAB_225D:
    DS.W    1
LAB_225E:
    DS.L    1
LAB_225F:
    DS.L    1
LAB_2260:
    DS.L    1
LAB_2261:
    DS.L    1
LAB_2262:
    DS.L    1
LAB_2263:
    DS.W    1
LAB_2264:
    DS.W    1
LAB_2265:
    DS.W    1
LAB_2266:
    DS.W    1
LAB_2267:
    DS.L    1
LAB_2268:
    DS.L    1
LAB_2269:
    DS.L    1
LAB_226A:
    DS.W    1
GLOB_PTR_STR_SELECT_CODE:
    DS.L    2
    DS.W    1
GLOB_REF_BAUD_RATE:
    DS.L    1
LAB_226D:
    DS.W    1
LAB_226E:
    DS.L    1
LAB_226F:
    DS.W    1
LAB_2270:
    DS.W    1
LAB_2271:
    DS.W    1
LAB_2272:
    DS.L    1
LAB_2273:
    DS.W    1
LAB_2274:
    DS.W    1
LAB_2275:
    DS.W    1
LAB_2276:
    DS.W    1
LAB_2277:
    DS.W    1
GLOB_WORD_CURRENT_HOUR:
    DS.W    1
GLOB_WORD_CURRENT_MINUTE:
    DS.W    1
GLOB_WORD_CURRENT_SECOND:
    DS.W    1
LAB_227B:
    DS.W    1
LAB_227C:
    DS.W    1
GLOB_WORD_USE_24_HR_FMT:
    DS.W    1
LAB_227E:
    DS.W    1
LAB_227F:
    DS.W    1
LAB_2280:
    DS.W    1
CTRL_H:
    DS.W    1
LAB_2282:
    DS.W    1
LAB_2283:
    DS.W    1
LAB_2284:
    DS.W    1
LAB_2285:
    DS.W    1
DATACErrs:
    DS.W    1
LAB_2287:
    DS.W    1
GLOB_WORD_H_VALUE:
    DS.W    1
GLOB_WORD_T_VALUE:
    DS.W    1
LAB_228A:
    DS.W    1
GLOB_WORD_MAX_VALUE:
    DS.W    1
LAB_228C:
    DS.W    1
; Flag indicating a UI banner/key highlight is active.
WDISP_HighlightActive:
    DS.W    1
; Index of the highlighted entry (if used by callers).
WDISP_HighlightIndex:
    DS.W    1
LAB_228F:
    DS.W    1
LAB_2290:
    DS.L    1
LAB_2291:
    DS.W    1
LAB_2292:
    DS.W    1
LAB_2293:
    DS.W    1
LAB_2294:
    DS.W    1
LAB_2295:
    DS.B    1
LAB_2296:
    DS.B    1
LAB_2297:
    DS.L    23
    DS.W    1
LAB_2298:
    DS.L    1
LAB_2299:
    DS.W    1
LAB_229A:
    DS.L    1
LAB_229B:
    DS.B    1
LAB_229C:
    DS.B    1
LAB_229D:
    DS.W    1
LAB_229E:
    DS.W    1
LAB_229F:
    DS.W    1
LAB_22A0:
    DS.W    1
LAB_22A1:
    DS.W    1
LAB_22A2:
    DS.L    50
CTRLRead1:
    DS.W    1
CTRLRead2:
    DS.W    1
LAB_22A5:
    DS.W    1
LAB_22A6:
    DS.L    160
LAB_22A7:
    DS.L    65
    DS.W    1
LAB_22A8:
    DS.L    1
LAB_22A9:
    DS.W    1
LAB_22AA:
    DS.W    1
LAB_22AB:
    DS.W    1
LAB_22AC:
    DS.W    1
LAB_22AD:
    DS.L    3
    DS.W    1
LAB_22AE:
    DS.L    3
LAB_22AF:
    DS.W    1
LAB_22B0:
    DS.W    1
LAB_22B1:
    DS.W    1
LAB_22B2:
    DS.B    1
LAB_22B3:
    DS.B    1
    DS.W    1
LAB_22B4:
    DS.W    1
LAB_22B5:
    DS.W    1
LAB_22B6:
    DS.B    1
LAB_22B7:
    DS.B    1
    DS.W    1
LAB_22B8:
    DS.W    1
LAB_22B9:
    DS.W    1
LAB_22BA:
    DS.B    1
LAB_22BB:
    DS.B    1
    DS.W    1
LAB_22BC:
    DS.W    1
LAB_22BD:
    DS.W    1
LAB_22BE:
    DS.B    1
LAB_22BF:
    DS.B    1
    DS.L    20
    DS.W    1
LAB_22C0:
    DS.W    1
LAB_22C1:
    DS.W    1
LAB_22C2:
    DS.L    21
LAB_22C3:
    DS.L    5
LAB_22C4:
    DS.L    1
    DS.W    1
LAB_22C5:
    DS.L    1
LAB_22C6:
    DS.L    2
    DS.B    1
LAB_22C7:
    DS.B    1
LAB_22C8:
    DS.L    2
    DS.W    1
LAB_22C9:
    DS.L    1
    DS.W    1
LAB_22CA:
    DS.L    2
LAB_22CB:
    DS.L    28
LAB_22CC:
    DS.W    1
LAB_22CD:
    DS.L    1
LAB_22CE:
    DS.L    1
LAB_22CF:
    DS.L    1
LAB_22D0:
    DS.L    1
LAB_22D1:
    DS.L    1
LAB_22D2:
    DS.L    1
LAB_22D3:
    DS.W    1
LAB_22D4:
    DS.L    1
LAB_22D5:
    DS.W    1
LAB_22D6:
    DS.L    1
LAB_22D7:
    DS.L    1
LAB_22D8:
    DS.L    1
LAB_22D9:
    DS.L    1
LAB_22DA:
    DS.L    1
LAB_22DB:
    DS.L    1
LAB_22DC:
    DS.L    1
LAB_22DD:
    DS.L    1
LAB_22DE:
    DS.L    1
LAB_22DF:
    DS.L    1
LAB_22E0:
    DS.B    1
LAB_22E1:
    DS.B    1
LAB_22E2:
    DS.L    1
LAB_22E3:
    DS.L    1
LAB_22E4:
    DS.W    1
LAB_22E5:
    DS.L    1
LAB_22E6:
    DS.L    1
LAB_22E7:
    DS.L    1
LAB_22E8:
    DS.L    1
LAB_22E9:
    DS.L    1
LAB_22EA:
    DS.L    1
LAB_22EB:
    DS.L    1
LAB_22EC:
    DS.L    1
LAB_22ED:
    DS.L    1
LAB_22EE:
    DS.L    1
LAB_22EF:
    DS.B    1
LAB_22F0:
    DS.B    1
LAB_22F1:
    DS.L    1
LAB_22F2:
    DS.L    1
LAB_22F3:
    DS.L    1
LAB_22F4:
    DS.L    8
LAB_22F5:
    DS.L    512
LAB_22F6:
    DS.L    2
LAB_22F7:
    DS.L    4
LAB_22F8:
    DS.L    2
LAB_22F9:
    DS.L    4
LAB_22FA:
    DS.L    2
LAB_22FB:
    DS.L    4
LAB_22FC:
    DS.L    2
LAB_22FD:
    DS.L    4
; Tracks whether the digital banner highlight is enabled (0/1).
GCOMMAND_HighlightFlag:
    DS.W    1
LAB_22FF:
    DS.L    1
LAB_2300:
    DS.L    1
LAB_2301:
    DS.L    1
LAB_2302:
    DS.L    1
LAB_2303:
    DS.L    1
LAB_2304:
    DS.L    1
LAB_2305:
    DS.L    1
LAB_2306:
    DS.L    1
LAB_2307:
    DS.L    1
LAB_2308:
    DS.L    1
LAB_2309:
    DS.W    1
LAB_230A:
    DS.W    1
LAB_230B:
    DS.L    1
LAB_230C:
    DS.L    1
LAB_230D:
    DS.L    1
LAB_230E:
    DS.L    1
LAB_230F:
    DS.L    1
LAB_2310:
    DS.L    1
LAB_2311:
    DS.L    1
LAB_2312:
    DS.L    1
    DS.W    1
GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE:
    DS.L    1
GLOB_REF_DATA_INPUT_BUFFER:
    DS.L    1
GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE:
    DS.L    1
GLOB_REF_INPUTDEVICE_MSGPORT:
    DS.L    1
GLOB_REF_CONSOLEDEVICE_MSGPORT:
    DS.L    1
LAB_2318:
    DS.L    1
LAB_2319:
    DS.L    3
LAB_231A:
    DS.L    4
LAB_231B:
    DS.L    1
LAB_231C:
    DS.L    1
LAB_231D:
    DS.L    25
LAB_231E:
    DS.L    1
LAB_231F:
    DS.L    2
LAB_2320:
    DS.L    1
LAB_2321:
    DS.L    2
LAB_2322:
    DS.L    1
LAB_2323:
    DS.L    3
LAB_2324:
    DS.L    6
LAB_2325:
    DS.L    1
GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST:
    DS.L    1
GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT:
    DS.L    1
LAB_2328:
    DS.W    1
LAB_2329:
    DS.W    1
LAB_232A:
    DS.W    1
LAB_232B:
    DS.W    1
LAB_232C:
    DS.L    1
LAB_232D:
    DS.L    1
LAB_232E:
    DS.L    1
LAB_232F:
    DS.L    2
LAB_2330:
    DS.L    3
LAB_2331:
    DS.L    1
    DS.W    1
LAB_2332:
    DS.L    6
    DS.W    1
LAB_2333:
    DS.L    1
LAB_2334:
    DS.L    1
LAB_2335:
    DS.L    1
LAB_2336:
    DS.L    19
LAB_2337:
    DS.L    1
LAB_2338:
    DS.L    10
LAB_2339:
    DS.L    1
LAB_233A:
    DS.L    2
LAB_233B:
    DS.L    1
LAB_233C:
    DS.L    1
LAB_233D:
    DS.L    1
LAB_233E:
    DS.L    1
LAB_233F:
    DS.L    520
CTRL_BUFFER:
    DS.L    125
LAB_2341:
    DS.W    1
LAB_2342:
    DS.W    1
LAB_2343:
    DS.L    1
GLOB_WORD_CLOCK_SECONDS:
    DS.W    1
CTRLRead3:
    DS.W    1
LAB_2346:
    DS.W    1
LAB_2347:
    DS.W    1
LAB_2348:
    DS.W    1
LAB_2349:
    DS.W    1
LAB_234A:
    DS.W    1
LAB_234B:
    DS.L    50
LAB_234C:
    DS.L    50
LAB_234D:
    DS.W    1
LAB_234E:
    DS.W    1
LAB_234F:
    DS.W    1
LAB_2350:
    DS.L    1
LAB_2351:
    DS.L    1
LAB_2352:
    DS.W    1
LAB_2353:
    DS.W    1
LAB_2354:
    DS.W    1
LAB_2355:
    DS.L    112
LAB_2356:
    DS.W    1
LAB_2357:
    DS.L    1
LAB_2358:
    DS.W    1
LAB_2359:
    DS.W    1
LAB_235A:
    DS.W    1
LAB_235B:
    DS.W    1
LAB_235C:
    DS.W    1
LAB_235D:
    DS.W    1
LAB_235E:
    DS.L    302
LAB_235F:
    DS.L    1
LAB_2360:
    DS.W    1
LAB_2361:
    DS.W    1
LAB_2362:
    DS.L    1
LAB_2363:
    DS.L    1
LAB_2364:
    DS.W    1
LAB_2365:
    DS.W    1
LAB_2366:
    DS.L    20
    DS.B    1
LAB_2367:
    DS.B    1
    DS.L    128
LAB_2368:
    DS.W    1
LAB_2369:
    DS.W    1
LAB_236A:
    DS.L    151
LAB_236B:
    DS.L    20
LAB_236C:
    DS.W    1
LAB_236D:
    DS.W    1
LAB_236E:
    DS.W    1
LAB_236F:
    DS.W    1
LAB_2370:
    DS.W    1
LAB_2371:
    DS.L    75
    DS.W    1
LAB_2372:
    DS.B    1
LAB_2373:
    DS.B    1
LAB_2374:
    DS.B    1
LAB_2375:
    DS.B    1
LAB_2376:
    DS.B    1
LAB_2377:
    DS.B    1
LAB_2378:
    DS.B    1
LAB_2379:
    DS.B    1
LAB_237A:
    DS.L    1
    DS.W    1
LAB_237B:
    DS.L    2
LAB_237C:
    DS.L    2
    DS.W    1
LAB_237D:
    DS.L    1
    DS.W    1
LAB_237E:
    DS.L    346
    DS.W    1
LAB_237F:
    DS.L    171
    DS.W    1
LAB_2380:
    DS.L    1
LAB_2381:
    DS.L    214
; Through a bit of manual work, I was able to figure out this points to dos.library
GLOB_REF_DOS_LIBRARY_2:
    DS.L    55

    if includeCustomAriAssembly
LAB_CTRLHTCMAX:
    NStr    "CTRL H:%04ld Cnt:%ld CRC:%02x State:%ld Byte:%02x"
    endif

    END
