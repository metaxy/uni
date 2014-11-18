import ellipse
import numpy as np
import matplotlib.pyplot as plt
import math
from numpy import dot

def sinogramm(nshots, nrays):
    """
    Aufgabe 3 a)
    Saves the trace values in a matrix
    
    Inputs:
    nshots :: number of shots
    nrays  :: number of rays per shot
        
    Output:
    sino :: trace values stored in a np.array 
    PNG file (use plt.imshow)
    """
    
    sino = np.zeros((nshots, nrays))
    #TODO: calculate starting points for each ray
    
    #TODO: put the values of the trace function into an np.array
    
    #TODO: use trace function to get the value for sinogramm
    #sino[?, ?] = ellipse.trace(?, ?)
    
    #TODO: visualize sino

    #sino have to be returned for 3 c)
    return sino

def equalMatrix(nshots, nrays, ngrid):
    """
    Aufgabe 3 b)
    Calculates the equality matrix (Ausgleichsmatrix)
    
    Inputs:
    nshots :: number of shots
    nrays  :: number of rays per shot
    ngrid  :: size of raster grid (ngrid*ngrid)
    
    Output:
    A :: Matrix containing the intersections (np.array)
    """

    A = np.zeros((nshots*nrays, ngrid*ngrid))
    #TODO: calculate starting points for each ray    
    
    #TODO: use grid_intersect
    #I, G, dt, px, py = ellipse.grid_intersect(?, ?, ?)
    
    #TODO: fill A with content from grid_intersect
    
    return A 

def solveTg(nshots, nrays, ngrid):
    """
    Aufgabe 3 c)
    evaluates the sinogramm using the matrix containing the intersect
    values and creates the tomograph picture
    
    Inputs:
    nshots :: number of shots
    nrays  :: number of rays per shot
    ngrid  :: size of raster grid (ngrid*ngrid)
    
    Output:
    PNG file (use plt.imshow and plt.show)
    """
    
    #TODO: use your sinogramm function and reshape for gauss
    
    #TODO: use your equalMatrix function

    #TODO: generate picture of toft (use matplotlib as plt)
