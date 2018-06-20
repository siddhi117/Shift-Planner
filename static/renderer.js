// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

document.getElementById('loginButton').addEventListener('click', function(){
	var email = document.getElementById('loginEmail')
	var pwd = document.getElementById('loginPassword')
	
	alert('null: '+(email.equals("")))
	if(email == null || pwd == null){
		alert("null")
		document.getElementById('errorLabel').innerHTML = 'Email or Password cannot be empty.';
		return false;
	}
})