#include <exec/types.h>

typedef LONG (*WdispOutputFunc)(LONG);

extern char *Global_FormatBufferPtr2;
extern LONG Global_FormatByteCount2;

extern LONG PARSE_ReadSignedLong_NoBranch(const UBYTE *in, LONG *outValue);
extern ULONG FORMAT_U32ToDecimalString(char *out, ULONG value);
extern ULONG FORMAT_U32ToHexString(UBYTE *dst, ULONG value);
extern ULONG FORMAT_U32ToOctalString(char *out, ULONG value);
extern void MEM_Move(const void *src, void *dst, ULONG size);
extern void STRING_ToUpperInPlace(char *text);
extern void WDISP_FormatWithCallback(WdispOutputFunc cb, const char *format, void *args);

static ULONG FORMAT_ParseFormatSpec_ReadU32(void **varArgsPtr)
{
    void *argSlot;

    argSlot = *varArgsPtr;
    *varArgsPtr = (void *)((UBYTE *)argSlot + 4);
    return *(ULONG *)argSlot;
}

LONG FORMAT_Buffer2WriteChar(LONG ch)
{
    char *cursor;

    Global_FormatByteCount2 += 1;
    cursor = Global_FormatBufferPtr2;
    *cursor = (char)ch;
    Global_FormatBufferPtr2 = cursor + 1;

    return ch;
}

LONG FORMAT_FormatToBuffer2(char *outBuf, const char *format, void *args)
{
    Global_FormatByteCount2 = 0;
    Global_FormatBufferPtr2 = outBuf;

    WDISP_FormatWithCallback(FORMAT_Buffer2WriteChar, format, args);

    *Global_FormatBufferPtr2 = '\0';
    return Global_FormatByteCount2;
}

char *FORMAT_ParseFormatSpec(char *fmt, void **varArgsPtr, WdispOutputFunc outputFunc)
{
    UBYTE leftJustify;
    UBYTE forcePlus;
    UBYTE forceSpace;
    UBYTE altForm;
    UBYTE padChar;
    UBYTE lengthIsLong;
    UBYTE conversionChar;
    LONG width;
    LONG precision;
    LONG fieldLen;
    LONG isNegative;
    ULONG value;
    ULONG charsWritten;
    LONG extraPad;
    char prefixBuffer[48];
    char *fieldPtr;
    char *moveDst;
    char *stringValue;
    char *callbackText;
    LONG ch;

    leftJustify = 0;
    forcePlus = 0;
    forceSpace = 0;
    altForm = 0;
    padChar = ' ';
    width = 0;
    precision = -1;
    lengthIsLong = 0;
    fieldLen = 0;
    isNegative = 0;
    fieldPtr = prefixBuffer;
    prefixBuffer[0] = '\0';
    prefixBuffer[1] = '\0';

    for (;;) {
        if (*fmt == '\0') {
            break;
        }

        ch = (UBYTE)*fmt;
        if (ch == ' ') {
            forceSpace = 1;
        } else if (ch == '#') {
            altForm = 1;
        } else if (ch == '+') {
            forcePlus = 1;
        } else if (ch == '-') {
            leftJustify = 1;
        } else {
            break;
        }

        ++fmt;
    }

    if ((UBYTE)*fmt == '0') {
        ++fmt;
        padChar = '0';
    }

    if ((UBYTE)*fmt == '*') {
        width = (LONG)FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        ++fmt;
    } else {
        fmt += PARSE_ReadSignedLong_NoBranch((const UBYTE *)fmt, &width);
    }

    if ((UBYTE)*fmt == '.') {
        ++fmt;
        if ((UBYTE)*fmt == '*') {
            precision = (LONG)FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
            ++fmt;
        } else {
            fmt += PARSE_ReadSignedLong_NoBranch((const UBYTE *)fmt, &precision);
        }
    }

    if ((UBYTE)*fmt == 'l') {
        lengthIsLong = 1;
        ++fmt;
    } else if ((UBYTE)*fmt == 'h') {
        ++fmt;
    }

    conversionChar = (UBYTE)*fmt++;
    switch (conversionChar) {
    case 'd':
    case 'i':
        if (lengthIsLong != 0) {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        } else {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        }

        isNegative = 0;
        if ((LONG)value < 0) {
            value = (ULONG)(-(LONG)value);
            isNegative = 1;
        }

        if (isNegative != 0) {
            prefixBuffer[0] = '-';
        } else if (forcePlus != 0) {
            prefixBuffer[0] = '+';
        } else {
            prefixBuffer[0] = ' ';
        }

        if ((forcePlus != 0) || (forceSpace != 0) || (isNegative != 0)) {
            ++fieldPtr;
            ++fieldLen;
        }

        charsWritten = FORMAT_U32ToDecimalString(fieldPtr, value);
        if (precision < 0) {
            precision = 1;
        }

        extraPad = precision - (LONG)charsWritten;
        if (extraPad > 0) {
            moveDst = fieldPtr + extraPad;
            MEM_Move(fieldPtr, moveDst, charsWritten);
            while (extraPad-- >= 0) {
                *fieldPtr++ = (char)padChar;
            }
            charsWritten = (ULONG)precision;
        }

        fieldLen += (LONG)charsWritten;
        fieldPtr = prefixBuffer;
        if (leftJustify != 0) {
            padChar = ' ';
        }
        break;

    case 'u':
        if (lengthIsLong != 0) {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        } else {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        }

        charsWritten = FORMAT_U32ToDecimalString(fieldPtr, value);
        if (precision < 0) {
            precision = 1;
        }

        extraPad = precision - (LONG)charsWritten;
        if (extraPad > 0) {
            moveDst = fieldPtr + extraPad;
            MEM_Move(fieldPtr, moveDst, charsWritten);
            while (extraPad-- >= 0) {
                *fieldPtr++ = (char)padChar;
            }
            charsWritten = (ULONG)precision;
        }

        fieldLen += (LONG)charsWritten;
        fieldPtr = prefixBuffer;
        if (leftJustify != 0) {
            padChar = ' ';
        }
        break;

    case 'o':
        if (lengthIsLong != 0) {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        } else {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        }

        if (altForm != 0) {
            *fieldPtr++ = '0';
            fieldLen = 1;
        }

        charsWritten = FORMAT_U32ToOctalString(fieldPtr, value);
        if (precision < 0) {
            precision = 1;
        }

        extraPad = precision - (LONG)charsWritten;
        if (extraPad > 0) {
            moveDst = fieldPtr + extraPad;
            MEM_Move(fieldPtr, moveDst, charsWritten);
            while (extraPad-- >= 0) {
                *fieldPtr++ = (char)padChar;
            }
            charsWritten = (ULONG)precision;
        }

        fieldLen += (LONG)charsWritten;
        fieldPtr = prefixBuffer;
        if (leftJustify != 0) {
            padChar = ' ';
        }
        break;

    case 'x':
    case 'X':
        padChar = '0';
        if (precision < 0) {
            precision = 8;
        }

        if (lengthIsLong != 0) {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        } else {
            value = FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        }

        if (altForm != 0) {
            *fieldPtr++ = '0';
            *fieldPtr++ = 'x';
            fieldLen = 2;
        }

        charsWritten = FORMAT_U32ToHexString((UBYTE *)fieldPtr, value);
        extraPad = precision - (LONG)charsWritten;
        if (extraPad > 0) {
            moveDst = fieldPtr + extraPad;
            MEM_Move(fieldPtr, moveDst, charsWritten);
            while (extraPad-- >= 0) {
                *fieldPtr++ = (char)padChar;
            }
            charsWritten = (ULONG)precision;
        }

        fieldLen += (LONG)charsWritten;
        fieldPtr = prefixBuffer;
        if (conversionChar == 'X') {
            STRING_ToUpperInPlace(prefixBuffer);
        }
        if (leftJustify != 0) {
            padChar = ' ';
        }
        break;

    case 's':
        stringValue = (char *)(ULONG)FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        if (stringValue == 0) {
            stringValue = "";
        }

        callbackText = stringValue;
        while (*callbackText != '\0') {
            ++callbackText;
        }

        fieldLen = callbackText - stringValue;
        if ((precision >= 0) && (fieldLen > precision)) {
            fieldLen = precision;
        }
        fieldPtr = stringValue;
        break;

    case 'c':
        fieldLen = 1;
        prefixBuffer[0] = (char)FORMAT_ParseFormatSpec_ReadU32(varArgsPtr);
        prefixBuffer[1] = '\0';
        fieldPtr = prefixBuffer;
        break;

    default:
        return 0;
    }

    if (width < fieldLen) {
        width = 0;
    } else {
        width -= fieldLen;
    }

    if (leftJustify != 0) {
        while (fieldLen-- > 0) {
            outputFunc((UBYTE)*fieldPtr++);
        }
        while (width-- > 0) {
            outputFunc((UBYTE)padChar);
        }
    } else {
        while (width-- > 0) {
            outputFunc((UBYTE)padChar);
        }
        while (fieldLen-- > 0) {
            outputFunc((UBYTE)*fieldPtr++);
        }
    }

    return fmt;
}
