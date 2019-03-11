<?php

//location for other employees


//all station locations
$query = "SELECT StationInfo.latitude, StationInfo.longitude
          FROM StationInfo";

//current unsolved user report locations
$query = "SELECT BikeInfo.latitude, BikeInfo.longitude
          FROM BikeInfo, CurrentUserReports
          WHERE BikeInfo.bikeID=CurrentUserReports.bikeID";






// for heatmaps

//current bike density at stations
$query = "SELECT BikeInfo.latitude, BikeInfo.longitude
          FROM BikeInfo, BikesAtStations
          WHERE BikeInfo.bikeID=BikesAtStations.bikeID";

//density of startStation for rides
$query = "SELECT StationInfo.latitude, StationInfo.longitude
          FROM StationInfo, FinishedRides
          WHERE FinishedRides.startStationID=StationInfo.stationID";

//density of finishStation for rides
$query = "SELECT StationInfo.latitude, StationInfo.longitude
          FROM StationInfo, FinishedRides
          WHERE FinishedRides.endStationID=StationInfo.stationID";

//Current users using bikes
$query = "SELECT BikeInfo.latitude, BikeInfo.longitude
          FROM BikeInfo, UsersUsingBikes
          WHERE BikeInfo.bikeID=UsersUsingBikes.bikeID";

//density of popular locations with high frequency of reports made
$query = "SELECT BikeInfo.latitude, BikeInfo.longitude
          FROM BikeInfo, SolvedUserReports
          WHERE BikeInfo.bikeID=SolvedUserReports.bikeID";
?>
