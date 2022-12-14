# ComfyWings
A web Application that allows users to book as well as monitor their flights. 

## Overview
ComfyWings gives you access to a wide option of flight deals from which you can choose. Not only that, we go the extra mile and give you details about the flights you will be booking, such as:
* Most recommended flights. 
* Cheapest deals or most expesive, if you're looking to spoil yourself.
* Best routes from your origin to destination and back. 

## Current goals
We hope to ease the process of booking flights by avoiding manual searches regarding deals you may be intereseted in. So, we also be providing e-mail services that will keep you updated on the current deals being offered. 

## Future goals
* Provide flight status for your friends and family to keep track of your flight.

## Plan your trip
* Collect airport details. Are considering a long period layover? not to worry, we will provide you with everything you will need to know to make your layover worthwhile.
* An itinerary will be provided after your booking is completed.


## Database

![](/assets/images/ComfyWings_DB.png)

* TripQuery

  Store users' search parameters, allowing users to share information through code.

* Currency

  Representation of currencies which followed the ISO 4217.

* Trip

  Core entity for ComfyWings, store the result of TripQuery.

* Flight

  Store information for individual flights in one trip

* Airport

  Airport information includes airport name, IATA code, city, country.
