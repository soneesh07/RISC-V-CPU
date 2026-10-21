module Reg32(
    input wire [31:0] in,
    input ld,
    input clk,
    output wire [31:0] out
);

    Reg reg1(
        .in(in[15:0]),
        .ld(ld),
        .clk(clk),
        .out(out[15:0])
    );

    Reg reg2(
        .in(in[31:16]),
        .ld(ld),
        .clk(clk),
        .out(out[31:16])
    );

endmodule