import sqlite3
import bottle_session
import bottle
from datetime import time, datetime, date
from bottle import route, run, template, request, static_file, get, redirect
import string
from random import *

adminSession = ""

get('/<filename:re:.*\.*>')
def server_static(filename):
	return static_file(filename, root='./static/')

@route('/logout')
def logout():
	session = bottle.request.environ.get('beaker.session')
	session['sp_user'] = ''
	session['usertype'] = ''
	return redirect('/')

def getSession():
	session = bottle.request.environ.get('beaker.session')
	if(session != ""):
		return session.get('sp_user')
	else:
		return ""

def adminHome(session):
	checkSession()
	loggedinUser = getSession()
	return template('adminHome', values=[loggedinUser], menu=[""], dininglocation={}, diningdetails=[])

def checkSession():
	session = bottle.request.environ.get('beaker.session')
	if(session.get('sp_user') == "" or session.get('sp_user') == None or session.get('usertype')!="ADM"):
		return redirect("/")
	else:
		return ""

@route("/addLocation", method="GET")
def addLocation():
	checkSession()
	loggedinUser = getSession()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM DiningLocation')
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('adminHome', values=[loggedinUser], menu=["addLocation"], dininglocation=diningdetails, diningdetails=[])

@route("/addManager", method="GET")
def addmanager():
	checkSession()
	loggedinUser = getSession()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM DiningLocation')
	result = cursor.fetchall()
	cursor.close()
	managerdetails = {}
	for row in result:
		managerdetails[row[0]] = row[1]
	return template('adminHome', values=[loggedinUser], menu=["addManager"], dininglocation=managerdetails, diningdetails=[])

@route("/viewLocations", method="GET")
def viewLocation():
	checkSession()
	loggedinUser = getSession()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM DiningLocation')
	result = cursor.fetchall()
	cursor.close()
	return template('adminHome', values=[loggedinUser], menu=["viewLocations"], dininglocation={}, diningdetails=result)

@route("/addManager", method="POST")
def addManager_todb():
	checkSession()
	loggedinUser = getSession()
	userid = request.POST.get('userid','').strip()
	name = request.POST.get('name','').strip()
	email = request.POST.get('email', '').strip()
	contactnumber = request.POST.get('contactnumber','').strip()
	locationid = request.POST.get('dininglocation','').strip()
	usertype = "MGR"
	activate = 1
	chars = string.ascii_letters + string.digits
	password = ""
	for x in range(randint(6,8)):
		password += choice(chars)

	print(password)

	connection = sqlite3.connect('ShiftPlanner.db')
	inserted = 1
	try:
		connection.execute('INSERT INTO UserInformation(UserID, Name, Email, ContactNumber, CreatedDate) VALUES(?,?,?,?,?)', (int(userid), name, email, int(contactnumber), datetime.now()))
		connection.execute('INSERT INTO UserLogin(UserEmail, Password, UserType, IsActive, LastLogin) VALUES(?,?,?,?,?)', (email, password, usertype, activate, datetime.now()))
		connection.execute('INSERT INTO UserDiningLocation(UserID, DiningLocationID) VALUES(?,?)', (userid, locationid))
		connection.commit()
	except Exception as err:
		print(err)
		inserted = -1

	cursor = connection.cursor()
	cursor.execute('SELECT Name, Email, ContactNumber FROM UserInformation')
	result = cursor.fetchall()
	cursor.close()
	managerdetails = {}
	for row in result:
		managerdetails[row[0]] = row[1]
	return template('adminHome', values=[loggedinUser, inserted], menu=["addManager"], dininglocation=managerdetails, diningdetails=[])

@route("/addLocation", method="POST")
def addLocation_todb():
	checkSession()
	loggedinUser = getSession()
	diningname = request.POST.get('diningname','').strip()
	address = request.POST.get('address','').strip()
	city = request.POST.get('city','').strip()
	state = request.POST.get('state','').strip()
	zipcode = request.POST.get('zipcode','').strip()
	contactnumber = request.POST.get('contactNumber','').strip()
	
	connection = sqlite3.connect('ShiftPlanner.db')
	inserted = 1
	try:
		connection.execute('INSERT INTO DiningLocation(Name, Address, City, State, Zipcode, ContactNumber, IsActive) VALUES(?,?,?,?,?,?,?)', (diningname, address, city, state, (int(zipcode)), (int(contactnumber)), 1))
		connection.commit()
	except Exception as err:
		print(err)
		inserted = -1

	cursor = connection.cursor()
	cursor.execute('SELECT LocationID, Name FROM DiningLocation')
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('adminHome', values=[loggedinUser, inserted], menu=["addLocation"], dininglocation=diningdetails, diningdetails=[])
