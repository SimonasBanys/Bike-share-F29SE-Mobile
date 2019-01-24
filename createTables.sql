DROP TABLE test;

CREATE TABLE userInfo
    --this table contains unique user login information
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE bikeInfo (
    --this table contains all unique bike identifiers
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE managementInfo (
  --this table contains unique management login information
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE stationInfo (
    --this table contains all the stations. used for mapping
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE bikesAtStations (
    --forgeign keys : bike ID @ station ID
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE usersUsingBikes (
    --current bikes that are being used by users
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE bikeTracking (
    --combination of bikesAtStatiosn and usersUsingBikes
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE finishedRides (
    --old logs of all the finished rides
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE scheduledMaintenance (
    --management scheduled maintenance
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE completedMaintenance (
    --old logs of all completed maintenance
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE currentBookings (
    --current bookings that have not been completed yet
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE oldBookings (
    --old logs for bookings
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE bikeData (
    --fancy stats
    test INT PRIMARY KEY AUTO_INCREMENT -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;
