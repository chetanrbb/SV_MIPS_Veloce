## Sript for converting instructions into hex value
global zero_reg
zero_reg = 0
count = 0
flag = 1
src1 = 0
src2 = 0
imm_bit = 0
loop = 0
       
##  loop = loop + 1
g = open("instr_mem.txt",'w')
with open("test_file.txt", 'r') as f:
    for line in f:
        instr = line
        count = count + 1
        


        instr_dic = { "add"  : 0,
                      "sub"  : 1,
                      "and"  : 2,
                      "or "  : 3,
                      "nor"  : 4,
                      "xor"  : 5,
                      "lw "  : 6,
                      "sw" : 7,
                      "addi" : 8,
                      "beq"  : 9,
                      "bp "  : 10,
                      "bn "  : 11,
                      "jr "  : 12,
                      "bnz"  : 13,
                      "bz "  : 14,
                      "hlt"  : 15
                    }

        reg_dic = { "$v0"     : 1,
                    "$v1"     : 2,
                    "$t0"     : 8,
                    "$t1"     : 9,
                    "$t2"     : 10,
                    "$t3"     : 11,
                    "$t4"     : 12,
                    "$t5"     : 13,
                    "$t6"     : 14,
                    "$t7"     : 15  
                    }


        instr_name = bin(instr_dic[instr[0:3]])[2:].zfill(4)
        print(instr_name)

        ## For load and store instr
        if instr_name == "0110" or instr_name == "0111":
            imm_bit = 1
            dest_reg = bin(reg_dic[instr[4:6]])[2:].zfill(4)
            imm_value = bin(int(instr[8:11]))[2:].zfill(19)
            #print(imm_value)
            src1 = bin(reg_dic[instr[12:14]])[2:].zfill(4)
            result_instr = str(instr_name)+ str(imm_bit)+str(dest_reg)+str(src1)+str(imm_value)
            #print(result_instr)
            instr_hex =str(count)+ " " + str(hex(int(result_instr,2))[2:])
            #print(instr_hex)

        ## For jumps    
        elif instr[0:3] == "bz " or instr[0:3] == "jr " or instr[0:3] == "bnz" or instr[0:3] == "bn " or instr[0:3] == "bp " or instr[0:3] == "beq":
            imm_addr = bin(int(instr[4:7]))[2:].zfill(28)
            result_instr = str(instr_name) + str(imm_addr)
            instr_hex = str(count) + " " + str(hex(int(result_instr,2))[2:]) 

        elif instr[0:3] == "hlt":
            result_instr = hex(int(instr_name,2))[2:]
            instr_hex = str(count)+ " " + str(result_instr) + str(bin(zero_reg)[2:].zfill(7))

        ## For R and I type arithmetic operations    
        else:    
            dest_reg = bin(reg_dic[instr[4:6]])[2:].zfill(4)
            src1 = bin(reg_dic[instr[8:10]])[2:].zfill(4)
            if instr[12] == "#":                                ##I type    
                imm_value = bin(int(instr[13:16]))[2:].zfill(18)
                src2 = 0000
                imm_bit = 1                
            else:                                               ##R type
                imm_value = bin(zero_reg)[2:].zfill(15)
                imm_bit = 0
                src2 = bin(int(reg_dic[instr[12:14]]))[2:].zfill(4)

            result_instr = str(instr_name)+str(imm_bit)+str(dest_reg)+str(src1)+str(src2)+str(imm_value)
            instr_hex = str(count)+" "+ str(hex(int(result_instr,2))[2:].zfill(8))
                               
        print(instr_hex)
        g.write(instr_hex+ '\n')
g.close()
