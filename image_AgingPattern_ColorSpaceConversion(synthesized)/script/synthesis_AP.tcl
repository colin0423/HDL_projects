#   Read in top module
read_file -format sverilog {../src/AP.v}

# SET POWER INTENT and ENVIRONMENT
current_design AP
link

#   Set Design Environment
set_host_options -max_core 8
source ../script/DC.sdc
check_design
uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set_max_area 0


#   Synthesize circuit
compile -map_effort high -area_effort high
#compile_ultra

#   Create Report
#timing report(setup time)
report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 4 -sort_by group > ../syn/AP_timing_max_rpt.txt
#timing report(hold time)
report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 4 -sort_by group > ../syn/AP_timing_min_rpt.txt
#area report
report_area -nosplit > ../syn/AP_area_rpt.txt
#report power
report_power -analysis_effort low > ../syn/AP_power_rpt.txt

#   Save syntheized file
write -hierarchy -format verilog -output {../syn/AP_syn.v}
write_sdf -version 3.0 -context verilog {../syn/AP_syn.sdf}

