vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/ramif/* 
run -all
coverage save RAM.ucdb -onexit
coverage exclude -src RAM.v -line 27 -code s
coverage exclude -src RAM.v -line 27 -code b
