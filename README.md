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

Acquire A Hire uses the OAuth 2.0 protocol to recieve a token for API requests. [Full API Documentation](./public/apidocs/api/v1/api-docs.json)

## Authors
Brendan Dillon  
Susi Irwin  
Jean Joeris  
Ryan Workman
