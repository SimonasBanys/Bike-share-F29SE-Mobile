<?php
session_start();
include 'config.php';

if($_SESSION['role'] != "dev" && $_SESSION['role'] != "manager"){
  header("Location: http://www2.macs.hw.ac.uk/~rh49/basicsignin.php");
}
?>

<html lang="en">
<head>
    <title>Management Maps</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCuEiVislCWsfs4M5xkWJ8H1zksQmYuA9M&libraries=visualization">
    </script>
</head>
<style>
html, body, #map-canvas {
    height: 100%;
    width: 100%;
    margin: 0px;
    padding: 0px;
}
</style>
<body>
  <form action="return.php" method="post">
      <button type="submit">Back</button>
  </form>

<h1>Maps: Density of startStation for rides</h1>

<div class="btn-group">
  <form method ="post" action="maps.php">
  <button type="submit">Current bike denisty at stations</button>
  </form>
  <form method ="post" action="map2.php">
  <button type="submit">Density of startStation for rides</button>
  </form>
  <form method ="post" action="map3.php">
  <button type="submit">Density of finishStation for rides</button>
  </form>
  <form method ="post" action="map4.php">
  <button type="submit">Current users using bikes</button>
  </form>
  <form method ="post" action="map5.php">
  <button type="submit">Density of popular locations with high frequency of reports made</button>
  </form>
</div>

<div id="map-canvas" style="border: 2px solid #3872ac;"></div>

<table style="border: 1px solid black; width: 100%;">
    <thead>
    <tr>
        <th>Station ID</th>
        <th>Number of Bikes Starting at that Station</th>
    </tr>

    <?php
    $query = "SELECT startStationID, COUNT(*) AS `Number of Bikes` FROM `FinishedRides` GROUP BY startStationID";
    $result = mysqli_query($dbc, $query);
    while($row = mysqli_fetch_array($result)) {
        $rows[] = $row;
    }
    foreach ($rows as $row){
        ?>
        <tr>
            <td><?php echo $row['startStationID']; ?></td>
            <td><?php echo $row['Number of Bikes']; ?></td>
        </tr>
        <?php
    }
    ?>
    </thead>

</table>

<script>
<?php
    $query = "SELECT StationInfo.latitude, StationInfo.longitude
              FROM StationInfo, FinishedRides
              WHERE FinishedRides.startStationID=StationInfo.stationID";
  $result = mysqli_query($dbc, $query);
  while($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
  }
  $data_json = json_encode($data, JSON_NUMERIC_CHECK);
?>

$(document).ready(function() {
  var map, pointarray, heatmap;

  function createMap() {
    var mapOptions = {
        zoom: 16,
        center: new google.maps.LatLng(55.953252, -3.188267),
        mapTypeId: google.maps.MapTypeId.SATELLITE
    };

    map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
    createHeatmap();
  }

  function createHeatmap(){
    heatmap = new google.maps.visualization.HeatmapLayer({
      data: [],
      radius: 150,
      dissipating: true,
      maxIntensity: 40
    });

    heatmap.setMap(map);
    heatmap.setMap(null);
    var jsonArray = [];
    var data = <?php echo $data_json; ?>;

    $.each(data, function (i, jsondata) {
      var jsonObject = {};
      jsonObject.latitude = jsondata.latitude;
      jsonObject.longitude = jsondata.longitude;
      jsonArray.push(new google.maps.LatLng(jsonObject.latitude,jsonObject.longitude));
      var marker = new google.maps.Marker({
        position: {lat: jsonObject.latitude, lng: jsonObject.longitude},
        map: map
      });
    });
    var pointArray = new google.maps.MVCArray(jsonArray);
    heatmap.setData(pointArray);
    heatmap.setMap(map);
  }

  google.maps.event.addDomListener(window, 'load', createMap);
});
</script>

</body>
</html>
