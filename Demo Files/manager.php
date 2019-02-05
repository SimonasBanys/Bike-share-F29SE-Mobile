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
            <td><?php echo $row['dateOfCompletion']; ?></td>
            <td><?php echo $row['lengthOfRepair']; ?></td>
            <td><?php echo $row['notes']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>

</body>
</html>
