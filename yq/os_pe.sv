module os_pe #(
    parameter integer unsigned DAT_WIDTH = 8                ,
    parameter integer unsigned ACC_WIDTH = 24               
)(
    // clk and rst
    input                               clk                 ,
    input                               rst_n               ,

    // data in
    input                               din_row_en          ,
    input           [DAT_WIDTH-1:0]     din_row             ,
    input           [DAT_WIDTH-1:0]     din_col             , 

    // data out
    output logic                        dout_row_en         ,
    output logic    [DAT_WIDTH-1:0]     dout_row            ,
    output logic    [DAT_WIDTH-1:0]     dout_col            ,

    //output shift
    input                               load_en             ,
    input                               shift_en            ,
    input           [ACC_WIDTH-1:0]     shift_dat_in        ,
    output logic    [ACC_WIDTH-1:0]     shift_dat_out       
);

    logic [ACC_WIDTH:0]     mac_res     ;
    logic [ACC_WIDTH-1:0]   acc_comb    ;
    logic [ACC_WIDTH-1:0]   acc_reg     ;

    assign dout_row_en      = din_row_en                  ;
    assign dout_row         = din_row                     ;
    assign dout_col         = din_col                     ;


    // mac
    assign mac_res          = (din_row * din_col) + acc_reg;
    assign acc_comb         = mac_res[ACC_WIDTH] ? {ACC_WIDTH{1'b1}} : mac_res[ACC_WIDTH-1:0];

    // acc reg
    always_ff @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            acc_reg <= {ACC_WIDTH{1'b0}};
        end
        else if(din_row_en) begin 
            acc_reg <= acc_comb;
        end
    end

    // shift pipeline
    always_ff @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            shift_dat_out <= {ACC_WIDTH{1'b0}};
        end
        else if (load_en) begin
            shift_dat_out <= acc_reg; 
        end 
        else if (shift_en) begin
            shift_dat_out <= shift_dat_in;
        end
    end

endmodule
