# Tiny Tapeout package P65 verification report

Fecha: `2026-05-31`

## Decision

Estado practico: `package_ready_for_workshop_pre_gds`.

El paquete `tiny_tapeout/tt_um_gen1_digital_companion_tile` queda preparado para llevar al workshop. El RTL empaquetado pasa lint Verilator, simulacion binaria Verilator y sintesis Yosys en Picasso cuando el job carga el mismo entorno que el P65 original: `module load pytorch/2.10.0` mas OSS CAD Suite.

Tambien se anadio y ejecuto una verificacion formal Yosys SAT sobre el RTL empaquetado.

## Resultados

- Python smoke model local: `pass`.
- P65 original en Picasso: Verilator lint `pass`, Verilator simulation `pass`, Yosys synthesis `pass`.
- Paquete Tiny Tapeout en Picasso:
  - Verilator lint: `pass`.
  - Verilator binary simulation: `pass`.
  - Yosys synthesis: `pass`.
  - Generic Yosys cell count: `158`.
  - Yosys SAT contract: `pass`, 3 proofs `SUCCESS`.
- Raw payload outputs observed in P65 smoke scenarios: `0`.

## Contratos verificados por Yosys SAT

- Up verify: `target=5`, `current=2`, `max_attempts=4` termina con `uo_out=8'hA3`, `uio_out=8'h32`.
- Down verify: `target=1`, `current=5`, `max_attempts=4` termina con `uo_out=8'hA3`, `uio_out=8'h42`.
- Timeout and clear: `target=8`, `current=0`, `max_attempts=3` termina con `uo_out=8'hB0`, `uio_out=8'h33`, y `CLEAR` devuelve `uo_out=8'h81`, `uio_out=8'h00`.

## Riesgos restantes

- Falta ejecutar la GitHub Action oficial de GDS de Tiny Tapeout.
- Falta ejecutar la GitHub Action oficial de Docs de Tiny Tapeout.
- El template exacto del shuttle debe confirmarse en el workshop.
- No se debe afirmar tapeout readiness hasta que el flujo oficial este verde.

## Nota sobre Picasso

El fallo anterior de simulacion se debia a lanzar el job sin cargar el entorno `pytorch/2.10.0`. Con ese modulo cargado, `python` pasa a Python 3.12.3 y la ejecucion reproduce el resultado `p65_tiny_tapeout_digital_companion_ready`.
