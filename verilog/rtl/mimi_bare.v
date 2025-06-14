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

module mimi_bare #(
    parameter PC_BITS = 10,
    parameter UC_BASE = 32'h0000200,
    parameter TRACE = `TRACE,
)(
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 1.8V supply
    inout vss,	// User area 1 digital ground
`endif

    input clk,
    input rst,

    input [31:0] rdata,
    output [31:0] wdata,
    input [31:0] addr,
    output [3:0] wmask,
);
    reg ack;

    wire [31:0] wdata;

    wire cpu_clk, mem_clk;
    assign cpu_clk = wb_clk_i;
    assign mem_clk = ~wb_clk_i;

    wire cpu_reset, mem_reset;
    assign cpu_reset = wb_rst_i;
    assign mem_reset = wb_rst_i;

    reg [15:0] inst_reg;
    wire inst_regce;

    wire [PC_BITS-1:0] inst_addr;
    wire rreq;

    wire [31:0] ram_addr;
    reg [15:0] inst_lat;
    reg [31:0] rdata_lat;

    assign ram_addr = cpu_reset ? 32'b0 : (({32{(|rreq)}} & addr)
                                        | ({32{(~|rreq)}} & inst_addr));

    // RAM
    assign rdata =
          (rdata_bank1 & {32{(ram_addr[12:11] == 2'h0)}})
        | (rdata_bank2 & {32{(ram_addr[12:11] == 2'h1)}})
        | (rdata_bank3 & {32{(ram_addr[12:11] == 2'h2)}})
        | (rdata_bank4 & {32{(ram_addr[12:11] == 2'h3)}})
        ;

    always @(posedge clk)
    begin
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
    ) minimax (
`ifdef USE_POWER_PINS
        .vdd(vdd),	// User area 1 1.8V supply
        .vss(vss),	// User area 1 digital ground
`endif
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
endmodule

`default_nettype wire
