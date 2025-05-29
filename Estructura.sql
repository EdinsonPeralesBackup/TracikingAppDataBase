--DROP TABLE TrackingBD

--CREATE DATABASE TrackingBD;

--USE TrackingBD

CREATE TABLE [ROLE]
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100),
	[State] BIT,
	CreatedBy INT,
	CreateAt DATETIME,
	UpdateBy INT,
	UpdateAt DATETIME,
	DeleteBy INT,
	DeleteAt DATETIME,
	CONSTRAINT pk_role
		PRIMARY KEY (Id)
)

CREATE TABLE [USER]
(
	Id INT IDENTITY(1,1),
	Phone VARCHAR(10),
	[Password] VARCHAR(MAX),
	IdRole INT,
	CreatedBy INT,
	CreateAt DATETIME,
	UpdateBy INT,
	UpdateAt DATETIME,
	DeleteBy INT,
	DeleteAt DATETIME,
	[State] BIT,
	Token VARCHAR(MAX),
	CONSTRAINT pk_user
		PRIMARY KEY (Id),
	CONSTRAINT fk_user_role
		FOREIGN KEY (IdRole)
		REFERENCES [ROLE](Id)
)

CREATE TABLE [USER_PROFILE]
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100),
	LastName VARCHAR(300),
	Birthday DATE,
	[State] BIT,
	IdUser INT,
	CONSTRAINT pk_user_profile
		PRIMARY KEY (Id),
	CONSTRAINT fk_user_profilexuser
		FOREIGN KEY (IdUser)
		REFERENCES [User](Id)
)

CREATE TABLE [ROUTE]
(
	Id INT IDENTITY(1,1),
	Tracking_id VARCHAR(10),
	Origin_latitud DECIMAL(10,4),
	Origin_longitude DECIMAL(10,4),
	Destination_latitud DECIMAL(10,4),
	Destination_longitude DECIMAL(10,4),
	Checkpoint_interval INT,
	IdUser INT,
	IdRoute_calibrated INT,
	CONSTRAINT pk_route
		PRIMARY KEY (Id),
	CONSTRAINT fk_route_user
		FOREIGN KEY (IdUser)
		REFERENCES [User](Id),
	CONSTRAINT fk_routeXroute_calibrated
		FOREIGN KEY (IdRoute_calibrated)
		REFERENCES [ROUTE](Id),
)

CREATE TABLE POINT
(
	Id INT IDENTITY(1,1),
	Latitud DECIMAL(10,4),
	Longitude DECIMAL(10,4),
	[Timestamp] DATETIME,
	IsValid CHAR(1),
	IdRoute INT,
	CONSTRAINT pk_point
		PRIMARY KEY (Id),
	CONSTRAINT fk_pointXroute
		FOREIGN KEY (IdRoute)
		REFERENCES [ROUTE](Id),
)

CREATE TABLE TRUSTED_CONTACT
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100),
	Lastname VARCHAR(300),
	Phone VARCHAR(10),
	[State] BIT,
	IdUser INT,
	CreatedBy INT,
	CreateAt DATETIME,
	UpdateBy INT,
	UpdateAt DATETIME,
	DeleteBy INT,
	DeleteAt DATETIME,
	CONSTRAINT pk_trusted_contacts
		PRIMARY KEY (Id),
	CONSTRAINT fk_trusted_contactsXUser
		FOREIGN KEY (IdUser)
		REFERENCES [User](Id),
)

CREATE TABLE ALERT
(
	Id INT IDENTITY(1,1),
	IsSafe BIT,
	Latitude DECIMAL(10,4),
	Longitude DECIMAL(10,4),
	[Timestamp] DATETIME,
	IdRoute INT,
	CONSTRAINT pk_alert
		PRIMARY KEY (Id),
	CONSTRAINT fk_alertXRoute
		FOREIGN KEY (IdRoute)
		REFERENCES [ROUTE](Id)
)

CREATE TABLE ALERTXTRUSTED_CONTACTS
(
	Id INT IDENTITY(1,1),
	[Message] VARCHAR(500),
	IdAlert INT,
	IdTrusted_Contacts INT,
	CONSTRAINT pk_alertxtrusted_contacts
		PRIMARY KEY (Id),
	CONSTRAINT fk_alertxtrusted_contactsXAlert
		FOREIGN KEY (IdAlert)
		REFERENCES ALERT(Id),
	CONSTRAINT fk_alertxtrusted_contactsXTrusted_contacts
		FOREIGN KEY (IdTrusted_Contacts)
		REFERENCES TRUSTED_CONTACT(Id)
)

CREATE TABLE CODE_RESET
(
	Id INT IDENTITY(1,1),
	Code VARCHAR(10),
	[State] BIT,
	IdUser INT,
	CONSTRAINT pk_code_reset
		PRIMARY KEY (Id),
	CONSTRAINT fk_code_resetXUser
		FOREIGN KEY (IdUser)
		REFERENCES [USER](Id)
)