<?php
$response = array();
include 'config.php';
include 'functions.php';

//Get the input request parameters
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE); //convert JSON into array
global $con;

//Check for Mandatory parameters
if(isset($input['username']) && isset($input['password'])) {
    $username = $input['username'];
    $password = $input['password'];
    $query = "SELECT password FROM UserInfo WHERE username = '$username'";
    if ($passwordHashDB = mysqli_query($con, $query)) {
            //Validate the password
            if (password_verify($password, $passwordHashDB)) {
                $response["status"] = 0;
                $response["message"] = "Login successful";
            } else {
                $response["status"] = 1;
                $response["message"] = "Invalid username and password combination";
            }

    }else {
        $response["status"] = 1;
        $response["message"] = "Invalid username and password combination";
    }
}else{
    $response["status"] = 2;
    $response["message"] = "Missing mandatory parameters";
}
$con->close();
//Display the JSON response
echo json_encode($response);
?>