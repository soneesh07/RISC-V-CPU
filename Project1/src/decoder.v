module Decoder(
    input wire [2:0] a,
    input en,
    output reg [7:0] out
);
    wire [7:0] w2;

    wire [2:0] w3;

    Not not0(
        .in(a[0]),
        .out(w3[0])
    );

    Not not1(
        .in(a[1]),
        .out(w3[1])
    );

    Not not2(
        .in(a[2]),
        .out(w3[2])
    );
    And8way and0(
        .a({w3,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[0])
    );

    And8way and1(
        .a({w3[2:1],a[0],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[1])
    );

    And8way and2(
        .a({w3[2],w3[0],a[1],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[2])
    );

    And8way and3(
        .a({w3[2],a[1:0],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[3])
    );

    And8way and4(
        .a({w3[1:0],a[2],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[4])
    );

    And8way and5(
        .a({w3[1],a[2],a[0],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[5])
    );

    And8way and6(
        .a({a[2:1],w3[0],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[6])
    );

    And8way and7(
        .a({a[2:0],1'b1,1'b1,1'b1,1'b1,1'b1}),
        .out(w2[7])
    );

    always @(*) begin
        if(en == 0)
            out = 8'b0;
        else
            out = w2;
    end
endmodule