#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include <graphics/text.h>

extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOTextLength(void *gfxBase, struct RastPort *rastPort, char *text, LONG count);
extern void _LVOSetAPen(void *gfxBase, struct RastPort *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, struct RastPort *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, struct RastPort *rastPort, LONG mode);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rastPort, LONG x, LONG y, const char *text);

void TLIBA3_DrawCenteredWrappedTextLines(struct RastPort *rastPort, const char *text, LONG y)
{
    BYTE savedDrawMode;
    BYTE savedFgPen;
    BYTE savedBgPen;
    BYTE savedMask;
    UBYTE savedDepth;
    LONG rastWidthPixels;
    BYTE splitChar;
    char *lineText;

    splitChar = 0;
    lineText = (char *)text;

    savedDrawMode = rastPort->DrawMode;
    savedFgPen = rastPort->FgPen;
    savedBgPen = rastPort->BgPen;
    savedMask = rastPort->Mask;
    savedDepth = rastPort->BitMap->Depth;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 7);

    rastWidthPixels = ((LONG)rastPort->BitMap->BytesPerRow) << 3;

    for (;;) {
        LONG textLen;
        LONG centerX;
        BYTE nextSplitChar;

        textLen = 0;
        while (lineText[textLen] != '\0') {
            textLen++;
        }

        for (;;) {
            if (textLen <= 0) {
                break;
            }

            centerX = rastWidthPixels -
                _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, lineText, textLen);
            if (centerX < 0) {
                centerX++;
            }
            centerX >>= 1;
            if (centerX >= 0) {
                break;
            }

            textLen--;
        }

        if (splitChar != 0) {
            nextSplitChar = 0;
        } else {
            nextSplitChar = lineText[textLen];
        }

        lineText[textLen] = '\0';
        splitChar = nextSplitChar;

        if (centerX >= 0) {
            DISPLIB_DisplayTextAtPosition(rastPort, centerX, y, lineText);
        }

        y += (LONG)rastPort->Font->tf_Baseline + 1;
        lineText[textLen] = splitChar;
        lineText += textLen;
        if (*lineText == '\0') {
            break;
        }
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, (LONG)savedFgPen);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rastPort, (LONG)savedBgPen);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, (LONG)savedDrawMode);
    rastPort->Mask = (UBYTE)savedMask;
    rastPort->BitMap->Depth = savedDepth;
}
