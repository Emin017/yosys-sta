set FOUNDARY_PATH           "$PROJ_HOME/pdk/ics55"

set CELL_BASE_PATH          "$FOUNDARY_PATH/IP/STD_cell/ics55_LLSC_H7C_V1p10C100"

set TECH_LEF_FILE           "$FOUNDARY_PATH/prtech/techLEF/N551P6M_ieda.lef"

set LIB_FILE                "$CELL_BASE_PATH/ics55_LLSC_H7CL/liberty/ics55_LLSC_H7CL_typ_tt_1p2_25_nldm.lib"

set STDCELL_LEF_FILE        "$CELL_BASE_PATH/ics55_LLSC_H7CL/lef/ics55_LLSC_H7CL_ieda.lef"

set BLACKBOX_V_FILE         ""
set CLKGATE_MAP_FILE        ""
set LATCH_MAP_FILE          ""
set BLACKBOX_MAP_TCL        ""

set TIEHI_CELL_AND_PORT     "TIEHIH7L Z"
set TIELO_CELL_AND_PORT     "TIELOH7L Z"
set MIN_BUF_CELL_AND_PORTS  "BUFX3H7L A Y"
set INO_INSERT_BUF          "BUFX3H7L"
