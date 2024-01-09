


module toy_pe44 
    import toy_vpack::*;
(
    input                               clk                 ,
    input                               rst_n               ,

    input  logic                        shift_en            ,    
    input  logic                        load_en             ,
    
    input  logic                        din_en              ,
    input  logic [V_REG_WIDTH-1:0]      din                 ,
    input  logic [V_REG_WIDTH-1:0]      din_y               ,
    output logic [V_REG_WIDTH-1:0]      shift_out           ,

    output logic                        dout_en             ,
    output logic [V_REG_WIDTH-1:0]      dout                ,
    output logic [V_REG_WIDTH-1:0]      dout_y              ,
    input  logic [V_REG_WIDTH-1:0]      shift_in           
);


    localparam DAT_WIDTH = 8;

    logic   [DAT_WIDTH-1:0]     v_shift_dat_in  [4-1:0]         ;
    logic   [3:0]               v_dout_row_en                   ;
    logic   [DAT_WIDTH-1:0]     v_dout_row      [4-1:0]         ;
    logic   [DAT_WIDTH-1:0]     v_dout_col      [4-1:0]         ;

    logic   [DAT_WIDTH-1:0]     v_din_row       [4-1:0]         ;
    logic   [DAT_WIDTH-1:0]     v_din_col       [4-1:0]         ; 
    logic   [DAT_WIDTH-1:0]     v_shift_dat_out [4-1:0]         ;


    assign dout_en = v_dout_row_en[0];

    assign dout     = {v_dout_row[3],v_dout_row[2],v_dout_row[1],v_dout_row[0]};
    assign dout_y   = {v_dout_col[3],v_dout_col[2],v_dout_col[1],v_dout_col[0]};

    assign v_shift_dat_in[3] = shift_in[31:24];
    assign v_shift_dat_in[2] = shift_in[23:16];
    assign v_shift_dat_in[1] = shift_in[15:8];
    assign v_shift_dat_in[0] = shift_in[7:0];

    assign v_din_row[3] = din[31:24];
    assign v_din_row[2] = din[23:16];
    assign v_din_row[1] = din[15:8];
    assign v_din_row[0] = din[7:0];

    assign v_din_col[3] = din_y[31:24];
    assign v_din_col[2] = din_y[23:16];
    assign v_din_col[1] = din_y[15:8];
    assign v_din_col[0] = din_y[7:0];

    os_pe_array #(
        .DAT_WIDTH (DAT_WIDTH ),
        .ACC_WIDTH (24),
        .ROW_NUM   (4 ),
        .COL_NUM   (4 )) 
    u_pe_array (
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .v_din_row_en       ({4{din_en}}        ),
        .v_din_row          (v_din_row          ),
        .v_din_col          (v_din_col          ), 
        .v_shift_dat_out    (v_shift_dat_out    ),
        .load_en            (load_en            ),
        .shift_en           (shift_en           ),
        .v_shift_dat_in     (v_shift_dat_in     ),
        .v_dout_row_en      (v_dout_row_en      ),
        .v_dout_row         (v_dout_row         ),
        .v_dout_col         (v_dout_col         ));




endmodule