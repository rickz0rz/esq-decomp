typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG LADFUNC_ComposePackedPenByte(UBYTE highNibble, UBYTE lowNibble);
extern LONG LADFUNC_GetPackedPenLowNibble(UBYTE packed);
extern void LADFUNC_UpdateEntryFromTextAndAttrBuffers(LONG entryIndex, char *textBuf, UBYTE *attrBuf);
extern void ESQ_WriteDecFixedWidth(char *outBuf, LONG value, LONG digits);
extern void LADFUNC_BuildEntryBuffersOrDefault(LONG entryIndex, char *outText, UBYTE *outAttr);
extern LONG LADFUNC_GetPackedPenHighNibble(UBYTE packed);

LONG GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(UBYTE highNibble, UBYTE lowNibble)
{
    return LADFUNC_ComposePackedPenByte(highNibble, lowNibble);
}

LONG GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(UBYTE packed)
{
    return LADFUNC_GetPackedPenLowNibble(packed);
}

void GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(LONG entryIndex, char *textBuf, UBYTE *attrBuf)
{
    LADFUNC_UpdateEntryFromTextAndAttrBuffers(entryIndex, textBuf, attrBuf);
}

void GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(char *outBuf, LONG value, LONG digits)
{
    ESQ_WriteDecFixedWidth(outBuf, value, digits);
}

void GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(LONG entryIndex, char *outText, UBYTE *outAttr)
{
    LADFUNC_BuildEntryBuffersOrDefault(entryIndex, outText, outAttr);
}

LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(UBYTE packed)
{
    return LADFUNC_GetPackedPenHighNibble(packed);
}
