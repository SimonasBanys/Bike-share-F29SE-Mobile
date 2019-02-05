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
$repID = $_POST[reportID];

echo "Array built... <br>";

$query = "SELECT * FROM CurrentUserReports WHERE reportID ='" .$repID. "'";
echo "query built... <br>";
$result = mysqli_query($dbc, $query);
echo "got result... <br>";
while($row = mysqli_fetch_array($result)) {
    $array[] = $row;
}

$v1 = $array[0][1];
$v2 = $array[0][2];
$v3 = $array[0][3];
$v4 = $array[0][4];
$v5 = $array[0][5];
$staffID = $_POST[staffID];
$nM = $_POST[needsMaintenance];

$query="INSERT INTO SolvedUserReports
(reportID, userID, bikeID, problem, latitude, longitude, staffID, needsMaintenance)
VALUES ($repID,$v1,$v2,'$v3',$v4,$v5,$staffID,'$nM')";

if(mysqli_query($dbc, $query)){

    echo "Done <br>";

    echo "Deleting old report... <br>";

    $delQuery = "DELETE FROM CurrentUserReports WHERE reportID ='" .$repID. "'";

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
