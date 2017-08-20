`define IMM_WIDTH       16
`define GPR_NUM         32
`define ADDR_WIDTH      32
`define DATA_WIDTH      32
`define REG_ADDR_WIDTH  5
`define MEM_LEN         128  //32KB MEM
`define CTRL_BUS_WIDTH  32

`define IDLE 3'b000
`define IF   3'b001
`define ID   3'b010
`define EXE  3'b011
`define WB   3'b100

`define OPCODE_CALC 	6'b000000
`define OPCODE_ADDI  	6'b001000
`define OPCODE_ADDIU 	6'b001001
`define OPCODE_ANDI  	6'b001100
`define OPCODE_ORI   	6'b001101
`define OPCODE_XORI  	6'b001110
`define OPCODE_LUI		6'b001111
`define OPCODE_LW		6'b100011
`define OPCODE_SW		6'b101011
`define OPCODE_BEQ		6'b000100
`define OPCODE_BNE		6'b000101
`define OPCODE_SLTI		6'b001010
`define OPCODE_SLTIU	6'b001011
`define OPCODE_J		6'b000010
`define OPCODE_JAL		6'b000011
`define OPCODE_SPECIAL	6'b010000
`define OPCODE_HLT		6'b111111
`define OPCODE_LDREX    6'b100000
`define OPCODE_STREX    6'b100001

`define FUNCT_JR		6'b001000
`define FUNCT_ADD		6'b100000
`define FUNCT_ADDU		6'b100001
`define FUNCT_SUB		6'b100010
`define FUNCT_SUBU		6'b100011
`define FUNCT_AND		6'b100100
`define FUNCT_OR		6'b100101
`define FUNCT_XOR		6'b100110
`define FUNCT_NOR		6'b100111
`define FUNCT_SLT		6'b101010
`define FUNCT_SLTU		6'b101011
`define FUNCT_SLL		6'b000000
`define FUNCT_SRL		6'b000010
`define FUNCT_SRA		6'b000011
`define FUNCT_SLLV		6'b000100
`define FUNCT_SRLV		6'b000110
`define FUNCT_SRAV		6'b000111
`define FUNCT_SYSCALL	6'b000001
`define FUNCT_SPRWR		6'b000010
`define FUNCT_SPRRD		6'b000100

`define ALU_OP_WIDTH 	4
`define ALU_OP_ADD		`ALU_OP_WIDTH'd1
`define ALU_OP_SUB		`ALU_OP_WIDTH'd2
`define ALU_OP_AND		`ALU_OP_WIDTH'd3
`define ALU_OP_OR		`ALU_OP_WIDTH'd4
`define ALU_OP_XOR		`ALU_OP_WIDTH'd5
`define ALU_OP_NOR		`ALU_OP_WIDTH'd6
`define ALU_OP_SLL		`ALU_OP_WIDTH'd7
`define ALU_OP_SRL		`ALU_OP_WIDTH'd8
`define ALU_OP_SRA		`ALU_OP_WIDTH'd9
`define ALU_OP_EQ		`ALU_OP_WIDTH'd10
`define ALU_OP_NE		`ALU_OP_WIDTH'd11
`define ALU_OP_LT		`ALU_OP_WIDTH'd12
`define ALU_OP_ADDU     `ALU_OP_WIDTH'd13
`define ALU_OP_SUBU     `ALU_OP_WIDTH'd14
`define ALU_OP_LTU      `ALU_OP_WIDTH'd15

`define ALU_SEL_WIDTH   2
`define ALU_SEL_RS		`ALU_SEL_WIDTH'd1
`define ALU_SEL_RT		`ALU_SEL_WIDTH'd2
`define ALU_SEL_IMM		`ALU_SEL_WIDTH'd3

`define WB_SEL_WIDTH    2
`define WB_SEL_ALUtoReg `WB_SEL_WIDTH'd1
`define WB_SEL_ALUtoMEM `WB_SEL_WIDTH'd2
`define WB_SEL_MEMtoReg `WB_SEL_WIDTH'd3

`define INT_SEL_WIDTH   16
`define INT_KEYBOARD    0
`define INT_MOUSE       1
`define INT_UART        2
`define INT_STORAGE     3
`define INT_ETHERNET    4
`define INT_CF          5
`define INT_SYSCALL     6

`define INT_KEYBOARD_ADDR    0
`define INT_MOUSE_ADDR       0
`define INT_UART_ADDR        0
`define INT_STORAGE_ADDR     0
`define INT_ETHERNET_ADDR    0
`define INT_CF_ADDR          `ADDR_WIDTH'd16
`define INT_SYSCALL_ADDR     `ADDR_WIDTH'd12

`define CORE_NUM             2