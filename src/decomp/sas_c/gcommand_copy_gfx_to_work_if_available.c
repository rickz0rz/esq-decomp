typedef signed long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
extern const char GCOMMAND_PATH_GFX_COLON[];
extern const char GCOMMAND_STR_WORK_COLON[];
extern const char GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS[];
extern const char GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_[];

extern LONG _LVOLock(void *dosBase, const char *name, LONG mode);
extern LONG _LVOUnLock(void *dosBase, LONG lock);

extern LONG GROUP_AT_JMPTBL_DOS_SystemTagList(LONG arg1, LONG arg2);
extern void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(void);
extern void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1(void);

void GCOMMAND_CopyGfxToWorkIfAvailable(void)
{
    LONG lock;
    LONG rc;

    rc = 0;
    lock = _LVOLock(Global_REF_DOS_LIBRARY_2, GCOMMAND_PATH_GFX_COLON, -2);
    if (lock == 0) {
        return;
    }
    _LVOUnLock(Global_REF_DOS_LIBRARY_2, lock);

    lock = _LVOLock(Global_REF_DOS_LIBRARY_2, GCOMMAND_STR_WORK_COLON, -2);
    if (lock == 0) {
        return;
    }
    _LVOUnLock(Global_REF_DOS_LIBRARY_2, lock);

    rc = GROUP_AT_JMPTBL_DOS_SystemTagList((LONG)GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS, 0);
    rc = GROUP_AT_JMPTBL_DOS_SystemTagList((LONG)GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_, 0);
    (void)rc;

    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0();
    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1();
}
