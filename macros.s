SetOffsetForStack macro
.numberOfStackValues = \1
.stackOffsetBytes = .numberOfStackValues*4
endm

SetOffsetForStackAfterLink macro
.numberOfLinkBytes = \1
.numberOfStackValues = \2
.stackOffsetBytes = .numberOfLinkBytes+4+(.numberOfStackValues*4)
endm

CopyStackValueIntoRegister macro
    MOVE.L  .stackOffsetBytes+(\1*4)(A7),\2
endm

CopyStackValueIntoAddressRegister macro
    MOVEA.L .stackOffsetBytes+(\1*4)(A7),\2
endm