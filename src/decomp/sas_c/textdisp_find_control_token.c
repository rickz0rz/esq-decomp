typedef unsigned char UBYTE;
typedef unsigned short UWORD;

const char *TEXTDISP_FindControlToken(const char *textPtr)
{
    UWORD tokenDelta;

    while (*textPtr != 0) {
        if (((UBYTE)*textPtr & (UBYTE)0x80) != 0) {
            tokenDelta = (UWORD)(UBYTE)*textPtr;
            tokenDelta = (UWORD)(tokenDelta - (UWORD)0x84);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 5);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 2);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 3);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 6);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 1);
            if (tokenDelta == 0) {
                return textPtr;
            }

            tokenDelta = (UWORD)(tokenDelta - 8);
            if (tokenDelta == 0) {
                return textPtr;
            }
        }

        textPtr += 1;
    }

    return 0;
}
