**libcef-arm**

This is a Unix Makefile for cross compiling libcef build 3440 for ARM from Google sources.
It creates an environment for chromium development in Linux x64 (Raspbian Desktop).
It allows different branches of cef, chromium and depot_tools to be combined together and built into a library for other applications which require an embedded browser.

You'll need a stable internet connection and at least 40GB of free hard drive space.
Additional dependencies may be required, such as gcc-arm-linux-gneabihf and g++-8-multilib-arm-linux-gnueabihf.
Administrator Priviledges are required. Enter "sudo make" into the terminal.

Useful Links:
 - [https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding]
 - [https://github.com/chromiumembedded/cef/]
 - [https://opensource.spotify.com/cefbuilds/index.html#linuxarm_builds]

The script is a work in progress. To contribute, please fork this git repository and make changes locally.
I hope you find this useful - Alastair Cota
