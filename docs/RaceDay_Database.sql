/* ============================================================
   RaceDay - Part 1 - Section C
   SQL Server database schema and seed data
   ============================================================ */

IF DB_ID('RaceDay') IS NULL
    CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

/* Drop tables in dependency order so the script can be re-run */
IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrollments', 'U') IS NOT NULL DROP TABLE dbo.Enrollments;
IF OBJECT_ID('dbo.WeatherUpdates', 'U') IS NOT NULL DROP TABLE dbo.WeatherUpdates;
IF OBJECT_ID('dbo.Routes', 'U') IS NOT NULL DROP TABLE dbo.Routes;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Users_Role CHECK (Role IN ('Organiser', 'Participant')),
    Phone NVARCHAR(20) NULL,
    DateOfBirth DATE NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    EventType NVARCHAR(30) NOT NULL
        CONSTRAINT CK_Events_EventType CHECK (EventType IN ('Running', 'Walking', 'Cycling')),
    EventDate DATE NOT NULL,
    Location NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Upcoming'
        CONSTRAINT CK_Events_Status CHECK (Status IN ('Upcoming', 'Open', 'Completed', 'Cancelled')),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserID) REFERENCES dbo.Users(UserID)
);
GO

CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    DistanceKM DECIMAL(6,2) NOT NULL
        CONSTRAINT CK_Categories_Distance CHECK (DistanceKM > 0),
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0
        CONSTRAINT CK_Categories_EntryFee CHECK (EntryFee >= 0),
    MaxParticipants INT NULL
        CONSTRAINT CK_Categories_MaxParticipants CHECK (MaxParticipants IS NULL OR MaxParticipants > 0),
    CONSTRAINT UQ_Categories_Event_Name UNIQUE (EventID, CategoryName),
    CONSTRAINT FK_Categories_Event
        FOREIGN KEY (EventID) REFERENCES dbo.Events(EventID)
);
GO

CREATE TABLE dbo.Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrollmentDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Registered'
        CONSTRAINT CK_Enrollments_Status CHECK (Status IN ('Registered', 'Paid', 'Cancelled')),
    RaceNumber INT NULL,
    CONSTRAINT UQ_Enrollments_Participant_Category UNIQUE (ParticipantID, CategoryID),
    CONSTRAINT FK_Enrollments_Participant
        FOREIGN KEY (ParticipantID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Enrollments_Category
        FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID)
);
GO

CREATE TABLE dbo.Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    PositionOverall INT NULL
        CONSTRAINT CK_Results_Position CHECK (PositionOverall IS NULL OR PositionOverall > 0),
    ResultStatus NVARCHAR(20) NOT NULL DEFAULT 'Finished'
        CONSTRAINT CK_Results_Status CHECK (ResultStatus IN ('Finished', 'DNF', 'DNS')),
    RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Results_Enrollment
        FOREIGN KEY (EnrollmentID) REFERENCES dbo.Enrollments(EnrollmentID)
);
GO

CREATE TABLE dbo.Routes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL UNIQUE,
    RouteName NVARCHAR(150) NOT NULL,
    StartPoint NVARCHAR(150) NOT NULL,
    FinishPoint NVARCHAR(150) NOT NULL,
    DistanceKM DECIMAL(6,2) NOT NULL
        CONSTRAINT CK_Routes_Distance CHECK (DistanceKM > 0),
    MapURL NVARCHAR(500) NULL,
    ElevationGainM INT NULL
        CONSTRAINT CK_Routes_Elevation CHECK (ElevationGainM IS NULL OR ElevationGainM >= 0),
    CONSTRAINT FK_Routes_Event
        FOREIGN KEY (EventID) REFERENCES dbo.Events(EventID)
);
GO

CREATE TABLE dbo.WeatherUpdates (
    WeatherID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TemperatureC DECIMAL(5,2) NULL,
    Conditions NVARCHAR(100) NULL,
    WindSpeedKPH DECIMAL(6,2) NULL
        CONSTRAINT CK_Weather_Wind CHECK (WindSpeedKPH IS NULL OR WindSpeedKPH >= 0),
    RainChancePercent INT NULL
        CONSTRAINT CK_Weather_Rain CHECK (RainChancePercent IS NULL OR RainChancePercent BETWEEN 0 AND 100),
    CONSTRAINT FK_Weather_Event
        FOREIGN KEY (EventID) REFERENCES dbo.Events(EventID)
);
GO

/* =========================
   Seed data
   Minimum required:
   - 2 organisers
   - 2 participants
   - 3 events
   - categories for each event
   - sample enrolments
   ========================= */

INSERT INTO dbo.Users
    (FullName, Email, PasswordHash, Role, Phone, DateOfBirth)
VALUES
    ('Thabo Mokoena', 'thabo.organiser@raceday.co.za', 'HASH_DEMO_001', 'Organiser', '0825551001', '1985-04-12'),
    ('Lerato Naidoo', 'lerato.organiser@raceday.co.za', 'HASH_DEMO_002', 'Organiser', '0835551002', '1988-09-23'),
    ('Sipho Dlamini', 'sipho.participant@raceday.co.za', 'HASH_DEMO_003', 'Participant', '0845551003', '2001-02-14'),
    ('Amahle Ndlovu', 'amahle.participant@raceday.co.za', 'HASH_DEMO_004', 'Participant', '0855551004', '1999-11-08');
GO

INSERT INTO dbo.Events
    (OrganiserID, EventName, EventType, EventDate, Location, Description, Status)
VALUES
    (1, 'Johannesburg City Run', 'Running', '2026-10-18', 'Johannesburg, Gauteng',
     'Road running event for community and competitive runners.', 'Open'),
    (2, 'Cape Town Coastal Cycle', 'Cycling', '2026-11-08', 'Cape Town, Western Cape',
     'Coastal cycling event with scenic road sections.', 'Open'),
    (1, 'Soweto Community Walk', 'Walking', '2026-12-06', 'Soweto, Gauteng',
     'Community walking event supporting healthy living.', 'Upcoming');
GO

INSERT INTO dbo.Categories
    (EventID, CategoryName, DistanceKM, EntryFee, MaxParticipants)
VALUES
    (1, '10 KM Open', 10.00, 180.00, 1500),
    (1, '21.1 KM Half Marathon', 21.10, 280.00, 1000),
    (2, '40 KM Cycle', 40.00, 350.00, 1200),
    (2, '80 KM Cycle', 80.00, 500.00, 800),
    (3, '5 KM Community Walk', 5.00, 80.00, 2000),
    (3, '10 KM Fitness Walk', 10.00, 120.00, 1200);
GO

INSERT INTO dbo.Enrollments
    (ParticipantID, CategoryID, Status, RaceNumber)
VALUES
    (3, 1, 'Paid', 101),
    (3, 3, 'Registered', 205),
    (4, 2, 'Paid', 102),
    (4, 5, 'Registered', 301);
GO

INSERT INTO dbo.Results
    (EnrollmentID, FinishTime, PositionOverall, ResultStatus)
VALUES
    (1, '00:48:32', 15, 'Finished'),
    (3, '01:52:17', 22, 'Finished');
GO

INSERT INTO dbo.Routes
    (EventID, RouteName, StartPoint, FinishPoint, DistanceKM, MapURL, ElevationGainM)
VALUES
    (1, 'Johannesburg City 10K Route', 'Mary Fitzgerald Square', 'Mary Fitzgerald Square', 10.00,
     'https://example.com/raceday/jhb-10k', 120),
    (2, 'Cape Town Coastal 40K Route', 'Green Point', 'Green Point', 40.00,
     'https://example.com/raceday/ct-40k', 450),
    (3, 'Soweto Community 5K Route', 'Walter Sisulu Square', 'Walter Sisulu Square', 5.00,
     'https://example.com/raceday/soweto-5k', 60);
GO

INSERT INTO dbo.WeatherUpdates
    (EventID, TemperatureC, Conditions, WindSpeedKPH, RainChancePercent)
VALUES
    (1, 22.50, 'Partly cloudy', 14.00, 20),
    (2, 19.00, 'Sunny', 18.00, 10),
    (3, 24.00, 'Clear', 9.00, 15);
GO

/* Quick verification queries */
SELECT * FROM dbo.Users;
SELECT * FROM dbo.Events;
SELECT * FROM dbo.Categories;
SELECT * FROM dbo.Enrollments;
SELECT * FROM dbo.Results;
SELECT * FROM dbo.Routes;
SELECT * FROM dbo.WeatherUpdates;
GO
