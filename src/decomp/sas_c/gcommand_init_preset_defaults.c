extern unsigned short GCOMMAND_DefaultPresetTable[];
extern void GCOMMAND_InitPresetTableFromPalette(unsigned short *table);

void GCOMMAND_InitPresetDefaults(void)
{
    GCOMMAND_InitPresetTableFromPalette(GCOMMAND_DefaultPresetTable);
}
