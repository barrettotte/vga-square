`timescale 1ns/1ps

module top (
    input i_clk_100MHz,
    input i_reset,
    output o_hsync,
    output o_vsync,
    output [11:0] o_rgb
);

    wire w_video_on;
    wire w_tick;
    wire [9:0] w_x;
    wire [9:0] w_y;
    reg [11:0] rgb;
    wire [11:0] rgb_next;

    vga_controller vga (
        .i_clk_100MHz(i_clk_100MHz),
        .i_reset(i_reset),
        .o_video_on(w_video_on),
        .o_hsync(o_hsync),
        .o_vsync(o_vsync),
        .o_tick(w_tick),
        .o_x(w_x),
        .o_y(w_y)
    );

    square_generator square_gen (
        .i_clk(i_clk_100MHz),
        .i_reset(i_reset),
        .i_video_on(w_video_on),
        .i_x(w_x),
        .i_y(w_y),
        .o_rgb(rgb_next)
    );

    always @(posedge i_clk_100MHz) begin
        if (w_tick) begin
            rgb <= rgb_next;
        end
    end
    assign o_rgb = rgb;
    
endmodule
