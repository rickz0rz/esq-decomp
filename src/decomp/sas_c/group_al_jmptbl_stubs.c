extern void LADFUNC_ComposePackedPenByte(void);
extern void LADFUNC_GetPackedPenLowNibble(void);
extern void LADFUNC_UpdateEntryFromTextAndAttrBuffers(void);
extern void ESQ_WriteDecFixedWidth(void);
extern void LADFUNC_BuildEntryBuffersOrDefault(void);
extern void LADFUNC_GetPackedPenHighNibble(void);

void GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(void)
{
    LADFUNC_ComposePackedPenByte();
}

void GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(void)
{
    LADFUNC_GetPackedPenLowNibble();
}

void GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(void)
{
    LADFUNC_UpdateEntryFromTextAndAttrBuffers();
}

void GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(void)
{
    ESQ_WriteDecFixedWidth();
}

void GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(void)
{
    LADFUNC_BuildEntryBuffersOrDefault();
}

void GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(void)
{
    LADFUNC_GetPackedPenHighNibble();
}
