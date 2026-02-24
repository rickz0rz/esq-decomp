# File-Format Example Fixtures

These fixtures are parser-oriented examples for tooling/tests.

- `config-dat-sample.txt`: escaped 52-byte `config.dat` record with one raw copper payload byte.
- `locavail-dat-sample.txt`: escaped NUL-token stream sample for `LocAvail.dat`.

Notes:
- These are **escaped representations** for readability.
- They are not raw binary files; convert escapes (`\0`, `\xNN`) before feeding to strict binary parsers.
