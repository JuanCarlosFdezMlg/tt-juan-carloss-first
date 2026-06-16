# Tiny Tapeout KA Workshop: Guia Rapida

Fecha del workshop: 2026-06-02

Este repositorio es el paquete separado para el workshop de Tiny Tapeout. La raiz del repo esta preparada como proyecto Tiny Tapeout Verilog: `info.yaml`, `src/project.v`, `test/`, `docs/` y `.github/workflows/`.

## Idea en una frase

No intentamos fabricar todavia un chip memristivo completo. Fabricamos una primera pieza digital realista: una tile que representa la logica companera que en el futuro controlaria un core memristivo.

## Que hace la tile

La tile implementa una FSM pequena:

1. Recibe un valor objetivo simbolico: `target`.
2. Recibe un valor actual simbolico: `current`.
3. Recibe `START`.
4. Compara `current` con `target`.
5. Si `current < target`, emite `pulse_up`.
6. Si `current > target`, emite `pulse_down`.
7. Cuenta intentos.
8. Si llega al objetivo, emite `done` y `verify_ok`.
9. Si agota intentos, emite `done` y `fault`.
10. Hacia fuera solo expone telemetria publica: estado, pulsos, contador y fallo, no el payload crudo cargado.

En un chip memristivo real, `pulse_up` y `pulse_down` serian ordenes hacia circuiteria fisica que ajusta conductancias. Aqui son senales digitales simbolicas, pensadas para validar el contrato de control.

## Como explicarlo alli

Pitch corto:

> Mi proyecto investiga IA local memristiva. Para Tiny Tapeout no intento fabricar el array memristivo completo; preparo la primera isla digital companera: una logica pequena que, en el chip final, secuenciaria operaciones, emitiria pulsos, verificaria escrituras, detectaria fallos y expondria solo telemetria publica. La parte memristiva haria el computo fisico; esta tile representa el contrato digital minimo alrededor de ella.

## Archivos principales

- RTL principal: `src/project.v`
- Metadatos Tiny Tapeout: `info.yaml`
- Documentacion oficial del proyecto: `docs/info.md`
- Tests cocotb-style: `test/test.py`
- Contratos formales Yosys: `formal/companion_contract.sv`
- Workflows oficiales: `.github/workflows/docs.yaml` y `.github/workflows/gds.yaml`
- Paquete Wokwi de simulacion: `wokwi/diagram.json`, `wokwi/gen1-companion.chip.json`, `wokwi/gen1-companion.chip.c`
- Brief del workshop: `docs/workshop_brief.md`
- Preguntas para Matt: `docs/questions_for_matt.md`
- Evidencia y reportes: `workshop/`

## Verificacion ya realizada

Resultado fuerte historico del paquete previo:

- Verilator lint: pass
- Verilator simulation: pass
- Yosys synthesis: pass
- Cell count generico: 158
- Yosys SAT contract: pass
- Docs check de Tiny Tapeout: pass

Artefacto principal historico:

- `workshop/artifacts/picasso/tiny_tapeout_package_p65_verilator_fixed/results.json`

## Como verificar en Picasso

Usar el entorno corregido:

```bash
module load pytorch/2.10.0
export OSS_CAD_SUITE_BIN=/mnt/home/users/tep_967_uma_colab/jfernandez/.tools/oss-cad-suite-20260508/bin
export PATH="$OSS_CAD_SUITE_BIN:$PATH"
```

El fallo anterior de Verilator ocurria cuando no se cargaba ese entorno y el nodo caia en `g++ 7.5.0`. Con `module load pytorch/2.10.0`, el job reproduce el estado `p65_tiny_tapeout_digital_companion_ready`.

## Como usar GitHub Actions oficiales

Este repo incluye Actions para GF26a / `gf180mcuD`:

- `docs`: `TinyTapeout/tt-gds-action/docs@ttgf26a`
- `gds`: `TinyTapeout/tt-gds-action@ttgf26a`

Para ejecutarlas:

1. Crear un repo GitHub nuevo desde la plantilla Tiny Tapeout Verilog o subir este repo como raiz.
2. Activar GitHub Pages con source `GitHub Actions`.
3. Hacer commit y push.
4. Esperar a que pasen `docs` y `gds`.
5. No afirmar tapeout readiness hasta que esas Actions esten verdes para la revision actual.

## Que hacer el 2 de junio

1. Abrir este repo.
2. Mostrar `src/project.v`, `info.yaml` y `docs/workshop_brief.md`.
3. Preguntar a Matt si `ttgf-verilog-template` y `ttgf26a` son la plantilla/action correctas para el evento.
4. Confirmar si `uio_oe = 8'hff` es aceptable para usar todos los `uio` como salidas.
5. Subir este repo a GitHub o copiarlo en el repo que se cree durante el workshop.
6. Correr las Actions `docs` y `gds`.
7. Si hay warnings, arreglar primero plantilla/documentacion/pines antes de cambiar la arquitectura.

Decision recomendada: mantener la tile minima. No anadir MVM ni IA completa en el workshop salvo recomendacion explicita de Matt.

## Nota sobre Wokwi

El workshop basico de Tiny Tapeout usa Wokwi para esquemas pequenos de puertas.
Esta tile ya esta implementada como Verilog secuencial, asi que la ruta de
fabricacion recomendada sigue siendo la plantilla Verilog. El directorio
`wokwi/` sirve para tener un proyecto Wokwi JSON de simulacion/explicacion de la
interfaz, no como sustituto automatico del RTL fabricable.
