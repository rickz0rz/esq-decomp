; Useful memory constants.
; Hoisted out of modules/submodules/memory.s: these are plain equates that were
; only visible program-wide because everything was one assembly unit.
MEMF_ANY       = 0
MEMF_PUBLIC    = 1
MEMF_CHIP      = 2
MEMF_FAST      = 4
MEMF_LOCAL     = 256
MEMF_24BITDMA  = 512
MEMF_KICK      = 1024
MEMF_CLEAR     = 65536
MEMF_LARGEST   = 131072
MEMF_REVERSE   = 262144
MEMF_TOTAL     = 524288
