import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

versnellingen = pd.read_csv('versnellingen.csv')

massa_car = 1000
A_car = 1.5 * 1.4
cw_car = 0.2
rho = 1.2
r_wiel = 0.35
v0 = 0

def F_lucht(v):
    Flucht = 0.5 * rho * cw_car * A_car * v**2
    return Flucht

def F_aandrijving(v):
    if v >= 0 and v <= 10:
        overbrenging = 15
    elif v > 10 and v < 20:
        overbrenging = 13
    elif v > 20 and v < 30:
        overbrenging = 9
    elif v > 30 and v < 40:
        overbrenging = 6
    elif v > 40 and v < 999:
        overbrenging = 4
    
    toerental = (v*60*overbrenging)/(2*np.pi*r_wiel)
    
    M_motor = 300*(1-((toerental-3000)/4500)**2) + toerental/20
    
    return M_motor * overbrenging

def F_tot(v):
    Ftot = F_aandrijving(v)-F_lucht(v)
    return Ftot

def versnelling(v):
    a = F_tot(v)/massa_car
    return a

def intergreer(tijdspan):
    a = np.zeros(len(tijdspan))
    v = np.zeros(len(tijdspan))
    
    
    v[0] = v0
    delta_t = tijdspan[1]-tijdspan[0]
    for n in range(len(tijdspan)):
            a[n] = versnelling(v[n])
            if n < len(tijdspan)-1:
                v[n + 1] = v[n] + delta_t*a[n]
    return a,v


t=np.linspace(0, 15, 10001)
acc,vel = intergreer(t)


plt.plot(t, vel, label = 'snelheid')
plt.plot(t, acc, label = 'versnelling')
plt.xlabel('tijd [s]')
plt.legend()
plt.grid()

print('de maximale snelheid is', np.max(vel)*3.6, 'km/h')
