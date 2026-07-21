module rotary_encoder_driver(
    input clk,          
    input rot_a,        
    input rot_b,        
    output reg [7:0] count = 8'd128 
);

    // Clock divider to create a ~1 kHz sample tick for debouncing
    reg [16:0] div_cnt = 0; //762 Hz
    always @(posedge clk) begin
        div_cnt <= div_cnt + 1;
    end
    wire sample_tick = (div_cnt == 0);

    reg [2:0] sync_a, sync_b;
    always @(posedge clk) begin
        if (sample_tick) begin // ONLY update synchronizers at 1 kHz
            sync_a <= {sync_a[1:0], rot_a};
            sync_b <= {sync_b[1:0], rot_b};
        end
    end

    wire a_state = sync_a[2];
    wire b_state = sync_b[2];
    reg a_state_prev;

    always @(posedge clk) begin
        if (sample_tick) begin // ONLY process logic at 1 kHz
            a_state_prev <= a_state;
            if (a_state != a_state_prev) begin
                if (a_state == b_state)
                    count <= count + 1'b1; //counter clkwise
                else
                    count <= count - 1'b1;
            end
        end
    end
endmodule