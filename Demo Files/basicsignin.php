<?php
include 'config.php';
?>
<html lang="en">
<head>
  <title>Sign In to Staff Account</title>
</head>
<body>

  <form action="signinfunction.php" method="post">
  <h1>Enter Account Details:</h1><br>
  username: <input type="text" name="username"><br>
  password: <input type="password" name="password"><br>
  <input type="submit">
  </form>
</body>
</html>
