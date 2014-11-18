import numpy as np

def LUDecomposition(M):
    """
    LU decomposition of matrix M.

    Inputs:
    M :: matrix to be decomposed (np.array)

    Return:
    P :: Permutation matrix of pivoting transformations (np.array)
    L :: L matrix of LU decomposition, lower triangular (np.array)
    U :: U matrix of LU decomposition, upper triangular (np.array)
    """
  
    M_rows, M_cols = np.shape(M)

    #Defining the return values
    P = np.array(range(M_rows))
    L = np.zeros((M_rows, M_rows))
    U = np.zeros((M_cols, M_cols))
    
    #TODO: split M into P, L and U
    
    Id = np.identity(M_rows)
    Pcounter = 0
    Lcounter = 0
    Ls = np.array(range(M_rows*M_cols))
    
    for c in range(M_cols):
        M1 = M[c:,c:]                      
        posi = np.argmax(np.abs(M1[:,:1]))
        perm = np.identity(M_rows)
        perm[[c,posi+c],:] = perm[[posi+c,c],:]
        print(perm)
       # P[Pcounter] = perm   # perm musss richtig gespeichert werden
        Pcounter += 1
        M = np.dot(perm, M)
        #print(M)
        for r in range(c+1, M_rows):
            mult = M[r][c]/M[c][c]
            tmpL = np.zeros((M_rows, M_cols))
            tmpL[r][c] = -mult
            M = np.dot(tmpL+Id, M)
            print(M)
           # Ls[Lcounter] = tmpL   # muss aUCH Noch richtig gespeichert werden
            Lcounter += 1
          
    L = Id
    #for i in range(Lcounter):
    #    L -= Ls[i]
    U = M
    return P, L, U

A = np.array([[3.0,6.0,8.0],[2.0,6.0,7.0],[4.0,2.0,7.0]])

def solveLU( P, L, U, b):
    """
    Solving matrix multiplication by using LUDecomposition

    Inputs:
    P :: Permutation matrix of pivoting transformations (np.array)
    L :: lower triangular matrix of LU (np.array)
    U :: upper triangular matrix of LU (np.array)
    b :: right hand side of linear system (np.array)

    Return:
    x :: solution of linear system represented by L,U,b (np.array)
    """
    
    #TODO: size of x?
    x = np.zeros(1)
    
    #TODO: compute x
    
    return x

	
