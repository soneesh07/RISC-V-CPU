module Add32(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] sum,
    output carry
);

    wire w1;
    Add16 add1(
        .a(a[15:0]),
        .b(b[15:0]),
        .sum(sum[15:0]),
        .carry(w1)
    );

    wire [15:0] w;
    assign w[0] = w1;

    genvar i;

    generate
        for(i=16;i<31;i=i+1) begin : adder_inst
        Fulladder add_impl(
        .a(a[i]),
        .b(b[i]),
        .c(w[i-16]),
        .sum(sum[i]),
        .carry(w[i-15])
    );
        end
    endgenerate

    Fulladder add_last(
        .a(a[31]),
        .b(b[31]),
        .c(w[15]),
        .sum(sum[31]),
        .carry(carry)
    );

endmodule
