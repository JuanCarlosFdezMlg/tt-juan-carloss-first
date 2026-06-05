/*
 * Copyright (c) 2026 Juan Fernandez
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns/1ps

module tt_um_gen1_digital_companion_tile (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
    localparam [1:0] CMD_NOP          = 2'b00;
    localparam [1:0] CMD_LOAD_TARGET  = 2'b01;
    localparam [1:0] CMD_LOAD_CURRENT = 2'b10;
    localparam [1:0] CMD_CONTROL      = 2'b11;

    localparam [3:0] STATE_IDLE  = 4'd0;
    localparam [3:0] STATE_BUSY  = 4'd1;
    localparam [3:0] STATE_DONE  = 4'd2;
    localparam [3:0] STATE_FAULT = 4'd3;

    wire [1:0] cmd = ui_in[7:6];
    wire [5:0] data = ui_in[5:0];
    wire control_start = data[0];
    wire control_clear = data[1];
    wire [3:0] control_max_attempts = data[5:2];

    wire _unused = &{uio_in, 1'b0};

    reg [5:0] target_q;
    reg [5:0] current_q;
    reg [3:0] max_attempts_q;
    reg [3:0] attempt_q;
    reg busy_q;
    reg done_q;
    reg fault_q;
    reg pulse_up_q;
    reg pulse_down_q;
    reg verify_ok_q;

    wire [3:0] state_code = fault_q ? STATE_FAULT : (busy_q ? STATE_BUSY : (done_q ? STATE_DONE : STATE_IDLE));
    wire ready = !busy_q;
    wire privacy_ok = !fault_q;

    assign uo_out = ena ? {
        ready,
        busy_q,
        done_q,
        fault_q,
        pulse_up_q,
        pulse_down_q,
        verify_ok_q,
        privacy_ok
    } : 8'h00;

    assign uio_out = ena ? {attempt_q, state_code} : 8'h00;
    assign uio_oe = ena ? 8'hff : 8'h00;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            target_q <= 6'd0;
            current_q <= 6'd0;
            max_attempts_q <= 4'd4;
            attempt_q <= 4'd0;
            busy_q <= 1'b0;
            done_q <= 1'b0;
            fault_q <= 1'b0;
            pulse_up_q <= 1'b0;
            pulse_down_q <= 1'b0;
            verify_ok_q <= 1'b0;
        end else if (ena) begin
            pulse_up_q <= 1'b0;
            pulse_down_q <= 1'b0;
            verify_ok_q <= 1'b0;

            if (busy_q) begin
                if (current_q == target_q) begin
                    busy_q <= 1'b0;
                    done_q <= 1'b1;
                    verify_ok_q <= 1'b1;
                end else if (attempt_q >= max_attempts_q) begin
                    busy_q <= 1'b0;
                    done_q <= 1'b1;
                    fault_q <= 1'b1;
                end else begin
                    attempt_q <= attempt_q + 4'd1;
                    if (current_q < target_q) begin
                        current_q <= current_q + 6'd1;
                        pulse_up_q <= 1'b1;
                    end else begin
                        current_q <= current_q - 6'd1;
                        pulse_down_q <= 1'b1;
                    end
                end
            end else begin
                case (cmd)
                    CMD_NOP: begin
                    end
                    CMD_LOAD_TARGET: begin
                        target_q <= data;
                    end
                    CMD_LOAD_CURRENT: begin
                        current_q <= data;
                    end
                    CMD_CONTROL: begin
                        if (control_clear) begin
                            busy_q <= 1'b0;
                            done_q <= 1'b0;
                            fault_q <= 1'b0;
                            pulse_up_q <= 1'b0;
                            pulse_down_q <= 1'b0;
                            verify_ok_q <= 1'b0;
                            attempt_q <= 4'd0;
                        end else if (control_start) begin
                            busy_q <= 1'b1;
                            done_q <= 1'b0;
                            fault_q <= 1'b0;
                            attempt_q <= 4'd0;
                            max_attempts_q <= (control_max_attempts == 4'd0) ? 4'd1 : control_max_attempts;
                        end
                    end
                    default: begin
                    end
                endcase
            end
        end
    end
endmodule

`default_nettype wire
