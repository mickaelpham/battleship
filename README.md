# Battleship

A classic guessing game for two players.

## Screenshots

Prompt for placing a ship on the grid:
![screen-01](/img/screen-01.png?raw=true "Ship placing prompt")

Prompt a player for a target to strike:
![screen-02](/img/screen-02.png?raw=true "Strike prompt")

## Installation

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
