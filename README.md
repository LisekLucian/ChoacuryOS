<p align="center">
  <img width="450" src="https://raw.githubusercontent.com/Pineconium/ChoacuryOS/main/projectlogo.png">
</p>

[![GitHub release](https://img.shields.io/github/release/Pineconium/ChoacuryOS?include_prereleases=&sort=semver&color=blue)](https://github.com/Pineconium/ChoacuryOS/releases/)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue)](#license)
[![issues - ChoacuryOS](https://img.shields.io/github/issues/Pineconium/ChoacuryOS)](https://github.com/Pineconium/ChoacuryOS/issues)

[View documentation](https://teamchoacury.github.io/docs/)

Choacury, (pronounced as coch-curry or /kʰɔx-ˈkʌr.i/), is a custom-built operating system written in C, C++ and Assembly. Choacury is currently in a very **Pre-Alpha** stage, meaning some stuff isn't complete yet...
This is a fork of said OS. I decided to get rid of GUI and... GRUB. I implemented limine (so far multiboot1, so still x86_64) and decided that it's time for production to start moving. I'm not planning to push changes to main, but if you'd like to help the real choacury, please push changes to them and not me. You could also join their [server](https://discord.gg/qhgDWrzCvg).
![ChoacuryScreenshot](https://raw.githubusercontent.com/Pineconium/ChoacuryOS/main/choacuryscreenshot.png)

# System Requirements
For fully optimized and checked usage please use QEMU, you could do real hardware, but are you insane?

# Compiling Choacury.
If you want to compile Choacury from the source code, here's what you'll need.
1. NASM, GCC, GRUB Multiboot, Makefile, and QEMU installed. (the compiler uses the `x86_64` version of QEMU. If you don't use that version of QEMU, replace `qemu-system-x86_64` in the compiler shell script with your version of QEMU)
2. A computer running any Linux distro (recommended, but there is a batch script for Windows devices as long as you have WSL installed).
3. On a terminal with it's directory in your choacuryOS location and run 'make clean' and then 'make run'. That's it. 
4. Profit

# Contributing
Contributions are welcome, please keep it civil. Although I do recommend contributing to the REAL ChoacuryOS created by teamchoacury (lead by Pineconium).
