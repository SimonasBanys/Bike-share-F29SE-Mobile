<html>
<body>
<h1>Creating staff account...</h1>

<?php
include 'config.php';

$username = $_POST[username];
$firstName = $_POST[firstName];
$lastName = $_POST[lastName];
$password = $_POST[password];
$hashed_password = password_hash($password, PASSWORD_DEFAULT);
$email = $_POST[email];
$DoB = $_POST[DoB];
$jobTitle = $_POST[jobTitle];


$query="INSERT INTO StaffInfo
(username, firstName, lastName, password, email, DoB, jobTitle)
VALUES ('$username','$firstName','$lastName','$hashed_password','$email','$DoB','$jobTitle')";

if(mysqli_query($dbc, $query)){

    echo "Account created<br>";

}else{
    echo "ERROR:" . mysqli_error($dbc);
}


?>
<form method ="post" action="staffcreate.php">
    <h1>
        Press to go back
    </h1>
    <button type="submit">BACK</button>
</form>
</body>
</html>
