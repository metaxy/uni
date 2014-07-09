LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../lib/ ; export LD_LIBRARY_PATH
killall protsim.cmdenv
make && ../protsim/protsim.cmdenv 

#diff GoBackNSender.c test.out
