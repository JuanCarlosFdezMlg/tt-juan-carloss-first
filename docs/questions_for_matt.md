# Questions for Matt Venn

## Flow and template

- Which Verilog template should this workshop use: SKY, GF, IHP, or another current shuttle template?
- Is `tt_um_juan_gen1_digital_companion_tile` unique enough for the target shuttle?
- Are there current restrictions on asynchronous active-low reset style for this shuttle?
- Is fixed `uio_oe = 8'hff` acceptable when all bidirectional pins are intentionally used as outputs?
- Should the clock be documented as 20 MHz, 25 MHz, or left as "not timing-characterized yet" until the official flow runs?

## Area and risk

- Is 158 generic Yosys cells safely small enough for one tile after technology mapping and routing?
- Which GDS reports should be treated as blockers before submission?
- Should I avoid adding any extra logic once the first GDS action is green?

## Architecture

- Is "digital companion island for a future memristive core" a clear and honest framing?
- Would you recommend keeping the protocol simple, or moving toward a UART/SPI-like command interface?
- If I buy extra tile space later, would a small digital MVM demo be useful, or would that distract from the memristive companion claim?
