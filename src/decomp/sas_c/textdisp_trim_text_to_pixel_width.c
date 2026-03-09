typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG WDISP_DisplayContextBase;

extern LONG _LVOTextLength(void *rastPort, char *text, LONG len);

typedef struct TEXTDISP_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} TEXTDISP_DisplayContext;

void TEXTDISP_TrimTextToPixelWidth(char *text, LONG maxWidth)
{
    UBYTE controlPrefix;
    char *current;
    char *lastSpace;
    TEXTDISP_DisplayContext *context;
    void *rastPort;
    LONG totalWidth;
    LONG currentWidth;
    LONG len;

    controlPrefix = 25;
    current = text;
    lastSpace = (char *)0;
    currentWidth = 0;
    context = (TEXTDISP_DisplayContext *)WDISP_DisplayContextBase;
    rastPort = (void *)context->rastPort;

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
            lastSpace = (char *)0;
            continue;
        }

        currentWidth += _LVOTextLength(rastPort, current, 1);
        if (currentWidth > maxWidth) {
            if (lastSpace == (char *)0) {
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
            lastSpace = (char *)0;
            continue;
        }

        if (*current == ' ') {
            lastSpace = current;
        }

        ++current;
    }
}
