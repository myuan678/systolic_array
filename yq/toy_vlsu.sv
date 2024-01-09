
module toy_vlsu
    import toy_vpack::*;
(
    input                                       clk                 ,
    input                                       rst_n               ,

    input  logic                                vlsu_op_en          ,
    input  logic [V_OPC_WIDTH-1:0]              vlsu_opcode         ,
    input  logic [V_REG_IDX_WIDTH-1:0]          vlsu_vs1            ,
    input  logic [V_REG_IDX_WIDTH-1:0]          vlsu_vs2            ,
    input  logic [V_REG_IDX_WIDTH-1:0]          vlsu_rd             ,

    // reg access
    output logic [4:0]                          reg_index           ,
    output logic                                reg_wr_en           ,
    output logic [V_REG_WIDTH-1:0]              reg_data            ,


    //mem access
    output logic [SHARE_MEM_ADDR_WIDTH-1:0]     mem_addr            ,
    input  logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_rd_data         ,
    output logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_wr_data         ,
    output logic [SHRAE_MEM_DATA_WIDTH/8-1:0]   mem_wr_byte_en      ,
    output logic                                mem_wr_en           ,
    output logic                                mem_en  
);




    //module velement
    //    import toy_vpack::*;
    //(
    //    input                               clk                 ,
    //    input                               rst_n               ,

    //    input  logic                        vmtx_op_en          ,
    //    input  logic [V_OPC_WIDTH-1:0]      vmtx_opcode         ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  vmtx_vs1            ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  vmtx_vs2            ,

    //    input  logic                        valu_op_en          ,
    //    input  logic [V_OPC_WIDTH-1:0]      valu_opcode         ,
    //    //input  logic [SREG_WIDTH-1:0]       valu_vs1_val        ,
    //    //input  logic [SREG_WIDTH-1:0]       valu_vs2_val        ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs1            ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs2            ,
    //    input  logic [4:0]                  valu_rd             ,

    //    input  logic                        vlsu_op_en          ,
    //    input  logic [V_OPC_WIDTH-1:0]      vlsu_opcode         ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_vs1            ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_vs2            ,
    //    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_rd             ,


    //    //interface with systolic array
    //    output logic [V_REG_WIDTH-1:0]      sa_dout             ,
    //    output logic                        sa_dout_en          ,
    //    input  logic [V_REG_WIDTH-1:0]      sa_din              ,
    //    output logic                        sa_load_en          ,
    //    output logic                        sa_shift_en         ,



    //    //mem access
    //    output logic [SHARE_MEM_ADDR_WIDTH-1:0]     mem_addr            ,
    //    input  logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_rd_data         ,
    //    output logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_wr_data         ,
    //    output logic [SHRAE_MEM_DATA_WIDTH/8-1:0]   mem_wr_byte_en      ,
    //    output logic                                mem_wr_en           ,
    //    output logic                                mem_en  

    //);



endmodule