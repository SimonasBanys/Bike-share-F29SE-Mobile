<?php
$response = array();


$db_host = 'mysql-server-1.macs.hw.ac.uk';
$db_user = 'rh49';
$db_pass = 'e8FpS0qItsvAFLz4';
$db_name = 'rh49';

$con = @mysqli_connect($db_host, $db_user, $db_pass, $db_name)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());


function userExists($username){
    $query = "SELECT username FROM UserInfo WHERE username = ?";
    global $con;
    if($stmt = $con->prepare($query)){
        $stmt->bind_param("s",$username);
        $stmt->execute();
        $stmt->store_result();
        $stmt->fetch();
        if($stmt->num_rows == 1){
            $stmt->close();
            return true;
        }
        $stmt->close();
    }

    return false;
}

//Get the input request parameters
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE); //convert JSON into array


//Check for Mandatory parameters
    $username = $input['username'];
    $password = $input['password'];
    $firstName = $input['first_name'];
    $lastName = $input['last_name'];
    $email = $input['email'];
    $DoB = $input['DoB'];

    //Check if user already exist
    if(!userExists($username)){


        //Generate a unique password Hash
        $passwordHash = password_hash($password,PASSWORD_DEFAULT);

        //Query to register new user
        $insertQuery  = "INSERT INTO UserInfo(username, firstName, lastName, password, email, DoB) VALUES (?,?,?,?,?,?)";
        if($stmt = $con->prepare($insertQuery)){
            $stmt->bind_param("ssssss",$username, $firstName, $lastName, $passwordHash, $email, $DoB);
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

echo json_encode($response, JSON_FORCE_OBJECT);
?>