/*
 * Functional Wokwi custom-chip model for tt_um_juan_gen1_digital_companion_tile.
 *
 * This is a simulation mirror of src/project.v. It is not the source that
 * should be synthesized for Tiny Tapeout; use src/project.v for fabrication.
 */

#include "wokwi-api.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

enum {
  CMD_NOP = 0,
  CMD_LOAD_TARGET = 1,
  CMD_LOAD_CURRENT = 2,
  CMD_CONTROL = 3,
};

typedef struct {
  pin_t vcc;
  pin_t gnd;
  pin_t clk;
  pin_t rst_n;
  pin_t ena;
  pin_t ui[8];
  pin_t uo[8];
  pin_t uio[8];
  uint8_t last_clk;
  uint8_t target_q;
  uint8_t current_q;
  uint8_t max_attempts_q;
  uint8_t attempt_q;
  bool busy_q;
  bool done_q;
  bool fault_q;
  bool pulse_up_q;
  bool pulse_down_q;
  bool verify_ok_q;
} chip_state_t;

static uint8_t read_bus(pin_t pins[8]) {
  uint8_t value = 0;
  for (uint8_t i = 0; i < 8; i++) {
    if (pin_read(pins[i]) == HIGH) {
      value |= (uint8_t)(1u << i);
    }
  }
  return value;
}

static void write_bit(pin_t pin, bool value) {
  pin_write(pin, value ? HIGH : LOW);
}

static void reset_state(chip_state_t *chip) {
  chip->target_q = 0;
  chip->current_q = 0;
  chip->max_attempts_q = 4;
  chip->attempt_q = 0;
  chip->busy_q = false;
  chip->done_q = false;
  chip->fault_q = false;
  chip->pulse_up_q = false;
  chip->pulse_down_q = false;
  chip->verify_ok_q = false;
}

static uint8_t state_code(const chip_state_t *chip) {
  if (chip->fault_q) {
    return 3;
  }
  if (cmd == CMD_CONTROL && control_clear) {
    chip->busy_q = false;
    chip->done_q = false;
    chip->fault_q = false;
    chip->pulse_up_q = false;
    chip->pulse_down_q = false;
    chip->verify_ok_q = false;
    chip->attempt_q = 0;
  } else if (chip->busy_q) {
    return 1;
  }
  if (chip->done_q) {
    return 2;
  }
  return 0;
}

static void update_outputs(chip_state_t *chip) {
  const bool enabled = pin_read(chip->ena) == HIGH;
  const bool ready = !chip->busy_q;
  const bool privacy_ok = !chip->fault_q;
  const bool uo_bits[8] = {
    privacy_ok,
    chip->verify_ok_q,
    chip->pulse_down_q,
    chip->pulse_up_q,
    chip->fault_q,
    chip->done_q,
    chip->busy_q,
    ready,
  };
  const uint8_t uio_value = (uint8_t)((chip->attempt_q << 4) | state_code(chip));

  for (uint8_t i = 0; i < 8; i++) {
    write_bit(chip->uo[i], enabled && uo_bits[i]);
    write_bit(chip->uio[i], enabled && ((uio_value >> i) & 1u));
  }
}

static void tick(chip_state_t *chip) {
  if (pin_read(chip->rst_n) == LOW) {
    reset_state(chip);
    update_outputs(chip);
    return;
  }

  if (pin_read(chip->ena) != HIGH) {
    update_outputs(chip);
    return;
  }

  const uint8_t ui = read_bus(chip->ui);
  const uint8_t cmd = (ui >> 6) & 0x3u;
  const uint8_t data = ui & 0x3fu;
  const bool control_start = (data & 0x01u) != 0;
  const bool control_clear = (data & 0x02u) != 0;
  const uint8_t control_max_attempts = (data >> 2) & 0x0fu;

  chip->pulse_up_q = false;
  chip->pulse_down_q = false;
  chip->verify_ok_q = false;

  if (chip->busy_q) {
    if (chip->current_q == chip->target_q) {
      chip->busy_q = false;
      chip->done_q = true;
      chip->verify_ok_q = true;
    } else if (chip->attempt_q >= chip->max_attempts_q) {
      chip->busy_q = false;
      chip->done_q = true;
      chip->fault_q = true;
    } else {
      chip->attempt_q = (chip->attempt_q + 1u) & 0x0fu;
      if (chip->current_q < chip->target_q) {
        chip->current_q = (chip->current_q + 1u) & 0x3fu;
        chip->pulse_up_q = true;
      } else {
        chip->current_q = (chip->current_q - 1u) & 0x3fu;
        chip->pulse_down_q = true;
      }
    }
  } else {
    if (cmd == CMD_LOAD_TARGET) {
      chip->target_q = data;
    } else if (cmd == CMD_LOAD_CURRENT) {
      chip->current_q = data;
    } else if (cmd == CMD_CONTROL) {
      if (control_start) {
        chip->busy_q = true;
        chip->done_q = false;
        chip->fault_q = false;
        chip->attempt_q = 0;
        chip->max_attempts_q = control_max_attempts == 0 ? 1 : control_max_attempts;
      }
    }
  }

  update_outputs(chip);
}

static void on_input_change(void *user_data, pin_t pin, uint32_t value) {
  (void)pin;
  (void)value;
  chip_state_t *chip = (chip_state_t *)user_data;

  if (pin_read(chip->rst_n) == LOW) {
    reset_state(chip);
    update_outputs(chip);
    chip->last_clk = (uint8_t)pin_read(chip->clk);
    return;
  }

  const uint8_t clk_now = (uint8_t)(pin_read(chip->clk) == HIGH);
  if (chip->last_clk == LOW && clk_now == HIGH) {
    tick(chip);
  } else {
    update_outputs(chip);
  }
  chip->last_clk = clk_now;
}

void chip_init(void) {
  static const char *ui_names[8] = {
    "UI0", "UI1", "UI2", "UI3", "UI4", "UI5", "UI6", "UI7",
  };
  static const char *uo_names[8] = {
    "UO0", "UO1", "UO2", "UO3", "UO4", "UO5", "UO6", "UO7",
  };
  static const char *uio_names[8] = {
    "UIO0", "UIO1", "UIO2", "UIO3", "UIO4", "UIO5", "UIO6", "UIO7",
  };

  chip_state_t *chip = malloc(sizeof(chip_state_t));
  chip->vcc = pin_init("VCC", INPUT);
  chip->gnd = pin_init("GND", INPUT);
  chip->clk = pin_init("CLK", INPUT);
  chip->rst_n = pin_init("RST_N", INPUT_PULLUP);
  chip->ena = pin_init("ENA", INPUT_PULLUP);
  for (uint8_t i = 0; i < 8; i++) {
    chip->ui[i] = pin_init(ui_names[i], INPUT_PULLDOWN);
    chip->uo[i] = pin_init(uo_names[i], OUTPUT_LOW);
    chip->uio[i] = pin_init(uio_names[i], OUTPUT_LOW);
  }

  reset_state(chip);
  chip->last_clk = (uint8_t)(pin_read(chip->clk) == HIGH);
  update_outputs(chip);

  const pin_watch_config_t watch_config = {
    .edge = BOTH,
    .pin_change = on_input_change,
    .user_data = chip,
  };
  pin_watch(chip->clk, &watch_config);
  pin_watch(chip->rst_n, &watch_config);
  pin_watch(chip->ena, &watch_config);
}
