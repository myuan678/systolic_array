

module toy_vec_mtx
    import toy_vpack::*;
(
    input                               clk                 ,
    input                               rst_n               ,

    input  logic                        vmtx_op_en          ,
    input  logic [V_OPC_WIDTH-1:0]      vmtx_opcode         ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vmtx_vs1            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vmtx_vs2            ,

    input  logic                        valu_op_en          ,
    input  logic [V_OPC_WIDTH-1:0]      valu_opcode         ,
    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs1            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs2            ,
    input  logic [4:0]                  valu_rd             ,

    input  logic                        vlsu_op_en          ,
    input  logic [V_OPC_WIDTH-1:0]      vlsu_opcode         ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_vs1            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_vs2            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_rd             
);

    logic [V_REG_WIDTH-1:0]      sa_dout       [V_ELEMENT_NUM-1:0]      ;
    logic                        sa_dout_en    [V_ELEMENT_NUM-1:0]      ;
    logic [V_REG_WIDTH-1:0]      sa_dout_y     [V_ELEMENT_NUM-1:0]      ;
    logic [V_REG_WIDTH-1:0]      sa_din        [V_ELEMENT_NUM-1:0]      ;
    logic                        sa_load_en    [V_ELEMENT_NUM-1:0]      ;
    logic                        sa_shift_en   [V_ELEMENT_NUM-1:0]      ;

    toy_vcore u_vcore (
        .clk                 (clk               ),
        .rst_n               (rst_n             ),
        .vmtx_op_en          (vmtx_op_en        ),
        .vmtx_opcode         (vmtx_opcode       ),
        .vmtx_vs1            (vmtx_vs1          ),
        .vmtx_vs2            (vmtx_vs2          ),
        .valu_op_en          (valu_op_en        ),
        .valu_opcode         (valu_opcode       ),
        .valu_vs1            (valu_vs1          ),
        .valu_vs2            (valu_vs2          ),
        .valu_rd             (valu_rd           ),
        .vlsu_op_en          (vlsu_op_en        ),
        .vlsu_opcode         (vlsu_opcode       ),
        .vlsu_vs1            (vlsu_vs1          ),
        .vlsu_vs2            (vlsu_vs2          ),
        .vlsu_rd             (vlsu_rd           ),
        .sa_dout             (sa_dout           ),
        .sa_dout_en          (sa_dout_en        ),
        .sa_dout_y           (sa_dout_y         ),
        .sa_din              (sa_din            ),
        .sa_load_en          (sa_load_en        ),
        .sa_shift_en         (sa_shift_en       ));

    toy_mcore u_mcore(
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .din                (sa_dout            ),
        .din_en             (sa_dout_en         ),
        .din_y              (sa_dout_y          ),
        .dout               (sa_din             ),
        .load_en            (sa_load_en         ),
        .shift_en           (sa_shift_en        ));


endmodule