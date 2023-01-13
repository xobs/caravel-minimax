`default_nettype none

module minimax_rf (
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 1.8V supply
    inout vss,	// User area 1 digital ground
`endif

    input clk,
    input [4:0] addrS,
    input [4:0] addrD,
    input [31:0] new_value,
    input we,
    input rS_microcode,
    input rD_microcode,
    output [31:0] rS,
    output [31:0] rD
);

  reg [31:0] execution_register_file[31:0];
  reg [31:0] microcode_register_file[31:0];

  assign rS = rS_microcode ? microcode_register_file[addrS] : execution_register_file[addrS];
  assign rD = rD_microcode ? microcode_register_file[addrD] : execution_register_file[addrD];

  always @(posedge clk) begin
    // writeback
    if ((|addrD) & we) begin
        if (rD_microcode) begin
            microcode_register_file[addrD] <= new_value;
        end else begin
            execution_register_file[addrD] <= new_value;
        end
    end
  end

  initial begin
    microcode_register_file[31] = 32'b00000000000000000000000000000000;
    microcode_register_file[30] = 32'b00000000000000000000000000000000;
    microcode_register_file[29] = 32'b00000000000000000000000000000000;
    microcode_register_file[28] = 32'b00000000000000000000000000000000;
    microcode_register_file[27] = 32'b00000000000000000000000000000000;
    microcode_register_file[26] = 32'b00000000000000000000000000000000;
    microcode_register_file[25] = 32'b00000000000000000000000000000000;
    microcode_register_file[24] = 32'b00000000000000000000000000000000;
    microcode_register_file[23] = 32'b00000000000000000000000000000000;
    microcode_register_file[22] = 32'b00000000000000000000000000000000;
    microcode_register_file[21] = 32'b00000000000000000000000000000000;
    microcode_register_file[20] = 32'b00000000000000000000000000000000;
    microcode_register_file[19] = 32'b00000000000000000000000000000000;
    microcode_register_file[18] = 32'b00000000000000000000000000000000;
    microcode_register_file[17] = 32'b00000000000000000000000000000000;
    microcode_register_file[16] = 32'b00000000000000000000000000000000;
    microcode_register_file[15] = 32'b00000000000000000000000000000000;
    microcode_register_file[14] = 32'b00000000000000000000000000000000;
    microcode_register_file[13] = 32'b00000000000000000000000000000000;
    microcode_register_file[12] = 32'b00000000000000000000000000000000;
    microcode_register_file[11] = 32'b00000000000000000000000000000000;
    microcode_register_file[10] = 32'b00000000000000000000000000000000;
    microcode_register_file[9] = 32'b00000000000000000000000000000000;
    microcode_register_file[8] = 32'b00000000000000000000000000000000;
    microcode_register_file[7] = 32'b00000000000000000000000000000000;
    microcode_register_file[6] = 32'b00000000000000000000000000000000;
    microcode_register_file[5] = 32'b00000000000000000000000000000000;
    microcode_register_file[4] = 32'b00000000000000000000000000000000;
    microcode_register_file[3] = 32'b00000000000000000000000000000000;
    microcode_register_file[2] = 32'b00000000000000000000000000000000;
    microcode_register_file[1] = 32'b00000000000000000000000000000000;
    microcode_register_file[0] = 32'b00000000000000000000000000000000;
  
    execution_register_file[31] = 32'b00000000000000000000000000000000;
    execution_register_file[30] = 32'b00000000000000000000000000000000;
    execution_register_file[29] = 32'b00000000000000000000000000000000;
    execution_register_file[28] = 32'b00000000000000000000000000000000;
    execution_register_file[27] = 32'b00000000000000000000000000000000;
    execution_register_file[26] = 32'b00000000000000000000000000000000;
    execution_register_file[25] = 32'b00000000000000000000000000000000;
    execution_register_file[24] = 32'b00000000000000000000000000000000;
    execution_register_file[23] = 32'b00000000000000000000000000000000;
    execution_register_file[22] = 32'b00000000000000000000000000000000;
    execution_register_file[21] = 32'b00000000000000000000000000000000;
    execution_register_file[20] = 32'b00000000000000000000000000000000;
    execution_register_file[19] = 32'b00000000000000000000000000000000;
    execution_register_file[18] = 32'b00000000000000000000000000000000;
    execution_register_file[17] = 32'b00000000000000000000000000000000;
    execution_register_file[16] = 32'b00000000000000000000000000000000;
    execution_register_file[15] = 32'b00000000000000000000000000000000;
    execution_register_file[14] = 32'b00000000000000000000000000000000;
    execution_register_file[13] = 32'b00000000000000000000000000000000;
    execution_register_file[12] = 32'b00000000000000000000000000000000;
    execution_register_file[11] = 32'b00000000000000000000000000000000;
    execution_register_file[10] = 32'b00000000000000000000000000000000;
    execution_register_file[9] = 32'b00000000000000000000000000000000;
    execution_register_file[8] = 32'b00000000000000000000000000000000;
    execution_register_file[7] = 32'b00000000000000000000000000000000;
    execution_register_file[6] = 32'b00000000000000000000000000000000;
    execution_register_file[5] = 32'b00000000000000000000000000000000;
    execution_register_file[4] = 32'b00000000000000000000000000000000;
    execution_register_file[3] = 32'b00000000000000000000000000000000;
    execution_register_file[2] = 32'b00000000000000000000000000000000;
    execution_register_file[1] = 32'b00000000000000000000000000000000;
    execution_register_file[0] = 32'b00000000000000000000000000000000;
  end

`ifdef ENABLE_REGISTER_INSPECTION
  // Wires that make it easier to inspect the register file during simulation
  wire [31:0] cpu_x0;
  wire [31:0] cpu_x1;
  wire [31:0] cpu_x2;
  wire [31:0] cpu_x3;
  wire [31:0] cpu_x4;
  wire [31:0] cpu_x5;
  wire [31:0] cpu_x6;
  wire [31:0] cpu_x7;
  wire [31:0] cpu_x8;
  wire [31:0] cpu_x9;
  wire [31:0] cpu_x10;
  wire [31:0] cpu_x11;
  wire [31:0] cpu_x12;
  wire [31:0] cpu_x13;
  wire [31:0] cpu_x14;
  wire [31:0] cpu_x15;
  wire [31:0] cpu_x16;
  wire [31:0] cpu_x17;
  wire [31:0] cpu_x18;
  wire [31:0] cpu_x19;
  wire [31:0] cpu_x20;
  wire [31:0] cpu_x21;
  wire [31:0] cpu_x22;
  wire [31:0] cpu_x23;
  wire [31:0] cpu_x24;
  wire [31:0] cpu_x25;
  wire [31:0] cpu_x26;
  wire [31:0] cpu_x27;
  wire [31:0] cpu_x28;
  wire [31:0] cpu_x29;
  wire [31:0] cpu_x30;
  wire [31:0] cpu_x31;

  wire [31:0] uc_x0;
  wire [31:0] uc_x1;
  wire [31:0] uc_x2;
  wire [31:0] uc_x3;
  wire [31:0] uc_x4;
  wire [31:0] uc_x5;
  wire [31:0] uc_x6;
  wire [31:0] uc_x7;
  wire [31:0] uc_x8;
  wire [31:0] uc_x9;
  wire [31:0] uc_x10;
  wire [31:0] uc_x11;
  wire [31:0] uc_x12;
  wire [31:0] uc_x13;
  wire [31:0] uc_x14;
  wire [31:0] uc_x15;
  wire [31:0] uc_x16;
  wire [31:0] uc_x17;
  wire [31:0] uc_x18;
  wire [31:0] uc_x19;
  wire [31:0] uc_x20;
  wire [31:0] uc_x21;
  wire [31:0] uc_x22;
  wire [31:0] uc_x23;
  wire [31:0] uc_x24;
  wire [31:0] uc_x25;
  wire [31:0] uc_x26;
  wire [31:0] uc_x27;
  wire [31:0] uc_x28;
  wire [31:0] uc_x29;
  wire [31:0] uc_x30;
  wire [31:0] uc_x31;

  assign cpu_x0 = execution_register_file[0];
  assign cpu_x1 = execution_register_file[1];
  assign cpu_x2 = execution_register_file[2];
  assign cpu_x3 = execution_register_file[3];
  assign cpu_x4 = execution_register_file[4];
  assign cpu_x5 = execution_register_file[5];
  assign cpu_x6 = execution_register_file[6];
  assign cpu_x7 = execution_register_file[7];
  assign cpu_x8 = execution_register_file[8];
  assign cpu_x9 = execution_register_file[9];
  assign cpu_x10 = execution_register_file[10];
  assign cpu_x11 = execution_register_file[11];
  assign cpu_x12 = execution_register_file[12];
  assign cpu_x13 = execution_register_file[13];
  assign cpu_x14 = execution_register_file[14];
  assign cpu_x15 = execution_register_file[15];
  assign cpu_x16 = execution_register_file[16];
  assign cpu_x17 = execution_register_file[17];
  assign cpu_x18 = execution_register_file[18];
  assign cpu_x19 = execution_register_file[19];
  assign cpu_x20 = execution_register_file[20];
  assign cpu_x21 = execution_register_file[21];
  assign cpu_x22 = execution_register_file[22];
  assign cpu_x23 = execution_register_file[23];
  assign cpu_x24 = execution_register_file[24];
  assign cpu_x25 = execution_register_file[25];
  assign cpu_x26 = execution_register_file[26];
  assign cpu_x27 = execution_register_file[27];
  assign cpu_x28 = execution_register_file[28];
  assign cpu_x29 = execution_register_file[29];
  assign cpu_x30 = execution_register_file[30];
  assign cpu_x31 = execution_register_file[31];

  assign uc_x0 = microcode_register_file[0];
  assign uc_x1 = microcode_register_file[1];
  assign uc_x2 = microcode_register_file[2];
  assign uc_x3 = microcode_register_file[3];
  assign uc_x4 = microcode_register_file[4];
  assign uc_x5 = microcode_register_file[5];
  assign uc_x6 = microcode_register_file[6];
  assign uc_x7 = microcode_register_file[7];
  assign uc_x8 = microcode_register_file[8];
  assign uc_x9 = microcode_register_file[9];
  assign uc_x10 = microcode_register_file[10];
  assign uc_x11 = microcode_register_file[11];
  assign uc_x12 = microcode_register_file[12];
  assign uc_x13 = microcode_register_file[13];
  assign uc_x14 = microcode_register_file[14];
  assign uc_x15 = microcode_register_file[15];
  assign uc_x16 = microcode_register_file[16];
  assign uc_x17 = microcode_register_file[17];
  assign uc_x18 = microcode_register_file[18];
  assign uc_x19 = microcode_register_file[19];
  assign uc_x20 = microcode_register_file[20];
  assign uc_x21 = microcode_register_file[21];
  assign uc_x22 = microcode_register_file[22];
  assign uc_x23 = microcode_register_file[23];
  assign uc_x24 = microcode_register_file[24];
  assign uc_x25 = microcode_register_file[25];
  assign uc_x26 = microcode_register_file[26];
  assign uc_x27 = microcode_register_file[27];
  assign uc_x28 = microcode_register_file[28];
  assign uc_x29 = microcode_register_file[29];
  assign uc_x30 = microcode_register_file[30];
  assign uc_x31 = microcode_register_file[31];
`endif // `ifdef ENABLE_REGISTER_INSPECTION

endmodule
