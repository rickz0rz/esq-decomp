#!/bin/bash
UUID=$(uuidgen)
FILENAME="ESQ-3-$UUID.bin"

~/Downloads/vasm/vasmm68k_mot -Fhunkexe -o "$FILENAME" -nosym ESQ-3-Test.asm
shasum -a 256 "$FILENAME"
echo "b3a0226ed193ae099230758f1a9e7031dc3ab74143d02101bad0276f422e38ec [Should be this]"
rm "$FILENAME"
