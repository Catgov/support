# Support

Forms that create Zendesk tickets for requests coming from government agencies. https://www.zendesk.com/   Callum Knights
The app is written in Rails and uses the zendesk_api gem to connect to Zendesk.
https://www.zendesk.com

#Getting Started

To start the app using `bowler`:

    bowl support

To start the app directly:

    ./startup.sh

### Starting the background processing queues

Zendesk tickets are raised in the background using a redis-backed queue called [sidekiq](http://sidekiq.org/).

To start the background workers:

    rake jobs:work

### Specs

To run the specs, execute:

    bundle exec rake
