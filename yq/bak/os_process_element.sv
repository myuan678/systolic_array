 

module os_pe#(
    parameter integer unsigned DIN_WIDTH = 8       ,
    parameter integer unsigned ACC_WIDTH = 32
)(
    input  logic                        clk             ,
    input  logic                        rst_n           ,
    input  logic [DIN_WIDTH-1:0]        din_row         ,
    input  logic [DIN_WIDTH-1:0]        din_col         ,
    input  logic                        din_row_en      ,
    input  logic                        load_en         ,
    input  logic                        shift_en        ,
    output logic [DIN_WIDTH-1:0]        din_row_out     ,
    output logic [DIN_WIDTH-1:0]        din_col_out     ,
    output logic                        din_row_out_en  ,
    //output logic [DATA_WIDTH*2-1:0]     shadow_result   ,
    //input logic [ACC_WIDTH-1:0]     partial_in  ,
    //output reg [DATA_WIDTH*2-1:0] partial_out,

    input  logic [ACC_WIDTH-1:0]        acc_shift_in    ,
    output logic [ACC_WIDTH-1:0]        acc_shift_out   

);

    logic [ACC_WIDTH-1:0] acc_value;

    assign din_col_out      = din_col;
    assign din_row_out      = din_row;
    assign din_row_out_en   = din_row_en;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            acc_value <= {ACC_WIDTH{1'b0}};
        end
        else if(enable)begin 
            acc_value<= (din_row * din_col) + acc_value;
        end else if(load_en) begin
            acc_value <= {ACC_WIDTH{1'b0}};
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            shadow_result <= {ACC_WIDTH{1'b0}};
        end
        else if(load_en) begin
            shadow_result <= acc_value;
        end
        else if(shift_en) begin
            shadow_result <= acc_shift_in;
        end
    end

    assign acc_shift_out = shadow_result;

endmodule






// always_ff @(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin
//         //partial_out<=0;
//         //din_row_out <= {DIN_WIDTH{1'b0}};
//         //din_col_out <= {DIN_WIDTH{1'b0}};
//         enable_next <= 1'b0;
//     end
//     else begin
//         //din_row_out<=din_row;
//         //din_col_out<=din_col;
//         enable_next <= enable;
//         if(enable)begin 
//             acc_value<=din_row*din_col+acc_value;
//         end
//     end
// end// 

// always_ff @(posedge clk or negedge rst_n)begin  
//     if(!rst_n)begin
//         shadow_result<=0;
//     end
//     else if (load_en)begin
//         shadow_result<=acc_value;
//     end
//     else begin
//         shadow_result<= 0;
//     end
// end