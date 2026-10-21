module Alu32(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] alu_ctrl,
    output reg [31:0] out
);

    wire [31:0] w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,a1,a2;

    Add32  add1(
        .a(a),
        .b(b),
        .sum(w1)
    );

    Not16 not1(
        .in(b[15:0]),
        .out(a1[15:0])
    );

    Not16 not2(
        .in(b[31:16]),
        .out(a1[31:16])
    );

    Add32 add2(
        .a(a1),
        .b(32'h00000001),
        .sum(a2)
    );


    Add32 sub1(
        .a(a),
        .b(a2),
        .sum(w2)
    );

    And16 and1(
        .a(a[15:0]),
        .b(b[15:0]),
        .out(w3[15:0])
    );

    And16 and2(
        .a(a[31:16]),
        .b(b[31:16]),
        .out(w3[31:16])
    );

    Or16 or1(
        .a(a[15:0]),
        .b(b[15:0]),
        .out(w4[15:0])
    );

    Or16 or2(
        .a(a[31:16]),
        .b(b[31:16]),
        .out(w4[31:16])
    );


    genvar i;
    generate
        for(i = 0; i <32;i=i+1) begin : xor_inst
        Xor xor_a(
            .a(a[i]),
            .b(b[i]),
            .out(w5[i])
        );
        end
    endgenerate

    assign w6 = a << b[4:0];
    assign w7 = a >> b[4:0];
    assign w8 = $signed(a) >>> b[4:0];
    assign w9  = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
    assign w10 = (a < b) ? 32'b1 : 32'b0;

    always @(*) begin
    case(alu_ctrl)
    4'b0000 : out = w1;
    4'b0001 : out = w2;
    4'b0010 : out = w3;
    4'b0011 : out = w4;
    4'b0100 : out = w5;
    4'b0101 : out = w6;
    4'b0110 : out = w7;
    4'b0111 : out = w8;
    4'b1000 : out = w9;
    4'b1001 : out = w10;
    default : out = 32'b0;
    endcase
    end
endmodule