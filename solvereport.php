<?php
DEFINE ('DB_HOST', 'mysql-server-1.macs.hw.ac.uk');
DEFINE ('DB_USER', 'rh49');
DEFINE ('DB_PASSWORD', 'e8FpS0qItsvAFLz4');
DEFINE ('DB_NAME', 'rh49');

$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());

$array = Array();

$result = mysql_query("SELECT * FROM CurrentUserReports WHERE reportID = '$_POST[reportID]'");
while ($row = mysql_fetch_array($result)) {
    $array[] = $row;
}

$query="INSERT INTO SolvedUserReports
(reportID, userID, bikeID, problem, latitude, longitude, staffID, needsMaintenance)
VALUES ('$_POST[reportID]',. $array[1] .,. $array[2] .,. $array[3] .,. $array[4] .,. $array[5] .,'$_POST[staffID]','$_POST[needsMaintenance]')";

if(mysqli_query($dbc, $query)){
    echo "";
}else{
    echo "ERROR:" . mysqli_error($dbc);
}

?>
