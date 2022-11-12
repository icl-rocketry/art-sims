#Uses orhelper, and also inspired by the MonteCarlo.py example from orhelper. This can be found at https://github.com/SilentSys/orhelper/.
#Requires OpenRocket-15.03 as well, as can be found here: https://openrocket.info/.

#Javatips.net is also very helpful: https://www.javatips.net/api/openrocket-master/core/src/net/sf/openrocket/rocketcomponent/Streamer.java.


#Applying principles from the orhelper pages (particularly MonteCarlo.py) in correlation with my own abilities and openrocket files produced as part of ICLR. 
#Stack Overflow also occasionally used along with Python documentation and W3schools.

import os

#Setting up I/O through Python and doing parallelisation and visualisation through MATLAB (Shrey Bohra doing).

import numpy
import matplotlib
import scipy

import orhelper

import random
import math

#Class incorporating the apogee and drift data into one data object.

class ApogeeDriftList(list):

    def __init__(self):

        #Initialisation

        self.Apogee = []
        self.Drift = []

    def add_simulationsapogeedrift(self, num, filename):

        #Function to add a simulation for apogee and drift calculations.

        with orhelper.OpenRocketInstance() as instance:
            orh = orhelper.Helper(instance) # Creating a new orhelper instance.
            doc = orh.load_doc(os.path.abspath('FILEPATH')) #Loading the desired OpenRocket simulation, USE DESIRED FILEPATH to the actual OpenRocket file - likely in GitHub folders of some variety.
            sim = doc.getSimulation(7) # Get the simulation as necessary, 0 for first simulation in OpenRocket list of save simulations.

            opts = sim.getOptions() #Getting the simulation parameters.
            #rocketparam = sim.getRocket() #Update: Getting rocket parameters from the simulation.

            for p in range(num):
                print('Simulation Number',p + 1) #Simulation updates.

                #opts.setLaunchRodDirection(math.radians(random.gauss(5,10))) -> Not including, 28/06/2022, as LENNY cannot be modified

                #Updating the parameters using a random Gaussian distribution.

                opts.setWindSpeedAverage(random.gauss(5,1))
                opts.setWindDirection(math.radians(random.gauss(247.5,22.5))) #Included on 28/06/2022 based on launch conditions at SARA.

                #Include Wind Direction and Turbulence.
                #opts.setWindSpeedDeviation(0.2)
                opts.setWindTurbulenceIntensity(0.1) #Turbulence and Wind Direction deviation are dependent on each other, so only one should be used.

                #opts.setTurbulenceIntensity(random.gauss(0.05,0.04)) --> Need to try and figure out what the listener or simulation options list is. Where can I find it? 24062022 174620

                #Include streamer component drag coefficient worst case scenario (change to 0.3) -> Perturbation of 0.3 +- 0.05 -> Even with C_D = 1.2, 2826 m
                #Include overall mass? 
                #streamer = orh.get_component_named(rocketparam,'Streamer (Apogee) ✓') #Cannot modify, not in OR Java.

                #streamer.setComponentCD(0.3 * random.gauss(1.0, 0.33))

                #Running the simulation.

                orh.run_simulation(sim)
                events = orh.get_events(sim)

                #Getting events and determining apogee and ground hit times.

                Apogeetime = events[orhelper.FlightEvent.APOGEE]
                Groundhittime = events[orhelper.FlightEvent.GROUND_HIT]
                #Starttime = events[orhelper.FlightEvent.LAUNCH]
                data = orh.get_timeseries(sim, [orhelper.FlightDataType.TYPE_TIME, orhelper.FlightDataType.TYPE_ALTITUDE,orhelper.FlightDataType.TYPE_POSITION_XY])
                print(data)
                Apogeeindex = [tup[0] for tup in enumerate(data[orhelper.FlightDataType.TYPE_TIME]) if tup[1] == Apogeetime][0] #Helped by Akshat Tripathi for this particular application of tuples.
                Apogeeval = data[orhelper.FlightDataType.TYPE_ALTITUDE][Apogeeindex + 1]
                Enddriftindex = [tup[0] for tup in enumerate(data[orhelper.FlightDataType.TYPE_TIME]) if tup[1] == Groundhittime][0]
                Enddriftval = data[orhelper.FlightDataType.TYPE_POSITION_XY][Enddriftindex + 1]
                #Startdriftindex = [tup[0] for tup in enumerate(data[orhelper.FlightDataType.TYPE_TIME]) if tup[1] == Starttime][0] -> Did not need to use this, as the start drift val and index were unnecessary.
                #Startdriftval = 0 #data[orhelper.FlightDataType.TYPE_POSITION_XY][Startdriftindex + 1]

                #Creating the apogee drift data object to save the data.

                apodrift = ApogeeDrift(self.Apogee, self.Drift)
                apodrift.Apogee.append(Apogeeval)
                apodrift.Drift.append(Enddriftval) #- Startdriftval)
                #print(self.LRCstabilities,self.maxstabilities)

                #Outputting to file for data analysis and checking.
                
                f = open(filename,'a')
                formattedwindspeedaverage = "{:.4f}".format(opts.getWindSpeedAverage())
                formattedwinddirection = "{:.4f}".format(opts.getWindDirection())
                formattedapo = "{:.4f}".format(Apogeeval)
                formatteddrift = "{:.4f}".format(Enddriftval) #- Startdriftval)
                f.write(str(formattedwindspeedaverage) + '          ')
                f.write(str(formattedwinddirection) + '          ')
                f.write(str(formattedapo) + '          ')
                f.write(str(formatteddrift) + '          ')
                f.write('\n')
                self.append(apodrift)
                f.close()
    
    def print_statsapogeedrift(self):
        #Function to output the final statistics of apogee and drift (taken and modified from orhelper/MonteCarlo.py).

        print(
            'Rocket Apogee %3.2f m +- %3.2f m, drift %3.2f m +- %3.4f m. Based on %i simulations.' % \
            (numpy.mean(self.Apogee), numpy.std(self.Apogee), numpy.mean(self.Drift),
             numpy.std(self.Drift), len(self)))

class ApogeeDrift():

    #Class of apogee and drift data.

    def __init__(self, Apogee, Drift):
        self.Apogee = Apogee
        self.Drift = Drift

class StabilitiesList(list):

    #Class denoting the stabilities off the launch rod, at maximum, and the average.

    def __init__(self):

        #Initialising.

        self.LRCstabilities = []
        self.maxstabilities = []
        self.averagestabilities =[]

    def add_simulationsstab(self, num, filename):

        #Function to add simulations to test stability.

        with orhelper.OpenRocketInstance() as instance:
            orh = orhelper.Helper(instance) #Creating a new orhelper instance.
            doc = orh.load_doc(os.path.abspath('FILEPATH')) #Loading the desired OpenRocket simulation, USE DESIRED FILEPATH to the actual OpenRocket file - likely in GitHub folders of some variety.
            sim = doc.getSimulation(7) #Choosing the simulation as saved in the OpenRocket file.

            opts = sim.getOptions() #Getting the simulation parameters.

            for p in range(num):
                print('Simulation Number',p + 1) #printing updates.
                #opts.setLaunchRodDirection(math.radians(random.gauss(5,10))) -> Not including, 28/06/2022, as LENNY cannot be modified

                #Changing the wind conditions and turbulence intensity.

                opts.setWindSpeedAverage(random.gauss(5,1)) #-> Changed from 5.81,2.24 on 02/07/2022
                opts.setWindDirection(math.radians(random.gauss(247.5,22.5))) #Changed from 220,40 on 02/07/2022 #Included on 28/06/2022 based on launch conditions at SARA.
                #Include Wind Direction and Turbulence.
                #opts.setWindSpeedDeviation(0.2)
                opts.setWindTurbulenceIntensity(0.1)
                #opts.setTurbulenceIntensity(random.gauss(0.05,0.04)) --> Need to try and figure out what the listener or simulation options list is. Where can I find it? 24062022 174620

                orh.run_simulation(sim) #Running and getting the simulation events and data.
                events = orh.get_events(sim)
                LRCtime = events[orhelper.FlightEvent.LAUNCHROD]
                data = orh.get_timeseries(sim, [orhelper.FlightDataType.TYPE_TIME, orhelper.FlightDataType.TYPE_STABILITY])
                print(data)
                LRCstabilityindex = [tup[0] for tup in enumerate(data[orhelper.FlightDataType.TYPE_TIME]) if tup[1] == LRCtime][0] #Akshat Tripathi helped with that particular tuple integration method.
                LRCstabval = data[orhelper.FlightDataType.TYPE_STABILITY][LRCstabilityindex + 1]
                numbercheck = numpy.isnan(data[orhelper.FlightDataType.TYPE_STABILITY])
                length = len(data[orhelper.FlightDataType.TYPE_STABILITY])
                i = 0
                #Include numbercheck, put the maxstabval based on the index.
                for i in range(0,length):  
                    if numbercheck[i] == False:  
                        stabnumval = data[orhelper.FlightDataType.TYPE_STABILITY][i] #Updating the stability to find the maximum stability.
                    #else:
                    #    continue
                maxstabval = stabnumval.max()
                avestabval = numpy.mean(stabnumval) #Getting the average stability value.
                stab = Stabilities(self.LRCstabilities, self.maxstabilities, self.averagestabilities)
                stab.LRCstabilities.append(LRCstabval) #Appending the class object.
                stab.maxstabilities.append(maxstabval)
                stab.averagestabilities.append(avestabval)
                #print(self.LRCstabilities,self.maxstabilities)

                #Writing out to file.
                f = open(filename,'a')
                formattedwindspeedaverage = "{:.4f}".format(opts.getWindSpeedAverage())
                formattedwinddirection = "{:.4f}".format(opts.getWindDirection())
                formattedLRCstab = "{:.4f}".format(LRCstabval)
                formattedmaxstab = "{:.4f}".format(maxstabval)
                formattedaveragestab = "{:.4f}".format(avestabval)
                f.write(str(formattedwindspeedaverage) + '          ')
                f.write(str(formattedwinddirection) + '          ')
                f.write(str(formattedLRCstab) + '          ')
                f.write(str(formattedmaxstab) + '          ')
                f.write(str(formattedaveragestab) + '          ')
                f.write('\n')
                self.append(stab)
                f.close()
    
    def print_statsstab(self):

        #Printing out the stability metrics.

        print(
            'Rocket LRC stability %3.2f cal +- %3.2f cal, max stability %3.2f cal +- %3.4f cal, average stability %3.2f cal +- %3.4f cal. Based on %i simulations.' % \
            (numpy.mean(self.LRCstabilities), numpy.std(self.LRCstabilities), numpy.mean(self.maxstabilities),
             numpy.std(self.maxstabilities), numpy.mean(self.averagestabilities), numpy.std(self.averagestabilities), len(self)))

class Stabilities():

    #Class with the different stability values.

    def __init__(self, LRCstabilities, maxstabilities, averagestabilities):
        self.LRCstabilities = LRCstabilities
        self.maxstabilities = maxstabilities
        self.averagestabilities = averagestabilities

    
#Running the function.

def apogeedriftMC(numberofsims):

    vals = ApogeeDriftList()
    f = open('ApogeeDriftMonteCarlo.txt','w')
    f.write('Wind Speed          ')
    f.write('Wind Direction          ')
    f.write('Apogee          ')
    f.write('Drift          ')
    f.write('\n')
    vals.add_simulationsapogeedrift(numberofsims, 'ApogeeDriftMonteCarloFine.txt')
    vals.print_statsapogeedrift()

def stabilityMC(numberofsims):
    vals = StabilitiesList()


    f = open('StabMonteCarlo.txt','w')
    f.write('Wind Speed          ')
    f.write('Wind Direction          ')
    f.write('LRC Stability          ')
    f.write('Maximum Stability          ')
    f.write('Average Stability         ')
    f.write('\n')
    vals.add_simulationsstab(numberofsims, 'StabMonteCarloFiner.txt')
    vals.print_statsstab()

#Main function

index = int(input('Please enter index corresponding to desired Monte Carlo sim, 1 for apogee and drift, 2 for stabilities: '))
numberofsims = int(input('Please enter the number of varying sims you would like to run - for now, please go into the source code to vary the averages and/or standard deviations for the randomness: '))

if index == 1:
    apogeedriftMC(numberofsims)
elif index == 2:
    stabilityMC(numberofsims)
else:
    print('Error: number not in index list.')
