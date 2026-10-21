module Mux32_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg s;
    wire [31:0] out;

    Mux32 dut(
        .a(a),
        .b(b),
        .s(s),
        .out(out)
    );

    task check;
        input [31:0] exp;
        begin
        #10
            if(out == exp)
                $display("PASS: a = %b, b= %b, s = %b, out = %b",a,b,s,out);
            else
                 $display("FAIL: a = %b, b= %b, s = %b, out = %b(expected = %b)",a,b,s,out,exp);
        end
    endtask

    initial begin

    // 1. Basic select = 0
    a = 32'hAAAAAAAA;
    b = 32'h55555555;
    s = 0;
    check(32'hAAAAAAAA);

    // 2. Basic select = 1
    s = 1;
    check(32'h55555555);

    // 3. Lower 16-bit test
    a = 32'h0000AAAA;
    b = 32'h00005555;
    s = 0;
    check(32'h0000AAAA);

    s = 1;
    check(32'h00005555);

    // 4. Upper 16-bit test
    a = 32'hAAAA0000;
    b = 32'h55550000;
    s = 0;
    check(32'hAAAA0000);

    s = 1;
    check(32'h55550000);

    // 5. Upper and lower halves completely different
    a = 32'h1234ABCD;
    b = 32'h5678EF90;
    s = 0;
    check(32'h1234ABCD);

    s = 1;
    check(32'h5678EF90);

    // 6. LSB test
    a = 32'h00000001;
    b = 32'h00000000;
    s = 0;
    check(32'h00000001);

    s = 1;
    check(32'h00000000);

    // 7. MSB test
    a = 32'h80000000;
    b = 32'h00000000;
    s = 0;
    check(32'h80000000);

    s = 1;
    check(32'h00000000);

    // 8. All zeros / all ones
    a = 32'h00000000;
    b = 32'hFFFFFFFF;
    s = 0;
    check(32'h00000000);

    s = 1;
    check(32'hFFFFFFFF);

    // 9. Input changes while select stays at 0
    s = 0;
    a = 32'h11112222;
    b = 32'h33334444;
    check(32'h11112222);

    a = 32'hAAAABBBB;
    b = 32'hCCCCDDDD;
    check(32'hAAAABBBB);

    // 10. Change unselected input (b) while s = 0
    a = 32'h12345678;
    b = 32'hAAAAAAAA;
    s = 0;
    check(32'h12345678);

    b = 32'h55555555;
    check(32'h12345678);

    // 11. Change unselected input (a) while s = 1
    a = 32'h12345678;
    b = 32'hAAAAAAAA;
    s = 1;
    check(32'hAAAAAAAA);

    a = 32'h55555555;
    check(32'hAAAAAAAA);

    // 12. Rapid select switching
    a = 32'h12345678;
    b = 32'h87654321;

    s = 0;
    check(32'h12345678);

    s = 1;
    check(32'h87654321);

    s = 0;
    check(32'h12345678);

    s = 1;
    check(32'h87654321);

    // 13. Upper/lower inversion test
    a = 32'h0000FFFF;
    b = 32'hFFFF0000;

    s = 0;
    check(32'h0000FFFF);

    s = 1;
    check(32'hFFFF0000);

    $finish;

end

endmodule