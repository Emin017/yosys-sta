PROJ_PATH = $(shell pwd)
SHELL := /bin/bash

O ?= $(PROJ_PATH)/result
DESIGN ?= gcd
SDC_FILE ?= $(PROJ_PATH)/scripts/default.sdc
RTL_FILES ?= $(shell find $(PROJ_PATH)/example -name "*.v")
export CLK_FREQ_MHZ ?= 100
export CLK_PORT_NAME ?= clk
PDK = ics55

RESULT_DIR = $(O)/$(DESIGN)-$(CLK_FREQ_MHZ)MHz
SCRIPT_DIR = $(PROJ_PATH)/scripts
NETLIST_SYN_V   = $(RESULT_DIR)/$(DESIGN).netlist.syn.v
NETLIST_FIXED_V = $(RESULT_DIR)/$(DESIGN).netlist.fixed.v
FIXED_DEF = $(RESULT_DIR)/$(DESIGN).netlist.fixed.def
TIMING_RPT = $(RESULT_DIR)/$(DESIGN).rpt

init:
	@git clone https://github.com/openecos-projects/icsprout55-pdk.git ${PROJ_PATH}/pdk/${PDK}
	@cd ${PROJ_PATH}/pdk/${PDK} && make unzip

syn: $(NETLIST_SYN_V)
$(NETLIST_SYN_V): $(RTL_FILES) $(SCRIPT_DIR)/yosys.tcl
	mkdir -p $(@D)
	echo tcl $(SCRIPT_DIR)/yosys.tcl $(DESIGN) $(PDK) \"$(RTL_FILES)\" $@ | yosys -l $(@D)/yosys.log -s -

fix-fanout: $(NETLIST_FIXED_V)
$(NETLIST_FIXED_V): $(SCRIPT_DIR)/fix-fanout.tcl $(SDC_FILE) $(NETLIST_SYN_V)
	set -o pipefail && iEDA -script $^ $(DESIGN) $(PDK) $@ $(FIXED_DEF) 2>&1 | tee $(RESULT_DIR)/fix-fanout.log
	echo tcl $(SCRIPT_DIR)/yosys-area.tcl $(DESIGN) $(PDK) $@ | yosys -l $(@D)/yosys-fixed.log -s -

sta: $(TIMING_RPT)
$(TIMING_RPT): $(SCRIPT_DIR)/sta.tcl $(SDC_FILE) $(NETLIST_FIXED_V)
	set -o pipefail && iEDA -script $^ $(DESIGN) $(PDK) $(FIXED_DEF) 2>&1 | tee $(RESULT_DIR)/sta.log

clean:
	-rm -rf result/

.PHONY: init syn fix-fanout sta clean
