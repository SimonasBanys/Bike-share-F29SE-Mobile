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

/* bikes at station 4 change coordinates */
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

/* bikes at station 5 change coordinates */
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



  /* bikes being used */
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Numbat', 55.936961205, -3.25787843, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mountain duck', 55.95768623, -3.254516113, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Wallaby, euro', 55.942109726, -3.20349335, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Otter, small-clawed', 55.924029697, -3.189460365, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Yellow-throated sandgrouse', 55.931713733, -3.19173213, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Malleefowl', 55.959134768, -3.158268042, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Fox, arctic', 55.931910402, -3.150049607, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sockeye salmon', 55.930384448, -3.144490742, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Groundhog', 55.948656749, -3.182683706, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tyrant flycatcher', 55.950082653, -3.188349323, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Skimmer, four-spotted', 55.923890279, -3.217180889, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tiger cat', 55.954590562, -3.137977152, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stone sheep', 55.934087491, -3.208742297, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Purple grenadier', 55.932198671, -3.254833167, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Purple grenadier', 55.95136191, -3.159726164, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Hen, sage', 55.921636746, -3.212582325, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Brindled gnu', 55.923920394, -3.154888953, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Mockingbird, galapagos', 55.954017955, -3.244041901, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Brown lemur', 55.958825923, -3.194434386, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Colobus, white-mantled', 55.942648479, -3.233267448, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jackal, silver-backed', 55.942376223, -3.174237671, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Violet-eared waxbill', 55.939150181, -3.13749922, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Barbet, crested', 55.937800236, -3.25252464, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bohor reedbuck', 55.931623539, -3.201963303, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Frilled dragon', 55.948403314, -3.21489729, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Cockatoo, roseate', 55.947777378, -3.144423704, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Waxbill, violet-eared', 55.948492225, -3.25428776, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pelican, great white', 55.958099795, -3.240047427, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Common pheasant', 55.949971367, -3.155943928, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Red squirrel', 55.935192303, -3.202256778, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Asian red fox', 55.9590305, -3.188854965, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Nutcracker, clark''s', 55.953873942, -3.210446646, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Rufous tree pie', 55.938271419, -3.212679685, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Blue waxbill', 55.926055562, -3.226736605, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tenrec, tailless', 55.945632606, -3.243769687, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('African black crake', 55.931584026, -3.217496815, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Wolf, timber', 55.929714209, -3.19160261, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Zorilla', 55.954607961, -3.243186814, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Black bear', 55.931039746, -3.245263937, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Jaguarundi', 55.937945413, -3.240262826, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Iguana, marine', 55.925370612, -3.174797899, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Western pygmy possum', 55.939296082, -3.2586546, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Tortoise, radiated', 55.946666347, -3.246746775, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Bird, magnificent frigate', 55.939066943, -3.25062052, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Sparrow, house', 55.936603825, -3.154001296, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Ibis, glossy', 55.956419153, -3.20834558, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('European red squirrel', 55.93280326, -3.236476261, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Trumpeter, green-winged', 55.94946639, -3.180730755, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Pied avocet', 55.948918862, -3.181298305, 1);
insert into BikeInfo (bikeName, latitude, longitude, inEco) values ('Stork, marabou', 55.931305242, -3.185222371, 1);


/* user info */

insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ejozaitis0', 'Early', 'Jozaitis', 'YOFpZyb1ilW', 'NULL', 'ejozaitis0@nih.gov', '1943-09-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('wloades1', 'Ward', 'Loades', 'VDGrtx', 'NULL', 'wloades1@blogspot.com', '1965-02-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jszymonwicz2', 'Jan', 'Szymonwicz', 'pCA3NJ2', 'NULL', 'jszymonwicz2@shutterfly.com', '1925-09-18');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('zmucillo3', 'Zebulon', 'Mucillo', 'xmGJH66N', 'NULL', 'zmucillo3@sbwire.com', '1979-06-30');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dochterlony4', 'Demetri', 'Ochterlony', 'sG4evKw', 'NULL', 'dochterlony4@dot.gov', '1940-03-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('fleger5', 'Ferrel', 'Leger', 'iL58AsBQxJ', 'NULL', 'fleger5@skype.com', '1989-07-24');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gjepp6', 'Gilbert', 'Jepp', 't1UbCE', 'NULL', 'gjepp6@ted.com', '1951-06-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ghuffy7', 'Gottfried', 'Huffy', 'PXv8x7Hvx9', 'NULL', 'ghuffy7@prweb.com', '1936-02-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('njodrellec8', 'Nanice', 'Jodrellec', 'RLP1mdW', 'NULL', 'njodrellec8@ibm.com', '1930-01-24');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('kgunthorp9', 'Kathie', 'Gunthorp', 'ZmVF33FMkBR', 'NULL', 'kgunthorp9@tamu.edu', '1943-03-16');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hthridgoulda', 'Hilly', 'Thridgould', 'R7xKgn3btE', 'NULL', 'hthridgoulda@si.edu', '1923-03-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ialthorpb', 'Iosep', 'Althorp', 'b4fbf1', 'NULL', 'ialthorpb@jiathis.com', '1953-05-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hkezorc', 'Holli', 'Kezor', 'JjuHwl0J45Y', 'NULL', 'hkezorc@google.com.hk', '1965-05-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mmateud', 'Marjy', 'Mateu', 'DrIwx77', 'NULL', 'mmateud@xing.com', '1948-04-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jdimblebeee', 'Jeremiah', 'Dimblebee', '4PpbYXMWiZ4e', 'NULL', 'jdimblebeee@linkedin.com', '1978-01-17');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mcoppockf', 'Muriel', 'Coppock.', 'kkzD1WzOSh', 'NULL', 'mcoppockf@sina.com.cn', '1941-09-05');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('clettsong', 'Chelsy', 'Lettson', 'M8GtHCDPr', 'NULL', 'clettsong@parallels.com', '1993-04-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('amaccarlichh', 'Anthiathia', 'MacCarlich', 'lvarCmHiR9j', 'NULL', 'amaccarlichh@last.fm', '1936-11-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jmedcalfei', 'Joseph', 'Medcalfe', 'qq5UDuT7UOb', 'NULL', 'jmedcalfei@usatoday.com', '1954-01-31');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cgetcliffej', 'Christina', 'Getcliffe', 'xbQ8B1wcpez', 'NULL', 'cgetcliffej@github.io', '1927-12-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cgrunderk', 'Cly', 'Grunder', 'p96JOQt5e', 'NULL', 'cgrunderk@time.com', '1957-12-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('kdaintierl', 'Katherine', 'Daintier', '00qTfoI', 'NULL', 'kdaintierl@icio.us', '1993-10-26');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('slathem', 'Stefan', 'Lathe', 'DoCr4Ag', 'NULL', 'slathem@arstechnica.com', '1976-02-22');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vmckien', 'Vinni', 'McKie', 'SjfUHbcmAYnq', 'NULL', 'vmckien@seesaa.net', '1954-10-24');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ccreffeildo', 'Codi', 'Creffeild', 'NTkZiPhv9', 'NULL', 'ccreffeildo@upenn.edu', '1956-10-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mschulzep', 'Maribeth', 'Schulze', 'cxzSLAojTpW', 'NULL', 'mschulzep@state.tx.us', '1977-03-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('wwordleyq', 'Wilhelm', 'Wordley', 'O9TuSTg27xci', 'NULL', 'wwordleyq@blogspot.com', '1985-07-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jzamorar', 'Jillian', 'Zamora', 'mq3nwa', 'NULL', 'jzamorar@fotki.com', '1985-03-26');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ttintons', 'Tracee', 'Tinton', 'r3FCYBFa', 'NULL', 'ttintons@nyu.edu', '1929-09-30');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cnowlant', 'Claudina', 'Nowlan', 'DIOWmssgF9I', 'NULL', 'cnowlant@china.com.cn', '1982-07-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('wellissu', 'Wenona', 'Elliss', '5Cb6qWd', 'NULL', 'wellissu@auda.org.au', '1987-02-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('fjosipovicv', 'Fania', 'Josipovic', 'X8OZif98CsM', 'NULL', 'fjosipovicv@freewebs.com', '1952-03-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ktavinorw', 'Keenan', 'Tavinor', 'osLy7hO', 'NULL', 'ktavinorw@businessweek.com', '1952-08-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('atoffanox', 'Annelise', 'Toffano', 'I8tyWG2', 'NULL', 'atoffanox@paginegialle.it', '1978-11-24');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mbevisy', 'Marika', 'Bevis', 'ha5bvi', 'NULL', 'mbevisy@simplemachines.org', '1920-02-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('malenichevz', 'Melisent', 'Alenichev', 'rIXCcSnnn', 'NULL', 'malenichevz@nature.com', '1988-12-10');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('htamlett10', 'Hewie', 'Tamlett', 'x3xscn', 'NULL', 'htamlett10@naver.com', '1932-08-31');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('limlen11', 'Linnea', 'Imlen', 'ttUC20nIHc6', 'NULL', 'limlen11@thetimes.co.uk', '1997-11-05');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bjoris12', 'Blayne', 'Joris', 'UC8gIA0OQ1H', 'NULL', 'bjoris12@wsj.com', '1927-12-17');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hhallas13', 'Harvey', 'Hallas', '4N4gsVS04cc1', 'NULL', 'hhallas13@hexun.com', '1956-07-05');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bthornthwaite14', 'Betsy', 'Thornthwaite', '0NtbwR', 'NULL', 'bthornthwaite14@blogtalkradio.com', '1946-10-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('smuzzall15', 'Sigismund', 'Muzzall', 'rM6Wom3', 'NULL', 'smuzzall15@irs.gov', '1992-12-23');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('soller16', 'Shandeigh', 'Oller', '7BHMOwPvgjc4', 'NULL', 'soller16@wunderground.com', '1952-03-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mschottli17', 'Margaretha', 'Schottli', 'rpIfsFhD', 'NULL', 'mschottli17@hp.com', '1975-09-13');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mkirkbright18', 'Moira', 'Kirkbright', 'OKrmp8Ugh', 'NULL', 'mkirkbright18@bbc.co.uk', '1959-05-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('swhatford19', 'Selestina', 'Whatford', '1UzSparquiBC', 'NULL', 'swhatford19@scribd.com', '1926-03-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jtebbet1a', 'Jeremy', 'Tebbet', 'fQ5i3m', 'NULL', 'jtebbet1a@usnews.com', '1964-03-13');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dwankel1b', 'Damien', 'Wankel', 'M56ggHdS9Ds', 'NULL', 'dwankel1b@mozilla.com', '1963-03-15');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gdilliway1c', 'George', 'Dilliway', 'kh9qPO8eGl1R', 'NULL', 'gdilliway1c@youku.com', '1978-03-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mbarnsley1d', 'Mikel', 'Barnsley', 'a3s5Zz4X', 'NULL', 'mbarnsley1d@nymag.com', '1932-02-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gdamerell1e', 'Gabie', 'Damerell', 'XYpiU0S', 'NULL', 'gdamerell1e@engadget.com', '1951-10-04');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bgething1f', 'Bernadina', 'Gething', 'upow4P51', 'NULL', 'bgething1f@ameblo.jp', '1988-01-04');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ndantuoni1g', 'Nolie', 'D''Antuoni', 'k6ugGx3', 'NULL', 'ndantuoni1g@theguardian.com', '1956-08-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cpowley1h', 'Claudia', 'Powley', 'TMEySaH03', 'NULL', 'cpowley1h@mysql.com', '1984-02-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nbullene1i', 'Norine', 'Bullene', 'zxC33SMFcH', 'NULL', 'nbullene1i@topsy.com', '1945-10-22');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ewilleman1j', 'Ellis', 'Willeman', 'PBPG6z', 'NULL', 'ewilleman1j@home.pl', '1969-04-07');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('beivers1k', 'Bernadette', 'Eivers', 'dBVVf5', 'NULL', 'beivers1k@last.fm', '1959-09-10');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('kpraundlin1l', 'Kattie', 'Praundlin', 'beun2q1iJl', 'NULL', 'kpraundlin1l@bigcartel.com', '1937-03-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('molney1m', 'Marrissa', 'Olney', 'HrAmjX4Q', 'NULL', 'molney1m@biglobe.ne.jp', '1922-09-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bglasgow1n', 'Bud', 'Glasgow', 'F0ff7fcs8', 'NULL', 'bglasgow1n@youtu.be', '1994-11-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cwemes1o', 'Cam', 'Wemes', 'PcclfHLysZ03', 'NULL', 'cwemes1o@sourceforge.net', '1977-03-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hhallitt1p', 'Hortensia', 'Hallitt', '1D0oWXQAz', 'NULL', 'hhallitt1p@w3.org', '1934-01-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('svieyra1q', 'Siward', 'Vieyra', 'bvak4gw', 'NULL', 'svieyra1q@github.io', '1929-06-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('klaminman1r', 'Kelli', 'Laminman', '0uRy9ddot', 'NULL', 'klaminman1r@wikia.com', '1951-09-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dcorneil1s', 'Drusy', 'Corneil', 'NRqXO8', 'NULL', 'dcorneil1s@etsy.com', '1997-10-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mludgate1t', 'Marietta', 'Ludgate', 'rNlD9RwD', 'NULL', 'mludgate1t@hao123.com', '1924-11-30');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('akleeman1u', 'Augustina', 'Kleeman', 'gTi3ndbs3gRi', 'NULL', 'akleeman1u@wikispaces.com', '1960-04-06');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('scromblehome1v', 'Shirlene', 'Cromblehome', 'EDs5LzO', 'NULL', 'scromblehome1v@reuters.com', '1980-10-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nverson1w', 'Natal', 'Verson', '5S4FJdPR', 'NULL', 'nverson1w@mit.edu', '1972-12-30');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dmiddup1x', 'Dorolice', 'Middup', 'Nk19yEhwKpRC', 'NULL', 'dmiddup1x@myspace.com', '1954-12-22');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('lquiddinton1y', 'Lindi', 'Quiddinton', 'LwfPwSAG6PY', 'NULL', 'lquiddinton1y@newsvine.com', '1937-07-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('idevanny1z', 'Ivie', 'Devanny', 'a1XKzfRVV', 'NULL', 'idevanny1z@yandex.ru', '1934-11-04');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rjanek20', 'Rodger', 'Janek', 'FCPiKkivH', 'NULL', 'rjanek20@state.gov', '1999-05-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mmenhenitt21', 'Marty', 'Menhenitt', 'nT8vWzDfYJF', 'NULL', 'mmenhenitt21@oakley.com', '1989-10-05');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mpashe22', 'Minerva', 'Pashe', 'U5I3hm', 'NULL', 'mpashe22@phoca.cz', '1983-05-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('sreeder23', 'Siobhan', 'Reeder', 'usQzu6AhEb', 'NULL', 'sreeder23@prlog.org', '1996-08-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('eguidoni24', 'Elnora', 'Guidoni', 'kpzZnugikYe', 'NULL', 'eguidoni24@tripadvisor.com', '1982-03-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vdicarlo25', 'Vaughn', 'Di Carlo', 'IReJEIXdlVVf', 'NULL', 'vdicarlo25@twitpic.com', '1954-08-07');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rbuff26', 'Rivi', 'Buff', 'znwaNktIHZ', 'NULL', 'rbuff26@barnesandnoble.com', '1972-09-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('awolfe27', 'Artus', 'Wolfe', 'EhFr0WTw0jko', 'NULL', 'awolfe27@digg.com', '1941-10-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('eguidera28', 'Elene', 'Guidera', 'NcKKpaZc4', 'NULL', 'eguidera28@diigo.com', '1965-01-26');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dstammers29', 'Dougy', 'Stammers', 'g8BL1j', 'NULL', 'dstammers29@1688.com', '1963-09-30');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('fioselevich2a', 'Frasco', 'Ioselevich', 'h2UXVJyjYJi1', 'NULL', 'fioselevich2a@google.co.uk', '1956-03-09');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rcapelin2b', 'Reamonn', 'Capelin', '5WFHvU3xU', 'NULL', 'rcapelin2b@netlog.com', '1932-05-26');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dmclurg2c', 'Di', 'McLurg', '4iiqKX9KJ', 'NULL', 'dmclurg2c@pagesperso-orange.fr', '1926-02-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gpennock2d', 'Guendolen', 'Pennock', '3n9QCqtulDJ', 'NULL', 'gpennock2d@artisteer.com', '1951-01-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ateers2e', 'Aland', 'Teers', 'VWARCFE', 'NULL', 'ateers2e@arstechnica.com', '1982-07-29');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('lreuble2f', 'Lu', 'Reuble', 'cObNYaQI6', 'NULL', 'lreuble2f@vkontakte.ru', '1978-01-07');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('edrakers2g', 'Estel', 'Drakers', '0zoAqHdP', 'NULL', 'edrakers2g@topsy.com', '1996-05-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mmaccaffrey2h', 'Margette', 'MacCaffrey', 'nZyS3Ga', 'NULL', 'mmaccaffrey2h@tuttocitta.it', '1976-07-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('pgroundwator2i', 'Phillipe', 'Groundwator', 'zJ7v72eHj6Hn', 'NULL', 'pgroundwator2i@google.co.uk', '1962-08-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mcrosetti2j', 'Mitchael', 'Crosetti', 'KqdBmpv9qo', 'NULL', 'mcrosetti2j@bluehost.com', '1973-01-04');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cethersey2k', 'Clarance', 'Ethersey', 'fRKu14', 'NULL', 'cethersey2k@a8.net', '1974-04-30');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('kzealy2l', 'Karla', 'Zealy', '9h093iu58q', 'NULL', 'kzealy2l@cloudflare.com', '1966-06-07');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bredmond2m', 'Benjy', 'Redmond', 'I87i0PaJN', 'NULL', 'bredmond2m@goo.gl', '1947-09-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('eshorten2n', 'Eimile', 'Shorten', 'EO2LBEKOv33', 'NULL', 'eshorten2n@hexun.com', '1973-04-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('lmogenot2o', 'Lyn', 'Mogenot', 'yntTu0pumO', 'NULL', 'lmogenot2o@cloudflare.com', '1994-03-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('brotte2p', 'Barbabas', 'Rotte', '8vIsnKU9', 'NULL', 'brotte2p@yolasite.com', '1932-11-15');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('edossit2q', 'Enrique', 'Dossit', 'kEVqtui7', 'NULL', 'edossit2q@cdbaby.com', '1940-09-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('fburridge2r', 'Frasquito', 'Burridge', 'BiGJhomei', 'NULL', 'fburridge2r@ted.com', '1932-10-17');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ccockney2s', 'Carlyle', 'Cockney', 'Ln0jqrsw', 'NULL', 'ccockney2s@elpais.com', '1989-05-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ntrodler2t', 'Nicky', 'Trodler', 'ZyfIS4QUk9Nu', 'NULL', 'ntrodler2t@ft.com', '1961-10-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('njancy2u', 'Norman', 'Jancy', 'inUULhfrlsBP', 'NULL', 'njancy2u@dmoz.org', '1999-12-06');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nkacheler2v', 'Neel', 'Kacheler', 'kV7yjOZ4Rl', 'NULL', 'nkacheler2v@acquirethisname.com', '1967-12-31');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('afigiovanni2w', 'Antonino', 'Figiovanni', 'ONghJU', 'NULL', 'afigiovanni2w@uiuc.edu', '1988-09-16');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('elusted2x', 'Elsey', 'Lusted', 'TRSRZaNfY', 'NULL', 'elusted2x@sphinn.com', '1956-03-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vkarp2y', 'Vere', 'Karp', 'UNbhIM7pvdj', 'NULL', 'vkarp2y@oakley.com', '1940-04-17');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rwailes2z', 'Rebeka', 'Wailes', 'efikYhSjh1eX', 'NULL', 'rwailes2z@nbcnews.com', '1986-05-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rlyttle30', 'Rowe', 'Lyttle', 'bpXUWUTcm9', 'NULL', 'rlyttle30@nps.gov', '1951-05-16');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('fknatt31', 'Francesco', 'Knatt', 'qU5manItnJSm', 'NULL', 'fknatt31@networkadvertising.org', '1940-06-07');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('eonthank32', 'Ericka', 'Onthank', '7RgbzaAxFBy', 'NULL', 'eonthank32@toplist.cz', '1922-06-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('swetherhead33', 'Saree', 'Wetherhead', 'zqNh5vr97', 'NULL', 'swetherhead33@spotify.com', '1994-02-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ccarp34', 'Carmencita', 'Carp', 'd0AmncA', 'NULL', 'ccarp34@ow.ly', '1951-12-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nhirsthouse35', 'Nollie', 'Hirsthouse', 'f6NrD7k2vNB', 'NULL', 'nhirsthouse35@dell.com', '1999-10-29');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('sswinbourne36', 'Standford', 'Swinbourne', 'sdm8fJfs', 'NULL', 'sswinbourne36@geocities.com', '1933-01-18');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jsemple37', 'Jori', 'Semple', 'gkTCx2qI', 'NULL', 'jsemple37@earthlink.net', '1976-05-31');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mingham38', 'Maggy', 'Ingham', '2pQW4zvroLVX', 'NULL', 'mingham38@adobe.com', '1921-12-29');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('eboyfield39', 'Edithe', 'Boyfield', 'mJ6mSw', 'NULL', 'eboyfield39@webs.com', '1977-03-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bjacson3a', 'Blayne', 'Jacson', 'QhTynGGWN', 'NULL', 'bjacson3a@tumblr.com', '1972-04-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('amccraw3b', 'Anne-marie', 'McCraw', 'P0jRMp8dSaO', 'NULL', 'amccraw3b@slideshare.net', '2000-05-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nsmale3c', 'Nero', 'Smale', 'R3GMfR9zup4C', 'NULL', 'nsmale3c@rediff.com', '2001-01-04');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mjobson3d', 'Milly', 'Jobson', 'XvFivio', 'NULL', 'mjobson3d@sun.com', '1925-03-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gsteers3e', 'Geraldine', 'Steers', '4KDXW7z4N', 'NULL', 'gsteers3e@biglobe.ne.jp', '1942-10-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('brucklesse3f', 'Bonnie', 'Rucklesse', 'NOcYHf5z8X', 'NULL', 'brucklesse3f@eepurl.com', '1953-08-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('kyoutead3g', 'Kienan', 'Youtead', 'Zk49ltHw', 'NULL', 'kyoutead3g@ycombinator.com', '1946-07-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ldomini3h', 'Lilli', 'Domini', 'iNvuNAG4q', 'NULL', 'ldomini3h@redcross.org', '1946-08-16');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dtamas3i', 'Darcy', 'Tamas', 'jrK74r', 'NULL', 'dtamas3i@addthis.com', '1990-07-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('wlemmers3j', 'Wesley', 'Lemmers', 'H45ixYKW', 'NULL', 'wlemmers3j@umich.edu', '1975-09-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('asee3k', 'Adela', 'See', 'QLN78GsIi', 'NULL', 'asee3k@prweb.com', '1945-12-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mbuswell3l', 'Melita', 'Buswell', '42G311h88pAQ', 'NULL', 'mbuswell3l@bbc.co.uk', '1970-01-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cbembrigg3m', 'Cornell', 'Bembrigg', 'GhgeDkgcyRB', 'NULL', 'cbembrigg3m@edublogs.org', '1925-09-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('fschottli3n', 'Fremont', 'Schottli', 'veTqkEk8crc', 'NULL', 'fschottli3n@adobe.com', '1976-06-23');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('sfranzschoninger3o', 'Shirlee', 'Franz-Schoninger', 'XXtVxdC2slO', 'NULL', 'sfranzschoninger3o@behance.net', '1933-02-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mtippings3p', 'Meagan', 'Tippings', 'sTE2tPRnJmO', 'NULL', 'mtippings3p@ehow.com', '1934-03-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mriggs3q', 'Mallorie', 'Riggs', 'eM3m9bmxtW', 'NULL', 'mriggs3q@sun.com', '1990-09-04');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mcorradetti3r', 'Mitchel', 'Corradetti', 'ZSx9zC3', 'NULL', 'mcorradetti3r@wikimedia.org', '1933-02-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rkonneke3s', 'Rainer', 'Konneke', 'OLMBxH', 'NULL', 'rkonneke3s@blogger.com', '1982-01-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vstrickler3t', 'Vanessa', 'Strickler', 'uPTiuk', 'NULL', 'vstrickler3t@cisco.com', '1974-11-15');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ahands3u', 'Arabel', 'Hands', 'V9HLhJj4FlE', 'NULL', 'ahands3u@parallels.com', '1938-05-12');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jkunkel3v', 'Josie', 'Kunkel', 'Fyic95A5n9', 'NULL', 'jkunkel3v@ted.com', '1977-09-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('snellies3w', 'Shandie', 'Nellies', 'WBFZ9ouV', 'NULL', 'snellies3w@stumbleupon.com', '1993-08-16');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dgrelik3x', 'Danica', 'Grelik', 'AyGffKdKzHg', 'NULL', 'dgrelik3x@freewebs.com', '1945-02-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vvasler3y', 'Vaughn', 'Vasler', '2EzwSF22J', 'NULL', 'vvasler3y@imageshack.us', '1959-02-10');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mfraine3z', 'Melanie', 'Fraine', 'H2rNLKSu3hS', 'NULL', 'mfraine3z@jalbum.net', '1948-03-03');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vsteven40', 'Vivie', 'Steven', 'KVvs1C7Vtq', 'NULL', 'vsteven40@cam.ac.uk', '1925-11-24');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ikalkofer41', 'Ida', 'Kalkofer', 'Nt9q10', 'NULL', 'ikalkofer41@skyrock.com', '1985-05-29');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('mmellon42', 'Michail', 'Mellon', 'xfpuRSkl5H', 'NULL', 'mmellon42@newsvine.com', '1949-10-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dstandeven43', 'Deny', 'Standeven', 'iak2Qy3bb', 'NULL', 'dstandeven43@go.com', '1947-04-06');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ebentall44', 'Esra', 'Bentall', 's0Liw1usI9Ct', 'NULL', 'ebentall44@nydailynews.com', '1954-02-10');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('btomadoni45', 'Bryn', 'Tomadoni', 'tq27JI2wd', 'NULL', 'btomadoni45@upenn.edu', '2000-04-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('amartindale46', 'Abie', 'Martindale', 'BT4JPyF', 'NULL', 'amartindale46@ucsd.edu', '1991-08-23');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cmickan47', 'Carin', 'Mickan', 'LQe6eOC3imzR', 'NULL', 'cmickan47@sourceforge.net', '1948-02-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jwashtell48', 'Jared', 'Washtell', 'MmOZwL4iIW37', 'NULL', 'jwashtell48@sun.com', '1973-02-26');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('eyakubowicz49', 'Eric', 'Yakubowicz', 'tUHjYhVMOi2', 'NULL', 'eyakubowicz49@nhs.uk', '1985-07-03');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('sbickle4a', 'Stacy', 'Bickle', '1NwG0CYKsBQ', 'NULL', 'sbickle4a@miibeian.gov.cn', '1992-09-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('boen4b', 'Bridie', 'Oen', 'gxZl96OKTav', 'NULL', 'boen4b@bizjournals.com', '1998-08-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('btilson4c', 'Bronny', 'Tilson', 'k6Crce', 'NULL', 'btilson4c@gizmodo.com', '1967-01-22');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hkleinberer4d', 'Hollie', 'Kleinberer', 'BEPz3NGVmWP', 'NULL', 'hkleinberer4d@netscape.com', '1985-12-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('clinkleter4e', 'Chickie', 'Linkleter', 'n8eIWLsAW', 'NULL', 'clinkleter4e@flickr.com', '1955-12-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dshere4f', 'Dorie', 'Shere', 'ThCJXhzZ', 'NULL', 'dshere4f@zimbio.com', '1961-09-28');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ksmy4g', 'Katti', 'Smy', 'IMi6s7W', 'NULL', 'ksmy4g@webeden.co.uk', '1927-09-22');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gmcelhinney4h', 'Germana', 'McElhinney', 'VsO3RctKU', 'NULL', 'gmcelhinney4h@alibaba.com', '1972-08-24');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('tharty4i', 'Tillie', 'Harty', 'SxllGtPaz6F3', 'NULL', 'tharty4i@cisco.com', '1965-09-19');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bsteed4j', 'Bettye', 'Steed', '9ynFQonEoe', 'NULL', 'bsteed4j@goo.gl', '1972-06-09');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('wbroodes4k', 'Wilburt', 'Broodes', 'wAaRJ2X', 'NULL', 'wbroodes4k@amazon.co.jp', '1973-01-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('pgrunbaum4l', 'Parry', 'Grunbaum', '9wHaH4Ac', 'NULL', 'pgrunbaum4l@newyorker.com', '1921-10-21');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ogreet4m', 'Ollie', 'Greet', 'snxtY8', 'NULL', 'ogreet4m@washington.edu', '1965-10-17');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dmabbett4n', 'Davidson', 'Mabbett', 'JfVEy7', 'NULL', 'dmabbett4n@cbslocal.com', '1948-04-09');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ttooze4o', 'Tarra', 'Tooze', 'GDNGv0', 'NULL', 'ttooze4o@joomla.org', '1997-07-20');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('chearmon4p', 'Christine', 'Hearmon', 'RYmkW3K', 'NULL', 'chearmon4p@amazon.de', '1978-11-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jkennea4q', 'Jimmy', 'Kennea', 'V0VmSzQnrBJE', 'NULL', 'jkennea4q@ft.com', '1925-10-13');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nantcliff4r', 'Noell', 'Antcliff', '3qJYdc5', 'NULL', 'nantcliff4r@examiner.com', '1966-09-23');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('dpele4s', 'Donia', 'Pele', 'NrfpxsE5Xv', 'NULL', 'dpele4s@skyrock.com', '1943-10-29');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('pspowage4t', 'Pascal', 'Spowage', 'aOsrtz', 'NULL', 'pspowage4t@indiatimes.com', '1992-02-23');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cbattison4u', 'Chancey', 'Battison', 'hb9vXdJ', 'NULL', 'cbattison4u@msu.edu', '1940-04-03');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('aiwanczyk4v', 'Ada', 'Iwanczyk', 'cwtk57KoRZ', 'NULL', 'aiwanczyk4v@printfriendly.com', '1982-10-03');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hcanada4w', 'Hansiain', 'Canada', 'Cio725RVq', 'NULL', 'hcanada4w@wiley.com', '1928-06-15');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ebirtwisle4x', 'Eddy', 'Birtwisle', 'kLJRaVPze', 'NULL', 'ebirtwisle4x@mozilla.com', '2000-12-18');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('bspeller4y', 'Betti', 'Speller', 'wh28eO8uei', 'NULL', 'bspeller4y@upenn.edu', '1965-07-09');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rlinbohm4z', 'Rozanna', 'Linbohm', 'aEjjt5FzBQg3', 'NULL', 'rlinbohm4z@hp.com', '1932-12-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cgiabucci50', 'Cassy', 'Giabucci', 'LPbSMOnzYBFX', 'NULL', 'cgiabucci50@vk.com', '1925-03-26');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('nscandrett51', 'Naoma', 'Scandrett', 'GMharG', 'NULL', 'nscandrett51@rediff.com', '1971-03-25');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('slathbury52', 'Shanda', 'Lathbury', 'TBKcO5TbgjO', 'NULL', 'slathbury52@people.com.cn', '1983-11-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('kkillough53', 'Katerina', 'Killough', 'cxh1uxvSjzG', 'NULL', 'kkillough53@photobucket.com', '1947-01-10');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('lheineken54', 'Lise', 'Heineken', 'ZF6lnTD', 'NULL', 'lheineken54@wordpress.com', '1966-12-08');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('shansberry55', 'Stacey', 'Hansberry', 'wad6wpS', 'NULL', 'shansberry55@timesonline.co.uk', '1927-09-17');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('rscothern56', 'Randy', 'Scothern', 'JmksR8j', 'NULL', 'rscothern56@rakuten.co.jp', '1975-03-14');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('vtremellan57', 'Viola', 'Tremellan', '8qFfmAc9', 'NULL', 'vtremellan57@chron.com', '1940-11-03');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ferington58', 'Flory', 'Erington', 'uulpp2CxaAlX', 'NULL', 'ferington58@squarespace.com', '1983-06-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ahowlin59', 'Anabal', 'Howlin', 'S8avo1vLQl', 'NULL', 'ahowlin59@java.com', '1980-11-02');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('sstebbing5a', 'Sydney', 'Stebbing', 'qRlJk0xtZ', 'NULL', 'sstebbing5a@pinterest.com', '2000-10-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('pelderfield5b', 'Pamella', 'Elderfield', 'hWKqD4xy76j', 'NULL', 'pelderfield5b@whitehouse.gov', '1929-11-13');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('cchazier5c', 'Camey', 'Chazier', 'i0plURbdx', 'NULL', 'cchazier5c@clickbank.net', '1980-09-06');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('jsirette5d', 'Jemmie', 'Sirette', 'HWzqEnB0', 'NULL', 'jsirette5d@bloglines.com', '1979-08-27');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gthomsen5e', 'Grant', 'Thomsen', 'opfTD0crod', 'NULL', 'gthomsen5e@aol.com', '1954-03-11');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('ptinkham5f', 'Padriac', 'Tinkham', 'lJJbFWd', 'NULL', 'ptinkham5f@oracle.com', '1974-11-05');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('hfarnish5g', 'Helen-elizabeth', 'Farnish', 'cm7gwBsffNIP', 'NULL', 'hfarnish5g@microsoft.com', '1981-08-31');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('lvonnassau5h', 'Leland', 'von Nassau', 'OlsuLOFF', 'NULL', 'lvonnassau5h@facebook.com', '1947-10-01');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('lricciardiello5i', 'Laverne', 'Ricciardiello', 'iJu2dhXIPWAo', 'NULL', 'lricciardiello5i@ihg.com', '1979-02-23');
insert into UserInfo (username, firstName, lastName, password, salt, email, DoB) values ('gcouthard5j', 'Gisella', 'Couthard', 'HgzrPQwtn0FI', 'NULL', 'gcouthard5j@devhub.com', '1972-02-15');

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
  ('1', '20', '10'),
  ('2', '20', '10'),
  ('3', '20', '10'),
  ('4', '20', '10'),
  ('5', '20', '10');

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
  ('50', '5');

insert into UsersUsingBikes (bikeID, userID) values (51, 51);
insert into UsersUsingBikes (bikeID, userID) values (52, 52);
insert into UsersUsingBikes (bikeID, userID) values (53, 53);
insert into UsersUsingBikes (bikeID, userID) values (54, 54);
insert into UsersUsingBikes (bikeID, userID) values (55, 55);
insert into UsersUsingBikes (bikeID, userID) values (56, 56);
insert into UsersUsingBikes (bikeID, userID) values (57, 57);
insert into UsersUsingBikes (bikeID, userID) values (58, 58);
insert into UsersUsingBikes (bikeID, userID) values (59, 59);
insert into UsersUsingBikes (bikeID, userID) values (60, 60);
insert into UsersUsingBikes (bikeID, userID) values (61, 61);
insert into UsersUsingBikes (bikeID, userID) values (62, 62);
insert into UsersUsingBikes (bikeID, userID) values (63, 63);
insert into UsersUsingBikes (bikeID, userID) values (64, 64);
insert into UsersUsingBikes (bikeID, userID) values (65, 65);
insert into UsersUsingBikes (bikeID, userID) values (66, 66);
insert into UsersUsingBikes (bikeID, userID) values (67, 67);
insert into UsersUsingBikes (bikeID, userID) values (68, 68);
insert into UsersUsingBikes (bikeID, userID) values (69, 69);
insert into UsersUsingBikes (bikeID, userID) values (70, 70);
insert into UsersUsingBikes (bikeID, userID) values (71, 71);
insert into UsersUsingBikes (bikeID, userID) values (72, 72);
insert into UsersUsingBikes (bikeID, userID) values (73, 73);
insert into UsersUsingBikes (bikeID, userID) values (74, 74);
insert into UsersUsingBikes (bikeID, userID) values (75, 75);
insert into UsersUsingBikes (bikeID, userID) values (76, 76);
insert into UsersUsingBikes (bikeID, userID) values (77, 77);
insert into UsersUsingBikes (bikeID, userID) values (78, 78);
insert into UsersUsingBikes (bikeID, userID) values (79, 79);
insert into UsersUsingBikes (bikeID, userID) values (80, 80);
insert into UsersUsingBikes (bikeID, userID) values (81, 81);
insert into UsersUsingBikes (bikeID, userID) values (82, 82);
insert into UsersUsingBikes (bikeID, userID) values (83, 83);
insert into UsersUsingBikes (bikeID, userID) values (84, 84);
insert into UsersUsingBikes (bikeID, userID) values (85, 85);
insert into UsersUsingBikes (bikeID, userID) values (86, 86);
insert into UsersUsingBikes (bikeID, userID) values (87, 87);
insert into UsersUsingBikes (bikeID, userID) values (88, 88);
insert into UsersUsingBikes (bikeID, userID) values (89, 89);
insert into UsersUsingBikes (bikeID, userID) values (90, 90);
insert into UsersUsingBikes (bikeID, userID) values (91, 91);
insert into UsersUsingBikes (bikeID, userID) values (92, 92);
insert into UsersUsingBikes (bikeID, userID) values (93, 93);
insert into UsersUsingBikes (bikeID, userID) values (94, 94);
insert into UsersUsingBikes (bikeID, userID) values (95, 95);
insert into UsersUsingBikes (bikeID, userID) values (96, 96);
insert into UsersUsingBikes (bikeID, userID) values (97, 97);
insert into UsersUsingBikes (bikeID, userID) values (98, 98);
insert into UsersUsingBikes (bikeID, userID) values (99, 99);
insert into UsersUsingBikes (bikeID, userID) values (100, 100);

  INSERT INTO FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid)
  VALUES
  ('1', '1', '3', '2019-02-28 10:20:32', '2019-02-28 10:36:48', '2');
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (8, 1, 2, '2019-03-09 00:23:23', '2019-03-10 02:13:01', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (137, 5, 3, '2019-03-09 22:40:20', '2019-03-10 21:24:15', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (200, 4, 4, '2019-03-09 00:44:59', '2019-03-10 22:43:18', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (141, 5, 2, '2019-03-09 17:36:37', '2019-03-10 15:21:02', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 4, 4, '2019-03-09 07:26:39', '2019-03-10 11:11:34', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (151, 4, 4, '2019-03-09 05:51:48', '2019-03-10 20:07:18', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (115, 1, 3, '2019-03-09 16:01:56', '2019-03-10 04:36:27', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (57, 2, 4, '2019-03-09 08:39:47', '2019-03-10 12:21:59', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (174, 2, 3, '2019-03-09 02:44:49', '2019-03-10 06:41:08', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (35, 5, 5, '2019-03-09 20:07:03', '2019-03-10 06:41:44', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (3, 1, 4, '2019-03-09 18:34:17', '2019-03-10 22:12:16', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (170, 4, 4, '2019-03-09 00:06:26', '2019-03-10 02:44:20', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (126, 1, 1, '2019-03-09 02:28:35', '2019-03-10 21:07:44', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (51, 4, 3, '2019-03-09 09:44:50', '2019-03-10 15:50:50', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 2, 1, '2019-03-09 22:01:15', '2019-03-10 14:22:27', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (34, 3, 1, '2019-03-09 15:57:20', '2019-03-10 12:31:43', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (129, 5, 4, '2019-03-09 19:50:08', '2019-03-10 22:55:03', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (141, 2, 4, '2019-03-09 10:07:12', '2019-03-10 14:00:06', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 2, 4, '2019-03-09 08:09:16', '2019-03-10 09:54:22', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (37, 3, 5, '2019-03-09 09:39:14', '2019-03-10 01:58:18', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (100, 3, 3, '2019-03-09 01:03:27', '2019-03-10 11:36:42', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (189, 5, 2, '2019-03-09 01:12:57', '2019-03-10 01:05:51', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (40, 3, 2, '2019-03-09 19:27:05', '2019-03-10 00:27:02', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (55, 2, 1, '2019-03-09 08:54:04', '2019-03-10 04:35:12', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (142, 1, 1, '2019-03-09 11:39:20', '2019-03-10 01:38:04', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (175, 2, 1, '2019-03-09 11:11:46', '2019-03-10 15:26:45', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (17, 4, 3, '2019-03-09 18:57:43', '2019-03-10 23:03:33', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (138, 3, 2, '2019-03-09 00:52:54', '2019-03-10 11:44:31', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (59, 4, 5, '2019-03-09 05:11:10', '2019-03-10 18:58:26', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (15, 4, 1, '2019-03-09 07:04:21', '2019-03-10 02:51:16', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (44, 2, 5, '2019-03-09 15:29:46', '2019-03-10 13:31:02', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (13, 2, 5, '2019-03-09 11:01:31', '2019-03-10 00:54:06', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (9, 1, 5, '2019-03-09 22:55:32', '2019-03-10 03:30:42', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 5, 2, '2019-03-09 20:31:19', '2019-03-10 21:07:20', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 5, 1, '2019-03-09 19:10:00', '2019-03-10 19:31:09', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (137, 2, 1, '2019-03-09 10:55:16', '2019-03-10 14:08:53', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (36, 1, 5, '2019-03-09 16:26:32', '2019-03-10 18:09:37', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 1, 4, '2019-03-09 15:45:05', '2019-03-10 03:37:38', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (85, 5, 4, '2019-03-09 02:06:03', '2019-03-10 19:01:28', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (118, 5, 2, '2019-03-09 06:47:49', '2019-03-10 07:21:49', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (77, 2, 5, '2019-03-09 16:19:21', '2019-03-10 01:04:53', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (199, 5, 1, '2019-03-09 07:46:30', '2019-03-10 04:22:07', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (169, 4, 1, '2019-03-09 16:27:41', '2019-03-10 10:37:33', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (135, 3, 1, '2019-03-09 19:32:58', '2019-03-10 21:53:08', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (128, 2, 4, '2019-03-09 00:31:48', '2019-03-10 18:55:09', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (195, 5, 3, '2019-03-09 10:21:51', '2019-03-10 08:52:17', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (56, 5, 3, '2019-03-09 12:06:02', '2019-03-10 07:09:00', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (129, 1, 2, '2019-03-09 10:43:17', '2019-03-10 19:23:57', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (139, 3, 3, '2019-03-09 17:27:01', '2019-03-10 10:25:23', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (165, 2, 3, '2019-03-09 20:22:18', '2019-03-10 20:20:22', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (191, 1, 3, '2019-03-09 22:58:26', '2019-03-10 09:17:15', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (159, 4, 4, '2019-03-09 08:17:53', '2019-03-10 13:08:08', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (23, 3, 3, '2019-03-09 07:01:45', '2019-03-10 23:59:41', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (117, 3, 5, '2019-03-09 16:28:33', '2019-03-10 01:03:25', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (109, 3, 4, '2019-03-09 08:41:16', '2019-03-10 20:07:12', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (73, 2, 5, '2019-03-09 20:04:46', '2019-03-10 04:45:43', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (128, 3, 4, '2019-03-09 07:26:54', '2019-03-10 04:27:58', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (87, 1, 1, '2019-03-09 15:39:34', '2019-03-10 05:33:17', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (141, 1, 2, '2019-03-09 15:57:58', '2019-03-10 19:28:14', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (170, 5, 1, '2019-03-09 19:05:46', '2019-03-10 09:26:30', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (143, 3, 4, '2019-03-09 20:27:43', '2019-03-10 09:45:18', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (193, 1, 4, '2019-03-09 20:52:15', '2019-03-10 06:28:44', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (180, 2, 4, '2019-03-09 15:09:09', '2019-03-10 16:39:30', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (102, 4, 5, '2019-03-09 20:31:20', '2019-03-10 17:34:11', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (85, 1, 2, '2019-03-09 03:45:10', '2019-03-10 07:53:19', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (82, 3, 3, '2019-03-09 18:12:03', '2019-03-10 23:13:31', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (58, 5, 3, '2019-03-09 15:48:31', '2019-03-10 10:07:47', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (87, 5, 5, '2019-03-09 09:59:50', '2019-03-10 23:43:24', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (29, 5, 4, '2019-03-09 03:28:41', '2019-03-10 07:33:46', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (79, 3, 2, '2019-03-09 10:57:39', '2019-03-10 00:05:27', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (134, 1, 3, '2019-03-09 04:53:00', '2019-03-10 00:50:37', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (163, 4, 1, '2019-03-09 06:23:42', '2019-03-10 01:59:16', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (52, 3, 5, '2019-03-09 23:54:30', '2019-03-10 07:53:18', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (192, 2, 1, '2019-03-09 23:32:00', '2019-03-10 12:50:25', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (65, 3, 1, '2019-03-09 02:52:52', '2019-03-10 23:22:42', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (163, 3, 2, '2019-03-09 16:23:52', '2019-03-10 21:17:06', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (162, 4, 1, '2019-03-09 14:52:39', '2019-03-10 11:20:24', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (85, 4, 1, '2019-03-09 11:15:42', '2019-03-10 02:20:59', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (2, 3, 5, '2019-03-09 05:11:20', '2019-03-10 04:17:19', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 3, 3, '2019-03-09 15:55:33', '2019-03-10 03:09:45', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (158, 1, 3, '2019-03-09 06:46:44', '2019-03-10 07:00:56', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (97, 1, 2, '2019-03-09 13:14:43', '2019-03-10 13:01:06', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (106, 5, 4, '2019-03-09 23:25:10', '2019-03-10 03:37:34', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (49, 4, 2, '2019-03-09 11:07:04', '2019-03-10 16:15:45', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (40, 3, 3, '2019-03-09 14:09:58', '2019-03-10 08:17:01', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (157, 3, 3, '2019-03-09 16:01:51', '2019-03-10 18:22:06', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (146, 1, 5, '2019-03-09 15:34:03', '2019-03-10 07:53:45', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (119, 4, 1, '2019-03-09 08:51:50', '2019-03-10 09:45:36', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (132, 3, 4, '2019-03-09 14:14:31', '2019-03-10 22:57:20', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (152, 3, 3, '2019-03-09 16:18:44', '2019-03-10 05:57:58', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (184, 2, 5, '2019-03-09 05:23:29', '2019-03-10 18:45:10', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (151, 4, 4, '2019-03-09 18:00:54', '2019-03-10 13:51:03', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (9, 5, 1, '2019-03-09 07:09:28', '2019-03-10 01:08:56', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (9, 5, 5, '2019-03-09 01:46:18', '2019-03-10 02:46:36', 2);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (69, 5, 5, '2019-03-09 01:53:02', '2019-03-10 18:54:34', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (194, 4, 5, '2019-03-09 01:13:25', '2019-03-10 22:13:00', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (68, 5, 4, '2019-03-09 08:41:13', '2019-03-10 02:39:47', 1);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (61, 5, 3, '2019-03-09 22:03:36', '2019-03-10 17:34:19', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (172, 1, 4, '2019-03-09 07:02:34', '2019-03-10 02:49:01', 3);
  insert into FinishedRides (userID, startStationID, endStationID, startTime, endTime, pricePaid) values (113, 2, 5, '2019-03-09 03:33:26', '2019-03-10 21:20:17', 3);
