char *STRING_AppendAtNull(char *dst, const char *src)
{
    char *ret;

    ret = dst;
    while (*dst != 0) {
        ++dst;
    }

    do {
        *dst = *src;
        ++src;
    } while (*dst++ != 0);

    return ret;
}
