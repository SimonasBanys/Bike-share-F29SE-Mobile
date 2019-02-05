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
    <title>Completed Maintenance</title>
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
        <th>Report ID</th>
        <th>User ID</th>
        <th>Bike ID</th>
        <th>Problem</th>
        <th>Latitude</th>
        <th>Longitude</th>
    </tr>

    <?php
    $query = "SELECT * FROM CurrentUserReports";
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
        </tr>
        <?php
    }
    ?>
    </thead>

</table>


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
    while($row1 = mysqli_fetch_array($result)) {
        $rows1[] = $row1;
    }
    foreach ($rows1 as $row1){
        ?>
        <tr>
            <td><?php echo $row1['reportID']; ?></td>
            <td><?php echo $row1['userID']; ?></td>
            <td><?php echo $row1['bikeID']; ?></td>
            <td><?php echo $row1['problem']; ?></td>
            <td><?php echo $row1['latitude']; ?></td>
            <td><?php echo $row1['longitude']; ?></td>
            <td><?php echo $row1['staffID']; ?></td>
            <td><?php echo $row1['needsMaintenance']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>


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
    while($row2 = mysqli_fetch_array($result)) {
        $rows2[] = $row2;
    }
    foreach ($rows2 as $row2){
        ?>
        <tr>
            <td><?php echo $row2['maintenanceID']; ?></td>
            <td><?php echo $row2['bikeID']; ?></td>
            <td><?php echo $row2['staffID']; ?></td>
            <td><?php echo $row2['reportID']; ?></td>
            <td><?php echo $row2['dateScheduled']; ?></td>
            <td><?php echo $row2['estimatedLengthOfRepair']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>

<h1>Completed Maintenance:</h1>
<table style="border: 1px solid black; width: 100%;">
    <thead>
    <tr>
        <th>Maintenance ID</th>
        <th>Bike ID</th>
        <th>Staff ID</th>
        <th>Report ID</th>
        <th>Date Scheduled</th>
        <th>Estimated Length Of Repair</th>
        <th>Date of Completion</th>
        <th>Length of Repair</th>
        <th>Notes</th>
    </tr>

    <?php
    $query = "SELECT * FROM CompletedMaintenance";
    $result = mysqli_query($dbc, $query);
    while($row3 = mysqli_fetch_array($result)) {
        $rows3[] = $row3;
    }
    foreach ($rows3 as $row3){
        ?>
        <tr>
            <td><?php echo $row3['maintenanceID']; ?></td>
            <td><?php echo $row3['bikeID']; ?></td>
            <td><?php echo $row3['staffID']; ?></td>
            <td><?php echo $row3['reportID']; ?></td>
            <td><?php echo $row3['dateScheduled']; ?></td>
            <td><?php echo $row3['estimatedLengthOfRepair']; ?></td>
            <td><?php echo $row3['dateOfCompletion']; ?></td>
            <td><?php echo $row3['lengthOfRepair']; ?></td>
            <td><?php echo $row3['notes']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>

</body>
</html>
