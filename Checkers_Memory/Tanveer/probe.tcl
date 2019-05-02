database -open waves_mem_tb -default
probe -create -all -depth all
##probe -create -database waves_muxtb -all -depth {muxtb.UUT}
run 10000000000 ms

