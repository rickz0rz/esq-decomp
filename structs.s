; This is wild. So 276(A6) is apparently a pointer to ThisTask (see: http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node0551.html
; and http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node009E.html) ... so the pointer to ThisTask gets pushed into A3, and then
; offset 152 on ThisTask ( http://amigadev.elowar.com/read/ADCD_2.1/Libraries_Manual_guide/node02BB.html ) points to _some_ field... is it the stack pointer
; or something? Need to work on this...

Struct_ExecBase__ThisTask       = 276
Struct_ExecBase__TaskWait       = 420
Struct_ExecBase__SoftInts       = 434

Struct_IORequest__io_Message    = 0
Struct_IORequest__io_Command    = 28

Struct_IOStdReq__io_Message     = Struct_IORequest__io_Message
Struct_IOStdReq__io_Command     = Struct_IORequest__io_Command
Struct_IOStdReq__io_Data        = 40

Struct__Message__mn_Node        = 0
Struct__Message__mn_ReplyPort   = 14

Struct_MsgPort__mp_Node         = 0
Struct_MsgPort__mp_Flags        = 14
Struct_MsgPort__mp_SigBit       = 15
Struct_MsgPort__mp_SigTask      = 16

Struct_Node__ln_Succ            = 0
Struct_Node__ln_Pred            = 4
Struct_Node__ln_Type            = 8
Struct_Node__ln_Pri             = 9
Struct_Node__ln_Name            = 10

; Node types
; http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node062F.html
NT_MSGPORT      = 4
NT_MESSAGE      = 5