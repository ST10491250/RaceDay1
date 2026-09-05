# RaceDay1
## System Roles

### Organiser

The Organiser is responsible for managing RaceDay events. An organiser can create events, manage event categories, view participant enrolments and record or update race results.

### Participant

The Participant can browse upcoming events, view event and category information, register for events and view their personal enrolment and performance history.

## ERD

The RaceDay ERD defines the database entities, attributes, primary keys, foreign keys and relationships required by the system.

The main entities are Users, Events, Categories, Enrollments, Results, Routes and WeatherUpdates.

## Users Entity

The Users entity stores information about RaceDay users. The Role attribute distinguishes between Organisers and Participants.

UserID is the primary key and Email is unique so that the same email address cannot be registered more than once.

## Events Entity

The Events entity stores information about running, walking and cycling events.

Each event is associated with an organiser through OrganiserID. One organiser can create many events, creating a one-to-many relationship.

## Categories Entity

The Categories entity stores the different race categories available for each event.

An event can have multiple categories. For example, an event could offer a 10 KM race and a 21.1 KM half marathon.

## Enrollments Entity

The Enrollments entity connects participants to event categories.

It records information such as the participant, category, enrolment date, registration status and race number.

This allows the system to keep track of which participants have entered which categories.

## Results Entity

The Results entity stores participant race performance.

It records information such as finish time, overall position and result status.

An enrolment can have zero or one result because a participant may be registered before completing the event.

## Routes and Weather

The Routes entity stores route information for events, including start point, finish point, distance and map information.

The WeatherUpdates entity stores weather information associated with events, including temperature, conditions, wind speed and chance of rain.

These entities support the requirement for participants to prepare for race day using route and weather information.

## Database Seed Data

The SQL script contains sample data required for the RaceDay system.

The seed data includes:

- Two Organisers
- Two Participants
- Three Events
- Categories for each event
- Sample participant enrolments
- Sample results
- Route information
- Weather information

The database script is designed for Microsoft SQL Server and can be executed using SQL Server Management Studio.

## GitHub Actions / CI/CD

GitHub Actions is used to automatically validate the RaceDay repository structure.

The workflow checks that the docs folder exists and that the required ERD, API Endpoint Plan and SQL database script are present.

A successful workflow is shown by a green build in GitHub Actions.

## Part 1 Documentation

The required planning documents are located in the `docs` folder:

- `RaceDay_ERD.png`
- `RaceDay_API_Endpoint_Plan.md`
- `RaceDay_Database.sql`

## CI/CD Validation

GitHub Actions is used to validate the RaceDay repository structure. The workflow checks that the required documentation folder and Part 1 files are present.

![Successful GitHub Actions Build](images/github-actions-success.png)
