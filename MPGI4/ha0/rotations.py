# -*- coding: utf-8 -*-
"""
MPGI4 - sheet 1 - homework 0
@author: clessig@tu-berlin.de
"""

# imports
import numpy as np
import matplotlib.pyplot as plt


def rotMatrix(theta) :
    """Create rotation matrix around angle theta.

    Arguments:
    theta : rotation angle (in degrees)

    Return:
    R : rotation matrix
    """

    # TODO: ...

    R = np.eye( 2, 2)
    return R


def testOrthogonality() :
    '''
    Test orthogonality of 2D rotation matrix.

    Side Effects:
    Prints average error on console.
    '''

    # next to the angles that were asked for we also use a random angle
    # pi/k might not be very meaningful
    thetas = [ 30.0, 45.0, 90.0, 120.0, np.random.rand() * np.pi ]

    err = 0.0
    for theta in thetas :
        R = rotMatrix( theta)
        err += 0.0 # TODO: compute error.

    # normalize error
    err /= len(thetas)

    # user output
    print('Average orthogonality error of rotation matrix = ', err)


def plotVector( vec) :
    '''
    Plot given vector (as arrow) in existing graph (which is cleared first).

    Input:
    vec : vector to be plotted
    '''

    plt.clf()
    # draw current vector
    # h  =plt.figure()
    plt.arrow( 0.0, 0.0, vec[0], vec[1] )

    # beautify figure
    plt.xlim( -1.1, 1.1)
    plt.ylim( -1.1, 1.1)
    plt.axes().set_aspect(1.0)

    # wait half a second
    plt.pause( 0.01)


def rotateXAxis( theta_max = 37) :
    '''
    Rotate X-Axis by theta_max degrees in 1 degree step and then rotate back.

    Input:
    theta_max : maximum rotation angle.

    Side effects:
    After each rotation step the current vector is plotted.
    '''

    # rotation matrix around one degree
    R = rotMatrix( 1.0)

    # vector to be rotated
    vec = np.array( (1,0)).transpose()
    plotVector( vec)

    # TODO: perform forward rotations using R, visualize each step with plotVector()

    # TODO: invert rotation for backward rotation

    # TODO: perform backward rotations using R, visualize each step with plotVector()

    plt.show()


# run exercise
if __name__ == '__main__':

    # 0.2.b
    testOrthogonality()

    # 0.2.c
    rotateXAxis()

