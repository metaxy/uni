import ellipse
import numpy as np
import matplotlib as plt
import math
from numpy import dot

def sinogramm(n, m):
    """
    Saves the trace values in a matrix
    
    Inputs:
    n :: number of rays
    m :: number of positions
    
    Output:
    sino :: trace values stored in a np.array 
    PNG file (use plt.imshow)
    """
    
    sino = np.zeros((n, m))
    
    #TODO: put the values of the trace function into an np.array
    
    #use trace function to get the value for sinogramm
    #sino[?, ?] = ellipse.trace(?, ?)
    
    #TODO: display matrix (use plt.imshow)
    
    return sino

def equalMatrix(n, k):
    """
    Calculates the equality matrix (Ausgleichsmatrix)
    
    Inputs:
    n :: numberof rays (have to be atleast 4*K)
    k :: size of the row/columm of the square grid (k*k)
    
    Output:
    A :: Matrix containing the intersections (np.array)
    """
    
    A = np.zeros((n, (k*k)))
    #TODO: evaluate the sinogramm
    
    #TODO: use grid_intersect
    #I, G, dt, px, py = ellipse.grid_intersect(?, ?, ?)
    
    #TODO: fill A with content from grid_intersect
    
    return A 

def showPic(A, b):
    """
    evaluates the sinogramm using the matrix containing the intersect
    values and creates the tomograph picture
    
    Inputs:
    A :: equalization matrix
    b :: sinogramm
    
    Output:
    PNG file (use plt.imshow)
    """

    #TODO generate picture of the skull