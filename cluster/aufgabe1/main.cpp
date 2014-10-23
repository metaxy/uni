#include <QCoreApplication>
#include <QHash>
QVector< QVector<int> > graph;
QHash<QString, int> labels;

int label2id(QString name)
{
    if(labels.contains(name))
        return labels[name];
    labels[name] = labels.size();
    return labels[name];
}

void add_edge(int a, int b)
{
    graph[a][b] = 1;
    graph[b][a] = 1;
}

void remove_edge(int a, int b)
{
    graph[a][b] = 0;
    graph[b][a] = 0;
}
void init_graph()
{
}

int readFile(QString input)
{
    init_graph();
    foreach(QString line, input.split(";",QString::SkipEmptyParts)) {
        if(line.startsWith(" ") || line.startsWith("#")) continue;

        QStringList edges = line.split(" ",QString::SkipEmptyParts);
        add_edge(label2id(edges.at(0)), label2id(edges.at(0)));
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    return a.exec();
}
