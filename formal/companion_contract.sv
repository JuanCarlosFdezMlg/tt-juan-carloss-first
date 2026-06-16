`default_nettype none

module companion_contract_up(input wire clk);
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [4:0] cycle;

    tt_um_juan_gen1_digital_companion_tile dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial cycle = 5'd0;
    always @(posedge clk) cycle <= cycle + 5'd1;

    always @* begin
        ena = 1'b1;
        uio_in = 8'h00;
        rst_n = cycle >= 5'd2;
        ui_in = 8'h00;
        case (cycle)
            5'd2: ui_in = {2'b01, 6'd5};
            5'd3: ui_in = {2'b10, 6'd2};
            5'd4: ui_in = {2'b11, 4'd4, 2'b01};
            default: ui_in = 8'h00;
        endcase
    end

    always @* begin
        if (cycle == 5'd9) begin
            assert(uo_out == 8'hA3);
            assert(uio_out == 8'h32);
            assert(uio_oe == 8'hFF);
        end
    end
endmodule

module companion_contract_down(input wire clk);
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [4:0] cycle;

    tt_um_juan_gen1_digital_companion_tile dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial cycle = 5'd0;
    always @(posedge clk) cycle <= cycle + 5'd1;

    always @* begin
        ena = 1'b1;
        uio_in = 8'h00;
        rst_n = cycle >= 5'd2;
        ui_in = 8'h00;
        case (cycle)
            5'd2: ui_in = {2'b01, 6'd1};
            5'd3: ui_in = {2'b10, 6'd5};
            5'd4: ui_in = {2'b11, 4'd4, 2'b01};
            default: ui_in = 8'h00;
        endcase
    end

    always @* begin
        if (cycle == 5'd10) begin
            assert(uo_out == 8'hA3);
            assert(uio_out == 8'h42);
            assert(uio_oe == 8'hFF);
        end
    end
endmodule

module companion_contract_timeout_clear(input wire clk);
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [4:0] cycle;

    tt_um_juan_gen1_digital_companion_tile dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial cycle = 5'd0;
    always @(posedge clk) cycle <= cycle + 5'd1;

    always @* begin
        ena = 1'b1;
        uio_in = 8'h00;
        rst_n = cycle >= 5'd2;
        ui_in = 8'h00;
        case (cycle)
            5'd2: ui_in = {2'b01, 6'd8};
            5'd3: ui_in = {2'b10, 6'd0};
            5'd4: ui_in = {2'b11, 4'd3, 2'b01};
            5'd9: ui_in = {2'b11, 6'b000010};
            default: ui_in = 8'h00;
        endcase
    end

    always @* begin
        if (cycle == 5'd9) begin
            assert(uo_out == 8'hB0);
            assert(uio_out == 8'h33);
            assert(uio_oe == 8'hFF);
        end
        if (cycle == 5'd10) begin
            assert(uo_out == 8'h81);
            assert(uio_out == 8'h00);
            assert(uio_oe == 8'hFF);
        end
    end
endmodule

module companion_contract_clear_while_busy(input wire clk);
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [4:0] cycle;

    tt_um_juan_gen1_digital_companion_tile dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial cycle = 5'd0;
    always @(posedge clk) cycle <= cycle + 5'd1;

    always @* begin
        ena = 1'b1;
        uio_in = 8'h00;
        rst_n = cycle >= 5'd2;
        ui_in = 8'h00;
        case (cycle)
            5'd2: ui_in = {2'b01, 6'd8};
            5'd3: ui_in = {2'b10, 6'd0};
            5'd4: ui_in = {2'b11, 4'd15, 2'b01};
            5'd5: ui_in = {2'b11, 6'b000010};
            default: ui_in = 8'h00;
        endcase
    end

    always @* begin
        if (cycle == 5'd6) begin
            assert(uo_out == 8'h81);
            assert(uio_out == 8'h00);
            assert(uio_oe == 8'hFF);
        end
    end
endmodule

module companion_contract_equal_and_zero_budget(input wire clk);
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [4:0] cycle;

    tt_um_juan_gen1_digital_companion_tile dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial cycle = 5'd0;
    always @(posedge clk) cycle <= cycle + 5'd1;

    always @* begin
        ena = 1'b1;
        uio_in = 8'h00;
        rst_n = cycle >= 5'd2;
        ui_in = 8'h00;
        case (cycle)
            5'd2: ui_in = {2'b01, 6'd7};
            5'd3: ui_in = {2'b10, 6'd7};
            5'd4: ui_in = {2'b11, 4'd1, 2'b01};
            5'd7: ui_in = {2'b11, 6'b000010};
            5'd8: ui_in = {2'b01, 6'd3};
            5'd9: ui_in = {2'b10, 6'd0};
            5'd10: ui_in = {2'b11, 4'd0, 2'b01};
            default: ui_in = 8'h00;
        endcase
    end

    always @* begin
        if (cycle == 5'd6) begin
            assert(uo_out == 8'hA3);
            assert(uio_out == 8'h02);
            assert(uio_oe == 8'hFF);
        end
        if (cycle == 5'd13) begin
            assert(uo_out == 8'hB0);
            assert(uio_out == 8'h13);
            assert(uio_oe == 8'hFF);
        end
    end
endmodule

`default_nettype wire
