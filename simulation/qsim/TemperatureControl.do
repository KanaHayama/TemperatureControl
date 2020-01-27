onerror {quit -f}
vlib work
vlog -work work TemperatureControl.vo
vlog -work work TemperatureControl.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.AD_vlg_vec_tst
vcd file -direction TemperatureControl.msim.vcd
vcd add -internal AD_vlg_vec_tst/*
vcd add -internal AD_vlg_vec_tst/i1/*
add wave /*
run -all
