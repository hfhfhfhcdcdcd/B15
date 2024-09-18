module debounce(
    input wire clk, // 时钟信号
    input wire rst, // 复位信号，高电平有效
    input wire key_in, // 原始按键输入信号
    output reg key_out // 消抖后的按键输出信号
);

// 定义一个计数器，用于记录按键抖动的时间
reg [31:0] counter;

// 当按键抖动时，计数器清零
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
    end else begin
        if (key_in == 1'b1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// 当计数器达到一定值时，认为按键稳定，输出高电平
always @(posedge clk or posedge rst) begin
    if (rst) begin
        key_out <= 1'b0;
    end else begin
        if (counter >= 10) begin
            key_out <= 1'b1;
        end else begin
            key_out <= 1'b0;
        end
    end
end

endmodule