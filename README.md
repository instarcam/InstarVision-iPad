InstarVision-iPad
=================

This repository contains the FFmpeg source code used for the app InstarVision. For the configuration please check the build script “build-ios.sh” in the ffmpeg folder.

The script supports:

- armv7 / armv7s
- i386 (simulator)

and generates fat libraries including the above architectures in the folder /build-ios/universal/lib and the header files in /build-ios/universal/include