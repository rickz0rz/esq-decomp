#include "esq_types.h"

extern s32 NEWGRID_ModeSelectionTable[7];
extern s32 NEWGRID_ModeCycleCountdown;
extern s32 NEWGRID_ModeCandidateIndex;

extern u8 CONFIG_ModeCycleEnabledFlag;
extern s32 CONFIG_ModeCycleGateDuration;

extern s8 CONFIG_NicheModeCycleBudget_Y;
extern s8 CONFIG_NicheModeCycleBudget_Static;
extern s8 CONFIG_NicheModeCycleBudget_Custom;

extern s32 GCOMMAND_NicheModeCycleCount;
extern s32 GCOMMAND_MplexModeCycleCount;
extern s32 GCOMMAND_PpvModeCycleCount;

extern s8 NEWGRID_NicheModeCycleBudget_Y;
extern s8 NEWGRID_NicheModeCycleBudget_Static;
extern s8 NEWGRID_NicheModeCycleBudget_Custom;
extern s8 NEWGRID_NicheModeCycleBudget_Global;
extern s8 NEWGRID_MplexModeCycleBudget;
extern s8 NEWGRID_PpvModeCycleBudget;

s32 NEWGRID_SelectNextMode(void) __attribute__((noinline, used));

s32 NEWGRID_SelectNextMode(void)
{
    s32 mode_table[7];
    s32 d5 = 0;
    s32 d6 = 0;
    s32 d7 = 0;
    s32 i;

    for (i = 0; i < 7; ++i) {
        mode_table[i] = NEWGRID_ModeSelectionTable[i];
    }

    if (CONFIG_ModeCycleEnabledFlag == 'Y') {
        s32 gate = CONFIG_ModeCycleGateDuration;

        if (gate <= 0) {
            d6 = 12;
            d5 = 1;
        } else if (NEWGRID_ModeCycleCountdown > 0) {
            NEWGRID_ModeCycleCountdown -= 1;
            d6 = 12;
            d5 = 1;
        } else {
            d7 = NEWGRID_ModeCandidateIndex;
            NEWGRID_ModeCycleCountdown = gate;
        }
    }

    for (;;) {
        if ((s16)d5 != 0) {
            return d6;
        }

        {
            s32 idx = NEWGRID_ModeCandidateIndex;
            d6 = mode_table[idx];
            if (d6 == 12) {
                NEWGRID_ModeCandidateIndex = 0;
            } else {
                NEWGRID_ModeCandidateIndex = idx + 1;
            }
        }

        if (CONFIG_ModeCycleEnabledFlag == 'Y') {
            s32 key = d6 - 5;
            d5 = 0;

            if (key >= 0 && key < 8) {
                switch (key) {
                case 0:
                    d5 = (GCOMMAND_NicheModeCycleCount != 0) ? -1 : 0;
                    break;
                case 1:
                    d5 = (CONFIG_NicheModeCycleBudget_Y != 0) ? -1 : 0;
                    break;
                case 2:
                    d5 = (CONFIG_NicheModeCycleBudget_Static != 0) ? -1 : 0;
                    break;
                case 3:
                    d5 = (CONFIG_NicheModeCycleBudget_Custom != 0) ? -1 : 0;
                    break;
                case 4:
                    d5 = (GCOMMAND_MplexModeCycleCount != 0) ? -1 : 0;
                    break;
                case 5:
                    d5 = (GCOMMAND_PpvModeCycleCount != 0) ? -1 : 0;
                    break;
                default:
                    break;
                }
            }

            if ((s16)d5 != 0) {
                continue;
            }

            if (NEWGRID_ModeCandidateIndex != d7) {
                continue;
            }

            d6 = 12;
            d5 = 1;
            continue;
        }

        {
            s32 key = d6 - 5;
            d5 = 0;

            if (key < 0 || key >= 8) {
                continue;
            }

            switch (key) {
            case 0: {
                s32 d0 = GCOMMAND_NicheModeCycleCount;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Global -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Global <= 0) {
                        d5 = 1;
                    }
                }
                if ((s16)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Global = (s8)d0;
                }
                break;
            }

            case 1: {
                s8 d0 = CONFIG_NicheModeCycleBudget_Y;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Y -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Y <= 0) {
                        d5 = 1;
                    }
                }
                if ((s16)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Y = d0;
                }
                break;
            }

            case 2: {
                s8 d0 = CONFIG_NicheModeCycleBudget_Static;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Static -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Static <= 0) {
                        d5 = 1;
                    }
                }
                if ((s16)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Static = d0;
                }
                break;
            }

            case 3: {
                s8 d0 = CONFIG_NicheModeCycleBudget_Custom;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Custom -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Custom <= 0) {
                        d5 = 1;
                    }
                }
                if ((s16)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Custom = d0;
                }
                break;
            }

            case 4: {
                s32 d0 = GCOMMAND_MplexModeCycleCount;
                if (d0 > 0) {
                    NEWGRID_MplexModeCycleBudget -= 1;
                    if (NEWGRID_MplexModeCycleBudget <= 0) {
                        d5 = 1;
                    }
                }
                if ((s16)d5 != 0) {
                    NEWGRID_MplexModeCycleBudget = (s8)d0;
                }
                break;
            }

            case 5: {
                s32 d0 = GCOMMAND_PpvModeCycleCount;
                if (d0 > 0) {
                    NEWGRID_PpvModeCycleBudget -= 1;
                    if (NEWGRID_PpvModeCycleBudget <= 0) {
                        d5 = 1;
                    }
                }
                if ((s16)d5 != 0) {
                    NEWGRID_PpvModeCycleBudget = (s8)d0;
                }
                break;
            }

            case 7:
                d5 = 1;
                break;

            default:
                break;
            }
        }
    }
}
