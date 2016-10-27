# Acquire A Hire

Acquire A Hire is a Rails-based web application that allows users to post jobs and hire professionals, and allows professionals to bid on jobs.

## Installation

Acquire A Hire uses Ruby 2.3.0 and Rails 5.0.0.1. Run the command `bundle install` to install neccesary gems.  
NOTE: Do not run `bundle update`, as this will update to a version of Capistrano that is incompatible with our server.

## Deployment

To deploy Acquire A Hire, run the command `bundle exec cap production deploy`.

## Database

To create the database, run the command `rake db:{create,migrate}`. Seed data for requesters, professionals, jobs, and reviews is also included in the project. To import this data into your database, run `rake db:seed`.

## Testing

First, update the test databases with the command `rake db:test:prepare`. Following this, use the command `rspec` to run the test suite.

## API

### OAuth 2.0 Handshake
Acquire A Hire uses the OAuth 2.0 protocol to recieve a token for API requests.  
* First, register your application on Acquire A Hire. You will recieve an API key and secret.
* To authorize a user, have them make a GET request to '/api/oauth/authorize' with the parameters:
  + `api_key` (The key you recieved in step 1)
  + `redirect_url` (The url that you would like OAuth authorizations to redirect to)
* The user will then be directed to a page where they can fill in an email and password that are associated with Acquire A Hire.
* If they successfully login, they will be able to click a button to authorize your application to access their Acquire A Hire account.
* Following this, the user will be directed to the redirect path you specified earlier, with their OAuth access code as a parameter.
* Once a user has gone through these steps to be authorized, you may make a GET request to 'api/v1/oauth/token' with the parameters:
  + `api_key` (the API key for your application)
  + `secret` (the secret for your application)
  + `code` (the code that was given to a user upon authorizing the app)
  + `redirect_url` (the URL to redirect to)
* If successful, this request will return a 201 response with an access token. Otherwise, it will return a 403 response.

### API Endpoints
* To send a message, make a POST request to `/api/v1/jobs/:job_id/message.json` with the parameters:
  + `body` 
  + `subject`
  + `token`
  + `recipient_id`
* To see all messages for a user, make a GET request to `/api/v1/jobs/:job_id/messages.json` with the parameter:
  + token
* If this is successful, you will recieve a response with a status of 200 and an array of all messages for that user.

## Authors
Brendan Dillon  
Susi Irwin  
Jean Joeris  
Ryan Workman
