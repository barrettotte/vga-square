module square_generator(
    input i_clk,
    input i_reset,
    input i_video_on,
    input [9:0] i_x,
    input [9:0] i_y,
    output reg [11:0] o_rgb
);

    // right border of display
    parameter X_MAX = 639;

    // bottom border of display
    parameter Y_MAX = 479;

    // square settings
    parameter SQ_RGB = 12'h0F0;
    parameter SQ_SIZE = 64;
    parameter SQ_XI = 25;
    parameter SQ_YI = 25;
    parameter SQ_VELOCITY = 1;

    // background color
    parameter BG_RGB = 12'h000;

    // square boundaries
    wire [9:0] sq_left;
    wire [9:0] sq_right;
    wire [9:0] sq_top;
    wire [9:0] sq_bottom;

    // square positions
    reg [9:0] sq_x;
    reg [9:0] sq_y;
    wire [9:0] sq_x_next;
    wire [9:0] sq_y_next;

    // square speeds
    reg [9:0] x_delta;
    reg [9:0] y_delta;
    reg [9:0] x_delta_next;
    reg [9:0] y_delta_next;

    // 60Hz refresh tick
    wire refresh_tick;
    assign refresh_tick = ((i_y == 481) && (i_x == 0)) ? 1 : 0;

    // registers
    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            sq_x <= SQ_XI;
            sq_y <= SQ_YI;
            x_delta <= SQ_VELOCITY;
            y_delta <= SQ_VELOCITY;
        end
        else begin
            sq_x <= sq_x_next;
            sq_y <= sq_y_next;
            x_delta <= x_delta_next;
            y_delta <= y_delta_next;
        end
    end

    // set square boundaries
    assign sq_left = sq_x;
    assign sq_top = sq_y;
    assign sq_right = sq_left + SQ_SIZE - 1;
    assign sq_bottom = sq_top + SQ_SIZE - 1;

    // set square status
    wire sq_on;
    assign sq_on = (sq_left <= i_x) && (i_x <= sq_right) && (sq_top <= i_y) && (i_y <= sq_bottom);

    // set next square position
    assign sq_x_next = refresh_tick ? sq_x + x_delta : sq_x;
    assign sq_y_next = refresh_tick ? sq_y + y_delta : sq_y;

    // set square velocity
    always @* begin
        x_delta_next = x_delta;
        y_delta_next = y_delta;

        if (sq_top < 1) begin
            // hit top border, start move down
            y_delta_next = SQ_VELOCITY;
        end
        else if (sq_bottom > Y_MAX) begin
            // hit bottom border, move up
            y_delta_next = 0 - SQ_VELOCITY;
        end
        else if (sq_left < 1) begin
            // hit left border, move right
            x_delta_next = SQ_VELOCITY;
        end
        else if (sq_right > X_MAX) begin
            // hit right border, move left
            x_delta_next = 0 - SQ_VELOCITY;
        end
    end

    // control RGB values
    always @* begin
        if (~i_video_on) begin
            o_rgb = 12'h000; // black for outside visible display
        end
        else begin
            o_rgb = (sq_on) ? SQ_RGB : BG_RGB;
        end
    end

endmodule
