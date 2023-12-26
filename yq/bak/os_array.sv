module os_array #(
    parameter integer unsigned DATA_WIDTH=8,
    parameter integer unsigned ARRAY_SIZE=4,
    parameter integer unsigned MEM_WIDTH=32
)(
    input clk,
    input rst_n,
    input enables,
    input load_en，
    //input cycle_cnt,
    input [MEM_WIDTH-1:0] din_ram_a,     //输入矩阵a32bit一行的4个元素
    input [MEM_WIDTH-1:0] din_ram_b,     //输入矩阵b32bit一列的4个元素
    input [3:0] matrix_index,
    

    output [(ARRAY_SIZE*DATA_WIDTH*2-1):0] mul_out
);


reg [DATA_WIDTH-1:0] matrix_a_queue[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
reg [DATA_WIDTH-1:0] matrix_b_queue[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
reg enable_quene[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
reg [DATA_WIDTH*2-1:0] accreg_value[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
reg [DATA_WIDTH*2-1:0] shadow_reg[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

//reg [DATA_WIDTH*2-1:0] matrix_mulout[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];




integer i,j;
always@(posedge clk or negedge rst_n)begin
    if (~rst_n)begin
        for (i=0;i<ARRAY_SIZE;i=i+1)begin
            for(j=0;j<ARRAY_SIZE;j=j+1)begin
                matrix_a_queue[i][j]<=0;
                matrix_b_queue[i][j]<=0;
                enable_queue[i][j]<=0;
            end
        end
    end
    else begin
        enable[0][0]<=enable;
        for (i=0;i<4;i=i+1)begin
            matrix_a_queue[0][i]<= din_ram_a[MEM_WIDTH-1-8*i-:8];
            matrix_b_queue[i][0]<= din_ram_b[MEM_WIDTH-1-8*i-:8];
 
        end
        
//a00/a01/a02......
        for(i=0;i<ARRAY_SIZE;i=i+1)begin
            for (j=1;j<ARRAY_SIZE;j=j+1)begin
                matrix_a_queue[i][j]<=matrix_a_queue[i][j-1];
                enable_queue[i][j]  <=enable_queue[i][j-1];
            end
        end
//b00/b10/b20.....
        for(i=1;i<ARRAY_SIZE;i=i+1)begin
            for (j=0;j<ARRAY_SIZE;j=j+1)begin
                matrix_b_queue[i][j]<=matrix_b_queue[i-1][j];
                //enable_queue[i][j]     <=enable[i][j-1];
            end
        end
    end
end

//mul_add_result
always@(*)begin
    if(enable_queue[i][j])begin
        for(i=0;i<ARRAY_SIZE;i=i+1)begin
            for(j=0;j<ARRAY_SIZE;j=j+1)begin
                accreg_value[i][j]= matrix_a_queue[i][j]*matrix_b_queue[i][j]+accreg_value[i][j];
            end
        end
    end
    else begin
        accreg_value[i][j]=0;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        for(i=0;i<ARRAY_SIZE;i=i+1)begin
            for(j=0;j<ARRAY_SIZE;j=j+1)begin
                shadow_reg[i][j]<=0;
            end
        end
    end
    else if (load_en)begin
            for(i=0;i<ARRAY_SIZE;i=i+1)begin
                for(j=0;j<ARRAY_SIZE;j=j+1)begin
                    shadow_reg[i][j]<=accreg_value[i][j];
                end
            end
        end
    end
end

//shift_en
always@(posedge clk or negedge rst_n)begin
    if (~rst_n)begin
        shift_en<=0;
    end
    else if (cycle_num>=ARRAY_SIZE+1)begin
        shift_en<=1
    end
    else begin
        shift_en<=0
    end
end


    















































endmodule
