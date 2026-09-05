# RaceDay – Part 1: API Endpoint Plan

This plan is designed to cover the required RaceDay functionality before implementation. The routes use the `/api/` prefix and are intended for a REST-style API.
 
| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
|POST|/api/auth/register|Creates a new participant or organiser account.|Public|fullName, email, password, role, phone, dateOfBirth|201 Created; 400 Bad Request if validation fails or email exists.|
|POST|/api/auth/login|Authenticates a user and returns an access token.|Public|email, password|200 OK with token and user profile; 401 Unauthorized for invalid credentials.|
|GET|/api/profile|Returns the logged-in user's profile.|Participant or Organiser|None|200 OK with profile details; 401 Unauthorized if not authenticated.|
|PUT|/api/profile|Updates the logged-in user's profile.|Participant or Organiser|fullName, phone, dateOfBirth|200 OK with updated profile; 400 Bad Request for invalid data.|
|GET|/api/events|Lists upcoming events with optional filters.|Public|None; optional query parameters such as type/location/date|200 OK with event list.|
|GET|/api/events/{eventId}|Returns details for one event, including categories and route information.|Public|None|200 OK with event details; 404 Not Found if event does not exist.|
|POST|/api/events|Creates a new event.|Organiser|eventName, eventType, eventDate, location, description|201 Created with new event; 400 Bad Request for invalid data.|
|PUT|/api/events/{eventId}|Updates an event owned by the organiser.|Organiser|Fields to update|200 OK with updated event; 403 Forbidden if not owner; 404 Not Found if missing.|
|DELETE|/api/events/{eventId}|Cancels/removes an event owned by the organiser.|Organiser|None|204 No Content; 403 Forbidden or 404 Not Found where applicable.|
|GET|/api/events/{eventId}/categories|Lists categories for an event.|Public|None|200 OK with category list; 404 Not Found if event does not exist.|
|POST|/api/events/{eventId}/categories|Adds a category to an event.|Organiser|categoryName, distanceKM, entryFee, maxParticipants|201 Created; 400 Bad Request for invalid data.|
|PUT|/api/categories/{categoryId}|Updates a category.|Organiser|categoryName, distanceKM, entryFee, maxParticipants|200 OK with updated category; 403 Forbidden or 404 Not Found where applicable.|
|DELETE|/api/categories/{categoryId}|Deletes a category that has no active enrolments.|Organiser|None|204 No Content; 409 Conflict if the category is in use.|
|POST|/api/events/{eventId}/enrollments|Registers the logged-in participant for an event category.|Participant|categoryId|201 Created with enrolment and race number; 400/409 if registration is invalid or duplicated.|
|GET|/api/enrollments/me|Lists the logged-in participant's event enrolments.|Participant|None|200 OK with enrolment history.|
|GET|/api/events/{eventId}/enrollments|Lists participants enrolled in an organiser's event.|Organiser|None|200 OK with enrolment list; 403 Forbidden if not event owner.|
|DELETE|/api/enrollments/{enrollmentId}|Cancels the logged-in participant's enrolment.|Participant|None|204 No Content; 404 Not Found if enrolment does not exist.|
|POST|/api/events/{eventId}/results|Records race results for an event.|Organiser|enrollmentId, finishTime, positionOverall, resultStatus|201 Created; 400 Bad Request for invalid result data.|
|GET|/api/events/{eventId}/results|Returns results for an event.|Public|None|200 OK with ordered result list.|
|GET|/api/results/me|Returns the logged-in participant's personal performance history.|Participant|None|200 OK with result history.|
|PUT|/api/results/{resultId}|Corrects or updates a result.|Organiser|finishTime, positionOverall, resultStatus|200 OK with updated result; 403 Forbidden or 404 Not Found where applicable.|
|GET|/api/events/{eventId}/route|Returns route information for an event.|Public|None|200 OK with route details/map URL; 404 Not Found if no route exists.| 
|GET|/api/events/{eventId}/weather|Returns the latest weather information for an event.|Public|None|200 OK with temperature, conditions, wind and rain chance; 404 Not Found if unavailable.| 
