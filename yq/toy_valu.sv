module toy_valu
    import toy_vpack::*;
(
    input                               clk             ,
    input                               rst_n           ,

    input  logic                        valu_op_en      ,
    input  logic [V_OPC_WIDTH-1:0]      valu_opcode     ,
    input  logic [S_REG_WIDTH-1:0]      valu_vs1_val    ,
    input  logic [S_REG_WIDTH-1:0]      valu_vs2_val    ,
    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs1        ,
    input  logic [V_REG_IDX_WIDTH-1:0]  valu_vs2        ,
    input  logic [4:0]                  valu_rd         ,

    // reg access
    output logic [4:0]                  reg_index       ,
    output logic                        reg_wr_en       ,
    output logic [V_REG_WIDTH-1:0]      reg_data        ,


    input  logic [V_REG_WIDTH-1:0]      sa_din          ,
    output logic                        sa_shift_en             

);


    //res = (x > 0) ? x : 0;

endmodule