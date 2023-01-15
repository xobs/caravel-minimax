// Tie 
module gf180mcu_sram_512x32(
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 1.8V supply
    inout vss,	// User area 1 digital ground
`endif
    input  clk,
    input  reset,
    input  en,
    input  [8:0] addr,
    output [31:0] rdata,
    input  [31:0] wdata,
    input  wen);

    wire [7:0] wen_mask;
    reg was_reset;

    assign wen_mask = {8{~wen}};

    reg was_en;
    wire cen;

    // want: If `en` is 1, then when clk is high we should transition
    // high->low then low->high

    assign cen = ~(en & ~was_en | clk);
    always @(posedge clk) begin
        if (reset)
            was_en <= 1'b0;
        else
            was_en <= ~cen;
    end

    gf180mcu_fd_ip_sram__sram512x8m8wm1 ram1 (
        .CLK(clk),
        .CEN(cen),
        .GWEN(~wen),
        .WEN(wen_mask),
        .A(addr),
        .D(wdata[7:0]),
        .Q(rdata[7:0]),
`ifdef USE_POWER_PINS
	    .VDD(vdd),
	    .VSS(vss)
`else
	    .VDD(1'b1),
	    .VSS(1'b0)
`endif
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 ram2 (
        .CLK(clk),
        .CEN(cen),
        .GWEN(~wen),
        .WEN(wen_mask),
        .A(addr),
        .D(wdata[15:8]),
        .Q(rdata[15:8]),
`ifdef USE_POWER_PINS
	    .VDD(vdd),
	    .VSS(vss)
`else
	    .VDD(1'b1),
	    .VSS(1'b0)
`endif
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 ram3 (
        .CLK(clk),
        .CEN(cen),
        .GWEN(~wen),
        .WEN(wen_mask),
        .A(addr),
        .D(wdata[23:16]),
        .Q(rdata[23:16]),
`ifdef USE_POWER_PINS
	    .VDD(vdd),
	    .VSS(vss)
`else
	    .VDD(1'b1),
	    .VSS(1'b0)
`endif
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 ram4 (
        .CLK(clk),
        .CEN(cen),
        .GWEN(~wen),
        .WEN(wen_mask),
        .A(addr),
        .D(wdata[31:24]),
        .Q(rdata[31:24]),
`ifdef USE_POWER_PINS
	    .VDD(vdd),
	    .VSS(vss)
`else
	    .VDD(1'b1),
	    .VSS(1'b0)
`endif
    );

endmodule

(*blackbox*)
module gf180mcu_fd_ip_sram__sram512x8m8wm1 (
    input           CLK,
    input           CEN,    //Chip Enable
    input           GWEN,   //Global Write Enable
    input   [8:0]  	WEN,    //Write Enable
    input   [8:0]   A,
    input   [8:0]  	D,
    output	[8:0]	Q,
    inout		VDD,
    inout		VSS
);
endmodule
