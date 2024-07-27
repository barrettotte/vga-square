// VGA controller for 640x480 60Hz refresh rate (http://www.tinyvga.com/vga-timing/640x480@60Hz)

module vga_controller (
    input i_clk_100MHz,
    input i_reset,
    output o_video_on,
    output o_hsync,
    output o_vsync,
    output o_tick,
    output [9:0] o_x,
    output [9:0] o_y
);

    /****************************************************************************/
    // setup VGA constants for 640x480 resolution
    /****************************************************************************/

    // setup horizontal timing constants; total horizontal width is 800 pixels

    // horizontal width of visible screen in pixels
    parameter H_DA = 640;

    // horizontal front porch width in pixels
    parameter H_FP = 48;

    // horizontal back porch width in pixels
    parameter H_BP = 16;

    // horizontal retrace width in pixels
    parameter H_R = 96;

    // max value of horizontal counter = 799
    parameter H_MAX = H_DA + H_FP + H_BP + H_R - 1;

    // setup vertical timing constants; total vertical length is 525 pixels

    // vertical length of visible screen in pixels
    parameter V_DA = 480;

    // vertical front porch length in pixels
    parameter V_FP = 10;

    // vertical back porch length in pixels
    parameter V_BP = 33;

    // vertical retrace length in pixels
    parameter V_R = 2;

    // max value of vertical counter = 524
    parameter V_MAX = V_DA + V_FP + V_BP + V_R - 1;

    /****************************************************************************/
    // generate 25MHz signal from 100MHz FPGA clock
    /****************************************************************************/

    // (800 pixels/line) * (525 lines/screen) * (60 screens/s) = ~25.2M pixels/s
    reg [1:0] r_clk_25MHz;
    wire w_clk_25MHz;

    always @(posedge i_clk_100MHz or posedge i_reset) begin
        if (i_reset) begin
            r_clk_25MHz <= 0;
        end
        else begin
            r_clk_25MHz <= r_clk_25MHz + 1;
        end
    end

    assign w_clk_25MHz = (r_clk_25MHz == 0) ? 1 : 0;

    /****************************************************************************/
    // setup counters and buffers
    /****************************************************************************/

    // counters
    reg [9:0] h_count;
    reg [9:0] v_count;
    reg [9:0] h_count_next;
    reg [9:0] v_count_next;

    // output buffers
    reg v_sync;
    reg h_sync;
    wire v_sync_next;
    wire h_sync_next;

    // register controls
    always @(posedge i_clk_100MHz or posedge i_reset) begin
        if (i_reset) begin
            h_count <= 0;
            v_count <= 0;
            h_sync <= 1;
            v_sync <= 1;
        end
        else begin
            h_count <= h_count_next;
            v_count <= v_count_next;
            h_sync <= h_sync_next;
            v_sync <= v_sync_next;
        end
    end

    /****************************************************************************/
    // timing logic
    /****************************************************************************/

    // horizontal timing (line)
    always @(posedge w_clk_25MHz or posedge i_reset) begin
        if (i_reset) begin
            h_count_next = 0;
        end
        else begin
            // check for end of horizontal scan
            if (h_count == H_MAX) begin
                h_count_next = 0;
            end
            else begin
                h_count_next = h_count + 1;
            end
        end
    end

    // vertical timing (frame)
    always @(posedge w_clk_25MHz or posedge i_reset) begin
        if (i_reset) begin
            v_count_next = 0;
        end
        else begin
            // check for end of horizontal scan
            if (h_count == H_MAX) begin
                // check for end of vertical scan
                if (v_count == V_MAX) begin
                    v_count_next = 0;
                end
                else begin
                    v_count_next = v_count + 1;
                end
            end
        end
    end

    // assert when in horizontal retrace
    assign h_sync_next = (h_count >= (H_DA + H_BP) && h_count <= (H_DA + H_BP + H_R - 1));

    // assert when in vertical retrace
    assign v_sync_next = (v_count >= (V_DA + V_BP) && v_count <= (V_DA + V_BP + V_R - 1));

    /****************************************************************************/
    // set outputs
    /****************************************************************************/

    assign o_hsync = h_sync;
    assign o_vsync = v_sync;
    assign o_x = h_count;
    assign o_y = v_count;
    assign o_tick = w_clk_25MHz;

    // enabled video on/off when pixels are within visible display area (0-639, 0-479)
    assign o_video_on = ((h_count < H_DA) && (v_count < V_DA));

endmodule
