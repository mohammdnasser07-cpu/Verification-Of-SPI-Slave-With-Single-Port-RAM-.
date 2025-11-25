vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/slaveif/* 
run -all
coverage save SLAVE_coverage.ucdb -du SLAVE
