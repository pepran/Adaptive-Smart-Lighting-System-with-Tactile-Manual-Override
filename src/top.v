`timescale 1ns / 1ps

module smart_lighting_top (
    input  wire clk,
    input  wire rst,         
    input  wire mode,        // 0 = Manual, 1 = Auto 
    input  wire [1:0] rot_enc,
    
    // ALS Physical Pins
    input  wire miso,        
    output wire cs,          
    output wire sclk,        
    
    // System Outputs
    output wire [7:0] count_level, 
    output wire [7:0] pmod_leds    
);

    wire [7:0] renc_count;     
    wire [7:0] als_raw_count;  
    wire       als_data_valid; 

    reg  [7:0] stable_als_val = 8'd128; 
    
    wire [7:0] target_brightness;

    // Data Catch-and-Hold Logic for the ALS
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stable_als_val <= 8'd128; 
        end else if (als_data_valid) begin
            stable_als_val <= als_raw_count;
        end
    end

    
    assign target_brightness = mode ? (8'd255 - stable_als_val) : renc_count;
    
    assign count_level = target_brightness;

    
    rotary_encoder_driver renc_inst (
        .clk(clk),
        .rot_a(rot_enc[1]),
        .rot_b(rot_enc[0]),
        .count(renc_count)
    );
    /*ila_0 ila (
	.clk(clk), // input wire clk
	.probe0(clk), // input wire [0:0]  probe0  clk
	.probe1(sclk), // input wire [0:0]  probe1  sclk
	.probe2(cs), // input wire [0:0]  probe2 cs
	.probe3(miso), // input wire [0:0]  probe3 miso
	.probe4(als_raw_count) // input wire [7:0]  probe4 ALS_data
);*/
    pmod_als_driver als_inst (
        .clk(clk),
        .reset(rst),
        .miso(miso),
        .cs(cs),
        .sclk(sclk),
        .als_data(als_raw_count),
        .data_valid(als_data_valid)
    );

    pmod8LD_driver led_drv_inst (
        .clk(clk),
        .rst(rst),
        .in(target_brightness),
        .pmod_leds(pmod_leds)
    );
    
endmodule
