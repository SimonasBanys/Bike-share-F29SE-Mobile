<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "dev" && $_SESSION['role'] != "manager" && $_SESSION['role'] != "field"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
$staffID = $_SESSION['staffID'];
?>

<html lang="en">
<head>
    <title>Station Info</title>
</head>
<body>
<button onclick="history.go(-1);">Back</button>

<h1>All Stations:</h1>
<table style="border: 1px solid black; width: 100%;">
    <thead>
    <tr>
        <th>Station ID</th>
        <th>Latitude</th>
        <th>Longitude</th>
        <th>Address Line 1</th>
        <th>Address Line 2</th>
        <th>Postcode</th>
    </tr>

    <?php
    $query = "SELECT * FROM StationInfo";
    $result = mysqli_query($dbc, $query);
    while($row = mysqli_fetch_array($result)) {
        $rows[] = $row;
    }
    foreach ($rows as $row){
        ?>
        <tr>
            <td><?php echo $row['stationID']; ?></td>
            <td><?php echo $row['latitude']; ?></td>
            <td><?php echo $row['longitude']; ?></td>
            <td><?php echo $row['addressLine1']; ?></td>
            <td><?php echo $row['addressLine2']; ?></td>
            <td><?php echo $row['postcode']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>
</body>
</html>
