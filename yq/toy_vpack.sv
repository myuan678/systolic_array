package toy_vpack;

    localparam integer unsigned V_OPC_WIDTH             = 5     ;
    localparam integer unsigned V_REG_IDX_WIDTH         = 5     ;
    localparam integer unsigned V_REG_NUM               = 32    ;
    
    localparam integer unsigned S_REG_WIDTH             = 32    ;
    localparam integer unsigned V_REG_WIDTH             = 32    ;
    localparam integer unsigned SHARE_MEM_ADDR_WIDTH    = 32    ;
    localparam integer unsigned SHRAE_MEM_DATA_WIDTH    = 32    ;

    localparam integer unsigned V_ELEMENT_NUM           = 4     ;
    //localparam integer unsigned
    //localparam integer unsigned

    typedef enum logic [4:0] {
        V_OPC_MTX_MUL   = 5'b00000,
        V_OPC_MTX_LOAD  = 5'b00001
        //OPC_RSVD3     = 5'b11101,
        //OPC_CUST3     = 5'b11110,
        //OPC_80B       = 5'b11111,
    } opcode_mtx;

endpackage
