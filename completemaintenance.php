<?php
DEFINE ('DB_HOST', 'mysql-server-1.macs.hw.ac.uk');
DEFINE ('DB_USER', 'rh49');
DEFINE ('DB_PASSWORD', 'e8FpS0qItsvAFLz4');
DEFINE ('DB_NAME', 'rh49');

$dbc = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
OR die('Could not connect to MySQL Database: ' . mysqli_connect_error());
?>
<html lang="en">
<head>
    <title>All Scheduled Maintenance</title>
</head>
<body>
<form method ="post" action="demo.html">
    <h1>
        Press to hide database
    </h1>
    <button type="submit">Hide</button>
</form>

<h1>Reports:</h1>
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
<h1>Schedule Maintenance:</h1><br>
Maintenance ID: <input type="number" name="maintenanceID"><br>
Your Staff ID: <input type="number" name="staffID"><br>
Date of Completion: <input type="date" name="dateOfCompletion"><br>
Length of Repair: <input type="time" name="lengthOfRepair"><br>
Notes: <input type="text" name="notes"><br>
<input type="submit">
</form>

</body>
</html>
