module Regfile(
    input wire clk,
    input wire reg_write,

    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,

    input wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);
    // sharing reg_write
    wire [7:0] a;
    wire [31:0] reg_out [0:31];

    Decoder dec1(
        .a({1'b0,rd[4:3]}),
        .en(reg_write),
        .out(a)

    );
    wire [31:0] b;
    Decoder dec2(
        .a(rd[2:0]),
        .en(a[0]),
        .out(b[7:0])
    );

    Decoder dec3(
        .a(rd[2:0]),
        .en(a[1]),
        .out(b[15:8])
    );

    Decoder dec4(
        .a(rd[2:0]),
        .en(a[2]),
        .out(b[23:16])
    );

    Decoder dec5(
        .a(rd[2:0]),
        .en(a[3]),
        .out(b[31:24])
);


    // reading operation
    wire [31:0] w1 [3:0] ;
    Mux8way32 mux1(
        .a(32'b0),
        .b(reg_out[1]),
        .c(reg_out[2]),
        .d(reg_out[3]),
        .e(reg_out[4]),
        .f(reg_out[5]),
        .g(reg_out[6]),
        .h(reg_out[7]),
        .s(rs1[2:0]),
        .out(w1[0])
    );

    Mux8way32 mux2(
        .a(reg_out[8]),
        .b(reg_out[9]),
        .c(reg_out[10]),
        .d(reg_out[11]),
        .e(reg_out[12]),
        .f(reg_out[13]),
        .g(reg_out[14]),
        .h(reg_out[15]),
        .s(rs1[2:0]),
        .out(w1[1])
    );

    Mux8way32 mux3(
        .a(reg_out[16]),
        .b(reg_out[17]),
        .c(reg_out[18]),
        .d(reg_out[19]),
        .e(reg_out[20]),
        .f(reg_out[21]),
        .g(reg_out[22]),
        .h(reg_out[23]),
        .s(rs1[2:0]),
        .out(w1[2])
    );

    Mux8way32 mux4(
        .a(reg_out[24]),
        .b(reg_out[25]),
        .c(reg_out[26]),
        .d(reg_out[27]),
        .e(reg_out[28]),
        .f(reg_out[29]),
        .g(reg_out[30]),
        .h(reg_out[31]),
        .s(rs1[2:0]),
        .out(w1[3])
    );

    Mux8way32 mux5(
        .a(w1[0]),
        .b(w1[1]),
        .c(w1[2]),
        .d(w1[3]),
        .e(32'b0),
        .f(32'b0),
        .g(32'b0),
        .h(32'b0),
        .s({1'b0, rs1[4:3]}),
        .out(read_data1)
    );

    // selecting second register
     wire [31:0] w2 [3:0] ;
    Mux8way32 mux6(
       .a(32'b0),
        .b(reg_out[1]),
        .c(reg_out[2]),
        .d(reg_out[3]),
        .e(reg_out[4]),
        .f(reg_out[5]),
        .g(reg_out[6]),
        .h(reg_out[7]),
        .s(rs2[2:0]),
        .out(w2[0])
    );

    Mux8way32 mux7(
        .a(reg_out[8]),
        .b(reg_out[9]),
        .c(reg_out[10]),
        .d(reg_out[11]),
        .e(reg_out[12]),
        .f(reg_out[13]),
        .g(reg_out[14]),
        .h(reg_out[15]),
        .s(rs2[2:0]),
        .out(w2[1])
    );

    Mux8way32 mux8(
        .a(reg_out[16]),
        .b(reg_out[17]),
        .c(reg_out[18]),
        .d(reg_out[19]),
        .e(reg_out[20]),
        .f(reg_out[21]),
        .g(reg_out[22]),
        .h(reg_out[23]),
        .s(rs2[2:0]),
        .out(w2[2])
    );

    Mux8way32 mux9(
        .a(reg_out[24]),
        .b(reg_out[25]),
        .c(reg_out[26]),
        .d(reg_out[27]),
        .e(reg_out[28]),
        .f(reg_out[29]),
        .g(reg_out[30]),
        .h(reg_out[31]),
        .s(rs2[2:0]),
        .out(w2[3])
    );

    Mux8way32 mux10(
        .a(w2[0]),
        .b(w2[1]),
        .c(w2[2]),
        .d(w2[3]),
        .e(32'b0),
        .f(32'b0),
        .g(32'b0),
        .h(32'b0),
        .s({1'b0, rs2[4:3]}),
        .out(read_data2)
    );



    // instantiating 32*32 registers

    // special zero register
    Reg32 reg0(
    .in(32'b0),
    .clk(clk),
    .ld(1'b1),
    .out(reg_out[0])
);

    genvar i;

    generate
    for(i = 1; i < 32; i = i + 1) begin : registers

        Reg32 reg_init(
            .in(write_data),
            .clk(clk),
            .ld(b[i]),
            .out(reg_out[i])
        );

    end
    endgenerate


endmodule