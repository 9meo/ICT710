
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

# [START InsertDistance]
class InsertDistance(webapp2.RequestHandler):
	def get(self):	
	
		# [Connect db]
		parser = SafeConfigParser()
		parser.read('Database.conf')

		cnx = MySQLdb.connect(parser.get('Database','host'),parser.get('Database','user'),parser.get('Database','passwd'),parser.get('Database','db'))
		cursor = cnx.cursor()
		
		#train_no = int(self.request.get('train_no'))
		distance = int(self.request.get('distance'))
		
		# [count transaction train data]
		#cursor.execute("SELECT appid FROM train_transaction_ku")
		#i_count = cursor.rowcount
		i_count = 0
		#self.response.write(i_count)
		
		if (i_count == 0):
			i = 0
		else:
			i = i_count
			cursor.execute("SELECT * FROM train_transaction_ku ORDER BY appid DESC")
			i_query = cursor.fetchone()
			
			distance_matlab_row = i_query[4]
			round_train_row = i_query[11]
			#self.response.write(i_query)
		try:
			# [Get value for insert data]			
			if (i_count == 0):
				distance_matlab = 0			
				round = 0
			else:			
				distance_matlab = distance_matlab_row			
				round = round_train_row
				
			# [query position data]
			#if(train_no == 1):
			#if(i_count == 0):
			distance_cal = distance
			query = ("SELECT * FROM  masteryamanote where range_start <= %s and  range_end >= %s ")
			cursor.execute(query %(distance_cal, distance_cal))
			results = cursor.fetchall()
				
			# elif ((round >= 0 and round%2 == 0 ) or (distance_matlab%34662 == 0)):
				# distance_cal = distance - (34662*round)
				# query = ("SELECT * FROM masteryamanote where range_start <= %s and  range_end >= %s ")
				# cursor.execute(query %(distance_cal, distance_cal))
				# results = cursor.fetchall()
				
			# elif (round > 0 and round%2 == 1):
				# distance_cal = (34662*(round+1)) - distance
				# query = ("SELECT * FROM masteryamanote where range_start <= %s and  range_end >= %s ")
				# cursor.execute(query %(distance_cal, distance_cal))
				# results = cursor.fetchall()
				
			# else:
				# self.response.write({'status': 'ERROR', 'error': 'train_no is not 1'})
				# return
				
			for row in results:
				lat = row[1]
				lon = row[2]
				distance_track = row[8]
				start_station = row[9]
				next_station = row[10]	
			
			# [set round trip data]			
			if (i == 0):
				round_train = 0
			else:
				if (distance_cal%34662 == 0):
					round_train = round + 1
				else:
					round_train = round
			
			# [insert data]
			insert_stmt = (
				"INSERT INTO train_transaction_ku (train_no,position_now_lat,position_now_lon, "
				"distance_matlab,start_station,next_station,distance_track,matlab_status,"
				"web_status,track_status,round_train)"
				"VALUES (%s, %s, %s, %s , %s , %s , %s ,%s ,%s , %s ,%s)"
			)
			data = (2 , lat , lon, distance , start_station , next_station , distance_track , 1 ,0 , 0 , round_train  )
			cursor.execute(insert_stmt, data)
			
			# [show status of insert data and commit data to db]
			appid = cursor.lastrowid
			self.response.write({'status': ' OK ', 'train id': appid })
			cnx.commit()
		except Exception, e:			
			self.response.write({'status': 'ERROR', 'error': str(e)})
			cnx.rollback()
			return
		cnx.close()	
		#self.redirect('/')
# [END InsertDistance]

# [START app]
app = webapp2.WSGIApplication([
	('/insertdistance_ku', InsertDistance),
], debug=True)
# [END app]
