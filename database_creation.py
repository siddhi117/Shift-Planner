import sqlite3

connection = sqlite3.connect("ShiftPlanner.db")

connection.execute('CREATE TABLE UserInformation (UserID INTEGER(9) PRIMARY KEY, Name Varchar(30) NOT NULL, Email Varchar(20) NOT NULL, ContactNumber INTEGER(10), CreatedDate DATETIME)')
connection.execute('CREATE TABLE UserLogin (UserEmail Varchar(20), Password Varchar(100) NOT NULL, UserType Varchar(3) NOT NULL, IsActive INTEGER(1), LastLogin DATETIME, FOREIGN KEY (UserEmail) REFERENCES UserInformation(Email))')
connection.execute('CREATE TABLE UserNationality (UserID INTEGER(9), NationalityType Varchar(3) NOT NULL, FOREIGN KEY (UserID) REFERENCES UserInformation(UserID))')
connection.execute('CREATE TABLE DiningLocation (LocationID INTEGER PRIMARY KEY AUTOINCREMENT, Name Varchar(20) NOT NULL, Address Varchar(30) NOT NULL, City Varchar(20) NOT NULL, State Varchar(2) NOT NULL, Zipcode INTEGER(5) NOT NULL, ContactNumber INTEGER(10) NOT NULL, IsActive INTEGER(1) NOT NULL)')
connection.execute('CREATE TABLE UserDiningLocation (UserID INTEGER(9), DiningLocationID INTEGER NOT NULL, FOREIGN KEY (UserID) REFERENCES UserInformation(UserID), FOREIGN KEY (DiningLocationID) REFERENCES DiningLocation(LocationID))')
connection.execute('CREATE TABLE StudentAvailability (ID INTEGER PRIMARY KEY AUTOINCREMENT, StudentID INTEGER(9), StartDate Date NOT NULL, EndDate Date NOT NULL, StartTime Time NOT NULL, EndTime Time NOT NULL, Day VARCHAR(9) NOT NULL, IsActive INTEGER(1) NOT NULL, FOREIGN KEY (StudentID) REFERENCES UserInformation(UserID))')
connection.execute('CREATE TABLE ShiftDetails (ID INTEGER PRIMARY KEY AUTOINCREMENT, LocationID INTEGER(3), StartDate Date NOT NULL, EndDate Date NOT NULL, StartTime Time NOT NULL, EndTime Time NOT NULL, Day VARCHAR(9) NOT NULL, TotalShifts INTEGER(2), IsActive INTEGER(1) NOT NULL, FOREIGN KEY (LocationID) REFERENCES DiningLocation(LocationID))')
connection.execute('CREATE TABLE StudentShifts (ID INTEGER PRIMARY KEY AUTOINCREMENT, ShiftID INTEGER, StudentID INTEGER(9), AddedDate Date NOT NULL, IsActive INTEGER(1) NOT NULL, FOREIGN KEY (ShiftID) REFERENCES ShiftDetails(ID), FOREIGN KEY (StudentID) REFERENCES UserInformation(UserID))')

connection.execute('INSERT INTO UserInformation VALUES(810917421,"Heena Dave","hdave@kent.edu",3302948223,datetime("now"))')
connection.execute('INSERT INTO UserLogin VALUES("hdave@kent.edu","Admin123","ADM",1,datetime("now"))')
connection.execute('INSERT INTO DiningLocation(Name,Address,City,State,Zipcode,ContactNumber,IsActive) VALUES("Kent Market 1","Student Center","Kent","OH",44240,3301110011,1)')
connection.execute('INSERT INTO UserDiningLocation VALUES(810917421,(SELECT LocationID FROM DiningLocation WHERE Name="Kent Market 1"))')

connection.commit()
