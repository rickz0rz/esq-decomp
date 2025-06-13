SetOffsetForStack macro
.numberOfStackValues = \1
.stackOffsetBytes = .numberOfStackValues*4
endm

SetOffsetForStackAfterLink macro
.numberOfLinkBytes = \1
.numberOfStackValues = \2
.stackOffsetBytes = .numberOfLinkBytes+4+(.numberOfStackValues*4)
endm

UseStackWord macro
    \1  .stackOffsetBytes+(\2*2)(A7),\3
endm

UseStackLong macro
    \1  .stackOffsetBytes+(\2*4)(A7),\3
endm

UseLinkStackLong macro
    \1 ((\2+1)*4)(A5),\3
endm

EmitStackAddress macro
.stackLong\1    = .stackOffsetBytes+(\1*4)
endm