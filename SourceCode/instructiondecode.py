# converts the instruction part of a line of MIPS code 
# param 'instr' is the instruction given
# returns an arrya in the form [function type, opcode, function number]
def instr_decode(instr):
    if instr == "add":
        func_type = "r"
        opcode = 0
        funct = 0x20
        
    elif instr == "xor":
        func_type = "r"
        opcode = 0
        funct = 0x13
		
    elif instr == "addi":
        func_type = "i"
        opcode = 0x8
        funct = None
        
    elif instr == "addiu":
        func_type = "i"
        opcode = 0x9
        funct = None
        
    elif instr == "addu":
        func_type = "r"
        opcode = 0
        funct = 0x21
    
    elif instr == "and":
        func_type = "r"
        opcode = 0
        funct = 0x24

    elif instr == "andi":
        func_type = "i"
        opcode = 0xc
        funct = None
        
    elif instr == "beq":
        func_type = "i"
        opcode = 0x4
        funct = None
        
    elif instr == "bne":
        func_type = "i"
        opcode = 0x5
        funct = None
        
    elif instr == "j":
        func_type = "j"
        opcode = 0x2
        funct = None
           
    elif instr == "jal":
        func_type = "j"
        opcode = 0x3
        funct = None
    
    elif instr == "jr":
        func_type = "r"
        opcode = 0
        funct = 0x8
     
    elif instr == "lbu":
        func_type = "i"
        opcode = 0x24
        funct = None
    
    elif instr == "lhu":
        func_type = "i"
        opcode = 0x25
        funct = None
      
    elif instr == "ll":
        func_type = "i"
        opcode = 0x30
        funct = None  
    
    elif instr == "lui":
        func_type = "i"
        opcode = 0xf
        funct = None
        
    elif instr == "lw":
        func_type = "i"
        opcode = 0x23
        funct = None
    
    elif instr == "nor":
        func_type = "r"
        opcode = 0
        funct = 0x27
        
    elif instr == "or":
        func_type = "r"
        opcode = 0
        funct = 0x25
    
    elif instr == "ori":
        func_type = "i"
        opcode = 0xd
        funct = None
    
    elif instr == "slt":
        func_type = "r"
        opcode = 0
        funct = 0x2a
    
    elif instr == "slti":
        func_type = "i"
        opcode = 0xa
        funct = None
    
    elif instr == "sltiu":
        func_type = "i"
        opcode = 0xb
        funct = None
    
    elif instr == "sltu":
        func_type = "r"
        opcode = 0
        funct = 0x2b
    
    elif instr == "sll":
        func_type = "r"
        opcode = 0
        funct = 0x00
    
    elif instr == "srl":
        func_type = "r"
        opcode = 0
        funct = 0x02
        
    elif instr == "sb":
        func_type = "i"
        opcode = 0x28
        funct = None
    
    elif instr == "sc":
        func_type = "i"
        opcode = 0x38
        funct = None
    
    elif instr == "sh":
        func_type = "i"
        opcode = 0x29
        funct = None
    
    elif instr == "sw":
        func_type = "i"
        opcode = 0x2b
        funct = None
        
    elif instr == "sub":
        func_type = "r"
        opcode = 0
        funct = 0x22
        
    elif instr == "subu":
        func_type = "r"
        opcode = 0
        funct = 0x23
        
    else:
        func_type = None
        opcode = None
        funct = None
    
    return [func_type, opcode, funct]
