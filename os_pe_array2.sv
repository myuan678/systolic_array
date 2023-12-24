module os_pe_array #(
    parameter integer unsigned DATA_WIDTH = 8                                                           ,
    parameter integer unsigned MEM_WIDTH  = 32                                                          ,
    parameter integer unsigned ARRAY_SIZE = 4                                                           ,
    parameter integer unsigned ACC_WIDTH  = 24                                                          ,    
    parameter integer unsigned TMP_WIDTH  = 32
)(
    input  logic    clk                                                                                 ,
    input  logic    rst_n                                                                               ,
    input  logic    start                                                                               ,
    input  logic    shift_en                                                                            ,
    input  logic    [MEM_WIDTH-1:0] data_in_a                                                           ,
    input  logic    [MEM_WIDTH-1:0] data_in_b                                                           ,
    output logic    [ACC_WIDTH-1:0]  pe_shadow_result[ARRAY_SIZE-1:0][ARRAY_SIZE-1:0]
);
logic [DATA_WIDTH-1:0] matrix_a[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1]                                         ;
logic [DATA_WIDTH-1:0] matrix_b[0:ARRAY_SIZE-1][0:ARRAY_SIZE-1]                                         ;
logic [DATA_WIDTH-1:0] din_row_out[ARRAY_SIZE-1:0][ARRAY_SIZE-1:0]                                      ;
logic [DATA_WIDTH-1:0] din_col_out[ARRAY_SIZE-1:0][ARRAY_SIZE-1:0]                                      ;
logic                  acc_enable[ARRAY_SIZE-1:0][ARRAY_SIZE-1:0]                                       ;
logic                  load_en                                                                          ;



always_ff @(posedge clk or negedge rst_n) begin
    if (rst_n = 1'b0)begin
        for (i=0;i<ARRAY_SIZE;i=i+1)begin
            matrix_a[0][i] <= 0                                                                         ;
            matrix_b[i][0] <= 0                                                                         ;
        end
    end
    else if(start)begin
        for (int i = 0; i < 4; i++) begin
            matrix_a[0][i] <= data_in_a >> (8 * i) & 8'hFF                                              ; // 拆分8位数据
            matrix_b[i][0] <= data_in_b >> (8 * i) & 8'hFF                                              ;
        end
    end
end


genvar i, j;
generate
    for (i = 0; i < 4; i++) begin: array_i
        for (j = 0; j < 4; j++) begin:array_j          
            os_pe    #(
                .DATA_WIDTH(DATA_WIDTH                                                                  ),
                .ACC_WIDTH(ACC_WIDTH                                                                    ),
                .TMP_WIDTH(TMP_WIDTH                                                                    )
            ) pe_inst (
                .clk            (clk                                                                    ),
                .rst_n          (rst_n                                                                  ),
                .din_row        ((j == 0) ? matrix_a[i][0] : din_row_out[i][j-1]                        ),
                .din_col        ((i == 0) ? matrix_b[0][j] : din_col_out[i-1][j]                        ),
                .acc_enable     ((j == 0) ? (i == 0 ? start : acc_enable[i-1][j]) : acc_enable[i][j-1]  ),
                .load_en        (load_en                                                                ),
                .shadow_result  (pe_shadow_result[i][j]                                                 ),
                .din_row_out    (din_row_out[i][j]                                                      ),
                .din_col_out    (din_col_out[i][j]                                                      ),
                .acc_enable_out (acc_enable[i][j]                                                       )  
                );
        end
    end
endgenerate

always_comb begin 
    for (i = 0; i < ARRAY_SIZE; i++) begin
        if(shift_en)begin
            for (j = 0; j < ARRAY_SIZE-1; j++) begin
                pe_shadow_result[i][j] = pe_shadow_result[i][j + 1]                                    ;
            end 
        end
     end
end
endmodule