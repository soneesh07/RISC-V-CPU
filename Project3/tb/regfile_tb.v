module RegFile_tb;

    reg clk;
    reg reg_write;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    Regfile dut(
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock
    always #5 clk = ~clk;

    task check;
        input [31:0] expected1;
        input [31:0] expected2;
    begin
        #1;
        if(read_data1 == expected1 && read_data2 == expected2)
            $display("PASS: rs1=%d rs2=%d | read1=%h read2=%h",
                     rs1, rs2, read_data1, read_data2);
        else
            $display("FAIL: rs1=%d rs2=%d | read1=%h (expected %h) | read2=%h (expected %h)",
                     rs1, rs2, read_data1, expected1,
                     read_data2, expected2);
    end
    endtask

    initial begin

    clk = 0;
    reg_write = 0;
    rs1 = 0;
    rs2 = 0;
    rd = 0;
    write_data = 0;

    // =========================================================
    // 1. x0 must always read zero
    // =========================================================

    rs1 = 5'd0;
    rs2 = 5'd0;

    check(32'h00000000, 32'h00000000);


    // =========================================================
    // 2. Write x1
    // =========================================================

    reg_write = 1;
    rd = 5'd1;
    write_data = 32'h12345678;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd1;
    rs2 = 5'd0;

    check(32'h12345678, 32'h00000000);


    // =========================================================
    // 3. Write x31 (upper boundary)
    // =========================================================

    reg_write = 1;
    rd = 5'd31;
    write_data = 32'hDEADBEEF;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd31;
    rs2 = 5'd1;

    check(32'hDEADBEEF, 32'h12345678);


    // =========================================================
    // 4. Write x15 (lower group boundary)
    // =========================================================

    reg_write = 1;
    rd = 5'd15;
    write_data = 32'hAAAAAAAA;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd15;
    rs2 = 5'd31;

    check(32'hAAAAAAAA, 32'hDEADBEEF);


    // =========================================================
    // 5. Write x16 (upper group boundary)
    // =========================================================

    reg_write = 1;
    rd = 5'd16;
    write_data = 32'h55555555;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd16;
    rs2 = 5'd15;

    check(32'h55555555, 32'hAAAAAAAA);


    // =========================================================
    // 6. Simultaneous read from two different registers
    // =========================================================

    rs1 = 5'd1;
    rs2 = 5'd16;

    check(32'h12345678, 32'h55555555);


    // =========================================================
    // 7. Overwrite x1
    // =========================================================

    reg_write = 1;
    rd = 5'd1;
    write_data = 32'hCAFEBABE;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd1;
    rs2 = 5'd16;

    check(32'hCAFEBABE, 32'h55555555);


    // =========================================================
    // 8. reg_write = 0 → register must hold its value
    // =========================================================

    reg_write = 0;
    rd = 5'd1;
    write_data = 32'hFFFFFFFF;

    @(posedge clk);
    #1;

    rs1 = 5'd1;
    rs2 = 5'd16;

    check(32'hCAFEBABE, 32'h55555555);


    // =========================================================
    // 9. Attempt to write x0
    // =========================================================

    reg_write = 1;
    rd = 5'd0;
    write_data = 32'hFFFFFFFF;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd0;
    rs2 = 5'd1;

    check(32'h00000000, 32'hCAFEBABE);


    // =========================================================
    // 10. x0 must remain zero after another attempted write
    // =========================================================

    reg_write = 1;
    rd = 5'd0;
    write_data = 32'h12345678;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd0;
    rs2 = 5'd0;

    check(32'h00000000, 32'h00000000);


    // =========================================================
    // 11. Check x1 and x31 again
    // =========================================================

    rs1 = 5'd1;
    rs2 = 5'd31;

    check(32'hCAFEBABE, 32'hDEADBEEF);


    // =========================================================
    // 12. Check x15 and x16 again
    // =========================================================

    rs1 = 5'd15;
    rs2 = 5'd16;

    check(32'hAAAAAAAA, 32'h55555555);


    // =========================================================
    // 13. Write x8
    // =========================================================

    reg_write = 1;
    rd = 5'd8;
    write_data = 32'h00000001;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd8;
    rs2 = 5'd1;

    check(32'h00000001, 32'hCAFEBABE);


    // =========================================================
    // 14. Write x23
    // =========================================================

    reg_write = 1;
    rd = 5'd23;
    write_data = 32'h80000000;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd23;
    rs2 = 5'd8;

    check(32'h80000000, 32'h00000001);


    // =========================================================
    // 15. Write all-zeros to a register
    // =========================================================

    reg_write = 1;
    rd = 5'd20;
    write_data = 32'h00000000;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd20;
    rs2 = 5'd23;

    check(32'h00000000, 32'h80000000);


    // =========================================================
    // 16. Write all-ones to a register
    // =========================================================

    reg_write = 1;
    rd = 5'd21;
    write_data = 32'hFFFFFFFF;

    @(posedge clk);
    #1;

    reg_write = 0;
    rs1 = 5'd21;
    rs2 = 5'd20;

    check(32'hFFFFFFFF, 32'h00000000);


    // =========================================================
    // 17. Simultaneous read of x0 and x31
    // =========================================================

    rs1 = 5'd0;
    rs2 = 5'd31;

    check(32'h00000000, 32'hDEADBEEF);


    // =========================================================
    // 18. Simultaneous read of x31 and x0
    // =========================================================

    rs1 = 5'd31;
    rs2 = 5'd0;

    check(32'hDEADBEEF, 32'h00000000);


    // =========================================================
    // 19. Change read addresses without writing
    // =========================================================

    reg_write = 0;

    rs1 = 5'd8;
    rs2 = 5'd21;

    check(32'h00000001, 32'hFFFFFFFF);

    rs1 = 5'd23;
    rs2 = 5'd15;

    check(32'h80000000, 32'hAAAAAAAA);


    // =========================================================
    // 20. Final x0 verification
    // =========================================================

    rs1 = 5'd0;
    rs2 = 5'd0;

    check(32'h00000000, 32'h00000000);


    $finish;

    end

endmodule