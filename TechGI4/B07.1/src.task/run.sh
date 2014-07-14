LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../lib/ ; export LD_LIBRARY_PATH
killall protsim.tk
make && ../protsim/protsim.tk 

#diff GoBackNSender.c test.out
