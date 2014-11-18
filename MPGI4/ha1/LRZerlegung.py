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
    P = np.identity(M_rows)
    L = np.zeros((M_rows, M_rows))
    U = np.copy(M)
    
    #TODO: split M into P, L and U
  
    for c in range (M_cols):
       U1 = U[c:,c:]                         #slicen der matrix 
       posi = np.argmax(np.abs(U1[:,:1]))      #absolute maximum der zeile ermitteln 
       U[[c,posi+c],:] = U[[posi+c,c],:]   #tauschen der zeilen
      
       # operationen, um P und L zu ermitteln
       P[[c,posi+c],:] = P[[posi+c,c],:]
       L[[c,posi+c],:] = L[[posi+c,c],:]
       
       for r in range(c, M_rows):
           if(U[c][c] == 0):
               raise Exception("Division durch null!")
           mult = U[r][c]/U[c][c]
           L[r][c] = mult
           if(c != r):
               U[r] = U[r] - mult*U[c]      
        
    return P, L, U

A = np.array([[23.0,-8.0,5.0],[22.0,3.0,-4.0],[1.0,11.0,7.0]])
b = np.array([[12.0],[4.0],[0.0]])  

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
    x = np.zeros(b.shape[0])
    
    #TODO: compute x
    Pb = np.dot(P, b)
    y = forwardSubstitution(L, Pb)
    x = backSubstitution(U, y)
    
    return x

def forwardSubstitution(M, b):
    x = np.zeros(M.shape[1])   
    
    for i in range(M.shape[0]):
        sub = 0
        for j in range(i):
            sub += M[i][j] * x[j]
        x[i] = (b[i] - sub) / M[i][i]
    
    return x


def backSubstitution(M, b):
    """
    Back substitution for the solution of a linear system in row echelon form.

    Inputs:
    M :: matrix in row echelon representing linear system (numpy.array)
    b :: vector, representing right hand side (numpy.array)
    
    Returns:
    x :: solution of linear system (numpy.array)
    """

    #TODO: check, if a solution exists
    if(np.linalg.det(M)==0):
        raise Exception("Gleichungssystem hat keine (eindeutige) Lösung")
        
    
    #TODO: size of x?
    x = np.zeros(M.shape[1])
    
    #TODO: your function
    rows = M.shape[0]
    cols = M.shape[1]
    for i in range(rows - 1, -1, -1):
        sub = 0
        y = 1
        for j in range(cols - 1, i, -1):
            sub += M[i][j] * x[cols - y]
            y += 1
        x[i] = (b[i] - sub) / M[i][i]
        
    return x

