module And8way(
    input wire [7:0] a,
    output wire out
);

    wire w1,w2,w3,w4,w5,w6,w7;
    And and1(
        .a(a[0]),
        .b(a[1]),
        .out(w1)
    );

    And and2(
        .a(a[2]),
        .b(w1),
        .out(w2)
    );

    And and3(
        .a(a[3]),
        .b(w2),
        .out(w3)
    );

    And and4(
        .a(a[4]),
        .b(w3),
        .out(w4)
    );

    And and5(
        .a(a[5]),
        .b(w4),
        .out(w5)
    );

    And and6(
        .a(a[6]),
        .b(w5),
        .out(w6)
    );

    And and7(
        .a(a[7]),
        .b(w6),
        .out(out)
    );

endmodule