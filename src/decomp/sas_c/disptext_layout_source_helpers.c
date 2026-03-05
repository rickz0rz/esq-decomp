typedef signed long LONG;

extern LONG DISPTEXT_LineTableLockFlag;
extern char Global_REF_1000_BYTES_ALLOCATED_1[];

extern void GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(char *dst, const char *fmt, void *argList);
extern LONG DISPTEXT_LayoutAndAppendToBuffer(const char *src, char *scratch);

LONG DISPTEXT_BuildLayoutForSource(const char *src, const char *fmt, LONG arg3)
{
    LONG status = 0;

    if (DISPTEXT_LineTableLockFlag == 0) {
        GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(
            Global_REF_1000_BYTES_ALLOCATED_1,
            fmt,
            &arg3);

        status = DISPTEXT_LayoutAndAppendToBuffer(src, Global_REF_1000_BYTES_ALLOCATED_1);
    }

    return status;
}
