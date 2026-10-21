module Mux8way32(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    input wire [31:0] e,
    input wire [31:0] f,
    input wire [31:0] g,
    input wire [31:0] h,
    input wire [2:0] s,
    output wire [31:0] out
);


    Mux8way16 mux1(
        .a(a[15:0]),
        .b(b[15:0]),
        .c(c[15:0]),
        .d(d[15:0]),
        .e(e[15:0]),
        .f(f[15:0]),
        .g(g[15:0]),
        .h(h[15:0]),
        .s(s),
        .out(out[15:0])
    );

    Mux8way16 mux2(
        .a(a[31:16]),
        .b(b[31:16]),
        .c(c[31:16]),
        .d(d[31:16]),
        .e(e[31:16]),
        .f(f[31:16]),
        .g(g[31:16]),
        .h(h[31:16]),
        .s(s),
        .out(out[31:16])
    );

endmodule
