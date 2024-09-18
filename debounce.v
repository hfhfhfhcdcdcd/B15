module debounce(
    input wire clk, // 时钟信号
    input wire rst, // 复位信号，高电平有效
    input nedge, // 下降沿触发信号
    input pedge, // 上升沿触发信号
    input wire key_in, // 原始按键输入信号
    output reg key_out // 消抖后的按键输出信号
);

/*-------------------------------Register declaration------------------------------*/
reg [31:0] counter;
reg key_flag;//transmit a flag  to show the signal has been stabled 
reg [1:0]cur_state;//present state can represent 4 states to express the debounce process
reg [1:0]next_state;// the next state
reg [16:0]cnt;//counter to count the time
parameter max_20ms = 17'd100_000 ;
localparam IDLE = 2'd0;//IDLE state:wait the negedge to P_FILTER state
localparam P_FILTER = 2'd1;//this state is for filtering the instability
localparam WAIT_R = 2'd2;//it is now stable and wait for release the key
localparam R_FILTER = 2'd3;//it is for filter the release stability,and if it being stable then it will into IDLE state
/*-------------------------------Exchange of present state and substate----------------------------*/
always @(posedge clk or posedge rst) begin
    if (!rst) begin
        cur_state <= IDLE;
    end else begin
        cur_state<=next_state;
    end
end
/*----------------------------Switch States-------------------------------*/
always @(*) begin
    case (cur_state)
        IDLE    :begin 
            if (!nedge) begin
                next_state = cur_state;
            end else if((pedge)&&(cnt<max_20ms)) begin
                next_state = P_FILTER;
            end
        end
        P_FILTER:begin 
            if ((!pedge)&&(cnt<max_20ms)) begin
                next_state = cur_state;
            end else if (cnt>max_20ms) begin
                next_state = WAIT_R;
            end
        end
        WAIT_R  :begin 
            if (!nedge) begin
                next_state = cur_state;
            end else if((pedge)&&(cnt<max_20ms)) begin
                next_state = P_FILTER;
            end
        end
        R_FILTER:begin 

        end
        default: ;
    endcase
end

endmodule