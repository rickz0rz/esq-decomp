/* RESTORES: _P_TYPE_LoadPromoIdDataFile
 * MODULE:   modules/groups/b/a/p_typebb_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-cursor
 *   ref:     4e55ffcc48e70f00487900006d9c4eba177c584f5280670001b62b7900008004fffc2e390000800042adffd041f900006dac43edffd912d866fc7002b0adffd067000170486dffd92f2dfffc4eba018a504f2b40fff84a806700012841edffd922484a1966fc538993c82009d1adfff8206dfff81010488048c043f900007c11d3c008110003670652adfff860e22f2dfff84eba371e584f2c001039000087bab0066604780060101039000087b6bc0066047801600278027002b880670000c4206dfff81010488048c043f900007c11d3c008110002670652adfff860e2206dfff81010488048c043f900007c11d3c008110003670652adfff860e22f2dfff84eba36b0584f42adfff02b40ffcc6f4e487900006db42f2dfff84eba00bc504f2b40fff867387007d1adfff8206dfff8202dffcc1a30080042300800720012062f082f002f016100fa584fef000c206dfff8222dffcc118518002b40fff02004e58041f90000b4e0d1c02f106100fb0a584f2004e58041f90000b4e0d1c020adfff0202dffd04a8067065380671a601870012b40ffd041f900006dc443edffd912d866fc6000fe9470022b40ffd06000fe8a200752802f002f2dfffc48780196487900006dcc4eba1c2a4fef001070014cdf00f04e5d4e75
 *   got:     9efc003048e7073448790000000061000000584f5280660670016000018a2a79000000002a39000000007e0041f90000000043ef001912d866fc200755806700014a486f00192f0d6100000026404a80504f6700011041ef001922484a1966fc538993c82009d7c01013488041f900000000d0c0081000036704528b60ea2f0b61000000584f72001239000000002f400044b280660642af0040601a7200123900000000b081660870012f400040600670022f4000407002b0af0040670000a61013488041f900000000d0c0081000026704528b60ea1013488041f900000000d0c0081000036704528b60ea2f0b610000002c00584f95ca4a866f3e4879000000002f0b6100000026404a80504f672a5e8b1f736800001842336800202f0044720012002f0b2f062f016100000024404fef000c17af00186800202f00402200e58141f900000000d1c12f1061000000584f202f00402200e58141f900000000d1c1208a20074a8067065380671660147e0141f90000000043ef001912d866fc6000feb87e026000feb2200552802f002f0d48780196487900000000610000004fef001070014cdf2ce0defc00304e75
 *   summary: 432 got vs 472 ref, forty bytes short. The original keeps the parse cursor in an A5 frame slot and rebuilds MOVEA.L -8(A5),A0 before every character-class probe and every advance -- twelve sites at four to six bytes each; 6.51 holds it in an address register across each scan. The load-failure early return, both section keys, the substring search, the three character-class scans on bits 3 and 2, the group-code match that picks slot 0, 1 or 2, the temporary NUL around the type list with its restore, the free-then-store of the group entry and the closing work-buffer release all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern unsigned char WDISP_CharClassTable[];
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern char *P_TYPE_PrimaryGroupListPtr[];
extern char P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load[];
extern char P_TYPE_STR_CURDAY_COLON_LoadSection[];
extern char P_TYPE_STR_NXTDAY_COLON_LoadSection[];
extern char P_TYPE_STR_TYPES_COLON[];
extern char Global_STR_P_TYPE_C_6[];

extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern char *STRING_FindSubstring(char *hay, char *needle);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern char *P_TYPE_AllocateEntry(long code, long count, char *text);
extern void  P_TYPE_FreeEntry(char *entry);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                   char *ptr, long size);

long P_TYPE_LoadPromoIdDataFile(void)
{
    char  key[39];
    char *buf;
    char *cur;
    char *entry;
    long  section;
    long  count;
    long  size;
    long  code;
    long  slot;
    char  saved;

    if (DISKIO_LoadFileToWorkBuffer(
            P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load) == -1)
        return 1;

    buf = Global_PTR_WORK_BUFFER;
    size = Global_REF_LONG_FILE_SCRATCH;
    section = 0;
    strcpy(key, P_TYPE_STR_CURDAY_COLON_LoadSection);

    while (section != 2) {
        cur = STRING_FindSubstring(buf, key);
        if (cur != 0) {
            cur += strlen(key);
            while (WDISP_CharClassTable[*cur] & 8)
                cur++;

            code = PARSE_ReadSignedLongSkipClass3_Alt(cur);
            if (TEXTDISP_PrimaryGroupCode == code)
                slot = 0;
            else if (code == TEXTDISP_SecondaryGroupCode)
                slot = 1;
            else
                slot = 2;

            if (slot != 2) {
                while (WDISP_CharClassTable[*cur] & 4)
                    cur++;
                while (WDISP_CharClassTable[*cur] & 8)
                    cur++;

                count = PARSE_ReadSignedLongSkipClass3_Alt(cur);
                entry = 0;
                if (count > 0) {
                    cur = STRING_FindSubstring(cur,
                              P_TYPE_STR_TYPES_COLON);
                    if (cur != 0) {
                        cur += 7;
                        saved = cur[count];
                        cur[count] = 0;
                        entry = P_TYPE_AllocateEntry((long)(unsigned char)code,
                                                     count, cur);
                        cur[count] = saved;
                    }
                }
                P_TYPE_FreeEntry(P_TYPE_PrimaryGroupListPtr[slot]);
                P_TYPE_PrimaryGroupListPtr[slot] = entry;
            }
        }

        switch (section) {
        case 0:
            section = 1;
            strcpy(key, P_TYPE_STR_NXTDAY_COLON_LoadSection);
            break;
        case 1:
        default:
            section = 2;
            break;
        }
    }

    MEMORY_DeallocateMemory(Global_STR_P_TYPE_C_6, 406, buf,
                                          size + 1);
    return 1;
}
