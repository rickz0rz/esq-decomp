typedef signed long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
#pragma libcall Global_REF_DOS_LIBRARY_2 SystemTagList 1c8 2102
extern LONG SystemTagList(LONG arg1, LONG arg2);

LONG DOS_SystemTagList(LONG arg1, LONG arg2)
{
    return SystemTagList(arg1, arg2);
}
