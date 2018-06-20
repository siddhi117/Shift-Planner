<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<link rel="stylesheet" type="text/css" href="../menu.css"/>
	<link rel="stylesheet" type="text/css" href="../login.css"/>
	<script type="text/javascript">
		function showDiv(id){
			<!--alert(id); -->
			id.style.display = "block";
			
		}
		
		function verifyaddavailabilityValues(){
			var startdate = document.getElementById("startDate").value;
			var enddate = document.getElementById("endDate").value;
			
			var starttime = document.getElementById("startTime").value;
			var endtime = document.getElementById("endTime").value;
			
			var time = ["00:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
				
			var today = new Date();
			today = today.getFullYear()+"/"+(today.getMonth()+1)+"/"+today.getDate();
			
			if(locationid==-1 || startdate == "" || enddate == "" || totalshifts == ""){
				document.getElementById("errorLabel").innerHTML = "All the fields are required.";
				return false;
			}
			else if(Date.parse(startdate+"T"+starttime) < Date.parse(today)){
				document.getElementById("errorLabel").innerHTML = "Start Date must occur after today.";
				return false;
			}
			else if(startdate > enddate){
				document.getElementById("errorLabel").innerHTML = "End Date cannot occur before Start Date.";
				return false;
			}
			else if(time.indexOf(starttime) >= time.indexOf(endtime)){
				document.getElementById("errorLabel").innerHTML = "End time cannot occur before Start time.";
				return false;
			}
			else if(int(totalshifts)<0){
				document.getElementById("errorLabel").innerHTML = "Total Shifts must be greater than 0.";
				return false;
			}
			return true;
		}
		function verifyupdateavailabilityValues(){
			var startdate = document.getElementById("startdate").value;
			var enddate = document.getElementById("enddate").value;
			
			var starttime = document.getElementById("starttime").value;
			var endtime = document.getElementById("endtime").value;
			
			var time = ["00:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
				
			var today = new Date();
			today = today.getFullYear()+"/"+(today.getMonth()+1)+"/"+today.getDate();
			
			if(locationid==-1 || startdate == "" || enddate == "" || totalshifts == ""){
				document.getElementById("errorLabel").innerHTML = "All the fields are required.";
				return false;
			}
			else if(Date.parse(startdate+"T"+starttime) < Date.parse(today)){
				document.getElementById("errorLabel").innerHTML = "Start Date must occur after today.";
				return false;
			}
			else if(startdate > enddate){
				document.getElementById("errorLabel").innerHTML = "End Date cannot occur before Start Date.";
				return false;
			}
			else if(time.indexOf(starttime) >= time.indexOf(endtime)){
				document.getElementById("errorLabel").innerHTML = "End time cannot occur before Start time.";
				return false;
			}
			else if(int(totalshifts)<0){
				document.getElementById("errorLabel").innerHTML = "Total Shifts must be greater than 0.";
				return false;
			}
			return true;
		}

		function getAvailability(){
			var http = new XMLHttpRequest();
			var date = document.getElementById("AvailabilityDate").value;
			var url = "/getavailability";
			
			if(date == ""){
				document.getElementById("errorLabel1").innerHTML = "All the fields are required.";
				return false;
			}
			
			return true;
		}	
	</script>
	<style type="text/css">
		input[type="date"]:before {
			content: attr(placeholder) !important;
			color: #aaa;
			margin-right: 0.5em;
		  }
		  input[type="date"]:focus:before,
		  input[type="date"]:valid:before {
			content: "";
		  }
		  table,td{
			border:1px solid #aaa;
		  }
		  table{
			border-collapse:collapse;
		  }
	</style>
  </head>
  <body style="background-color:#F0F0F0;" onload="showDiv({{str(menu[0])}})">
	<div id="main-div">
		<div id="menu-div">
			<h2 align="center">Shift Planner</h2>
			<h2 align="center">Welcome {{values[0]}}</h2>
				<ul id="menu">
					<li>
						<a href="#"> Availability ￬</a>
						<ul class="hidden">
							<li><a href="/addavailability">Add Availability</a></li>
							<li><a href="/updateavailability">Update Availability</a></li>
							<!-- <li><a href="#">Delete Availability</a></li> -->
							<li><a href="/viewavailability">View Availability</a></li>
						</ul>
					</li>
					<!--<li>
						<a href="#">Available Shifts ￬</a>
						<ul class="hidden">
							<li><a href="#">View Shifts</a></li>
							<li><a href="#">Take Shifts</a></li>
						</ul>
					</li> -->
					<!--<li><a href="#">Cancel Shifts</a></li> -->
					<li><a href="/logout">Logout</a></li>
				</ul>
		</div>		
		
		<div id="contentpane" style="width:100%;margin-left:auto;margin-right:auto;height:60%;bottom:0;z-index: -1; position:absolute;">
			%time = ["00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00",					"15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00",					"22:30","23:00","23:30","24:00"]
			<div id="addavailability" class="form" style="display:none;">				
				<h2 style="padding-top:0;margin-top:0;">Add Availability</h2>
				<form action="/addavailability" method="POST" class="login-form" onsubmit="return verifyaddavailabilityValues();">					
					<input type="date" id="startDate" name="startDate" placeholder="Select Start Date"/>
					<input type="date" id="endDate" name="endDate" placeholder="Select End Date"/>
					<select id="startTime" name="startTime">
						%for hour in time:
							<option value="{{hour}}">{{hour}}</option>
						%end
					</select>
					<select id="endTime" name="endTime">
						%for hour in time:
							<option value="{{hour}}">{{hour}}</option>
						%end
					</select>
					%days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
					<select id="day" name="day">
						%for day in days:
							<option name="{{day}}">{{day}}</option>
						%end
					</select>
					
					<input type="submit" id="addavailabilitybutton" value="Add Availability"/>
					<span id="errorLabel" style="color:red"></span>
					%for index,row in enumerate(values):
						%if(index!=0 and row!=None):
							%if(row==1):
								<span id="label{{index}}" style="color:green">Student Availability details are entered successfully.</span>
							%else:
								<span id="label{{index}}" style="color:red">Error occurred while adding Student Availabilitys Details.</span>
							%end
						%end
					%end
				</form>
			</div>
			<div id="updateavailability" class="form" style="display:none;">				
				<h2 style="padding-top:0;margin-top:0;">Update Availability</h2>
				<form action="/updateavailability" method="POST" class="login-form" onsubmit="return verifyupdateavailabilityValues();">					
					<input type="date" id="startdate" name="startdate" placeholder="Select Start Date"/>
					<input type="date" id="enddate" name="enddate" placeholder="Select End Date"/>
					<select id="starttime" name="starttime">
						%for hour in time:
							<option value="{{hour}}">{{hour}}</option>
						%end
					</select>
					<select id="endtime" name="endtime">
						%for hour in time:
							<option value="{{hour}}">{{hour}}</option>
						%end
					</select>
					%days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
					<select id="day" name="day">
						%for day in days:
							<option name="{{day}}">{{day}}</option>
						%end
					</select>
					
					<input type="submit" id="updateavailabilitybutton" value="Update Availability"/>
					<span id="errorLabel" style="color:red"></span>
					%for index,row in enumerate(values):
						%if(index!=0 and row!=None):
							%if(row==1):
								<span id="label{{index}}" style="color:green">Student Availability details are updated successfully.</span>
							%else:
								<span id="label{{index}}" style="color:red">Error occurred while updating Student Availabilitys Details.</span>
							%end
						%end
					%end
				</form>
			</div>
			<div id="viewavailability" style="display:none;">
				<form action="/getavailability" method="POST" class="login-form">	
					<div class="form">						
						<input type="date" id="AvailabilityDate" name="viewavailability" placeholder="Select Date"/>					
						<input type="submit" value="Check Availability" onsubmit="return getAvailability()"/>
						<span id="errorLabel1" style="color:red"></span>
					</div>
				</form>
				<table style="width:70%;margin:auto;">
					%for hour in time:
						<tr>
							<td style="width:10%;max-width:10%;text-align:center;" id="{{hour}}">{{hour}}</td>
							%index = time.index(hour)
							%for avail in studentavailability:
								%index1 = time.index(avail[4])
								%index2 = time.index(avail[5])
								%if(index1<=index and index2>=index):
									%if(index1==index):
										<td style="background-color:cyan;border-top:2px solid;border-left:2px solid;border-right:2px solid;border-bottom:0px;max-width:20%;width:20%;">
											Availability ID: {{avail[0]}}
											<br/>
											Start Date: {{avail[2]}}
											<br/>
											End Date: {{avail[3]}}
										</td>
									%elif(index2==index):
										<td style="background-color:cyan;border-bottom:2px solid;border-left:2px solid;border-right:2px solid;border-top:0px;max-width:20%;width:20%;"></td>
									%else:
										<td style="background-color:cyan;border-left:2px solid;border-right:2px solid;border-top:0px;border-bottom:0px;max-width:20%;width:20%;"></td>
									%end
								%else:
									<td></td>
								%end
							%end
						</tr>
					%end
				</table>
			</div>
		</div>
		</div>
	
	<div>
  </body>
</html>
