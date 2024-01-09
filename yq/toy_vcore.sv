


module toy_vcore
    import toy_vpack::*;
(
    input                               clk                                 ,
    input                               rst_n                               ,

    input  logic                        vmtx_op_en                          ,
    input  logic [V_OPC_WIDTH-1:0]      vmtx_opcode                         ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vmtx_vs1                            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vmtx_vs2                            ,

    input  logic                        valu_op_en                          ,
    input  logic [V_OPC_WIDTH-1:0]      valu_opcode                         ,
    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs1                            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs2                            ,
    input  logic [4:0]                  valu_rd                             ,

    input  logic                        vlsu_op_en                          ,
    input  logic [V_OPC_WIDTH-1:0]      vlsu_opcode                         ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_vs1                            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_vs2                            ,
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_rd                             ,

    //interface with systolic array
    output logic [V_REG_WIDTH-1:0]      sa_dout       [V_ELEMENT_NUM-1:0]   ,
    output logic                        sa_dout_en    [V_ELEMENT_NUM-1:0]   ,
    output logic [V_REG_WIDTH-1:0]      sa_dout_y     [V_ELEMENT_NUM-1:0]   ,
    input  logic [V_REG_WIDTH-1:0]      sa_din        [V_ELEMENT_NUM-1:0]   ,
    output logic                        sa_load_en    [V_ELEMENT_NUM-1:0]   ,
    output logic                        sa_shift_en   [V_ELEMENT_NUM-1:0]  
);


    generate for(genvar i=0;i<V_ELEMENT_NUM;i=i+1) begin

        logic [SHARE_MEM_ADDR_WIDTH-1:0]     mem_addr           ;
        logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_rd_data        ;
        logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_wr_data        ;
        logic [SHRAE_MEM_DATA_WIDTH/8-1:0]   mem_wr_byte_en     ;
        logic                                mem_wr_en          ;
        logic                                mem_en             ;

        toy_velement u_velement(
            .clk                    (clk                ),
            .rst_n                  (rst_n              ),
            .vmtx_op_en             (vmtx_op_en         ),
            .vmtx_opcode            (vmtx_opcode        ),
            .vmtx_vs1               (vmtx_vs1           ),
            .vmtx_vs2               (vmtx_vs2           ),
            .valu_op_en             (valu_op_en         ),
            .valu_opcode            (valu_opcode        ),
            .valu_vs1               (valu_vs1           ),
            .valu_vs2               (valu_vs2           ),
            .valu_rd                (valu_rd            ),
            .vlsu_op_en             (vlsu_op_en         ),
            .vlsu_opcode            (vlsu_opcode        ),
            .vlsu_vs1               (vlsu_vs1           ),
            .vlsu_vs2               (vlsu_vs2           ),
            .vlsu_rd                (vlsu_rd            ),
            //interface with systolic array
            .sa_dout                (sa_dout     [i]    ),
            .sa_dout_en             (sa_dout_en  [i]    ),
            .sa_dout_y              (sa_dout_y   [i]    ),
            .sa_din                 (sa_din      [i]    ),
            .sa_load_en             (sa_load_en  [i]    ),
            .sa_shift_en            (sa_shift_en [i]    ),
            //mem access
            .mem_addr               (mem_addr           ),
            .mem_rd_data            (mem_rd_data        ),
            .mem_wr_data            (mem_wr_data        ),
            .mem_wr_byte_en         (mem_wr_byte_en     ),
            .mem_wr_en              (mem_wr_en          ),
            .mem_en                 (mem_en             ));


        toy_1dly_mem #(
            .ADDR_WIDTH(SHARE_MEM_ADDR_WIDTH),
            .DATA_WIDTH(SHRAE_MEM_DATA_WIDTH))
        u_mem(
            .clk        (clk                ),
            .en         (mem_en             ),
            .addr       (mem_addr           ),
            .rd_data    (mem_rd_data        ),
            .wr_data    (mem_wr_data        ),
            .wr_byte_en (mem_wr_byte_en     ),
            .wr_en      (mem_wr_en          ));



    end endgenerate


endmodule