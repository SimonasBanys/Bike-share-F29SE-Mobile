<html>
<body>
<h1>Adding station...</h1>

<?php
DEFINE ('DB_HOST', 'mysql-server-1.macs.hw.ac.uk');
DEFINE ('DB_USER', 'rh49');
DEFINE ('DB_PASSWORD', 'e8FpS0qItsvAFLz4');
DEFINE ('DB_NAME', 'rh49');

$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());

$stationName = $_POST[stationName];
$latitude = $_POST[latitude];
$longitude = $_POST[longitude];
$addressLine1 = $_POST[addressLine1];
$addressLine2 = $_POST[addressLine2];
$postcode = $_POST[postcode];

$maxParkingSpaces = $_POST[maxParkingSpaces];
$availableParkingSpaces = $_POST[availableParkingSpaces];

$query="INSERT INTO StationInfo
(stationName, latitude, longitude, addressLine1, addressLine2, postcode)
VALUES ('$stationName','$latitude','$longitude','$addressLine1','$addressLine2','$postcode')";

if(mysqli_query($dbc, $query)){

    echo "Done Step 1<br>";
    echo "Adding More Data... <br>";

    $array = Array();
    $query2 = "SELECT * FROM StationInfo WHERE stationName ='" .$stationName. "'";
    $result2 = mysqli_query($dbc, $query2);
    while($row = mysqli_fetch_array($result2)) {
        $array[] = $row;
    }
    $v1 = $array[0][1];

    $query3="INSERT INTO StationStatus
    (stationID, maxParkingSpaces, availableParkingSpaces)
    VALUES ('$v1','$maxParkingSpaces','$availableParkingSpaces')";

    if(mysqli_query($dbc, $query3)){
        echo "Done Step 2<br>";
    }else{
        echo "ERROR:" . mysqli_error($dbc);
    }

}else{
    echo "ERROR:" . mysqli_error($dbc);
}


?>
<form method ="post" action="report.php">
    <h1>
        Press to go back
    </h1>
    <button type="submit">BACK</button>
</form>
</body>
</html>
