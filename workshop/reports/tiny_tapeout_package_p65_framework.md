# Tiny Tapeout Unified Digital Companion Framework

Fecha: `2026-05-31`

## Goal final del proyecto

El goal final es un chip de IA local memristiva donde el calculo principal vive en arrays resistivos, pero donde todas las funciones digitales inevitables quedan aglutinadas en una unica isla digital integrada. Esa isla no reemplaza al core memristivo: lo hace utilizable, verificable y protegible.

Arquitectura objetivo:

```text
datos locales -> isla digital unificada -> core memristivo -> lectura/verificacion -> isla digital -> telemetria publica
```

La parte memristiva deberia encargarse de almacenamiento resistivo, MVM y cambios fisicos por pulsos. La parte digital unificada deberia encargarse de scheduler, generacion de pulsos, write-verify, contadores, faults, configuracion, estado pequeno y frontera de privacidad.

## Enfoque Tiny Tapeout

Para el workshop no se intenta fabricar el core memristivo. Se prototipa una primera version digital minima de la isla companion:

- `LOAD_TARGET`: carga objetivo simbolico de conductancia/peso.
- `LOAD_CURRENT`: carga estado simbolico actual.
- `START`: lanza un bucle write-verify.
- FSM interna: compara, emite `pulse_up` o `pulse_down`, cuenta intentos, verifica o falla por timeout.
- Salidas publicas: `ready`, `busy`, `done`, `fault`, `pulse_up`, `pulse_down`, `verify_ok`, `privacy_ok`, intento y estado.

Esto cambia el pitch desde "controlador de telemetria" a "unidad digital companera del futuro bloque memristivo".

## Resultado P65 package

- Estado practico: `package_ready_for_workshop_pre_gds`.
- Paquete preparado: `True`.
- Celdas Yosys genericas: `158` con presupuesto P65 `300`.
- Raw payload outputs observados: `0`.
- Verilator lint del paquete: `pass`.
- Verilator simulation del paquete: `pass` en job corregido con `module load pytorch/2.10.0`.
- Yosys synthesis del paquete: `pass`.
- Yosys SAT contract del paquete: `pass`, tres pruebas `SUCCESS`.

Claim permitido:

`P65 implements a Tiny Tapeout-sized unified digital companion candidate with symbolic pulse-update/write-verify control, public telemetry, timeout fault logic, and no observed raw payload output in the tested scenarios.`

Claim prohibido:

`P65 does not prove a memristive array, analog 1T1R behavior, measured energy, physical privacy, full Gen1 equivalence, ASIC signoff, tapeout readiness, or local LLM capability.`

## Como explicarlo en el workshop

Version corta:

> Mi proyecto busca IA local memristiva. Para Tiny Tapeout no intento fabricar el array memristivo completo; quiero fabricar la primera isla digital companera: la logica que, en un chip final, secuenciaria pulsos, verificaria escrituras, detectaria fallos y solo expondria telemetria publica.

Preguntas para Matt:

- Si conviene mantener esta FSM hardwired o convertirla a un protocolo serial mas extensible.
- Si el flujo del taller acepta este top Verilog directamente o conviene migrarlo a la plantilla exacta del shuttle.
- Si el limite practico de area/timing deja margen para anadir un pequeno registro de configuracion o conviene mantener P65 minimo.
- Si merece la pena comprar tiles extra para una version con mini MVM digital de 2x2 o 4x4.

## Checklist antes y durante el workshop

Antes:

- Llevar el RTL `tt_um_gen1_digital_companion_tile.v`.
- Llevar el testbench y el reporte P65.
- Llevar este pitch y tener claro que P65 es digital companion, no memristor real.

Durante:

- Preguntar por plantilla/top module exacto.
- Confirmar proceso/PDK/shuttle.
- Correr el flujo GDS oficial.
- Revisar warnings, area, pins y documentacion.
- Guardar una lista de cambios para antes del cierre del 22 de junio de 2026.

Despues:

- Rehacer P65 en la plantilla oficial si hace falta.
- Ejecutar la GitHub Action/GDS oficial.
- Decidir si se mantiene P65 minimo o se usa el margen de area para anadir un mini MVM cuantizado.
