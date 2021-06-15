# -*- coding: utf-8 -*-
'''Realiza a análise de png com lances de pênaltis
    Paulo R. P. Santiago 14-06-2021
'''

import os
import sys
import numpy as np
from numpy import linalg as LA
import matplotlib.pyplot as plt
from matplotlib.image import imread

dir_atual = os.getcwd()
# Contants
distpenalty = 11 # distance of the penalty or free kick
ballradius = 0.11 # radius of the ball in meters
midgoal = 3.66 # Middle of the goal
phorz = float(sys.argv[1]) - midgoal # horizontal point
pvert = float(sys.argv[2]) # vertical point
nframes = int(sys.argv[3]) # number of frames

try:
    fpsvideo = float(sys.argv[4])
except:
    print('Default set to 30 FPS')
    fpsvideo = 30

if pvert < ballradius:
    pvert = ballradius

ppenalty = np.asarray([0, 0, ballradius])
pgoal = np.asarray([phorz, distpenalty, pvert])
distball = LA.norm(pgoal - ppenalty)
# import pdb; pdb.set_trace()
velball_ms = distball / nframes * fpsvideo
velball_kmh = velball_ms * 3.6

print(f'A distância percorrida pela bola até o gol foi de {distball:.3f} metros')
print(f'A velocidade média do bola até o gol foi de {velball_ms:.3f} m/s ou {velball_kmh:.3f} km/h')


