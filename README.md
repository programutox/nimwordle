# Nim Wordle

> Wordle game using Nim

## Why did you make this game?

I wanted to learn quickly Nim and make a game with it.
I chose Nim for its simple syntax and its various backends' support, and used [naylib](https://github.com/planetis-m/naylib) library since I'm already familiar with raylib.

## Where can I play it

You can find the game [here](https://programutox.itch.io/nim-wordle).

## How did you get all those words?

You can find the French words file [here](https://www.freelang.com/dictionnaire/dic-francais.php),
and the English one [there](https://github.com/dwyl/english-words).

## Setup

Install naylib : `nimble install naylib`

### For desktop

Simply use `make`, or `make check` if you don't need to run the game. Note that the output will be in debug mode.

You can turn it into release mode using `-d:release` parameter, but keep in mind that compilation-time will be longer.

### For Web

Install emscripten :

```
# On Debian, Ubuntu, Linux Mint, etc.
sudo apt install emscripten

# On Arch Linux, Manjaro
sudo pacman -S emscripten
```

Make sure you have direct access to `emcc`.
On Arch Linux or Manjaro, you may need to add this line to the `~/.bashrc` file : 

`export PATH=$PATH:/usr/lib/emscripten`

Note that the files needed for the web compilation are [config.nims](./config.nims), [index.html](./index.html) and [Makefile](./Makefile). Also, do not rename `resources` folder, otherwise you won't be able to preload the resources files.

Thanks to the latter, you can use the `make release` command. It will create a `web` folder containing all the generated files (you need to use `make` before `make release`, as emscripten seems to need the desktop executable).

To run the web game, go to the `web` folder and type :

`python3 -m http.server`

Then click on the shown link.
