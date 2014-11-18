set -e 
set -o pipefail
cabal build
G=/home/paul/Cloud/studium/Cluster/programs/instances/synthetic/synthetic_smallK/k_015_n_148.txt
#G=/home/paul/Cloud/studium/Cluster/programs/material/ce-data/test067.graph
time ./dist/build/t3/t3 < $G
cd images
cat before.dot | dot -Tpng > before.png
cat after.dot | dot -Tpng > after.png
rm before.dot
rm after.dot
gwenview before.png after.png
