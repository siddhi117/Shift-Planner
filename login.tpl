<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<link rel="stylesheet" type="text/css" href="../login.css" />
	<script type="text/javascript">
		function validateLogin(){
			var email = document.getElementById('loginEmail').value;
			var pwd = document.getElementById('loginPassword').value;
			
			var regex = /^[^@.,:\"\']*([a-z]+)([0-9]*)@kent.edu$/;
			if(email.trim() == "" || pwd.trim() == ""){
				document.getElementById('errorLabel').innerHTML = 'Email or Password cannot be empty.';
				return false;
			}
			else if(!regex.test(email)){
				document.getElementById('errorLabel').innerHTML = 'Email is not valid.';
				return false;
			}
		}
	</script>
  </head>
  <body style="background-color:#F0F0F0;">
    <div class="login-page">
		<h2 align="center">Shift Planner Login</h2>
		<div class="form">
			<form action="/login" method="POST" class="login-form">
				<input type="text" id="loginEmail" name="loginEmail" placeholder="Email"/>
				<input type="password" id="loginPassword" name="loginPassword" placeholder="Password"/>
				<input type="submit" value="Login" onclick="return validateLogin();" id="loginButton"/>
				<span id="errorLabel" style="color:red"></span>
				%for index,row in enumerate(rows):
					<span id="label{{index}}" style="color:red">{{row}}</span>
				%end
			</form>
		</div>
	</div>
  </body>
</html>
