

module os_pe_array #(
    parameter integer unsigned DAT_WIDTH = 8                ,
    parameter integer unsigned ACC_WIDTH = 24               ,
    parameter integer unsigned ROW_NUM   = 4                ,
    parameter integer unsigned COL_NUM   = 3
) (
    // clk and rst
    input                               clk                             ,
    input                               rst_n                           ,

    // data in
    input           [ROW_NUM-1:0]       v_din_row_en                    ,
    input           [DAT_WIDTH-1:0]     v_din_row       [ROW_NUM-1:0]   ,
    input           [DAT_WIDTH-1:0]     v_din_col       [ROW_NUM-1:0]   , 

    input                               load_en                         ,
    input                               shift_en                        ,
    output logic    [ACC_WIDTH-1:0]     v_shift_dat_out [ROW_NUM-1:0]
);

    logic                     vv_dat_h_en   [ROW_NUM:0][COL_NUM:0];
    logic [DAT_WIDTH-1:0]     vv_dat_h      [ROW_NUM:0][COL_NUM:0];
    logic [DAT_WIDTH-1:0]     vv_dat_v      [ROW_NUM:0][COL_NUM:0];
    logic [ACC_WIDTH-1:0]     vv_shift_dat  [ROW_NUM:0][COL_NUM:0];

    generate for(genvar row=0 ; row<ROW_NUM ; row=row+1) begin
        assign vv_dat_h_en[row][0]      = v_din_row_en[row]             ; 
        assign vv_dat_h[row][0]         = v_din_row[row]                ;
        assign v_shift_dat_out[row]     = vv_shift_dat[row][COL_NUM]    ;
        assign vv_shift_dat[row][0]     = {ACC_WIDTH{1'b0}}             ;
    end endgenerate

    generate for(genvar col=0 ; col<COL_NUM ; col=col+1) begin
        assign vv_dat_v[0][col]         = v_din_col[col]                ;
    end endgenerate


    generate 
        for(genvar row=0 ; row<ROW_NUM ; row=row+1) begin
            for(genvar col=0 ; col<COL_NUM ; col=col+1) begin
                os_pe #(
                    .DAT_WIDTH(DAT_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH))
                u_pe(
                    // clk and rst
                    .clk           (clk                         ),
                    .rst_n         (rst_n                       ),
                    // data in
                    .din_row_en    (vv_dat_h_en[row][col]       ),
                    .din_row       (vv_dat_h[row][col]          ),
                    .din_col       (vv_dat_v[row][col]          ), 
                    // data out
                    .dout_row_en   (vv_dat_h_en[row][col+1]     ),
                    .dout_row      (vv_dat_h[row][col+1]        ),
                    .dout_col      (vv_dat_v[row+1][col]        ), 
                    //output shift
                    .load_en       (load_en                     ),
                    .shift_en      (shift_en                    ),
                    .shift_dat_in  (vv_shift_dat[row][col]      ),
                    .shift_dat_out (vv_shift_dat[row][col+1]    ));
            end
        end
    endgenerate

endmodule 