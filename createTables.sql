DROP TABLE OldBookings;
DROP TABLE CurrentBookings;
DROP TABLE CompletedMaintenance;
DROP TABLE ScheduledMaintenance;
DROP TABLE SolvedUserReports;
DROP TABLE CurrentUserReports;
DROP TABLE FinishedRides;
DROP TABLE UsersUsingBikes;
DROP TABLE BikesAtStations;
DROP TABLE StationStatus;
DROP TABLE StationInfo;
DROP TABLE StaffInfo;
DROP TABLE BikeInfo;
DROP TABLE UserInfo;


CREATE TABLE UserInfo(
    /*this table contains unique user login information*/
    userID INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    salt VARCHAR(45) NOT NULL,
    email VARCHAR(320) NOT NULL,
    DoB DATE NOT NULL
)ENGINE=INNODB;

CREATE TABLE BikeInfo (
    /*this table contains all unique bike identifiers*/
    bikeID INT PRIMARY KEY AUTO_INCREMENT,
    bikeName VARCHAR(15) NOT NULL,
    inEco BOOLEAN NOT NULL
)ENGINE=INNODB;

CREATE TABLE StaffInfo (
  /*this table contains unique management login information*/
    staffID INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    salt VARCHAR(45) NOT NULL,
    email VARCHAR(320) NOT NULL,
    DoB DATE NOT NULL,
    jobTitle ENUM('dev', 'maintenance', 'manager') NOT NULL
)ENGINE=INNODB;

CREATE TABLE StationInfo (
    /*this table contains all the stations. used for mapping*/
    stationID INT PRIMARY KEY AUTO_INCREMENT,
    stationName VARCHAR(50) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    addressLine1 VARCHAR(50) NOT NULL,
    addressLine2 VARCHAR(50),
    postcode VARCHAR(8) NOT NULL
    /*example for Edinburgh is lat 55.950161, long -3.213177*/
)ENGINE=INNODB;

CREATE TABLE StationStatus (
  /*one to one relationship with stationInfo. Therefore primary key is forgeign key*/
    stationID INT PRIMARY KEY,
    maxParkingSpaces INT NOT NULL,
    availableParkingSpaces INT NOT NULL,
    FOREIGN KEY (stationID) REFERENCES StationInfo (stationID)
)ENGINE=INNODB;

CREATE TABLE BikesAtStations (
    bikeID INT NOT NULL,
    stationID INT NOT NULL,
    PRIMARY KEY (bikeID, stationID),
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID),
    FOREIGN KEY (stationID) REFERENCES StationInfo (stationID)
)ENGINE=INNODB;

CREATE TABLE UsersUsingBikes (
    /*current bikes that are being used by users*/
    bikeID INT NOT NULL,
    userID INT NOT NULL,
    PRIMARY KEY (bikeID, userID),
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID),
    FOREIGN KEY (userID) REFERENCES UserInfo (userID)
)ENGINE=INNODB;

CREATE TABLE FinishedRides (
    /*old logs of all the finished rides*/
    rideID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    startStationID INT NOT NULL,
    endStationID INT NOT NULL,
    startTime DATE NOT NULL,
    endTime DATE NOT NULL,
    pricePaid INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES UserInfo (userID),
    FOREIGN KEY (startStationID) REFERENCES StationStatus (stationID),
    FOREIGN KEY (endStationID) REFERENCES StationStatus (stationID)
)ENGINE=INNODB;

CREATE TABLE CurrentUserReports(
    reportID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    bikeID INT NOT NULL,
    problem VARCHAR(300),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    FOREIGN KEY (userID) REFERENCES UserInfo (userID),
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID)
)ENGINE=INNODB;

CREATE TABLE SolvedUserReports(
    reportID INT PRIMARY KEY,
    userID INT NOT NULL,
    bikeID INT NOT NULL,
    problem VARCHAR(300),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    staffID INT NOT NULL,
    needsMaintenance ENUM('yes', 'no') NOT NULL,
    FOREIGN KEY (userID) REFERENCES UserInfo (userID),
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID),
    FOREIGN KEY (staffID) REFERENCES StaffInfo (staffID)
)ENGINE=INNODB;

CREATE TABLE ScheduledMaintenance (
    /* staff scheduled maintenance */
    maintenanceID INT AUTO_INCREMENT,
    bikeID INT NOT NULL,
    staffID INT NOT NULL,
    reportID INT NOT NULL,
    dateScheduled DATE NOT NULL,
    estimatedLengthOfRepair TIME NOT NULL,
    FOREIGN KEY (staffID) REFERENCES StaffInfo (staffID),
    FOREIGN KEY (reportID) REFERENCES SolvedUserReports (reportID),
    PRIMARY KEY (maintenanceID, reportID)
)ENGINE=INNODB;

CREATE TABLE CompletedMaintenance (
    /*old logs of all completed maintenance*/
    maintenanceID INT NOT NULL,
    bikeID INT NOT NULL,
    staffID INT NOT NULL,
    reportID INT NOT NULL,
    dateScheduled DATE NOT NULL,
    estimatedLengthOfRepair TIME NOT NULL,
    dateOfCompletion DATE NOT NULL,
    lengthOfRepair TIME NOT NULL,
    notes VARCHAR(300),
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID),
    FOREIGN KEY (staffID) REFERENCES StaffInfo (staffID),
    FOREIGN KEY (reportID) REFERENCES SolvedUserReports (reportID),
    PRIMARY KEY (maintenanceID, reportID)
)ENGINE=INNODB;

CREATE TABLE CurrentBookings (
    /*current bookings that have not been completed yet*/
    bookingID INT PRIMARY KEY AUTO_INCREMENT,
    bikeID INT NOT NULL,
    stationID INT NOT NULL,
    userID INT NOT NULL,
    timeOfBooking TIME NOT NULL,
    timeRemaining TIME NOT NULL, /* countdown  */
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID),
    FOREIGN KEY (stationID) REFERENCES StationInfo (stationID),
    FOREIGN KEY (userID) REFERENCES UserInfo (userID)
)ENGINE=INNODB;

CREATE TABLE OldBookings (
    /*old logs for bookings*/
    bookingID INT PRIMARY KEY,
    bikeID INT NOT NULL,
    stationID INT NOT NULL,
    userID INT NOT NULL,
    timeOfBooking TIME NOT NULL,
    dateOfBooking DATE NOT NULL,
    pickedUp BOOLEAN,
    extraCharge BOOLEAN,
    FOREIGN KEY (bikeID) REFERENCES BikeInfo (bikeID),
    FOREIGN KEY (stationID) REFERENCES StationInfo (stationID),
    FOREIGN KEY (userID) REFERENCES UserInfo (userID)
)ENGINE=INNODB;
