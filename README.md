# tt_um_juan_gen1_digital_companion_tile

Tiny Tapeout proposal package for KA-Memristive-FF.

Start here for the workshop guide in Spanish: [WORKSHOP_START_HERE.md](WORKSHOP_START_HERE.md).

## One sentence

This is a small digital companion tile for a future local memristive AI chip: it sequences symbolic pulse updates, verifies convergence, reports public status, and avoids exposing raw loaded payload values on the public outputs.

## Why this fits Tiny Tapeout

Tiny Tapeout is best used here as a first real-silicon step, not as the complete memristive system. The final KA-Memristive-FF goal would use memristive arrays for the physical compute and a single digital island for the control work that physics does not do cleanly by itself: scheduling, pulse direction, bounded write-verify, fault handling, and public telemetry.

This tile prototypes that digital island in one compact finite-state machine.

## Interface

Dedicated inputs:

| Signal | Meaning |
| --- | --- |
| `ui_in[7:6]` | command |
| `ui_in[5:0]` | command data |

Dedicated outputs:

| Signal | Meaning |
| --- | --- |
| `uo_out[7]` | `ready` |
| `uo_out[6]` | `busy` |
| `uo_out[5]` | `done` |
| `uo_out[4]` | `fault` |
| `uo_out[3]` | `pulse_up` |
| `uo_out[2]` | `pulse_down` |
| `uo_out[1]` | `verify_ok` |
| `uo_out[0]` | `privacy_ok` |

Bidirectional pins are driven as extra public outputs:

| Signal | Meaning |
| --- | --- |
| `uio_out[7:4]` | attempt counter |
| `uio_out[3:0]` | FSM state code |
| `uio_oe` | fixed to `8'hff` while enabled |

## Commands

| Encoding | Name | Effect |
| --- | --- | --- |
| `00xxxxxx` | `NOP` | no operation |
| `01vvvvvv` | `LOAD_TARGET(v)` | load symbolic target value |
| `10vvvvvv` | `LOAD_CURRENT(v)` | load symbolic current value |
| `11mmmm01` | `START(m)` | start bounded write-verify loop with `max_attempts=m` |
| `11xxxx10` | `CLEAR` | clear busy/done/fault/events/attempt state, including while busy |

## How it works

1. The host loads a symbolic target and current value.
2. `START` puts the FSM into `busy`.
3. Each clock cycle compares `current` with `target`.
4. If `current < target`, the tile emits `pulse_up` for one cycle and increments the symbolic current.
5. If `current > target`, the tile emits `pulse_down` for one cycle and decrements the symbolic current.
6. If the target is reached, the tile emits `done` and `verify_ok`.
7. If `max_attempts` is exhausted first, the tile emits `done` and `fault`.
8. Public outputs expose status, events and counters, not the loaded target/current payload values.

## What this proves

- A Tiny Tapeout-sized digital companion contract can be expressed as a small FSM.
- The interface is small enough for one tile.
- The public telemetry surface is separated from the loaded symbolic payload.
- The design is small enough for the Tiny Tapeout flow and has a historical pre-revision P65 smoke result on Picasso.

## What this does not prove

- No real memristors are implemented.
- No analog 1T1R behavior is modeled.
- No energy or timing claim about physical memristive hardware is made.
- No side-channel or physical privacy claim is made.
- This is not a complete local AI chip or LLM accelerator.
- This package still needs the official Tiny Tapeout GDS and Docs actions before submission.

## Verification status

Current revision evidence:

- RTL: `src/project.v`
- Testbench: `test/test.py` and `test/tb.v`
- Yosys SAT contracts: `formal/companion_contract.sv`
- Local package: `workshop/artifacts/local/tt_um_juan_gen1_digital_companion_tile_submission.tar.gz`

Historical pre-revision Picasso evidence:

- Verilator lint: pass.
- Verilator simulation: pass.
- Yosys synthesis: pass.
- Generic Yosys cell count: 158.
- Smoke scenarios: up verify, down verify, timeout fault.
- Raw payload outputs observed in smoke scenarios: 0.
- Source: `workshop/artifacts/picasso/tiny_tapeout_package_p65_verilator_fixed/results.json`
- This result predates the unique top-module rename and `CLEAR` priority fix, so rerun hosted Actions before submission.

## Run tests

This package now includes Tiny Tapeout GF26a workflow files under `.github/workflows/`:

- `docs.yaml`: uses `TinyTapeout/tt-gds-action/docs@ttgf26a`.
- `gds.yaml`: uses `TinyTapeout/tt-gds-action@ttgf26a`, precheck, gate-level test and viewer jobs.

To run the hosted Actions, push this directory as the root of a GitHub repository created from or compatible with the official Tiny Tapeout Verilog template, then enable GitHub Pages from Actions.

From this package:

```sh
cd test
make
```

That uses the standard Tiny Tapeout cocotb-style test layout. If cocotb or a simulator is not installed locally, use the existing repository-level Python/P65 tests or run on Picasso/OSS CAD Suite.

For a lightweight Yosys-only contract check:

```sh
yosys formal/run_yosys_contract.ys
```

This proves the expected terminal outputs for the up-verify, down-verify, timeout, clear, clear-while-busy, target-equals-current and zero-budget smoke contracts without needing Verilator's generated C++ simulator.

## Wokwi companion package

The `wokwi/` directory contains a Wokwi `diagram.json`, custom-chip pinout JSON and C simulation model for the same command/status contract. This is a visual and interactive simulation bridge for the workshop flow.

Use `src/project.v` as the fabrication RTL. Do not replace the Verilog submission package with the Wokwi custom-chip model unless Tiny Tapeout staff explicitly confirms that custom-chip Wokwi projects are accepted for the current shuttle.

## Workshop pitch

My project investigates local memristive AI. For Tiny Tapeout I am not trying to fabricate the full memristive array. I am preparing the first digital companion island: the logic that, in a final chip, would sequence operations, emit pulses, verify writes, detect faults and expose only public telemetry. The memristive part would do the physical compute; this tile represents the minimum digital contract around it.
