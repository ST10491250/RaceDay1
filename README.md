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
