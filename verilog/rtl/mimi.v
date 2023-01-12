// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

`ifdef ENABLE_TRACE
`define TRACE 1'b1
`else
`define TRACE 1'b0
`endif

module mimi #(
    parameter PC_BITS = 10,
    parameter UC_BASE = 32'h0000200,
    parameter TRACE = `TRACE,
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // Our wishbone base is a window at 0x3000_0000
    assign valid = wbs_cyc_i && wbs_stb_i && wbs_adr_i[31:16] == 16'h3000; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    wire cpu_clk, mem_clk;
    assign cpu_clk = wb_clk_i;
    assign mem_clk = ~wb_clk_i;

    wire cpu_reset, mem_reset;
    assign cpu_reset = wb_rst_i;
    assign mem_reset = wb_rst_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    wire clk_en;
    assign clk_en = la_oenb[64];

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = 128'b0;/*{
        16'b0, inst_reg,
        32'b0,
        {(32-PC_BITS){1'b0}}, addr,
        {(32-PC_BITS){1'b0}}, inst_addr
    };*/

    // Assuming LA probes [63:32] are for controlling the count register  
    // assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = /*(~clk_en) ? la_data_in[64] : */wb_clk_i;
    assign rst = /*(~la_oenb[65]) ? la_data_in[65] : */wb_rst_i;

    reg [15:0] inst_reg;
    wire inst_regce;

    wire [PC_BITS-1:0] inst_addr;
    wire [31:0] addr, wdata;
    wire [3:0] wmask;
    wire rreq;

    wire [31:0] ram_addr;
    wire [31:0] rdata;
    reg [15:0] inst_lat;
    reg [31:0] rdata_lat;

    assign ram_addr = cpu_reset ? 32'b0 : (({32{(|rreq)}} & addr)
                                        | ({32{(~|rreq)}} & inst_addr));

    // RAM
    assign rdata =
          (rdata_bank0 & {32{(ram_addr[12:11] == 2'h0)}})
        | (rdata_bank1 & {32{(ram_addr[12:11] == 2'h1)}})
        | (rdata_bank2 & {32{(ram_addr[12:11] == 2'h2)}})
        | (rdata_bank3 & {32{(ram_addr[12:11] == 2'h3)}});

    // Bytes 0-2047
    wire [31:0] rdata_bank0;
    gf180mcu_sram_512x32 bank0 (
        .clk(mem_clk),
        .reset(mem_reset),
        .en(ram_addr[12:11] == 2'h0),
        .addr(ram_addr[10:2]),
        .rdata(rdata_bank0),
        .wdata(wdata),
        .wen(wmask == 4'hf)
    );

    // Bytes 2048-4097
    wire [31:0] rdata_bank1;
    gf180mcu_sram_512x32 bank1 (
        .clk(mem_clk),
        .reset(mem_reset),
        .en(ram_addr[12:11] == 2'h1),
        .addr(ram_addr[10:2]),
        .rdata(rdata_bank1),
        .wdata(wdata),
        .wen(wmask == 4'hf)
    );

    // Bytes 4098-6143
    wire [31:0] rdata_bank2;
    gf180mcu_sram_512x32 bank2 (
        .clk(mem_clk),
        .reset(mem_reset),
        .en(ram_addr[12:11] == 2'h2),
        .addr(ram_addr[10:2]),
        .rdata(rdata_bank2),
        .wdata(wdata),
        .wen(wmask == 4'hf)
    );

    // Bytes 6144-8191
    wire [31:0] rdata_bank3;
    gf180mcu_sram_512x32 bank3 (
        .clk(mem_clk),
        .reset(mem_reset),
        .en(ram_addr[12:11] == 2'h3),
        .addr(ram_addr[10:2]),
        .rdata(rdata_bank3),
        .wdata(wdata),
        .wen(wmask == 4'hf)
    );

    always @(posedge clk) begin
        inst_lat <= ~inst_addr[1] ? rdata[15:0] : rdata[31:16];
        rdata_lat <= rdata;
        if (inst_regce) begin
            inst_reg <= inst_lat;
        end
    end

    minimax #(
        .TRACE(TRACE),
        .PC_BITS(PC_BITS),
        .UC_BASE(UC_BASE)
    ) dut (
        .clk(clk),
        .reset(rst),
        .inst_addr(inst_addr),
        .inst(inst_reg),
        .inst_regce(inst_regce),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .wmask(wmask),
        .rreq(rreq)
    );

    // Wishbone interface
    always @(posedge clk) begin
        ack <= 1'b0;
        if (valid | ~ack) begin
            ack <= 1'b1;
        end
    end


endmodule

`default_nettype wire
