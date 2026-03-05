typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern LONG NEWGRID_ModeSelectionTable[7];
extern LONG NEWGRID_ModeCycleCountdown;
extern LONG NEWGRID_ModeCandidateIndex;

extern UBYTE CONFIG_ModeCycleEnabledFlag;
extern LONG CONFIG_ModeCycleGateDuration;

extern BYTE CONFIG_NicheModeCycleBudget_Y;
extern BYTE CONFIG_NicheModeCycleBudget_Static;
extern BYTE CONFIG_NicheModeCycleBudget_Custom;

extern LONG GCOMMAND_NicheModeCycleCount;
extern LONG GCOMMAND_MplexModeCycleCount;
extern LONG GCOMMAND_PpvModeCycleCount;

extern BYTE NEWGRID_NicheModeCycleBudget_Y;
extern BYTE NEWGRID_NicheModeCycleBudget_Static;
extern BYTE NEWGRID_NicheModeCycleBudget_Custom;
extern BYTE NEWGRID_NicheModeCycleBudget_Global;
extern BYTE NEWGRID_MplexModeCycleBudget;
extern BYTE NEWGRID_PpvModeCycleBudget;

LONG NEWGRID_SelectNextMode(void)
{
    LONG mode_table[7];
    LONG d5;
    LONG d6;
    LONG d7;
    LONG i;

    d5 = 0;
    d6 = 0;
    d7 = 0;

    for (i = 0; i < 7; ++i) {
        mode_table[i] = NEWGRID_ModeSelectionTable[i];
    }

    if (CONFIG_ModeCycleEnabledFlag == 'Y') {
        LONG gate = CONFIG_ModeCycleGateDuration;

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
        if ((WORD)d5 != 0) {
            return d6;
        }

        {
            LONG idx = NEWGRID_ModeCandidateIndex;
            d6 = mode_table[idx];
            if (d6 == 12) {
                NEWGRID_ModeCandidateIndex = 0;
            } else {
                NEWGRID_ModeCandidateIndex = idx + 1;
            }
        }

        if (CONFIG_ModeCycleEnabledFlag == 'Y') {
            LONG key = d6 - 5;
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

            if ((WORD)d5 != 0) {
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
            LONG key = d6 - 5;
            d5 = 0;

            if (key < 0 || key >= 8) {
                continue;
            }

            switch (key) {
            case 0: {
                LONG d0 = GCOMMAND_NicheModeCycleCount;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Global -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Global <= 0) {
                        d5 = 1;
                    }
                }
                if ((WORD)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Global = (BYTE)d0;
                }
                break;
            }

            case 1: {
                BYTE d0 = CONFIG_NicheModeCycleBudget_Y;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Y -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Y <= 0) {
                        d5 = 1;
                    }
                }
                if ((WORD)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Y = d0;
                }
                break;
            }

            case 2: {
                BYTE d0 = CONFIG_NicheModeCycleBudget_Static;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Static -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Static <= 0) {
                        d5 = 1;
                    }
                }
                if ((WORD)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Static = d0;
                }
                break;
            }

            case 3: {
                BYTE d0 = CONFIG_NicheModeCycleBudget_Custom;
                if (d0 > 0) {
                    NEWGRID_NicheModeCycleBudget_Custom -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Custom <= 0) {
                        d5 = 1;
                    }
                }
                if ((WORD)d5 != 0) {
                    NEWGRID_NicheModeCycleBudget_Custom = d0;
                }
                break;
            }

            case 4: {
                LONG d0 = GCOMMAND_MplexModeCycleCount;
                if (d0 > 0) {
                    NEWGRID_MplexModeCycleBudget -= 1;
                    if (NEWGRID_MplexModeCycleBudget <= 0) {
                        d5 = 1;
                    }
                }
                if ((WORD)d5 != 0) {
                    NEWGRID_MplexModeCycleBudget = (BYTE)d0;
                }
                break;
            }

            case 5: {
                LONG d0 = GCOMMAND_PpvModeCycleCount;
                if (d0 > 0) {
                    NEWGRID_PpvModeCycleBudget -= 1;
                    if (NEWGRID_PpvModeCycleBudget <= 0) {
                        d5 = 1;
                    }
                }
                if ((WORD)d5 != 0) {
                    NEWGRID_PpvModeCycleBudget = (BYTE)d0;
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
