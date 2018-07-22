# bot-combat-sim

This is a framework for pitting AIs against each other in squad combat.

AIs are given knowledge of their bot's position, their opponents' / teammates' position, and the change in time since last update


## Example
![bot combat](misc/2v2.gif)

## Todo
Give AIs visibility to projectiles so they can dodge

Add validation for AI's starting stats (speed / firing rate / damage). AIs should have a maximum number of points to apply across their starting stats, but currently they have no limits.

Add special projectile abilities (damage over time, heal allies, slow target, etc)

Consider opening issues for these instead of having a todo list

## How to run
Install [LOVE](https://love2d.org/) and call it from the root directory (`love .`)

## How to create an AI
The [Random AI](src/ai/Random.lua) is an example of how to create an AI.

AIs must provide initial conditions (speed, health, firing rate) as well as a projectile effect (currently, the only effect is "Damage").

Every time the game state is updated, your AI will be called with the list of bots, your active bot's index in that list, and the change in time since the last update.

Once your AI is created, place it in [config.lua](src/ai/config.lua) to try it out!

### Explanation of initial conditions
Speed: Movement speed of your bots

Health: Damage that your bots can take before they are destroyed

Firing rate: Speed at which your bot can fire per second

Effect: Type of effect that is applied when your bot's projectile hits a target

Effect power: Strength of the effect

## Development / TDD Setup (Linux)
Install lenv (https://github.com/mah0x211/lenv)

Setting up dependencies and TDD:
```
lenv fetch
lenv install-lj 2.0.5
lenv use-lj 2.0.5
sudo apt install luarocks
sudo luarocks install mach
sudo luarocks install busted
```

Running TDD:
`busted .`
