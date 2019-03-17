<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "dev"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
?>
<html lang="en">
<head>
  <title>Dev Home</title>
</head>
<body>
<h1>Welcome <?php echo("{$_SESSION['username']}"."");?>!</h1>

<form method ="post" action="report.php">
    <h2>
        Press to show reports
    </h2>
    <button type="submit">Show</button>
</form>

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

<form method ="post" action="manager.php">
    <h2>
        Press to show manager data
    </h2>
    <button type="submit">Show</button>
</form>

<form method ="post" action="allstations.php">
    <h2>
        Press to view all the stations
    </h2>
    <button type="submit">Show</button>
</form>

<form method ="post" action="insert.php">
    <h2>
        Press to insert more data
    </h2>
    <button type="submit">Go</button>
</form>

<form method ="post" action="maps.php">
    <h2>
        Press to go to map data
    </h2>
    <button type="submit">Go</button>
</form>

<form method ="post" action="staffcreate.php">
    <h2>
        Create staff account
    </h2>
    <button type="submit">Go</button>
</form>



















  <form method ="post" action="logout.php">
      <button type="submit">Log Out</button>
  </form>

</body>
</html>
