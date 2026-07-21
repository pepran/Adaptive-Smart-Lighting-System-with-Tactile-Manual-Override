`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2026 10:51:04
// Design Name: 
// Module Name: pmod_als_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module pmod_als_driver(
    input wire clk,
    input wire reset,
    input wire miso,
    output reg sclk,
    output reg [7:0] als_data,
    output reg cs,
    output reg data_valid
    );
    
    //Clock divider to get 2MHz SCLK required by PMOD ALS 
    localparam clk_div_max = 25 - 1;
    
    //States for the Controller FSM
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter DONE = 2'b10;
    
    reg [1:0] state;
    reg [4:0] clk_counter; //to count upto 24
    reg [4:0] count; //to count to 16 to tell us when the data can be read
    reg sclk_en; //goes high when SCLK should toggle
    reg [15:0] shift_reg; 
    reg sclk_int; //tracking the SCLK based on sclk_en 
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            clk_counter <= 5'd0;
            sclk_en <= 1'd0;
        end
        else begin
            if(state == SHIFT)
            begin
                if(clk_counter == clk_div_max)
                begin
                    clk_counter <= 5'd0; //reset back to 0 once you've counter up to max
                    sclk_en <= 1'd1; //toggle SCLK
                end 
                else begin
                    clk_counter <= clk_counter + 1;
                    sclk_en <= 1'd0;
                end
            end
            else begin //if in IDLE or DONE state
                clk_counter <= 5'd0;
                sclk_en <= 1'd0;
            end
        end
    end
    
    //FSM Logic for SPI Mode 3
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            state <= IDLE;
            cs <= 1'b1;       // CS idles HIGH (inactive)
            sclk <= 1'b1;       // SPI Mode 3 idles HIGH
            sclk_int <= 1'b1;
            count <= 0;
            shift_reg <= 16'd0;
            als_data <= 8'd0;
            data_valid <= 1'b0;
        end
        else begin
        data_valid <= 1'd0; //Default value should be 0, and it should be made 1 only in DONE
        case (state)
                IDLE: begin
                    cs <= 1'b1;
                    sclk <= 1'b1;
                    sclk_int <= 1'b1;
                    count <= 0;
                    // Immediately jump to read state. Could add a delay counter for lower sampling rate
                    state <= SHIFT; 
                end

                SHIFT: begin
                    cs <= 1'b0; // Pull CS low to wake up ADC
                    if (sclk_en) begin
                        sclk_int <= ~sclk_int; // Toggle internal tracker
                        sclk <= ~sclk_int; // Push to physical output

                        if (sclk_int == 1'b1) begin
                            // sclk_int was HIGH, now going LOW -> FALLING EDGE
                            // The ADC is placing data on MISO right now. We do nothing but wait.
                        end else begin
                            // sclk_int was LOW, now going HIGH -> RISING EDGE
                            // The data on MISO is stable. We sample it.
                            shift_reg <= {shift_reg[14:0], miso}; // Shift left
                            count <= count + 1;

                            if (count == 15) begin
                                // We just sampled the 16th and final bit
                                state <= DONE;
                            end
                        end
                    end
                end

                DONE: begin
                    cs <= 1'b1;// Deactivate CS
                    sclk <= 1'b1;// Return SCLK to idle
                    als_data <= shift_reg[12:5]; // Extract the 8 data bits
                    data_valid <= 1'b1; //Send pulse to main_controller
                    state <= IDLE; // Loop back for next reading
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule