<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "dev" && $_SESSION['role'] != "manager" && $_SESSION['role'] != "maintenance"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
$staffID = $_SESSION['staffID'];
?>
<html lang="en">
<head>
    <title>All Scheduled Maintenance</title>
</head>
<body>
<button onclick="history.go(-1);">Back</button>

<h1>Scheduled Maintenance:</h1>
<table style="border: 1px solid black; width: 100%;">
    <thead>
    <tr>
        <th>Maintenance ID</th>
        <th>Bike ID</th>
        <th>Staff ID</th>
        <th>Report ID</th>
        <th>Date Scheduled</th>
        <th>Estimated Length Of Repair</th>
    </tr>

    <?php
    $query = "SELECT * FROM ScheduledMaintenance";
    $result = mysqli_query($dbc, $query);
    while($row = mysqli_fetch_array($result)) {
        $rows[] = $row;
    }
    foreach ($rows as $row){
        ?>
        <tr>
            <td><?php echo $row['maintenanceID']; ?></td>
            <td><?php echo $row['bikeID']; ?></td>
            <td><?php echo $row['staffID']; ?></td>
            <td><?php echo $row['reportID']; ?></td>
            <td><?php echo $row['dateScheduled']; ?></td>
            <td><?php echo $row['estimatedLengthOfRepair']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>

<form action="actionmaintenance.php" method="post">
<h1>Complete Maintenance:</h1><br>
Maintenance ID: <input type="number" name="maintenanceID"><br>
Your Staff ID: <input type="number" name="staffID" value="<?php echo htmlspecialchars($staffID); ?>" readonly><br>
Date of Completion: <input type="date" name="dateOfCompletion"><br>
Length of Repair: <input type="time" name="lengthOfRepair"><br>
Notes: <input type="text" name="notes"><br>
<input type="submit">
</form>

</body>
</html>
