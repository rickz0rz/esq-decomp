#include <exec/types.h>
extern LONG PARSE_ReadSignedLong(const char *in, LONG *out_value);

LONG PARSE_ReadSignedLong_ParseLoop(const char *in, LONG *out_value)
{
    return PARSE_ReadSignedLong(in, out_value);
}

LONG PARSE_ReadSignedLong_ParseLoopEntry(const char *in, LONG *out_value)
{
    return PARSE_ReadSignedLong(in, out_value);
}

LONG PARSE_ReadSignedLong_ParseDone(const char *in, LONG *out_value)
{
    return PARSE_ReadSignedLong(in, out_value);
}

LONG PARSE_ReadSignedLong_StoreResult(const char *in, LONG *out_value)
{
    return PARSE_ReadSignedLong(in, out_value);
}

LONG PARSE_ReadSignedLong_NegateValue(LONG value)
{
    return -value;
}
