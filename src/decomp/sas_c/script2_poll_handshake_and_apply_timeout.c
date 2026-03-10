typedef short WORD;

extern WORD SCRIPT_CtrlInterfaceEnabledFlag;
extern WORD SCRIPT_CtrlLineAssertedTicks;
extern WORD ESQIFF_ExternalAssetFlags;
extern WORD LADFUNC_EntryCount;

extern long SCRIPT_ReadHandshakeBit5Mask(void);

void SCRIPT_PollHandshakeAndApplyTimeout(void)
{
    WORD ticks;

    if (SCRIPT_CtrlInterfaceEnabledFlag == 0) {
        return;
    }

    if ((SCRIPT_ReadHandshakeBit5Mask() & 0x20) == 0) {
        return;
    }

    ticks = (WORD)(SCRIPT_CtrlLineAssertedTicks + 1);
    SCRIPT_CtrlLineAssertedTicks = ticks;
    if (ticks >= 20) {
        ESQIFF_ExternalAssetFlags = 0;
        LADFUNC_EntryCount = 0x24;
        SCRIPT_CtrlLineAssertedTicks = 0;
    }
}
