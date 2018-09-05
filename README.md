# RubyCraft
A Copy Of Minecraft... But not in c, c++, java, but in ruby! 
IDE by Aptana Studio.

The files won't execute properly if there is no ruby interpreter or no gitbash installed.
When you try to execute, please check out the 'gemlist.txt' and see if there is anything missing from your computer.
The core gem of this program is glu,opengl.

Very important library for this game, called 'rbSFML' is used for this version.
rbSFML : https://github.com/Groogy/rbSFML
It's recommended to build, install the library by your own.
But since it's a quite tricky library to build, and time-consuming job, I posted the compiled library file.

# How to build rbSFML by your own.
Incase you want to build the library by your own, here is some instructions.

If you already have a build of sfml, you could just skip to number ?.
<Used mingw32-gcc-MSYS build.>
1. Install Cmake.
Cmake download site : https://cmake.org/download/
'rbSFML' is kind of a wrapper library, that doesn't has the basic function.
So what you would need is the sfml library, and it requires cmake to build one.
(I used gui version of it for more accuracy.)

2. Build Sfml
SFML source download : https://www.sfml-dev.org/download.php
Since 'rbSFML' is updated until 2.3.2 of sfml, it's recommended to use 2.3.2.
If you don't know how to use cmake to build things, you should find it out by yourself.

3. 

# Notice!
Current version of the game has not only lots of flaws and bugs, but also very poor performance.
More than 3~4 blocks will lag your computer! 
So before you execute, BE CAREFUL!!!
