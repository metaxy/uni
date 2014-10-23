cabal build
time ./dist/build/t3/t3 < /home/paul/Cloud/studium/Cluster/programs/material/ce-data/test067.graph
cd images
cat before.dot | dot -Tpng > before.png
cat after.dot | dot -Tpng > after.png
rm before.dot
rm after.dot
gwenview before.png after.png
