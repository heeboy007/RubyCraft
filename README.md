# RubyCraft
A Copy Of Minecraft... But not in c, c++, java, but in ruby! 
IDE by Aptana Studio.

The files won't execute properly if there is no ruby interpreter or no gitbash installed.
When you try to execute, please check out the 'gemlist.txt' and see if there is anything missing from your computer.
The core gem of this program is glu,opengl.

Very important library for this game, called 'rbSFML' is used for this version.

It's recommended to build, install the library by your own.
But since it's a quite tricky library to build, and time-consuming job, I posted the compiled library file.

# Dependencies

Recommended setup is,\
[SFML](https://github.com/SFML/SFML)\
[rbSFML(sfml:2.3.2)](https://github.com/Groogy/rbSFML)\
[Ruby](http://www.ruby-lang.org/en/downloads/)\
[GIT(2.5.0.1+)](https://git-scm.com/download)\
[Rake(10.4.2+)](https://rubygems.org/gems/rake)\
[glu(8.3.0)](https://rubygems.org/gems/glu/versions/8.2.2)\
[opengl(0.10.0)](https://rubygems.org/gems/opengl/versions/0.9.2)\

# How to build rbSFML by your own.
Incase you want to build the library by your own, here is some instructions.

If you already have a build of sfml, you could just skip to number 3.
Warning! : Used mingw32-gcc-MSYS build, based on windows only!
1. Install Cmake.
Cmake download site : https://cmake.org/download/
'rbSFML' is kind of a wrapper library, that doesn't has the basic function.
So what you would need is the sfml library, and it requires cmake to build one.
(I used gui version of it for more accuracy.)

2. Build Sfml
SFML source download : https://www.sfml-dev.org/download.php
Since 'rbSFML' is updated until 2.3.2 of sfml, it's recommended to use 2.3.2.
If you don't know how to use cmake to build things, you should find it out by yourself.

3. Install Git 
Recommended to use option cmd prompt command + git prompt command.
Git Download Link is above description.

4. Install Ruby
After installing it, open a command shell, and type these :
>gem install rake\
>gem install glu\
>gem install opengl\

5. Fetch rbSFML, build, install
After downloading rbSFML, you could follow the instuctions of the main page(https://github.com/Groogy/rbSFML).

6. Run! If you did setup correctly, the program will start properly.

7. Install Aptana Studio(Option)
http://www.aptana.com/
If you want better workspace, highly recommend. Not neccecary, though.

# Notice!
Current version of the game has not only lots of flaws and bugs, but also very poor performance.
More than 3~4 blocks will lag your computer! 
So before you execute, BE CAREFUL!!!
