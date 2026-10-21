module And8way_tb;

    reg [7:0] a;
    wire out;

    And8way dut(
        .a(a),
        .out(out)
    );

    task check;
        input expected;
    begin
        #10;
        if(out == expected)
            $display("PASS: a=%b, out=%b", a, out);
        else
            $display("FAIL: a=%b, out=%b (expected=%b)", a, out, expected);
    end
    endtask

    initial begin

        a = 8'b00000000;
        check(0);

        a = 8'b11111111;
        check(1);

        a = 8'b11111110;
        check(0);

        a = 8'b01111111;
        check(0);

        a = 8'b11110111;
        check(0);

        a = 8'b10101010;
        check(0);

        a = 8'b11001111;
        check(0);

        a = 8'b11111101;
        check(0);

        $finish;
    end

endmodule