typedef signed long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
extern LONG _LVOSystemTagList(void *dosBase, LONG arg1, LONG arg2);

LONG DOS_SystemTagList(LONG arg1, LONG arg2)
{
    return _LVOSystemTagList(Global_REF_DOS_LIBRARY_2, arg1, arg2);
}
