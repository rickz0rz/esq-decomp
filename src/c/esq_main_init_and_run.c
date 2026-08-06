/* RESTORES: ESQ_MainInitAndRun
 * MODULE:   modules/groups/a/m/esq.s
 * STATUS:   behavioural
 *
 * The program's startup routine and its idle loop, 3528 bytes -- the largest
 * single function in ESQ after the serial command dispatcher. It is almost all
 * straight-line work, which is why it reads long but decomposes cleanly:
 *
 *   1. argv[1] becomes the select code, and the string "RAVESC" in it is a mode
 *      flag rather than a code.
 *   2. graphics / diskfont / dos / intuition open; each failure calls
 *      BUFFER_FlushAllAndCloseWithCode(0) and then CONTINUES. That is the
 *      original's behaviour, not an oversight in the transcription -- the
 *      close-out routine does not return, so the fall-through is unreachable.
 *   3. utility.library and battclock.resource are opened only on Kickstart 2.0
 *      or later (graphics lib_Version >= 37).
 *   4. four fonts, with topaz substituted for any disk font that fails.
 *   5. two RastPorts, five bitmaps and four raster families, each allocated
 *      through the file/line-tagged wrappers and cleared with BltClear.
 *   6. serial.device at the selected baud, then the RBF / AUD1 / VERTB
 *      interrupt servers.
 *   7. the INI files, the brush list and the banner tables.
 *   8. the idle loop: tick the UI, watch the clock, and consume one serial
 *      command byte per pass until the shutdown flag is set.
 *
 * Two structural points worth stating because they look like transcription
 * errors and are not:
 *
 * THE HARDWARE-WARNING PATH NEVER RETURNS. When either compatibility flag is
 * set the routine draws its messages, runs the copper rise, and then spins
 * forever (`for (;;) ;` -- `BRA.S` to itself in the original). ESQ is a
 * broadcast box with no operator console, so hanging with an error on screen IS
 * the error handler.
 *
 * THE FLAG NAMES READ BACKWARDS. Warnings are shown when
 * IS_COMPATIBLE_VIDEO_CHIP or HAS_REQUESTED_FAST_MEMORY is NON-zero. The names
 * come from the disassembly and are kept for cross-referencing; the sense is
 * "chip is wrong" / "fast memory is missing".
 *
 * The font handle written through here is a ColorTextFont, not a plain
 * TextFont: the two stores land past the 52-byte TextFont, on the low byte of
 * ctf_Flags (bit 0 = CT_COLORFONT) and on ctf_FgColor. `struct EsqColorFont`
 * spells those two offsets out rather than casting and adding, so the
 * displacements fold into the stores -- see AGENTS.md on cast-and-add.
 *
 * SASC-MISMATCH: library-base-reload
 *   ref:     2c780004                        MOVEA.L AbsExecBase,A6   (4 bytes)
 *   got:     2c7900000000                    MOVEA.L _SysBase,A6      (6 bytes)
 *   summary: 3612 against 3528, +84 over 105 regions, and the base loads
 *            account for +82 of it. Counted rather than estimated: the function
 *            makes 36 library calls; the original issues 25 base loads for them
 *            (8 short-absolute from AbsExecBase, 17 absolute-long), so it CACHES
 *            the base across 11 calls. The volatile headers reload before every
 *            one, giving 36 loads.
 *              11 added loads   x 6 bytes = +66
 *               8 exec loads, 4 -> 6 bytes = +16
 *            The reloads are mandatory, not a tuning choice: this function calls
 *            ESQ assembly that returns with A6 clobbered, so a cached base
 *            enters the wrong library at the same offset and resets the machine.
 *            esq-graphics-leaf.h cannot help -- the header choice is per file,
 *            and this file is the opposite of a leaf. See esq-libbase.md.
 *   tried:   nothing. A non-volatile base here is a machine reset, not a
 *            byte-count question.
 *   scope:   every restoration that mixes library calls with ESQ calls. This is
 *            the largest single instance in the program.
 *   retest:  not a compiler question. It goes away only when the ESQ assembly
 *            those 11 spans call is itself restored and preserves A6.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fff0 ... 4cdf0cec 4e5d      LINK.W A5,#-16 / MOVEM / UNLK A5
 *   got:     9efc0010 ... 4cdf6cec defc0010  SUBA.W #16,A7 / MOVEM / ADDA.W
 *   summary: +2, the remaining balance of the +84. 6.51 addresses its 16 bytes
 *            of locals off A7 and saves A5/A6 in the entry MOVEM instead of
 *            building a frame. Same size at entry, two bytes more at exit.
 *   scope:   program-wide; the A5-frame class is recorded in
 *            docs/compiler-version.md.
 *   retest:  a compiler that reserves A5 as a frame pointer.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                        JSR (d16,PC)
 *   got:     61000000                        BSR.W
 *   summary: all ~70 ESQ calls here were cross-unit in the original. Same size,
 *            same displacement, same semantics, different opcode -- so this
 *            class costs no bytes and is why the itemisation above adds up.
 *   scope:   the whole cross-unit bucket, 0 exact of 150.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: divide-for-a-parity-test
 *   ref:     7044 3200 2001 7202 4eba....    MOVEQ #68 / ... / JSR MATH_DivS32
 *   got:     the remainder computed inline
 *   summary: the highlight raster height is halved only to test the REMAINDER,
 *            which the original takes from MATH_DivS32 in D1. A C return value
 *            carries the quotient alone, so this is written with `%`. Size
 *            neutral in the total above, which is why it is not itemised
 *            separately -- it lands inside the balanced region.
 *   tried:   reading the height back out of the global rather than holding it
 *            in a local, so 6.51 cannot fold the test away. That keeps the
 *            behaviour; the call itself still cannot be MATH_DivS32.
 *   scope:   every site wanting a quotient AND a remainder from ESQ's own
 *            divide helpers.
 *   retest:  a compiler whose integer divide IS the ESQ helper.
 *
 * SASC-MISMATCH: constant-materialisation
 *   ref:     7078 d080                       MOVEQ #120,D0 / ADD.L D0,D0
 *   got:     the literal 240
 *   summary: the original builds 240, 241, 218 and 176 from small immediates
 *            with ADD.L or NOT.B rather than loading them. Six sites, all
 *            inside regions that balance out in the itemisation above.
 *   scope:   this function, and anywhere the original wanted a constant over 127.
 *   retest:  a compiler with the same immediate-synthesis rule.
 *
 * Address-computation check (AGENTS.md rule 2): reference 11 `LEA (d16,An),Am`
 * sites against 0 emitted. A DEFICIT, not an excess -- the struct forms here fold
 * their offsets into the accessing instruction, so no address is recomputed.
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/lists.h>
#include <dos/dosextens.h>
#include <devices/serial.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <string.h>

#include "esq-exec.h"
#include "esq-dos.h"
#include "esq-graphics.h"
#include "esq-diskfont.h"

/* The two stores land past the end of struct TextFont, on struct ColorTextFont's
 * own fields. Named here so each store folds its offset into a displacement. */
struct EsqColorFont {
    unsigned char pad[53];
    unsigned char flagsLo;          /* 53: low byte of ctf_Flags, bit 0 = CT_COLORFONT */
    unsigned char depth;            /* 54: ctf_Depth */
    unsigned char fgColor;          /* 55: ctf_FgColor */
};

/* Callers are handed RastPort 2 plus two bytes, which is what the original's
 * ADDA.W #(Offset_RastPort2_FromDisplayContextBase+2) computes. */
struct EsqDisplayContext {
    char pad[8];
    char rastPort2[2];
};

extern volatile unsigned short INTENA;

extern char  ESQ_SelectCodeBuffer[10];
extern char  Global_STR_RAVESC[];
extern short Global_WORD_SELECT_CODE_IS_RAVESC;
extern char  Global_STR_COPY_NIL_ASSIGN_RAM[];
extern char  Global_STR_GRAPHICS_LIBRARY[];
extern char  Global_STR_DISKFONT_LIBRARY[];
extern char  Global_STR_DOS_LIBRARY[];
extern char  Global_STR_INTUITION_LIBRARY[];
extern char  Global_STR_UTILITY_LIBRARY[];
extern char  Global_STR_BATTCLOCK_RESOURCE[];
extern char  Global_STR_CART[];
extern char  Global_STR_SERIAL_READ[];
extern char  Global_STR_SERIAL_DEVICE[];
extern char  Global_STR_DF0_GRADIENT_INI_2[];
extern char  Global_STR_DF0_DEFAULT_INI_1[];
extern char  Global_STR_DF0_BRUSH_INI_1[];
extern char  Global_STR_DF0_BANNER_INI_1[];
extern char  Global_STR_GUIDE_START_VERSION_AND_BUILD[];
extern char  Global_STR_MAJOR_MINOR_VERSION[];
extern char *Global_PTR_STR_BUILD_ID;
extern long  Global_LONG_BUILD_NUMBER;
extern long  Global_LONG_PATCH_VERSION_NUMBER;
extern long  Global_LONG_ROM_VERSION_CHECK;

extern char  ESQ_STR_NO_DF1_PRESENT[];
extern char  ESQ_STR_SystemInitializing[];
extern char  ESQ_STR_PleaseStandByEllipsis[];
extern char  ESQ_STR_AttentionSystemEngineer[];
extern char  ESQ_STR_ReportErrorCodeEr011ToTVGuide[];
extern char  ESQ_STR_ReportErrorCodeER012ToTVGuide[];
extern char  ESQ_STR_DT[];
extern char  ESQ_STR_DITHER[];
extern char  ESQ_TAG_GRANADA[];
extern char  ESQ_STR_38_Spaces[];
extern char  ESQ_StartupVersionBannerBuffer[80];
extern char  DISKIO_ErrorMessageScratch[41];

extern void *WDISP_ExecBaseHookPtr;
extern void *ESQ_ProcessWindowPtrBackup;
extern void *Global_REF_DOS_LIBRARY;
extern void *Global_REF_INTUITION_LIBRARY;
extern void *Global_REF_UTILITY_LIBRARY;
extern void *Global_REF_BATTCLOCK_RESOURCE;

extern struct TextAttr Global_STRUCT_TEXTATTR_TOPAZ_FONT;
extern struct TextAttr Global_STRUCT_TEXTATTR_PREVUEC_FONT;
extern struct TextAttr Global_STRUCT_TEXTATTR_H26F_FONT;
extern struct TextAttr Global_STRUCT_TEXTATTR_PREVUE_FONT;
extern struct TextFont *Global_HANDLE_TOPAZ_FONT;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern struct TextFont *Global_HANDLE_H26F_FONT;
extern struct TextFont *Global_HANDLE_PREVUE_FONT;

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct RastPort *Global_REF_RASTPORT_2;
extern struct BitMap Global_REF_696_400_BITMAP;
extern struct BitMap Global_REF_696_241_BITMAP;
extern struct BitMap Global_REF_320_240_BITMAP;
extern struct BitMap WDISP_BannerGridBitmapStruct;

extern short WDISP_HighlightRasterHeightPx;
extern char  Global_REF_STR_USE_24_HR_CLOCK;
extern void *Global_JMPTBL_HALF_HOURS_24_HR_FMT;
extern void *Global_JMPTBL_HALF_HOURS_12_HR_FMT;
extern void *Global_REF_STR_CLOCK_FORMAT;

extern struct MsgPort *ESQ_HighlightMsgPort;
extern struct MsgPort *ESQ_HighlightReplyPort;
extern short WDISP_HighlightBufferMode;

extern char ESQDISP_HighlightBitmapTable[];             /* stride 40 */
extern char GCOMMAND_HighlightMessageSlotTable[];       /* stride 160 */

extern void *WDISP_352x240RasterPtrTable[4];
extern void *WDISP_BannerRowScratchRasterTable0[3];
extern void *WDISP_BannerRowScratchRasterTable1;
extern void *WDISP_BannerRowScratchRasterTable2;
extern void *WDISP_DisplayContextPlanePointer0[5];
extern void *WDISP_DisplayContextPlanePointer1;
extern void *WDISP_DisplayContextPlanePointer2;
extern void *WDISP_DisplayContextPlanePointer3;
extern void *WDISP_DisplayContextPlanePointer4;
extern void *WDISP_LivePlaneRasterTable0[3];
extern void *WDISP_LivePlaneRasterTable1;
extern void *WDISP_LivePlaneRasterTable2;
extern struct EsqDisplayContext *WDISP_DisplayContextBase;
extern void *WDISP_BannerWorkRasterPtr;

extern void *ESQSHARED_BannerRowScratchRasterBase0;
extern void *ESQSHARED_BannerRowScratchRasterBase1;
extern void *ESQSHARED_BannerRowScratchRasterBase2;
extern void *ESQSHARED_LivePlaneBase0;
extern void *ESQSHARED_LivePlaneBase1;
extern void *ESQSHARED_LivePlaneBase2;
extern void *ESQSHARED_DisplayContextPlaneBase0;
extern void *ESQSHARED_DisplayContextPlaneBase1;
extern void *ESQSHARED_DisplayContextPlaneBase2;
extern void *ESQSHARED_DisplayContextPlaneBase3;
extern void *ESQSHARED_DisplayContextPlaneBase4;

extern short SCRIPT_CtrlInterfaceEnabledFlag;
extern void *ESQIFF_RecordBufferPtr;
extern long  Global_REF_BAUD_RATE;
extern struct IOExtSer *WDISP_SerialIoRequestPtr;
extern struct MsgPort  *WDISP_SerialMessagePortPtr;
extern void *Global_REF_96_BYTES_ALLOCATED;

extern short CLOCK_DaySlotIndex;
extern short CLOCK_CurrentDayOfWeekIndex;
extern void *CLOCK_DaySlotIndexPtr;
extern void *CLOCK_CurrentDayOfWeekIndexPtr;
extern short DST_PrimaryCountdown;
extern short DST_SecondaryCountdown;
extern short WDISP_AccumulatorFlushPending;
extern long  NEWGRID_RefreshStateFlag;
extern long  NEWGRID_MessagePumpSuspendFlag;
extern long  DISKIO_DriveWriteProtectStatusCodeDrive1;
extern short IS_COMPATIBLE_VIDEO_CHIP;
extern short HAS_REQUESTED_FAST_MEMORY;

extern void *ESQIFF_BrushIniListHead;
extern void *PARSEINI_ParsedDescriptorListHead;
extern void *BRUSH_SelectedNode;
extern void *ESQFUNC_FallbackType3BrushNode;

extern short ESQ_StartupWriteOnlyLong2272;
extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharIndex;
extern char  LOCAVAIL_PrimaryFilterState[1];
extern char  LOCAVAIL_SecondaryFilterState[1];
extern void *DST_BannerWindowPrimary;
extern void *DST_BannerWindowSecondary;
extern short Global_RefreshTickCounter;
extern long  ESQDISP_DisplayActiveFlag;
extern short ESQIFF_ExternalAssetFlags;
extern short CLEANUP_AlignedStatusEntryCycleTable[302];
extern short ESQ_MainLoopUiTickEnabledFlag;
extern short ESQ_ShutdownRequestedFlag;

extern short Global_UIBusyFlag;
extern short ESQ_StartupStateWord2203;
extern short TEXTDISP_SecondaryGroupRecordLength;
extern short TEXTDISP_PrimaryGroupRecordLength;
extern short ESQ_TickModulo60Counter;
extern short ESQ_StartupWriteOnlyWord2271;
extern short ESQIFF_ParseAttemptCount;
extern short SCRIPT_CtrlCmdCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short ESQIFF_GAdsListLineIndex;
extern short ESQIFF_LogoListLineIndex;
extern short ESQIFF_StatusPacketReadyFlag;
extern short TEXTDISP_GroupMutationState;
extern short ESQ_SerialRbfFillLevel;
extern short Global_WORD_MAX_VALUE;
extern short Global_WORD_T_VALUE;
extern short Global_WORD_H_VALUE;
extern short CLEANUP_PendingAlertFlag;
extern short CTRL_BufferedByteCount;
extern short CTRL_HDeltaMax;
extern short CTRL_HPreviousSample;
extern short CTRL_H;
extern short ESQ_SerialRbfErrorCount;
extern short DATACErrs;
extern short SCRIPT_CtrlCmdChecksumErrorCount;
extern short ESQIFF_LineErrorCount;
extern short SCRIPT_CtrlCmdLengthErrorCount;
extern short ESQPARS_CommandPreambleArmedFlag;
extern short ESQPARS_Preamble55SeenFlag;
extern short WDISP_BannerCharPhaseShift;
extern short ESQPARS_SelectionMatchCode;
extern short ESQPARS_ResetArmedFlag;
extern char  ESQIFF_UseCachedChecksumFlag;
extern char  TEXTDISP_SecondaryGroupRecordChecksum;
extern char  TEXTDISP_PrimaryGroupRecordChecksum;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern short ESQ_StartupPhaseSeed225E;
extern short CLOCK_HalfHourSlotIndex;
extern short SCRIPT_CTRL_READ_INDEX;
extern short PARSEINI_CtrlHChangeGateFlag;
extern short SCRIPT_CTRL_CHECKSUM;

extern void  BUFFER_FlushAllAndCloseWithCode(long code);
extern void  OVERRIDE_INTUITION_FUNCS(void);
extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void *GRAPHICS_AllocRaster(char *who, long line, long w,
                                                 long h);
extern void  ESQDISP_AllocateHighlightBitmaps(void *slot);
extern void  ESQDISP_QueueHighlightDrawMessage(void *msgSlot, void *bitmapSlot);
extern void  LIST_InitHeader(struct List *l);
extern void  ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void  ESQ_SetCopperEffect_OnEnableHighlight(void);
extern long  ESQ_FormatDiskErrorMessage(void);
extern void  ESQ_CheckAvailableFastMemory(void);
extern void  ESQ_CheckCompatibleVideoChip(void);
extern void  ESQ_CheckTopazFontGuard(void);
extern void  PARSEINI_UpdateClockFromRtc(void);
extern void  DST_RefreshBannerBuffer(void);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void *SIGNAL_CreateMsgPortWithSignal(char *name, long f);
extern void *STRUCT_AllocWithOwner(void *port, long size);
extern void  SETUP_INTERRUPT_INTB_RBF(void);
extern void  SETUP_INTERRUPT_INTB_AUD1(void);
extern void  SETUP_INTERRUPT_INTB_VERTB(void);
extern void  ESQ_InitAudio1Dma(void);
extern void  SCRIPT_InitCtrlContext(void);
extern void  KYBD_InitializeInputDevices(void);
extern void  ESQFUNC_AllocateLineTextBuffers(void);
extern long  DISKIO_LoadConfigFromDisk(void);
extern void  ESQFUNC_UpdateRefreshModeState(long a, long b);
extern void  ESQSHARED4_InitializeBannerCopperSystem(void);
extern void  TLIBA3_InitPatternTable(void);
extern void  ESQIFF_RestoreBasePaletteTriples(void);
extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern void *TLIBA3_BuildDisplayContextForViewMode(long a, long b,
                                                                 long c);
extern void  TLIBA3_DrawCenteredWrappedTextLines(void *rp,
                                                                char *text,
                                                                long y);
extern void  DISKIO_ProbeDrivesAndAssignPaths(void);
extern void  WDISP_SPrintf(char *dst, char *fmt, char *a,
                                           long b, long c, char *d);
extern void  SCRIPT_PrimeBannerTransitionFromHexCode(void);
extern void  GCOMMAND_InitPresetDefaults(void);
extern void  PARSEINI_ParseIniBufferAndDispatch(char *path);
extern void  GCOMMAND_ResetBannerFadeState(void);
extern void  LADFUNC_AllocBannerRectEntries(void);
extern void  LADFUNC_ClearBannerRectEntries(void);
extern void  DISKIO2_ReloadDataFilesAndRebuildIndex(void);
extern void  DISKIO2_ParseIniFileFromDisk(void);
extern void  TEXTDISP_LoadSourceConfig(void);
extern void  BRUSH_PopulateBrushList(void *descriptors,
                                                   void *listHead);
extern void  BRUSH_SelectBrushByLabel(char *label);
extern void *BRUSH_FindBrushByPredicate(char *want, void *head);
extern void *BRUSH_FindType3Brush(void *head);
extern void  ESQFUNC_RebuildPwBrushListFromTagTable(void);
extern void  FLIB2_ResetAndLoadListingTemplates(void);
extern void  LADFUNC_LoadTextAdsFromFile(void);
extern void  LADFUNC_UpdateHighlightState(void);
extern void  ESQDISP_UpdateStatusMaskAndRefresh(long mask, long mode);
extern void  P_TYPE_ResetListsAndLoadPromoIds(void);
extern void  LOCAVAIL_ResetFilterStateStruct(void *state);
extern void  LOCAVAIL_LoadAvailabilityDataFile(void *primary,
                                                               void *secondary);
extern void  DST_LoadBannerPairFromFiles(void *pair);
extern void  ESQFUNC_UpdateDiskWarningAndRefreshTick(void);
extern void  TEXTDISP_SetRastForMode(long mode);
extern void  ESQFUNC_ServiceUiTickIfRunning(void);
extern short PARSEINI_MonitorClockChange(void);
extern void  ESQPARS_ConsumeRbfByteAndDispatchCommand(void);
extern void  CLEANUP_ShutdownSystem(void);

void ESQ_MainInitAndRun(long argc, char **argv)
{
    struct Process *self;
    struct EsqColorFont *font;
    struct MsgPort *port;
    long *tsrc, *tdst;
    long baud;
    short i;

    if (argc >= 2)
        strcpy(ESQ_SelectCodeBuffer, argv[1]);
    else
        ESQ_SelectCodeBuffer[0] = 0;

    if (strcmp(ESQ_SelectCodeBuffer, Global_STR_RAVESC) == 0)
        Global_WORD_SELECT_CODE_IS_RAVESC = 1;
    else
        Global_WORD_SELECT_CODE_IS_RAVESC = 0;

    Execute(Global_STR_COPY_NIL_ASSIGN_RAM, 0L, 0L);

    self = (struct Process *)FindTask(0L);
    WDISP_ExecBaseHookPtr = self;
    ESQ_ProcessWindowPtrBackup = self->pr_WindowPtr;
    self->pr_WindowPtr = (APTR)-1L;

    GfxBase = (struct GfxBase *)OpenLibrary(Global_STR_GRAPHICS_LIBRARY, 0L);
    if (GfxBase == 0)
        BUFFER_FlushAllAndCloseWithCode(0L);

    DiskfontBase = OpenLibrary(Global_STR_DISKFONT_LIBRARY, 0L);
    if (DiskfontBase == 0)
        BUFFER_FlushAllAndCloseWithCode(0L);

    Global_REF_DOS_LIBRARY = OpenLibrary(Global_STR_DOS_LIBRARY, 0L);
    if (Global_REF_DOS_LIBRARY == 0)
        BUFFER_FlushAllAndCloseWithCode(0L);

    Global_REF_INTUITION_LIBRARY = OpenLibrary(Global_STR_INTUITION_LIBRARY, 0L);
    if (Global_REF_INTUITION_LIBRARY == 0)
        BUFFER_FlushAllAndCloseWithCode(0L);

    /* utility.library and the battery clock exist only from Kickstart 2.0. */
    if (GfxBase->LibNode.lib_Version >= 37) {
        Global_REF_UTILITY_LIBRARY = OpenLibrary(Global_STR_UTILITY_LIBRARY, 37L);
        if (Global_REF_UTILITY_LIBRARY != 0)
            Global_REF_BATTCLOCK_RESOURCE =
                OpenResource(Global_STR_BATTCLOCK_RESOURCE);
        Global_LONG_ROM_VERSION_CHECK = 2;
    }

    OVERRIDE_INTUITION_FUNCS();

    Global_HANDLE_TOPAZ_FONT = OpenFont(&Global_STRUCT_TEXTATTR_TOPAZ_FONT);
    if (Global_HANDLE_TOPAZ_FONT == 0)
        goto shutdown;

    Global_HANDLE_PREVUEC_FONT = OpenDiskFont(&Global_STRUCT_TEXTATTR_PREVUEC_FONT);
    if (Global_HANDLE_PREVUEC_FONT == 0)
        Global_HANDLE_PREVUEC_FONT = Global_HANDLE_TOPAZ_FONT;

    Global_HANDLE_H26F_FONT = OpenDiskFont(&Global_STRUCT_TEXTATTR_H26F_FONT);
    if (Global_HANDLE_H26F_FONT == 0)
        Global_HANDLE_H26F_FONT = Global_HANDLE_TOPAZ_FONT;

    Global_HANDLE_PREVUE_FONT = OpenDiskFont(&Global_STRUCT_TEXTATTR_PREVUE_FONT);
    if (Global_HANDLE_PREVUE_FONT == 0)
        Global_HANDLE_PREVUE_FONT = Global_HANDLE_TOPAZ_FONT;

    Global_REF_RASTPORT_1 = (struct RastPort *)
        MEMORY_AllocateMemory("ESQ.c", 623L, 100L,
                                            MEMF_PUBLIC | MEMF_CLEAR);
    InitRastPort(Global_REF_RASTPORT_1);
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    SetFont(Global_REF_RASTPORT_1, Global_HANDLE_PREVUEC_FONT);

    /* Halved only to test the remainder; see divide-for-a-parity-test above. */
    WDISP_HighlightRasterHeightPx = 68;
    if ((long)(unsigned short)WDISP_HighlightRasterHeightPx % 2L != 0)
        WDISP_HighlightRasterHeightPx = WDISP_HighlightRasterHeightPx - 1;

    Global_REF_RASTPORT_2 = (struct RastPort *)
        MEMORY_AllocateMemory("ESQ.c", 645L, 100L,
                                            MEMF_PUBLIC | MEMF_CLEAR);
    InitRastPort(Global_REF_RASTPORT_2);
    Global_REF_RASTPORT_2->BitMap = &Global_REF_320_240_BITMAP;
    SetFont(Global_REF_RASTPORT_2, Global_HANDLE_PREVUEC_FONT);

    for (i = 0; i < 4; i++)
        ESQDISP_AllocateHighlightBitmaps(&ESQDISP_HighlightBitmapTable[i * 40]);

    InitBitMap(&Global_REF_320_240_BITMAP, 4L, 352L, 240L);

    for (i = 0; i < 4; i++) {
        WDISP_352x240RasterPtrTable[i] =
            GRAPHICS_AllocRaster("ESQ.c", 668L,
                                                352L, 240L);
        BltClear(WDISP_352x240RasterPtrTable[i], 10560L, 0L);
    }

    if (Global_REF_STR_USE_24_HR_CLOCK == 'Y')
        Global_REF_STR_CLOCK_FORMAT = &Global_JMPTBL_HALF_HOURS_24_HR_FMT;
    else
        Global_REF_STR_CLOCK_FORMAT = &Global_JMPTBL_HALF_HOURS_12_HR_FMT;

    ESQ_HighlightMsgPort = (struct MsgPort *)
        MEMORY_AllocateMemory("ESQ.c", 683L, 34L,
                                            MEMF_PUBLIC | MEMF_CLEAR);
    if (ESQ_HighlightMsgPort == 0)
        goto shutdown;
    port = ESQ_HighlightMsgPort;
    port->mp_Node.ln_Name = 0;
    ESQ_HighlightMsgPort->mp_Node.ln_Pri = 0;
    ESQ_HighlightMsgPort->mp_Node.ln_Type = NT_MSGPORT;
    ESQ_HighlightMsgPort->mp_Flags = PA_IGNORE;
    LIST_InitHeader(&ESQ_HighlightMsgPort->mp_MsgList);

    ESQ_HighlightReplyPort = (struct MsgPort *)
        MEMORY_AllocateMemory("ESQ.c", 698L, 34L,
                                            MEMF_PUBLIC | MEMF_CLEAR);
    if (ESQ_HighlightReplyPort == 0)
        goto shutdown;
    port = ESQ_HighlightReplyPort;
    port->mp_Node.ln_Name = 0;
    ESQ_HighlightReplyPort->mp_Node.ln_Pri = 0;
    ESQ_HighlightReplyPort->mp_Node.ln_Type = NT_MSGPORT;
    ESQ_HighlightReplyPort->mp_Flags = PA_IGNORE;
    LIST_InitHeader(&ESQ_HighlightReplyPort->mp_MsgList);

    for (i = 0; i < 4; i++)
        ESQDISP_QueueHighlightDrawMessage(
            &GCOMMAND_HighlightMessageSlotTable[i * 160],
            &ESQDISP_HighlightBitmapTable[i * 40]);

    ESQ_SetCopperEffect_OffDisableHighlight();

    WDISP_HighlightBufferMode = 0;
    if (GfxBase->LibNode.lib_Version >= 34)
        WDISP_HighlightBufferMode = 1;
    if ((long)AvailMem(MEMF_FAST) > 1750000L)
        WDISP_HighlightBufferMode = 2;

    if (ESQ_FormatDiskErrorMessage() != 0)
        goto shutdown;

    ESQ_CheckAvailableFastMemory();
    ESQ_CheckCompatibleVideoChip();
    ESQ_CheckTopazFontGuard();

    CLOCK_DaySlotIndexPtr = &CLOCK_DaySlotIndex;
    CLOCK_CurrentDayOfWeekIndexPtr = &CLOCK_CurrentDayOfWeekIndex;
    DST_PrimaryCountdown = DST_SecondaryCountdown = 0;
    PARSEINI_UpdateClockFromRtc();
    DST_RefreshBannerBuffer();

    /* "CART" anywhere in argv enables the CTRL serial interface. The scan does
     * not stop at the first hit, so the last argument still decides nothing --
     * any occurrence sets the flag. */
    SCRIPT_CtrlInterfaceEnabledFlag = 0;
    for (i = 1; (long)i < argc; i++)
        if (strcmp(argv[i], Global_STR_CART) == 0)
            SCRIPT_CtrlInterfaceEnabledFlag = 1;

    if (argc <= 2) {
        Global_REF_BAUD_RATE = 2400;
    } else {
        baud = PARSE_ReadSignedLongSkipClass3_Alt(argv[2]);
        Global_REF_BAUD_RATE = baud;
        if (baud != 2400 && baud != 4800 && baud != 9600)
            Global_REF_BAUD_RATE = 2400;
    }

    ESQIFF_RecordBufferPtr =
        MEMORY_AllocateMemory("ESQ.c", 854L, 9000L,
                                            MEMF_PUBLIC | MEMF_CLEAR);

    WDISP_SerialMessagePortPtr = (struct MsgPort *)
        SIGNAL_CreateMsgPortWithSignal(Global_STR_SERIAL_READ, 0L);
    if (WDISP_SerialMessagePortPtr == 0)
        goto shutdown;

    WDISP_SerialIoRequestPtr = (struct IOExtSer *)
        STRUCT_AllocWithOwner(WDISP_SerialMessagePortPtr, 82L);
    if (WDISP_SerialIoRequestPtr == 0)
        goto shutdown;

    if (OpenDevice(Global_STR_SERIAL_DEVICE, 0L,
                   (struct IORequest *)WDISP_SerialIoRequestPtr, 0L) != 0)
        goto shutdown;

    WDISP_SerialIoRequestPtr->io_SerFlags = SERF_RAD_BOOGIE;
    WDISP_SerialIoRequestPtr->io_Baud = Global_REF_BAUD_RATE;
    WDISP_SerialIoRequestPtr->IOSer.io_Command = SDCMD_SETPARAMS;
    DoIO((struct IORequest *)WDISP_SerialIoRequestPtr);

    SETUP_INTERRUPT_INTB_RBF();
    SETUP_INTERRUPT_INTB_AUD1();
    ESQ_InitAudio1Dma();
    SCRIPT_InitCtrlContext();
    KYBD_InitializeInputDevices();
    ESQFUNC_AllocateLineTextBuffers();

    Global_REF_96_BYTES_ALLOCATED =
        MEMORY_AllocateMemory("ESQ.c", 984L, 96L,
                                            MEMF_PUBLIC);

    InitBitMap(&Global_REF_696_400_BITMAP, 3L, 696L, 400L);
    InitBitMap(&Global_REF_696_241_BITMAP, 4L, 696L, 241L);

    for (i = 0; i < 3; i++) {
        WDISP_BannerRowScratchRasterTable0[i] =
            GRAPHICS_AllocRaster("ESQ.c", 991L,
                                                696L, 509L);
        BltClear(WDISP_BannerRowScratchRasterTable0[i], 0xaef8L, 0L);
    }

    ESQSHARED_BannerRowScratchRasterBase0 = WDISP_BannerRowScratchRasterTable0[0];
    ESQSHARED_BannerRowScratchRasterBase1 = WDISP_BannerRowScratchRasterTable0[1];
    ESQSHARED_BannerRowScratchRasterBase2 = WDISP_BannerRowScratchRasterTable0[2];

    /* The first three display planes are aliases into the 696x509 scratch
     * rasters at a fixed offset, not allocations of their own. */
    for (i = 0; i < 3; i++)
        WDISP_DisplayContextPlanePointer0[i] =
            (char *)WDISP_BannerRowScratchRasterTable0[i] + 0x5c20;

    for (i = 3; i < 5; i++) {
        WDISP_DisplayContextPlanePointer0[i] =
            GRAPHICS_AllocRaster("ESQ.c", 1008L,
                                                696L, 241L);
        BltClear(WDISP_DisplayContextPlanePointer0[i], 0x52d8L, 0L);
    }

    ESQSHARED_DisplayContextPlaneBase0 = WDISP_DisplayContextPlanePointer0[0];
    ESQSHARED_DisplayContextPlaneBase1 = WDISP_DisplayContextPlanePointer0[1];
    ESQSHARED_DisplayContextPlaneBase2 = WDISP_DisplayContextPlanePointer0[2];
    ESQSHARED_DisplayContextPlaneBase3 = WDISP_DisplayContextPlanePointer0[3];
    ESQSHARED_DisplayContextPlaneBase4 = WDISP_DisplayContextPlanePointer0[4];

    font = (struct EsqColorFont *)Global_REF_RASTPORT_1->Font;
    font->fgColor = 1;
    font->flagsLo |= 1;

    WDISP_DisplayContextBase = (struct EsqDisplayContext *)
        TLIBA3_BuildDisplayContextForViewMode(2L, 0L, 3L);

    InitBitMap(&WDISP_BannerGridBitmapStruct, 3L, 696L, 2L);

    for (i = 0; i < 3; i++) {
        WDISP_LivePlaneRasterTable0[i] =
            GRAPHICS_AllocRaster("ESQ.c", 1027L,
                                                696L, 2L);
        BltClear(WDISP_LivePlaneRasterTable0[i], 176L, 0L);
    }

    ESQSHARED_LivePlaneBase0 = WDISP_LivePlaneRasterTable0[0];
    ESQSHARED_LivePlaneBase1 = WDISP_LivePlaneRasterTable0[1];
    ESQSHARED_LivePlaneBase2 = WDISP_LivePlaneRasterTable0[2];

    WDISP_BannerWorkRasterPtr =
        GRAPHICS_AllocRaster("ESQ.c", 1038L, 696L, 15L);
    WDISP_AccumulatorFlushPending = 0;
    NEWGRID_RefreshStateFlag = 0;
    NEWGRID_MessagePumpSuspendFlag = -1;

    if (DISKIO_LoadConfigFromDisk() == -1)
        ESQFUNC_UpdateRefreshModeState(0L, 0L);

    ESQSHARED4_InitializeBannerCopperSystem();
    TLIBA3_InitPatternTable();
    SETUP_INTERRUPT_INTB_VERTB();

    Global_UIBusyFlag = 0;
    ESQ_StartupStateWord2203 = 0;
    TEXTDISP_SecondaryGroupRecordLength = 0;
    TEXTDISP_PrimaryGroupRecordLength = 0;
    ESQ_TickModulo60Counter = 0;
    ESQ_StartupWriteOnlyWord2271 = 0;
    ESQIFF_ParseAttemptCount = 0;
    SCRIPT_CtrlCmdCount = 0;
    TEXTDISP_SecondaryGroupEntryCount = 0;
    TEXTDISP_PrimaryGroupEntryCount = 0;
    ESQIFF_GAdsListLineIndex = 0;
    ESQIFF_LogoListLineIndex = 0;
    ESQIFF_StatusPacketReadyFlag = 0;
    TEXTDISP_GroupMutationState = 0;
    ESQ_SerialRbfFillLevel = 0;
    Global_WORD_MAX_VALUE = 0;
    Global_WORD_T_VALUE = 0;
    Global_WORD_H_VALUE = 0;
    CLEANUP_PendingAlertFlag = 0;
    CTRL_BufferedByteCount = 0;
    CTRL_HDeltaMax = 0;
    CTRL_HPreviousSample = 0;
    CTRL_H = 0;
    ESQ_SerialRbfErrorCount = 0;
    DATACErrs = 0;
    SCRIPT_CtrlCmdChecksumErrorCount = 0;
    ESQIFF_LineErrorCount = 0;
    SCRIPT_CtrlCmdLengthErrorCount = 0;
    ESQPARS_CommandPreambleArmedFlag = 0;
    ESQPARS_Preamble55SeenFlag = 0;
    WDISP_BannerCharPhaseShift = 0;
    ESQPARS_SelectionMatchCode = 0;
    ESQPARS_ResetArmedFlag = 0;
    ESQIFF_UseCachedChecksumFlag = 0;
    TEXTDISP_SecondaryGroupRecordChecksum = 0;
    TEXTDISP_PrimaryGroupRecordChecksum = 0;
    TEXTDISP_SecondaryGroupPresentFlag = 0;
    TEXTDISP_PrimaryGroupCode = 0;
    TEXTDISP_SecondaryGroupCode = 1;
    ESQ_StartupPhaseSeed225E = 7;
    CLOCK_HalfHourSlotIndex = 2;
    SCRIPT_CTRL_READ_INDEX = 0;
    PARSEINI_CtrlHChangeGateFlag = 0;
    SCRIPT_CTRL_CHECKSUM = 0xff;

    ESQIFF_RestoreBasePaletteTriples();
    ESQIFF_RunCopperDropTransition();

    SetAPen(Global_REF_RASTPORT_1, 7L);
    RectFill(Global_REF_RASTPORT_1, 0L, 0L, 695L, 399L);

    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_241_BITMAP;
    SetAPen(Global_REF_RASTPORT_1, 7L);
    RectFill(Global_REF_RASTPORT_1, 0L, 0L, 695L, 240L);

    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetBPen(Global_REF_RASTPORT_1, 2L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);

    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rastPort2[2], DISKIO_ErrorMessageScratch, 150L);
    DISKIO_ProbeDrivesAndAssignPaths();

    if (DISKIO_DriveWriteProtectStatusCodeDrive1 == 218)
        TLIBA3_DrawCenteredWrappedTextLines(
            &WDISP_DisplayContextBase->rastPort2[2], ESQ_STR_NO_DF1_PRESENT, 150L);

    WDISP_SPrintf(ESQ_StartupVersionBannerBuffer,
                                  Global_STR_GUIDE_START_VERSION_AND_BUILD,
                                  Global_STR_MAJOR_MINOR_VERSION,
                                  Global_LONG_PATCH_VERSION_NUMBER,
                                  Global_LONG_BUILD_NUMBER,
                                  Global_PTR_STR_BUILD_ID);

    /* Ten longwords, not forty bytes: the original copies with MOVE.L/DBF, so
     * the loop is written over longs. A memcpy of the same span inlines to a
     * MOVE.B loop instead. */
    tsrc = (long *)ESQ_STR_38_Spaces;
    tdst = (long *)DISKIO_ErrorMessageScratch;
    for (i = 0; i < 10; i++)
        *tdst++ = *tsrc++;

    SCRIPT_PrimeBannerTransitionFromHexCode();
    GCOMMAND_InitPresetDefaults();
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_GRADIENT_INI_2);
    GCOMMAND_ResetBannerFadeState();

    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rastPort2[2], ESQ_SelectCodeBuffer, 60L);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rastPort2[2], ESQ_StartupVersionBannerBuffer, 90L);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rastPort2[2], ESQ_STR_SystemInitializing, 120L);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rastPort2[2], ESQ_STR_PleaseStandByEllipsis, 150L);

    if (IS_COMPATIBLE_VIDEO_CHIP != 0 || HAS_REQUESTED_FAST_MEMORY != 0) {
        TLIBA3_DrawCenteredWrappedTextLines(
            &WDISP_DisplayContextBase->rastPort2[2],
            ESQ_STR_AttentionSystemEngineer, 180L);

        if (HAS_REQUESTED_FAST_MEMORY != 0)
            TLIBA3_DrawCenteredWrappedTextLines(
                &WDISP_DisplayContextBase->rastPort2[2],
                ESQ_STR_ReportErrorCodeEr011ToTVGuide, 210L);

        if (IS_COMPATIBLE_VIDEO_CHIP != 0)
            TLIBA3_DrawCenteredWrappedTextLines(
                &WDISP_DisplayContextBase->rastPort2[2],
                ESQ_STR_ReportErrorCodeER012ToTVGuide,
                HAS_REQUESTED_FAST_MEMORY != 0 ? 240L : 210L);

        ESQIFF_RunCopperRiseTransition();

        /* No operator console: the box stops here with the fault on screen. */
        for (;;)
            ;
    }

    ESQIFF_RunCopperRiseTransition();
    LADFUNC_AllocBannerRectEntries();
    LADFUNC_ClearBannerRectEntries();
    DISKIO2_ReloadDataFilesAndRebuildIndex();
    DISKIO2_ParseIniFileFromDisk();
    TEXTDISP_LoadSourceConfig();
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_DEFAULT_INI_1);
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BRUSH_INI_1);
    BRUSH_PopulateBrushList(PARSEINI_ParsedDescriptorListHead,
                                          &ESQIFF_BrushIniListHead);
    BRUSH_SelectBrushByLabel(ESQ_STR_DT);

    if (BRUSH_SelectedNode == 0)
        BRUSH_SelectedNode =
            BRUSH_FindBrushByPredicate(ESQ_STR_DITHER,
                                                     &ESQIFF_BrushIniListHead);

    ESQFUNC_FallbackType3BrushNode =
        BRUSH_FindType3Brush(&ESQIFF_BrushIniListHead);
    ESQFUNC_RebuildPwBrushListFromTagTable();

    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BANNER_INI_1);
    FLIB2_ResetAndLoadListingTemplates();
    LADFUNC_LoadTextAdsFromFile();
    LADFUNC_UpdateHighlightState();

    ESQ_StartupWriteOnlyLong2272 = 1;
    WDISP_BannerCharIndex = WDISP_BannerCharRangeStart;
    ESQDISP_UpdateStatusMaskAndRefresh(4095L, 0L);

    INTENA = 0x8100;
    P_TYPE_ResetListsAndLoadPromoIds();

    LOCAVAIL_ResetFilterStateStruct(LOCAVAIL_PrimaryFilterState);
    LOCAVAIL_ResetFilterStateStruct(LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_LoadAvailabilityDataFile(LOCAVAIL_PrimaryFilterState,
                                                      LOCAVAIL_SecondaryFilterState);

    DST_BannerWindowPrimary = DST_BannerWindowSecondary = 0;
    DST_LoadBannerPairFromFiles(&DST_BannerWindowPrimary);

    Global_RefreshTickCounter = 0;
    ESQFUNC_UpdateDiskWarningAndRefreshTick();

    ESQDISP_DisplayActiveFlag = 0;
    for (i = 1; (long)i < argc; i++)
        if (strcmp(argv[i], ESQ_TAG_GRANADA) == 0)
            ESQDISP_DisplayActiveFlag = 1;

    /* The serial counters are cleared with interrupts off: the RBF server
     * writes the same words. */
    Disable();
    ESQ_SerialRbfFillLevel = 0;
    Global_WORD_MAX_VALUE = 0;
    Global_WORD_T_VALUE = 0;
    Global_WORD_H_VALUE = 0;
    Enable();

    ESQIFF_ExternalAssetFlags = 0;
    TEXTDISP_SetRastForMode(0L);
    ESQ_SetCopperEffect_OffDisableHighlight();

    for (i = 0; i < 302; i++)
        CLEANUP_AlignedStatusEntryCycleTable[i] = 0;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
        ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0L);
    }

    ESQ_MainLoopUiTickEnabledFlag = 1;

    do {
        ESQFUNC_ServiceUiTickIfRunning();
        if (PARSEINI_MonitorClockChange() != 0 &&
            ESQ_ShutdownRequestedFlag == 0)
            ESQPARS_ConsumeRbfByteAndDispatchCommand();
    } while (ESQ_ShutdownRequestedFlag == 0);

shutdown:
    CLEANUP_ShutdownSystem();
}
