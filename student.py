import sqlite3 
import bottle_session
import bottle
from datetime import time, datetime, date
from bottle import route, run, template, request, static_file, get, redirect

studentSession = ""

@get('/<filename:re:.*\.*>')
def server_static(filename):
    return static_file(filename, root='./static/')

@route('/logout')
def logout():
	session = bottle.request.environ.get('beaker.session')
	session['sp_user']=''
	session['usertype']=''
	return redirect('/')

def getSession():
	session = bottle.request.environ.get('beaker.session')
	if(session!=""):
		return session.get('sp_user')
	else:
		return ""

def studentHome(session):
	checkSession()
	loggedinUser = getSession()
	return template('studentHome',values=[loggedinUser],menu=[""], userinformation = {},studentavailability = [])
	
def checkSession():
	session = bottle.request.environ.get('beaker.session')
	if(session.get('sp_user') == "" or session.get('sp_user') == None or session.get('usertype')!="STU"):
		return redirect("/")
	else:
		return ""
	
@route("/addavailability",method="GET")
def addavailability():
	checkSession()
	loggedinUser = getSession()
	return template('studentHome',values=[loggedinUser],menu=["addavailability"], userinformation = {},studentavailability = [])
	
@route("/addavailability",method="POST")
def addavailability_todb():
	checkSession()
	loggedinUser = getSession()
	startdate = request.POST.get('startDate','').strip()
	enddate = request.POST.get('endDate','').strip()
	starttime = request.POST.get('startTime','').strip()
	endtime = request.POST.get('endTime','').strip()
	day = request.POST.get('day','').strip()
	
	startyear, startmonth, startday = startdate.split("-")
	endyear, endmonth, endday = enddate.split("-")
		
	time1_str = startdate + " " + starttime
	time2_str = enddate + " " + endtime
	time1 = datetime.strptime(time1_str, "%Y-%m-%d %H:%M")
	time2 = datetime.strptime(time2_str, "%Y-%m-%d %H:%M")
	
	connection = sqlite3.connect('ShiftPlanner.db')
	inserted = 1
	try:
		cursor = connection.cursor()
		cursor.execute('SELECT UserID FROM UserInformation WHERE Email="%s"'%loggedinUser)
		result = cursor.fetchone()

		connection.execute('INSERT INTO StudentAvailability(StudentID,StartDate,EndDate,StartTime,EndTime,Day,IsActive) VALUES(?,?,?,?,?,?,?)',(int(result[0]),date(int(startyear), int(startmonth), int(startday)),
		date(int(endyear), int(endmonth), int(endday)),time1,time2,day,1))
		connection.commit()
	except Exception as err:
		inserted = -1
		
	return template('studentHome',values=[loggedinUser,inserted],menu=["addavailability"], userinformation = {},studentavailability = [])
	
	
@route("/updateavailability",method="GET")
def updateavailability():
	checkSession()
	loggedinUser = getSession()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM StudentAvailability')
	result = cursor.fetchall()
	cursor.close()
	return template('studentHome',values=[loggedinUser],menu=["updateavailability"], userinformation = {},studentavailability = [])
	
@route("/updateavailability",method="POST")
def updateavailability_todb():
	checkSession()
	loggedinUser = getSession()
	startdate = request.POST.get('startDate','').strip()
	enddate = request.POST.get('endDate','').strip()
	starttime = request.POST.get('startTime','').strip()
	endtime = request.POST.get('endTime','').strip()
	day = request.POST.get('day','').strip()
	
	startyear, startmonth, startday = startdate.split("-")
	endyear, endmonth, endday = enddate.split("-")
		
	time1_str = startdate + " " + starttime
	time2_str = enddate + " " + endtime
	time1 = datetime.strptime(time1_str, "%Y-%m-%d %H:%M")
	time2 = datetime.strptime(time2_str, "%Y-%m-%d %H:%M")
	
	connection = sqlite3.connect('ShiftPlanner.db')
	inserted = 1
	try:
		cursor = connection.cursor()
		cursor.execute('UPDATE UserInformation WHERE Email="%s"'%loggedinUser)
		result = cursor.fetchone()

		connection.execute('UPDATE StudentAvailability SET StartDate = ?,EndDate = ?,StartTime = ?,EndTime = ?,Day = ? WHERE StudentID=?',(date(startyear,startmonth,startday),date(endyear,endmonth,endday),time1,time2,day,result[0])) 
		connection.commit()
	except Exception as err:
		inserted = -1
		
	return template('studentHome',values=[loggedinUser,inserted],menu=["updateavailability"], userinformation = {},studentavailability = [])

@route("/viewavailability",method="GET")
def viewavailability():
	checkSession()
	loggedinUser = getSession()
	return template('studentHome',values=[loggedinUser],menu=["viewavailability"], userinformation = {},studentavailability = [])

@route("/getavailability",method="POST")
def getavailability_fromdb():
	checkSession()
	weekdays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
	loggedinUser = getSession()
	date = request.POST.get('viewavailability','').strip()
	
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT UserID FROM UserInformation WHERE Email = "%s"'%loggedinUser)
	result = cursor.fetchone()	
	
	cursor.execute('SELECT ID,StudentID,StartDate,EndDate,strftime("%H:%M",StartTime),strftime("%H:%M",EndTime),Day FROM StudentAvailability WHERE StudentID=? AND StartDate<=? AND EndDate>=? AND IsActive=1',(int(result[0]),date,date))
	result = cursor.fetchall()
	cursor.close()
	print(result)
	return template('studentHome',values=[loggedinUser],menu=["viewavailability"], userinformation = {},studentavailability = result)
