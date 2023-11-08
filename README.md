MATLAB audio plugins from scratch
================

Example code buiusing MATLAB Audio System Toolbox.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=cerkut/wpAudioPlugin)

Initially based on Charlie DeVane and Gabriele Bunkheila. 2016.  
Automatically Generating VST Plugins from MATLAB Code.  
https://www.mathworks.com/tagteam/89231_PluginGenerationEbriefMWFormat.pdf

Check also MATLAB Audio Plugin Example Gallery at 
https://mathworks.com/help/audio/ug/audio-plugin-example-gallery.html

Suggested order, starting with the [[./01-Basics]] directory:

1. myWire (simple throughput)
2. myWidth (Linear mapping/matrixing of channels, single slider UI)
3. myFilePan (mixdown to mono)

and then the rest of the subdirectory. 

A Live Script .mlx (and its source .m script) are also provided.

In [[./02-Sources]], we inherit 

4. myFileMix (mix with an audio file)
5. myOsc (use another audio object, accessors)
6. myModulator: AM/Ring Modulation with audioOscillator class. GUI: Checkbox. 

New Refrac (experimental):
./analysis: audio analysis routines: envelope, xcorr, etc
./hwSupport: arduino, iOS, Android, vs experiments

* PROJECT

** CANCELLED Add colored noise source plugins: 
   Avaliable as a source at audioTestBench using =dsp.ColoredNoise=


