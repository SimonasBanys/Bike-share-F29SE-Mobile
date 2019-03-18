<?php

$response = array();

$db_host = 'mysql-server-1.macs.hw.ac.uk';
$db_user = 'rh49';
$db_pass = 'e8FpS0qItsvAFLz4';
$db_name = 'rh49';

$con = @mysqli_connect($db_host, $db_user, $db_pass, $db_name)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());



$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE); //convert JSON into array
$userID = $input["user"];
$bikeID = $input["bike"];
$problem = $input["problem"];

$getID = "SELECT userID FROM UserInfo WHERE username = ?";

if ($stmt = $con->prepare($getID)){
    $stmt->bind_param("s",$userID);
    $stmt->execute();
    $stmt->bind_result($user);
    if ($stmt->fetch()){
        $stmt->close();
        $query="INSERT INTO CurrentUserReports(userID, bikeID, problem) VALUES (?,?,?)";
        if ($stmt2 = $con->prepare($query)) {
            $stmt2->bind_param("iis", $user, $bikeID, $problem);
            $stmt2->execute();
            $response["status"] = 0;
            $response["message"] = "Problem successfully reported";
            $stmt2->close();
        } else {
            $response["status"] = 1;
            $response["message"] = "Error reporting problem";
        }
    }
}
echo json_encode($response, JSON_FORCE_OBJECT);
?>

