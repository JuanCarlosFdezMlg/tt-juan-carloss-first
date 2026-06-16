# Tiny Tapeout Workshop Playbook: Unified Digital Companion

Fecha del taller: `2026-06-02`
Fecha limite de cambios indicada por el taller: `2026-06-22`

## 1. Idea central

El proyecto final no es "hacer una IA en digital normal". El goal final es:

```text
un chip de IA local memristiva donde el calculo principal vive en arrays resistivos,
pero donde todas las tareas digitales inevitables quedan agrupadas en una unica isla
digital integrada.
```

La parte memristiva es el motor fisico principal: pesos resistivos, MVM y cambios por pulsos.
La parte digital no es el motor principal. Es la unidad companera que hace lo que la fisica
memristiva no hace bien por si sola: secuenciar, comparar, limitar intentos, emitir pulsos,
verificar escrituras, detectar fallos, llevar contadores y decidir que telemetria publica sale.

La frase corta:

> No quiero meter toda la IA memristiva en Tiny Tapeout. Quiero fabricar una primera mini-isla digital companera: la logica que en el chip final coordinaria pulsos, write-verify, faults y telemetria publica alrededor del core memristivo.

## 2. Que es Tiny Tapeout para este proyecto

Tiny Tapeout permite meter una tile pequena dentro de un chip compartido. No es el chip final
del proyecto. Es un primer contacto con silicio real y con el flujo ASIC.

Restricciones practicas a recordar:

- La tile estandar historica de TT04-TT10 es pequena, alrededor de `160 x 100 um`, suficiente
  para unas `1000` puertas digitales orientativas segun la FAQ de Tiny Tapeout.
- La interfaz tipica da `8` entradas, `8` salidas y `8` bidireccionales, ademas de clock,
  reset y enable.
- Esto favorece una FSM pequena y muy clara, no un acelerador de IA.

Fuentes utiles:

- FAQ: https://www.tinytapeout.com/faq/
- Guia de envio: https://tinytapeout.com/guides/advanced-workshop/submit-your-design/
- Memoria en Tiny Tapeout: https://www.tinytapeout.com/specs/memory/

## 3. Que es P65

P65 es el candidato nuevo para el workshop:

```text
tt_um_gen1_digital_companion_tile
```

No intenta simular memristores reales. Implementa en digital una version simbolica de la
unidad companion:

1. Carga un objetivo simbolico de conductancia/peso: `LOAD_TARGET`.
2. Carga un estado actual simbolico: `LOAD_CURRENT`.
3. Arranca un bucle: `START`.
4. Compara `current` contra `target`.
5. Emite `pulse_up` o `pulse_down`.
6. Actualiza el estado simbolico en un paso.
7. Repite hasta verificar o hasta llegar a timeout.
8. Publica solo estado, eventos y contadores.

Interfaz propuesta:

```text
ui_in[7:6]  comando
ui_in[5:0]  dato del comando

uo_out[7]   ready
uo_out[6]   busy
uo_out[5]   done
uo_out[4]   fault
uo_out[3]   pulse_up
uo_out[2]   pulse_down
uo_out[1]   verify_ok
uo_out[0]   privacy_ok

uio_out[7:4] attempt_count
uio_out[3:0] state
uio_oe       0xff
```

Comandos:

```text
00xxxxxx  NOP
01vvvvvv  LOAD_TARGET(v)
10vvvvvv  LOAD_CURRENT(v)
11mmmm01  START con max_attempts=m
11xxxx10  CLEAR
```

## 4. Que se ha verificado

P65 se ejecuto en Picasso como `gen1_p65_tiny_tapeout_digital_companion`.

Resultado:

- Estado: `p65_tiny_tapeout_digital_companion_ready`.
- Verilator lint: pasa.
- Verilator simulation: pasa.
- Yosys synthesis: pasa.
- Cell count generico Yosys: `158`.
- Presupuesto P65 elegido: `300` cells.
- Raw payload outputs observados en los escenarios de smoke: `0`.

Escenarios de smoke:

- `target=5`, `current=2`, `max_attempts=4`: verifica con `pulse_up`.
- `target=1`, `current=5`, `max_attempts=4`: verifica con `pulse_down`.
- `target=8`, `current=0`, `max_attempts=3`: falla por timeout.

Archivos:

- RTL: `hardware/rtl/tt_um_gen1_digital_companion_tile.v`
- Testbench: `hardware/tb/tb_tt_um_gen1_digital_companion_tile.sv`
- Script: `experiments/clean/gen1_p65_tiny_tapeout_digital_companion.py`
- Resultado: `artifacts/picasso/gen1_p65_tiny_tapeout_digital_companion/results.json`
- Reporte: `docs/reports/gen1_p65_tiny_tapeout_digital_companion.md`

## 5. Que NO se ha verificado

No afirmar:

- que hay array memristivo real;
- que hay comportamiento analogico `1T1R`;
- que hay energia medida;
- que hay privacidad fisica o resistencia a canales laterales;
- que el diseno esta listo para tapeout oficial;
- que esto equivale al wrapper Gen1 completo;
- que esto ejecuta IA local util o un LLM.

Frase honesta:

> P65 es una primera pieza digital fabricable del futuro sistema: una FSM companion que modela control de pulsos/write-verify y telemetria publica. Es una preparacion para Tiny Tapeout, no validacion fisica memristiva.

## 6. Como explicarlo alli

Version de 20 segundos:

> Trabajo en IA local memristiva. El chip final tendria un core resistivo para el calculo y una unica isla digital que agrupe todo lo que el core no puede hacer: scheduling, pulsos, write-verify, fallos y telemetria. Para Tiny Tapeout quiero prototipar esa isla digital minima, no el array memristivo completo.

Version de 60 segundos:

> La parte memristiva ideal almacenaria pesos y haria operaciones tipo matriz-vector. Pero un sistema real necesita logica clasica: seleccionar pasos, aplicar pulsos, comprobar si una escritura llego al objetivo, parar por timeout y emitir solo eventos publicos. P65 implementa una version minima de esa logica: cargo target/current simbolicos, arranco write-verify, emito pulse_up/pulse_down, cuento intentos y termino en verify_ok o fault. Ya lo probe con Verilator y Yosys en Picasso.

Si preguntan por privacidad:

> Aqui privacidad significa frontera arquitectonica de salida: la tile no esta pensada para publicar el payload cargado, sino estado, eventos y contadores. No afirmo resistencia fisica a canales laterales.

Si preguntan por memristores:

> No hay memristores en esta tile. Es la parte digital companion que un core memristivo necesitaria. La version memristiva real exigiria analog/mixed-signal, ADC/DAC o comparadores, caracterizacion fisica y otro nivel de validacion.

## 7. Preguntas buenas para Matt

Prioridad alta:

- Cual es la plantilla exacta de top module para este workshop?
- El flujo acepta este Verilog directamente o debo adaptarlo a otro wrapper?
- El uso fijo de `uio_oe = 8'hff` es aceptable para el shuttle concreto?
- Hay warnings o estilos Verilog que conviene evitar antes de GDS?
- Que metricas del flujo oficial debo mirar: area, timing, wire length, utilization, setup/hold?

Prioridad media:

- Tiene sentido mantener P65 hardwired o hacer el protocolo mas serial/extensible?
- Hay margen de area para anadir mini MVM cuantizado 2x2 o es mejor dejar solo write-verify?
- Si compro tiles extra, cual seria la extension mas razonable?
- Conviene publicar el proyecto como "digital companion for memristive core" o con un nombre mas educativo?

## 8. Decision recomendada durante el workshop

Default:

```text
usar P65 como base del proyecto Tiny Tapeout
```

No usar P64 salvo como fallback, porque P64 es mas debil conceptualmente: control/telemetria.
P65 representa mejor el goal final: una unica unidad digital companion.

Solo cambiar el enfoque si Matt indica que:

- el protocolo de pines no encaja con la plantilla;
- el flujo del taller espera Wokwi y no Verilog;
- hay una restriccion de estilo/timing que haga P65 problematico;
- la shuttle permite una opcion analogica/mixed-signal claramente mejor para write-verify.

## 9. Roadmap hasta el 22 de junio

Dia 2 de junio:

- Adaptar top module a la plantilla oficial.
- Correr GDS oficial.
- Anotar todos los warnings.
- Confirmar si cabe en 1 tile.
- Confirmar como se testearia en la PCB.

Despues del workshop:

1. Cerrar P65-template: mismo comportamiento, top oficial.
2. Correr flujo oficial completo y guardar artefactos.
3. Hacer testbench compatible con la plantilla Tiny Tapeout.
4. Documentar instrucciones de uso en README del proyecto TT.
5. Decidir si se anade una extension pequena:
   - extension segura: registro de configuracion/tolerancia;
   - extension ambiciosa: mini MVM cuantizado 2x2;
   - no recomendado: aprendizaje completo o memoria grande.

## 10. Criterio de exito realista

Exito minimo:

```text
P65 se adapta al template oficial, pasa GDS y queda enviado como tile educativa.
```

Exito fuerte:

```text
P65 se envia y la documentacion explica claramente el puente entre goal final, core memristivo futuro e isla digital companion.
```

No hace falta demostrar IA ni memristores para que el workshop aporte valor. El valor es abrir el camino de silicio real para una pieza pequena pero conceptualmente alineada.
