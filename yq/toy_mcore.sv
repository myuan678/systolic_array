

module toy_mcore
    import toy_vpack::*;
(
    input  logic                        clk                                 ,
    input  logic                        rst_n                               ,
    
    input  logic [V_REG_WIDTH-1:0]      din        [V_ELEMENT_NUM-1:0]      ,
    input  logic                        din_en     [V_ELEMENT_NUM-1:0]      ,
    input  logic [V_REG_WIDTH-1:0]      din_y      [V_ELEMENT_NUM-1:0]      ,
    output logic [V_REG_WIDTH-1:0]      dout       [V_ELEMENT_NUM-1:0]      ,
    input  logic                        load_en    [V_ELEMENT_NUM-1:0]      ,
    input  logic                        shift_en   [V_ELEMENT_NUM-1:0]  
);


    logic                       vv_dat_h_en   [V_ELEMENT_NUM:0][V_ELEMENT_NUM:0];
    logic [V_REG_WIDTH-1:0]     vv_dat_h      [V_ELEMENT_NUM:0][V_ELEMENT_NUM:0];
    logic [V_REG_WIDTH-1:0]     vv_dat_v      [V_ELEMENT_NUM:0][V_ELEMENT_NUM:0];
    logic [V_REG_WIDTH-1:0]     vv_shift_dat  [V_ELEMENT_NUM:0][V_ELEMENT_NUM:0];

    generate for(genvar row=0;row<V_ELEMENT_NUM;row=row+1) begin
        assign vv_dat_h_en[row][0]      = din_en[row]                           ;
        assign vv_dat_h[row][0]         = din[row]                              ;
        assign dout[row]                = vv_shift_dat[row][V_ELEMENT_NUM+1]    ;
    end endgenerate
    
    generate for(genvar col=0 ; col<V_ELEMENT_NUM ; col=col+1) begin
        assign vv_dat_v[0][col]         = din_y[col]                            ;

    end endgenerate


    generate for(genvar row=0;row<V_ELEMENT_NUM;row=row+1) begin
        for(genvar col=0;col<V_ELEMENT_NUM;col=col+1) begin

            toy_pe44 u_pe44(
                .clk                    (clk                        ),
                .rst_n                  (rst_n                      ),
                .shift_en               (load_en[row]               ),    
                .load_en                (shift_en[row]              ),
                
                .din_en                 (vv_dat_h_en[row][col]      ),
                .din                    (vv_dat_h[row][col]         ),
                .din_y                  (vv_dat_v[row][col]         ),
                .shift_out              (vv_shift_dat[row][col+1]   ),

                .dout_en                (vv_dat_h_en[row][col+1]    ),
                .dout                   (vv_dat_h[row][col+1]       ),
                .dout_y                 (vv_dat_v[row+1][col]       ),
                .shift_in               (vv_shift_dat[row][col]     ));

        end
    end endgenerate



    


endmodule