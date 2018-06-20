<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShiftPlanner</title>
	<link rel="stylesheet" type="text/css" href="../menu.css"/>
	<link rel="stylesheet" type="text/css" href="../login.css"/>
	<script type="text/javascript">
		function showDiv(id){
			id.style.display = "block";
		}

		function verifyAddLocationValues(){
			var locname = document.getElementById("diningname").value;
			var address = document.getElementById("address").value;
			var city = document.getElementById("city").value;
			var state = document.getElementById("state").value;
			var zipcode = document.getElementById("zipcode").value;
			var contactnum = document.getElementById("contactNumber").value;
			var isactive = document.getElementById("isActive").value;

			if(locname=="" || address=="" || city=="" || state==""){
				document.getElementById("errorLabel").innerHTML = "All fields are required.";
				return false;
			}
			else if(zipcode.length != 5){
				document.getElementById("errorLabel").innerHTML = "Zip Code was invalid.";
				return false;
			}
			else if(contactnum.length != 10){
				document.getElementById("errorLabel").innerHTML = "Contact Number was invalid.";
				return false;
			}	
			else if(isactive == 0){
				document.getElementById("errorLabel").innerHTML = "Activation was invalid";
				return false;
			}
			return true;
		}
		
		function verifyAddManagerValues(){
			var userid = document.getElementById("userid").value;
			var name = document.getElementById("name").value;
			var email = document.getElementById("email").value;
			var contactnumber = document.getElementById("contactnumber").value;

			if(userid=="" || name=="" || email==""){
				document.getElementById("errorLabel1").innerHTML = "All fields are required.";
				return false;
			}
			else if(userid.length != 9){
				document.getElementById("errorLabel1").innerHTML = "User ID was invalid.";
				return false;
			}
			else if(contactnumber.length != 10){
				document.getElementById("errorLabel1").innerHTML = "Contact Number was invalid.";
				return false;
			}
			return true;
		}
	</script>
	<style type="text/css">
		input[type="date"]:before{
			content: attr(placeholder) !important;
			color: #aaa;
			margin-right: 0.5em;
		}
		input[type="date"]:focus:before,
		input[type="date"]:valid:before{
			content: "";
		}
		table, td{
			border:1px solid #aaa;	
		}
		table{
			border-collapse:collapse;
		}
	</style>
</head>
<body style="background-color: #F0F0F0;" onload="showDiv({{str(menu[0])}})">
<div id="main-div">
	<div id="menu-div">
		<h2 align="center">Shift Planner</h2>
		<h2 align="center">Welcome {{values[0]}}</h2>
			<ul id="menu">
				<li>
					<a href="#">Dining Locations ￬</a>
					<ul class="hidden">
						<li><a href="/addLocation">Add Location</a></li>
						<!--<li><a href="#">Update Location</a></li>-->
						<li><a href="/viewLocations">View Location</a></li>
					</ul>
				</li>
				<li>
					<a href="#">Managers ￬</a>
					<ul class="hidden">
						<li><a href="/addManager">Add Manager</a></li> 
						<!--<li><a href="#">Update Managers</a></li>-->
						<!--<li><a href="#">View Managers</a></li>-->
					</ul>
				</li>
				<li><a href="/logout">Logout</a></li>
			</ul>
	</div>
	<div id="contentpanel" style="width:100%;margin-left:auto;margin-right:auto;height:60%;bottom:0;z-index: -1; position:absolute;">
		<div id="addLocation" class="form" style="display:none;">
			<h2 style="padding-top:0;margin-top:0;">Add Dining Location</h2>
			<form action="/addLocation" method="POST" class="login-form" onsubmit="return verifyAddLocationValues();">
				<input type="text" id="diningname" name="diningname" placeholder="Dining Location Name"/>
				<input type="text" id="address" name="address" placeholder="Address"/>
				<input type="text" id="city" name="city" placeholder="City"/>
				<input type="text" id="state" name="state" placeholder="State"/>
				<input type="number" id="zipcode" name="zipcode" placeholder="ZipCode">
				<input type="number" id="contactNumber" name="contactNumber" placeholder="Contact Number"/>
				<input type="submit" id="addLoc" value="Add Dining Location"/>
				<span id="errorLabel" style="color:red"></span>
				%for index, row in enumerate(values):
					%if(index!=0 and row!=None):
						%if(row==1):
							<span id="label{{index}}" style="color:green">Dining Location details are entered successfully.</span>
						%else:
							<span id="label{{index}}" style="color:red">Error occurred while adding Dining Location.</span>
						%end
					%end
				%end
			</form>
		</div>
		<div id="addManager" class="form" style="display:none;">
			<h2 style="padding-top:0;margin-top:0;">Add Manager</h2>
			<form action="/addManager" method="POST" class="login-form" onsubmit="return verifyAddManagerValues();">
				<select id="dininglocation" name="dininglocation">
					<option value="-1">Select Dining Location</option>
					%for key, value in dininglocation.items():
						<option value="{{key}}">{{value}}</option>
					%end
				</select>
				<input type="number" id="userid" name="userid" placeholder="User ID"/>
				<input type="text" id="name" name="name" placeholder="First & Last Name"/>
				<input type="text" id="email" name="email" placeholder="Email"/>
				<input type="number" id="contactnumber" name="contactnumber" placeholder="Contact Number"/>
				<input type="submit" id="addmanagers" value="Add Manager">
				<span id="errorLabel1" style"color:red"></span>
				%for index, row in enumerate(values):
					%if(index!=0 and row!=None):
						%if(row==1):
							<span id="label{{index}}" style="color:green">Manager Details are entered successfully.</span>
						%else:
							<span id="label{{index}}" style="color:red">Error occurred while adding Manager Details.</span>
						%end
					%end
				%end
			</form>
		</div>
		<div id="viewLocations" style="max-width:50%;display:none;margin-left:auto;margin-right:auto;">
			<h2 style="padding-top:0;margin-top:0;text-align:center;">Dining Locations</h2>
			<table border=1 cellspacing=3 cellpadding=3 style="border-collapse:collapse;margin:auto;">
				<tr>
					<th>Location ID</th>
					<th>Location Name</th>
					<th>Address</th>
					<th>City</th>
					<th>State</th>
					<th>ZipCode</th>
					<th>Contact Number</th>
					<th></th>
					<th></th>
				</tr>
					%for row in diningdetails:
						<tr>
							%for col in row:
								<td>{{col}}</td>
							%end
							<td><input type="button" value="DELETE"/></td>
						</tr>
					%end
			</table>
	</div>						
</div>
</body>
</html>
