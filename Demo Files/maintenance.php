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
    <title>Maintenance</title>
</head>
<body>
<form method ="post" action="demo.html">
    <h1>
        Press to hide database
    </h1>
    <button type="submit">Hide</button>
</form>

<h1>Solved Reports:</h1>
<table style="border: 1px solid black; width: 100%;">
    <thead>
    <tr>
        <th>Report ID</th>
        <th>User ID</th>
        <th>Bike ID</th>
        <th>problem</th>
        <th>Latitude</th>
        <th>Longitude</th>
        <th>Staff ID</th>
        <th>Needs Maintenance</th>
    </tr>

    <?php
    $query = "SELECT * FROM SolvedUserReports WHERE needsMaintenance='yes'";
    $result = mysqli_query($dbc, $query);
    while($row = mysqli_fetch_array($result)) {
        $rows[] = $row;
    }
    foreach ($rows as $row){
        ?>
        <tr>
            <td><?php echo $row['reportID']; ?></td>
            <td><?php echo $row['userID']; ?></td>
            <td><?php echo $row['bikeID']; ?></td>
            <td><?php echo $row['problem']; ?></td>
            <td><?php echo $row['latitude']; ?></td>
            <td><?php echo $row['longitude']; ?></td>
            <td><?php echo $row['staffID']; ?></td>
            <td><?php echo $row['needsMaintenance']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>

<form action="scheduledmaintenance.php" method="post">
<h1>Schedule Maintenance:</h1><br>
Report ID: <input type="number" name="reportID"><br>
Your Staff ID: <input type="number" name="staffID"><br>
Date Scheduled: <input type="date" name="dateScheduled"><br>
Estimated Length Of Repair: <input type="time" name="estimatedLengthOfRepair"><br>
<input type="submit">
</form>

</body>
</html>
