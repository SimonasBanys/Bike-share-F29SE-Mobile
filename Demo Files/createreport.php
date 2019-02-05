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
$userID = $_POST[userID];
$bikeID = $_POST[bikeID];
$problem = $_POST[problem];


$query="INSERT INTO CurrentUserReports
(userID, bikeID, problem)
VALUES ('$userID','$bikeID','$problem')";

if(mysqli_query($dbc, $query)){

    echo "Done <br>";

}else{
    echo "ERROR:" . mysqli_error($dbc);
}


?>
<form method ="post" action="demo.html">
    <h1>
        Press to go back
    </h1>
    <button type="submit">BACK</button>
</form>
</body>
</html>
