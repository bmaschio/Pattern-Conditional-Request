A simple [Jolie](https://jolie-lang.org) implementation of the [API Conditional Request Pattern](https://microservice-api-patterns.org/patterns/quality/dataTransferParsimony/ConditionalRequest).

## Story
You have a service Leonardo that is the standard Jolie webserver embedding the service frontend that implements the logic for the Conditional Request 
Using the [courier](https://jolielang.gitbook.io/docs/architectural-composition/couriers) we can intercept the request to any of the webserver resources and apply the ETag check.
