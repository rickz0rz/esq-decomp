typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG WDISP_DisplayContextBase;

extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);

void TEXTDISP_TrimTextToPixelWidth(UBYTE *text, LONG maxWidth)
{
    UBYTE controlPrefix;
    UBYTE *current;
    UBYTE *lastSpace;
    void *rastPort;
    LONG totalWidth;
    LONG currentWidth;
    LONG len;

    controlPrefix = 25;
    current = text;
    lastSpace = (UBYTE *)0;
    currentWidth = 0;
    rastPort = (void *)((UBYTE *)WDISP_DisplayContextBase + 2);

    len = 0;
    while (text[len] != 0) {
        ++len;
    }
    totalWidth = _LVOTextLength(rastPort, text, len);

    while (totalWidth > maxWidth) {
        if (*current == 0) {
            return;
        }

        if (*current == 24 || *current == 25) {
            controlPrefix = *current++;
            len = 0;
            while (current[len] != 0) {
                ++len;
            }
            totalWidth = _LVOTextLength(rastPort, current, len);
            currentWidth = 0;
            lastSpace = (UBYTE *)0;
            continue;
        }

        currentWidth += _LVOTextLength(rastPort, current, 1);
        if (currentWidth > maxWidth) {
            if (lastSpace == (UBYTE *)0) {
                return;
            }

            *lastSpace = controlPrefix;
            current = lastSpace + 1;

            len = 0;
            while (current[len] != 0) {
                ++len;
            }
            totalWidth = _LVOTextLength(rastPort, current, len);
            currentWidth = 0;
            lastSpace = (UBYTE *)0;
            continue;
        }

        if (*current == ' ') {
            lastSpace = current;
        }

        ++current;
    }
}
