database -open waves_memorytb -default
probe -create -all -depth all
##probe -create -database waves_memorytb -all -depth {memorytb.UUT}
run 100 ms
exit
