#include <exec/types.h>
LONG SCRIPT_BuildTokenIndexMap(
    char *inputBytes,
    WORD *outIndexByToken,
    WORD tokenCount,
    const char *tokenTable,
    WORD maxScanCount,
    char terminatorByte,
    WORD fillMissingFlag)
{
    WORD tokenIndex;
    WORD nextTokenIndex;
    WORD scanIndex;
    WORD lastMatchedScanIndex;
    char tokenByte;

    tokenIndex = 0;
    lastMatchedScanIndex = 0;
    while (tokenIndex < tokenCount) {
        outIndexByToken[(LONG)tokenIndex] = (WORD)-1;
        ++tokenIndex;
    }

    nextTokenIndex = 0;
    scanIndex = 0;
    while (1) {
        tokenByte = inputBytes[(WORD)scanIndex];
        if (tokenByte == terminatorByte) {
            break;
        }
        if (scanIndex >= maxScanCount) {
            break;
        }

        tokenIndex = nextTokenIndex;
        while (tokenIndex < tokenCount) {
            if (tokenByte == tokenTable[(WORD)tokenIndex]) {
                outIndexByToken[(LONG)tokenIndex] = (WORD)(scanIndex + 1);
                inputBytes[(WORD)scanIndex] = 0;
                ++nextTokenIndex;
                lastMatchedScanIndex = scanIndex;
                break;
            }
            ++tokenIndex;
        }

        if (tokenCount > 0 && outIndexByToken[(LONG)(tokenCount - 1)] != (WORD)-1) {
            break;
        }

        ++scanIndex;
    }

    if (lastMatchedScanIndex == 0) {
        lastMatchedScanIndex = scanIndex;
    }

    if (fillMissingFlag != 0) {
        tokenIndex = 0;
        while (tokenIndex < tokenCount) {
            if (outIndexByToken[(LONG)tokenIndex] == (WORD)-1) {
                outIndexByToken[(LONG)tokenIndex] = lastMatchedScanIndex;
            }
            ++tokenIndex;
        }
    }

    return (LONG)scanIndex;
}
