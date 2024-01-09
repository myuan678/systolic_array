

module toy_velement
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
    input  logic [V_REG_IDX_WIDTH-1:0]  vlsu_rd             ,


    //interface with systolic array
    output logic [V_REG_WIDTH-1:0]      sa_dout             ,
    output logic                        sa_dout_en          ,
    output logic [V_REG_WIDTH-1:0]      sa_dout_y           ,
    input  logic [V_REG_WIDTH-1:0]      sa_din              ,
    output logic                        sa_load_en          ,
    output logic                        sa_shift_en         ,



    //mem access
    output logic [SHARE_MEM_ADDR_WIDTH-1:0]     mem_addr            ,
    input  logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_rd_data         ,
    output logic [SHRAE_MEM_DATA_WIDTH-1:0]     mem_wr_data         ,
    output logic [SHRAE_MEM_DATA_WIDTH/8-1:0]   mem_wr_byte_en      ,
    output logic                                mem_wr_en           ,
    output logic                                mem_en  

);


    logic [4:0]                 vlsu_reg_index               ;
    logic                       vlsu_reg_wr_en               ;
    logic [V_REG_WIDTH-1:0]     vlsu_reg_val                 ;

    logic [4:0]                 valu_reg_index               ;
    logic                       valu_reg_wr_en               ;
    logic [V_REG_WIDTH-1:0]     valu_reg_val                 ;

    logic [S_REG_WIDTH-1:0]     valu_vs1_val                 ;      
    logic [S_REG_WIDTH-1:0]     valu_vs2_val                 ;      



    // reg file ========================================================

    logic [V_REG_WIDTH-1:0] registers [V_REG_NUM-1:0];

    assign reg_wr_en    = vlsu_reg_wr_en | valu_reg_wr_en;
    assign reg_val      = vlsu_reg_wr_en ? vlsu_reg_val
                                         : valu_reg_val;
    assign reg_index    = vlsu_reg_wr_en ? vlsu_reg_index
                                         : valu_reg_index;


    generate for(genvar i=0;i<32;i=i+1) begin
        if(i==0) begin
            assign registers[i] = 32'b0;
        end else begin
            always_ff @(posedge clk or negedge rst_n) begin
                if(~rst_n) begin
                    registers[i] <= 32'b0;
                end
                else if(reg_wr_en && (reg_index == i)) begin 
                    registers[i] <= reg_val;
                end
            end
        end
    end endgenerate

    assign valu_vs1_val = registers[valu_vs1];
    assign valu_vs2_val = registers[valu_vs2];

    //lsu ==============================================================

    toy_vlsu u_vlsu(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),
        .vlsu_op_en         (vlsu_op_en             ),
        .vlsu_opcode        (vlsu_opcode            ),
        .vlsu_vs1           (vlsu_vs1               ),
        .vlsu_vs2           (vlsu_vs2               ),
        .vlsu_rd            (vlsu_rd                ),
        .mem_addr           (mem_addr               ),
        .mem_rd_data        (mem_rd_data            ),
        .mem_wr_data        (mem_wr_data            ),
        .mem_wr_byte_en     (mem_wr_byte_en         ),
        .mem_wr_en          (mem_wr_en              ),
        .mem_en             (mem_en                 ),
        .reg_index          (vlsu_reg_index         ),
        .reg_wr_en          (vlsu_reg_wr_en         ),
        .reg_data           (vlsu_reg_val           ));

    //alu ==============================================================
    toy_valu u_valu(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),
        .valu_op_en         (valu_op_en             ),
        .valu_opcode        (valu_opcode            ),
        .valu_vs1_val       (valu_vs1_val           ),
        .valu_vs2_val       (valu_vs2_val           ),
        .valu_vs1           (valu_vs1               ),
        .valu_vs2           (valu_vs2               ),
        .valu_rd            (valu_rd                ),
        .sa_din             (sa_din                 ),
        .sa_shift_en        (sa_shift_en            ),
        .reg_index          (valu_reg_index         ),
        .reg_wr_en          (valu_reg_wr_en         ),
        .reg_data           (valu_reg_val           ));

    //systolic array ===================================================

    assign sa_dout      = registers[vmtx_vs1];
    assign sa_dout_y    = registers[vmtx_vs2];
    assign sa_dout_en   = (vmtx_opcode == V_OPC_MTX_MUL   ) && vmtx_op_en;
    assign sa_load_en   = (vmtx_opcode == V_OPC_MTX_LOAD  ) && vmtx_op_en;


endmodule