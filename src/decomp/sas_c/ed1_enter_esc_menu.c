#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>

extern void *AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct TextFont *Global_HANDLE_H26F_FONT;
extern struct BitMap Global_REF_696_400_BITMAP;

extern WORD Global_UIBusyFlag;
extern BYTE ED_DiagGraphModeChar;
extern BYTE ED_SavedDiagGraphModeChar;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD ESQSHARED_BannerColorModeWord;
extern LONG ED_SaveTextAdsOnExitFlag;
extern LONG ED_MaxAdNumber;
extern LONG ED_TextLimit;
extern LONG ED_BlockOffset;
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern BYTE ED_DiagScrollSpeedChar;
extern UBYTE ESQ_TAG_36[];
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE KYBD_CustomPaletteTriplesRBase[];
extern LONG Global_LONG_PATCH_VERSION_NUMBER;

extern const char Global_STR_NINE_POINT_ZERO[];
extern const char Global_STR_VER_PERCENT_S_PERCENT_L_D[];

extern void _LVOSetFont(void *gfxBase, struct RastPort *rp, struct TextFont *font);
extern void _LVOInitBitMap(void *gfxBase, struct BitMap *bm, LONG depth, LONG width, LONG height);
extern void _LVOSetRast(void *gfxBase, struct RastPort *rp, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, struct RastPort *rp, LONG mode);
extern void _LVOSetAPen(void *gfxBase, struct RastPort *rp, LONG pen);
extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);

extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte);
extern void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow(void);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rastPort, LONG y, LONG x, const char *text);

void ED1_EnterEscMenu(void)
{
    char versionBanner[41];
    LONG i;
    LONG centerX;
    LONG fontWidth;

    Global_UIBusyFlag = 1;
    ED_SavedDiagGraphModeChar = ED_DiagGraphModeChar;

    _LVOSetFont(
        Global_REF_GRAPHICS_LIBRARY,
        Global_REF_RASTPORT_1,
        Global_HANDLE_H26F_FONT);

    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    _LVOInitBitMap(
        Global_REF_GRAPHICS_LIBRARY,
        &Global_REF_696_400_BITMAP,
        3,
        696,
        509);

    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    ESQIFF_RunCopperDropTransition();

    for (i = 0; i < 24; i++) {
        WDISP_PaletteTriplesRBase[i] = KYBD_CustomPaletteTriplesRBase[i];
    }

    _LVODisable(AbsExecBase);

    ESQPARS2_ReadModeFlags = 0x0100;
    ESQSHARED_BannerColorModeWord = 0;
    GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(3);
    GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
    ED_SaveTextAdsOnExitFlag = 0;
    ED1_JMPTBL_GCOMMAND_SeedBannerDefaults();

    _LVOEnable(AbsExecBase);

    ED_MaxAdNumber = ESQIFF_JMPTBL_MATH_Mulu32(
        (LONG)(UBYTE)ESQ_TAG_36[0] - (LONG)'0',
        10
    ) + ((LONG)(UBYTE)ESQ_TAG_36[1] - (LONG)'0');

    ED_TextLimit = (LONG)(UBYTE)ED_DiagScrollSpeedChar - (LONG)'0';
    if (ED_TextLimit > 6) {
        ED_TextLimit = 6;
        ED_DiagScrollSpeedChar = '6';
    }

    ED_BlockOffset = ESQIFF_JMPTBL_MATH_Mulu32(ED_TextLimit, 40);
    Global_REF_LONG_CURRENT_EDITING_AD_NUMBER = 1;
    ED_DrawESCMenuBottomHelp();

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        versionBanner,
        Global_STR_VER_PERCENT_S_PERCENT_L_D,
        Global_STR_NINE_POINT_ZERO,
        Global_LONG_PATCH_VERSION_NUMBER
    );

    ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow();

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 3);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);

    fontWidth = (LONG)(UWORD)Global_REF_RASTPORT_1->Font->tf_XSize;
    centerX = 34 - fontWidth;
    if (centerX < 0) {
        centerX++;
    }
    centerX >>= 1;
    centerX += fontWidth;
    centerX += 33;

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 280, centerX, versionBanner);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    ESQIFF_RunCopperRiseTransition();
}
