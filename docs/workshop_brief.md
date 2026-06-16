# Workshop brief

## What Tiny Tapeout gives us

Tiny Tapeout lets a small design occupy a tile inside a shared manufactured chip. For this project, the right use is not to claim a complete memristive AI chip. The right use is to put one precise, explainable, digital piece of the future architecture through a real ASIC-style flow.

## Project goal

KA-Memristive-FF aims at local AI hardware where the main compute eventually lives in memristive arrays. A realistic chip still needs classical digital logic for:

- command sequencing;
- pulse generation;
- write-verify control;
- timeout and fault detection;
- configuration and bounded state;
- public telemetry.

The Tiny Tapeout proposal implements a minimal version of that digital island.

## Two-minute explanation

My project investigates local memristive AI. For Tiny Tapeout I am not trying to fabricate the full memristive array. I am preparing the first digital companion island: the logic that, in a final chip, would sequence operations, emit pulses, verify writes, detect faults and expose only public telemetry. The memristive part would do the physical compute; this tile represents the minimum digital contract around it.

In this prototype the memristive state is symbolic. I load a target and a current value, start a bounded write-verify loop, and the FSM emits `pulse_up` or `pulse_down` until it reaches `verify_ok` or `fault`. The important part is not that this is a real memristor. The important part is that the digital contract is small, testable and aligned with the final chip architecture.

## What to ask Matt

- Is this top module and port use aligned with the current Verilog template?
- Should `uio_oe = 8'hff` remain fixed, or should some bidirectional pins be left as inputs?
- Is a hardwired FSM the right workshop target, or should the protocol be made more serial and extensible?
- After GDS, which warnings or utilization metrics should decide whether to add anything before submission?
- If extra space is available, is a tolerance register or a tiny 2x2 digital MVM the better next extension?

## Default decision at the workshop

Keep the design minimal unless the official flow shows large, clean area/timing margin. The priority is a correct submission with honest claims, not an ambitious demo that blurs the memristive story.
