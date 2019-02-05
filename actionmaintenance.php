<html>
<body>
<h1>Solving report...</h1>

<?php
DEFINE ('DB_HOST', 'mysql-server-1.macs.hw.ac.uk');
DEFINE ('DB_USER', 'rh49');
DEFINE ('DB_PASSWORD', 'e8FpS0qItsvAFLz4');
DEFINE ('DB_NAME', 'rh49');

$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());

$array = Array();
$mainID = $_POST[maintenanceID];
$staffID = $_POST[staffID];

$input_doC = $_POST[dateOfCompletion];
$doC=date("Y-m-d",strtotime($input_doC));
$input_loR = $_POST[lengthOfRepair];
$loR=date("H:i:s",strtotime($input_loR));
$notes = $_POST[notes];

echo "Array built... <br>";

$query = "SELECT * FROM ScheduledMaintenance WHERE maintenanceID ='" .$mainID. "'";
echo "query built... <br>";
$result = mysqli_query($dbc, $query);
echo "got result... <br>";
while($row = mysqli_fetch_array($result)) {
    $array[] = $row;
}

$v1 = $array[0][2];
$v2 = $array[0][4];
$v3 = $array[0][5];

$query="INSERT INTO CompletedMaintenance
(maintenanceID, bikeID, staffID, dateScheduled, estimatedLengthOfRepair, dateOfCompletion, lengthOfRepair, notes)
VALUES ('$mainID','$v1','$staffID','$v2','$v3','$doC','$loR','$notes')";

if(mysqli_query($dbc, $query)){

    echo "Done <br>";

    echo "Deleting old report... <br>";

    $delQuery = "DELETE FROM ScheduledMaintenance WHERE maintenanceID ='" .$mainID. "'";

    if(mysqli_query($dbc, $delQuery)){
        echo "Done <br>";
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
