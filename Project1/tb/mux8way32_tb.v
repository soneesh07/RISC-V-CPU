module Mux8way32_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [31:0] c;
    reg  [31:0] d;
    reg  [31:0] e;
    reg  [31:0] f;
    reg  [31:0] g;
    reg  [31:0] h;

    reg  [2:0] s;

    wire [31:0] out;

    Mux8way32 dut(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .s(s),
        .out(out)
    );

    task check;
        input [31:0] expected;
    begin
        #10;
        if(out == expected)
            $display("PASS: s=%b, out=%h", s, out);
        else
            $display("FAIL: s=%b, out=%h (expected=%h)", s, out, expected);
    end
    endtask

    initial begin

        // Give every input a different pattern

        a = 32'hAAAAAAAA;
        b = 32'hBBBBBBBB;
        c = 32'hCCCCCCCC;
        d = 32'hDDDDDDDD;
        e = 32'hEEEEEEEE;
        f = 32'hFFFFFFFF;
        g = 32'h12345678;
        h = 32'h87654321;

        // Test all 8 select values

        s = 3'b000;
        check(32'hAAAAAAAA);

        s = 3'b001;
        check(32'hBBBBBBBB);

        s = 3'b010;
        check(32'hCCCCCCCC);

        s = 3'b011;
        check(32'hDDDDDDDD);

        s = 3'b100;
        check(32'hEEEEEEEE);

        s = 3'b101;
        check(32'hFFFFFFFF);

        s = 3'b110;
        check(32'h12345678);

        s = 3'b111;
        check(32'h87654321);

        $finish;
    end

endmodule