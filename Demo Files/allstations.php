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
    <title>Station Info</title>
</head>
<body>
<form method ="post" action="demo.html">
    <h1>
        Press to hide database
    </h1>
    <button type="submit">Hide</button>
</form>

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
