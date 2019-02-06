<?php
$response = array();
include 'config.php';
include 'functions.php';

//Get the input request parameters
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE); //convert JSON into array

//Check for Mandatory parameters
if(isset($input['username']) && isset($input['password']) && isset($input['full_name'])){
    $username = $input['username'];
    $password = $input['password'];
    $DoB = $input['dob'];
    $firstName = $input['first_name'];
    $lastName = $input['last_name'];
    $email = $input['email'];


    //Check if user already exist
    if(!userExists($username)){

        //Get a unique Salt
        $salt         = getSalt();

        //Generate a unique password Hash
        $passwordHash = password_hash(concatPasswordWithSalt($password,$salt),PASSWORD_DEFAULT);

        //Query to register new user
        $insertQuery  = "INSERT INTO UserInfo(username, firstName, lastName, password, email, dob) VALUES (?,?,?,?)";
        if($stmt = $con->prepare($insertQuery)){
            $stmt->bind_param($username,$firstName,$lastName,$password,$email,$DoB);
            $stmt->execute();
            $response["status"] = 0;
            $response["message"] = "User created";
            $stmt->close();
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
echo json_encode($response);
?>