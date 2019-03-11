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
    <title>Management Maps</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCuEiVislCWsfs4M5xkWJ8H1zksQmYuA9M&callback=initMap">
    </script>
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
<form method ="post" action="demo.html">
    <h1>
        Press to hide maps
    </h1>
    <button type="submit">Hide</button>
</form>

<h1>Maps:</h1>

<?php
  $query = "SELECT StationInfo.latitude, StationInfo.longitude
            FROM StationInfo";
  $result = mysqli_query($dbc, $query);
  while($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
  }
  $data_json = json_encode($data, JSON_NUMERIC_CHECK);
?>

<div id="map-canvas" style="border: 2px solid #3872ac;"></div>

<script>
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
      data: []
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
