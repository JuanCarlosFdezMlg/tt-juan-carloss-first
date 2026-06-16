# Gen1 P65 Tiny Tapeout package check

P65 reformula el candidato Tiny Tapeout como una unidad digital companera unificada: scheduler minimo, pulse-update simbolico, write-verify, timeout/fault y telemetria publica.

Artefactos principales:

- Paquete: `tiny_tapeout/tt_um_gen1_digital_companion_tile/`
- Resultado crudo del script: `artifacts/picasso/tiny_tapeout_package_p65/results.json`
- Witness del smoke model: `artifacts/picasso/tiny_tapeout_package_p65/witness.json`
- Log formal: `artifacts/picasso/tiny_tapeout_package_p65/yosys_contract.stdout.log`

Estado: `package_ready_for_workshop_pre_gds`.

Verificacion principal:

- `artifacts/picasso/tiny_tapeout_package_p65_verilator_fixed/results.json`
- Estado: `p65_tiny_tapeout_digital_companion_ready`
- Verilator lint: `pass`
- Verilator simulation: `pass`
- Yosys synthesis: `pass`
- Cell count: `158`

Nota: el resultado antiguo en `artifacts/picasso/tiny_tapeout_package_p65/results.json` conserva `verilator_simulation_failed` porque ese job se lanzo sin cargar el entorno `pytorch/2.10.0`. El job corregido carga ese modulo y reproduce el estado ready.
