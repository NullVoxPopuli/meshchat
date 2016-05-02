#Meshchat (Ruby) [![Build Status](https://travis-ci.org/NullVoxPopuli/meshchat.svg)](https://travis-ci.org/NullVoxPopuli/meshchat) [![Code Climate](https://codeclimate.com/github/NullVoxPopuli/meshchat/badges/gpa.svg)](https://codeclimate.com/github/NullVoxPopuli/meshchat) [![Test Coverage](https://codeclimate.com/github/NullVoxPopuli/meshchat/badges/coverage.svg)](https://codeclimate.com/github/NullVoxPopuli/meshchat/coverage)

This is the core functionality for implementing a [mesh-chat](https://github.com/neuravion/mesh-chat) compatible client in ruby

[Documentation](http://nullvoxpopuli.github.io/meshchat/)

#Usage



See [Spiced Rumby](https://github.com/NullVoxPopuli/spiced_rumby)

In order to use meshchat with your own interface, you only need to pass in your own implementations of `Display::Base` and `CLI::Base`

Optionally, you may pass in a notifier to have the mesh-chat trigger notifications for your system

TODO: update all this, as it's not correct anymore
```ruby
Meshchat.start(
  client_name: NAME, # name of your client
  client_version: VERSION, # version of your client
  display: ui, # your class implementing `Display::Base`
  input: input, # your class implementing `CLI::Base`
  notifier: notifier, # your class implementing `Notifier::Base`
  on_display_start: ->{ Meshchat::CLI.check_startup_settings } # optional
)
```


# Development

### Running

```bash
./run
```

### Tests

```bash
rspec
```

### Line Count

```bash
loco
```
