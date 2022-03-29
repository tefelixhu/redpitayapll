
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# sum_limit, sum_limit, axis_red_pitaya_adc, axis_red_pitaya_dac, dac_out_switch, pid_w_range, pid_w_range, dec_filter, exp_avg_filter_order, exp_avg_filter_order, mult_n_1, mult_n_1, freq_div, nco_driver_2, waveform_gen, weight_sum, dec_filter, exp_avg_filter_order, exp_avg_filter_order, mult_n_1, mult_n_1, freq_div, nco_driver_2, waveform_gen, weight_sum

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: wave_gen
proc create_hier_cell_wave_gen_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_wave_gen_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 11 -to 0 C_DO
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 0 -to 0 Div_SI
  create_bd_pin -dir I -from 31 -to 0 NcoSet_DI
  create_bd_pin -dir I PidEn_SI
  create_bd_pin -dir I -from 31 -to 0 PidIn_DI
  create_bd_pin -dir I PidValid_SI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O SGN_COS
  create_bd_pin -dir O SGN_SIN
  create_bd_pin -dir O Valid_SO
  create_bd_pin -dir I -from 7 -to 0 WA_DI
  create_bd_pin -dir I -from 7 -to 0 WB_DI

  # Create instance: freq_div_0, and set properties
  set block_name freq_div
  set block_cell_name freq_div_0
  if { [catch {set freq_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_div_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nco_driver_2_0, and set properties
  set block_name nco_driver_2
  set block_cell_name nco_driver_2_0
  if { [catch {set nco_driver_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nco_driver_2_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: waveform_gen_0, and set properties
  set block_name waveform_gen
  set block_cell_name waveform_gen_0
  if { [catch {set waveform_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $waveform_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: weight_sum_0, and set properties
  set block_name weight_sum
  set block_cell_name weight_sum_0
  if { [catch {set weight_sum_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $weight_sum_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N_IN {12} \
CONFIG.N_OUT {12} \
CONFIG.N_WEIGHTS {8} \
 ] $weight_sum_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create port connections
  connect_bd_net -net NcoSet_DI_1 [get_bd_pins NcoSet_DI] [get_bd_pins nco_driver_2_0/NcoSet_DI]
  connect_bd_net -net Net [get_bd_pins Clk_CI] [get_bd_pins freq_div_0/Clk_CI] [get_bd_pins nco_driver_2_0/Clk_CI] [get_bd_pins waveform_gen_0/clk] [get_bd_pins weight_sum_0/Clk_CI]
  connect_bd_net -net Net1 [get_bd_pins Reset_RBI] [get_bd_pins freq_div_0/Reset_RBI] [get_bd_pins nco_driver_2_0/Reset_RBI] [get_bd_pins waveform_gen_0/reset] [get_bd_pins weight_sum_0/Reset_RBI]
  connect_bd_net -net Net2 [get_bd_pins Div_SI] [get_bd_pins freq_div_0/Div_SI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins PidEn_SI] [get_bd_pins nco_driver_2_0/PidEn_SI]
  connect_bd_net -net PidIn_DI_1 [get_bd_pins PidIn_DI] [get_bd_pins nco_driver_2_0/PidIn_DI]
  connect_bd_net -net PidValid_SI_1 [get_bd_pins PidValid_SI] [get_bd_pins nco_driver_2_0/PidValid_SI]
  connect_bd_net -net WA_DI_1 [get_bd_pins WA_DI] [get_bd_pins weight_sum_0/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins WB_DI] [get_bd_pins weight_sum_0/WB_DI]
  connect_bd_net -net freq_div_0_OscOut_SO [get_bd_pins SGN_COS] [get_bd_pins freq_div_0/SgnCosOut_SO]
  connect_bd_net -net freq_div_0_SgnSinOut_SO [get_bd_pins SGN_SIN] [get_bd_pins freq_div_0/SgnSinOut_SO]
  connect_bd_net -net nco_driver_2_0_NcoOut_DO [get_bd_pins nco_driver_2_0/NcoOut_DO] [get_bd_pins waveform_gen_0/phase_inc]
  connect_bd_net -net waveform_gen_0_cos_out [get_bd_pins waveform_gen_0/cos_out] [get_bd_pins weight_sum_0/A_DI]
  connect_bd_net -net waveform_gen_0_sgn_cos_out [get_bd_pins freq_div_0/SgnCosIn_SI] [get_bd_pins waveform_gen_0/sgn_cos_out]
  connect_bd_net -net waveform_gen_0_sgn_sin_out [get_bd_pins freq_div_0/SgnSinIn_SI] [get_bd_pins waveform_gen_0/sgn_sin_out]
  connect_bd_net -net waveform_gen_0_sin_out [get_bd_pins waveform_gen_0/sin_out] [get_bd_pins weight_sum_0/B_DI]
  connect_bd_net -net weight_sum_0_C_DO [get_bd_pins C_DO] [get_bd_pins weight_sum_0/C_DO]
  connect_bd_net -net weight_sum_0_Valid_SO [get_bd_pins Valid_SO] [get_bd_pins weight_sum_0/Valid_SO]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins waveform_gen_0/en] [get_bd_pins weight_sum_0/Valid_SI] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: phase_det
proc create_hier_cell_phase_det_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_phase_det_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 16 -to 0 Alpha_DI
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 2 -to 0 Order_DI
  create_bd_pin -dir O PhiValid_SO
  create_bd_pin -dir O -from 15 -to 0 Phi_DO
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I SGN_COS
  create_bd_pin -dir I SGN_SIN
  create_bd_pin -dir O -from 15 -to 0 mix_cos
  create_bd_pin -dir O -from 23 -to 0 mix_cos_dec
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_dec_valid
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir O -from 15 -to 0 mix_sin
  create_bd_pin -dir O -from 23 -to 0 mix_sin_dec
  create_bd_pin -dir O -from 23 -to 0 mix_sin_lpf

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
CONFIG.Coarse_Rotation {true} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Arc_Tan} \
CONFIG.Input_Width {24} \
CONFIG.Output_Width {16} \
CONFIG.Phase_Format {Scaled_Radians} \
 ] $cordic_0

  # Create instance: dec_filter_0, and set properties
  set block_name dec_filter
  set block_cell_name dec_filter_0
  if { [catch {set dec_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dec_filter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.CEILLOGDEC {8} \
CONFIG.DEC {256} \
CONFIG.DIV {1} \
CONFIG.N {16} \
CONFIG.N_OUT {24} \
 ] $dec_filter_0

  # Create instance: exp_avg_filter_order_0, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_0
  if { [catch {set exp_avg_filter_order_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {24} \
CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_0

  # Create instance: exp_avg_filter_order_1, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_1
  if { [catch {set exp_avg_filter_order_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {24} \
CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_1

  # Create instance: mult_n_1_0, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_0
  if { [catch {set mult_n_1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {16} \
 ] $mult_n_1_0

  # Create instance: mult_n_1_1, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_1
  if { [catch {set mult_n_1_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {16} \
 ] $mult_n_1_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {16} \
CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {24} \
CONFIG.IN1_WIDTH {24} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {48} \
CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {47} \
CONFIG.DIN_TO {24} \
CONFIG.DIN_WIDTH {48} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins Alpha_DI] [get_bd_pins exp_avg_filter_order_0/Alpha_DI] [get_bd_pins exp_avg_filter_order_1/Alpha_DI]
  connect_bd_net -net Net [get_bd_pins Ref_DI] [get_bd_pins mult_n_1_0/A_DI] [get_bd_pins mult_n_1_1/A_DI]
  connect_bd_net -net Net1 [get_bd_pins Clk_CI] [get_bd_pins cordic_0/aclk] [get_bd_pins dec_filter_0/Clk_CI] [get_bd_pins exp_avg_filter_order_0/Clk_CI] [get_bd_pins exp_avg_filter_order_1/Clk_CI] [get_bd_pins mult_n_1_0/Clk_CI] [get_bd_pins mult_n_1_1/Clk_CI]
  connect_bd_net -net Net2 [get_bd_pins Reset_RBI] [get_bd_pins dec_filter_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_1/Reset_RBI] [get_bd_pins mult_n_1_0/Reset_RBI] [get_bd_pins mult_n_1_1/Reset_RBI]
  connect_bd_net -net Order_DI_1 [get_bd_pins Order_DI] [get_bd_pins exp_avg_filter_order_0/Order_SI] [get_bd_pins exp_avg_filter_order_1/Order_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins SGN_COS] [get_bd_pins mult_n_1_0/B_DI]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins SGN_SIN] [get_bd_pins mult_n_1_1/B_DI]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins Phi_DO] [get_bd_pins cordic_0/m_axis_dout_tdata]
  connect_bd_net -net cordic_0_m_axis_dout_tvalid [get_bd_pins PhiValid_SO] [get_bd_pins cordic_0/m_axis_dout_tvalid]
  connect_bd_net -net dec_filter_0_Out_DO [get_bd_pins dec_filter_0/Out_DO] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dec_filter_0_Valid_SO [get_bd_pins mix_dec_valid] [get_bd_pins dec_filter_0/Valid_SO] [get_bd_pins exp_avg_filter_order_0/Valid_SI] [get_bd_pins exp_avg_filter_order_1/Valid_SI]
  connect_bd_net -net exp_avg_filter_order_0_Y_DO [get_bd_pins mix_cos_lpf] [get_bd_pins exp_avg_filter_order_0/Y_DO] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net exp_avg_filter_order_1_Y_DO [get_bd_pins mix_sin_lpf] [get_bd_pins exp_avg_filter_order_1/Y_DO] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net fir_compiler_0_m_axis_data_tvalid [get_bd_pins mix_lpf_valid] [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins exp_avg_filter_order_0/Valid_SO]
  connect_bd_net -net mult_n_1_0_C_DO [get_bd_pins mix_cos] [get_bd_pins mult_n_1_0/C_DO] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_n_1_1_C_DO [get_bd_pins mix_sin] [get_bd_pins mult_n_1_1/C_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dec_filter_0/In_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dec_filter_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins mix_cos_dec] [get_bd_pins exp_avg_filter_order_0/X_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins mix_sin_dec] [get_bd_pins exp_avg_filter_order_1/X_DI] [get_bd_pins xlslice_2/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: wave_gen
proc create_hier_cell_wave_gen { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_wave_gen() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 11 -to 0 C_DO
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 0 -to 0 Div_SI
  create_bd_pin -dir I -from 31 -to 0 NcoSet_DI
  create_bd_pin -dir I PidEn_SI
  create_bd_pin -dir I -from 31 -to 0 PidIn_DI
  create_bd_pin -dir I PidValid_SI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O SGN_COS
  create_bd_pin -dir O SGN_SIN
  create_bd_pin -dir O Valid_SO
  create_bd_pin -dir I -from 7 -to 0 WA_DI
  create_bd_pin -dir I -from 7 -to 0 WB_DI

  # Create instance: freq_div_0, and set properties
  set block_name freq_div
  set block_cell_name freq_div_0
  if { [catch {set freq_div_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_div_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nco_driver_2_0, and set properties
  set block_name nco_driver_2
  set block_cell_name nco_driver_2_0
  if { [catch {set nco_driver_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nco_driver_2_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: waveform_gen_0, and set properties
  set block_name waveform_gen
  set block_cell_name waveform_gen_0
  if { [catch {set waveform_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $waveform_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: weight_sum_0, and set properties
  set block_name weight_sum
  set block_cell_name weight_sum_0
  if { [catch {set weight_sum_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $weight_sum_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N_IN {12} \
CONFIG.N_OUT {12} \
CONFIG.N_WEIGHTS {8} \
 ] $weight_sum_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create port connections
  connect_bd_net -net NcoSet_DI_1 [get_bd_pins NcoSet_DI] [get_bd_pins nco_driver_2_0/NcoSet_DI]
  connect_bd_net -net Net [get_bd_pins Clk_CI] [get_bd_pins freq_div_0/Clk_CI] [get_bd_pins nco_driver_2_0/Clk_CI] [get_bd_pins waveform_gen_0/clk] [get_bd_pins weight_sum_0/Clk_CI]
  connect_bd_net -net Net1 [get_bd_pins Reset_RBI] [get_bd_pins freq_div_0/Reset_RBI] [get_bd_pins nco_driver_2_0/Reset_RBI] [get_bd_pins waveform_gen_0/reset] [get_bd_pins weight_sum_0/Reset_RBI]
  connect_bd_net -net Net2 [get_bd_pins Div_SI] [get_bd_pins freq_div_0/Div_SI]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins PidEn_SI] [get_bd_pins nco_driver_2_0/PidEn_SI]
  connect_bd_net -net PidIn_DI_1 [get_bd_pins PidIn_DI] [get_bd_pins nco_driver_2_0/PidIn_DI]
  connect_bd_net -net PidValid_SI_1 [get_bd_pins PidValid_SI] [get_bd_pins nco_driver_2_0/PidValid_SI]
  connect_bd_net -net WA_DI_1 [get_bd_pins WA_DI] [get_bd_pins weight_sum_0/WA_DI]
  connect_bd_net -net WB_DI_1 [get_bd_pins WB_DI] [get_bd_pins weight_sum_0/WB_DI]
  connect_bd_net -net freq_div_0_OscOut_SO [get_bd_pins SGN_COS] [get_bd_pins freq_div_0/SgnCosOut_SO]
  connect_bd_net -net freq_div_0_SgnSinOut_SO [get_bd_pins SGN_SIN] [get_bd_pins freq_div_0/SgnSinOut_SO]
  connect_bd_net -net nco_driver_2_0_NcoOut_DO [get_bd_pins nco_driver_2_0/NcoOut_DO] [get_bd_pins waveform_gen_0/phase_inc]
  connect_bd_net -net waveform_gen_0_cos_out [get_bd_pins waveform_gen_0/cos_out] [get_bd_pins weight_sum_0/A_DI]
  connect_bd_net -net waveform_gen_0_sgn_cos_out [get_bd_pins freq_div_0/SgnCosIn_SI] [get_bd_pins waveform_gen_0/sgn_cos_out]
  connect_bd_net -net waveform_gen_0_sgn_sin_out [get_bd_pins freq_div_0/SgnSinIn_SI] [get_bd_pins waveform_gen_0/sgn_sin_out]
  connect_bd_net -net waveform_gen_0_sin_out [get_bd_pins waveform_gen_0/sin_out] [get_bd_pins weight_sum_0/B_DI]
  connect_bd_net -net weight_sum_0_C_DO [get_bd_pins C_DO] [get_bd_pins weight_sum_0/C_DO]
  connect_bd_net -net weight_sum_0_Valid_SO [get_bd_pins Valid_SO] [get_bd_pins weight_sum_0/Valid_SO]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins waveform_gen_0/en] [get_bd_pins weight_sum_0/Valid_SI] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: phase_det
proc create_hier_cell_phase_det { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_phase_det() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 16 -to 0 Alpha_DI
  create_bd_pin -dir I Clk_CI
  create_bd_pin -dir I -from 2 -to 0 Order_DI
  create_bd_pin -dir O PhiValid_SO
  create_bd_pin -dir O -from 15 -to 0 Phi_DO
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I SGN_COS
  create_bd_pin -dir I SGN_SIN
  create_bd_pin -dir O -from 15 -to 0 mix_cos
  create_bd_pin -dir O -from 23 -to 0 mix_cos_dec
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_dec_valid
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir O -from 15 -to 0 mix_sin
  create_bd_pin -dir O -from 23 -to 0 mix_sin_dec
  create_bd_pin -dir O -from 23 -to 0 mix_sin_lpf

  # Create instance: cordic_0, and set properties
  set cordic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 cordic_0 ]
  set_property -dict [ list \
CONFIG.Coarse_Rotation {true} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Arc_Tan} \
CONFIG.Input_Width {24} \
CONFIG.Output_Width {16} \
CONFIG.Phase_Format {Scaled_Radians} \
 ] $cordic_0

  # Create instance: dec_filter_0, and set properties
  set block_name dec_filter
  set block_cell_name dec_filter_0
  if { [catch {set dec_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dec_filter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.CEILLOGDEC {8} \
CONFIG.DEC {256} \
CONFIG.DIV {1} \
CONFIG.N {16} \
CONFIG.N_OUT {24} \
 ] $dec_filter_0

  # Create instance: exp_avg_filter_order_0, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_0
  if { [catch {set exp_avg_filter_order_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {24} \
CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_0

  # Create instance: exp_avg_filter_order_1, and set properties
  set block_name exp_avg_filter_order
  set block_cell_name exp_avg_filter_order_1
  if { [catch {set exp_avg_filter_order_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exp_avg_filter_order_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {24} \
CONFIG.N_ALPHA {17} \
 ] $exp_avg_filter_order_1

  # Create instance: mult_n_1_0, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_0
  if { [catch {set mult_n_1_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {16} \
 ] $mult_n_1_0

  # Create instance: mult_n_1_1, and set properties
  set block_name mult_n_1
  set block_cell_name mult_n_1_1
  if { [catch {set mult_n_1_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mult_n_1_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {16} \
 ] $mult_n_1_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {16} \
CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {24} \
CONFIG.IN1_WIDTH {24} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {48} \
CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {47} \
CONFIG.DIN_TO {24} \
CONFIG.DIN_WIDTH {48} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins Alpha_DI] [get_bd_pins exp_avg_filter_order_0/Alpha_DI] [get_bd_pins exp_avg_filter_order_1/Alpha_DI]
  connect_bd_net -net Net [get_bd_pins Ref_DI] [get_bd_pins mult_n_1_0/A_DI] [get_bd_pins mult_n_1_1/A_DI]
  connect_bd_net -net Net1 [get_bd_pins Clk_CI] [get_bd_pins cordic_0/aclk] [get_bd_pins dec_filter_0/Clk_CI] [get_bd_pins exp_avg_filter_order_0/Clk_CI] [get_bd_pins exp_avg_filter_order_1/Clk_CI] [get_bd_pins mult_n_1_0/Clk_CI] [get_bd_pins mult_n_1_1/Clk_CI]
  connect_bd_net -net Net2 [get_bd_pins Reset_RBI] [get_bd_pins dec_filter_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_0/Reset_RBI] [get_bd_pins exp_avg_filter_order_1/Reset_RBI] [get_bd_pins mult_n_1_0/Reset_RBI] [get_bd_pins mult_n_1_1/Reset_RBI]
  connect_bd_net -net Order_DI_1 [get_bd_pins Order_DI] [get_bd_pins exp_avg_filter_order_0/Order_SI] [get_bd_pins exp_avg_filter_order_1/Order_SI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins SGN_COS] [get_bd_pins mult_n_1_0/B_DI]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins SGN_SIN] [get_bd_pins mult_n_1_1/B_DI]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins Phi_DO] [get_bd_pins cordic_0/m_axis_dout_tdata]
  connect_bd_net -net cordic_0_m_axis_dout_tvalid [get_bd_pins PhiValid_SO] [get_bd_pins cordic_0/m_axis_dout_tvalid]
  connect_bd_net -net dec_filter_0_Out_DO [get_bd_pins dec_filter_0/Out_DO] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dec_filter_0_Valid_SO [get_bd_pins mix_dec_valid] [get_bd_pins dec_filter_0/Valid_SO] [get_bd_pins exp_avg_filter_order_0/Valid_SI] [get_bd_pins exp_avg_filter_order_1/Valid_SI]
  connect_bd_net -net exp_avg_filter_order_0_Y_DO [get_bd_pins mix_cos_lpf] [get_bd_pins exp_avg_filter_order_0/Y_DO] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net exp_avg_filter_order_1_Y_DO [get_bd_pins mix_sin_lpf] [get_bd_pins exp_avg_filter_order_1/Y_DO] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins cordic_0/s_axis_cartesian_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net fir_compiler_0_m_axis_data_tvalid [get_bd_pins mix_lpf_valid] [get_bd_pins cordic_0/s_axis_cartesian_tvalid] [get_bd_pins exp_avg_filter_order_0/Valid_SO]
  connect_bd_net -net mult_n_1_0_C_DO [get_bd_pins mix_cos] [get_bd_pins mult_n_1_0/C_DO] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_n_1_1_C_DO [get_bd_pins mix_sin] [get_bd_pins mult_n_1_1/C_DO] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dec_filter_0/In_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dec_filter_0/Valid_SI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins mix_cos_dec] [get_bd_pins exp_avg_filter_order_0/X_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins mix_sin_dec] [get_bd_pins exp_avg_filter_order_1/X_DI] [get_bd_pins xlslice_2/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: soc
proc create_hier_cell_soc { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_soc() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M07_AXI

  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_IMPORT_BOARD_PRESET {cfg/red_pitaya.xml} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {8} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_125M, and set properties
  set rst_ps7_0_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_125M ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M01_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M02_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M04_AXI] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M05_AXI] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M06_AXI] [get_bd_intf_pins ps7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M07_AXI] [get_bd_intf_pins ps7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_125M/interconnect_aresetn]
  connect_bd_net -net M00_ACLK_1 [get_bd_pins clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_125M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_125M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_125M_peripheral_aresetn [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_125M/peripheral_aresetn]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pll2
proc create_hier_cell_pll2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pll2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  # Create pins
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O -from 11 -to 0 WAVE
  create_bd_pin -dir O WAVE_VALID
  create_bd_pin -dir O -from 15 -to 0 mix_cos
  create_bd_pin -dir O -from 23 -to 0 mix_cos_dec
  create_bd_pin -dir O -from 23 -to 0 mix_cos_lpf
  create_bd_pin -dir O mix_dec_valid
  create_bd_pin -dir O mix_lpf_valid
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_1

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_2

  # Create instance: axi_gpio_3, and set properties
  set axi_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3 ]

  # Create instance: phase_det
  create_hier_cell_phase_det_1 $hier_obj phase_det

  # Create instance: pid_w_range_0, and set properties
  set block_name pid_w_range
  set block_cell_name pid_w_range_0
  if { [catch {set pid_w_range_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pid_w_range_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: wave_gen
  create_hier_cell_wave_gen_1 $hier_obj wave_gen

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {26} \
CONFIG.DIN_TO {10} \
CONFIG.DOUT_WIDTH {17} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {2} \
CONFIG.DOUT_WIDTH {3} \
 ] $xlslice_1

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {8} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {6} \
CONFIG.DIN_TO {6} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DIN_TO {7} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_gpio_2/S_AXI]
  connect_bd_intf_net -intf_net S_AXI3_1 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_gpio_3/S_AXI]

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins phase_det/Alpha_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net Div_SI_1 [get_bd_pins wave_gen/Div_SI] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins wave_gen/PidEn_SI] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net Ref_DI_1 [get_bd_pins Ref_DI] [get_bd_pins phase_det/Ref_DI]
  connect_bd_net -net Reset_RBI_1 [get_bd_pins Reset_RBI] [get_bd_pins phase_det/Reset_RBI] [get_bd_pins pid_w_range_0/Reset_RBI] [get_bd_pins wave_gen/Reset_RBI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins phase_det/SGN_COS] [get_bd_pins wave_gen/SGN_COS]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins phase_det/SGN_SIN] [get_bd_pins wave_gen/SGN_SIN]
  connect_bd_net -net WA_DI_1 [get_bd_pins wave_gen/WA_DI] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net WB_DI_1 [get_bd_pins wave_gen/WB_DI] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins axi_gpio_1/gpio2_io_i] [get_bd_pins axi_gpio_1/gpio2_io_o] [get_bd_pins pid_w_range_0/Ki]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins axi_gpio_1/gpio_io_i] [get_bd_pins axi_gpio_1/gpio_io_o] [get_bd_pins pid_w_range_0/Kp]
  connect_bd_net -net axi_gpio_2_gpio2_io_o [get_bd_pins axi_gpio_2/gpio2_io_i] [get_bd_pins axi_gpio_2/gpio2_io_o] [get_bd_pins pid_w_range_0/Range_DI]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins axi_gpio_2/gpio_io_i] [get_bd_pins axi_gpio_2/gpio_io_o] [get_bd_pins wave_gen/NcoSet_DI]
  connect_bd_net -net axi_gpio_3_gpio_io_o [get_bd_pins axi_gpio_3/gpio_io_i] [get_bd_pins axi_gpio_3/gpio_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net phase_det_PhiValid_SO [get_bd_pins phase_det/PhiValid_SO] [get_bd_pins pid_w_range_0/Valid_SI]
  connect_bd_net -net phase_det_Phi_DO [get_bd_pins phase_det/Phi_DO] [get_bd_pins pid_w_range_0/Din_DI]
  connect_bd_net -net phase_det_mix_cos [get_bd_pins mix_cos] [get_bd_pins phase_det/mix_cos]
  connect_bd_net -net phase_det_mix_cos_dec [get_bd_pins mix_cos_dec] [get_bd_pins phase_det/mix_cos_dec]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins mix_cos_lpf] [get_bd_pins phase_det/mix_cos_lpf]
  connect_bd_net -net phase_det_mix_dec_valid [get_bd_pins mix_dec_valid] [get_bd_pins phase_det/mix_dec_valid]
  connect_bd_net -net phase_det_mix_lpf_valid [get_bd_pins mix_lpf_valid] [get_bd_pins phase_det/mix_lpf_valid]
  connect_bd_net -net pid_w_range_0_Dout_DO [get_bd_pins pid_w_range_0/Dout_DO] [get_bd_pins wave_gen/PidIn_DI]
  connect_bd_net -net pid_w_range_0_Valid_SO [get_bd_pins pid_w_range_0/Valid_SO] [get_bd_pins wave_gen/PidValid_SI]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_gpio_3/s_axi_aclk] [get_bd_pins phase_det/Clk_CI] [get_bd_pins pid_w_range_0/Clk_CI] [get_bd_pins wave_gen/Clk_CI]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn]
  connect_bd_net -net wave_gen_C_DO [get_bd_pins WAVE] [get_bd_pins wave_gen/C_DO]
  connect_bd_net -net wave_gen_Valid_SO [get_bd_pins WAVE_VALID] [get_bd_pins wave_gen/Valid_SO]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins phase_det/Order_DI] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pll1
proc create_hier_cell_pll1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pll1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  # Create pins
  create_bd_pin -dir O -from 23 -to 0 LI_X
  create_bd_pin -dir O -from 23 -to 0 LI_Y
  create_bd_pin -dir O LI_valid
  create_bd_pin -dir I -from 15 -to 0 Ref_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir O -from 2 -to 0 SelDacA
  create_bd_pin -dir O -from 2 -to 0 SelDacB
  create_bd_pin -dir O -from 11 -to 0 WAVE
  create_bd_pin -dir O WAVE_VALID
  create_bd_pin -dir O -from 7 -to 0 ext_pins_n
  create_bd_pin -dir O -from 7 -to 0 ext_pins_p
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_1

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_2

  # Create instance: axi_gpio_3, and set properties
  set axi_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3 ]

  # Create instance: phase_det
  create_hier_cell_phase_det $hier_obj phase_det

  # Create instance: pid_w_range_0, and set properties
  set block_name pid_w_range
  set block_cell_name pid_w_range_0
  if { [catch {set pid_w_range_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pid_w_range_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: wave_gen
  create_hier_cell_wave_gen $hier_obj wave_gen

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {26} \
CONFIG.DIN_TO {10} \
CONFIG.DOUT_WIDTH {17} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {2} \
CONFIG.DOUT_WIDTH {3} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {2} \
CONFIG.DOUT_WIDTH {3} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {8} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {6} \
CONFIG.DIN_TO {6} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DIN_TO {7} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {5} \
CONFIG.DIN_TO {3} \
CONFIG.DOUT_WIDTH {3} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {31} \
CONFIG.DIN_TO {24} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {16} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_9

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_gpio_2/S_AXI]
  connect_bd_intf_net -intf_net S_AXI3_1 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_gpio_3/S_AXI]

  # Create port connections
  connect_bd_net -net Alpha_DI_1 [get_bd_pins phase_det/Alpha_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net Div_SI_1 [get_bd_pins wave_gen/Div_SI] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net PidEn_SI_1 [get_bd_pins wave_gen/PidEn_SI] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net Ref_DI_1 [get_bd_pins Ref_DI] [get_bd_pins phase_det/Ref_DI]
  connect_bd_net -net Reset_RBI_1 [get_bd_pins Reset_RBI] [get_bd_pins phase_det/Reset_RBI] [get_bd_pins pid_w_range_0/Reset_RBI] [get_bd_pins wave_gen/Reset_RBI]
  connect_bd_net -net SGN_COS_1 [get_bd_pins phase_det/SGN_COS] [get_bd_pins wave_gen/SGN_COS]
  connect_bd_net -net SGN_SIN_1 [get_bd_pins phase_det/SGN_SIN] [get_bd_pins wave_gen/SGN_SIN]
  connect_bd_net -net WA_DI_1 [get_bd_pins wave_gen/WA_DI] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net WB_DI_1 [get_bd_pins wave_gen/WB_DI] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net axi_gpio_1_gpio2_io_o [get_bd_pins axi_gpio_1/gpio2_io_i] [get_bd_pins axi_gpio_1/gpio2_io_o] [get_bd_pins pid_w_range_0/Ki]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins axi_gpio_1/gpio_io_i] [get_bd_pins axi_gpio_1/gpio_io_o] [get_bd_pins pid_w_range_0/Kp]
  connect_bd_net -net axi_gpio_2_gpio2_io_o [get_bd_pins axi_gpio_2/gpio2_io_i] [get_bd_pins axi_gpio_2/gpio2_io_o] [get_bd_pins pid_w_range_0/Range_DI]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins axi_gpio_2/gpio_io_i] [get_bd_pins axi_gpio_2/gpio_io_o] [get_bd_pins wave_gen/NcoSet_DI]
  connect_bd_net -net axi_gpio_3_gpio_io_o [get_bd_pins axi_gpio_3/gpio_io_i] [get_bd_pins axi_gpio_3/gpio_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net phase_det_PhiValid_SO [get_bd_pins phase_det/PhiValid_SO] [get_bd_pins pid_w_range_0/Valid_SI]
  connect_bd_net -net phase_det_Phi_DO [get_bd_pins phase_det/Phi_DO] [get_bd_pins pid_w_range_0/Din_DI]
  connect_bd_net -net phase_det_mix_cos_lpf [get_bd_pins LI_X] [get_bd_pins phase_det/mix_cos_lpf]
  connect_bd_net -net phase_det_mix_lpf_valid [get_bd_pins LI_valid] [get_bd_pins phase_det/mix_lpf_valid]
  connect_bd_net -net phase_det_mix_sin_lpf [get_bd_pins LI_Y] [get_bd_pins phase_det/mix_sin_lpf]
  connect_bd_net -net pid_w_range_0_Dout_DO [get_bd_pins pid_w_range_0/Dout_DO] [get_bd_pins wave_gen/PidIn_DI]
  connect_bd_net -net pid_w_range_0_Valid_SO [get_bd_pins pid_w_range_0/Valid_SO] [get_bd_pins wave_gen/PidValid_SI]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_gpio_3/s_axi_aclk] [get_bd_pins phase_det/Clk_CI] [get_bd_pins pid_w_range_0/Clk_CI] [get_bd_pins wave_gen/Clk_CI]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn]
  connect_bd_net -net wave_gen_C_DO [get_bd_pins WAVE] [get_bd_pins wave_gen/C_DO]
  connect_bd_net -net wave_gen_Valid_SO [get_bd_pins WAVE_VALID] [get_bd_pins wave_gen/Valid_SO]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins phase_det/Order_DI] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins SelDacA] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins SelDacB] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins ext_pins_n] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins ext_pins_p] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dac
proc create_hier_cell_dac { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dac() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk Clk_CI
  create_bd_pin -dir I -from 13 -to 0 In0_DI
  create_bd_pin -dir I -from 13 -to 0 In1_DI
  create_bd_pin -dir I -from 13 -to 0 In2_DI
  create_bd_pin -dir I -from 13 -to 0 In3_DI
  create_bd_pin -dir I -from 13 -to 0 In4_DI
  create_bd_pin -dir I -from 13 -to 0 In5_DI
  create_bd_pin -dir I -from 13 -to 0 In6_DI
  create_bd_pin -dir I -from 13 -to 0 In7_DI
  create_bd_pin -dir I -type rst Reset_RBI
  create_bd_pin -dir I -from 2 -to 0 SwitchDac0_SI
  create_bd_pin -dir I -from 2 -to 0 SwitchDac1_SI
  create_bd_pin -dir I Valid0_SI
  create_bd_pin -dir I Valid1_SI
  create_bd_pin -dir I Valid2_SI
  create_bd_pin -dir I Valid3_SI
  create_bd_pin -dir I Valid4_SI
  create_bd_pin -dir I Valid5_SI
  create_bd_pin -dir I Valid6_SI
  create_bd_pin -dir I Valid7_SI
  create_bd_pin -dir O -type clk dac_clk
  create_bd_pin -dir O -from 13 -to 0 dac_dat
  create_bd_pin -dir O -type rst dac_rst
  create_bd_pin -dir O dac_sel
  create_bd_pin -dir O dac_wrt

  # Create instance: axis_red_pitaya_dac_0, and set properties
  set block_name axis_red_pitaya_dac
  set block_cell_name axis_red_pitaya_dac_0
  if { [catch {set axis_red_pitaya_dac_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_red_pitaya_dac_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {320.0} \
CONFIG.CLKOUT1_JITTER {175.817} \
CONFIG.CLKOUT1_PHASE_ERROR {204.239} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250.000} \
CONFIG.MMCM_CLKFBOUT_MULT_F {32.000} \
CONFIG.MMCM_CLKIN1_PERIOD {32.000} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.PRIM_IN_FREQ {31.25} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: dac_out_switch_0, and set properties
  set block_name dac_out_switch
  set block_cell_name dac_out_switch_0
  if { [catch {set dac_out_switch_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dac_out_switch_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net Clk_CI_1 [get_bd_pins Clk_CI] [get_bd_pins axis_red_pitaya_dac_0/aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins dac_out_switch_0/Clk_CI]
  connect_bd_net -net In0_DI_1 [get_bd_pins In0_DI] [get_bd_pins dac_out_switch_0/In0_DI]
  connect_bd_net -net In1_DI_1 [get_bd_pins In1_DI] [get_bd_pins dac_out_switch_0/In1_DI]
  connect_bd_net -net In2_DI_1 [get_bd_pins In2_DI] [get_bd_pins dac_out_switch_0/In2_DI]
  connect_bd_net -net In3_DI_1 [get_bd_pins In3_DI] [get_bd_pins dac_out_switch_0/In3_DI]
  connect_bd_net -net In4_DI_1 [get_bd_pins In4_DI] [get_bd_pins dac_out_switch_0/In4_DI]
  connect_bd_net -net In5_DI_1 [get_bd_pins In5_DI] [get_bd_pins dac_out_switch_0/In5_DI]
  connect_bd_net -net In6_DI_1 [get_bd_pins In6_DI] [get_bd_pins dac_out_switch_0/In6_DI]
  connect_bd_net -net In7_DI_1 [get_bd_pins In7_DI] [get_bd_pins dac_out_switch_0/In7_DI]
  connect_bd_net -net Reset_RBI_1 [get_bd_pins Reset_RBI] [get_bd_pins dac_out_switch_0/Reset_RBI]
  connect_bd_net -net SwitchDac0_SI_1 [get_bd_pins SwitchDac0_SI] [get_bd_pins dac_out_switch_0/SwitchDac0_SI]
  connect_bd_net -net SwitchDac1_SI_1 [get_bd_pins SwitchDac1_SI] [get_bd_pins dac_out_switch_0/SwitchDac1_SI]
  connect_bd_net -net Valid0_SI_1 [get_bd_pins Valid0_SI] [get_bd_pins dac_out_switch_0/Valid0_SI]
  connect_bd_net -net Valid1_SI_1 [get_bd_pins Valid1_SI] [get_bd_pins dac_out_switch_0/Valid1_SI]
  connect_bd_net -net Valid2_SI_1 [get_bd_pins Valid2_SI] [get_bd_pins dac_out_switch_0/Valid2_SI]
  connect_bd_net -net Valid3_SI_1 [get_bd_pins Valid3_SI] [get_bd_pins dac_out_switch_0/Valid3_SI]
  connect_bd_net -net Valid4_SI_1 [get_bd_pins Valid4_SI] [get_bd_pins dac_out_switch_0/Valid4_SI]
  connect_bd_net -net Valid5_SI_1 [get_bd_pins Valid5_SI] [get_bd_pins dac_out_switch_0/Valid5_SI]
  connect_bd_net -net Valid6_SI_1 [get_bd_pins Valid6_SI] [get_bd_pins dac_out_switch_0/Valid6_SI]
  connect_bd_net -net Valid7_SI_1 [get_bd_pins Valid7_SI] [get_bd_pins dac_out_switch_0/Valid7_SI]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_clk [get_bd_pins dac_clk] [get_bd_pins axis_red_pitaya_dac_0/dac_clk]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_dat [get_bd_pins dac_dat] [get_bd_pins axis_red_pitaya_dac_0/dac_dat]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_rst [get_bd_pins dac_rst] [get_bd_pins axis_red_pitaya_dac_0/dac_rst]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_sel [get_bd_pins dac_sel] [get_bd_pins axis_red_pitaya_dac_0/dac_sel]
  connect_bd_net -net axis_red_pitaya_dac_0_dac_wrt [get_bd_pins dac_wrt] [get_bd_pins axis_red_pitaya_dac_0/dac_wrt]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axis_red_pitaya_dac_0/ddr_clk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins axis_red_pitaya_dac_0/locked] [get_bd_pins clk_wiz_0/locked]
  connect_bd_net -net dac_out_switch_0_DacOut_DO [get_bd_pins axis_red_pitaya_dac_0/s_axis_tdata] [get_bd_pins dac_out_switch_0/DacOut_DO]
  connect_bd_net -net dac_out_switch_0_Valid_SO [get_bd_pins axis_red_pitaya_dac_0/s_axis_tvalid] [get_bd_pins dac_out_switch_0/Valid_SO]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc
proc create_hier_cell_adc { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_adc() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 15 -to 0 adc_a
  create_bd_pin -dir O -from 15 -to 0 adc_b
  create_bd_pin -dir O adc_clk
  create_bd_pin -dir I -type clk adc_clk_n
  create_bd_pin -dir I -type clk adc_clk_p
  create_bd_pin -dir O adc_csn
  create_bd_pin -dir I -from 13 -to 0 adc_dat_a
  create_bd_pin -dir I -from 13 -to 0 adc_dat_b

  # Create instance: axis_red_pitaya_adc_0, and set properties
  set block_name axis_red_pitaya_adc
  set block_cell_name axis_red_pitaya_adc_0
  if { [catch {set axis_red_pitaya_adc_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_red_pitaya_adc_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net adc_clk_n_1 [get_bd_pins adc_clk_n] [get_bd_pins axis_red_pitaya_adc_0/adc_clk_n]
  connect_bd_net -net adc_clk_p_1 [get_bd_pins adc_clk_p] [get_bd_pins axis_red_pitaya_adc_0/adc_clk_p]
  connect_bd_net -net adc_dat_a_1 [get_bd_pins adc_dat_a] [get_bd_pins axis_red_pitaya_adc_0/adc_dat_a]
  connect_bd_net -net adc_dat_b_1 [get_bd_pins adc_dat_b] [get_bd_pins axis_red_pitaya_adc_0/adc_dat_b]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_a [get_bd_pins adc_a] [get_bd_pins axis_red_pitaya_adc_0/adc_a]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_b [get_bd_pins adc_b] [get_bd_pins axis_red_pitaya_adc_0/adc_b]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_clk [get_bd_pins adc_clk] [get_bd_pins axis_red_pitaya_adc_0/adc_clk]
  connect_bd_net -net axis_red_pitaya_adc_0_adc_csn [get_bd_pins adc_csn] [get_bd_pins axis_red_pitaya_adc_0/adc_csn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set Vaux0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0 ]
  set Vaux1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux1 ]
  set Vaux8 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8 ]
  set Vaux9 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux9 ]
  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  # Create ports
  set adc_clk_n_i [ create_bd_port -dir I adc_clk_n_i ]
  set adc_clk_p_i [ create_bd_port -dir I adc_clk_p_i ]
  set adc_csn_o [ create_bd_port -dir O adc_csn_o ]
  set adc_dat_a_i [ create_bd_port -dir I -from 13 -to 0 adc_dat_a_i ]
  set adc_dat_b_i [ create_bd_port -dir I -from 13 -to 0 adc_dat_b_i ]
  set adc_enc_n_o [ create_bd_port -dir O adc_enc_n_o ]
  set adc_enc_p_o [ create_bd_port -dir O adc_enc_p_o ]
  set dac_clk_o [ create_bd_port -dir O dac_clk_o ]
  set dac_dat_o [ create_bd_port -dir O -from 13 -to 0 dac_dat_o ]
  set dac_pwm_o [ create_bd_port -dir O -from 3 -to 0 dac_pwm_o ]
  set dac_rst_o [ create_bd_port -dir O dac_rst_o ]
  set dac_sel_o [ create_bd_port -dir O dac_sel_o ]
  set dac_wrt_o [ create_bd_port -dir O dac_wrt_o ]
  set daisy_n_i [ create_bd_port -dir I -from 1 -to 0 daisy_n_i ]
  set daisy_n_o [ create_bd_port -dir O -from 1 -to 0 daisy_n_o ]
  set daisy_p_i [ create_bd_port -dir I -from 1 -to 0 daisy_p_i ]
  set daisy_p_o [ create_bd_port -dir O -from 1 -to 0 daisy_p_o ]
  set exp_n_tri_io [ create_bd_port -dir O -from 7 -to 0 exp_n_tri_io ]
  set exp_p_tri_io [ create_bd_port -dir O -from 7 -to 0 exp_p_tri_io ]
  set led_o [ create_bd_port -dir O -from 7 -to 0 led_o ]

  # Create instance: adc
  create_hier_cell_adc [current_bd_instance .] adc

  # Create instance: dac
  create_hier_cell_dac [current_bd_instance .] dac

  # Create instance: pll1
  create_hier_cell_pll1 [current_bd_instance .] pll1

  # Create instance: pll2
  create_hier_cell_pll2 [current_bd_instance .] pll2

  # Create instance: soc
  create_hier_cell_soc [current_bd_instance .] soc

  # Create instance: sum_limit_0, and set properties
  set block_name sum_limit
  set block_cell_name sum_limit_0
  if { [catch {set sum_limit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sum_limit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {14} \
 ] $sum_limit_0

  # Create instance: sum_limit_1, and set properties
  set block_name sum_limit
  set block_cell_name sum_limit_1
  if { [catch {set sum_limit_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sum_limit_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.N {14} \
 ] $sum_limit_1

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1 ]
  set_property -dict [ list \
CONFIG.C_SIZE {2} \
 ] $util_ds_buf_1

  # Create instance: util_ds_buf_2, and set properties
  set util_ds_buf_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_2 ]
  set_property -dict [ list \
CONFIG.C_BUF_TYPE {OBUFDS} \
CONFIG.C_SIZE {2} \
 ] $util_ds_buf_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {2} \
CONFIG.IN1_WIDTH {12} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {2} \
CONFIG.IN1_WIDTH {12} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
 ] $xlconstant_4

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_5

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {2} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {2} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {2} \
CONFIG.DIN_WIDTH {16} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {10} \
CONFIG.DIN_WIDTH {24} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {10} \
CONFIG.DIN_WIDTH {24} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_4

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins pll2/S_AXI1] [get_bd_intf_pins soc/M05_AXI]
  connect_bd_intf_net -intf_net S_AXI2_1 [get_bd_intf_pins pll2/S_AXI2] [get_bd_intf_pins soc/M06_AXI]
  connect_bd_intf_net -intf_net S_AXI3_1 [get_bd_intf_pins pll1/S_AXI3] [get_bd_intf_pins soc/M03_AXI]
  connect_bd_intf_net -intf_net S_AXI3_2 [get_bd_intf_pins pll2/S_AXI3] [get_bd_intf_pins soc/M07_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins pll2/S_AXI] [get_bd_intf_pins soc/M04_AXI]
  connect_bd_intf_net -intf_net soc_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins soc/DDR]
  connect_bd_intf_net -intf_net soc_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins soc/FIXED_IO]
  connect_bd_intf_net -intf_net soc_M00_AXI [get_bd_intf_pins pll1/S_AXI1] [get_bd_intf_pins soc/M00_AXI]
  connect_bd_intf_net -intf_net soc_M01_AXI [get_bd_intf_pins pll1/S_AXI] [get_bd_intf_pins soc/M01_AXI]
  connect_bd_intf_net -intf_net soc_M02_AXI [get_bd_intf_pins pll1/S_AXI2] [get_bd_intf_pins soc/M02_AXI]

  # Create port connections
  connect_bd_net -net In4_DI_1 [get_bd_pins dac/In4_DI] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net In5_DI_1 [get_bd_pins dac/In5_DI] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net In6_DI_1 [get_bd_pins dac/In6_DI] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net Valid6_SI_1 [get_bd_pins dac/Valid6_SI] [get_bd_pins dac/Valid7_SI] [get_bd_pins pll1/LI_valid]
  connect_bd_net -net adc_adc_a [get_bd_pins adc/adc_a] [get_bd_pins pll1/Ref_DI] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net adc_adc_b [get_bd_pins adc/adc_b] [get_bd_pins pll2/Ref_DI] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net adc_adc_csn [get_bd_ports adc_csn_o] [get_bd_pins adc/adc_csn]
  connect_bd_net -net adc_clk_n_i_1 [get_bd_ports adc_clk_n_i] [get_bd_pins adc/adc_clk_n]
  connect_bd_net -net adc_clk_p_i_1 [get_bd_ports adc_clk_p_i] [get_bd_pins adc/adc_clk_p]
  connect_bd_net -net adc_dat_a_i_1 [get_bd_ports adc_dat_a_i] [get_bd_pins adc/adc_dat_a]
  connect_bd_net -net adc_dat_b_i_1 [get_bd_ports adc_dat_b_i] [get_bd_pins adc/adc_dat_b]
  connect_bd_net -net clk_1 [get_bd_pins adc/adc_clk] [get_bd_pins dac/Clk_CI] [get_bd_pins pll1/s_axi_aclk] [get_bd_pins pll2/s_axi_aclk] [get_bd_pins soc/clk] [get_bd_pins sum_limit_0/Clk_CI] [get_bd_pins sum_limit_1/Clk_CI]
  connect_bd_net -net dac_dac_clk [get_bd_ports dac_clk_o] [get_bd_pins dac/dac_clk]
  connect_bd_net -net dac_dac_dat [get_bd_ports dac_dat_o] [get_bd_pins dac/dac_dat]
  connect_bd_net -net dac_dac_rst [get_bd_ports dac_rst_o] [get_bd_pins dac/dac_rst]
  connect_bd_net -net dac_dac_sel [get_bd_ports dac_sel_o] [get_bd_pins dac/dac_sel]
  connect_bd_net -net dac_dac_wrt [get_bd_ports dac_wrt_o] [get_bd_pins dac/dac_wrt]
  connect_bd_net -net daisy_n_i_1 [get_bd_ports daisy_n_i] [get_bd_pins util_ds_buf_1/IBUF_DS_N]
  connect_bd_net -net daisy_p_i_1 [get_bd_ports daisy_p_i] [get_bd_pins util_ds_buf_1/IBUF_DS_P]
  connect_bd_net -net pll1_LI_X [get_bd_pins pll1/LI_X] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net pll1_LI_Y [get_bd_pins pll1/LI_Y] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net pll1_SelDacA [get_bd_pins dac/SwitchDac0_SI] [get_bd_pins pll1/SelDacA]
  connect_bd_net -net pll1_SelDacB [get_bd_pins dac/SwitchDac1_SI] [get_bd_pins pll1/SelDacB]
  connect_bd_net -net pll1_WAVE [get_bd_pins dac/In0_DI] [get_bd_pins sum_limit_0/B_DI] [get_bd_pins sum_limit_1/A_DI] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net pll1_WAVE1 [get_bd_pins pll1/WAVE] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net pll1_WAVE_VALID [get_bd_pins dac/Valid0_SI] [get_bd_pins pll1/WAVE_VALID] [get_bd_pins sum_limit_0/ValidB_SI] [get_bd_pins sum_limit_1/ValidA_SI]
  connect_bd_net -net pll1_ext_pins_n [get_bd_ports exp_n_tri_io] [get_bd_pins pll1/ext_pins_n]
  connect_bd_net -net pll1_ext_pins_p [get_bd_ports exp_p_tri_io] [get_bd_pins pll1/ext_pins_p]
  connect_bd_net -net pll2_WAVE [get_bd_pins dac/In1_DI] [get_bd_pins sum_limit_0/A_DI] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net pll2_WAVE1 [get_bd_pins pll2/WAVE] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net pll2_WAVE_VALID [get_bd_pins dac/Valid1_SI] [get_bd_pins pll2/WAVE_VALID] [get_bd_pins sum_limit_0/ValidA_SI]
  connect_bd_net -net soc_peripheral_aresetn [get_bd_pins pll1/s_axi_aresetn] [get_bd_pins pll2/s_axi_aresetn] [get_bd_pins soc/peripheral_aresetn]
  connect_bd_net -net sum_limit_0_C_DO [get_bd_pins dac/In2_DI] [get_bd_pins sum_limit_0/C_DO]
  connect_bd_net -net sum_limit_0_Valid_SO [get_bd_pins dac/Valid2_SI] [get_bd_pins sum_limit_0/Valid_SO]
  connect_bd_net -net sum_limit_1_C_DO [get_bd_pins dac/In3_DI] [get_bd_pins sum_limit_1/C_DO]
  connect_bd_net -net sum_limit_1_Valid_SO [get_bd_pins dac/Valid3_SI] [get_bd_pins sum_limit_1/Valid_SO]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins util_ds_buf_2/OBUF_IN]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_N [get_bd_ports daisy_n_o] [get_bd_pins util_ds_buf_2/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_P [get_bd_ports daisy_p_o] [get_bd_pins util_ds_buf_2/OBUF_DS_P]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins dac/Reset_RBI] [get_bd_pins pll1/Reset_RBI] [get_bd_pins pll2/Reset_RBI] [get_bd_pins sum_limit_0/Reset_RBI] [get_bd_pins sum_limit_1/Reset_RBI] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins sum_limit_1/ValidB_SI] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins dac/Valid4_SI] [get_bd_pins dac/Valid5_SI] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins sum_limit_1/B_DI] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins dac/In7_DI] [get_bd_pins xlslice_4/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x41200000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll1/axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41300000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll2/axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0x41210000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll1/axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41310000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll2/axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg3
  create_bd_addr_seg -range 0x00001000 -offset 0x41220000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll1/axi_gpio_2/S_AXI/Reg] SEG_axi_gpio_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41320000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll2/axi_gpio_2/S_AXI/Reg] SEG_axi_gpio_2_Reg5
  create_bd_addr_seg -range 0x00010000 -offset 0x41230000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll1/axi_gpio_3/S_AXI/Reg] SEG_axi_gpio_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41330000 [get_bd_addr_spaces soc/processing_system7_0/Data] [get_bd_addr_segs pll2/axi_gpio_3/S_AXI/Reg] SEG_axi_gpio_3_Reg7


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


