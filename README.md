---
title: CodePath Capstone Project

---

Original App Design Project - README Template
===

# Wait Time

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Wait Time is an app that displays the current wait time of MARTA trains at a selected station. the app will display the the wait time for each direction as well as indicate which rail line the train is on.

<div>
    <a href="https://www.loom.com/share/4498c2ee7b7548b1aee2671b994203b3">
    </a>
    <a href="https://www.loom.com/share/4498c2ee7b7548b1aee2671b994203b3">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/4498c2ee7b7548b1aee2671b994203b3-631d295d409f13f3-full-play.gif">
    </a>
  </div>

### App Evaluation

[Evaluation of your app across the following attributes]
- **Category:** Travel
- **Mobile:** since you will need to check the schedules on the go a mobile app is perfect when traveling through public transportation
- **Story:** Just as any driver checks their GPS to see how long it would take to get to their destination this app will help students keep in mind the wait time of the MARTA to fully plan their trip.

- **Market:** Students or Atlanta residents using the MARTA.
- **Habit:** Students will be checking the app everytime they are waiting for the train or heading to the station just as drivers check ETA when driving. 
- **Scope:** Version 1 will show all train stations and display the wait time for the two closest trains for each rail line and in which direction they are heading. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Call API and recieve JSON
* Create Tab view to display stations
* User can tap station for detailed view

**Optional Nice-to-have Stories**

* User can see what station is closest to them
* User can save favorite stations

### 2. Screen Archetypes

- [x] Stream
* User can see all rail stations
* User can see wait times for the two closest trains
- [x] Detail
* User can see wait times for the two closest trains
* User can save favorite stations

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home View
* Station Detailed View

**Flow Navigation** (Screen to Screen)

- [x] Home View
* => Station Detailed View
- [x] Station Detailed View
* => Home View

## Wireframes

<img src="https://github.com/user-attachments/assets/2df8f9bf-ecfb-49a9-a5a9-42e9b6591bb2" width=600>


## Schema 

### Models
| Model Name     | Properties                                                                                 | Description                                  |
|----------------|---------------------------------------------------------------------------------------------|----------------------------------------------|
| `TrainArrival` | `destination: String`<br>`direction: String`<br>`line: String`<br>`station: String`<br>`waitingTime: String`<br>`waitingSeconds: String`<br>`nextArrival: String`<br>`trainId: String` | Represents a single train's ETA and metadata |
| `StationInfo`  | `name: String`<br>`arrivalsByLine: [String: [TrainArrival]]`                               | Grouped train arrivals by line at a station  |

### Networking

- MARTA Real-Time Rail Arrivals API
- Requests per screen 

| Screen                   | API Requests                                                                 |
|--------------------------|------------------------------------------------------------------------------|
| Home (Station List)      | Fetch all train arrivals → group by station and line                        |
| Station Detail View      | Filter and sort arrivals by direction and destination for selected station  |

- EndPoints: GET https://developerservices.itsmarta.com:18096/itsmarta/railrealtimearrivals/developerservices/traindata?apiKey=YOUR_API_KEY
