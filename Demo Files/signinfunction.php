<?php
session_start();
include 'config.php';

$rawusername = $_POST[username];
$username = sprintf('"%s"', $rawusername);
$password = $_POST[password];

$query="SELECT password FROM StaffInfo
        WHERE $username=StaffInfo.username";

$result = mysqli_query($dbc, $query);

while($row = mysqli_fetch_assoc($result))
{
   $hash = $row["password"];
}

if (password_verify($password, $hash)) {

  $query2="SELECT staffID, jobTitle FROM StaffInfo
           WHERE $username=StaffInfo.username";

  $result = mysqli_query($dbc, $query2);
  while($row = mysqli_fetch_assoc($result))
  {
    $id = $row["staffID"];
    $role = $row["jobTitle"];
  }

  $_SESSION['staffID'] = $id;
  $_SESSION['role'] = $role;
  $_SESSION['username'] = $rawusername;

  if($role == "dev"){
    header("Location: http://www2.macs.hw.ac.uk/~rh49/devhome.php");
  }else if($role == "manager"){
    header("Location: http://www2.macs.hw.ac.uk/~rh49/managerhome.php");
  }else if($role == "field"){
    header("Location: http://www2.macs.hw.ac.uk/~rh49/fieldhome.php");
  }else if($role == "maintenance"){
    header("Location: http://www2.macs.hw.ac.uk/~rh49/maintenancehome.php");
  }else{
    header("Location: http://www2.macs.hw.ac.uk/~rh49/demo.html");
  }

}
else {
  echo "ERROR: Wrong password...redirecting now...";
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
?>
