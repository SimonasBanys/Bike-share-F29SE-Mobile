<html>
<body>
<h1>Scheduling Maintenance...</h1>

<?php
DEFINE ('DB_HOST', 'mysql-server-1.macs.hw.ac.uk');
DEFINE ('DB_USER', 'rh49');
DEFINE ('DB_PASSWORD', 'e8FpS0qItsvAFLz4');
DEFINE ('DB_NAME', 'rh49');

$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());

$array = Array();
$repID = $_POST[reportID];

echo "Array built... <br>";

$query = "SELECT * FROM SolvedUserReports WHERE reportID ='" .$repID. "' AND needsMaintenance ='yes'";
echo "query built... <br>";
$result = mysqli_query($dbc, $query);
echo "got result... <br>";
while($row = mysqli_fetch_array($result)) {
    $array[] = $row;
}

$bikeID = $array[0][2];

$staffID = $_POST[staffID];
$input_dS = $_POST[dateScheduled];
$dS=date("Y-m-d",strtotime($input_dS));
$input_eLoR = $_POST[estimatedLengthOfRepair];
$eLoR=date("H:i:s",strtotime($input_eLoR));

$query="INSERT INTO ScheduledMaintenance
(bikeID, staffID, reportID, dateScheduled, estimatedLengthOfRepair)
VALUES ('$bikeID','$staffID','$repID','$dS','$eLoR')";

if(mysqli_query($dbc, $query)){
    echo "Done <br>";
}else{
    echo "ERROR:" . mysqli_error($dbc);
}


?>
<form method ="post" action="maintenance.php">
    <h1>
        Press to go back
    </h1>
    <button type="submit">BACK</button>
</form>
</body>
</html>
