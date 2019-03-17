<?php
session_start();
include 'config.php';

?>
<html lang="en">
<head>
  <title>Create Staff Account</title>
</head>
<body>

<button onclick="history.go(-1);">Back</button>



  <form action="staffcreatefunction.php" method="post">
  <h1>Account Details:</h1><br>
  username: <input type="text" name="username"><br>
  firstName: <input type="text" name="firstName"><br>
  lastName: <input type="text" name="lastName"><br>
  password: <input type="password" name="password"><br>
  email: <input type="email" name="email"><br>
  DoB: <input type="date" name="DoB"><br>
  jobTitle:<br>
  dev : <input type="radio" name="jobTitle" value="dev"><br>
  maintenance : <input type="radio" name="jobTitle" value="maintenance"><br>
  field : <input type="radio" name="jobTitle" value="field"><br>
  manager : <input type="radio" name="jobTitle" value="manager"><br>
  <input type="submit">
  </form>
</body>
</html>
