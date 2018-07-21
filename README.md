# bot-combat-sim

### How to run
Install [LOVE](https://love2d.org/) and call it from the root directory

### Development / TDD Setup (Linux)
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
