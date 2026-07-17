/* Phase-3 whole-program entry. SAS/C startup (c.o) calls main(); we set up the
   exec base and invoke the RESTORED original startup (ESQ_StartupEntry), which
   opens dos.library into Global_DosLibrary, handles WB/CLI startup, and runs the
   program. AbsExecBase lives at absolute address 4 on the Amiga. */
extern void *AbsExecBase;
extern long ESQ_StartupEntry(void *startupCmdString, long startupCmdLength);

int main(void)
{
    AbsExecBase = *(void **)4;
    return (int)ESQ_StartupEntry((void *)0, 0);
}
