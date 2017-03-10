# Converts MIPS instructions into binary and hex
import os
import sys
from instructiondecode import instr_decode # converts the instruction part of a line of MIPS code
from registerdecode import reg_decode # converts the register and immediate parts of the MIPS code



# the main conversion function
def convert(code):
    code = code.replace("(", " ")
    code = code.replace(")", "")
    code = code.replace(",", " ")
    code = code.replace("  ", " ")
    code = code.replace("\n", " ")
    args = code.split(" ")
    instruction = args[0]
    #print("\n"+ str(args))
    if instruction == "exit":
        sys.exit()
        
    codes = instr_decode(instruction)
    func_type = codes[0]
    reg_values = reg_decode(func_type, instruction, args[1:4]) #get the numeric values of the registers
    
    #the following if statement below prints an error if needed
    if reg_values == None:
        print("Not a valid MIPS statement")
        return
     
    #execution for r-type functions
    if func_type == "r":            
        opcode = '{0:06b}'.format(codes[1])
        rs = '{0:05b}'.format(reg_values[0])
        rt = '{0:05b}'.format(reg_values[1])
        rd = '{0:05b}'.format(reg_values[2])
        shamt = '{0:05b}'.format(reg_values[3])
        funct = '{0:06b}'.format(codes[2])
        # print("Function type: R-Type")
        # print("Instruction form: opcode|  rs |  rt |  rd |shamt| funct")
        # print("Formatted binary: "+opcode+"|"+rs+"|"+rt+"|"+rd+"|"+shamt+"|"+funct)
        binary = opcode+rs+rt+rd+shamt+funct
        # print("Binary:           " + binary)
        # hex_string = '{0:08x}'.format(int(binary, base=2))
        # print("Hex:              0x" + hex_string)
        
    #execution for i-type functions    
    elif func_type == "i":
        opcode = '{0:06b}'.format(codes[1])
        rs = '{0:05b}'.format(reg_values[0])
        rt = '{0:05b}'.format(reg_values[1])
        imm = '{0:016b}'.format(reg_values[2])
        # print("Function type: I-Type")
        # print("Instruction form: opcode|  rs |  rt |   immediate      ")
        # print("Formatted binary: " + opcode+"|"+rs+"|"+rt+"|"+imm)
        binary = opcode+rs+rt+imm
        # print("Binary:           " + binary)
        # hex_string = '{0:08x}'.format(int(binary, base=2))
        # print("Hex:              0x" + hex_string)
    
    #execution for j-type functions    
    elif func_type == "j":
        opcode = '{0:06b}'.format(codes[1])
        imm = '{0:026b}'.format(reg_values[0])
        # print("Function type: I-Type")
        # print("Instruction form: opcode|          immediate           ")
        # print("Formatted binary: " + opcode+"|"+imm)
        binary = "0b"+opcode+imm
        # print("Binary:           " + binary)
        # hex_string = '{0:08x}'.format(int(binary, base=2))
        # print("Hex:              0x" + hex_string)        
                
    else:
        print("Not a valid MIPS statement")
        return
        
    return binary
        
# main
os.system("clear")
# print("WELCOME TO THE MIPS DECODER!")
# print("Type MIPS code below to see it in binary and hex form")
# print("Syntax: If using hex, use the '0x' label")
# print("Type 'exit' to exit")
# print("--------------------------------------------------------------------------------")
g = open("instr_mem.txt",'w')
with open("test_file.txt", 'r') as f:
    for line in f:
        # mips = input("Type MIPS code here: ")
        #print(line)
        result =  convert(line)
        #print(result)
        g.write(str(result)+ '\n')
        # print("--------------------------------------------------------------------------------")
g.close()        
