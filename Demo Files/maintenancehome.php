<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "maintenance"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
?>
<html lang="en">
<head>
  <title>Maintenance Home</title>
</head>
<body>
<h1>Welcome <?php echo("{$_SESSION['username']}"."");?>!</h1>

<form method ="post" action="maintenance.php">
    <h2>
        Press to show solved reports
    </h2>
    <button type="submit">Show</button>
</form>

<form method ="post" action="completemaintenance.php">
    <h2>
        Press to show all scheduled maintenance
    </h2>
    <button type="submit">Show</button>
</form>


  <form method ="post" action="logout.php">
      <button type="submit">Log Out</button>
  </form>


</body>
</html>
