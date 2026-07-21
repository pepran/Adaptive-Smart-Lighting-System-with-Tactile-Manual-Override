`timescale 1ns / 1ps

module clk_divider(
    input clk,
    output slclk
    );
    reg [1:0] count;
    always @(posedge clk)begin
        count = count + 2'b01;
    end
    wire slclk = count [1];
endmodule
