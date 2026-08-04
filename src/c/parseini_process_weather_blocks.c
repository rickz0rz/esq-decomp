/* RESTORES: _PARSEINI_ProcessWeatherBlocks
 * MODULE:   modules/groups/b/a/parseini_p1_2_p0.s
 * STATUS:   behavioural
 *
 * Applies one key/value pair from the weather section of the INI to the block
 * currently being built. It is called once per line, and it keeps its state in
 * two globals rather than in the caller.
 *
 * FILENAME STARTS A NEW BLOCK and the others fill it in, so the order of lines
 * in the file is load-bearing: a key arriving before any FILENAME finds a null
 * block pointer and is dropped by the guard. The first block allocated also
 * becomes the list head.
 *
 * THE COMPARISON RETURNS ZERO FOR EQUAL, so every test below reads inverted.
 * That is the ordinary STRING_CompareNoCase convention and not the inverted
 * wildcard one, but the two look alike in the disassembly.
 *
 * KEYS ARE TESTED IN A FIXED ORDER AND MOST RETURN. The exception is FILENAME,
 * which falls THROUGH to the rest of the chain after allocating -- so a line
 * whose key is FILENAME is then compared against every other tag as well. Those
 * comparisons cannot match, but the original makes them and the C below
 * preserves the fall-through rather than returning early.
 *
 * SOURCE IS THE ONLY KEY WITH A LENGTH GUARD, and failing it does NOT return:
 * an empty SOURCE value falls through to the HORIZONTAL test and continues down
 * the chain. Writing it as an early return would change which later tags an
 * empty SOURCE line can reach.
 *
 * SOURCE ALSO OVERLOADS ITS VALUE. The literal "PPV" sets the block type to 3
 * instead of appending anything; every other value allocates a 12-byte node and
 * links it. So the source list and the type field are written by the same key.
 *
 * THE LINK IS MADE THROUGH THE PREVIOUS NODE, captured BEFORE the allocation.
 * The global holding the previous node is overwritten by the new one as soon as
 * the allocation returns, so the local copy taken first is what closes the
 * list. Reading the global instead links each node to itself.
 *
 * The three-way alignment tags share one shape: a named value maps to 2, CENTER
 * maps to 1, and anything else -- including an unrecognised word -- maps to 0.
 * There is no rejection path.
 *
 * The ID field is a two-character copy with an explicit terminator written
 * afterwards, at +193, which is why the struct declares it separately from the
 * two-byte array.
 *
 * 990 ref vs 980 got, 26 differing regions. All twenty-two tag comparisons in
 * the original order, the fall-through after FILENAME, the block guard, all six
 * numeric fields with their distinct offsets, the SOURCE length guard and its
 * PPV special case, the 12-byte allocation with its line number, the
 * previous-node link, both three-way alignment ladders and the ID copy with its
 * separate terminator match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff8 ... 2b48fff8   LINK.W A5,#-8 / MOVE.L A0,-8(A5)
 *   got:     the previous-node pointer kept in a register
 *   summary: the frame class, and it goes the other way here -- the original
 *            spills the one local it has, 6.51 does not, and the candidate is
 *            10 bytes UNDER rather than over. The same divergence, opposite
 *            sign, because this function has almost no register pressure.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct WeatherSource {                  /* 12 bytes */
    char                  label[8];     /* +0, NUL-terminated, copied in */
    struct WeatherSource *link;         /* +8 */
};

struct WeatherBlock {
    char                  pad0[190];
    unsigned char         type;         /* +190 */
    char                  id[2];        /* +191 */
    char                  idTerm;       /* +193 */
    long                  colorMode;    /* +194 */
    long                  xpos;         /* +198 */
    long                  ypos;         /* +202 */
    long                  xsource;      /* +206 */
    long                  ysource;      /* +210 */
    long                  sizex;        /* +214 */
    long                  sizey;        /* +218 */
    long                  hAlign;       /* +222 */
    long                  vAlign;       /* +226 */
    struct WeatherSource *sourceHead;   /* +230 */
};

extern long  STRING_CompareNoCase(char *a, char *b);
extern void *BRUSH_AllocBrushNode(char *name, void *prev);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void *MEMORY_AllocateMemory(char *who, long line,
                                                 long size, long flags);
extern void  STRING_CopyPadNul(char *dst, char *src, long n);

extern struct WeatherBlock  *PARSEINI_CurrentWeatherBlockPtr;
extern struct WeatherSource *PARSEINI_CurrentWeatherBlockTempPtr;
extern void  *PARSEINI_ParsedDescriptorListHead;

extern char PARSEINI_TAG_FILENAME_WeatherBlock[];
extern char PARSEINI_STR_LOADCOLOR[];
extern char PARSEINI_TAG_ALL[];
extern char PARSEINI_TAG_NONE[];
extern char PARSEINI_TAG_TEXT[];
extern char PARSEINI_TAG_XPOS[];
extern char PARSEINI_TAG_TYPE[];
extern char PARSEINI_TAG_DITHER[];
extern char PARSEINI_TAG_YPOS[];
extern char PARSEINI_TAG_XSOURCE[];
extern char PARSEINI_TAG_YSOURCE[];
extern char PARSEINI_TAG_SIZEX[];
extern char PARSEINI_TAG_SIZEY[];
extern char PARSEINI_TAG_SOURCE[];
extern char PARSEINI_TAG_PPV[];
extern char PARSEINI_STR_HORIZONTAL[];
extern char PARSEINI_TAG_RIGHT[];
extern char PARSEINI_TAG_CENTER_HorizontalAlign[];
extern char PARSEINI_TAG_VERTICAL[];
extern char PARSEINI_TAG_BOTTOM[];
extern char PARSEINI_TAG_CENTER_VerticalAlign[];
extern char PARSEINI_TAG_ID[];
extern char Global_STR_PARSEINI_C_3[];

void PARSEINI_ProcessWeatherBlocks(char *key, char *value)
{
    struct WeatherSource *prev;
    struct WeatherSource *node;

    prev = 0;

    if (PARSEINI_ParsedDescriptorListHead == 0) {
        PARSEINI_CurrentWeatherBlockTempPtr = 0;
        PARSEINI_CurrentWeatherBlockPtr     = 0;
    }

    if (STRING_CompareNoCase(
            key, PARSEINI_TAG_FILENAME_WeatherBlock) == 0) {

        PARSEINI_CurrentWeatherBlockTempPtr = 0;

        PARSEINI_CurrentWeatherBlockPtr = BRUSH_AllocBrushNode(
            value, PARSEINI_CurrentWeatherBlockPtr);

        PARSEINI_CurrentWeatherBlockPtr->type = 1;

        if (PARSEINI_ParsedDescriptorListHead == 0)
            PARSEINI_ParsedDescriptorListHead = PARSEINI_CurrentWeatherBlockPtr;
    }

    if (PARSEINI_CurrentWeatherBlockPtr == 0)
        return;

    if (STRING_CompareNoCase(key, PARSEINI_STR_LOADCOLOR)
        == 0) {

        if (STRING_CompareNoCase(value, PARSEINI_TAG_ALL) == 0)
            PARSEINI_CurrentWeatherBlockPtr->colorMode = 0;
        else if (STRING_CompareNoCase(value,
                                                      PARSEINI_TAG_NONE) == 0)
            PARSEINI_CurrentWeatherBlockPtr->colorMode = 2;
        else if (STRING_CompareNoCase(value,
                                                      PARSEINI_TAG_TEXT) == 0)
            PARSEINI_CurrentWeatherBlockPtr->colorMode = 3;
        else
            PARSEINI_CurrentWeatherBlockPtr->colorMode = 1;
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_XPOS) == 0) {
        PARSEINI_CurrentWeatherBlockPtr->xpos =
            PARSE_ReadSignedLongSkipClass3_Alt(value);
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_TYPE) == 0) {
        if (STRING_CompareNoCase(value, PARSEINI_TAG_DITHER)
            == 0)
            PARSEINI_CurrentWeatherBlockPtr->type = 2;
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_YPOS) == 0) {
        PARSEINI_CurrentWeatherBlockPtr->ypos =
            PARSE_ReadSignedLongSkipClass3_Alt(value);
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_XSOURCE) == 0) {
        PARSEINI_CurrentWeatherBlockPtr->xsource =
            PARSE_ReadSignedLongSkipClass3_Alt(value);
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_YSOURCE) == 0) {
        PARSEINI_CurrentWeatherBlockPtr->ysource =
            PARSE_ReadSignedLongSkipClass3_Alt(value);
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_SIZEX) == 0) {
        PARSEINI_CurrentWeatherBlockPtr->sizex =
            PARSE_ReadSignedLongSkipClass3_Alt(value);
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_SIZEY) == 0) {
        PARSEINI_CurrentWeatherBlockPtr->sizey =
            PARSE_ReadSignedLongSkipClass3_Alt(value);
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_SOURCE) == 0
        && strlen(value) > 0) {

        if (STRING_CompareNoCase(value, PARSEINI_TAG_PPV)
            == 0) {
            PARSEINI_CurrentWeatherBlockPtr->type = 3;
            return;
        }

        prev = PARSEINI_CurrentWeatherBlockTempPtr;

        node = MEMORY_AllocateMemory(Global_STR_PARSEINI_C_3,
                                                   670L, 12L,
                                                   MEMF_PUBLIC | MEMF_CLEAR);
        PARSEINI_CurrentWeatherBlockTempPtr = node;

        if (node == 0)
            return;

        node->link = 0;
        strcpy(node->label, value);

        if (PARSEINI_CurrentWeatherBlockPtr->sourceHead == 0)
            PARSEINI_CurrentWeatherBlockPtr->sourceHead =
                PARSEINI_CurrentWeatherBlockTempPtr;
        else
            prev->link = PARSEINI_CurrentWeatherBlockTempPtr;

        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_STR_HORIZONTAL)
        == 0) {

        if (STRING_CompareNoCase(value, PARSEINI_TAG_RIGHT)
            == 0)
            PARSEINI_CurrentWeatherBlockPtr->hAlign = 2;
        else if (STRING_CompareNoCase(
                     value, PARSEINI_TAG_CENTER_HorizontalAlign) == 0)
            PARSEINI_CurrentWeatherBlockPtr->hAlign = 1;
        else
            PARSEINI_CurrentWeatherBlockPtr->hAlign = 0;
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_VERTICAL)
        == 0) {

        if (STRING_CompareNoCase(value, PARSEINI_TAG_BOTTOM)
            == 0)
            PARSEINI_CurrentWeatherBlockPtr->vAlign = 2;
        else if (STRING_CompareNoCase(
                     value, PARSEINI_TAG_CENTER_VerticalAlign) == 0)
            PARSEINI_CurrentWeatherBlockPtr->vAlign = 1;
        else
            PARSEINI_CurrentWeatherBlockPtr->vAlign = 0;
        return;
    }

    if (STRING_CompareNoCase(key, PARSEINI_TAG_ID) != 0)
        return;

    STRING_CopyPadNul(PARSEINI_CurrentWeatherBlockPtr->id,
                                     value, 2L);
    PARSEINI_CurrentWeatherBlockPtr->idTerm = 0;
}
