/* RESTORES: _NEWGRID_SelectNextMode
 * MODULE:   modules/groups/b/a/newgrid_p1_newgrid_selectnextmode.s
 * STATUS:   behavioural
 *
 * Pick the next display mode to cycle to, or 12 for "stay put". Walks a
 * seven-entry mode table, and for each candidate asks whether that mode has any
 * content worth showing; the first that does wins. Returns the mode.
 *
 * TWO DIFFERENT DISPATCHES ON THE SAME MODES, selected by the same config flag
 * that was already tested at the top:
 *
 *   flag == 'Y'  each case merely TESTS whether a count is non-zero, so cycling
 *                is advisory and the caller keeps its position
 *   otherwise    each case DECREMENTS a per-mode budget and only accepts the
 *                mode when the budget runs out, then RELOADS the budget from
 *                config -- a round-robin with per-mode dwell times
 *
 * ('Y' is 89, and the original writes it both ways -- `MOVEQ #'Y'` at the top and
 * `MOVEQ #89` at the dispatch. Same value, same flag, tested twice.)
 *
 * The table is copied to a local before use, via MOVE.L/DBF over seven longs.
 * That is struct assignment, not memcpy -- AGENTS.md: "dst = *src (struct)"
 * emits the long copy, memcpy of the same bytes emits a MOVE.B loop. Hence the
 * struct wrapper, since C cannot assign a bare array.
 *
 * WHY IT COPIES AT ALL is worth noting: nothing here writes to the local copy.
 * The copy is dead work that the original does anyway, so it is reproduced.
 *
 * The 'Y' arm also has a wrap guard the other arm lacks: after each candidate it
 * checks whether the index has come back round to where it started and gives up
 * with mode 12 if so. That is the only use of the saved start index, and it is
 * only set on the path where the countdown expired.
 *
 * Budget decrements are BYTE-wide (SUBQ.B) while three of the six config sources
 * are longs, so the reload truncates a long to a byte. That is the original's
 * behaviour, not a transcription slip.
 *
 * SASC-MISMATCH: dual-jumptable-layout
 *   summary: 724 against 632 -- +92, the WORST ratio in the tranche at 14.6%, and
 *            it is not attributed. Two jump tables over the same selector plus
 *            fourteen small case bodies give casm.py nothing stable to align on.
 *            Recorded as a known-unknown per AGENTS.md rule 3.
 *   tried:   - SHORTINT makes it WORSE (728 with, 724 without), which is unusual
 *              for a function whose selector is a long; noted rather than
 *              explained.
 *            - The group-2 arms were rewritten from `done = (a && b)` to explicit
 *              `if (...) done = 1; else done = 0;` because the original branches
 *              to MOVEQ #1 / MOVEQ #0 there rather than using the SNE/NEG.B
 *              booleanize it uses in group 1. That is the right shape on the
 *              evidence and it changed the byte count by ZERO -- so the idiom was
 *              not the cost. The if/else form was KEPT anyway, being the one the
 *              original's own instructions show.
 *   scope:   this function. The pattern to watch is two switches on one selector.
 *   retest:  a compiler that reserves A5, then re-measure; do not theorise about
 *            the case layout until the streams align.
 */

struct ModeTable { long m[7]; };

extern struct ModeTable NEWGRID_ModeSelectionTable;
extern unsigned char CONFIG_ModeCycleEnabledFlag;
extern long          CONFIG_ModeCycleGateDuration;
extern long          NEWGRID_ModeCycleCountdown;
extern long          NEWGRID_ModeCandidateIndex;

extern unsigned char CONFIG_NicheModeCycleBudget_Y;
extern unsigned char CONFIG_NicheModeCycleBudget_Static;
extern unsigned char CONFIG_NicheModeCycleBudget_Custom;
extern long          GCOMMAND_NicheModeCycleCount;
extern long          GCOMMAND_MplexModeCycleCount;
extern long          GCOMMAND_PpvModeCycleCount;

extern unsigned char NEWGRID_NicheModeCycleBudget_Y;
extern unsigned char NEWGRID_NicheModeCycleBudget_Static;
extern unsigned char NEWGRID_NicheModeCycleBudget_Custom;
extern unsigned char NEWGRID_NicheModeCycleBudget_Global;
extern unsigned char NEWGRID_MplexModeCycleBudget;
extern unsigned char NEWGRID_PpvModeCycleBudget;

long NEWGRID_SelectNextMode(void)
{
    struct ModeTable table;
    long done = 0;
    long mode = 0;
    long startIndex = 0;
    long budgetL;
    unsigned char budgetB;

    table = NEWGRID_ModeSelectionTable;

    if (CONFIG_ModeCycleEnabledFlag == 'Y') {
        if (CONFIG_ModeCycleGateDuration <= 0) {
            mode = 12;
            done = 1;
        } else if (NEWGRID_ModeCycleCountdown > 0) {
            NEWGRID_ModeCycleCountdown--;
            mode = 12;
            done = 1;
        } else {
            startIndex = NEWGRID_ModeCandidateIndex;
            NEWGRID_ModeCycleCountdown = CONFIG_ModeCycleGateDuration;
        }
    }

    while (!done) {
        mode = table.m[NEWGRID_ModeCandidateIndex];
        if (mode == 12)
            NEWGRID_ModeCandidateIndex = 0;
        else
            NEWGRID_ModeCandidateIndex++;

        if (CONFIG_ModeCycleEnabledFlag == 'Y') {
            switch (mode - 5) {
            case 0: done = (GCOMMAND_NicheModeCycleCount != 0);        break;
            case 1: done = (CONFIG_NicheModeCycleBudget_Y != 0);       break;
            case 2: done = (CONFIG_NicheModeCycleBudget_Static != 0);  break;
            case 3: done = (CONFIG_NicheModeCycleBudget_Custom != 0);  break;
            case 4: done = (GCOMMAND_MplexModeCycleCount != 0);        break;
            case 5: done = (GCOMMAND_PpvModeCycleCount != 0);          break;
            }
            if (!done && NEWGRID_ModeCandidateIndex == startIndex) {
                mode = 12;
                done = 1;
            }
        } else {
            switch (mode - 5) {
            case 0:
                budgetL = GCOMMAND_NicheModeCycleCount;
                if (budgetL > 0 && --NEWGRID_NicheModeCycleBudget_Global <= 0)
                    done = 1;
                else
                    done = 0;
                if (done)
                    NEWGRID_NicheModeCycleBudget_Global = budgetL;
                break;
            case 1:
                budgetB = CONFIG_NicheModeCycleBudget_Y;
                if (budgetB > 0 && --NEWGRID_NicheModeCycleBudget_Y <= 0)
                    done = 1;
                else
                    done = 0;
                if (done)
                    NEWGRID_NicheModeCycleBudget_Y = budgetB;
                break;
            case 2:
                budgetB = CONFIG_NicheModeCycleBudget_Static;
                if (budgetB > 0 && --NEWGRID_NicheModeCycleBudget_Static <= 0)
                    done = 1;
                else
                    done = 0;
                if (done)
                    NEWGRID_NicheModeCycleBudget_Static = budgetB;
                break;
            case 3:
                budgetB = CONFIG_NicheModeCycleBudget_Custom;
                if (budgetB > 0 && --NEWGRID_NicheModeCycleBudget_Custom <= 0)
                    done = 1;
                else
                    done = 0;
                if (done)
                    NEWGRID_NicheModeCycleBudget_Custom = budgetB;
                break;
            case 4:
                budgetL = GCOMMAND_MplexModeCycleCount;
                if (budgetL > 0 && --NEWGRID_MplexModeCycleBudget <= 0)
                    done = 1;
                else
                    done = 0;
                if (done)
                    NEWGRID_MplexModeCycleBudget = budgetL;
                break;
            case 5:
                budgetL = GCOMMAND_PpvModeCycleCount;
                if (budgetL > 0 && --NEWGRID_PpvModeCycleBudget <= 0)
                    done = 1;
                else
                    done = 0;
                if (done)
                    NEWGRID_PpvModeCycleBudget = budgetL;
                break;
            case 7:
                done = 1;
                break;
            }
        }
    }

    return mode;
}
