import numpy as np

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

    #TODO: implement gauss elimination with and without pivoting
    b = b.T
    asone = np.concatenate((M,b),axis=1)                    #matrix wird erzeugt durch die beiden eingabe matrizen
    columns = asone.shape[0]
    rows = asone.shape[1]
    for r in range (rows):
            if r == rows-1:
                return asone                                #abbruch bei wenn man bei der letzten diagonalen
            else:
                asone1 = asone[r:,r:]                       #slicen der matrix PROBLEM: ich kann nicht auf die shape zugreifen das waere spaeter fuer gauss nuetzlich
                #print(type(asone1))
                #print(dir(asone1))
                print(asone1.shape[0])
                posi = np.argmax(np.abs(asone1[:,:1]))      #absolute maximum der zeile ermitteln 
                asone[[r,posi+r],:] = asone[[posi+r,r],:]   #tauschen der zeilen
                for c in range (rows):                     
                    if c+1 == rows:                        #Das soll das Gauss werden
                        break
                    else:
                        asone[r,:]= (((asone[c+1][r])/(asone[r][r]))*(asone[r,:]))
                        asone[c+1,:]=((asone[c+1,:])-(asone[r,:]))
                        print(r)
                
                
A = np.array([[11,44,1],[0.1,0.4,3],[0,1,-1]])
b = np.array([[1,1,1]])   
gaussianElimination(A,b)

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
    
    #TODO: size of x?
    x = np.zeros(1)
    
    #TODO: your function
        
    return x