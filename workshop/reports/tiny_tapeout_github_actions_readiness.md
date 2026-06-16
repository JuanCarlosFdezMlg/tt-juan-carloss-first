# Tiny Tapeout GitHub Actions readiness

Fecha: `2026-05-31`

## Estado

El paquete `tiny_tapeout/tt_um_gen1_digital_companion_tile` esta preparado para usarse como raiz de un repositorio Tiny Tapeout Verilog.

Se han incorporado los workflows oficiales de la plantilla `ttsky-verilog-template`:

- `.github/workflows/docs.yaml`
- `.github/workflows/gds.yaml`

Version de action usada:

- `TinyTapeout/tt-gds-action/docs@ttsky26c`
- `TinyTapeout/tt-gds-action@ttsky26c`
- `TinyTapeout/tt-gds-action/precheck@ttsky26c`
- `TinyTapeout/tt-gds-action/gl_test@ttsky26c`
- `TinyTapeout/tt-gds-action/viewer@ttsky26c`

## Ejecutado

- `tt_tool.py --check-docs` ejecutado en Picasso/Linux: `pass`.
- Verilator lint del RTL empaquetado en Picasso: `pass`.
- Verilator simulation del RTL empaquetado en Picasso: `pass`.
- Yosys synthesis del RTL empaquetado en Picasso: `pass`, 158 celdas.
- Yosys SAT contract del RTL empaquetado: `pass`, 3 pruebas `SUCCESS`.

## No ejecutado desde esta maquina

Las GitHub Actions alojadas `docs` y `gds` no pueden dispararse desde este workspace porque:

- el repo local no tiene `git remote` GitHub configurado;
- no hay `gh` CLI instalado/autenticado;
- no hay `act` instalado para emular Actions localmente;
- no hay `docker` en PATH, requerido por el flujo local de hardening/LibreLane.

## Siguiente paso exacto

1. Crear un repo GitHub desde `TinyTapeout/ttsky-verilog-template` o usar este paquete como raiz de un repo nuevo.
2. Copiar/subir el contenido de `tiny_tapeout/tt_um_gen1_digital_companion_tile/` a la raiz del repo.
3. En GitHub: Settings -> Pages -> Source -> GitHub Actions.
4. Hacer commit/push.
5. Verificar que las Actions `docs` y `gds` quedan verdes.
6. No afirmar tapeout readiness hasta que ambas Actions pasen.
