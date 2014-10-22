cabal build
./dist/build/t1/t1 < /home/paul/Cloud/studium/Cluster/programs/material/ce-data/test000.graph
#./dist/build/t1/t1 < /home/paul/uni/cluster/aufgabe1/graph.1
cat out.dot | dot -Tpng > graph.png
gwenview graph.png
