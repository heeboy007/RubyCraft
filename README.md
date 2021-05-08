# RubyCraft
A Copy Of Minecraft... But not in c, c++, java, but in ruby! \
IDE by Aptana Studio.

The files won't execute properly if there is no ruby interpreter or no gitbash installed.\
When you try to execute, please check out the 'gemlist.txt' and see if there is anything missing from your computer.
The core gem for this program is glu,opengl.

Very important library for this game, called 'rbSFML' is used for this game.(It's not a gem library!)\
It's recommended to build and install the library by your own.\
I've posted a pre-compiled library file at past commits, but i deleted since it's not recommened. 

## Dependencies

Recommended setup is,\
[SFML](https://github.com/SFML/SFML)\
[rbSFML(SFML 2.3.2)](https://github.com/Groogy/rbSFML)\
[Ruby](http://www.ruby-lang.org/en/downloads/)\
[GIT(2.5.0.1+)](https://git-scm.com/download)\
[Rake(10.4.2+)](https://rubygems.org/gems/rake)\
[glu(8.3.0)](https://rubygems.org/gems/glu/versions/8.2.2)\
[opengl(0.10.0)](https://rubygems.org/gems/opengl/versions/0.9.2)

## How to build rbSFML by your own.
Incase you want to build the library by your own, here is some instructions.

If you already have a build of sfml, you could just skip to number 3.\
Warning! based on windows only!\
Currently tested on mingw32-MSYS and mingw 64bit versions.

1. Install Cmake.
Cmake download site : https://cmake.org/download/
'rbSFML' is kind of a wrapper library, that doesn't has the basic function.\
So what you would need is the sfml library, and it requires cmake to build one.\
(I used gui version of cmake for more accuracy.)

2. Build Sfml
SFML source download : https://www.sfml-dev.org/download.php\
Since 'rbSFML' is updated until 2.3.2 of sfml, it's recommended to use 2.3.2.\
If you don't know how to use cmake to build things, you should find it out by yourself.

3. Install Git
Recommended to use option cmd prompt command + git prompt command.\
Git Download Link is above description.

4. Install Ruby
After installing it, open a command shell, and type these :
>gem install rake\
>gem install glu\
>gem install opengl

5. Fetch rbSFML, build, install
After downloading rbSFML, you could follow the instuctions of the main page(https://github.com/Groogy/rbSFML).

6. Run! If you did setup correctly, the program will start properly.

## About Program itself...
Currently, chunk loadings and loading distance methods are working.\
And ray-tracing for block placement and removeal are implemented.\
Added pause menu, and a initial menu.

And frustrum culling for preformance.\
Also we need a map generator.

Although i've made this through, I'm still using the deprecated opengl methods.\
(Such as glRotatef or glTranslatef.)

### Snapshot

![Flat_Generation](https://user-images.githubusercontent.com/41155496/63218860-24edc080-c1a0-11e9-850a-64d09a70af1e.PNG)

## Building Executable
If you want a .exe file, necessary commands can be found on "OcraCmd.txt".\
Use the command on Git Bash at /src.\
Make sure you have the latest ocra is installed in your bash.\
No other O/S than windows are supported yet.

[Install Ocra](https://github.com/larsch/ocra/)
>gem install ocra

## License
This program is available as open source under the terms of BSD-3-Clause License.

## Copyright
Copyright(c) 2017 Kim Hi Su. See LICENSE for further details.

<table border="1">
</table>
