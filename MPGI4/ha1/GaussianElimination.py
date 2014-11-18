import numpy as np
import string
def pm(my_matrix):
    max_lens = [max([len(str(r[i])) for r in my_matrix])
                for i in range(len(my_matrix[0]))]

    print("\n".join(["".join([str(np.round(e,2)).ljust(l + 2)
                for e, l in zip(r, max_lens)]) for r in my_matrix]))
    
def gaussianElimination(M, b, use_pivoting = True):
    """
    Gaussian Elimination with Pivoting.

    Inputs:
    M :: matrix representing linear system (numpy.array)
    b :: vector, representing right hand side (numpy.array)
    use_pivoting :: flag if pivoting should be used or no flag if 
                    pivoting should not be used
 
    Return:
    M :: input matrix in row echelon form (numpy.array)
    b :: input vector with pivoting permutations applied (numpy.array)
    """

    #b = b.T
    asone = np.concatenate((M,b),axis=1)                    #matrix wird erzeugt durch die beiden eingabe matrizen
    rows = asone.shape[0]    
    columns = asone.shape[1]
    for c in range (columns):
        if c == columns-2:
            return asone[:,:asone.shape[1]-1], asone[:, asone.shape[1]-1:]                          #abbruch bei wenn man bei der letzten diagonalen
        else:
            if(use_pivoting):
                asone1 = asone[c:,c:]                       #slicen der matrix PROBLEM: ich kann nicht auf die shape zugreifen das waere spaeter fuer gauss nuetzlich
                posi = np.argmax(np.abs(asone1[:,:1]))      #absolute maximum der zeile ermitteln 
                asone[[c,posi+c],:] = asone[[posi+c,c],:]   #tauschen der zeilen
            for r in range(c+1,rows):
                if(asone[c][c] == 0):
                    raise Exception("Division durch null!")
                mult = asone[r][c]/asone[c][c]
                asone[r] = asone[r] - mult*asone[c]
    return asone[:,:asone.shape[1]-1], asone[:, asone.shape[1]-1:]        
                
A = np.array([[23.0,-8.0,5.0],[22.0,3.0,-4.0],[1.0,11.0,7.0]])
b = np.array([[12.0],[4.0],[0.0]])   
print(gaussianElimination(A,b))
print(np.linalg.solve(A, b)) 
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