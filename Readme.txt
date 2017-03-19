ECE 571: Final Project 
Project: MIPS processor with 5 stage pipeline
Project Engineers: Chetan B. | Daksh D. | Harsh M. 

Design Files List: 
SourceCode: 
1. alu_control.sv - Based on the opcode and funct bits the alu control signal are generated for the ALU operation. 
2. AluCtrlSig_pkg.sv - Enum declerations for opcode, funct and registers. 
3. Control.sv - Generates the control signals for CPU operations. 
4. dm.sv - Data memory. This file instantiates the data memory of size 512bytes. Based on the signals it either reads/writes the data to/from memory.
5. regr.sv - The following file store the register data for one clock cycle for the pipeline stages. 
6. Alu.sv - Based on opcode and func bits the corresponding ALU operation is performed. 
7. reg.sv - register memory. This file instantiates the register memory of size 128 bytes. Based on the signals it either reads/writes the data to/from reg.
8. CPU.sv - This is main module which instantiates all other module and performs the operations. 

Environment module files
1. Checker.sv - The checker replicates the functionality of cpu. It performs all the operations that cpu does based on opcode and funct bits. If the outputs match then, opDone signal(Operation is done) is asserted.
2. Checker_interface.sv - Is an interface between teh CPU module and the checker. It is used to access the internal signals of the CPU. 

Enironment module files: TBX Mode Source Codes: 
1. CPU_tb_dpi.sv - The file consists of the methods which are used to read the instructions and the result of the operaitons. This data is sent to the testbench.cxx file where it is logged. 
2. testbench.cxx - This file is the HVL file of the design. This file sends the instruction as per the PC requested. This file then receives the result of the operaiton and stores/logs it in the "Functional coverage" file. 
3. FunctionalCoverage: This file has the logs of the result of each instruction. The file shows if the instruction issued was successful or not. It shows the total number of instructions issued and their results. (In the functional coverage file there are two results that are shown. One is correct operaiton and the one is for error operaiton i.e. intentional error was inserted in the design for XOR instruction.) 
 
Unit Testing: The following folder consists of the files which are designed and directed to check the individual modules of the design. 

Test Patterns: This folder consists of the files which generates instructions and its machine code. 

Log: The folder consists of the log of machine/design running on the Veloce in TBX-DPI-C mode. The file velcomp has the compiling messages before the DUT is ran. The file velrun.transcript has the messages that are printed from the DUT/Design when running on the Veloce. The xrtl.log has the number of tasks that were run on veloce. The tbxrun.log has the emulation and simulation statistics. 

Scripts: The folder consists of three script files which are used to convert the instruction to machine code. The folder also consists of two text files one containing the instsructions and the other containing the resulted machine code. 
