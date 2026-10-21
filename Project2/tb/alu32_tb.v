module Alu32_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_ctrl;
    wire [31:0] out;


    Alu32 dut(
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .out(out)
    );

    task check;
    input [31:0] exp;
    begin
        #10;
        if(out == exp)
            $display("PASS : a = %b, b = %b , the control line was %b, out = %b",a,b,alu_ctrl,out);
        else
            $display("FAIL : a = %b, b = %b , the control line was %b, out = %b(expected = %b)",a,b,alu_ctrl,out,exp);
    end
    endtask

    initial begin

    // ADD

    alu_ctrl = 4'b0000;

    a = 32'h00000000; b = 32'h00000000; check(32'h00000000);
    a = 32'h00000001; b = 32'h00000001; check(32'h00000002);
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'h00000000);
    a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; check(32'hFFFFFFFE);
    a = 32'h7FFFFFFF; b = 32'h00000001; check(32'h80000000);
    a = 32'h80000000; b = 32'h80000000; check(32'h00000000);
    a = 32'h12345678; b = 32'h87654321; check(32'h99999999);


    // SUB

    alu_ctrl = 4'b0001;

    a = 32'h00000000; b = 32'h00000000; check(32'h00000000);
    a = 32'h00000005; b = 32'h00000003; check(32'h00000002);
    a = 32'h00000003; b = 32'h00000005; check(32'hFFFFFFFE);
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'hFFFFFFFE);
    a = 32'h00000000; b = 32'h00000001; check(32'hFFFFFFFF);
    a = 32'h80000000; b = 32'h00000001; check(32'h7FFFFFFF);
    a = 32'h7FFFFFFF; b = 32'hFFFFFFFF; check(32'h80000000);
    a = 32'h80000000; b = 32'h80000000; check(32'h00000000);



    // AND

    alu_ctrl = 4'b0010;

    a = 32'h00000000; b = 32'hFFFFFFFF; check(32'h00000000);
    a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; check(32'hFFFFFFFF);
    a = 32'hAAAAAAAA; b = 32'h55555555; check(32'h00000000);
    a = 32'h12345678; b = 32'h87654321; check(32'h02244220);
    a = 32'h80000000; b = 32'h80000000; check(32'h80000000);
    a = 32'h0000FFFF; b = 32'hFFFF0000; check(32'h00000000);



    // OR

    alu_ctrl = 4'b0011;

    a = 32'h00000000; b = 32'h00000000; check(32'h00000000);
    a = 32'h00000000; b = 32'hFFFFFFFF; check(32'hFFFFFFFF);
    a = 32'hAAAAAAAA; b = 32'h55555555; check(32'hFFFFFFFF);
    a = 32'h12345678; b = 32'h87654321; check(32'h97755779);
    a = 32'h80000000; b = 32'h00000000; check(32'h80000000);
    a = 32'h0000FFFF; b = 32'hFFFF0000; check(32'hFFFFFFFF);



    // XOR

    alu_ctrl = 4'b0100;

    a = 32'h00000000; b = 32'h00000000; check(32'h00000000);
    a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; check(32'h00000000);
    a = 32'hAAAAAAAA; b = 32'h55555555; check(32'hFFFFFFFF);
    a = 32'h12345678; b = 32'h87654321; check(32'h95511559);
    a = 32'h80000000; b = 32'h00000000; check(32'h80000000);



    // SLL

    alu_ctrl = 4'b0101;

    a = 32'h00000001; b = 32'h00000000; check(32'h00000001);
    a = 32'h00000001; b = 32'h00000001; check(32'h00000002);
    a = 32'h00000001; b = 32'h0000001F; check(32'h80000000);
    a = 32'h80000000; b = 32'h00000001; check(32'h00000000);
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'hFFFFFFFE);
    a = 32'h12345678; b = 32'h00000004; check(32'h23456780);
    a = 32'h80000001; b = 32'h00000010; check(32'h00010000);


    a = 32'h00000001; b = 32'h00000021; check(32'h00000002);



    // SRL

    alu_ctrl = 4'b0110;

    a = 32'h00000001; b = 32'h00000000; check(32'h00000001);
    a = 32'h00000002; b = 32'h00000001; check(32'h00000001);
    a = 32'h80000000; b = 32'h00000001; check(32'h40000000);
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'h7FFFFFFF);
    a = 32'hFFFFFFFF; b = 32'h0000001F; check(32'h00000001);
    a = 32'h80000000; b = 32'h0000001F; check(32'h00000001);
    a = 32'h12345678; b = 32'h00000004; check(32'h01234567);



    // SRA

    alu_ctrl = 4'b0111;

    a = 32'h00000001; b = 32'h00000000; check(32'h00000001);
    a = 32'h00000002; b = 32'h00000001; check(32'h00000001);
    a = 32'h80000000; b = 32'h00000001; check(32'hC0000000);
    a = 32'h80000000; b = 32'h00000004; check(32'hF8000000);
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'hFFFFFFFF);
    a = 32'hFFFFFFFF; b = 32'h0000001F; check(32'hFFFFFFFF);
    a = 32'h80000000; b = 32'h0000001F; check(32'hFFFFFFFF);
    a = 32'h7FFFFFFF; b = 32'h00000004; check(32'h07FFFFFF);
    a = 32'h12345678; b = 32'h00000004; check(32'h01234567);



    // SLT (SIGNED)

    alu_ctrl = 4'b1000;

    a = 32'h00000000; b = 32'h00000000; check(32'h00000000);
    a = 32'h00000001; b = 32'h00000002; check(32'h00000001);
    a = 32'h00000002; b = 32'h00000001; check(32'h00000000);

    // -1 < +1
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'h00000001);

    // +1 > -1
    a = 32'h00000001; b = 32'hFFFFFFFF; check(32'h00000000);

    // -2147483648 < 0
    a = 32'h80000000; b = 32'h00000000; check(32'h00000001);

    // 0 > -2147483648
    a = 32'h00000000; b = 32'h80000000; check(32'h00000000);

    // -2147483648 < -1
    a = 32'h80000000; b = 32'hFFFFFFFF; check(32'h00000001);

    // +2147483647 > -2147483648
    a = 32'h7FFFFFFF; b = 32'h80000000; check(32'h00000000);

    // Equal
    a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; check(32'h00000000);



    // SLTU (UNSIGNED)
    alu_ctrl = 4'b1001;

    a = 32'h00000000; b = 32'h00000000; check(32'h00000000);
    a = 32'h00000001; b = 32'h00000002; check(32'h00000001);
    a = 32'h00000002; b = 32'h00000001; check(32'h00000000);

    // 4294967295 > 1
    a = 32'hFFFFFFFF; b = 32'h00000001; check(32'h00000000);

    // 1 < 4294967295
    a = 32'h00000001; b = 32'hFFFFFFFF; check(32'h00000001);

    // 2147483648 > 0
    a = 32'h80000000; b = 32'h00000000; check(32'h00000000);

    // 0 < 2147483648
    a = 32'h00000000; b = 32'h80000000; check(32'h00000001);

    // 2147483648 < 4294967295
    a = 32'h80000000; b = 32'hFFFFFFFF; check(32'h00000001);

    // 4294967295 > 2147483648
    a = 32'hFFFFFFFF; b = 32'h80000000; check(32'h00000000);

    // Equal
    a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; check(32'h00000000);

    $finish;

    end

endmodule