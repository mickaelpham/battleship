[![Build Status](https://travis-ci.org/mickaelpham/battleship.svg?branch=master)](https://travis-ci.org/mickaelpham/battleship)

# Battleship

A classic guessing game for two players.

## Installation

```sh
git clone https://github.com/mickaelpham/battleship
bundle install
gem build battleship.gemspec
gem install battleship-0.1.0.gem
```

This should take care of installing the `battleship` executable in your `PATH`,
allowing you to start a new game from the shell:

```
$ battleship
```

## Screenshots

Welcome screen

![screen-01](/img/screen-01.png?raw=true "Welcome screen")

Players prompt

![screen-02](/img/screen-02.png?raw=true "Players prompt")

Ship positioning

![screen-03](/img/screen-03.png?raw=true "Ship positioning")

Strike result

![screen-04](/img/screen-04.png?raw=true "Strike result")

Last strike

![screen-05](/img/screen-05.png?raw=true "Last strike")

Winning screen

![screen-06](/img/screen-06.png?raw=true "Winning screen")

## Development

```sh
git clone https://github.com/mickaelpham/battleship
cd battleship
bundle install
bin/console
```

Then, within the Pry console:

```ruby
Battleship::Game.new
```
