module PC(
    input [31:0] in,
    input ld,
    input inc,
    input rst,
    input clk,
    output [31:0] out
);

    wire [31:0] w2,w3,w4,w5;

    Add32 add1(
        .a(out),
        .b(32'b01),
        .sum(w2)
    );

    Mux32 mux1(
        .a(out),
        .b(w2),
        .s(inc),
        .out(w4)
    );

    Mux32 mux2(
        .a(w4),
        .b(in),
        .s(ld),
        .out(w5)
    );

    Mux32 mux3(
        .a(w5),
        .b(32'b0),
        .s(rst),
        .out(w3)
    );

    Reg32 reg1(
        .in(w3),
        .ld(1'b1),
        .clk(clk),
        .out(out)
    );

endmodule