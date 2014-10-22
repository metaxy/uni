cabal build
time ./dist/build/t2/t2 < /home/paul/Cloud/studium/Cluster/programs/material/ce-data/test067.graph
cat before.dot | dot -Tpng > before.png
cat after.dot | dot -Tpng > after.png
rm before.dot
rm after.dot
gwenview before.png after.png
