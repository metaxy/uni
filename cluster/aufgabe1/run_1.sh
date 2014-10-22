cabal build
./dist/build/simple/simple < /home/paul/Cloud/studium/Cluster/programs/material/ce-data/test000.graph
cat before.dot | dot -Tpng > before.png
cat after.dot | dot -Tpng > after.png
#gwenview before.png after.png
