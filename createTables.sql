DROP TABLE test;

CREATE TABLE userInfo
    --this table contains unique user login information
    userID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    username,
    firstName,
    lastName,
    passwordHash,
    salt,
    email,
    DoB
)ENGINE=INNODB;

CREATE TABLE bikeInfo (
    --this table contains all unique bike identifiers
    bikeID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    inEco bool

)ENGINE=INNODB;

CREATE TABLE managementInfo (
  --this table contains unique management login information
    staffID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    username,
    firstName,
    lastName,
    passwordHash,
    salt,
    email,
    DoB,
    jobTitle enum,
    workingHours
)ENGINE=INNODB;

CREATE TABLE stationInfo (
    --this table contains all the stations. used for mapping
    stationID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    stationName,
    latitude,
    longitude,
    addressLine1,
    addressLine2, --can be NULL
    postcode
    --example for Edinburgh is lat 55.950161, long -3.213177

)ENGINE=INNODB;

CREATE TABLE stationStatus (
  --one to one relationship with stationInfo. Therefore primary key is forgeign key
    stationID primary/forgeign, -- in reality this would be generated number not auto inc.
    maxParkingSpaces,
    availableParkingSpaces
)ENGINE=INNODB;

CREATE TABLE bikesAtStations (
    bikeID,
    stationID,
    PRIMARY KEY (bikeID, stationID),
    --forgeign keys : bike ID @ station ID
    FOREIGN KEY (bikeID) REFERENCES bikeInfo (bikeID),
    FOREIGN KEY (stationID) REFERENCES stationStatus (stationID)
)ENGINE=INNODB;

CREATE TABLE usersUsingBikes (
    --current bikes that are being used by users
    PRIMARY KEY (bikeID, userID),
    --forgeign keys : bike ID @ station ID
    FOREIGN KEY (bikeID) REFERENCES bikeInfo (bikeID),
    FOREIGN KEY (userID) REFERENCES userInfo (userID)

CREATE TABLE bikeTracking (
    --combination of bikesAtStations and usersUsingBikes
    test INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
)ENGINE=INNODB;

CREATE TABLE finishedRides (
    --old logs of all the finished rides
    rideID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    userID,
    startStationID,
    endStationID,
    rideLength,
    pricePaid
)ENGINE=INNODB;

CREATE TABLE scheduledMaintenance (
    --management scheduled maintenance
    maintenanceID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    bikeID,
    staffID, --who scheduled the maintenance
    dateScheduled,
    estimatedLengthOfRepair

)ENGINE=INNODB;

CREATE TABLE completedMaintenance (
    --old logs of all completed maintenance
    maintenanceID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    bikeID,
    staffID, --who fixed the bike
    dateScheduled,
    estimatedLengthOfRepair,
    dateOfCompletion,
    notes
)ENGINE=INNODB;

CREATE TABLE currentBookings (
    --current bookings that have not been completed yet
    bookingID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    bikeID,
    stationID,
    userID,
    timeOfBooking
)ENGINE=INNODB;

CREATE TABLE oldBookings (
    --old logs for bookings
    bookingID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.
    bikeID,
    stationID,
    userID,
    timeOfBooking,
    dateOfBooking,
    pickedUp, --bool
    extraCharge --bool
)ENGINE=INNODB;

CREATE TABLE bikeData (
    --fancy stats
    bikeID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.

)ENGINE=INNODB;

CREATE TABLE userData (
    --fancy stats
    userID INT PRIMARY KEY AUTO_INCREMENT, -- in reality this would be generated number not auto inc.

)ENGINE=INNODB;
