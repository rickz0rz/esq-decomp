#include <exec/types.h>
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *in);
extern LONG DOS_OpenFileWithMode(const char *name, LONG mode);
extern LONG SCRIPT_CheckPathExists(const char *path);

LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *in)
{
    return PARSE_ReadSignedLongSkipClass3_Alt(in);
}

LONG GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const char *name, LONG mode)
{
    return DOS_OpenFileWithMode(name, mode);
}

LONG GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(const char *path)
{
    return SCRIPT_CheckPathExists(path);
}
