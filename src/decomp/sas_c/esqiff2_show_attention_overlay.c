typedef unsigned char UBYTE;
typedef signed char BYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef signed long LONG;

struct RastPort {
    UBYTE pad0[4];
    void *BitMap;
    UBYTE pad1[20];
    UBYTE DrawMode;
};

extern WORD Global_UIBusyFlag;
extern WORD ED_DiagnosticsScreenActive;
extern WORD ESQPARS2_ReadModeFlags;

extern struct RastPort *Global_REF_RASTPORT_1;
extern void *Global_REF_696_400_BITMAP;
extern ULONG BRUSH_SnapshotDepth;
extern ULONG BRUSH_SnapshotWidth;
extern const char *BRUSH_SnapshotHeader;
extern WORD COI_AttentionOverlayBusyFlag;

extern const char Global_STR_PLEASE_STANDBY_2[];
extern const char Global_STR_ATTENTION_SYSTEM_ENGINEER_2[];
extern const char Global_STR_REPORT_ERROR_CODE_FORMATTED[];
extern const char Global_STR_FILE_WIDTH_COLORS_FORMATTED[];
extern const char Global_STR_FILE_PERCENT_S[];
extern const char Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL[];

extern void Disable(void);
extern void Enable(void);
extern void GCOMMAND_SeedBannerFromPrefs(void);
extern void SetAPen(struct RastPort *rp, LONG pen);
extern void RectFill(struct RastPort *rp, LONG x1, LONG y1, LONG x2, LONG y2);
extern void SetDrMd(struct RastPort *rp, LONG mode);
extern void ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rp, WORD x, WORD y, const char *text);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(ULONG depth);

void ESQIFF2_ShowAttentionOverlay(BYTE code)
{
    LONG d5 = -1;
    struct RastPort *rp;
    void *old_bitmap;
    UBYTE old_drmd;
    char textbuf[128];

    if (Global_UIBusyFlag != 0 && ED_DiagnosticsScreenActive == 0) {
        return;
    }

    switch ((int)code) {
    case 1: d5 = 1; break;
    case 2: d5 = 2; break;
    case 3: d5 = 8; break;
    case 4: d5 = 9; break;
    case 5: d5 = 10; break;
    default: break;
    }

    if (d5 <= 0) {
        return;
    }

    Disable();
    ESQPARS2_ReadModeFlags = 0x100;
    GCOMMAND_SeedBannerFromPrefs();
    Enable();

    rp = Global_REF_RASTPORT_1;
    old_bitmap = rp->BitMap;
    rp->BitMap = Global_REF_696_400_BITMAP;
    ED_DiagnosticsScreenActive = 0;

    SetAPen(rp, 2);
    RectFill(rp, 0, 65, 0x2ac, (UBYTE)(~40));
    SetAPen(rp, 3);

    old_drmd = rp->DrawMode;
    SetDrMd(rp, 0);

    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition((char *)rp, 35, 90, Global_STR_PLEASE_STANDBY_2);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition((char *)rp, 35, 120, Global_STR_ATTENTION_SYSTEM_ENGINEER_2);

    GROUP_AM_JMPTBL_WDISP_SPrintf(textbuf, Global_STR_REPORT_ERROR_CODE_FORMATTED, d5);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition((char *)rp, 35, 150, textbuf);

    if (d5 == 9 || d5 == 10) {
        ULONG mask = (ULONG)ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(BRUSH_SnapshotDepth);
        GROUP_AM_JMPTBL_WDISP_SPrintf(textbuf, Global_STR_FILE_WIDTH_COLORS_FORMATTED, BRUSH_SnapshotHeader, BRUSH_SnapshotWidth, mask);
        COI_AttentionOverlayBusyFlag = 1;
    } else {
        GROUP_AM_JMPTBL_WDISP_SPrintf(textbuf, Global_STR_FILE_PERCENT_S, BRUSH_SnapshotHeader);
    }

    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition((char *)rp, 35, 180, textbuf);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition((char *)rp, 35, 210, Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL);

    SetDrMd(rp, (LONG)old_drmd);
    rp->BitMap = old_bitmap;
}
