#!/bin/bash
UUID=$(uuidgen)
FILENAME="ESQ-3-$UUID.bin"

~/Downloads/vasm/vasmm68k_mot -Fhunkexe -o "$FILENAME" -nosym ESQ-3-Test.asm
shasum -a 256 "$FILENAME"
echo "0e4aa277e991e3d125cc23277bbb002569ba74bf8d8c42b9f532b2c272b68df9 [Should be this]"
rm "$FILENAME"