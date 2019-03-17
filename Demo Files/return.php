<?php
session_start();
include 'config.php';

if($_SESSION['role'] == "dev"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/devhome.php");
}else if ($_SESSION['role'] == "manager"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/managerhome.php");
}else if ($_SESSION['role'] == "field"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/field.php");
}else if ($_SESSION['role'] == "maintenance"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/maintenancehome.php");
}
?>
