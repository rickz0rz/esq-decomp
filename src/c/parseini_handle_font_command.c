/* RESTORES: PARSEINI_HandleFontCommand
 * MODULE:   modules/groups/b/a/parseini_p2.s
 * STATUS:   behavioural
 *
 * Decodes a three-character command from the serial stream and runs it. The
 * name is misleading: only three of the sixteen commands have anything to do
 * with fonts. The rest reload INI files, shell out to DOS, drive the ESC menu
 * and rebuild brush lists.
 *
 * THREE NESTED DISPATCHES, ALL CHAINED SUBTRACTS. The first character must be
 * '3'; the second selects one of three groups; the third selects the command.
 * The pointer is advanced by each level, so a command that never reaches the
 * third level leaves it advanced by two rather than three -- the reads are
 * unconditional side effects of the dispatch.
 *
 * THE THIRD-LEVEL CODES ARE NOT CONTIGUOUS. Under group '3' they are 0x34..0x39
 * and then 0x51, 0x61..0x64 and 0x73 -- the chain subtracts 0x18, then 16, then
 * 15 to skip the gaps. Those three jumps are the whole reason the codes look
 * arbitrary; they are '4'..'9', 'Q', 'a'..'d' and 's'.
 *
 * COMMAND 0x63 ('c') BLOCKS ON THE IFF TASK. It spins on a flag with no timeout
 * before freeing the brush lists, because freeing them while the IFF task is
 * mid-load would pull memory out from under it. That busy-wait is the only
 * synchronisation.
 *
 * The 'c' command frees TWO different lists with TWO different functions, in
 * order, then reparses and requeues. Skipping either free leaks.
 *
 * COMMAND 0x39 IGNORES ITS RESULT. The original tests the font-open return with
 * `TST.W D0` and then unconditionally branches to the exit -- the test is dead.
 * The two other font commands do act on it. Written below without the test,
 * since a dead `if` with an empty body is not reproducible and the value is not
 * used either way.
 *
 * COMMAND 0x37 CHECKS THE UI BUSY FLAG and only sets the font when it is SET,
 * which is the opposite of what the name suggests. 0x38 has no such guard and
 * sets nine rastports.
 *
 * The highlight slot table is indexed at 160 bytes a slot with the rastport 60
 * bytes in -- the original computes `80 * 2` at run time rather than using 160
 * as a literal, which is why the struct is declared at that size rather than
 * the index being written out.
 *
 * 684 ref vs 712 got, 26 differing regions. All three dispatch levels with
 * their non-contiguous subtractions, the DOS Execute, the logo-scan guard, all
 * three font-open calls, the nine SetFont calls, the four-slot loop, the IFF
 * busy-wait, both frees, all five INI reparses and the three ESC-menu pairs
 * match in kind and size.
 *
 * SASC-MISMATCH: volatile-a6-reload
 *   ref:     4 loads of the graphics base for 9 library calls
 *   got:     8 loads for 9 calls
 *   summary: 24 of the 28 bytes, measured. The original caches A6 across the
 *            five consecutive SetFont calls in command 0x38 and across the
 *            pair in the slot loop; we reload before each because
 *            esq-graphics.h declares the base volatile.
 *   tried:   NOT attempted, and must not be. esq-graphics-leaf.h is restricted
 *            to the `no-calls` bucket and this function calls ESQ assembly at
 *            almost every arm -- including MATH_Mulu32 inside the slot loop,
 *            between two library calls, which is precisely the shape
 *            src/c/esq-libbase.md documents as the A6 bug. tools/a6_audit.py
 *            would flag it.
 *   scope:   every restoration that mixes library and ESQ calls.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-dos.h"
#include "esq-graphics.h"

struct HighlightSlot {                  /* 160 bytes */
    char            pad0[60];
    struct RastPort rp;                 /* +60 */
    char            pad160[24];
};

struct FontCtx {
    short           pad0;
    short           pad2;
    char            pad4[6];
    struct RastPort rp;                 /* +10 */
};

extern void  WDISP_SPrintf(char *buf, char *fmt, char *arg);
extern void  ED1_WaitForFlagAndClearBit0(void);
extern void  ED1_WaitForFlagAndClearBit1(void);
extern void  PARSEINI_ScanLogoDirectory(void);
extern void  ESQFUNC_RebuildPwBrushListFromTagTable(void);
extern short PARSEINI_TestMemoryAndOpenTopazFont(struct TextFont **handle,
                                                 struct TextAttr *attr);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void  TLIBA3_SetFontForAllViewModes(struct TextFont *font);
extern void  DISKIO2_ParseIniFileFromDisk(void);
extern void  ESQIFF_HandleBrushIniReloadHotkey(long key);
extern void  PARSEINI_ParseIniBufferAndDispatch(char *path);
extern short SCRIPT_CheckPathExists(char *path);
extern void  BRUSH_FreeBrushList(void *head, long zero);
extern void  BRUSH_FreeBrushResources(void *head);
extern void  ESQIFF_QueueIffBrushLoad(long mode);
extern void  TEXTDISP_ApplySourceConfigAllEntries(void);
extern void  ED1_EnterEscMenu(void);
extern void  ED1_ExitEscMenu(void);
extern void  ED1_DrawDiagnosticsScreen(void);
extern void  ESQFUNC_DrawEscMenuVersion(void);

extern struct TextFont *Global_HANDLE_H26F_FONT;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern struct TextFont *Global_HANDLE_PREVUE_FONT;
extern struct TextAttr  Global_STRUCT_TEXTATTR_H26F_FONT;
extern struct TextAttr  Global_STRUCT_TEXTATTR_PREVUEC_FONT;
extern struct TextAttr  Global_STRUCT_TEXTATTR_PREVUE_FONT;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct RastPort *Global_REF_RASTPORT_2;
extern struct RastPort *NEWGRID_MainRastPortPtr;
extern struct RastPort *NEWGRID_HeaderRastPortPtr;
extern struct FontCtx  *WDISP_DisplayContextBase;
extern struct HighlightSlot GCOMMAND_HighlightMessageSlotTable[];

extern short Global_UIBusyFlag;
extern short CTASKS_IffTaskDoneFlag;
extern char  CONFIG_ParseiniLogoScanEnabledFlag;
extern void *WDISP_WeatherStatusBrushListHead;
extern void *PARSEINI_BannerBrushResourceHead;

extern char Global_STR_PERCENT_S_2[];
extern char Global_STR_DF0_GRADIENT_INI_3[];
extern char Global_STR_DF0_BANNER_INI_2[];
extern char Global_STR_DF0_BANNER_INI_3[];
extern char Global_STR_DF0_DEFAULT_INI_2[];
extern char Global_STR_DF0_SOURCECFG_INI_1[];

void PARSEINI_HandleFontCommand(char *cmd)
{
    char cmdBuf[80];
    long i;

    if ((long)(unsigned char)*cmd++ != 0x33)
        return;

    switch ((short)(unsigned char)*cmd++) {

    case 0x32:
        WDISP_SPrintf(cmdBuf, Global_STR_PERCENT_S_2, cmd);
        Execute(cmdBuf, 0L, 0L);
        return;

    case 0x33:
        switch ((short)(unsigned char)*cmd++) {

        case 0x34:
            ED1_WaitForFlagAndClearBit0();
            return;

        case 0x35:
            if (CONFIG_ParseiniLogoScanEnabledFlag == 89)
                PARSEINI_ScanLogoDirectory();
            ED1_WaitForFlagAndClearBit1();
            return;

        case 0x36:
            ESQFUNC_RebuildPwBrushListFromTagTable();
            return;

        case 0x37:
            if (PARSEINI_TestMemoryAndOpenTopazFont(
                    &Global_HANDLE_H26F_FONT,
                    &Global_STRUCT_TEXTATTR_H26F_FONT) == 0)
                return;
            if (Global_UIBusyFlag == 0)
                return;
            SetFont(Global_REF_RASTPORT_1, Global_HANDLE_H26F_FONT);
            return;

        case 0x38:
            if (PARSEINI_TestMemoryAndOpenTopazFont(
                    &Global_HANDLE_PREVUEC_FONT,
                    &Global_STRUCT_TEXTATTR_PREVUEC_FONT) == 0)
                return;

            SetFont(&WDISP_DisplayContextBase->rp,
                    Global_HANDLE_PREVUEC_FONT);
            SetFont(Global_REF_RASTPORT_1, Global_HANDLE_PREVUEC_FONT);
            SetFont(Global_REF_RASTPORT_2, Global_HANDLE_PREVUEC_FONT);
            SetFont(NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);
            SetFont(NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

            for (i = 0; i < 4; i++)
                SetFont(&GCOMMAND_HighlightMessageSlotTable[i].rp,
                        Global_HANDLE_PREVUEC_FONT);

            TLIBA3_SetFontForAllViewModes(Global_HANDLE_PREVUEC_FONT);
            return;

        case 0x39:
            PARSEINI_TestMemoryAndOpenTopazFont(
                &Global_HANDLE_PREVUE_FONT,
                &Global_STRUCT_TEXTATTR_PREVUE_FONT);
            return;

        case 0x51:
            DISKIO2_ParseIniFileFromDisk();
            return;

        case 0x61:
            ESQIFF_HandleBrushIniReloadHotkey(97L);
            return;

        case 0x62:
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_GRADIENT_INI_3);
            return;

        case 0x63:
            if (SCRIPT_CheckPathExists(Global_STR_DF0_BANNER_INI_2) == 0)
                return;

            while (CTASKS_IffTaskDoneFlag == 0)
                ;

            BRUSH_FreeBrushList(
                &WDISP_WeatherStatusBrushListHead, 0L);
            BRUSH_FreeBrushResources(
                &PARSEINI_BannerBrushResourceHead);
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BANNER_INI_3);
            ESQIFF_QueueIffBrushLoad(1L);
            return;

        case 0x64:
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_DEFAULT_INI_2);
            return;

        case 0x73:
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_SOURCECFG_INI_1);
            TEXTDISP_ApplySourceConfigAllEntries();
            return;

        default:
            return;
        }

    case 0x34:
        switch ((short)(unsigned char)*cmd++) {

        case 0x30:
            ED1_EnterEscMenu();
            ED1_ExitEscMenu();
            return;

        case 0x31:
            ED1_EnterEscMenu();
            ED1_DrawDiagnosticsScreen();
            return;

        case 0x32:
            ED1_EnterEscMenu();
            ESQFUNC_DrawEscMenuVersion();
            return;

        default:
            return;
        }

    default:
        return;
    }
}
