vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/wrapif/* 
add wave -position insertpoint sim:/top/slaveif/*
add wave -position insertpoint sim:/top/ramif/*
run -all
coverage save SPI_Wrapper_coverage.ucdb -du WRAPPER
