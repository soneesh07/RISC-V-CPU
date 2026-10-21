module Reg32_tb;
    reg [31:0] in;
    reg ld,clk;
    wire [31:0] out;

    Reg32 dut(
        .in(in),
        .ld(ld),
        .clk(clk),
        .out(out)
    );

    always #5 clk = ~clk;

    task check;
        input [31:0] exp;
        begin
            if(out == exp)
                $display("PASS: in = %b , load = %b, out = %b",in,ld,out);
            else
                $display("FAIL: in = %b , load = %b, out = %b(expected = %b)",in,ld,out,exp);
        end
    endtask

    initial begin
    clk = 0;

    // Initial condition
    in = 32'h00000000;
    ld = 0;

    // ------------------------------------------------
    // TC1: Load 0
    // ------------------------------------------------
    #3;
    in = 32'h00000000;
    ld = 1;

    #2;              // t = 5 -> rising edge
    #1;              // allow register to update
    check(32'h00000000);


    // ------------------------------------------------
    // TC2: Normal load of all 1s
    // ------------------------------------------------
    #5;              // t = 11
    in = 32'hFFFFFFFF;
    ld = 1;

    #4;              // t = 15 -> rising edge
    #1;
    check(32'hFFFFFFFF);


    // ------------------------------------------------
    // TC3: ld = 0 -> input changes, output must hold
    // ------------------------------------------------
    #1;              // t = 17
    ld = 0;
    in = 32'h12345678;

    #8;              // t = 25 -> rising edge
    #1;
    check(32'hFFFFFFFF);


    // ------------------------------------------------
    // TC4: Input changed before edge, but ld = 0
    // Then enable loading
    // ------------------------------------------------
    #1;              // t = 27
    ld = 1;

    #7;              // t = 34, just before rising edge
    check(32'hFFFFFFFF);

    #1;              // t = 35 -> rising edge
    #1;
    check(32'h12345678);


    // ------------------------------------------------
    // TC5: Change input immediately AFTER rising edge
    // Output must not change until next edge
    // ------------------------------------------------
    #1;              // t = 37
    in = 32'hAAAAAAAA;

    #8;              // t = 45 -> rising edge
    #1;
    check(32'hAAAAAAAA);


    // ------------------------------------------------
    // TC6: Change input just BEFORE rising edge
    // ------------------------------------------------
    #8;              // t = 54
    in = 32'h55555555;

    #1;              // t = 55 -> rising edge
    #1;
    check(32'h55555555);


    // ------------------------------------------------
    // TC7: ld = 0 before edge
    // New input must NOT load
    // ------------------------------------------------
    #1;              // t = 57
    ld = 0;
    in = 32'hDEADBEEF;

    #8;              // t = 65 -> rising edge
    #1;
    check(32'h55555555);


    // ------------------------------------------------
    // TC8: ld = 1 just before edge
    // ------------------------------------------------
    #8;              // t = 74
    in = 32'hCAFEBABE;
    ld = 1;

    #1;              // t = 75 -> rising edge
    #1;
    check(32'hCAFEBABE);


    // ------------------------------------------------
    // TC9: Different upper/lower 16-bit patterns
    // ------------------------------------------------
    #4;              // t = 80
    in = 32'hAAAA5555;

    #5;              // t = 85 -> rising edge
    #1;
    check(32'hAAAA5555);


    // ------------------------------------------------
    // TC10: Rapid input changes while ld = 0
    // Output must remain unchanged
    // ------------------------------------------------
    #1;              // t = 87
    ld = 0;
    in = 32'h11111111;

    #2;              // t = 89
    in = 32'h22222222;

    #2;              // t = 91
    in = 32'h33333333;

    #4;              // t = 95 -> rising edge
    #1;
    check(32'hAAAA5555);


    // ------------------------------------------------
    // TC11: Load after being held
    // ------------------------------------------------
    #1;              // t = 97
    ld = 1;
    in = 32'h0000FFFF;

    #8;              // t = 105 -> rising edge
    #1;
    check(32'h0000FFFF);


    // ------------------------------------------------
    // TC12: Alternating patterns
    // ------------------------------------------------
    #4;              // t = 110
    in = 32'hF0F0F0F0;

    #5;              // t = 115 -> rising edge
    #1;
    check(32'hF0F0F0F0);


    #4;              // t = 120
    in = 32'h0F0F0F0F;

    #5;              // t = 125 -> rising edge
    #1;
    check(32'h0F0F0F0F);


    $finish;
end
endmodule