module tiny_processor (
    input clk,
    input rst,
    output reg [7:0] acc_out, ext_out,
    output reg cb_out
);    
    wire [7:0] instruction_mem [0:15]; // 16 instructions
    assign instruction_mem[0]  = 8'b10010001; // 0: MOV ACC, R1 
    assign instruction_mem[1]  = 8'b01100001; // 1: XRA R1       (ACC = ACC ^ R1 -> Clears ACC)
    assign instruction_mem[2]  = 8'b00010101; // 2: ADD R5       (ACC = ACC + R5)
    assign instruction_mem[3]  = 8'b00010110; // 3: ADD R6       (ACC = ACC + R6)
    assign instruction_mem[4]  = 8'b10100111; // 4: MOV R7, ACC  (R7 = ACC)


    reg [7:0] registers [0:15];
    initial begin
        registers[0] = 8'd28; 
        registers[1] = 8'd11; 
        registers[2] = 8'd32;
        registers[3] = 8'd29; 
        registers[4] = 8'd15; 
        registers[5] = 8'd17; 
        registers[6] = 8'd21; 
        registers[7] = 8'd10; 
    end 
    
    
    reg [3:0] pc;          
    reg [7:0] acc, ext;  
    reg cb;     

    // Combinatorially get instruction
    wire [7:0] instruction; // Current instruction
    assign instruction = instruction_mem[pc];

    // Fetch Phase: Update PC on clock posedge 
    // Basically, Sequential logic to update PC
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            pc <= 0;
        end
        else begin
            if((instruction[7:4] == 4'b1000) && (cb==1'b1)) begin 
                pc <= instruction[3:0];
            end
            else if(instruction[7:4] == 4'b1011) begin
                pc <= instruction[3:0];
            end
            else begin
                pc <= pc + 1;
            end 
        end
    end

    reg [3:0] opcode, operand;
    reg [8:0] temp; // 9 bits to hold carry bit
    reg [15:0] temp_mul;
    reg halt;
    // Decode Phase: decode instruction and set control signals
    // Combinatorial logic to decode instruction to precompute shit
    always@(*) begin
        opcode = instruction[7:4];
        operand = instruction[3:0];

        // handle no op and hlt
        if(instruction == 8'b11111111) begin
            acc = acc; // No operation
            ext = ext; // No operation
            cb = cb; // No operation
            halt = 1'b1; 
        end

        case (opcode)
            4'b0001: begin
                temp = acc + registers[operand]; // Add Ri
                cb = temp[8]; 
                acc = temp[7:0]; 
            end
            4'b0010: begin 
                temp = acc - registers[operand]; // Sub Ri
                cb = temp[8];
                acc = temp[7:0];
            end
            4'b0011: begin 
                temp_mul = acc * registers[operand]; // Mul Ri
                ext = temp_mul[15:8];
                acc = temp_mul[7:0];
            end
            4'b0101: begin
                acc = acc & registers[operand]; // And Ri
            end
            4'b0110: begin
                acc = acc ^ registers[operand]; // Xor Ri
            end
            4'b0111: begin
                if (acc >= registers[operand]) begin
                    cb = 0; 
                end else begin
                    cb = 1; 
                end
            end
            4'b1001: begin
                acc = registers[operand]; // MOV ACC, Ri
            end
            4'b0000: begin
                case (instruction[3:0])
                    4'b0000: acc = acc; // No operation
                    4'b0001: acc = {acc[6:0], 1'b0}; // LSL
                    4'b0010: acc = {1'b0, acc[7:1]}; // LSR
                    4'b0100: acc = {acc[0], acc[7:1]}; // CSL
                    4'b0011: acc = {acc[6:0], acc[7]}; // CSR
                    4'b0101: acc = {acc[7], acc[7:1]}; // ASR
                    4'b0110: begin 
                        temp = acc + 1;   // INC
                        cb = temp[8];
                        acc = temp[7:0];
                    end
                    4'b0111: begin 
                        temp = acc - 1; // DEC
                        cb = temp[8];
                        acc = temp[7:0];
                    end
                endcase
            end
            default: acc = acc; // NO OP
        endcase
    end

    // Execution Phase: execute instruction
    // Sequential logic to update acc_out, ext_out, cb_out
    // and also register for 1 of the instructions
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            acc_out <= 0;
            ext_out <= 0;
            cb_out <= 0;
        end
        else begin
            if(halt) begin
                acc_out <= acc_out; // No operation
                ext_out <= ext_out; // No operation
                cb_out <= cb_out; // No operation
            end
            else begin
                case (opcode)
                    4'b1010: begin
                        registers[operand] <= acc; // MOV ACC, Ri 
                    end
                endcase
                acc_out <= acc;
                ext_out <= ext;
                cb_out <= cb;
            end
        end
    end

endmodule
