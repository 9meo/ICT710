
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

# [START GetStatus]
class GetStatus(webapp2.RequestHandler):
	def get(self):
		try:
			# [Connect db]
			parser = SafeConfigParser()
			parser.read('Database.conf')

			cnx = MySQLdb.connect(parser.get('Database','host'),parser.get('Database','user'),parser.get('Database','passwd'),parser.get('Database','db'))
			cursor = cnx.cursor()
			
			# [query data]
			cursor.execute("SELECT * FROM train_status_ku ORDER BY appid DESC")
			i_query = cursor.fetchone()

			appid = i_query[0]
			train_no = i_query[1]
			door_driver = i_query[2]
			door_passenger = i_query[3]
			light_1 = i_query[4]
			light_2 = i_query[5]
			light_3 = i_query[6]
			
			# [get data to json]
			reply = {}
			reply['appid'] = appid
			reply['train_no'] = train_no
			reply['door_driver'] = door_driver
			reply['door_passenger'] = door_passenger
			reply['light_1'] = light_1
			reply['light_2'] = light_2
			reply['light_3'] = light_3
			json_reply = json.dumps(reply , default = myconverter)
			self.response.write( json_reply )
		except Exception, e:
			self.response.write({'status': 'ERROR', 'error': str(e)})
			return

		#return json_reply

		#self.redirect('/')
# [END GetStatus]

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

# [START app]
app = webapp2.WSGIApplication([
	('/getstatus_ku', GetStatus),
], debug=True)
# [END app]
