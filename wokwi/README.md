# Wokwi package for Gen1 Digital Companion Tile

This directory contains a Wokwi simulation package for the Tiny Tapeout tile in
`../src/project.v`.

Files:

- `diagram.json`: Wokwi diagram using the Tiny Tapeout input/output blocks.
- `gen1-companion.chip.json`: pinout for the custom Wokwi chip.
- `gen1-companion.chip.c`: functional simulation model mirroring `src/project.v`.
- `wokwi.toml`: Wokwi CLI/VS Code custom-chip configuration.

Important boundary:

- Fabrication RTL: `../src/project.v`.
- Wokwi functional simulation model: `gen1-companion.chip.c`.

The Wokwi model is useful for testing the command/status interface visually. It
is not the source that should be synthesized for Tiny Tapeout. For the actual
chip submission, use the Verilog Tiny Tapeout repository path with `info.yaml`,
`src/project.v`, `test/`, `docs/`, and the official `gds`/`docs` actions.

## Input mapping

`ui_in[7:6]` is the command field and `ui_in[5:0]` is command data.

Commands:

- `00xxxxxx`: NOP.
- `01vvvvvv`: LOAD_TARGET.
- `10vvvvvv`: LOAD_CURRENT.
- `11mmmm01`: START, where `m = ui_in[5:2]`.
- `11xxxx10`: CLEAR, including while busy.

## Output mapping

Dedicated outputs:

- `uo_out[7]`: ready.
- `uo_out[6]`: busy.
- `uo_out[5]`: done.
- `uo_out[4]`: fault.
- `uo_out[3]`: pulse_up.
- `uo_out[2]`: pulse_down.
- `uo_out[1]`: verify_ok.
- `uo_out[0]`: privacy_ok.

The extra LEDs in the diagram show the bidirectional telemetry from the Verilog
tile:

- `uio_out[3:0]`: state code.
- `uio_out[7:4]`: attempt counter.

## Using in Wokwi

For the browser editor, create a custom chip named `gen1-companion`, then replace
the generated files with the files in this directory and replace the project
`diagram.json`.

For Wokwi CLI or VS Code, compile the custom chip model first:

```sh
wokwi-cli chip compile gen1-companion.chip.c -o gen1-companion.chip.wasm
```

Then run/open the project from this directory.
