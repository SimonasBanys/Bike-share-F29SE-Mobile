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
    password VARCHAR(256) NOT NULL,
    email VARCHAR(320) NOT NULL,
    DoB DATE NOT NULL,
    UNIQUE (username),
    UNIQUE (email)
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
    password VARCHAR(256) NOT NULL,
    email VARCHAR(320) NOT NULL,
    DoB DATE NOT NULL,
    UNIQUE (username),
    UNIQUE (email),
    jobTitle ENUM('dev', 'maintenance', 'field', 'manager') NOT NULL
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

/* bikes at station 1 */
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

/* bikes at station 2 */
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

/* bikes at station 3 */
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

/* bikes at station 4 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Elaina', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cullan', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jenelle', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vyky', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Davide', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fidelia', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vi', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Carrol', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jereme', 55.94949298, -3.19018782, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lucho', 55.94949298, -3.19018782, 1);

/* bikes at station 5 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Denys', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Carissa', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vladamir', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Michele', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sibylla', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ashlie', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Piggy', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cullin', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pippo', 55.95143029, -3.18227279, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hyacintha', 55.95143029, -3.18227279, 1);

/* bikes at station 6 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tin', 55.95151, -3.206838, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sonair', 55.95151, -3.206838, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bigtax', 55.95151, -3.206838, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Daltfresher', 55.95151, -3.206838, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Prodder', 55.95151, -3.206838, 1);

/* bikes at station 7 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Opela', 55.94787, -3.194798, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Aerified', 55.94787, -3.194798, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vagram', 55.94787, -3.194798, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Domainer', 55.94787, -3.194798, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stim', 55.94787, -3.194798, 1);

/* bikes at station 8*/
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Quo Lux', 55.945591, -3.189415, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Veribet', 55.945591, -3.189415, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Y-Solowarm', 55.945591, -3.189415, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Opelad', 55.945591, -3.189415, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Zathin', 55.945591, -3.189415, 1);
/* bikes at station 9 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ventosanzap', 55.944806, -3.19746, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sub-Ex', 55.944806, -3.19746, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Daltfresh', 55.944806, -3.19746, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Voltsillam', 55.944806, -3.19746, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Dalt', 55.944806, -3.19746, 1);

/* bikes at station 10 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sonsing', 55.947412, -3.205632, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fixflex', 55.947412, -3.205632, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('It', 55.947412, -3.205632, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bitchip', 55.947412, -3.205632, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cardguard', 55.947412, -3.205632, 1);

/* bikes at station 11 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Flexidy', 55.951191, -3.174957, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Y-find', 55.951191, -3.174957, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Span', 55.951191, -3.174957, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Voyatouch', 55.951191, -3.174957, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Zamit', 55.951191, -3.174957, 1);
/* bikes at station 12 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Zinc', 55.953893, -3.184029, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Toughjoyfax', 55.953893, -3.184029, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Zaam-Dox', 55.953893, -3.184029, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Duobam', 55.953893, -3.184029, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Zontrax', 55.953893, -3.184029, 1);

/* bikes at station 13 */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Smallflowered Woodrush', 55.956706, -3.185885, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Canada Germander', 55.956706, -3.185885, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Santee Azalea', 55.956706, -3.185885, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Margarett''s Clearweed', 55.956706, -3.185885, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Coastal Searocket', 55.956706, -3.185885, 1);


  /* bikes being used  small radius*/
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Nat', 55.951170266, -3.198329128, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jennine', 55.944018358, -3.191472632, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Charmain', 55.952148667, -3.187627807, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Carmelita', 55.944751142, -3.209016084, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Glennis', 55.944908314, -3.189085191, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Malinda', 55.944218223, -3.207413769, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Maxim', 55.939761814, -3.178578782, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Briano', 55.948391592, -3.194910654, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Starlin', 55.946516338, -3.17683438, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ingram', 55.949047972, -3.199509094, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Willie', 55.949616595, -3.20751004, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fredrika', 55.954242766, -3.187295686, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Nettle', 55.940868991, -3.207703273, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Aila', 55.94363372, -3.20899362, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Malvina', 55.952849123, -3.181419751, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Alasteir', 55.943774256, -3.204744366, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Orland', 55.944246276, -3.188869101, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pietra', 55.943152299, -3.194762679, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Willetta', 55.940924208, -3.17406164, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Borg', 55.954569285, -3.207630857, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Kerianne', 55.94557663, -3.187777481, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Angelle', 55.955865253, -3.21045824, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lizette', 55.954691171, -3.204177217, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Meier', 55.954103712, -3.183108904, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Edy', 55.941641122, -3.19664906, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stinky', 55.950601683, -3.191386078, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bernice', 55.954331674, -3.185476385, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Nathanael', 55.940105723, -3.203366817, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ernesta', 55.957857684, -3.199692377, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Crin', 55.956299515, -3.179422332, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Erastus', 55.945351799, -3.204978157, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Inga', 55.956971874, -3.188539871, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Roy', 55.952190604, -3.190813133, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Amye', 55.942598302, -3.199051952, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Heida', 55.943865694, -3.187852897, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ingar', 55.950766826, -3.180222536, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Grange', 55.953990163, -3.175723728, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Karlen', 55.944528952, -3.182614058, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ashly', 55.949809649, -3.201224271, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Norene', 55.94863064, -3.207115613, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Catina', 55.950636464, -3.194879662, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ronna', 55.946406104, -3.196983031, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vonny', 55.944394411, -3.196152639, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Brig', 55.939992339, -3.173857096, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bernadina', 55.940303562, -3.190117, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Robbert', 55.949871901, -3.176167509, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tallou', 55.946553908, -3.187223531, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Brenda', 55.946835616, -3.203194299, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Wilbert', 55.940582421, -3.177101832, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tedd', 55.958185537, -3.196549177, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Dorisa', 55.946198746, -3.189841351, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Debora', 55.947841993, -3.187547816, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Saunders', 55.957416744, -3.172394802, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tyrus', 55.950066318, -3.199546254, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Darrell', 55.944099649, -3.20275275, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Vladimir', 55.957152305, -3.204668142, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stinky', 55.946762727, -3.200569827, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cayla', 55.944102269, -3.193374474, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fara', 55.954427914, -3.171523393, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Salvatore', 55.939985941, -3.186919425, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Wesley', 55.958203367, -3.197040986, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Joseph', 55.941665791, -3.178249045, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Towney', 55.954321564, -3.200838399, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sile', 55.953350212, -3.198790643, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Eada', 55.941708873, -3.184594575, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Helene', 55.949494946, -3.175491779, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Windy', 55.952345706, -3.208764451, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Theda', 55.953635289, -3.196607125, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Dick', 55.947590566, -3.203069296, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Amabel', 55.956599956, -3.195776097, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Odille', 55.943190479, -3.182172927, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Nevile', 55.949656932, -3.202434271, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hermon', 55.939859046, -3.202049365, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Brantley', 55.958630876, -3.209286224, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lianne', 55.944625614, -3.197708409, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stirling', 55.951090837, -3.201139286, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Raychel', 55.959364002, -3.182196055, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jennee', 55.947486493, -3.209699039, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Michaella', 55.949378318, -3.183179946, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Marten', 55.951456584, -3.204088237, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Augy', 55.952578544, -3.172542373, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rooney', 55.944047366, -3.190349362, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Billye', 55.941984282, -3.187880504, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Charmine', 55.957969401, -3.186011835, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pembroke', 55.940043861, -3.176518757, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Deanna', 55.957485047, -3.182954219, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Launce', 55.953329086, -3.209311768, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ambros', 55.958187191, -3.208094269, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rutherford', 55.958364533, -3.171702596, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Emmett', 55.947390794, -3.173462919, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Delinda', 55.945843794, -3.188510372, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Verne', 55.949724539, -3.185620957, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Dex', 55.951646503, -3.171636899, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lemmy', 55.947840074, -3.190098442, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cathe', 55.95649337, -3.183637116, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Darby', 55.947064154, -3.202201344, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Wadsworth', 55.952777573, -3.200611576, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tamas', 55.946748371, -3.198768985, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Verena', 55.949639777, -3.19857413, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Naomi', 55.952731073, -3.209308993, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Abbie', 55.948713205, -3.205257269, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Purcell', 55.957293904, -3.189923015, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Klement', 55.955800876, -3.172327107, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Luciano', 55.948320149, -3.181083439, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ilaire', 55.959110105, -3.187583667, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ester', 55.945225845, -3.1903252, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Leicester', 55.939868455, -3.209958644, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Worth', 55.942240192, -3.204133443, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Kirbie', 55.949141363, -3.189499579, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Abbey', 55.945597237, -3.178241142, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rosalyn', 55.952924913, -3.208286386, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Marnia', 55.951624744, -3.178623394, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lazar', 55.957033558, -3.197354566, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fredrika', 55.9404992, -3.201330033, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Davita', 55.941599762, -3.202943601, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gerhardine', 55.946805333, -3.177338062, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Leese', 55.954455169, -3.194652753, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Shelba', 55.943798987, -3.187323449, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lyndel', 55.946943111, -3.187040265, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cesar', 55.951974069, -3.206329017, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sandy', 55.949030228, -3.190169534, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lola', 55.95701633, -3.193529805, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Chlo', 55.95237949, -3.188107447, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mirna', 55.943805062, -3.200406513, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lillis', 55.944352942, -3.195722059, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mischa', 55.954555838, -3.207891204, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mariya', 55.940981887, -3.202104531, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ludwig', 55.959201446, -3.180576507, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Raquel', 55.948802264, -3.182247423, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Henryetta', 55.956647918, -3.173470054, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Micaela', 55.949487588, -3.206935097, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ninon', 55.943725983, -3.185115694, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Diane-marie', 55.948218536, -3.177106045, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lisa', 55.955868565, -3.189093364, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jules', 55.950771376, -3.200389109, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Kiley', 55.956354139, -3.183210617, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Lucine', 55.948720034, -3.184332929, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Raimund', 55.947536137, -3.179771133, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Derick', 55.952378243, -3.173074734, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Chrissy', 55.947949591, -3.204237323, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gerardo', 55.949192239, -3.205398198, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Miguel', 55.940329115, -3.196353677, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Melony', 55.958998954, -3.20057093, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Kendal', 55.95455343, -3.190068639, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Merla', 55.958420892, -3.191521087, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jessamyn', 55.951669124, -3.193350087, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Annmaria', 55.948003972, -3.186188188, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fairlie', 55.954992723, -3.183201148, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Laurene', 55.956350619, -3.189335769, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Neal', 55.940155079, -3.177626622, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Thatch', 55.945026839, -3.206986329, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ysabel', 55.941129916, -3.173083234, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mannie', 55.946095212, -3.199331636, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ardella', 55.94127601, -3.180010942, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gilli', 55.953195929, -3.195625408, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Scott', 55.94806884, -3.206351084, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Avictor', 55.955470141, -3.207821118, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Micah', 55.942926175, -3.173163538, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mavra', 55.957985372, -3.20921349, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Shandie', 55.951983489, -3.208156503, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Yancey', 55.950691691, -3.200715842, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Brew', 55.948876555, -3.187585957, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Valene', 55.95449231, -3.199610739, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tabb', 55.953441258, -3.205989306, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gilbertina', 55.951437853, -3.206585158, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Gerrie', 55.943471524, -3.209052037, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Noe', 55.950374998, -3.188297212, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Beaufort', 55.957358348, -3.201366908, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Joice', 55.941195928, -3.197111757, 1);
  insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Townsend', 55.956423563, -3.18985311, 1);



/* user info */

insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('duplicated', 'Early', 'Jozaitis', 'YOFpZyb1ilW', 'ejozewfaitis0@nih.gov', '1943-09-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('wloades1', 'Ward', 'Loades', 'VDGrtx', 'wloades1@blogspot.com', '1965-02-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jszymonwicz2', 'Jan', 'Szymonwicz', 'pCA3NJ2', 'jszymonwicz2@shutterfly.com', '1925-09-18');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('zmucillo3', 'Zebulon', 'Mucillo', 'xmGJH66N', 'zmucillo3@sbwire.com', '1979-06-30');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dochterlony4', 'Demetri', 'Ochterlony', 'sG4evKw', 'dochterlony4@dot.gov', '1940-03-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('fleger5', 'Ferrel', 'Leger', 'iL58AsBQxJ', 'fleger5@skype.com', '1989-07-24');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gjepp6', 'Gilbert', 'Jepp', 't1UbCE', 'gjepp6@ted.com', '1951-06-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ghuffy7', 'Gottfried', 'Huffy', 'PXv8x7Hvx9', 'ghuffy7@prweb.com', '1936-02-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('njodrellec8', 'Nanice', 'Jodrellec', 'RLP1mdW', 'njodrellec8@ibm.com', '1930-01-24');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('kgunthorp9', 'Kathie', 'Gunthorp', 'ZmVF33FMkBR', 'kgunthorp9@tamu.edu', '1943-03-16');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hthridgoulda', 'Hilly', 'Thridgould', 'R7xKgn3btE', 'hthridgoulda@si.edu', '1923-03-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ialthorpb', 'Iosep', 'Althorp', 'b4fbf1', 'ialthorpb@jiathis.com', '1953-05-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hkezorc', 'Holli', 'Kezor', 'JjuHwl0J45Y', 'hkezorc@google.com.hk', '1965-05-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mmateud', 'Marjy', 'Mateu', 'DrIwx77', 'mmateud@xing.com', '1948-04-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jdimblebeee', 'Jeremiah', 'Dimblebee', '4PpbYXMWiZ4e', 'jdimblebeee@linkedin.com', '1978-01-17');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mcoppockf', 'Muriel', 'Coppock.', 'kkzD1WzOSh', 'mcoppockf@sina.com.cn', '1941-09-05');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('clettsong', 'Chelsy', 'Lettson', 'M8GtHCDPr', 'clettsong@parallels.com', '1993-04-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('amaccarlichh', 'Anthiathia', 'MacCarlich', 'lvarCmHiR9j', 'amaccarlichh@last.fm', '1936-11-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jmedcalfei', 'Joseph', 'Medcalfe', 'qq5UDuT7UOb', 'jmedcalfei@usatoday.com', '1954-01-31');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cgetcliffej', 'Christina', 'Getcliffe', 'xbQ8B1wcpez', 'cgetcliffej@github.io', '1927-12-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cgrunderk', 'Cly', 'Grunder', 'p96JOQt5e', 'cgrunderk@time.com', '1957-12-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('kdaintierl', 'Katherine', 'Daintier', '00qTfoI', 'kdaintierl@icio.us', '1993-10-26');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('slathem', 'Stefan', 'Lathe', 'DoCr4Ag', 'slathem@arstechnica.com', '1976-02-22');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vmckien', 'Vinni', 'McKie', 'SjfUHbcmAYnq', 'vmckien@seesaa.net', '1954-10-24');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ccreffeildo', 'Codi', 'Creffeild', 'NTkZiPhv9', 'ccreffeildo@upenn.edu', '1956-10-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mschulzep', 'Maribeth', 'Schulze', 'cxzSLAojTpW', 'mschulzep@state.tx.us', '1977-03-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('wwordleyq', 'Wilhelm', 'Wordley', 'O9TuSTg27xci', 'wwordleyq@blogspot.com', '1985-07-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jzamorar', 'Jillian', 'Zamora', 'mq3nwa', 'jzamorar@fotki.com', '1985-03-26');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ttintons', 'Tracee', 'Tinton', 'r3FCYBFa', 'ttintons@nyu.edu', '1929-09-30');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cnowlant', 'Claudina', 'Nowlan', 'DIOWmssgF9I', 'cnowlant@china.com.cn', '1982-07-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('wellissu', 'Wenona', 'Elliss', '5Cb6qWd', 'wellissu@auda.org.au', '1987-02-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('fjosipovicv', 'Fania', 'Josipovic', 'X8OZif98CsM', 'fjosipovicv@freewebs.com', '1952-03-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ktavinorw', 'Keenan', 'Tavinor', 'osLy7hO', 'ktavinorw@businessweek.com', '1952-08-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('atoffanox', 'Annelise', 'Toffano', 'I8tyWG2', 'atoffanox@paginegialle.it', '1978-11-24');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mbevisy', 'Marika', 'Bevis', 'ha5bvi', 'mbevisy@simplemachines.org', '1920-02-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('malenichevz', 'Melisent', 'Alenichev', 'rIXCcSnnn', 'malenichevz@nature.com', '1988-12-10');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('htamlett10', 'Hewie', 'Tamlett', 'x3xscn', 'htamlett10@naver.com', '1932-08-31');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('limlen11', 'Linnea', 'Imlen', 'ttUC20nIHc6', 'limlen11@thetimes.co.uk', '1997-11-05');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bjoris12', 'Blayne', 'Joris', 'UC8gIA0OQ1H', 'bjoris12@wsj.com', '1927-12-17');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hhallas13', 'Harvey', 'Hallas', '4N4gsVS04cc1', 'hhallas13@hexun.com', '1956-07-05');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bthornthwaite14', 'Betsy', 'Thornthwaite', '0NtbwR', 'bthornthwaite14@blogtalkradio.com', '1946-10-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('smuzzall15', 'Sigismund', 'Muzzall', 'rM6Wom3', 'smuzzall15@irs.gov', '1992-12-23');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('soller16', 'Shandeigh', 'Oller', '7BHMOwPvgjc4', 'soller16@wunderground.com', '1952-03-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mschottli17', 'Margaretha', 'Schottli', 'rpIfsFhD', 'mschottli17@hp.com', '1975-09-13');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mkirkbright18', 'Moira', 'Kirkbright', 'OKrmp8Ugh', 'mkirkbright18@bbc.co.uk', '1959-05-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('swhatford19', 'Selestina', 'Whatford', '1UzSparquiBC', 'swhatford19@scribd.com', '1926-03-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jtebbet1a', 'Jeremy', 'Tebbet', 'fQ5i3m', 'jtebbet1a@usnews.com', '1964-03-13');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dwankel1b', 'Damien', 'Wankel', 'M56ggHdS9Ds', 'dwankel1b@mozilla.com', '1963-03-15');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gdilliway1c', 'George', 'Dilliway', 'kh9qPO8eGl1R', 'gdilliway1c@youku.com', '1978-03-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mbarnsley1d', 'Mikel', 'Barnsley', 'a3s5Zz4X', 'mbarnsley1d@nymag.com', '1932-02-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gdamerell1e', 'Gabie', 'Damerell', 'XYpiU0S', 'gdamerell1e@engadget.com', '1951-10-04');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bgething1f', 'Bernadina', 'Gething', 'upow4P51', 'bgething1f@ameblo.jp', '1988-01-04');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ndantuoni1g', 'Nolie', 'D''Antuoni', 'k6ugGx3', 'ndantuoni1g@theguardian.com', '1956-08-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cpowley1h', 'Claudia', 'Powley', 'TMEySaH03', 'cpowley1h@mysql.com', '1984-02-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nbullene1i', 'Norine', 'Bullene', 'zxC33SMFcH', 'nbullene1i@topsy.com', '1945-10-22');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ewilleman1j', 'Ellis', 'Willeman', 'PBPG6z', 'ewilleman1j@home.pl', '1969-04-07');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('beivers1k', 'Bernadette', 'Eivers', 'dBVVf5', 'beivers1k@last.fm', '1959-09-10');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('kpraundlin1l', 'Kattie', 'Praundlin', 'beun2q1iJl', 'kpraundlin1l@bigcartel.com', '1937-03-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('molney1m', 'Marrissa', 'Olney', 'HrAmjX4Q', 'molney1m@biglobe.ne.jp', '1922-09-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bglasgow1n', 'Bud', 'Glasgow', 'F0ff7fcs8', 'bglasgow1n@youtu.be', '1994-11-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cwemes1o', 'Cam', 'Wemes', 'PcclfHLysZ03', 'cwemes1o@sourceforge.net', '1977-03-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hhallitt1p', 'Hortensia', 'Hallitt', '1D0oWXQAz', 'hhallitt1p@w3.org', '1934-01-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('svieyra1q', 'Siward', 'Vieyra', 'bvak4gw', 'svieyra1q@github.io', '1929-06-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('klaminman1r', 'Kelli', 'Laminman', '0uRy9ddot', 'klaminman1r@wikia.com', '1951-09-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dcorneil1s', 'Drusy', 'Corneil', 'NRqXO8', 'dcorneil1s@etsy.com', '1997-10-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mludgate1t', 'Marietta', 'Ludgate', 'rNlD9RwD', 'mludgate1t@hao123.com', '1924-11-30');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('akleeman1u', 'Augustina', 'Kleeman', 'gTi3ndbs3gRi', 'akleeman1u@wikispaces.com', '1960-04-06');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('scromblehome1v', 'Shirlene', 'Cromblehome', 'EDs5LzO', 'scromblehome1v@reuters.com', '1980-10-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nverson1w', 'Natal', 'Verson', '5S4FJdPR', 'nverson1w@mit.edu', '1972-12-30');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dmiddup1x', 'Dorolice', 'Middup', 'Nk19yEhwKpRC', 'dmiddup1x@myspace.com', '1954-12-22');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('lquiddinton1y', 'Lindi', 'Quiddinton', 'LwfPwSAG6PY', 'lquiddinton1y@newsvine.com', '1937-07-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('idevanny1z', 'Ivie', 'Devanny', 'a1XKzfRVV', 'idevanny1z@yandex.ru', '1934-11-04');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rjanek20', 'Rodger', 'Janek', 'FCPiKkivH', 'rjanek20@state.gov', '1999-05-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mmenhenitt21', 'Marty', 'Menhenitt', 'nT8vWzDfYJF', 'mmenhenitt21@oakley.com', '1989-10-05');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mpashe22', 'Minerva', 'Pashe', 'U5I3hm', 'mpashe22@phoca.cz', '1983-05-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('sreeder23', 'Siobhan', 'Reeder', 'usQzu6AhEb', 'sreeder23@prlog.org', '1996-08-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('eguidoni24', 'Elnora', 'Guidoni', 'kpzZnugikYe', 'eguidoni24@tripadvisor.com', '1982-03-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vdicarlo25', 'Vaughn', 'Di Carlo', 'IReJEIXdlVVf', 'vdicarlo25@twitpic.com', '1954-08-07');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rbuff26', 'Rivi', 'Buff', 'znwaNktIHZ', 'rbuff26@barnesandnoble.com', '1972-09-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('awolfe27', 'Artus', 'Wolfe', 'EhFr0WTw0jko', 'awolfe27@digg.com', '1941-10-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('eguidera28', 'Elene', 'Guidera', 'NcKKpaZc4', 'eguidera28@diigo.com', '1965-01-26');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dstammers29', 'Dougy', 'Stammers', 'g8BL1j', 'dstammers29@1688.com', '1963-09-30');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('fioselevich2a', 'Frasco', 'Ioselevich', 'h2UXVJyjYJi1', 'fioselevich2a@google.co.uk', '1956-03-09');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rcapelin2b', 'Reamonn', 'Capelin', '5WFHvU3xU', 'rcapelin2b@netlog.com', '1932-05-26');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dmclurg2c', 'Di', 'McLurg', '4iiqKX9KJ', 'dmclurg2c@pagesperso-orange.fr', '1926-02-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gpennock2d', 'Guendolen', 'Pennock', '3n9QCqtulDJ', 'gpennock2d@artisteer.com', '1951-01-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ateers2e', 'Aland', 'Teers', 'VWARCFE', 'ateers2e@arstechnica.com', '1982-07-29');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('lreuble2f', 'Lu', 'Reuble', 'cObNYaQI6', 'lreuble2f@vkontakte.ru', '1978-01-07');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('edrakers2g', 'Estel', 'Drakers', '0zoAqHdP', 'edrakers2g@topsy.com', '1996-05-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mmaccaffrey2h', 'Margette', 'MacCaffrey', 'nZyS3Ga', 'mmaccaffrey2h@tuttocitta.it', '1976-07-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('pgroundwator2i', 'Phillipe', 'Groundwator', 'zJ7v72eHj6Hn', 'pgroundwator2i@google.co.uk', '1962-08-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mcrosetti2j', 'Mitchael', 'Crosetti', 'KqdBmpv9qo', 'mcrosetti2j@bluehost.com', '1973-01-04');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cethersey2k', 'Clarance', 'Ethersey', 'fRKu14', 'cethersey2k@a8.net', '1974-04-30');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('kzealy2l', 'Karla', 'Zealy', '9h093iu58q', 'kzealy2l@cloudflare.com', '1966-06-07');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bredmond2m', 'Benjy', 'Redmond', 'I87i0PaJN', 'bredmond2m@goo.gl', '1947-09-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('eshorten2n', 'Eimile', 'Shorten', 'EO2LBEKOv33', 'eshorten2n@hexun.com', '1973-04-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('lmogenot2o', 'Lyn', 'Mogenot', 'yntTu0pumO', 'lmogenot2o@cloudflare.com', '1994-03-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('brotte2p', 'Barbabas', 'Rotte', '8vIsnKU9', 'brotte2p@yolasite.com', '1932-11-15');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('edossit2q', 'Enrique', 'Dossit', 'kEVqtui7', 'edossit2q@cdbaby.com', '1940-09-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('fburridge2r', 'Frasquito', 'Burridge', 'BiGJhomei', 'fburridge2r@ted.com', '1932-10-17');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ccockney2s', 'Carlyle', 'Cockney', 'Ln0jqrsw', 'ccockney2s@elpais.com', '1989-05-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ntrodler2t', 'Nicky', 'Trodler', 'ZyfIS4QUk9Nu', 'ntrodler2t@ft.com', '1961-10-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('njancy2u', 'Norman', 'Jancy', 'inUULhfrlsBP', 'njancy2u@dmoz.org', '1999-12-06');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nkacheler2v', 'Neel', 'Kacheler', 'kV7yjOZ4Rl', 'nkacheler2v@acquirethisname.com', '1967-12-31');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('afigiovanni2w', 'Antonino', 'Figiovanni', 'ONghJU', 'afigiovanni2w@uiuc.edu', '1988-09-16');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('elusted2x', 'Elsey', 'Lusted', 'TRSRZaNfY', 'elusted2x@sphinn.com', '1956-03-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vkarp2y', 'Vere', 'Karp', 'UNbhIM7pvdj', 'vkarp2y@oakley.com', '1940-04-17');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rwailes2z', 'Rebeka', 'Wailes', 'efikYhSjh1eX', 'rwailes2z@nbcnews.com', '1986-05-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rlyttle30', 'Rowe', 'Lyttle', 'bpXUWUTcm9', 'rlyttle30@nps.gov', '1951-05-16');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('fknatt31', 'Francesco', 'Knatt', 'qU5manItnJSm', 'fknatt31@networkadvertising.org', '1940-06-07');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('eonthank32', 'Ericka', 'Onthank', '7RgbzaAxFBy', 'eonthank32@toplist.cz', '1922-06-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('swetherhead33', 'Saree', 'Wetherhead', 'zqNh5vr97', 'swetherhead33@spotify.com', '1994-02-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ccarp34', 'Carmencita', 'Carp', 'd0AmncA', 'ccarp34@ow.ly', '1951-12-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nhirsthouse35', 'Nollie', 'Hirsthouse', 'f6NrD7k2vNB', 'nhirsthouse35@dell.com', '1999-10-29');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('sswinbourne36', 'Standford', 'Swinbourne', 'sdm8fJfs', 'sswinbourne36@geocities.com', '1933-01-18');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jsemple37', 'Jori', 'Semple', 'gkTCx2qI', 'jsemple37@earthlink.net', '1976-05-31');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mingham38', 'Maggy', 'Ingham', '2pQW4zvroLVX', 'mingham38@adobe.com', '1921-12-29');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('eboyfield39', 'Edithe', 'Boyfield', 'mJ6mSw', 'eboyfield39@webs.com', '1977-03-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bjacson3a', 'Blayne', 'Jacson', 'QhTynGGWN', 'bjacson3a@tumblr.com', '1972-04-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('amccraw3b', 'Anne-marie', 'McCraw', 'P0jRMp8dSaO', 'amccraw3b@slideshare.net', '2000-05-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nsmale3c', 'Nero', 'Smale', 'R3GMfR9zup4C', 'nsmale3c@rediff.com', '2001-01-04');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mjobson3d', 'Milly', 'Jobson', 'XvFivio', 'mjobson3d@sun.com', '1925-03-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gsteers3e', 'Geraldine', 'Steers', '4KDXW7z4N', 'gsteers3e@biglobe.ne.jp', '1942-10-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('brucklesse3f', 'Bonnie', 'Rucklesse', 'NOcYHf5z8X', 'brucklesse3f@eepurl.com', '1953-08-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('kyoutead3g', 'Kienan', 'Youtead', 'Zk49ltHw', 'kyoutead3g@ycombinator.com', '1946-07-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ldomini3h', 'Lilli', 'Domini', 'iNvuNAG4q', 'ldomini3h@redcross.org', '1946-08-16');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dtamas3i', 'Darcy', 'Tamas', 'jrK74r', 'dtamas3i@addthis.com', '1990-07-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('wlemmers3j', 'Wesley', 'Lemmers', 'H45ixYKW', 'wlemmers3j@umich.edu', '1975-09-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('asee3k', 'Adela', 'See', 'QLN78GsIi', 'asee3k@prweb.com', '1945-12-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mbuswell3l', 'Melita', 'Buswell', '42G311h88pAQ', 'mbuswell3l@bbc.co.uk', '1970-01-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cbembrigg3m', 'Cornell', 'Bembrigg', 'GhgeDkgcyRB', 'cbembrigg3m@edublogs.org', '1925-09-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('fschottli3n', 'Fremont', 'Schottli', 'veTqkEk8crc', 'fschottli3n@adobe.com', '1976-06-23');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('sfranzschoninger3o', 'Shirlee', 'Franz-Schoninger', 'XXtVxdC2slO', 'sfranzschoninger3o@behance.net', '1933-02-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mtippings3p', 'Meagan', 'Tippings', 'sTE2tPRnJmO', 'mtippings3p@ehow.com', '1934-03-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mriggs3q', 'Mallorie', 'Riggs', 'eM3m9bmxtW', 'mriggs3q@sun.com', '1990-09-04');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mcorradetti3r', 'Mitchel', 'Corradetti', 'ZSx9zC3', 'mcorradetti3r@wikimedia.org', '1933-02-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rkonneke3s', 'Rainer', 'Konneke', 'OLMBxH', 'rkonneke3s@blogger.com', '1982-01-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vstrickler3t', 'Vanessa', 'Strickler', 'uPTiuk', 'vstrickler3t@cisco.com', '1974-11-15');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ahands3u', 'Arabel', 'Hands', 'V9HLhJj4FlE', 'ahands3u@parallels.com', '1938-05-12');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jkunkel3v', 'Josie', 'Kunkel', 'Fyic95A5n9', 'jkunkel3v@ted.com', '1977-09-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('snellies3w', 'Shandie', 'Nellies', 'WBFZ9ouV', 'snellies3w@stumbleupon.com', '1993-08-16');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dgrelik3x', 'Danica', 'Grelik', 'AyGffKdKzHg', 'dgrelik3x@freewebs.com', '1945-02-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vvasler3y', 'Vaughn', 'Vasler', '2EzwSF22J', 'vvasler3y@imageshack.us', '1959-02-10');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mfraine3z', 'Melanie', 'Fraine', 'H2rNLKSu3hS', 'mfraine3z@jalbum.net', '1948-03-03');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vsteven40', 'Vivie', 'Steven', 'KVvs1C7Vtq', 'vsteven40@cam.ac.uk', '1925-11-24');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ikalkofer41', 'Ida', 'Kalkofer', 'Nt9q10', 'ikalkofer41@skyrock.com', '1985-05-29');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('mmellon42', 'Michail', 'Mellon', 'xfpuRSkl5H', 'mmellon42@newsvine.com', '1949-10-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dstandeven43', 'Deny', 'Standeven', 'iak2Qy3bb', 'dstandeven43@go.com', '1947-04-06');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ebentall44', 'Esra', 'Bentall', 's0Liw1usI9Ct', 'ebentall44@nydailynews.com', '1954-02-10');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('btomadoni45', 'Bryn', 'Tomadoni', 'tq27JI2wd', 'btomadoni45@upenn.edu', '2000-04-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('amartindale46', 'Abie', 'Martindale', 'BT4JPyF', 'amartindale46@ucsd.edu', '1991-08-23');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cmickan47', 'Carin', 'Mickan', 'LQe6eOC3imzR', 'cmickan47@sourceforge.net', '1948-02-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jwashtell48', 'Jared', 'Washtell', 'MmOZwL4iIW37', 'jwashtell48@sun.com', '1973-02-26');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('eyakubowicz49', 'Eric', 'Yakubowicz', 'tUHjYhVMOi2', 'eyakubowicz49@nhs.uk', '1985-07-03');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('sbickle4a', 'Stacy', 'Bickle', '1NwG0CYKsBQ', 'sbickle4a@miibeian.gov.cn', '1992-09-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('boen4b', 'Bridie', 'Oen', 'gxZl96OKTav', 'boen4b@bizjournals.com', '1998-08-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('btilson4c', 'Bronny', 'Tilson', 'k6Crce', 'btilson4c@gizmodo.com', '1967-01-22');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hkleinberer4d', 'Hollie', 'Kleinberer', 'BEPz3NGVmWP', 'hkleinberer4d@netscape.com', '1985-12-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('clinkleter4e', 'Chickie', 'Linkleter', 'n8eIWLsAW', 'clinkleter4e@flickr.com', '1955-12-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dshere4f', 'Dorie', 'Shere', 'ThCJXhzZ', 'dshere4f@zimbio.com', '1961-09-28');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ksmy4g', 'Katti', 'Smy', 'IMi6s7W', 'ksmy4g@webeden.co.uk', '1927-09-22');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gmcelhinney4h', 'Germana', 'McElhinney', 'VsO3RctKU', 'gmcelhinney4h@alibaba.com', '1972-08-24');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('tharty4i', 'Tillie', 'Harty', 'SxllGtPaz6F3', 'tharty4i@cisco.com', '1965-09-19');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bsteed4j', 'Bettye', 'Steed', '9ynFQonEoe', 'bsteed4j@goo.gl', '1972-06-09');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('wbroodes4k', 'Wilburt', 'Broodes', 'wAaRJ2X', 'wbroodes4k@amazon.co.jp', '1973-01-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('pgrunbaum4l', 'Parry', 'Grunbaum', '9wHaH4Ac', 'pgrunbaum4l@newyorker.com', '1921-10-21');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ogreet4m', 'Ollie', 'Greet', 'snxtY8', 'ogreet4m@washington.edu', '1965-10-17');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dmabbett4n', 'Davidson', 'Mabbett', 'JfVEy7', 'dmabbett4n@cbslocal.com', '1948-04-09');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ttooze4o', 'Tarra', 'Tooze', 'GDNGv0', 'ttooze4o@joomla.org', '1997-07-20');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('chearmon4p', 'Christine', 'Hearmon', 'RYmkW3K', 'chearmon4p@amazon.de', '1978-11-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jkennea4q', 'Jimmy', 'Kennea', 'V0VmSzQnrBJE', 'jkennea4q@ft.com', '1925-10-13');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nantcliff4r', 'Noell', 'Antcliff', '3qJYdc5', 'nantcliff4r@examiner.com', '1966-09-23');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('dpele4s', 'Donia', 'Pele', 'NrfpxsE5Xv', 'dpele4s@skyrock.com', '1943-10-29');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('pspowage4t', 'Pascal', 'Spowage', 'aOsrtz', 'pspowage4t@indiatimes.com', '1992-02-23');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cbattison4u', 'Chancey', 'Battison', 'hb9vXdJ', 'cbattison4u@msu.edu', '1940-04-03');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('aiwanczyk4v', 'Ada', 'Iwanczyk', 'cwtk57KoRZ', 'aiwanczyk4v@printfriendly.com', '1982-10-03');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hcanada4w', 'Hansiain', 'Canada', 'Cio725RVq', 'hcanada4w@wiley.com', '1928-06-15');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ebirtwisle4x', 'Eddy', 'Birtwisle', 'kLJRaVPze', 'ebirtwisle4x@mozilla.com', '2000-12-18');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('bspeller4y', 'Betti', 'Speller', 'wh28eO8uei', 'bspeller4y@upenn.edu', '1965-07-09');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rlinbohm4z', 'Rozanna', 'Linbohm', 'aEjjt5FzBQg3', 'rlinbohm4z@hp.com', '1932-12-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cgiabucci50', 'Cassy', 'Giabucci', 'LPbSMOnzYBFX', 'cgiabucci50@vk.com', '1925-03-26');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('nscandrett51', 'Naoma', 'Scandrett', 'GMharG', 'nscandrett51@rediff.com', '1971-03-25');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('slathbury52', 'Shanda', 'Lathbury', 'TBKcO5TbgjO', 'slathbury52@people.com.cn', '1983-11-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('kkillough53', 'Katerina', 'Killough', 'cxh1uxvSjzG', 'kkillough53@photobucket.com', '1947-01-10');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('lheineken54', 'Lise', 'Heineken', 'ZF6lnTD', 'lheineken54@wordpress.com', '1966-12-08');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('shansberry55', 'Stacey', 'Hansberry', 'wad6wpS', 'shansberry55@timesonline.co.uk', '1927-09-17');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('rscothern56', 'Randy', 'Scothern', 'JmksR8j', 'rscothern56@rakuten.co.jp', '1975-03-14');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('vtremellan57', 'Viola', 'Tremellan', '8qFfmAc9', 'vtremellan57@chron.com', '1940-11-03');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ferington58', 'Flory', 'Erington', 'uulpp2CxaAlX', 'ferington58@squarespace.com', '1983-06-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ahowlin59', 'Anabal', 'Howlin', 'S8avo1vLQl', 'ahowlin59@java.com', '1980-11-02');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('sstebbing5a', 'Sydney', 'Stebbing', 'qRlJk0xtZ', 'sstebbing5a@pinterest.com', '2000-10-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('pelderfield5b', 'Pamella', 'Elderfield', 'hWKqD4xy76j', 'pelderfield5b@whitehouse.gov', '1929-11-13');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('cchazier5c', 'Camey', 'Chazier', 'i0plURbdx', 'cchazier5c@clickbank.net', '1980-09-06');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('jsirette5d', 'Jemmie', 'Sirette', 'HWzqEnB0', 'jsirette5d@bloglines.com', '1979-08-27');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gthomsen5e', 'Grant', 'Thomsen', 'opfTD0crod', 'gthomsen5e@aol.com', '1954-03-11');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('ptinkham5f', 'Padriac', 'Tinkham', 'lJJbFWd', 'ptinkham5f@oracle.com', '1974-11-05');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('hfarnish5g', 'Helen-elizabeth', 'Farnish', 'cm7gwBsffNIP', 'hfarnish5g@microsoft.com', '1981-08-31');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('lvonnassau5h', 'Leland', 'von Nassau', 'OlsuLOFF', 'lvonnassau5h@facebook.com', '1947-10-01');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('lricciardiello5i', 'Laverne', 'Ricciardiello', 'iJu2dhXIPWAo', 'lricciardiello5i@ihg.com', '1979-02-23');
insert into UserInfo (username, firstName, lastName, password, email, DoB) values ('gcouthard5j', 'Gisella', 'Couthard', 'HgzrPQwtn0FI', 'gcouthard5j@devhub.com', '1972-02-15');

/* manual data entry */

  INSERT INTO UserInfo (username, firstName, lastName, password, email, DoB)
  VALUES
  ('FirstUser', 'Regan', 'Hay', 'hashed', 'rh49@hw.ac.uk', '1998-11-29');

  INSERT INTO StaffInfo (username, firstName, lastName, password, email, DoB, jobTitle)
  VALUES
  ('admin', 'Admin', 'Istrator', 'hash', 'SkedaddlAdmin@gmail.com', '2019-02-28', 'manager');

  INSERT INTO StationInfo (stationName, latitude, longitude, addressLine1, addressLine2, postcode)
  VALUES
  ('Waverley Station', '55.95201117', '-3.18945461', 'Edinburgh Waverley', 'Edinburgh', 'EH1 1BB'),
  ('St Andrew Square', '55.95445231', '-3.19302891', '42 St Andrew Square', 'Edinburgh', 'EH2 2AD'),
  ('The Mound', '55.95172524', '-3.19575404', 'The Mound', 'Edinburgh', 'EH2 2HG'),
  ('St Giles Cathedral', '55.94949298', '-3.19018782', '1 Parliament Square', 'Edinburgh', 'EH1 1RF'),
  ('Sibbald Walk', '55.95143029', '-3.18227279', '231 Canongate', 'Edinburgh', 'EH8 8DQ'),
  ('Charlotte Square', '55.951510', '-3.206838', '45 Charlotte Square', 'Edinburgh', 'EH2 4HQ'),
  ('Grassmarket', '55.94787', '-3.194798', '87 Grassmarket', 'Edinburgh', 'EH1 2HJ'),
  ('Bristo Square', '55.945591', '-3.189415', 'Bristo Square', 'Edinburgh', 'EH8 9AG'),
  ('Lauriston Place', '55.944806', '-3.197460', 'Lauriston Place', 'Edinburgh', 'EH3 9HX'),
  ('The Usher Hall', '55.947412', '-3.205632', 'Lothian Road', 'Edinburgh', 'EH1 2EA'),
  ('Dynamic Earth', '55.951191', '-3.174957', 'Holyrood Road', 'Edinburgh', 'EH8 8AS'),
  ('Regent Road', '55.953893', '-3.184029', '2 Regent Road', 'Edinburgh', 'EH1 3DG'),
  ('Omni Centre', '55.956706', '-3.185885', 'Greenside Row', 'Edinburgh', 'EH1 3AA');

  INSERT INTO StationStatus (stationID, maxParkingSpaces, availableParkingSpaces)
  VALUES
  ('1', '20', '10'),
  ('2', '20', '10'),
  ('3', '20', '10'),
  ('4', '20', '10'),
  ('5', '20', '10'),
  ('6', '20', '5'),
  ('7', '20', '5'),
  ('8', '20', '5'),
  ('9', '20', '5'),
  ('10', '20', '5'),
  ('11', '20', '5'),
  ('12', '20', '5'),
  ('13', '20', '5');

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
  ('11', '2'),
  ('12', '2'),
  ('13', '2'),
  ('14', '2'),
  ('15', '2'),
  ('16', '2'),
  ('17', '2'),
  ('18', '2'),
  ('19', '2'),
  ('20', '2'),
  ('21', '3'),
  ('22', '3'),
  ('23', '3'),
  ('24', '3'),
  ('25', '3'),
  ('26', '3'),
  ('27', '3'),
  ('28', '3'),
  ('29', '3'),
  ('30', '3'),
  ('31', '4'),
  ('32', '4'),
  ('33', '4'),
  ('34', '4'),
  ('35', '4'),
  ('36', '4'),
  ('37', '4'),
  ('38', '4'),
  ('39', '4'),
  ('40', '4'),
  ('41', '5'),
  ('42', '5'),
  ('43', '5'),
  ('44', '5'),
  ('45', '5'),
  ('46', '5'),
  ('47', '5'),
  ('48', '5'),
  ('49', '5'),
  ('50', '5'),
  ('51', '6'),
  ('52', '6'),
  ('53', '6'),
  ('54', '6'),
  ('55', '6'),
  ('56', '7'),
  ('57', '7'),
  ('58', '7'),
  ('59', '7'),
  ('60', '7'),
  ('61', '8'),
  ('62', '8'),
  ('63', '8'),
  ('64', '8'),
  ('65', '8'),
  ('66', '9'),
  ('67', '9'),
  ('68', '9'),
  ('69', '9'),
  ('70', '9'),
  ('71', '10'),
  ('72', '10'),
  ('73', '10'),
  ('74', '10'),
  ('75', '10'),
  ('76', '11'),
  ('77', '11'),
  ('78', '11'),
  ('79', '11'),
  ('80', '11'),
  ('81', '12'),
  ('82', '12'),
  ('83', '12'),
  ('84', '12'),
  ('85', '12'),
  ('86', '13'),
  ('87', '13'),
  ('88', '13'),
  ('89', '13'),
  ('90', '13');


  insert into UsersUsingBikes (bikeID, userID) values (90, 1);
  insert into UsersUsingBikes (bikeID, userID) values (91, 2);
  insert into UsersUsingBikes (bikeID, userID) values (92, 3);
  insert into UsersUsingBikes (bikeID, userID) values (93, 4);
  insert into UsersUsingBikes (bikeID, userID) values (94, 5);
  insert into UsersUsingBikes (bikeID, userID) values (95, 6);
  insert into UsersUsingBikes (bikeID, userID) values (96, 7);
  insert into UsersUsingBikes (bikeID, userID) values (97, 8);
  insert into UsersUsingBikes (bikeID, userID) values (98, 9);
  insert into UsersUsingBikes (bikeID, userID) values (99, 10);
  insert into UsersUsingBikes (bikeID, userID) values (100, 11);
  insert into UsersUsingBikes (bikeID, userID) values (101, 12);
  insert into UsersUsingBikes (bikeID, userID) values (102, 13);
  insert into UsersUsingBikes (bikeID, userID) values (103, 14);
  insert into UsersUsingBikes (bikeID, userID) values (104, 15);
  insert into UsersUsingBikes (bikeID, userID) values (105, 16);
  insert into UsersUsingBikes (bikeID, userID) values (106, 17);
  insert into UsersUsingBikes (bikeID, userID) values (107, 18);
  insert into UsersUsingBikes (bikeID, userID) values (108, 19);
  insert into UsersUsingBikes (bikeID, userID) values (109, 20);
  insert into UsersUsingBikes (bikeID, userID) values (110, 21);
  insert into UsersUsingBikes (bikeID, userID) values (111, 22);
  insert into UsersUsingBikes (bikeID, userID) values (112, 23);
  insert into UsersUsingBikes (bikeID, userID) values (113, 24);
  insert into UsersUsingBikes (bikeID, userID) values (114, 25);
  insert into UsersUsingBikes (bikeID, userID) values (115, 26);
  insert into UsersUsingBikes (bikeID, userID) values (116, 27);
  insert into UsersUsingBikes (bikeID, userID) values (117, 28);
  insert into UsersUsingBikes (bikeID, userID) values (118, 29);
  insert into UsersUsingBikes (bikeID, userID) values (119, 30);
  insert into UsersUsingBikes (bikeID, userID) values (120, 31);
  insert into UsersUsingBikes (bikeID, userID) values (121, 32);
  insert into UsersUsingBikes (bikeID, userID) values (122, 33);
  insert into UsersUsingBikes (bikeID, userID) values (123, 34);
  insert into UsersUsingBikes (bikeID, userID) values (124, 35);
  insert into UsersUsingBikes (bikeID, userID) values (125, 36);
  insert into UsersUsingBikes (bikeID, userID) values (126, 37);
  insert into UsersUsingBikes (bikeID, userID) values (127, 38);
  insert into UsersUsingBikes (bikeID, userID) values (128, 39);
  insert into UsersUsingBikes (bikeID, userID) values (129, 40);
  insert into UsersUsingBikes (bikeID, userID) values (130, 41);
  insert into UsersUsingBikes (bikeID, userID) values (131, 42);
  insert into UsersUsingBikes (bikeID, userID) values (132, 43);
  insert into UsersUsingBikes (bikeID, userID) values (133, 44);
  insert into UsersUsingBikes (bikeID, userID) values (134, 45);
  insert into UsersUsingBikes (bikeID, userID) values (135, 46);
  insert into UsersUsingBikes (bikeID, userID) values (136, 47);
  insert into UsersUsingBikes (bikeID, userID) values (137, 48);
  insert into UsersUsingBikes (bikeID, userID) values (138, 49);
  insert into UsersUsingBikes (bikeID, userID) values (139, 50);
  insert into UsersUsingBikes (bikeID, userID) values (140, 51);
  insert into UsersUsingBikes (bikeID, userID) values (141, 52);
  insert into UsersUsingBikes (bikeID, userID) values (142, 53);
  insert into UsersUsingBikes (bikeID, userID) values (143, 54);
  insert into UsersUsingBikes (bikeID, userID) values (144, 55);
  insert into UsersUsingBikes (bikeID, userID) values (145, 56);
  insert into UsersUsingBikes (bikeID, userID) values (146, 57);
  insert into UsersUsingBikes (bikeID, userID) values (147, 58);
  insert into UsersUsingBikes (bikeID, userID) values (148, 59);
  insert into UsersUsingBikes (bikeID, userID) values (149, 60);
  insert into UsersUsingBikes (bikeID, userID) values (150, 61);
  insert into UsersUsingBikes (bikeID, userID) values (151, 62);
  insert into UsersUsingBikes (bikeID, userID) values (152, 63);
  insert into UsersUsingBikes (bikeID, userID) values (153, 64);
  insert into UsersUsingBikes (bikeID, userID) values (154, 65);
  insert into UsersUsingBikes (bikeID, userID) values (155, 66);
  insert into UsersUsingBikes (bikeID, userID) values (156, 67);
  insert into UsersUsingBikes (bikeID, userID) values (157, 68);
  insert into UsersUsingBikes (bikeID, userID) values (158, 69);
  insert into UsersUsingBikes (bikeID, userID) values (159, 70);
  insert into UsersUsingBikes (bikeID, userID) values (160, 71);
  insert into UsersUsingBikes (bikeID, userID) values (161, 72);
  insert into UsersUsingBikes (bikeID, userID) values (162, 73);
  insert into UsersUsingBikes (bikeID, userID) values (163, 74);
  insert into UsersUsingBikes (bikeID, userID) values (164, 75);
  insert into UsersUsingBikes (bikeID, userID) values (165, 76);
  insert into UsersUsingBikes (bikeID, userID) values (166, 77);
  insert into UsersUsingBikes (bikeID, userID) values (167, 78);
  insert into UsersUsingBikes (bikeID, userID) values (168, 79);
  insert into UsersUsingBikes (bikeID, userID) values (169, 80);
  insert into UsersUsingBikes (bikeID, userID) values (170, 81);
  insert into UsersUsingBikes (bikeID, userID) values (171, 82);
  insert into UsersUsingBikes (bikeID, userID) values (172, 83);
  insert into UsersUsingBikes (bikeID, userID) values (173, 84);
  insert into UsersUsingBikes (bikeID, userID) values (174, 85);
  insert into UsersUsingBikes (bikeID, userID) values (175, 86);
  insert into UsersUsingBikes (bikeID, userID) values (176, 87);
  insert into UsersUsingBikes (bikeID, userID) values (177, 88);
  insert into UsersUsingBikes (bikeID, userID) values (178, 89);
  insert into UsersUsingBikes (bikeID, userID) values (179, 90);
  insert into UsersUsingBikes (bikeID, userID) values (180, 91);
  insert into UsersUsingBikes (bikeID, userID) values (181, 92);
  insert into UsersUsingBikes (bikeID, userID) values (182, 93);
  insert into UsersUsingBikes (bikeID, userID) values (183, 94);
  insert into UsersUsingBikes (bikeID, userID) values (184, 95);
  insert into UsersUsingBikes (bikeID, userID) values (185, 96);
  insert into UsersUsingBikes (bikeID, userID) values (186, 97);
  insert into UsersUsingBikes (bikeID, userID) values (187, 98);
  insert into UsersUsingBikes (bikeID, userID) values (188, 99);
  insert into UsersUsingBikes (bikeID, userID) values (189, 100);
  insert into UsersUsingBikes (bikeID, userID) values (190, 101);
  insert into UsersUsingBikes (bikeID, userID) values (191, 102);
  insert into UsersUsingBikes (bikeID, userID) values (192, 103);
  insert into UsersUsingBikes (bikeID, userID) values (193, 104);
  insert into UsersUsingBikes (bikeID, userID) values (194, 105);
  insert into UsersUsingBikes (bikeID, userID) values (195, 106);
  insert into UsersUsingBikes (bikeID, userID) values (196, 107);
  insert into UsersUsingBikes (bikeID, userID) values (197, 108);
  insert into UsersUsingBikes (bikeID, userID) values (198, 109);
  insert into UsersUsingBikes (bikeID, userID) values (199, 110);
  insert into UsersUsingBikes (bikeID, userID) values (200, 111);
  insert into UsersUsingBikes (bikeID, userID) values (201, 112);
  insert into UsersUsingBikes (bikeID, userID) values (202, 113);
  insert into UsersUsingBikes (bikeID, userID) values (203, 114);
  insert into UsersUsingBikes (bikeID, userID) values (204, 115);
  insert into UsersUsingBikes (bikeID, userID) values (205, 116);
  insert into UsersUsingBikes (bikeID, userID) values (206, 117);
  insert into UsersUsingBikes (bikeID, userID) values (207, 118);
  insert into UsersUsingBikes (bikeID, userID) values (208, 119);
  insert into UsersUsingBikes (bikeID, userID) values (209, 120);
  insert into UsersUsingBikes (bikeID, userID) values (210, 121);
  insert into UsersUsingBikes (bikeID, userID) values (211, 122);
  insert into UsersUsingBikes (bikeID, userID) values (212, 123);
  insert into UsersUsingBikes (bikeID, userID) values (213, 124);
  insert into UsersUsingBikes (bikeID, userID) values (214, 125);
  insert into UsersUsingBikes (bikeID, userID) values (215, 126);
  insert into UsersUsingBikes (bikeID, userID) values (216, 127);
  insert into UsersUsingBikes (bikeID, userID) values (217, 128);
  insert into UsersUsingBikes (bikeID, userID) values (218, 129);
  insert into UsersUsingBikes (bikeID, userID) values (219, 130);
  insert into UsersUsingBikes (bikeID, userID) values (220, 131);
  insert into UsersUsingBikes (bikeID, userID) values (221, 132);
  insert into UsersUsingBikes (bikeID, userID) values (222, 133);
  insert into UsersUsingBikes (bikeID, userID) values (223, 134);
  insert into UsersUsingBikes (bikeID, userID) values (224, 135);
  insert into UsersUsingBikes (bikeID, userID) values (225, 136);
  insert into UsersUsingBikes (bikeID, userID) values (226, 137);
  insert into UsersUsingBikes (bikeID, userID) values (227, 138);
  insert into UsersUsingBikes (bikeID, userID) values (228, 139);
  insert into UsersUsingBikes (bikeID, userID) values (229, 140);
  insert into UsersUsingBikes (bikeID, userID) values (230, 141);
  insert into UsersUsingBikes (bikeID, userID) values (231, 142);
  insert into UsersUsingBikes (bikeID, userID) values (232, 143);
  insert into UsersUsingBikes (bikeID, userID) values (233, 144);
  insert into UsersUsingBikes (bikeID, userID) values (234, 145);
  insert into UsersUsingBikes (bikeID, userID) values (235, 146);
  insert into UsersUsingBikes (bikeID, userID) values (236, 147);
  insert into UsersUsingBikes (bikeID, userID) values (237, 148);
  insert into UsersUsingBikes (bikeID, userID) values (238, 149);
  insert into UsersUsingBikes (bikeID, userID) values (239, 150);
  insert into UsersUsingBikes (bikeID, userID) values (240, 151);
  insert into UsersUsingBikes (bikeID, userID) values (241, 152);
  insert into UsersUsingBikes (bikeID, userID) values (242, 153);
  insert into UsersUsingBikes (bikeID, userID) values (243, 154);
  insert into UsersUsingBikes (bikeID, userID) values (244, 155);
  insert into UsersUsingBikes (bikeID, userID) values (245, 156);
  insert into UsersUsingBikes (bikeID, userID) values (246, 157);
  insert into UsersUsingBikes (bikeID, userID) values (247, 158);
  insert into UsersUsingBikes (bikeID, userID) values (248, 159);
  insert into UsersUsingBikes (bikeID, userID) values (249, 160);
  insert into UsersUsingBikes (bikeID, userID) values (250, 161);
  insert into UsersUsingBikes (bikeID, userID) values (251, 162);
  insert into UsersUsingBikes (bikeID, userID) values (252, 163);
  insert into UsersUsingBikes (bikeID, userID) values (253, 164);
  insert into UsersUsingBikes (bikeID, userID) values (254, 165);
  insert into UsersUsingBikes (bikeID, userID) values (255, 166);
  insert into UsersUsingBikes (bikeID, userID) values (256, 167);
  insert into UsersUsingBikes (bikeID, userID) values (257, 168);
  insert into UsersUsingBikes (bikeID, userID) values (258, 169);
  insert into UsersUsingBikes (bikeID, userID) values (259, 170);

    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (20, 12, 9, '2019-03-09 04:52:05', '2019-03-10 00:05:55', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (70, 9, 1, '2019-03-09 13:52:31', '2019-03-10 06:48:04', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (25, 3, 1, '2019-03-09 10:09:30', '2019-03-10 08:38:01', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 12, 10, '2019-03-09 07:35:39', '2019-03-10 02:18:33', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 2, 5, '2019-03-09 17:52:02', '2019-03-10 19:04:57', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (86, 1, 1, '2019-03-09 23:25:19', '2019-03-10 04:49:17', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 8, 3, '2019-03-09 11:37:59', '2019-03-10 04:51:22', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (112, 13, 6, '2019-03-09 23:23:42', '2019-03-10 15:19:18', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (18, 13, 6, '2019-03-09 06:18:24', '2019-03-10 07:03:38', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (144, 5, 6, '2019-03-09 17:36:50', '2019-03-10 03:20:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (183, 11, 10, '2019-03-09 07:05:26', '2019-03-10 15:37:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (42, 5, 1, '2019-03-09 08:05:00', '2019-03-10 16:52:53', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (53, 5, 4, '2019-03-09 23:05:28', '2019-03-10 18:30:49', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 4, 7, '2019-03-09 20:06:59', '2019-03-10 19:32:24', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (38, 11, 5, '2019-03-09 20:05:19', '2019-03-10 20:31:18', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 8, 12, '2019-03-09 03:37:22', '2019-03-10 23:39:00', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (179, 11, 13, '2019-03-09 19:07:50', '2019-03-10 07:45:27', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (114, 7, 2, '2019-03-09 23:19:39', '2019-03-10 16:01:14', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (165, 4, 2, '2019-03-09 16:26:06', '2019-03-10 19:19:14', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (114, 4, 9, '2019-03-09 03:28:47', '2019-03-10 12:50:57', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (71, 10, 8, '2019-03-09 11:24:36', '2019-03-10 21:22:28', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (164, 5, 9, '2019-03-09 09:35:31', '2019-03-10 03:11:08', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (96, 4, 6, '2019-03-09 17:39:08', '2019-03-10 01:29:56', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 9, 12, '2019-03-09 06:12:48', '2019-03-10 06:01:05', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (129, 2, 7, '2019-03-09 03:56:59', '2019-03-10 23:30:30', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (148, 9, 11, '2019-03-09 06:39:36', '2019-03-10 13:59:05', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (121, 13, 9, '2019-03-09 21:02:37', '2019-03-10 12:40:14', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (127, 11, 7, '2019-03-09 20:55:51', '2019-03-10 16:14:29', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (104, 2, 5, '2019-03-09 13:41:26', '2019-03-10 02:08:45', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (37, 6, 11, '2019-03-09 11:09:18', '2019-03-10 12:02:23', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (150, 2, 2, '2019-03-09 00:30:05', '2019-03-10 19:35:30', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (62, 12, 4, '2019-03-09 14:58:53', '2019-03-10 23:31:51', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (168, 7, 8, '2019-03-09 06:33:47', '2019-03-10 15:45:36', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (85, 4, 2, '2019-03-09 02:25:31', '2019-03-10 08:31:21', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (177, 8, 11, '2019-03-09 23:23:08', '2019-03-10 13:09:49', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (65, 2, 4, '2019-03-09 03:47:51', '2019-03-10 21:51:31', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (99, 9, 13, '2019-03-09 02:49:18', '2019-03-10 21:57:40', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 3, 6, '2019-03-09 18:16:45', '2019-03-10 08:52:14', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (84, 7, 7, '2019-03-09 10:30:01', '2019-03-10 14:29:31', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (25, 2, 11, '2019-03-09 16:47:21', '2019-03-10 10:15:52', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (193, 3, 7, '2019-03-09 04:16:38', '2019-03-10 18:23:42', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (29, 10, 6, '2019-03-09 04:34:52', '2019-03-10 08:57:37', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (87, 5, 7, '2019-03-09 01:46:00', '2019-03-10 17:09:31', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (174, 12, 3, '2019-03-09 03:51:39', '2019-03-10 13:27:27', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 2, 13, '2019-03-09 21:18:44', '2019-03-10 08:20:29', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (45, 13, 11, '2019-03-09 21:07:58', '2019-03-10 05:40:06', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (128, 2, 6, '2019-03-09 09:02:32', '2019-03-10 02:42:16', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (189, 4, 2, '2019-03-09 17:25:34', '2019-03-10 15:38:24', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 2, 10, '2019-03-09 02:07:17', '2019-03-10 22:37:29', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (12, 9, 6, '2019-03-09 11:28:17', '2019-03-10 20:38:26', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (143, 13, 2, '2019-03-09 11:10:57', '2019-03-10 00:28:42', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 4, 11, '2019-03-09 12:11:34', '2019-03-10 14:46:53', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (143, 3, 11, '2019-03-09 03:32:20', '2019-03-10 01:25:56', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (183, 13, 2, '2019-03-09 05:53:07', '2019-03-10 01:47:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (36, 10, 12, '2019-03-09 07:54:29', '2019-03-10 20:56:12', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (54, 3, 1, '2019-03-09 17:36:16', '2019-03-10 12:29:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (53, 6, 9, '2019-03-09 17:14:51', '2019-03-10 10:08:43', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (78, 1, 8, '2019-03-09 14:28:44', '2019-03-10 21:05:56', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (182, 4, 3, '2019-03-09 07:21:04', '2019-03-10 17:56:28', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (11, 1, 8, '2019-03-09 00:02:06', '2019-03-10 13:17:16', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (196, 4, 1, '2019-03-09 22:32:05', '2019-03-10 04:01:24', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (15, 3, 8, '2019-03-09 20:20:46', '2019-03-10 21:04:01', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (187, 6, 9, '2019-03-09 16:29:50', '2019-03-10 15:27:22', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (14, 7, 1, '2019-03-09 06:21:03', '2019-03-10 12:47:12', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (127, 13, 2, '2019-03-09 11:19:31', '2019-03-10 09:50:27', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (68, 3, 13, '2019-03-09 12:53:23', '2019-03-10 21:39:23', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (139, 12, 10, '2019-03-09 07:58:21', '2019-03-10 09:04:58', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (35, 5, 6, '2019-03-09 10:29:14', '2019-03-10 20:33:17', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (1, 7, 7, '2019-03-09 18:47:56', '2019-03-10 05:23:39', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (128, 4, 1, '2019-03-09 15:34:35', '2019-03-10 17:28:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (48, 11, 6, '2019-03-09 12:25:35', '2019-03-10 11:59:49', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (188, 1, 12, '2019-03-09 15:39:37', '2019-03-10 00:30:27', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (186, 4, 4, '2019-03-09 12:40:50', '2019-03-10 09:40:52', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (165, 5, 13, '2019-03-09 15:26:58', '2019-03-10 16:47:40', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (27, 10, 11, '2019-03-09 02:23:54', '2019-03-10 02:53:14', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (60, 1, 11, '2019-03-09 21:49:18', '2019-03-10 14:01:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (182, 5, 6, '2019-03-09 19:15:25', '2019-03-10 09:39:23', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (38, 3, 1, '2019-03-09 13:16:47', '2019-03-10 13:43:38', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (165, 11, 6, '2019-03-09 00:16:47', '2019-03-10 17:39:24', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (71, 13, 7, '2019-03-09 21:16:10', '2019-03-10 21:14:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 5, 3, '2019-03-09 07:40:49', '2019-03-10 04:14:54', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (20, 13, 1, '2019-03-09 02:44:45', '2019-03-10 14:16:27', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (80, 2, 2, '2019-03-09 11:49:55', '2019-03-10 17:42:10', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (28, 5, 5, '2019-03-09 15:26:15', '2019-03-10 21:43:32', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 7, 2, '2019-03-09 04:26:16', '2019-03-10 13:20:59', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (133, 3, 5, '2019-03-09 18:22:28', '2019-03-10 06:35:58', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (109, 4, 13, '2019-03-09 16:39:45', '2019-03-10 20:21:48', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 8, 4, '2019-03-09 21:43:34', '2019-03-10 12:43:09', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (37, 12, 13, '2019-03-09 22:52:49', '2019-03-10 05:47:24', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (197, 5, 10, '2019-03-09 04:50:24', '2019-03-10 14:02:27', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (106, 7, 3, '2019-03-09 09:23:39', '2019-03-10 00:22:33', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 12, 13, '2019-03-09 17:16:47', '2019-03-10 21:05:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (125, 11, 13, '2019-03-09 12:03:36', '2019-03-10 04:32:09', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (72, 4, 11, '2019-03-09 20:16:46', '2019-03-10 08:29:43', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (46, 13, 3, '2019-03-09 12:08:04', '2019-03-10 20:39:55', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (184, 13, 5, '2019-03-09 04:16:24', '2019-03-10 12:20:03', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (29, 9, 10, '2019-03-09 07:14:53', '2019-03-10 18:47:43', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 10, 7, '2019-03-09 04:49:29', '2019-03-10 18:18:35', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (127, 11, 6, '2019-03-09 10:41:28', '2019-03-10 01:39:48', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 6, 9, '2019-03-09 21:34:36', '2019-03-10 05:35:13', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 10, 11, '2019-03-09 15:19:09', '2019-03-10 19:43:34', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (68, 7, 10, '2019-03-09 04:43:24', '2019-03-10 18:40:26', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (170, 11, 9, '2019-03-09 15:36:32', '2019-03-10 11:18:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (142, 11, 3, '2019-03-09 17:51:40', '2019-03-10 13:35:34', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (167, 5, 2, '2019-03-09 13:21:55', '2019-03-10 06:31:19', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 11, 11, '2019-03-09 05:58:26', '2019-03-10 16:46:03', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (12, 9, 6, '2019-03-09 23:09:28', '2019-03-10 12:29:04', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (162, 9, 1, '2019-03-09 11:14:49', '2019-03-10 02:54:33', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (51, 7, 2, '2019-03-09 20:53:05', '2019-03-10 00:54:55', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (101, 6, 5, '2019-03-09 04:33:15', '2019-03-10 14:54:34', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 10, 13, '2019-03-09 15:56:29', '2019-03-10 17:34:23', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (179, 13, 11, '2019-03-09 22:24:38', '2019-03-10 22:33:49', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (32, 3, 8, '2019-03-09 07:09:56', '2019-03-10 04:31:11', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (42, 11, 6, '2019-03-09 00:20:57', '2019-03-10 02:27:52', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 6, 13, '2019-03-09 03:50:40', '2019-03-10 19:32:42', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (77, 11, 7, '2019-03-09 14:31:49', '2019-03-10 15:37:11', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (51, 2, 4, '2019-03-09 08:09:41', '2019-03-10 15:08:46', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (171, 2, 8, '2019-03-09 21:30:18', '2019-03-10 18:32:59', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (160, 12, 12, '2019-03-09 18:11:44', '2019-03-10 08:01:13', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 1, 12, '2019-03-09 19:49:02', '2019-03-10 21:56:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (71, 8, 3, '2019-03-09 16:25:42', '2019-03-10 18:24:17', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (136, 2, 11, '2019-03-09 08:36:26', '2019-03-10 18:30:37', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (17, 9, 10, '2019-03-09 03:02:51', '2019-03-10 03:50:14', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (5, 1, 2, '2019-03-09 03:14:25', '2019-03-10 17:46:03', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (96, 11, 9, '2019-03-09 14:42:20', '2019-03-10 01:33:25', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (71, 1, 2, '2019-03-09 13:33:24', '2019-03-10 14:07:45', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (95, 4, 13, '2019-03-09 04:21:41', '2019-03-10 22:45:54', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (62, 10, 9, '2019-03-09 14:53:08', '2019-03-10 00:11:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (186, 4, 1, '2019-03-09 23:32:04', '2019-03-10 02:07:51', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 10, 1, '2019-03-09 19:37:03', '2019-03-10 20:28:24', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (163, 2, 1, '2019-03-09 21:24:30', '2019-03-10 23:02:39', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 3, 10, '2019-03-09 10:50:22', '2019-03-10 16:53:36', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (127, 1, 4, '2019-03-09 01:31:46', '2019-03-10 23:21:17', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (21, 3, 12, '2019-03-09 14:29:55', '2019-03-10 18:42:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (51, 3, 5, '2019-03-09 15:22:10', '2019-03-10 00:30:39', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (163, 9, 5, '2019-03-09 19:00:03', '2019-03-10 20:38:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (1, 1, 5, '2019-03-09 13:31:04', '2019-03-10 14:53:46', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (152, 5, 2, '2019-03-09 11:04:51', '2019-03-10 05:32:01', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (37, 7, 8, '2019-03-09 17:08:31', '2019-03-10 07:25:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (78, 5, 4, '2019-03-09 12:01:18', '2019-03-10 01:42:12', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (110, 8, 1, '2019-03-09 10:02:43', '2019-03-10 05:46:51', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (52, 5, 3, '2019-03-09 19:13:23', '2019-03-10 07:08:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (123, 6, 10, '2019-03-09 10:38:21', '2019-03-10 11:52:56', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (27, 1, 3, '2019-03-09 09:18:20', '2019-03-10 01:50:40', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (58, 13, 10, '2019-03-09 09:19:53', '2019-03-10 06:37:38', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (20, 12, 3, '2019-03-09 00:53:56', '2019-03-10 02:53:47', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (110, 5, 3, '2019-03-09 13:44:59', '2019-03-10 00:47:20', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (112, 1, 10, '2019-03-09 06:08:10', '2019-03-10 06:58:24', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (182, 4, 10, '2019-03-09 23:37:52', '2019-03-10 06:02:25', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (137, 12, 2, '2019-03-09 08:40:47', '2019-03-10 00:42:39', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (24, 9, 12, '2019-03-09 12:22:10', '2019-03-10 20:54:24', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (48, 9, 6, '2019-03-09 13:36:51', '2019-03-10 16:10:29', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (153, 8, 1, '2019-03-09 09:36:10', '2019-03-10 15:31:04', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (150, 12, 13, '2019-03-09 04:04:04', '2019-03-10 21:05:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 2, 10, '2019-03-09 18:51:50', '2019-03-10 14:14:20', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (196, 1, 3, '2019-03-09 09:36:54', '2019-03-10 15:29:44', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (188, 8, 10, '2019-03-09 16:46:54', '2019-03-10 16:09:31', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (97, 2, 6, '2019-03-09 07:41:19', '2019-03-10 19:50:01', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (134, 6, 7, '2019-03-09 04:05:47', '2019-03-10 16:35:21', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (4, 6, 13, '2019-03-09 13:04:12', '2019-03-10 12:16:41', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 11, 6, '2019-03-09 21:11:03', '2019-03-10 09:27:31', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (62, 11, 11, '2019-03-09 08:25:33', '2019-03-10 13:50:06', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (87, 3, 2, '2019-03-09 11:18:57', '2019-03-10 22:42:05', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 5, 1, '2019-03-09 21:13:31', '2019-03-10 07:17:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (87, 2, 7, '2019-03-09 04:55:08', '2019-03-10 05:58:17', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (46, 10, 2, '2019-03-09 00:44:47', '2019-03-10 04:38:21', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (122, 6, 4, '2019-03-09 09:36:06', '2019-03-10 23:42:59', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (124, 12, 7, '2019-03-09 12:56:39', '2019-03-10 00:39:22', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 8, 7, '2019-03-09 11:50:22', '2019-03-10 23:51:01', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (22, 7, 12, '2019-03-09 13:43:03', '2019-03-10 16:09:01', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (181, 9, 3, '2019-03-09 15:50:14', '2019-03-10 03:35:34', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (120, 2, 6, '2019-03-09 10:02:23', '2019-03-10 01:11:23', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (170, 11, 10, '2019-03-09 21:13:01', '2019-03-10 17:55:38', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (195, 13, 2, '2019-03-09 19:57:01', '2019-03-10 18:49:51', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (138, 10, 5, '2019-03-09 22:17:47', '2019-03-10 17:15:16', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (100, 4, 2, '2019-03-09 20:45:38', '2019-03-10 20:07:26', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (5, 8, 8, '2019-03-09 01:28:00', '2019-03-10 11:42:38', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (111, 5, 6, '2019-03-09 04:09:48', '2019-03-10 08:13:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (34, 1, 11, '2019-03-09 12:34:33', '2019-03-10 17:32:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (136, 8, 8, '2019-03-09 00:34:01', '2019-03-10 04:52:06', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (151, 3, 8, '2019-03-09 02:46:50', '2019-03-10 08:39:21', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (142, 13, 4, '2019-03-09 03:49:07', '2019-03-10 08:36:10', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (50, 7, 10, '2019-03-09 11:42:22', '2019-03-10 22:34:18', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (93, 1, 13, '2019-03-09 04:54:43', '2019-03-10 16:04:23', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (161, 10, 11, '2019-03-09 08:05:11', '2019-03-10 00:37:18', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (127, 10, 7, '2019-03-09 16:48:48', '2019-03-10 18:08:46', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (146, 5, 6, '2019-03-09 22:25:10', '2019-03-10 15:43:00', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 2, 2, '2019-03-09 04:22:57', '2019-03-10 20:04:57', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (11, 10, 3, '2019-03-09 22:07:47', '2019-03-10 06:24:04', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (176, 9, 4, '2019-03-09 13:22:54', '2019-03-10 18:04:23', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (175, 10, 6, '2019-03-09 18:59:12', '2019-03-10 19:56:08', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (118, 8, 7, '2019-03-09 12:18:59', '2019-03-10 17:09:59', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (68, 13, 5, '2019-03-09 04:11:05', '2019-03-10 02:26:56', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (94, 3, 7, '2019-03-09 05:29:45', '2019-03-10 07:14:36', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (101, 1, 9, '2019-03-09 13:16:21', '2019-03-10 16:23:55', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (51, 4, 9, '2019-03-09 23:22:43', '2019-03-10 18:17:37', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (125, 10, 1, '2019-03-09 07:04:44', '2019-03-10 03:17:45', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (152, 3, 5, '2019-03-09 09:37:39', '2019-03-10 13:05:44', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (91, 7, 11, '2019-03-09 17:01:59', '2019-03-10 08:18:01', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (156, 8, 6, '2019-03-09 14:03:59', '2019-03-10 04:56:29', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (120, 8, 12, '2019-03-09 15:31:58', '2019-03-10 17:28:33', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (99, 10, 5, '2019-03-09 21:46:51', '2019-03-10 21:46:32', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 7, 2, '2019-03-09 21:36:19', '2019-03-10 19:30:33', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (173, 10, 5, '2019-03-09 12:25:49', '2019-03-10 12:59:27', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 10, 4, '2019-03-09 22:00:21', '2019-03-10 19:10:06', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (18, 12, 1, '2019-03-09 15:17:26', '2019-03-10 20:35:23', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (31, 6, 10, '2019-03-09 21:02:01', '2019-03-10 00:36:01', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 13, 12, '2019-03-09 15:37:47', '2019-03-10 04:52:17', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (129, 6, 7, '2019-03-09 01:33:49', '2019-03-10 12:27:26', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (22, 10, 8, '2019-03-09 05:54:32', '2019-03-10 08:35:21', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (188, 4, 13, '2019-03-09 21:55:34', '2019-03-10 18:31:30', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (103, 7, 2, '2019-03-09 18:03:44', '2019-03-10 23:13:45', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (186, 8, 3, '2019-03-09 08:07:11', '2019-03-10 21:20:00', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 1, 12, '2019-03-09 22:41:58', '2019-03-10 04:39:55', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (37, 7, 2, '2019-03-09 22:07:14', '2019-03-10 18:16:14', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 5, 11, '2019-03-09 15:19:40', '2019-03-10 16:05:28', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 2, 9, '2019-03-09 22:52:41', '2019-03-10 02:48:01', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (154, 11, 4, '2019-03-09 05:14:21', '2019-03-10 16:43:05', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 13, 11, '2019-03-09 13:10:59', '2019-03-10 06:38:31', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (63, 5, 11, '2019-03-09 03:04:19', '2019-03-10 00:35:08', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (161, 8, 3, '2019-03-09 15:16:35', '2019-03-10 22:46:13', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (122, 11, 4, '2019-03-09 00:49:33', '2019-03-10 09:47:45', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (11, 10, 11, '2019-03-09 14:18:31', '2019-03-10 20:40:52', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (109, 8, 9, '2019-03-09 18:20:07', '2019-03-10 12:24:17', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (29, 11, 4, '2019-03-09 13:37:31', '2019-03-10 16:14:36', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (197, 7, 11, '2019-03-09 01:03:59', '2019-03-10 18:34:31', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (111, 6, 3, '2019-03-09 18:28:51', '2019-03-10 15:08:21', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (155, 7, 3, '2019-03-09 19:10:52', '2019-03-10 03:50:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (166, 8, 12, '2019-03-09 00:06:29', '2019-03-10 18:45:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (148, 2, 5, '2019-03-09 01:12:16', '2019-03-10 23:15:01', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (102, 4, 4, '2019-03-09 02:23:17', '2019-03-10 12:47:52', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (114, 1, 4, '2019-03-09 17:42:03', '2019-03-10 23:52:03', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (95, 13, 7, '2019-03-09 14:58:38', '2019-03-10 02:32:47', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (199, 10, 2, '2019-03-09 00:00:29', '2019-03-10 13:48:55', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (31, 7, 4, '2019-03-09 14:15:49', '2019-03-10 04:00:39', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (22, 6, 11, '2019-03-09 04:36:22', '2019-03-10 17:20:03', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (47, 6, 2, '2019-03-09 05:23:42', '2019-03-10 00:59:57', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (120, 13, 11, '2019-03-09 07:22:04', '2019-03-10 07:03:39', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (93, 10, 8, '2019-03-09 12:40:47', '2019-03-10 04:21:04', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (175, 6, 4, '2019-03-09 12:16:44', '2019-03-10 03:48:55', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (143, 10, 4, '2019-03-09 23:22:31', '2019-03-10 07:22:21', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (107, 2, 9, '2019-03-09 03:31:59', '2019-03-10 18:27:32', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (169, 2, 2, '2019-03-09 12:16:24', '2019-03-10 08:25:12', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (65, 4, 11, '2019-03-09 17:16:39', '2019-03-10 02:57:57', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 3, 1, '2019-03-09 03:32:26', '2019-03-10 03:13:42', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (49, 6, 5, '2019-03-09 15:55:04', '2019-03-10 10:25:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (150, 7, 6, '2019-03-09 12:41:55', '2019-03-10 12:13:01', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (139, 4, 12, '2019-03-09 18:21:32', '2019-03-10 16:55:45', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (15, 7, 12, '2019-03-09 09:02:50', '2019-03-10 23:06:58', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (73, 3, 8, '2019-03-09 02:57:20', '2019-03-10 10:02:46', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (153, 1, 4, '2019-03-09 23:39:58', '2019-03-10 07:10:45', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (137, 2, 6, '2019-03-09 19:05:55', '2019-03-10 12:41:43', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (20, 3, 6, '2019-03-09 07:43:34', '2019-03-10 09:01:52', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (111, 10, 12, '2019-03-09 16:57:39', '2019-03-10 16:20:14', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (151, 12, 1, '2019-03-09 02:55:21', '2019-03-10 02:34:20', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (122, 2, 13, '2019-03-09 09:55:17', '2019-03-10 23:56:08', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 1, 10, '2019-03-09 22:53:36', '2019-03-10 04:14:45', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (196, 13, 5, '2019-03-09 14:27:50', '2019-03-10 06:53:04', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (124, 1, 7, '2019-03-09 23:06:16', '2019-03-10 01:00:33', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 2, 7, '2019-03-09 09:32:38', '2019-03-10 14:13:34', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (40, 8, 12, '2019-03-09 18:26:39', '2019-03-10 06:30:37', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (30, 9, 8, '2019-03-09 04:52:06', '2019-03-10 14:14:14', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (106, 2, 13, '2019-03-09 12:48:53', '2019-03-10 04:25:42', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (114, 2, 1, '2019-03-09 13:09:57', '2019-03-10 18:03:34', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (169, 1, 2, '2019-03-09 15:13:25', '2019-03-10 06:10:26', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (54, 4, 1, '2019-03-09 03:53:12', '2019-03-10 17:00:35', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (170, 3, 12, '2019-03-09 04:11:10', '2019-03-10 17:54:22', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (183, 10, 3, '2019-03-09 18:27:48', '2019-03-10 16:33:24', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (162, 5, 7, '2019-03-09 14:04:09', '2019-03-10 07:43:22', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 10, 6, '2019-03-09 10:11:57', '2019-03-10 10:30:59', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (24, 7, 5, '2019-03-09 00:54:48', '2019-03-10 22:05:57', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 2, 12, '2019-03-09 21:15:17', '2019-03-10 07:49:13', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (43, 12, 2, '2019-03-09 20:14:52', '2019-03-10 22:59:50', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (48, 4, 13, '2019-03-09 23:44:55', '2019-03-10 13:55:34', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (58, 11, 8, '2019-03-09 22:37:24', '2019-03-10 18:25:13', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (21, 7, 11, '2019-03-09 10:00:06', '2019-03-10 21:11:17', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (98, 7, 11, '2019-03-09 22:29:40', '2019-03-10 22:28:03', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (4, 8, 9, '2019-03-09 03:59:00', '2019-03-10 01:50:20', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (181, 11, 2, '2019-03-09 21:21:39', '2019-03-10 22:56:02', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (62, 4, 9, '2019-03-09 02:37:53', '2019-03-10 10:55:59', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (125, 3, 8, '2019-03-09 20:55:40', '2019-03-10 05:07:33', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (39, 10, 8, '2019-03-09 12:23:26', '2019-03-10 19:50:23', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (101, 12, 10, '2019-03-09 19:26:58', '2019-03-10 08:13:34', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (27, 11, 8, '2019-03-09 17:34:43', '2019-03-10 08:00:04', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (85, 7, 4, '2019-03-09 21:53:24', '2019-03-10 10:03:05', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (90, 3, 7, '2019-03-09 21:23:26', '2019-03-10 09:12:54', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (5, 7, 7, '2019-03-09 20:58:03', '2019-03-10 19:18:38', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (187, 4, 7, '2019-03-09 03:05:41', '2019-03-10 21:32:45', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (37, 3, 8, '2019-03-09 17:28:56', '2019-03-10 12:53:16', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (173, 7, 9, '2019-03-09 02:27:04', '2019-03-10 11:50:52', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (125, 10, 12, '2019-03-09 14:33:16', '2019-03-10 10:39:10', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (26, 11, 5, '2019-03-09 10:47:25', '2019-03-10 23:47:21', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (177, 12, 13, '2019-03-09 05:20:39', '2019-03-10 13:55:14', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (69, 6, 11, '2019-03-09 07:08:23', '2019-03-10 19:42:03', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (28, 6, 11, '2019-03-09 13:17:05', '2019-03-10 21:29:46', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (11, 10, 3, '2019-03-09 17:20:16', '2019-03-10 20:05:30', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (64, 12, 8, '2019-03-09 00:19:17', '2019-03-10 09:17:57', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (97, 6, 9, '2019-03-09 02:51:14', '2019-03-10 06:45:31', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (47, 6, 11, '2019-03-09 23:39:48', '2019-03-10 02:47:04', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (151, 6, 9, '2019-03-09 06:07:12', '2019-03-10 08:27:12', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (117, 6, 10, '2019-03-09 21:18:14', '2019-03-10 17:02:19', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 10, 6, '2019-03-09 14:37:41', '2019-03-10 06:05:55', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (156, 3, 8, '2019-03-09 21:37:46', '2019-03-10 19:27:35', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 8, 13, '2019-03-09 13:10:02', '2019-03-10 17:19:38', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (50, 11, 1, '2019-03-09 00:46:38', '2019-03-10 17:28:50', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (134, 11, 10, '2019-03-09 22:42:18', '2019-03-10 00:06:03', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (130, 4, 7, '2019-03-09 19:32:28', '2019-03-10 08:06:24', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (97, 13, 9, '2019-03-09 12:55:10', '2019-03-10 15:08:23', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (123, 1, 2, '2019-03-09 14:21:38', '2019-03-10 03:37:01', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (20, 4, 9, '2019-03-09 02:11:02', '2019-03-10 14:12:21', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (183, 4, 10, '2019-03-09 01:22:21', '2019-03-10 00:43:24', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (60, 8, 5, '2019-03-09 12:57:26', '2019-03-10 05:21:38', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 6, 12, '2019-03-09 09:38:14', '2019-03-10 06:04:10', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (45, 7, 6, '2019-03-09 08:34:01', '2019-03-10 18:21:30', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (156, 8, 8, '2019-03-09 16:15:00', '2019-03-10 14:23:08', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 5, 6, '2019-03-09 11:00:01', '2019-03-10 14:41:58', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (68, 3, 11, '2019-03-09 13:04:38', '2019-03-10 05:15:43', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (126, 4, 1, '2019-03-09 02:16:01', '2019-03-10 02:25:53', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (136, 12, 10, '2019-03-09 14:01:41', '2019-03-10 02:28:01', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (1, 12, 10, '2019-03-09 08:28:34', '2019-03-10 21:15:09', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (141, 5, 12, '2019-03-09 11:51:47', '2019-03-10 22:26:34', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (3, 1, 13, '2019-03-09 03:22:49', '2019-03-10 12:32:53', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (180, 5, 5, '2019-03-09 10:06:52', '2019-03-10 02:56:50', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (34, 9, 10, '2019-03-09 11:34:46', '2019-03-10 04:28:59', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (4, 7, 11, '2019-03-09 15:30:20', '2019-03-10 19:46:20', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (82, 5, 11, '2019-03-09 12:42:07', '2019-03-10 02:40:28', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (94, 6, 7, '2019-03-09 23:27:06', '2019-03-10 03:31:57', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (125, 5, 11, '2019-03-09 17:32:28', '2019-03-10 23:16:36', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (88, 11, 13, '2019-03-09 07:28:47', '2019-03-10 07:51:19', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (174, 12, 1, '2019-03-09 17:50:57', '2019-03-10 09:05:35', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (32, 11, 6, '2019-03-09 00:50:11', '2019-03-10 14:18:14', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (88, 5, 10, '2019-03-09 16:11:30', '2019-03-10 07:57:07', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 11, 2, '2019-03-09 19:42:50', '2019-03-10 01:27:50', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (29, 9, 5, '2019-03-09 07:36:32', '2019-03-10 19:54:31', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (155, 13, 12, '2019-03-09 19:17:21', '2019-03-10 21:59:52', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (45, 5, 10, '2019-03-09 06:39:40', '2019-03-10 18:16:16', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (174, 6, 3, '2019-03-09 06:47:09', '2019-03-10 07:37:38', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (183, 2, 8, '2019-03-09 21:12:52', '2019-03-10 15:24:29', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (121, 10, 7, '2019-03-09 16:09:39', '2019-03-10 03:58:06', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (166, 3, 8, '2019-03-09 12:48:37', '2019-03-10 20:15:41', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (171, 9, 11, '2019-03-09 12:36:20', '2019-03-10 20:58:07', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 10, 3, '2019-03-09 01:04:37', '2019-03-10 23:24:14', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 13, 11, '2019-03-09 11:17:25', '2019-03-10 04:33:42', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (45, 10, 13, '2019-03-09 10:48:47', '2019-03-10 10:21:14', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (77, 5, 3, '2019-03-09 17:00:36', '2019-03-10 21:21:07', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (146, 11, 11, '2019-03-09 05:50:57', '2019-03-10 00:46:06', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (128, 4, 1, '2019-03-09 06:32:06', '2019-03-10 03:29:51', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (195, 2, 2, '2019-03-09 13:57:19', '2019-03-10 22:37:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (86, 12, 9, '2019-03-09 10:44:34', '2019-03-10 00:10:28', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (48, 13, 1, '2019-03-09 16:59:26', '2019-03-10 08:22:13', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (46, 12, 2, '2019-03-09 14:54:56', '2019-03-10 18:28:21', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (47, 4, 1, '2019-03-09 16:30:15', '2019-03-10 10:58:03', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (6, 7, 10, '2019-03-09 00:32:37', '2019-03-10 00:47:43', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 7, 4, '2019-03-09 17:05:07', '2019-03-10 12:42:11', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 13, 12, '2019-03-09 12:15:51', '2019-03-10 05:25:29', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (109, 11, 5, '2019-03-09 18:12:16', '2019-03-10 12:51:59', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (11, 5, 9, '2019-03-09 09:02:25', '2019-03-10 13:06:22', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (29, 13, 8, '2019-03-09 00:43:38', '2019-03-10 09:13:48', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (160, 3, 5, '2019-03-09 09:15:36', '2019-03-10 02:09:34', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (17, 13, 11, '2019-03-09 13:43:10', '2019-03-10 15:01:56', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (74, 8, 4, '2019-03-09 18:04:47', '2019-03-10 07:54:21', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (120, 2, 11, '2019-03-09 06:08:43', '2019-03-10 05:22:06', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (59, 12, 2, '2019-03-09 16:02:24', '2019-03-10 04:35:59', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (63, 5, 4, '2019-03-09 05:40:10', '2019-03-10 02:30:38', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (21, 1, 11, '2019-03-09 10:59:06', '2019-03-10 23:28:49', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (13, 2, 5, '2019-03-09 13:57:28', '2019-03-10 22:18:13', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (198, 12, 12, '2019-03-09 13:04:46', '2019-03-10 11:23:51', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (95, 12, 12, '2019-03-09 22:47:19', '2019-03-10 07:37:25', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (165, 5, 13, '2019-03-09 05:33:01', '2019-03-10 10:09:43', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (63, 5, 6, '2019-03-09 01:06:17', '2019-03-10 16:11:02', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (154, 3, 3, '2019-03-09 16:07:50', '2019-03-10 19:27:48', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (15, 4, 9, '2019-03-09 22:47:35', '2019-03-10 14:15:04', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (123, 12, 13, '2019-03-09 14:03:58', '2019-03-10 16:23:59', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (109, 10, 7, '2019-03-09 11:21:25', '2019-03-10 06:30:55', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (24, 11, 5, '2019-03-09 16:30:50', '2019-03-10 14:56:07', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (136, 9, 3, '2019-03-09 10:10:20', '2019-03-10 09:07:07', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (163, 11, 5, '2019-03-09 09:15:17', '2019-03-10 00:22:10', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (47, 1, 2, '2019-03-09 01:27:54', '2019-03-10 12:58:22', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 9, 2, '2019-03-09 23:45:28', '2019-03-10 01:29:47', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (62, 9, 6, '2019-03-09 13:07:43', '2019-03-10 08:16:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (146, 13, 13, '2019-03-09 14:52:40', '2019-03-10 14:55:07', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (111, 6, 9, '2019-03-09 22:49:19', '2019-03-10 15:58:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (114, 4, 9, '2019-03-09 12:02:41', '2019-03-10 05:29:06', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (84, 5, 9, '2019-03-09 18:47:01', '2019-03-10 21:10:16', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 8, 4, '2019-03-09 16:08:21', '2019-03-10 15:41:15', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (30, 6, 6, '2019-03-09 21:38:46', '2019-03-10 09:53:32', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (153, 6, 8, '2019-03-09 05:46:27', '2019-03-10 21:46:04', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 1, 11, '2019-03-09 13:22:44', '2019-03-10 06:03:10', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (6, 4, 1, '2019-03-09 14:30:38', '2019-03-10 04:50:06', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (87, 7, 12, '2019-03-09 07:00:33', '2019-03-10 01:39:13', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (169, 4, 12, '2019-03-09 16:04:30', '2019-03-10 13:51:40', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (165, 5, 8, '2019-03-09 09:09:59', '2019-03-10 01:20:18', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (180, 3, 11, '2019-03-09 13:26:41', '2019-03-10 01:01:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (116, 9, 10, '2019-03-09 17:18:18', '2019-03-10 21:43:14', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (82, 12, 3, '2019-03-09 09:11:07', '2019-03-10 19:43:59', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (139, 12, 8, '2019-03-09 21:42:29', '2019-03-10 11:08:10', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (113, 2, 4, '2019-03-09 09:18:40', '2019-03-10 18:05:37', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (70, 13, 3, '2019-03-09 07:52:37', '2019-03-10 07:01:42', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (143, 8, 3, '2019-03-09 13:53:34', '2019-03-10 03:45:43', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (112, 9, 6, '2019-03-09 23:06:10', '2019-03-10 13:53:53', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (39, 4, 1, '2019-03-09 04:03:46', '2019-03-10 22:24:22', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 8, 5, '2019-03-09 21:08:15', '2019-03-10 10:27:33', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (159, 5, 2, '2019-03-09 20:23:11', '2019-03-10 16:37:04', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (112, 4, 6, '2019-03-09 15:31:44', '2019-03-10 05:21:57', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (8, 3, 3, '2019-03-09 01:49:56', '2019-03-10 10:17:24', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (198, 11, 12, '2019-03-09 16:15:56', '2019-03-10 00:44:38', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (15, 13, 5, '2019-03-09 03:38:16', '2019-03-10 13:42:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 3, 8, '2019-03-09 14:09:17', '2019-03-10 21:10:56', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (33, 8, 6, '2019-03-09 14:14:36', '2019-03-10 07:49:31', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (67, 7, 5, '2019-03-09 15:06:48', '2019-03-10 18:47:27', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (136, 6, 11, '2019-03-09 04:15:25', '2019-03-10 00:17:41', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (93, 1, 10, '2019-03-09 22:48:35', '2019-03-10 18:32:08', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (106, 8, 10, '2019-03-09 13:34:34', '2019-03-10 14:09:43', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (105, 13, 2, '2019-03-09 05:32:07', '2019-03-10 17:32:21', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (104, 9, 9, '2019-03-09 10:10:03', '2019-03-10 14:49:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (91, 8, 13, '2019-03-09 13:02:04', '2019-03-10 16:26:15', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (92, 8, 2, '2019-03-09 13:41:56', '2019-03-10 09:57:53', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (5, 7, 7, '2019-03-09 02:49:32', '2019-03-10 19:19:24', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 4, 6, '2019-03-09 00:08:17', '2019-03-10 22:20:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (91, 1, 13, '2019-03-09 15:41:09', '2019-03-10 12:26:06', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (109, 2, 10, '2019-03-09 02:48:52', '2019-03-10 00:50:53', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (98, 13, 8, '2019-03-09 15:36:27', '2019-03-10 05:25:24', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (187, 6, 11, '2019-03-09 16:32:59', '2019-03-10 08:45:34', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (154, 11, 1, '2019-03-09 08:33:47', '2019-03-10 18:30:13', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (135, 7, 3, '2019-03-09 19:46:09', '2019-03-10 05:48:13', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (74, 8, 3, '2019-03-09 04:55:25', '2019-03-10 01:23:18', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (191, 2, 3, '2019-03-09 11:32:15', '2019-03-10 07:14:30', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (41, 11, 10, '2019-03-09 15:47:29', '2019-03-10 04:19:14', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (32, 10, 9, '2019-03-09 01:09:45', '2019-03-10 19:51:18', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (153, 9, 9, '2019-03-09 21:59:19', '2019-03-10 23:01:34', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (38, 7, 4, '2019-03-09 04:06:19', '2019-03-10 05:25:55', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (19, 2, 6, '2019-03-09 17:28:43', '2019-03-10 21:32:25', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (16, 8, 9, '2019-03-09 12:42:03', '2019-03-10 14:12:11', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (36, 6, 2, '2019-03-09 21:54:31', '2019-03-10 09:50:07', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (22, 11, 5, '2019-03-09 08:00:43', '2019-03-10 11:36:13', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (186, 5, 3, '2019-03-09 21:07:22', '2019-03-10 01:23:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (150, 12, 10, '2019-03-09 14:08:12', '2019-03-10 00:43:26', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (160, 2, 6, '2019-03-09 19:18:26', '2019-03-10 17:07:32', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (167, 1, 6, '2019-03-09 13:00:00', '2019-03-10 10:18:51', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (114, 9, 7, '2019-03-09 17:47:13', '2019-03-10 04:37:29', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (42, 11, 12, '2019-03-09 02:26:24', '2019-03-10 16:25:18', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (135, 2, 8, '2019-03-09 20:15:11', '2019-03-10 03:58:46', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (162, 13, 6, '2019-03-09 05:32:42', '2019-03-10 00:28:50', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (42, 7, 12, '2019-03-09 08:45:45', '2019-03-10 10:11:12', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (135, 12, 4, '2019-03-09 10:19:49', '2019-03-10 05:15:44', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 12, 7, '2019-03-09 14:53:39', '2019-03-10 18:06:08', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (148, 8, 5, '2019-03-09 09:17:13', '2019-03-10 12:45:08', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (74, 10, 10, '2019-03-09 04:15:29', '2019-03-10 13:56:13', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (27, 5, 12, '2019-03-09 23:50:32', '2019-03-10 04:34:10', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (39, 9, 7, '2019-03-09 15:16:21', '2019-03-10 02:12:50', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (122, 2, 1, '2019-03-09 17:21:22', '2019-03-10 04:57:14', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 5, 10, '2019-03-09 19:34:33', '2019-03-10 02:25:54', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (192, 10, 6, '2019-03-09 18:42:21', '2019-03-10 18:59:05', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (180, 5, 1, '2019-03-09 02:13:52', '2019-03-10 16:28:17', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (144, 1, 5, '2019-03-09 17:46:14', '2019-03-10 10:14:59', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (30, 4, 7, '2019-03-09 19:57:46', '2019-03-10 05:31:04', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (199, 4, 8, '2019-03-09 21:01:47', '2019-03-10 14:49:23', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (38, 11, 9, '2019-03-09 17:12:22', '2019-03-10 17:08:33', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (15, 1, 3, '2019-03-09 17:20:19', '2019-03-10 21:34:44', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (27, 2, 5, '2019-03-09 21:54:35', '2019-03-10 21:59:58', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (175, 13, 5, '2019-03-09 14:34:00', '2019-03-10 22:35:18', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (156, 9, 7, '2019-03-09 22:22:21', '2019-03-10 19:40:25', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (140, 1, 11, '2019-03-09 06:35:08', '2019-03-10 13:51:09', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (65, 12, 3, '2019-03-09 17:17:27', '2019-03-10 18:01:46', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (167, 1, 12, '2019-03-09 15:59:15', '2019-03-10 14:21:58', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (3, 1, 13, '2019-03-09 14:11:36', '2019-03-10 10:06:22', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (166, 12, 11, '2019-03-09 04:34:46', '2019-03-10 05:25:27', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (174, 9, 13, '2019-03-09 14:19:44', '2019-03-10 14:47:42', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (81, 9, 9, '2019-03-09 16:14:27', '2019-03-10 13:58:26', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (131, 10, 9, '2019-03-09 15:59:57', '2019-03-10 07:08:09', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (12, 2, 11, '2019-03-09 08:49:21', '2019-03-10 08:13:12', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (19, 2, 7, '2019-03-09 07:19:44', '2019-03-10 19:56:26', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (50, 3, 4, '2019-03-09 20:45:02', '2019-03-10 09:04:46', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (60, 4, 11, '2019-03-09 03:31:48', '2019-03-10 17:47:02', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (191, 8, 4, '2019-03-09 21:38:50', '2019-03-10 01:48:19', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (185, 7, 12, '2019-03-09 23:15:03', '2019-03-10 23:52:59', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (148, 5, 6, '2019-03-09 22:15:00', '2019-03-10 09:15:07', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (47, 13, 1, '2019-03-09 18:51:55', '2019-03-10 04:06:26', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (39, 7, 3, '2019-03-09 08:13:22', '2019-03-10 21:18:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (131, 2, 1, '2019-03-09 16:40:57', '2019-03-10 21:25:40', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (12, 5, 2, '2019-03-09 14:23:46', '2019-03-10 08:51:01', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (137, 2, 7, '2019-03-09 12:11:42', '2019-03-10 10:28:02', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (81, 7, 7, '2019-03-09 02:29:03', '2019-03-10 21:53:41', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 2, 6, '2019-03-09 08:42:00', '2019-03-10 17:12:03', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (124, 7, 11, '2019-03-09 10:46:29', '2019-03-10 08:23:15', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (34, 2, 13, '2019-03-09 10:52:54', '2019-03-10 05:50:56', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (32, 7, 8, '2019-03-09 11:57:48', '2019-03-10 02:57:48', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (100, 13, 11, '2019-03-09 15:28:27', '2019-03-10 01:41:20', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (162, 12, 10, '2019-03-09 02:56:03', '2019-03-10 22:48:39', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (48, 2, 5, '2019-03-09 06:42:18', '2019-03-10 04:17:54', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 11, 11, '2019-03-09 10:38:35', '2019-03-10 11:30:43', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (71, 8, 8, '2019-03-09 01:25:48', '2019-03-10 19:26:29', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (179, 7, 13, '2019-03-09 13:18:20', '2019-03-10 16:57:55', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (108, 3, 1, '2019-03-09 21:50:14', '2019-03-10 20:37:24', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (142, 10, 2, '2019-03-09 11:36:04', '2019-03-10 11:33:44', 2);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 2, 9, '2019-03-09 14:58:40', '2019-03-10 06:58:02', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (107, 5, 4, '2019-03-09 22:25:32', '2019-03-10 11:40:16', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (5, 6, 1, '2019-03-09 10:17:23', '2019-03-10 19:30:47', 3);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (85, 1, 13, '2019-03-09 19:20:09', '2019-03-10 03:46:09', 1);
    insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (196, 6, 3, '2019-03-09 20:50:23', '2019-03-10 07:18:21', 3);
