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
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
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
    startTime DATETIME NOT NULL,
    endTime DATETIME NOT NULL,
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



/* welcome to the random generated part of this document, good luck
   after this there is manually entered data which is formatted nicer */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rochette', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Chucho', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Yuri', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jazmin', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hinze', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Merlina', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Erica', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mallissa', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Kimberley', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pedro', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Elaina', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cullan', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jenelle', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vyky', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Davide', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fidelia', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vi', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Carrol', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jereme', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lucho', 55.95201117, -3.18945461, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Corbett', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Isak', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Massimo', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Eve', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Karine', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stanislas', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ericka', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ashlie', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tedi', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Maggy', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Denys', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Carissa', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vladamir', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Michele', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sibylla', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ashlie', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Piggy', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cullin', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pippo', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hyacintha', 55.95445231, -3.19302891, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Adriana', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Roxanna', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Remy', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Yolanthe', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Leandra', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Orella', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ilise', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Janey', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gun', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Selig', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Charmaine', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Maye', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Merci', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ava', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Welch', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Connie', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Oliviero', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cecile', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Homerus', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Arni', 55.95172524, -3.19575404, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Melisenda', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Clarance', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Monroe', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hope', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Marlowe', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Issy', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Timmie', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Alfreda', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bordy', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Clayson', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tarrance', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pepi', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gabrielle', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Paten', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Carroll', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Talbot', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rosette', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Estelle', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ettie', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ranice', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mimi', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mabelle', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Johnnie', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rich', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Malorie', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Egbert', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rick', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tamar', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rockey', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fernande', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Helaine', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hunter', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Valentia', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lorens', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Christel', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jasper', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Becky', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cord', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ev', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jsandye', 55.95143029, -3.18227279, 1);




/* manual data entry */

  INSERT INTO UserInfo (username, firstName, lastName, password, salt, email, DoB)
  VALUES
  ('FirstUser', 'Regan', 'Hay', 'hash', 'salt', 'rh49@hw.ac.uk', '1998-11-29');

  INSERT INTO StaffInfo (username, firstName, lastName, password, salt, email, DoB, jobTitle)
  VALUES
  ('admin', 'Admin', 'Istrator', 'hash', 'salt', 'SkedaddlAdmin@gmail.com', '2019-02-28', 'manager');

  INSERT INTO StationInfo (stationName, latitude, longitude, addressLine1, addressLine2, postcode)
  VALUES
  ('Waverley Station', '55.95201117', '-3.18945461', 'Edinburgh Waverley', 'Edinburgh', 'EH1 1BB'),
  ('St Andrew Square', '55.95445231', '-3.19302891', '42 St Andrew Square', 'Edinburgh', 'EH2 2AD'),
  ('The Mound', '55.95172524', '-3.19575404', 'The Mound', 'Edinburgh', 'EH2 2HG'),
  ('St Giles Cathedral', '55.94949298', '-3.19018782', '1 Parliament Square', 'Edinburgh', 'EH1 1RF'),
  ('Sibbald Walk', '55.95143029', '-3.18227279', '231 Canongate', 'Edinburgh', 'EH8 8DQ');

  INSERT INTO StationStatus (stationID, maxParkingSpaces, availableParkingSpaces)
  VALUES
  ('1', '20', '0'),
  ('2', '20', '0'),
  ('3', '20', '0'),
  ('4', '20', '0'),
  ('5', '20', '0');

  INSERT INTO BikesAtStations (bikeID, stationID)
  VALUES
  ('1', '1'),
  ('2', '1'),
  ('3', '1'),
  ('4', '1'),
  ('5', '1'),
  ('6', '1'),
  ('7', '1'),
  ('8', '1'),
  ('9', '1'),
  ('10', '1'),
  ('11', '1'),
  ('12', '1'),
  ('13', '1'),
  ('14', '1'),
  ('15', '1'),
  ('16', '1'),
  ('17', '1'),
  ('18', '1'),
  ('19', '1'),
  ('20', '1'),
  ('21', '2'),
  ('22', '2'),
  ('23', '2'),
  ('24', '2'),
  ('25', '2'),
  ('26', '2'),
  ('27', '2'),
  ('28', '2'),
  ('29', '2'),
  ('30', '2'),
  ('31', '2'),
  ('32', '2'),
  ('33', '2'),
  ('34', '2'),
  ('35', '2'),
  ('36', '2'),
  ('37', '2'),
  ('38', '2'),
  ('39', '2'),
  ('40', '2'),
  ('41', '3'),
  ('42', '3'),
  ('43', '3'),
  ('44', '3'),
  ('45', '3'),
  ('46', '3'),
  ('47', '3'),
  ('48', '3'),
  ('49', '3'),
  ('50', '3'),
  ('51', '3'),
  ('52', '3'),
  ('53', '3'),
  ('54', '3'),
  ('55', '3'),
  ('56', '3'),
  ('57', '3'),
  ('58', '3'),
  ('59', '3'),
  ('60', '3'),
  ('61', '4'),
  ('62', '4'),
  ('63', '4'),
  ('64', '4'),
  ('65', '4'),
  ('66', '4'),
  ('67', '4'),
  ('68', '4'),
  ('69', '4'),
  ('70', '4'),
  ('71', '4'),
  ('72', '4'),
  ('73', '4'),
  ('74', '4'),
  ('75', '4'),
  ('76', '4'),
  ('77', '4'),
  ('78', '4'),
  ('79', '4'),
  ('80', '4'),
  ('81', '5'),
  ('82', '5'),
  ('83', '5'),
  ('84', '5'),
  ('85', '5'),
  ('86', '5'),
  ('87', '5'),
  ('88', '5'),
  ('89', '5'),
  ('90', '5'),
  ('91', '5'),
  ('92', '5'),
  ('93', '5'),
  ('94', '5'),
  ('95', '5'),
  ('96', '5'),
  ('97', '5'),
  ('98', '5'),
  ('99', '5'),
  ('100', '5');

/*
  INSERT INTO UsersUsingBikes (bikeID, userID)
  VALUES
  ('2', '1');
*/

  INSERT INTO FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid)
  VALUES
  ('1', '1', '3', '2019-02-28 10:20:32', '2019-02-28 10:36:48', '2');
