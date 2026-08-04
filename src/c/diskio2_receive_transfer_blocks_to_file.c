/* RESTORES: _DISKIO2_ReceiveTransferBlocksToFile
 * MODULE:   modules/groups/a/h/diskio2_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-xor
 *   ref:     4e55fbf048e73f001e2d000b70ff2b40fff642adfff2422dfff041f9000012a643edfbf0303c00ff22d851c8fffc4eba03ae4eba03c8280030390000a334524033c00000a334103900008052b800660001c6123900008051b10113c1000080514eba037c4eba039613c0000080504a0067000152123900008051b10113c1000080513a39000080587c00200648c07200123900008050b081674c4eba03424eba035c2800103900008051b90013c00000805170001004222dfff6b38074004602c082e58041edfbf0d1c0e0892010b38022055245207900008054d0c110842b40fff6524660a44a07675042adfff27c007004bc406c344eba02e64eba0300123900008051b10113c100008051222dfff2e1817400140076004603c48382821b40fff12b41fff2524660c6202dfff6b0adfff2670670011b40fff04a2dfff066784eba029c4eba02b613c00000a07e123900008051b001660000ba33c5000080580c4510006d28200533c00000805848c02f002f39000080544ebacd72504f528066067002600000c64279000080581039000080522200520113c1000080527000100172004601c08113c000008052700023c00000805c605a422dfff052b90000805c604e4eba02184eba023213c00000a07e123900008051b001662a3039000080586f1e48c02f002f39000080544ebaccfc504f528066047003605042790000805870ff60461b7c0001fff052b90000805c7000603670001004528072004601c0817200123900008052b08166047000601a41f90000801c43f900007dbb12d866fc487800014eba01a270014ced00fcfbd84e5d4e75
 *   got:     9efc040c48e73f001e2f042b7cff7a00780041f90000000043ef0024303c00ff22d851c8fffc6100000061000000323900000000524133c1000000002f40001c488048c07200123900000000b081673e202f001c74001400528270004600c48070001001b480660670006000020e41f90000000043f90000000012d866fc4878000161000000584f7001600001ee103900000000123900000000b30013c000000000610000006100000013c000000000720012006664610000006100000013c000000000488048c07200123900000000b081670e780152b90000000070006000019a30390000000048c06f2830390000000048c02f002f390000000061000000504f52806606700360000170700033c00000000070ff60000162103900000000123900000000b30013c0000000003f7900000000001a426f0018302f001848c07200123900000000b081675061000000610000007200123900000000b18113c10000000072001200bd8174004602c2822401e5822206e08926372824b3832c03207900000000322f001ad0c11080526f001a526f00182f40001c609e4a07674a7a00426f00180c6f000400186c3661000000610000007200123900000000b18113c1000000002205e181240076004603c48382822a01526f00181f4000202f40001c60c2bc85670278014a04670e780052b900000000700060000080610000006100000013c000000000488048c07200123900000000b08167047000605c302f001a33c0000000000c4010006d2433c00000000048c02f002f390000000061000000504f528066047002602e4279000000001039000000001200520113c1000000007000100172004601c08113c00000000042b90000000070004cdf00fcdefc040c4e75
 *   summary: 644 got vs 598 ref. The original keeps the running XOR checksum in D0 or D1 across the read-and-fold pair; 6.51 reloads the global on both sides of each of the six XOR updates, six bytes a site. The 1024-byte CRC table is copied through a struct assignment, which is what produces the original's MOVE.L (A0)+,(A1)+ / DBF. The sequence check with its off-by-one resend tolerance, the zero-length end-of-file block with its tail flush, the payload loop with its per-byte CRC32 fold, the optional four-byte CRC read and compare, the record checksum verification, the 4096-byte flush threshold and all six distinct return codes match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct Crc32Table { unsigned long w[256]; };

extern struct Crc32Table DISKIO2_TransferCrc32Table;
extern short ESQIFF_ParseAttemptCount;
extern unsigned char DISKIO2_TransferBlockSequence;
extern unsigned char DISKIO2_TransferXorChecksumByte;
extern unsigned char DISKIO2_TransferBlockLength;
extern short DISKIO2_TransferBufferedByteCount;
extern char *DISKIO2_TransferBlockBufferPtr;
extern long  DISKIO2_TransferCrcErrorCount;
extern unsigned char ESQIFF_RecordChecksumByte;
extern char  DISKIO2_TransferFilenameBuffer[];
extern char  BRUSH_SnapshotHeader[];

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern long SCRIPT_ReadNextRbfByte(void);
extern long DISKIO_WriteBytesToOutputHandleGuarded(char *buf, long n);
extern void ESQIFF2_ShowAttentionOverlay(long mode);

long DISKIO2_ReceiveTransferBlocksToFile(char withCrc)
{
    struct Crc32Table table;
    unsigned long crc;
    unsigned long received;
    char  crcError;
    char  lastByte;
    long  byte;
    short count;
    short i;

    crc = -1;
    received = 0;
    crcError = 0;
    table = DISKIO2_TransferCrc32Table;

    ESQFUNC_WaitForClockChangeAndServiceUi();
    byte = SCRIPT_ReadNextRbfByte();
    ESQIFF_ParseAttemptCount++;

    if ((char)byte != DISKIO2_TransferBlockSequence) {
        if ((((long)(unsigned char)byte + 1) & 0xff)
            == (long)DISKIO2_TransferBlockSequence)
            return 0;
        strcpy(BRUSH_SnapshotHeader, DISKIO2_TransferFilenameBuffer);
        ESQIFF2_ShowAttentionOverlay(1);
        return 1;
    }

    DISKIO2_TransferXorChecksumByte =
        DISKIO2_TransferXorChecksumByte ^ DISKIO2_TransferBlockSequence;

    ESQFUNC_WaitForClockChangeAndServiceUi();
    DISKIO2_TransferBlockLength = SCRIPT_ReadNextRbfByte();

    if (DISKIO2_TransferBlockLength == 0) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = SCRIPT_ReadNextRbfByte();
        if ((char)ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte) {
            crcError = 1;
            DISKIO2_TransferCrcErrorCount++;
            return 0;
        }
        if (DISKIO2_TransferBufferedByteCount > 0) {
            if (DISKIO_WriteBytesToOutputHandleGuarded(
                    DISKIO2_TransferBlockBufferPtr,
                    (long)DISKIO2_TransferBufferedByteCount) == -1)
                return 3;
            DISKIO2_TransferBufferedByteCount = 0;
        }
        return -1;
    }

    DISKIO2_TransferXorChecksumByte =
        DISKIO2_TransferXorChecksumByte ^ DISKIO2_TransferBlockLength;

    count = DISKIO2_TransferBufferedByteCount;

    i = 0;
    while ((long)i != (long)DISKIO2_TransferBlockLength) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        byte = SCRIPT_ReadNextRbfByte();
        DISKIO2_TransferXorChecksumByte =
            DISKIO2_TransferXorChecksumByte ^ byte;

        crc = table.w[((unsigned long)(unsigned char)byte ^ crc) & 0xff]
              ^ (crc >> 8);
        DISKIO2_TransferBlockBufferPtr[count] = byte;
        count++;
        i++;
    }

    if (withCrc != 0) {
        received = 0;
        i = 0;
        while (i < 4) {
            ESQFUNC_WaitForClockChangeAndServiceUi();
            byte = SCRIPT_ReadNextRbfByte();
            DISKIO2_TransferXorChecksumByte =
                DISKIO2_TransferXorChecksumByte ^ byte;
            received = (received << 8) | ((unsigned long)byte & 0xff);
            lastByte = byte;
            i++;
        }
        if (crc != received)
            crcError = 1;
    }

    if (crcError != 0) {
        crcError = 0;
        DISKIO2_TransferCrcErrorCount++;
        return 0;
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = SCRIPT_ReadNextRbfByte();
    if ((char)ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte)
        return 0;

    DISKIO2_TransferBufferedByteCount = count;
    if (count >= 0x1000) {
        DISKIO2_TransferBufferedByteCount = count;
        if (DISKIO_WriteBytesToOutputHandleGuarded(
                DISKIO2_TransferBlockBufferPtr, (long)count) == -1)
            return 2;
        DISKIO2_TransferBufferedByteCount = 0;
    }

    DISKIO2_TransferBlockSequence = DISKIO2_TransferBlockSequence + 1;
    DISKIO2_TransferBlockSequence =
        (unsigned char)DISKIO2_TransferBlockSequence & 0xff;
    DISKIO2_TransferCrcErrorCount = 0;
    return 0;
}
