import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy.optimize as opt

plt.close('all')

data = pd.read_csv('Rotterdam_1990_2018.csv')

# opdracht 1 ##############################################
min_temp_500 = data['t_min'][499]
print('De minimum temperatuur op dagnummer 500 is ', min_temp_500, 'graden')

# opdracht 2 ##############################################
yearly_averages = data.groupby('year').mean()

# Opdracht 3 ##############################################
yearly_average_temp = yearly_averages['t_avg']
yearly_average_temp.plot.bar()
# yearly_averages['t_avg'].plot.bar() kan ook natuurlijk


# Odracht 4 ##############################################
data_stats = data.describe()

print('gemiddeld aantal zonuren is', data_stats['sun']['mean'])
# Eenvoudiger is natuurlijk:
print('gemiddeld aantal zonuren is', data['sun'].mean())
# deze print statements hoeven niet perse, lezen in de variabele explorer is OK

# Odracht 5 ##############################################
hoek = data['direction']
snelheid = data['speed']

# Odracht 6 ##############################################
plt.figure()
hoek.plot.hist()

# Odracht 7 ##############################################
hoek_radialen = (hoek+270)/360*(2*np.pi)

plt.figure()
plt.polar(hoek_radialen, snelheid, 'r,')

# Opdracht 8 ##############################################
data.boxplot('t_max', by='month')

# Opdracht 9 ##############################################
koningsdagen = data[(data['day'] == 27) & (data['month'] == 4)]
koningsdagen = koningsdagen.set_index('year')  # is niet perse nodig
# maar zorgt er voor dat je in de plot de jaren op de x-as krijgt
plt.figure()
koningsdagen['sun'].plot.bar()


# Opdracht 10 ##############################################
rain_peaks = data[data['rain_sum'] > 5]
peak_table = pd.pivot_table(rain_peaks,'rain_sum', index='year', columns='month', aggfunc=np.sum)

plt.figure()
peak_table[8].plot.bar()  # de index begint niet bij nul. De getallen zijn de maanden uit de data
plt.figure()
peak_table[3].plot.bar()

# Extra opgave ##############################################
xdata = data['daynum']
ydata = data['t_avg']


def temp_model(daynum, amplitude_year, yearly_change, shift, normal):
    return (normal+yearly_change*daynum/365.25 +
            amplitude_year*np.sin((daynum+shift)/365.25*2*np.pi))


params, cov = opt.curve_fit(temp_model, xdata, ydata)

plt.figure()
plt.scatter(xdata, ydata, s=0.2)
plt.scatter(xdata, temp_model(xdata, *params), s=0.2)

# opmerking. Pandas kan goed omgaan met tijdseries. het zou logisch
# geweest zijn om de index hier de datum te maken, bijvoorbeeld door:
data['date'] = pd.to_datetime(data[['year', 'month', 'day']])
data.set_index('date', inplace=True)  # inplace bespaart je de data =...
# maar voor de eenvoud is dat hier niet gedaan
# vaak bevat data al een timestamp.
