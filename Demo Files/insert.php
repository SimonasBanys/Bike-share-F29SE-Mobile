<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "dev" && $_SESSION['role'] != "manager"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
?>
<html lang="en">
<head>
    <title>Reports</title>
</head>
<body>
<button onclick="history.go(-1);">Back</button>


<form action="insertstation.php" method="post">
<h1>Add Station:</h1><br>
Station Name: <input type="text" name="stationName"><br>
latitude: <input type="number" name="latitude"><br>
longitude: <input type="number" name="longitude"><br>
addressLine1: <input type="text" name="addressLine1"><br>
addressLine2: <input type="text" name="addressLine2"><br>
Postcode: <input type="text" name="postcode"><br>

Maximum Number of Parking Spaces: <input type="number" name="maxParkingSpaces"><br>
Currently Available Parking Spaces: <input type="number" name="availableParkingSpaces"><br>
<input type="submit">
</form>

</body>
</html>
