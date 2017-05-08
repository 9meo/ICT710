
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
			cursor.execute("SELECT * FROM traffic_transaction_ku ORDER BY appid DESC")
			i_query = cursor.fetchone()
			
			appid = i_query[0]
			train_no = i_query[1]
			light = i_query[2]
			timestamp = i_query[3]
			
			# [get data to json]
			reply = {}
			reply['appid'] = appid
			reply['train_no'] = train_no
			reply['light'] = light
			reply['timestamp'] = timestamp
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
	('/get_traffic_ku', GetStatus),
], debug=True)
# [END app]
