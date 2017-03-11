#This makefile is for Booth DPI-C Example 

#Specify the mode- could be either puresim or veloce
#Always make sure that everything works fine in puresim before changing to veloce

#MODE ?= veloce
MODE ?= puresim

#make all does everything
all: clean lib compile run

lib:
ifeq ($(MODE),puresim)
	vlib work.$(MODE)
	vmap work work.$(MODE) 
else	
	vellib work.$(MODE)
	velmap work work.$(MODE)
endif

compile:
ifeq ($(MODE),puresim)
	vlog -dpiheader cpuTest.h SourceCode/cpu.sv SourceCode/alu.sv SourceCode/alu_control.sv SourceCode/AluCtrlSig_pkg.sv SourceCode/control.sv SourceCode/dm.sv SourceCode/regm.sv SourceCode/regr.sv TBX_Mode_Testing/CPU_tb_dpi.sv SourceCode/checker.sv SourceCode/checker_interface.sv
	vlog TBX_Mode_Testing/testbench.cxx 
else
	velanalyze SourceCode/cpu.sv SourceCode/alu.sv SourceCode/alu_control.sv SourceCode/control.sv SourceCode/dm.sv SourceCode/regm.sv SourceCode/checker.sv SourceCode/checker_interface.sv SourceCode/regr.sv SourceCode/regm.sv
	velanalyze TBX_Mode_Testing/CPU_tb_dpi.sv
	
	#Note that the testbench.cxx file is passed to velcomp in veloce.config file. That way it knows this is the CoModel and compiles, then later runs on workstation
	velcomp 
endif
                                                           
run:
ifeq ($(MODE),puresim)
	vsim -c CPU_tb_dpi -do "run -all" | tee transcript.puresim
else
	velrun $(RUNTIME_OPTS) | tee transcript.veloce
endif
                                                                                
clean:
	rm -rf edsenv work.puresim transcript modelsim.ini transcript.veloce transcript.puresim veloce.map veloce.wave velrunopts.ini work work.veloce veloce.out veloce.med veloce.log tbxbindings.h 

