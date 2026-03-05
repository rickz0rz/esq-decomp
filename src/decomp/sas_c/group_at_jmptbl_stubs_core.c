extern void ED1_WaitForFlagAndClearBit0(void);
extern void DOS_SystemTagList(void);

void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(void)
{
    ED1_WaitForFlagAndClearBit0();
}

void GROUP_AT_JMPTBL_DOS_SystemTagList(void)
{
    DOS_SystemTagList();
}
