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
    <title>Reports</title>
</head>
<body>
<button onclick="history.go(-1);">Back</button>

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

<form action="solvereport.php" method="post">
<h1>Solve Report:</h1><br>
Report ID: <input type="number" name="reportID"><br>
Your Staff ID: <input type="number" name="staffID" value="<?php echo htmlspecialchars($staffID); ?>" readonly><br>
Does this need maintenance?:<br>
Yes <input type="radio" name="needsMaintenance" value="yes"><br>
No <input type="radio" name="needsMaintenance" value="no"><br>
<input type="submit">
</form>

</body>
</html>
