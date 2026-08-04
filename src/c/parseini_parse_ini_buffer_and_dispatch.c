/* RESTORES: _PARSEINI_ParseIniBufferAndDispatch
 * MODULE:   modules/groups/b/a/parseini.s
 * STATUS:   behavioural
 *
 * The INI reader: loads a file into the work buffer, walks it line by line, tracks
 * which `[section]` is open, and hands each `key = value` pair to that section's
 * own handler. 1792 bytes.
 *
 * Eight sections are recognised -- qtable, backdrop, gradient, textads, brush,
 * banner, "default text" and "source config" -- and three of them do work at the
 * header rather than at the lines: gradient seeds the gradient preset table,
 * banner clears the weather-brush pending flag, and "default text" resets the
 * three weather message pointers to their built-in strings.
 *
 * THE KEY/VALUE SPLIT IS WRITTEN OUT SEVEN TIMES. Every section except gradient
 * repeats the same twenty-line sequence: find '=', terminate the key there, skip
 * whitespace at the head of the value, trim trailing whitespace off the KEY with
 * its own delimiter string, then trim trailing whitespace off the value. The
 * original does not share it, and each copy uses a DIFFERENT delimiter symbol
 * (PARSEINI_DelimSpaceTab_Section1 .. _Section8), so it cannot be shared here
 * either -- those are eight separate data labels with eight relocations.
 *
 * `CharClassTable[c] & 8` is the whitespace class; bit 3 is what the original
 * tests with `BTST #3`.
 *
 * The gradient section is the exception: it passes the WHOLE line to
 * PARSEINI_ParseRangeKeyValue and does its own splitting there.
 *
 * The qtable section is the other exception. It allocates an eight-byte alias
 * entry per line, stores the key and the first double-quoted substring of the
 * value into it, and RETURNS EARLY WITH 0 if either quote is missing -- leaving
 * the file loaded and the work buffer un-freed. That leak is in the original.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                JSR (d16,PC)
 *   got:     61000000                BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffd4 ... 4e5d       LINK.W A5,#-44 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: no-return-value-on-the-normal-path
 *   ref:     the deallocate call's D0 is returned unchanged
 *   got:     the same, by falling off the end
 *   summary: the original's normal exit runs MEMORY_DeallocateMemory and then
 *            MOVEM/UNLK/RTS with no MOVEQ, so it returns whatever that call left
 *            in D0. This restoration reproduces it by falling off the end of a
 *            `long` function rather than by inventing a `return 0`, which would
 *            add two bytes and a value the original never sets.
 *   scope:   this function.
 *   retest:  n/a.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: 1776 against 1792, -16 over 58 regions -- SIXTEEN SHORT, 0.9%.
 *            NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3: with
 *            seven copies of one block, a per-hunk listing is seven copies of the
 *            same register-allocation difference.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <string.h>

struct AliasEntry {
    char *key;                  /* 0 */
    char *value;                /* 4 */
};

extern unsigned char WDISP_CharClassTable[];
extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern struct AliasEntry *TEXTDISP_AliasPtrTable[];
extern short TEXTDISP_AliasCount;
extern long  P_TYPE_WeatherBrushRefreshPendingFlag;
extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;
extern char *Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;
extern char *SCRIPT_PtrNoForecastWeatherData;
extern char *SCRIPT_PtrWeatherDataAvailabilityDisclaimer;
extern char  GCOMMAND_GradientPresetTable[1];

extern char P_TYPE_STR_QTABLE[];
extern char P_TYPE_TAG_BACKDROP[];
extern char P_TYPE_TAG_GRADIENT[];
extern char P_TYPE_TAG_TEXTADS[];
extern char P_TYPE_TAG_BRUSH[];
extern char P_TYPE_TAG_BANNER[];
extern char P_TYPE_STR_DEFAULT_TEXT[];
extern char P_TYPE_STR_SOURCE_CONFIG[];
extern char Global_STR_PARSEINI_C_1[];
extern char Global_STR_PARSEINI_C_2[];
extern char PARSEINI_DelimSpaceTab_Section1[];
extern char PARSEINI_DelimSpaceTab_Section2[];
extern char PARSEINI_DelimSpaceTab_Section4_5[];
extern char PARSEINI_DelimSpaceTab_Section6[];
extern char PARSEINI_DelimSpaceTab_Section7[];
extern char PARSEINI_DelimSpaceTab_Section8[];

extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern char *DISKIO_ConsumeLineFromWorkBuffer(void);
extern char *STR_FindCharPtr(char *s, long c);
extern char *STR_FindAnyCharPtr(char *s, char *set);
extern long  STRING_CompareNoCase(char *a, char *b);
extern char *ESQPARS_ReplaceOwnedString(char *newText,
                                                        char *oldText);
extern void  GCOMMAND_InitPresetTableFromPalette(void *table);
extern void  TEXTDISP_ClearSourceConfig(void);
extern void  TEXTDISP_AddSourceConfigEntry(char *key, char *value);
extern void  PARSEINI_ProcessWeatherBlocks(char *key, char *value);
extern void  PARSEINI_ParseRangeKeyValue(char *line, void *table);
extern void  PARSEINI_ParseColorTable(char *key, char *value, long section);
extern void  PARSEINI_LoadWeatherStrings(char *key, char *value);
extern void  PARSEINI_LoadWeatherMessageStrings(char *key, char *value);
extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                   long size);

long PARSEINI_ParseIniBufferAndDispatch(char *path)
{
    struct AliasEntry *entry;
    char *work;
    char *line;
    char *value;
    char *marker;
    char *end;
    char *quote;
    long  fileLen;
    long  section;
    long  aliasIndex;

    section = 0;
    aliasIndex = -1;

    if (DISKIO_LoadFileToWorkBuffer(path) == -1)
        return -1;

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    work = Global_PTR_WORK_BUFFER;

    for (;;) {
        line = DISKIO_ConsumeLineFromWorkBuffer();
        if (line == (char *)-1)
            break;

        while ((WDISP_CharClassTable[(unsigned char)*line] & 8) != 0)
            line++;

        if (*line == 91) {
            marker = STR_FindCharPtr(line + 1, 93L);
            if (marker == 0)
                continue;
            *marker = 0;

            if (STRING_CompareNoCase(line + 1,
                                                     P_TYPE_STR_QTABLE) == 0) {
                section = 1;
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_TAG_BACKDROP) == 0) {
                section = 2;
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_TAG_GRADIENT) == 0) {
                section = 3;
                GCOMMAND_InitPresetTableFromPalette(
                    GCOMMAND_GradientPresetTable);
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_TAG_TEXTADS) == 0) {
                section = 4;
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_TAG_BRUSH) == 0) {
                section = 5;
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_TAG_BANNER) == 0) {
                section = 6;
                P_TYPE_WeatherBrushRefreshPendingFlag = 0;
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_STR_DEFAULT_TEXT) == 0) {
                section = 7;
                P_TYPE_WeatherCurrentMsgPtr =
                    ESQPARS_ReplaceOwnedString(
                        Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,
                        P_TYPE_WeatherCurrentMsgPtr);
                P_TYPE_WeatherForecastMsgPtr =
                    ESQPARS_ReplaceOwnedString(
                        SCRIPT_PtrNoForecastWeatherData,
                        P_TYPE_WeatherForecastMsgPtr);
                P_TYPE_WeatherBottomLineMsgPtr =
                    ESQPARS_ReplaceOwnedString(
                        SCRIPT_PtrWeatherDataAvailabilityDisclaimer,
                        P_TYPE_WeatherBottomLineMsgPtr);
            } else if (STRING_CompareNoCase(
                           line + 1, P_TYPE_STR_SOURCE_CONFIG) == 0) {
                TEXTDISP_ClearSourceConfig();
                section = 8;
            } else {
                section = 0;
            }
            continue;
        }

        switch (section) {

        case 1:
            value = STR_FindCharPtr(line, 61L);
            if (value == 0) {
                TEXTDISP_AliasCount = 0;
                continue;
            }
            *value = 0;
            value++;
            while ((WDISP_CharClassTable[(unsigned char)*value] & 8) != 0)
                value++;
            marker = STR_FindAnyCharPtr(
                line, PARSEINI_DelimSpaceTab_Section1);
            if (marker != 0)
                *marker = 0;
            end = value + strlen(value) - 1;
            while (end > value &&
                   (WDISP_CharClassTable[(unsigned char)*end] & 8) != 0) {
                *end = 0;
                end--;
            }

            aliasIndex = aliasIndex + 1;
            TEXTDISP_AliasPtrTable[aliasIndex] = (struct AliasEntry *)
                MEMORY_AllocateMemory(Global_STR_PARSEINI_C_1,
                                                    219L, 8L,
                                                    MEMF_PUBLIC | MEMF_CLEAR);
            entry = TEXTDISP_AliasPtrTable[aliasIndex];
            entry->key = entry->value = 0;
            entry->key = ESQPARS_ReplaceOwnedString(line,
                                                                    entry->key);

            quote = STR_FindCharPtr(value, 34L);
            if (quote == 0) {
                TEXTDISP_AliasCount = 0;
                return 0;
            }
            value = quote + 1;
            quote = STR_FindCharPtr(value, 34L);
            if (quote == 0) {
                TEXTDISP_AliasCount = 0;
                return 0;
            }
            *quote = 0;
            entry->value = ESQPARS_ReplaceOwnedString(
                value, entry->value);
            TEXTDISP_AliasCount = (short)(aliasIndex + 1);
            break;

        case 2:
            value = STR_FindCharPtr(line, 61L);
            if (value == 0)
                continue;
            *value = 0;
            value++;
            while ((WDISP_CharClassTable[(unsigned char)*value] & 8) != 0)
                value++;
            marker = STR_FindAnyCharPtr(
                line, PARSEINI_DelimSpaceTab_Section2);
            if (marker != 0)
                *marker = 0;
            end = value + strlen(value) - 1;
            while (end > value &&
                   (WDISP_CharClassTable[(unsigned char)*end] & 8) != 0) {
                *end = 0;
                end--;
            }
            PARSEINI_ProcessWeatherBlocks(line, value);
            break;

        case 3:
            PARSEINI_ParseRangeKeyValue(line, GCOMMAND_GradientPresetTable);
            break;

        case 4:
        case 5:
            value = STR_FindCharPtr(line, 61L);
            if (value == 0)
                continue;
            *value = 0;
            value++;
            while ((WDISP_CharClassTable[(unsigned char)*value] & 8) != 0)
                value++;
            marker = STR_FindAnyCharPtr(
                line, PARSEINI_DelimSpaceTab_Section4_5);
            if (marker != 0)
                *marker = 0;
            end = value + strlen(value) - 1;
            while (end > value &&
                   (WDISP_CharClassTable[(unsigned char)*end] & 8) != 0) {
                *end = 0;
                end--;
            }
            PARSEINI_ParseColorTable(line, value, section);
            break;

        case 6:
            value = STR_FindCharPtr(line, 61L);
            if (value == 0)
                continue;
            *value = 0;
            value++;
            while ((WDISP_CharClassTable[(unsigned char)*value] & 8) != 0)
                value++;
            marker = STR_FindAnyCharPtr(
                line, PARSEINI_DelimSpaceTab_Section6);
            if (marker != 0)
                *marker = 0;
            end = value + strlen(value) - 1;
            while (end > value &&
                   (WDISP_CharClassTable[(unsigned char)*end] & 8) != 0) {
                *end = 0;
                end--;
            }
            PARSEINI_LoadWeatherStrings(line, value);
            break;

        case 7:
            value = STR_FindCharPtr(line, 61L);
            if (value == 0)
                continue;
            *value = 0;
            value++;
            while ((WDISP_CharClassTable[(unsigned char)*value] & 8) != 0)
                value++;
            marker = STR_FindAnyCharPtr(
                line, PARSEINI_DelimSpaceTab_Section7);
            if (marker != 0)
                *marker = 0;
            end = value + strlen(value) - 1;
            while (end > value &&
                   (WDISP_CharClassTable[(unsigned char)*end] & 8) != 0) {
                *end = 0;
                end--;
            }
            PARSEINI_LoadWeatherMessageStrings(line, value);
            break;

        case 8:
            value = STR_FindCharPtr(line, 61L);
            if (value == 0)
                continue;
            *value = 0;
            value++;
            while ((WDISP_CharClassTable[(unsigned char)*value] & 8) != 0)
                value++;
            marker = STR_FindAnyCharPtr(
                line, PARSEINI_DelimSpaceTab_Section8);
            if (marker != 0)
                *marker = 0;
            end = value + strlen(value) - 1;
            while (end > value &&
                   (WDISP_CharClassTable[(unsigned char)*end] & 8) != 0) {
                *end = 0;
                end--;
            }
            TEXTDISP_AddSourceConfigEntry(line, value);
            break;

        default:
            break;
        }
    }

    MEMORY_DeallocateMemory(Global_STR_PARSEINI_C_2, 403L, work,
                                          fileLen + 1);
}
