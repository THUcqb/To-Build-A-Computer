
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ALUExperiment -dir "Y:/Desktop/ALUExperiment/planAhead_run_2" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "Y:/Desktop/ALUExperiment/ALUExperiment.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {Y:/Desktop/ALUExperiment} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ALUExperiment.ucf" [current_fileset -constrset]
add_files [list {ALUExperiment.ucf}] -fileset [get_property constrset [current_run]]
link_design
