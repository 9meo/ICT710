
# [START imports]
import MySQLdb
import os
import urllib
import json
import datetime
from ConfigParser import SafeConfigParser

from google.appengine.api import users
from google.appengine.ext import ndb

import webapp2
# [END imports]

# [START Getlocation]	
class Getlocation(webapp2.RequestHandler):
	def get(self):	
		try :             
			# [Connect db]
			parser = SafeConfigParser()
			parser.read('Database.conf')

			cnx = MySQLdb.connect(parser.get('Database','host'),parser.get('Database','user'),parser.get('Database','passwd'),parser.get('Database','db'))
			cursor = cnx.cursor()
			
			# [query data]
			cursor.execute("SELECT * FROM train_transaction_ku ORDER BY appid DESC")
			i_query = cursor.fetchone()
			
			appid = i_query[0]
			train_no = i_query[1]
			lat = i_query[2]
			lon = i_query[3]
			distance_matlab = i_query[4]
			start_station = i_query[5]
			next_station = i_query[6]	
			distance_track = i_query[7]
			matlab_status = i_query[8]
			web_status = i_query[9]
			track_status = i_query[10]
			round_train = i_query[11]
			timestamp = i_query[12]

			# [get data to json]
			reply = {}
			reply['appid'] = appid
			reply['train_no'] = train_no
			reply['latitude'] = float(lat)
			reply['longtitude'] = float(lon)
			reply['distance_matlab'] = distance_matlab
			reply['start_station'] = start_station
			reply['next_station'] = next_station
			reply['distance_track'] = distance_track
			reply['matlab_status'] = matlab_status
			reply['web_status'] = web_status
			reply['track_status'] = track_status
			reply['round_train'] = round_train
			reply['timestamp'] = timestamp
			json_reply = json.dumps(reply , default = myconverter)
			self.response.write( json_reply )
		except Exception, e:
			self.response.write({'status': 'ERROR', 'error': str(e)})
			return
		
		#return json_reply
		
		#self.redirect('/')
# [END Getlocation]	

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

# [START app]
app = webapp2.WSGIApplication([
	('/getlocation_ku', Getlocation),
], debug=True)
# [END app]
