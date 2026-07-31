/* RESTORES: PARSEINI_LoadWeatherMessageStrings
 * MODULE:   modules/groups/b/a/parseini_p1.s
 * STATUS:   behavioural
 *
 * Matches an .ini key against the three weather message tags and installs the
 * value into the matching global.
 *
 * NOT to be confused with parseini_load_weather_strings.c, which restores
 * PARSEINI_LoadWeatherStrings -- a different function in the same area. This
 * one takes a key and a value and does three case-folded compares; that one
 * loads a fixed set.
 *
 * Each compare is against a literal tag and the match is the ZERO result. The
 * chain is exclusive -- every arm branches to the common exit rather than
 * falling into the next compare -- so a key can only install one message.
 *
 * ReplaceOwnedString takes the NEW string first and the old second, and its
 * result goes back into the same global, which is the ordinary swap-and-free
 * idiom this program uses everywhere.
 *
 * 136 ref vs 136 got. All three tag addresses, all three compares, all three
 * ADDQ.W #8,A7 cleanups, all three global stores and both exit branch
 * displacements (604e / 6026) match exactly.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba0772 4eba07f6 4eba074a 4eba07ce 4eba0722 4eba07a6
 *   got:     61000000 x6
 *   summary: same size, same displacement, same semantics, different opcode.
 *            With six calls and nothing else structural, this function is
 *            close to a clean isolation of the class.
 *   scope:   every cross-unit restoration; the count is in AGENTS.md. docs/compiler-version.md, "Call encoding depends
 *            on the callee translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 *
 * SASC-MISMATCH: store-before-stack-cleanup
 *   ref:     504f 23c0....      ADDQ.W #8,A7 / MOVE.L D0,global
 *   got:     23c0.... 504f      the store first
 *   summary: the original pops the argument frame and then stores the result;
 *            6.51 stores first. Same two instructions, reordered, at all three
 *            sites.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long  PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(char *newStr, char *old);

extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;
extern char  PARSEINI_STR_WEATHERCURRENT[];
extern char  PARSEINI_STR_WEATHERFORECAST[];
extern char  PARSEINI_STR_BOTTOMLINETAG[];

void PARSEINI_LoadWeatherMessageStrings(char *key, char *value)
{
    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_WEATHERCURRENT) == 0)
        P_TYPE_WeatherCurrentMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(value,
                                                       P_TYPE_WeatherCurrentMsgPtr);

    else if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_WEATHERFORECAST) == 0)
        P_TYPE_WeatherForecastMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(value,
                                                       P_TYPE_WeatherForecastMsgPtr);

    else if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_BOTTOMLINETAG) == 0)
        P_TYPE_WeatherBottomLineMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(value,
                                                       P_TYPE_WeatherBottomLineMsgPtr);
}
