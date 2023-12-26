

always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        shadow_reg <= {DIN_WIDTH{1'b0}};
    end
    else if(load_en) begin
        shadow_reg <= acc_reg;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        acc_reg <= {DIN_WIDTH{1'b0}};
    end
    else if(xxx) begin
        acc_reg <= xxx;
    end
    else if(load_en) begin
        acc_reg <= {DIN_WIDTH{1'b0}};
    end
end

