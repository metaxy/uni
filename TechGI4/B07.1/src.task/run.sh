killall GoBackNReceiver.musterlsg 
killall GoBackNSender.musterlsg 
killall GoBackNReceiver
killall GoBackNSender

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../lib/ ; export LD_LIBRARY_PATH
../protsim/protsim.cmdenv &
./GoBackNReceiver.musterlsg localhost test.out &
./GoBackNSender.musterlsg -d 10/5 localhost ../protsim/protsim.tk
