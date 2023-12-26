module os_pe#(
    parameter integer unsigned DATA_WIDTH= 8             ,
    parameter integer unsigned ACC_WIDTH = 24            ,
    parameter integer unsigned TMP_WIDTH = 32
)(
    input  logic    clk                                  ,
    input  logic    rst_n                                ,
    input  logic    [DATA_WIDTH-1:0] din_row             ,
    input  logic    [DATA_WIDTH-1:0] din_col             , 
    input  logic    acc_enable                           ,
    input  logic    load_en                              ,
    output logic    [ACC_WIDTH-1:0] shadow_result        ,
    output logic    [DATA_WIDTH-1:0] din_row_out         ,
    output logic    [DATA_WIDTH-1:0] din_col_out         ,
    output logic    acc_enable_out                        
);

logic [ACC_WIDTH-1:0]         acc_value                  ;
logic [TMP_WIDTH-1:0]         tmp_acc_value              ;

assign din_row_out        = din_row                      ;
assign din_col_out        = din_col                      ;
assign acc_enable_out     = acc_enable                   ;

always_ff@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        tmp_acc_value <= {TMP_WIDTH{1'b0}}               ;
    end
    if(acc_enable)begin 
        tmp_acc_value<=din_row*din_col+tmp_acc_value     ;
    end
end
assign acc_value = (tmp_acc_value[TMP_WIDTH:ACC_WIDTH]=={TMP_WIDTH-ACC_WIDTH}{1'b0}) ? tmp_acc_value[ACC_WIDTH-1:0] : {ACC_WIDTH-1}{1'b1};


always_ff@(posedge clk or negedge rst_n)begin  
    if(!rst_n)begin
        shadow_result   <=  {ACC_WIDTH}{1'b0}            ;
    end
    else if (load_en)begin
        shadow_result   <=  acc_value                    ; 
    end 
end

endmodule

