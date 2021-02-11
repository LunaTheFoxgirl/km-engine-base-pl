# Base Kitsune Games engine for generic use

#### NOTE
**The assets in the assets/ folder are NOT part of the assets for the potluck**  
**They are only there to demonstate how to use the engine, please delete them once you start making your game.**

## Getting Started
To get started grab D from [here](https://dlang.org)

Open a command prompt in this folder and run `dub` to build your game, all of the game will be put in the out/ folder  
you'll have to copy assets yourself in there though once you ship your game.

See the file `source/game.d` and `source/game/package.d` for examples for using some of the various features of this engine, you can always  
ask Luna for more indepth knowledge.

As well I highly recommend checking out the [D tour](https://tour.dlang.org)

## Dependencies
The Kitsunemimi engine requires the following dependencies to be present to work:
 * OpenAL Driver ([OpenAL-Soft included on Windows](https://github.com/kcat/openal-soft))
 * OpenGL Driver
 * SDL2 2.0.12 or above
 * libogg
 * libvorbis
 * libvorbisfile
 * FreeType
 * Kosugi Maru Font (in [`res/fonts`](/res/fonts) w/ license)
 * PixelMPlus 10 Font (in [`res/fonts`](/res/fonts) w/ license)

On Windows these libraries are copied from the included libs/ folder.