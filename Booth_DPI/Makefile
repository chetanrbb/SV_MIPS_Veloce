#This makefile is for Booth DPI-C Example 

#Specify the mode- could be either puresim or veloce
#Always make sure that everything works fine in puresim before changing to veloce

MODE ?= veloce
#MODE ?= puresim

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
	vlog hdl/booth_fsm.sv hdl/booth_tb_dpi.sv -dpiheader tbxbindings.h 
	vlog hvl/testbench.cxx 
else
	velanalyze hdl/booth_fsm.sv hdl/booth_tb_dpi.sv
	#Note that the testbench.cxx file is passed to velcomp in veloce.config file. That way it knows this is the CoModel and compiles, then later runs on workstation
	velcomp
endif
                                                           
run:
ifeq ($(MODE),puresim)
	vsim -c booth_tb_dpi -do "run -all" | tee transcript.puresim
else
	velrun $(RUNTIME_OPTS) | tee transcript.veloce
endif
                                                                                
clean:
	rm -rf edsenv work.puresim transcript modelsim.ini transcript.veloce transcript.puresim veloce.map veloce.wave velrunopts.ini work work.veloce veloce.out veloce.med veloce.log tbxbindings.h 

