`timescale 1ns / 1ps
module pmod8LD_driver(
    input [7:0] in,
    input clk,
    input rst,
    output reg [7:0] pmod_leds
    );
    reg [7:0] counter; //8 bit counter for the pwm signal
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            counter <=8'b0;
            pmod_leds <= 8'b0;
        end else begin
            counter <= counter +1;
            if(counter <= in)begin
                pmod_leds <= 8'b11111111;
            end else begin
                pmod_leds <= 8'b00000000;
            end
        end
    end
endmodule
