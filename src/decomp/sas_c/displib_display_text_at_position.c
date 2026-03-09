extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOMove(void *graphicsBase, char *rastPort, long x, long y);
extern void _LVOText(void *graphicsBase, char *rastPort, const char *text, long len);

void DISPLIB_DisplayTextAtPosition(char *rastPort, long x, long y, const char *text)
{
    long len = 0;

    if (text == 0) {
        return;
    }

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, x, y);

    while (text[len] != 0) {
        len++;
    }

    _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, text, len);
}
