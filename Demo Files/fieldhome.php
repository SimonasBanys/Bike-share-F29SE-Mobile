<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "field"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
?>
<html lang="en">
<head>
  <title>Field Home</title>
</head>
<body>
<h1>Welcome <?php echo("{$_SESSION['username']}"."");?>!</h1>

<form method ="post" action="report.php">
    <h2>
        Press to show reports
    </h2>
    <button type="submit">Show</button>
</form>


<form method ="post" action="allstations.php">
    <h2>
        Press to view all the stations
    </h2>
    <button type="submit">Show</button>
</form>



  <form method ="post" action="logout.php">
      <button type="submit">Log Out</button>
  </form>

</body>
</html>
