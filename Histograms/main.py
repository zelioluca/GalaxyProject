import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

"""load the file"""
histoDD = pd.read_csv("B:/GalaxyHistoCorrect/galaxy/histogramDD.csv")
histoDR = pd.read_csv("B:/GalaxyHistoCorrect/galaxy/histogramDR.csv")
histoRR = pd.read_csv("B:/GalaxyHistoCorrect/galaxy/histogramRR.csv")
scientific = pd.read_csv("B:/GalaxyHistoCorrect/galaxy/scientific_diff.csv")

"""Plot all the DD"""
plt.title('All Histogram DD')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDD.iloc[:, 0], histoDD.iloc[:, 1], label='real')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllHistoDD.pdf')
plt.show()

"""Plot all the DR"""
plt.title('All Histogram DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDR.iloc[:, 0], histoDR.iloc[:, 1], label='both')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllHistoDR.pdf')
plt.show()

"""Plot all the RR"""
plt.title('All Histogram RR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoRR.iloc[:, 0], histoRR.iloc[:, 1], label='flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllHistoRR.pdf')
plt.show()

"""Plot all the scientific"""
plt.title('Scientific measurement')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(scientific.iloc[:, 0], scientific.iloc[:, 1], label='scientific')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllScientific.pdf')
plt.show()


"""Plot all histoDD vs histo DR"""
plt.title('All Histogram DD vs All histogram DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDD.iloc[:, 0], histoDD.iloc[:, 1], label='real')
plt.bar(histoDR.iloc[:, 0], histoDR.iloc[:, 1], label='both')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllHistoDDvsHistoDR.pdf')
plt.show()

"""Plot all histoDD vs histo DR"""
plt.title('All Histogram DD vs All histogram RR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDD.iloc[:, 0], histoDD.iloc[:, 1], label='real')
plt.bar(histoRR.iloc[:, 0], histoRR.iloc[:, 1], label='flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllHistoDDvsHistoRR.pdf')
plt.show()

"""Plot all histoDD vs histo DR"""
plt.title('All Histogram DR vs All histogram RR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDR.iloc[:, 0], histoDR.iloc[:, 1], label='both')
plt.bar(histoRR.iloc[:, 0], histoRR.iloc[:, 1], label='flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/AllHistoDRvsHistoRR.pdf')
plt.show()

"""Plot all the DD 150 el"""
plt.title('First 150 element DD')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDD.iloc[0:150, 0], histoDD.iloc[0:150, 1], label='real')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/150HistoDD.pdf')
plt.show()

"""Plot all the DR 150 el"""
plt.title('First 150 element DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoDR.iloc[0:150, 0], histoDR.iloc[0:150, 1], label='both')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/150HistoDR.pdf')
plt.show()

"""Plot all the RR 150 el"""
plt.title('First 150 element RR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.bar(histoRR.iloc[0:150, 0], histoRR.iloc[0:150, 1], label='flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/150HistoRR.pdf')
plt.show()


"""get the correct col"""
histoDD = histoDD.iloc[:, 1]
histoDD = histoDD.iloc[0:150]

histoDR = histoDR.iloc[:, 1]
histoDR = histoDR.iloc[0:150]

histoRR = histoRR.iloc[:, 1]
histoRR = histoRR.iloc[0:150]

Xx = scientific.iloc[:, 0]
Yy = scientific.iloc[:, 1]

scientificX = Xx.iloc[0:150]
scientificY = Yy.iloc[0:150]
"""plot with panda only DD"""
plt.title('Histogram DD')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.hist(histoDD, bins=10, rwidth=0.9, color='red', label='real')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/histoDD.pdf')
plt.show()

"""plot with panda only DR"""
plt.title('Histogram DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.hist(histoDR, bins=10, rwidth=0.9, color='red', label='flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/histoDR.pdf')
plt.show()

"""plot with panda RR"""
plt.title('Histogram RR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.hist(histoRR, bins=10, rwidth=0.9, color='red', label='flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/histoRR.pdf')
plt.show()


"""Plot with panda DD vs DR"""
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.title('Histogram DD vs DR')
plt.hist([histoDD, histoDR], bins=10, rwidth=0.9, color=['red', 'green'], label=['real', 'both'])
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/histoDD_vs_histoDR.pdf')
plt.show()

"""Plot with panda RR vs DR"""
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.title('Histogram RR vs DR')
plt.hist([histoRR, histoDR], bins=10, rwidth=0.9, color=['red', 'green'], label=['flat', 'both'])
plt.ticklabel_format(useOffset=False, style='plain')
plt.autoscale(tight=True)
plt.legend()
plt.savefig('saveFigure/histoRR_vs_histoDR.pdf')
plt.show()

"""Plot with panda DD vs RR"""
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.title('Histogram DD vs RR')
plt.hist([histoDD, histoRR], bins=10, rwidth=0.9, color=['red', 'green'], label=['real', 'flat'])
plt.ticklabel_format(useOffset=False, style='plain')
plt.legend()
plt.savefig('saveFigure/histoDD_vs_histoRR.pdf')
plt.show()

"""plot with seaborn Density DD vs DR
sns.kdeplot(histoDD, histoDR, label='real and both')
plt.ticklabel_format(useOffset=False, style='plain')
plt.title('Density of the galaxy DD and DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.legend()
plt.savefig('saveFigure/densityDDvsDR.pdf')
plt.show()


sns.kdeplot(histoRR, histoDR, label='flat and both')
plt.ticklabel_format(useOffset=False, style='plain')
plt.title('Density of the galaxy DD and DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.legend()
plt.savefig('saveFigure/densityRRvsDR.pdf')
plt.show()

sns.kdeplot(histoDD, histoRR, label='real and flat')
plt.ticklabel_format(useOffset=False, style='plain')
plt.title('Density of the galaxy DD and DR')
plt.xlabel('Galaxy angles')
plt.ylabel('Counts')
plt.legend()
plt.savefig('saveFigure/densityDDvsRR.pdf')
plt.show()
"""