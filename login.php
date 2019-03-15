<?php
$response = array();


$db_host = 'mysql-server-1.macs.hw.ac.uk';
$db_user = 'rh49';
$db_pass = 'e8FpS0qItsvAFLz4';
$db_name = 'rh49';

$con = @mysqli_connect($db_host, $db_user, $db_pass, $db_name)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());

//Get the input request parameters
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE); //convert JSON into array

//Check for Mandatory parameters
if(isset($input['username']) && isset($input['password'])){
    $username = $input['username'];
    $password = $input['password'];
    $query    = "SELECT password FROM UserInfo WHERE username = ?";

    if($stmt = $con->prepare($query)){
        $stmt->bind_param("s",$username);
        $stmt->execute();
        $stmt->bind_result($passwordHashDB);
        if($stmt->fetch()){
            //Validate the password
            if(password_verify($password,$passwordHashDB)){
                $response["status"] = 0;
                $response["message"] = "Login successful";
            }
            else{
                $response["status"] = 1;
                $response["message"] = "Invalid username and password combination";
            }
        }
        else{
            $response["status"] = 1;
            $response["message"] = "Invalid username and password combination";
        }

        $stmt->close();
    }
}
else{
    $response["status"] = 2;
    $response["message"] = "Missing mandatory parameters";
}
//Display the JSON response
echo json_encode($response, JSON_FORCE_OBJECT);
?>