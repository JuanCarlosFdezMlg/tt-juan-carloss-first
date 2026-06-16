# Wokwi and Tiny Tapeout submission analysis

Date: 2026-06-02

## Verified from documentation

- The workshop page links the route used during the workshop: draw/simulate a
  Wokwi logic design, create GDS, optionally submit a revision, and optionally
  activate/test a design.
- The Wokwi workshop route expects a Wokwi project that started from the Tiny
  Tapeout Wokwi template, then a saved Wokwi project URL is submitted through the
  Tiny Tapeout portal.
- The generated repository contains `info.yaml`; GitHub Actions build docs and
  GDS. For Wokwi workshop submissions, Tiny Tapeout says only the GDS action has
  to be green for submission, but docs should be fixed because failed docs omit
  project information from the datasheet.
- Tiny Tapeout's Verilog route uses the Verilog template repository, fills
  `info.yaml`, keeps `src/`, `test/`, and `docs/`, iterates until `gds` and
  `docs` are green, and then submits a revision through `app.tinytapeout.com`.
- Wokwi `diagram.json` is a JSON file with `version`, `author`, `editor`,
  `parts`, and `connections`.
- Wokwi custom chips define their pinout in `<chip-name>.chip.json`.
- Wokwi custom-chip source can be written in C; Wokwi's Chips API is beta and
  Verilog support for custom chips is experimental.

## Consequence for this tile

The current tile is a sequential Verilog FSM, not a small Wokwi gate schematic.
The workshop page itself says Wokwi is mainly useful for beginner circuits below
about 100 gates and points more complex designs toward Verilog.

Therefore:

- The real submission package for manufacturing is the Verilog package already
  present in this repository: `info.yaml`, `src/project.v`, `test/`, `docs/`,
  and `.github/workflows/`.
- The new `wokwi/` package is a faithful Wokwi simulation/visualization package
  for the same command/status contract, but it should not replace `src/project.v`
  as the fabrication source.
- If the event staff explicitly requires a Wokwi URL, create/save a Wokwi
  project from `wokwi/diagram.json` and the custom-chip files, then ask whether
  custom chips are accepted by the current Tiny Tapeout Wokwi portal. If not,
  use the documented Verilog-template path instead.

## Primary sources checked

- Tiny Tapeout workshop overview:
  https://tinytapeout.com/guides/workshop/
- Tiny Tapeout Wokwi simulation workshop:
  https://tinytapeout.com/guides/workshop/simulate-a-gate/
- Tiny Tapeout Wokwi GDS/submission workshop:
  https://tinytapeout.com/guides/workshop/create-your-gds/
- Tiny Tapeout Verilog submission guide:
  https://tinytapeout.com/guides/submit-verilog-project/
- Wokwi diagram JSON format:
  https://docs.wokwi.com/diagram-format
- Wokwi custom chip JSON format:
  https://docs.wokwi.com/chips-api/chip-json
- Wokwi custom chips getting started:
  https://docs.wokwi.com/chips-api/getting-started
- Wokwi custom chips to WASM:
  https://docs.wokwi.com/guides/custom-chips-to-wasm
