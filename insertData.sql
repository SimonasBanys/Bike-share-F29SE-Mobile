INSERT INTO UserInfo (username, firstName, lastName, password, salt, email, DoB)
VALUES ('FirstUser', 'Regan' 'Hay', 'hash', 'salt', 'rh49@hw.ac.uk', '1998-11-29');

INSERT INTO BikeInfo (bikeName, inEco)
VALUES ('BikeOne', '1');

INSERT INTO StaffInfo (username, firstName, lastName, password, salt, email, DoB, jobTitle)
VALUES ('admin', 'Admin' 'Istrator', 'hash', 'salt', 'SkedaddlAdmin@gmail.com', '2019-02-28', 'manager');

INSERT INTO StationInfo (stationName, latitude, longitude, addressLine1, addressLine2, postcode)
VALUES
('Waverley Station', '55.95201117', '-3.18945461', 'Edinburgh Waverley', 'Edinburgh', 'EH1 1BB'),
('St Andrew Square', '55.95445231', '-3.19302891', '42 St Andrew Square', 'Edinburgh', 'EH2 2AD'),
('The Mound', '55.95172524', '-3.19575404', 'The Mound', 'Edinburgh', 'EH2 2HG'),
('St Giles Cathedral', '55.94949298', '-3.19018782', '1 Parliament Square', 'Edinburgh', 'EH1 1RF'),
('Sibbald Walk', '55.95143029', '-3.18227279', '231 Canongate', 'Edinburgh', 'EH8 8DQ');

INSERT INTO StationStatus ()
VALUES ();

INSERT INTO BikesAtStations ()
VALUES ();

INSERT INTO UsersUsingBikes ()
VALUES ();

INSERT INTO FinishedRides ()
VALUES ();

INSERT INTO CurrentUserReports ()
VALUES ();

INSERT INTO SolvedUserReports ()
VALUES ();

INSERT INTO ScheduledMaintenance ()
VALUES ();

INSERT INTO CompletedMaintenance ()
VALUES ();

INSERT INTO CurrentBookings ()
VALUES ();

INSERT INTO OldBookings ()
VALUES ();
