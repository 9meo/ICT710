
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

# [START InsertStatus]
class InsertStatus(webapp2.RequestHandler):
	def get(self):
		# [Connect db]
		parser = SafeConfigParser()
		parser.read('Database.conf')

		cnx = MySQLdb.connect(parser.get('Database','host'),parser.get('Database','user'),parser.get('Database','passwd'),parser.get('Database','db'))
		cursor = cnx.cursor()
		try:
			door_driver = int(self.request.get('door_driver'))
			door_passenger = int(self.request.get('door_passenger'))
			light_1 = int(self.request.get('light_1'))
			light_2 = int(self.request.get('light_2'))
			light_3 = int(self.request.get('light_3'))

			insert_stmt = (
				"INSERT INTO train_status_ku (train_no,door_driver,door_passenger, "
				"light_1,light_2,light_3)"
				"VALUES (%s, %s, %s, %s , %s , %s)"
			)
			data = (2 , door_driver , door_passenger, light_1 , light_2 , light_3)
			cursor.execute(insert_stmt, data)

			# [show status of insert data and commit data to db]
			appid = cursor.lastrowid
			self.response.write({'status': ' OK ', 'train id': appid})
			cnx.commit()

		except Exception, e:
			self.response.write({'status': 'ERROR', 'error': str(e)})
			cnx.rollback()
			return
		cnx.close()
# [END InsertStatus]

# [START app]
app = webapp2.WSGIApplication([
	('/insertstatus_ku', InsertStatus),
], debug=True)
# [END app]
