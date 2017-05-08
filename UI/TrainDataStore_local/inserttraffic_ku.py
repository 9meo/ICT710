
# [START imports]
import MySQLdb
import os
import urllib
import json
from ConfigParser import SafeConfigParser

from google.appengine.api import users
from google.appengine.ext import ndb

import webapp2
# [END imports]

# [START InsertTraffic]
class InsertTraffic(webapp2.RequestHandler):
	def get(self):		
		# [Connect db]
		parser = SafeConfigParser()
		parser.read('Database.conf')

		cnx = MySQLdb.connect(parser.get('Database','host'),parser.get('Database','user'),parser.get('Database','passwd'),parser.get('Database','db'))
		cursor = cnx.cursor()		
		
		try:
			# [Get value for insert data]
			#train_no = int(self.request.get('train_no'))
			light = self.request.get('light')
			
			# [insert data]
			insert_stmt = (
				"INSERT INTO traffic_transaction_ku (train_no,light)"
				"VALUES (%s, %s)"
			)
			data = (2 , light )
			cursor.execute(insert_stmt, data)
			
			# [show status of insert data and commit data to db]
			appid = cursor.lastrowid
			self.response.write({'status': ' OK ', 'train id': appid })
			cnx.commit()
		except Exception, e:			
			self.response.write({'status': 'ERROR', 'error': str(e)})
			cnx.rollback()
			return
		
		#self.redirect('/')
# [END InsertTraffic]

# [START app]
app = webapp2.WSGIApplication([
	('/insert_traffic_ku', InsertTraffic),
], debug=True)
# [END app]
