# Status summary

## Current revision

- Fabrication RTL is `src/project.v`.
- Top module is `tt_um_juan_gen1_digital_companion_tile`.
- `CLEAR` is defined to clear state even while busy.
- Cocotb and Yosys SAT contracts include up verify, down verify, timeout, clear, clear while busy, target equals current, and zero-budget behavior.
- The repository workflows currently target SKY26c / `sky130A`.

## Historical evidence

- Pre-revision packaged RTL reported Verilator lint pass on Picasso.
- Pre-revision packaged RTL reported Verilator binary simulation pass on Picasso when launched with `module load pytorch/2.10.0`.
- Pre-revision packaged RTL reported Yosys synthesis pass on Picasso with 158 generic cells.
- Pre-revision smoke result reported 0 raw payload outputs observed.
- These artifacts predate the unique top-module rename and `CLEAR` priority fix, so rerun hosted Actions before submission.

## Provisional

- This revision has not yet run the official Tiny Tapeout GDS and Docs GitHub Actions.
- The final shuttle/process template should be confirmed before submission. Use SKY26c as configured, or migrate to GF if targeting a June 22 GF shuttle.
- Clock documentation uses a conservative 20 MHz placeholder until official flow/timing guidance.
- `uio_oe = 8'hff` should be confirmed against the exact workshop template and board expectations.
- A previous Picasso package job failed Verilator binary simulation because it did not load the `pytorch/2.10.0` environment. The corrected job passes.

## Do not claim

- Do not claim real memristive devices.
- Do not claim analog 1T1R behavior.
- Do not claim physical privacy.
- Do not claim measured energy.
- Do not claim full local AI or LLM inference.
- Do not claim tapeout readiness until the official GDS and Docs actions pass.

## Next actions before submission

1. Confirm target shuttle: SKY26c with this repo, or GF26a/GF26b after migrating template/action.
2. Copy this package into that repository.
3. Run the official test, GDS and Docs actions.
4. Fix only template, documentation or warning issues unless Matt recommends an architectural change.
5. Submit the project once actions are green.
