typedef signed long LONG;

extern char *Global_REF_RASTPORT_1;
extern const char Global_STR_REBOOTING_COMPUTER[];

extern LONG ED_IsConfirmKey(void);
extern LONG DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern void ED1_JMPTBL_ESQ_ColdReboot(void);
extern void ED_DrawESCMenuBottomHelp(void);

void ED_RebootComputer(void)
{
    LONG d6;
    LONG d7;

    d7 = ED_IsConfirmKey();
    if (((unsigned char)d7) == 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_REBOOTING_COMPUTER);

        for (d6 = 0; d6 < 0xAAE60; d6 += 2) {
        }

        ED1_JMPTBL_ESQ_ColdReboot();
    }

    ED_DrawESCMenuBottomHelp();
}
