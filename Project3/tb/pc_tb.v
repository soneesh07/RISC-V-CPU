module Pc_tb;
    reg [31:0] in;
    reg rst;
    reg ld;
    reg clk;
    reg inc;
    wire [31:0] out;

    PC pc1(
        .in(in),
        .rst(rst),
        .ld(ld),
        .inc(inc),
        .clk(clk),
        .out(out)
    );

    always #5 clk = ~clk;

    task check;
    input [31:0] exp;
    begin
        if(out == exp)
            $display("PASS: in = %b, reset = %b, load = %b, inc =%b, out = %b",in,rst,ld,inc,out);
        else
            $display("FAIL: in = %b, reset = %b, load = %b, inc =%b, out = %b(exp = %b)",in,rst,ld,inc,out,exp);
    end
    endtask

    initial begin
    clk = 1'b0;

    // ------------------------------------------------
    // TC1: Initial reset
    // rst = 1 should force PC to 0
    // ------------------------------------------------
    in  = 32'h12345678;
    rst = 1;
    ld  = 1;
    inc = 1;

    #5;              // t = 5 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC2: Reset remains active
    // Everything else changes, but reset has priority
    // ------------------------------------------------
    #3;
    in  = 32'hAAAAAAAA;
    ld  = 0;
    inc = 0;

    #3;              // t = 12
    check(32'h00000000);

    #3;              // t = 15 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC3: Release reset, hold PC
    // rst=0, ld=0, inc=0
    // ------------------------------------------------
    #1;              // t = 17
    rst = 0;

    #7;              // t = 24, before edge
    check(32'h00000000);

    #1;              // t = 25 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC4: Load a value
    // ------------------------------------------------
    #4;              // t = 30
    in = 32'h12345678;
    ld  = 1;
    inc = 0;

    #5;              // t = 35 -> rising edge
    #1;
    check(32'h12345678);


    // ------------------------------------------------
    // TC5: Load has priority over increment
    // ld=1, inc=1
    // Should load 'in', NOT increment old PC
    // ------------------------------------------------
    #4;              // t = 40
    in  = 32'hAAAAAAAA;
    ld  = 1;
    inc = 1;

    #5;              // t = 45 -> rising edge
    #1;
    check(32'hAAAAAAAA);


    // ------------------------------------------------
    // TC6: Increment
    // ld=0, inc=1
    // ------------------------------------------------
    #4;              // t = 50
    ld  = 0;
    inc = 1;

    #5;              // t = 55 -> rising edge
    #1;
    check(32'hAAAAAAAB);


    // ------------------------------------------------
    // TC7: Increment again
    // ------------------------------------------------
    #9;              // t = 65 -> rising edge
    #1;
    check(32'hAAAAAAAC);


    // ------------------------------------------------
    // TC8: Hold
    // ld=0, inc=0
    // ------------------------------------------------
    #4;              // t = 70
    inc = 0;

    #5;              // t = 75 -> rising edge
    #1;
    check(32'hAAAAAAAC);


    // ------------------------------------------------
    // TC9: Change input while holding
    // Input must NOT affect PC
    // ------------------------------------------------
    #1;              // t = 77
    in = 32'h55555555;

    #8;              // t = 85 -> rising edge
    #1;
    check(32'hAAAAAAAC);


    // ------------------------------------------------
    // TC10: Load just before rising edge
    // ------------------------------------------------
    #8;              // t = 94
    in = 32'hCAFEBABE;
    ld  = 1;

    #1;              // t = 95 -> rising edge
    #1;
    check(32'hCAFEBABE);


    // ------------------------------------------------
    // TC11: Change input immediately AFTER edge
    // PC should retain loaded value
    // ------------------------------------------------
    #1;              // t = 97
    in = 32'hDEADBEEF;
    ld  = 0;
    inc = 0;

    #8;              // t = 105 -> rising edge
    #1;
    check(32'hCAFEBABE);


    // ------------------------------------------------
    // TC12: RESET priority over LOAD
    // rst=1, ld=1
    // Must reset, NOT load
    // ------------------------------------------------
    #4;              // t = 110
    rst = 1;
    ld  = 1;
    in  = 32'hFFFFFFFF;

    #5;              // t = 115 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC13: RESET priority over INCREMENT
    // rst=1, inc=1
    // Must reset, NOT increment
    // ------------------------------------------------
    #4;              // t = 120
    ld  = 0;
    inc = 1;

    #5;              // t = 125 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC14: RESET priority over BOTH LOAD and INC
    // rst=1, ld=1, inc=1
    // ------------------------------------------------
    #4;              // t = 130
    rst = 1;
    ld  = 1;
    inc = 1;
    in  = 32'hFACEB00C;

    #5;              // t = 135 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC15: Release reset and load FFFFFFFF
    // ------------------------------------------------
    #4;              // t = 140
    rst = 0;
    ld  = 1;
    inc = 0;
    in  = 32'hFFFFFFFF;

    #5;              // t = 145 -> rising edge
    #1;
    check(32'hFFFFFFFF);


    // ------------------------------------------------
    // TC16: Increment overflow
    // FFFFFFFF + 1 = 00000000
    // ------------------------------------------------
    #4;              // t = 150
    ld  = 0;
    inc = 1;

    #5;              // t = 155 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC17: Increment from zero
    // ------------------------------------------------
    #9;              // t = 165 -> rising edge
    #1;
    check(32'h00000001);


    // ------------------------------------------------
    // TC18: Load zero
    // ------------------------------------------------
    #4;              // t = 170
    in  = 32'h00000000;
    ld  = 1;
    inc = 0;

    #5;              // t = 175 -> rising edge
    #1;
    check(32'h00000000);


    // ------------------------------------------------
    // TC19: Load and increment interaction
    // ld=1 must win over inc=1
    // ------------------------------------------------
    #4;              // t = 180
    in  = 32'h00000010;
    ld  = 1;
    inc = 1;

    #5;              // t = 185 -> rising edge
    #1;
    check(32'h00000010);


    // ------------------------------------------------
    // TC20: Final hold
    // ------------------------------------------------
    #4;              // t = 190
    ld  = 0;
    inc = 0;

    #5;              // t = 195 -> rising edge
    #1;
    check(32'h00000010);


    $finish;
end
endmodule