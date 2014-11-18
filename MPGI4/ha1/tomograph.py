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
    a = 0
    for i in np.linspace(np.pi,0, num=nshots):
        x_points = []
        y_points = []
        y = np.sin(i)*2
        x = np.cos(i)*2
        b= 0
        for j in np.linspace(-1,1,num=nrays):
            x1 = x + j*np.sin(-i)
            y1 = y + j*np.cos(-i)
            x2 = -x
            y2 = -y
            res = ellipse.trace([x1,y1], [x2,y2])
            sino[b,a] = res
            x_points.append(x1)
            y_points.append(y1)
            b += 1
        #plt.plot(x_points, y_points, marker='o', color=(i/180,0,i/210+0.1))
        a += 1
        print(a)
 
    plt.imshow(sino, cmap='Greys')
    plt.show()
    #sino have to be returned for 3 c)
    return sino

sinogramm(64,64)
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
