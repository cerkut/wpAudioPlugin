# wpAudioPlugin

Example code using MATLAB Audio System Toolbox.
See Charlie DeVane and Gabriele Bunkheila. 2016. 
Automatically Generating VST Plugins from MATLAB Code. 
https://www.mathworks.com/tagteam/89231_PluginGenerationEbriefMWFormat.pdf

Suggested order, starting with the Basic directory:

1. myWire (simple throughput)
2. myWidth (Linear mapping/matrixing of channels, single slider UI)
3. myFilePan (mixdown to mono)

SOURCE

4. myFileMix (mix with an audio file)
5. myOsc (use another audio object, accessors)
6. myModulator: AM/Ring Modulation with audioOscillator class. GUI: Checkbox. 

New Refrac (experimental):
./analysis: audio analysis routines: envelope, xcorr, etc
./hwSupport: arduino, iOS, Android, vs experiments
