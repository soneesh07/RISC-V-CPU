module Add32_tb;
    reg[31:0] a;
    reg[31:0] b;
    wire [31:0] sum;
    wire carry;

    Add32 dut(
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    task check;
        input [31:0] exp_sum;
        input exp_c;
    begin
        #10;
        if(sum == exp_sum && carry == exp_c)
            $display("PASS: a=%b, b=%b, sum = %b, carry = %b",a,b,sum,carry);
        else
            $display("FAIL: a=%b, b=%b, sum = %b(expected = %b), carry = %b(expected = %b)",a,b,sum,exp_sum,carry,exp_c);

    end
    endtask

    initial begin
            // 1. Zero + zero
    a = 32'h00000000;
    b = 32'h00000000;
    check(32'h00000000, 1'b0);

    // 2. Basic addition
    a = 32'h00000005;
    b = 32'h00000003;
    check(32'h00000008, 1'b0);

    // 3. Maximum value + zero
    a = 32'hFFFFFFFF;
    b = 32'h00000000;
    check(32'hFFFFFFFF, 1'b0);

    // 4. Carry from bit 15 into bit 16
    a = 32'h0000FFFF;
    b = 32'h00000001;
    check(32'h00010000, 1'b0);

    // 5. Carry propagating through upper half
    a = 32'h0000FFFF;
    b = 32'h00010001;
    check(32'h00020000, 1'b0);

    // 6. Carry through many bits
    a = 32'h0FFFFFFF;
    b = 32'h00000001;
    check(32'h10000000, 1'b0);

    // 7. Carry propagation through entire 32 bits
    a = 32'hFFFFFFFF;
    b = 32'h00000001;
    check(32'h00000000, 1'b1);

    // 8. Maximum + maximum
    a = 32'hFFFFFFFF;
    b = 32'hFFFFFFFF;
    check(32'hFFFFFFFE, 1'b1);

    // 9. Alternating bit patterns
    a = 32'hAAAAAAAA;
    b = 32'h55555555;
    check(32'hFFFFFFFF, 1'b0);

    // 10. Upper-half addition
    a = 32'h12340000;
    b = 32'h56780000;
    check(32'h68AC0000, 1'b0);

    // 11. Carry from lower half with upper-half addition
    a = 32'h1234FFFF;
    b = 32'h56780001;
    check(32'h68AD0000, 1'b0);

    // 12. Random-looking values
    a = 32'h12345678;
    b = 32'h87654321;
    check(32'h99999999, 1'b0);

    // 13. Input change: completely different values
    a = 32'h11112222;
    b = 32'h33334444;
    check(32'h44446666, 1'b0);

    a = 32'hAAAABBBB;
    b = 32'hCCCCDDDD;
    check(32'h77779998, 1'b1);

    // 14. Only one bit set in each operand
    a = 32'h80000000;
    b = 32'h00000001;
    check(32'h80000001, 1'b0);

    // 15. Full carry chain from bit 0 to bit 31
    a = 32'h7FFFFFFF;
    b = 32'h00000001;
    check(32'h80000000, 1'b0);

    $finish;
    end

endmodule
