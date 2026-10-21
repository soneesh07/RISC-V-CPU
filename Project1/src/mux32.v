module Mux32(
    input wire [31:0] a,
    input wire [31:0] b,
    input s,
    output wire [31:0] out
);


Mux16 m1(
    .a(a[15:0]),
    .b(b[15:0]),
    .s(s),
    .out(out[15:0])
);

Mux16 m2(
    .a(a[31:16]),
    .b(b[31:16]),
    .s(s),
    .out(out[31:16])
);

endmodule