'''
    This script is used to write characters to NUCLEO F401RE via serial port.
'''
import serial
import time
import json
import urllib2
import io

__author__ = "Ukrish Vanichrujee"
__copyright__ = "Copyright 2017, ICTES Train Simulation Project"
__credits__ = ["Paradorn Pimporn"]
__license__ = "GPL"
__version__ = "1.0.0"
__email__ = "ukrishva@gmail.com"

# For SIIT
# Start Serial connection
ser = serial.Serial()
ser.baudrate = 9600
ser.port = 'COM4'# pc port
ip = "192.168.137.90:8080"
GREEN = 350
YELLOW1 = 300
YELLOW2 = 200
DISTANCE_URL = "getlocation_siit"
INSERT_TRAFF_URL = "insert_traffic_siit"
#this line can be written as "192.168.1.10:8080"
try:
    ser.open()
    i = 0
    while (1):
        # HTTP request
        try:
            url = "http://%s/%s" %(ip,DISTANCE_URL)  # Local Addr
            print("Trying to connect to %s" % (url))
            resp = urllib2.urlopen(url)
            result = json.load(resp)
            distance = result['distance_track']
            print("Distance:%d" % (result['distance_track']))
            print("Next station:%s" % (result['next_station']))
            light = ''
            if distance > GREEN:
                light = 'green'
                ser.write('g')
            elif (distance < GREEN) and (distance > YELLOW1):
                light = 'yellow1'
                ser.write('y')
            elif (distance < YELLOW1) and (distance > YELLOW2):
                light = 'yellow2'
                ser.write('p')
            elif (distance < YELLOW2) and (distance > 0):
                ser.write('r')
                light = 'red'
            elif distance == 0:
                print('Start Blinking')
                light = 'red'
                j = 0
                ser.write('r')
                url = "http://%s/%s?light=%s" \
                       % (ip,INSERT_TRAFF_URL, light)
                resp = urllib2.urlopen(url)
                time.sleep(10)
                light = 'blink'
                url = "http://%s/%s?light=%s" \
                      % (ip, INSERT_TRAFF_URL, light)
                resp = urllib2.urlopen(url)
                while j < 15:
                    ser.write('c')
                    time.sleep(.5)
                    ser.write('r')
                    time.sleep(.5)
                    j += 1
                ser.write('g')
                light = 'green'
                url = "http://%s/%s?light=%s" \
                      % (ip, INSERT_TRAFF_URL, light)
                resp = urllib2.urlopen(url)
                time.sleep(5)
                print('Train takes off')
            print("Traffic Light:%s" % (light))
            url = "http://%s/%s?light=%s" \
                  % (ip, INSERT_TRAFF_URL, light)
            resp = urllib2.urlopen(url)
            print('==================')
        except IOError:
            print('There is something wrong with serial connection.')
            break
        except Exception:
            print('There is something wrong with http connection.')
            break
        time.sleep(2)
        i += 1
except IOError:
    print('There is something wrong with serial connection.')
finally:
    ser.close()
# End Serial connection
# ser.isOpen()