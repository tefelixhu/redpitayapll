set project_name pll_project
set part_name xc7z010clg400-1
set bd_path tmp/$project_name/$project_name.srcs/sources_1/bd/system

file delete -force tmp/$project_name

create_project $project_name tmp/$project_name -part $part_name

create_bd_design system



# Load any additional VHDL files in the project folder
set files [glob -nocomplain vhdl/*.vhd]
if {[llength $files] > 0} {
  add_files -norecurse $files
}
update_compile_order -fileset sources_1

#add ADC files
add_files -norecurse cores/axis_red_pitaya_adc_v1_0/axis_red_pitaya_adc.vhd
add_files -norecurse cores/axis_red_pitaya_adc_v1_0/clock_div_dec_filter.vhd

#add DAC files
add_files -norecurse cores/axis_red_pitaya_dac_v1_0/axis_red_pitaya_dac.v

#add constraint files
add_files -fileset constrs_1 -norecurse {cfg/clocks.xdc cfg/ports.xdc}

source scripts/create_block_design.tcl

set_property CONFIG.FREQ_HZ 31250000 [get_bd_pins /adc/axis_red_pitaya_adc_0/adc_clk]

regenerate_bd_layout

make_wrapper -files [get_files $bd_path/system.bd] -top
add_files -norecurse $bd_path/hdl/system_wrapper.v
set_property top system_wrapper [current_fileset]
save_bd_design
