typedef signed long LONG;

typedef LONG (*WdispOutputFunc)(LONG);

extern char *Global_FormatBufferPtr2;
extern LONG Global_FormatByteCount2;

extern void WDISP_FormatWithCallback(WdispOutputFunc cb, const char *format, void *args);

LONG FORMAT_Buffer2WriteChar(LONG ch)
{
    Global_FormatByteCount2 += 1;
    *Global_FormatBufferPtr2++ = (char)ch;

    return ch;
}

LONG FORMAT_FormatToBuffer2(char *outBuf, const char *format, void *args)
{
    Global_FormatByteCount2 = 0;
    Global_FormatBufferPtr2 = outBuf;

    WDISP_FormatWithCallback(FORMAT_Buffer2WriteChar, format, args);

    *Global_FormatBufferPtr2 = '\0';
    return Global_FormatByteCount2;
}
