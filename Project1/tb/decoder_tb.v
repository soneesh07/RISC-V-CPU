module Decoder_tb;
    reg [2:0] a;
    reg en;
    wire [7:0] out;

    Decoder dut(
        .a(a),
        .en(en),
        .out(out)
    );

    task check;
    input [7:0] exp;
    begin
    #10;
        if(exp == out)
            $display("PASS : a = %b, en = %b, out = %b",a,en,out);
        else
             $display("FAIL : a = %b, en = %b, out = %b(expected = %b)",a,en,out,exp);
    end
    endtask

    initial begin

    // Enable = 1 : test all 8 inputs

    en = 1'b1;

    a = 3'b000;
    check(8'b00000001);

    a = 3'b001;
    check(8'b00000010);

    a = 3'b010;
    check(8'b00000100);

    a = 3'b011;
    check(8'b00001000);

    a = 3'b100;
    check(8'b00010000);

    a = 3'b101;
    check(8'b00100000);

    a = 3'b110;
    check(8'b01000000);

    a = 3'b111;
    check(8'b10000000);


    // Enable = 0 : output must always be zero

    en = 1'b0;

    a = 3'b000;
    check(8'b00000000);

    a = 3'b001;
    check(8'b00000000);

    a = 3'b010;
    check(8'b00000000);

    a = 3'b011;
    check(8'b00000000);

    a = 3'b100;
    check(8'b00000000);

    a = 3'b101;
    check(8'b00000000);

    a = 3'b110;
    check(8'b00000000);

    a = 3'b111;
    check(8'b00000000);


    $finish;
    end
endmodule