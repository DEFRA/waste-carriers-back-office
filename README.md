# Waste Carriers Back Office

![Build Status](https://github.com/DEFRA/waste-carriers-back-office/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-carriers-back-office&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_waste-carriers-back-office)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-carriers-back-office&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_waste-carriers-back-office)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

The 'Register or renew as a waste carrier' service allows businesses, who deal with waste and have to register according to the regulations, to register online. Once registered, businesses can sign in again to edit their registrations if needed.

The service also allows authorised agency users and NCCC staff to create and manage registrations on other users' behalf, e.g. to support 'Assisted Digital' registrations. The service provides an internal user account management facility which allows authorised administrators to create and manage other agency user accounts.

This project is the back office application which internal EA users use to manage the service and the registrations submitted.

## Prequisites

You'll need [Ruby 2.7.1](https://www.ruby-lang.org/en/) installed plus the [Bundler](http://bundler.io/) gem.

## Installation

First clone the repository and then drop into your new local repo

```bash
git clone https://github.com/defra/waste-carriers-back-office.git && cd waste-carriers-back-office
```

Next download and install the dependencies

```bash
bundle install
```

## Configuration

Any configuration is expected to be driven by environment variables when the service is run in production as per [12 factor app](https://12factor.net/config).

However when running locally in development mode or in test it makes use of the [Dotenv](https://github.com/bkeepers/dotenv) gem. This is a shim that will load values stored in a `.env` file into the environment which the service will then pick up as though they were there all along.

Check out [.env.example](/.env.example) for details of what you need in your `.env` file, and what environment variables you'll need in production.

## Running the app

Simply start the app using `bundle exec rails s`. If you are in an environment with other Rails apps running you might find the default port of 3000 is in use and so get an error.

If that's the case use `bundle exec rails s -p 8001` swapping `8001` for whatever port you want to use.

## Testing the app

The test suite is written in RSpec.

To run all the tests, use `bundle exec rspec`

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
