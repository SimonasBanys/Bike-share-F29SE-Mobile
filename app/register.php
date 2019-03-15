<?php
$response = array();
include 'config.php';
include 'functions.php';

//Get the input request parameters
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE); //convert JSON into array
global $con;

//Check for Mandatory parameters
if(isset($input["username"]) && isset($input["password"]) && isset($input["email"])){
    $username = $input["username"];
    $password = $input["password"];
    $firstName = $input["first_name"];
    $lastName = $input["last_name"];
    $email = $input["email"];
    $DoB = $input["DoB"];
    //Check if user already exist
    if(!userExists($username)){

        //Get a unique Salt

        //Generate a unique password Hash
        $passwordHash = password_hash($password,PASSWORD_DEFAULT);

        //Query to register new user
        $insertQuery  = "INSERT INTO UserInfo(username, firstName, lastName, `password`, email, DoB) VALUES ('$username','$firstName','$lastName','$passwordHash','$email', '$DoB')";
        if(mysqli_query($con, $insertQuery)){
            $response["status"] = 0;
            $response["message"] = "User created";
        } else {
            $response["status"] = 3;
            $response["message"] = "incorrect querry";
        }
    }
    else{
        $response["status"] = 1;
        $response["message"] = "User exists";
    }
}
else{
    $response["status"] = 2;
    $response["message"] = "Missing mandatory parameters";
}
$con->close();
echo json_encode($response);
?>