module CS(
  input                                 clk, 
  input                                 reset,
  input                           [7:0] X,
  output reg                      [9:0] Y
);

reg [7:0] buffer [0:8];
reg [7:0] appr;
reg [11:0] sum;

always@(posedge clk or posedge reset)begin
    if(reset)begin
        buffer[0] <= 0;
        buffer[1] <= 0;
        buffer[2] <= 0;
        buffer[3] <= 0;
        buffer[4] <= 0;
        buffer[5] <= 0;
        buffer[6] <= 0;
        buffer[7] <= 0;
        buffer[8] <= 0;
    end
    else begin
        buffer[0] <= buffer[1];
        buffer[1] <= buffer[2];
        buffer[2] <= buffer[3];
        buffer[3] <= buffer[4];
        buffer[4] <= buffer[5];
        buffer[5] <= buffer[6];
        buffer[6] <= buffer[7];
        buffer[7] <= buffer[8];
        buffer[8] <= X;
    end
end

always@(*)begin
    sum = buffer[0] + buffer[1] + buffer[2] + buffer[3] + buffer[4] + buffer[5] + buffer[6] + buffer[7] + buffer[8]; 

    appr = 0;
    appr = ((((buffer[0] << 3) + buffer[0]) <= sum) && (buffer[0] > appr))?buffer[0]:appr;
    appr = ((((buffer[1] << 3) + buffer[1]) <= sum) && (buffer[1] > appr))?buffer[1]:appr;
    appr = ((((buffer[2] << 3) + buffer[2]) <= sum) && (buffer[2] > appr))?buffer[2]:appr;
    appr = ((((buffer[3] << 3) + buffer[3]) <= sum) && (buffer[3] > appr))?buffer[3]:appr;
    appr = ((((buffer[4] << 3) + buffer[4]) <= sum) && (buffer[4] > appr))?buffer[4]:appr;
    appr = ((((buffer[5] << 3) + buffer[5]) <= sum) && (buffer[5] > appr))?buffer[5]:appr;
    appr = ((((buffer[6] << 3) + buffer[6]) <= sum) && (buffer[6] > appr))?buffer[6]:appr;
    appr = ((((buffer[7] << 3) + buffer[7]) <= sum) && (buffer[7] > appr))?buffer[7]:appr;
    appr = ((((buffer[8] << 3) + buffer[8]) <= sum) && (buffer[8] > appr))?buffer[8]:appr;    
    
    Y = ((sum) + ((appr << 3) + appr)) >> 3 ;
end

endmodule
