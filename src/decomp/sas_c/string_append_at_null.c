char *STRING_AppendAtNull(char *dst, const char *src)
{
    char *ret;

    ret = dst;
    while (*dst++ != '\0') {}
    --dst;

    do {
        *dst++ = *src++;
    } while (dst[-1] != '\0');

    return ret;
}
