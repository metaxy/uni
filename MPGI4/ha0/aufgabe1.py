import numpy as np
import time
import matplotlib import pyplot

def matMult(A, B):
    n = A.shape[0]
    p = B.shape[1]
    m = A.shape[1]
    ret = np.empty([n, p], dtype='int')
    for i in range(0,n):
        for j in range(0,p):
            s = 0
            for k in range(0,m):
                s += A[i][k] * B[k][j]
            ret[i][j] = s
    return ret


def matMultExperiment():

    for i in range(2,100):
        A = np.random.random_integers(0, 100, (i, i))
        B = np.random.random_integers(0, 100, (i, i))
        
        t = time.process_time()
        my = matMult(A,B)
        e = time.process_time() - t

        t2 = time.process_time()
        nu = np.dot(A,B)
        e2 = time.process_time() - t2
        print(e)
        print(e2)


matMultExperiment()


