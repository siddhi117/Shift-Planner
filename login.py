import sqlite3 
import manager
import student
import admin
import bottle
from bottle import route, run, template, request, debug, static_file, get
from beaker.middleware import SessionMiddleware

session_opts = {
    'session.type': 'file',
    'session.cookie_expires': 3000,
    'session.data_dir': './data',
    'session.auto': True
}
app = SessionMiddleware(bottle.app(), session_opts)

@get('/<filename:re:.*\.*>')
def server_static(filename):
    return static_file(filename, root='./static/')

@route("/")
@route("/login",method="GET")
def login():
	session = bottle.request.environ.get('beaker.session')
	if(session.get('sp_user') == "" or session.get('sp_user') == None):
		return template('login',rows=())
	elif(session.get('usertype') == "ADM"):
		return admin.adminHome(session)
	elif(session.get('usertype') == "MGR"):
		return manager.managerHome(session)
	elif(session.get('usertype') == "STU"):
		return student.studentHome(session)

@route("/login",method="POST")
def userAuthentication():
	email = request.POST.get('loginEmail','').strip()
	password = request.POST.get('loginPassword','').strip()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM UserLogin WHERE UserEmail=? AND Password = ?',(str(email),str(password)))
	result = cursor.fetchall()
	cursor.close()
	for row in result:
		if(row[2] == "ADM"):
			session = bottle.request.environ.get('beaker.session')
			session['sp_user'] = row[0]
			session['usertype'] = "ADM"
			session.save()
			return admin.adminHome(session)
		elif(row[2] == "MGR"):
			session = bottle.request.environ.get('beaker.session')
			session['sp_user'] = row[0]
			session['usertype'] = "MGR"
			session.save()
			return manager.managerHome(session)
		elif(row[2] == "STU"):
			session = bottle.request.environ.get('beaker.session')
			session['sp_user'] = row[0]
			session['usertype'] = "STU"
			session.save()
			return student.studentHome(session)
		else:
			return "<p>Login Unsuccessful</p>"
	
	return template('login',rows=["User authentication failed."])

bottle.run(app=app, host='localhost',port=8080, reloader=True)
debug(True)