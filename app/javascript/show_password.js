function showPassword() {
  var x = document.getElementById("user_password");
 if (x.type === "password") {
   x.type = "text";
 } else {
   x.type = "password";
 }
}
