<?php
DEFINE ('DB_HOST', 'mysql-server-1.macs.hw.ac.uk');
DEFINE ('DB_USER', 'rh49');
DEFINE ('DB_PASSWORD', 'e8FpS0qItsvAFLz4');
DEFINE ('DB_NAME', 'rh49');

$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());
?>
<html lang="en">
<head>
    <title>Reports</title>
</head>
<body>
<form method ="post" action="demo.html">
    <h1>
        Press to go back
    </h1>
    <button type="submit">BACK</button>
</form>


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
