% Test bench script for 'myEchoPlugin'.
% Generated by Audio Test Bench on 30-Mar-2019 09:00:24 +0100.

% Create test bench input and output
fileReader = dsp.AudioFileReader('Filename','SoftGuitar-44p1_mono-10mins.ogg', ...
    'PlayCount',1, ...
    'SamplesPerFrame',512);
deviceWriter = audioDeviceWriter('Device','Default', ...
    'SampleRate',fileReader.SampleRate);

% Create scopes
timeScope = dsp.TimeScope('SampleRate',44100, ...
    'TimeSpan',1, ...
    'TimeSpanOverrunAction','Scroll', ...
    'AxesScaling','Manual', ...
    'BufferLength',176400, ...
    'ShowLegend',true, ...
    'ChannelNames',{'Input channel 1','Output channel 1'}, ...
    'ShowGrid',true, ...
    'YLimits',[-1 1]);
specScope = dsp.SpectrumAnalyzer('SampleRate',44100, ...
    'PlotAsTwoSidedSpectrum',false, ...
    'FrequencyScale','Log', ...
    'ShowLegend',true, ...
    'ChannelNames',{'Input channel 1','Output channel 1'}, ...
    'YLimits',[-215.8713145430647 33.544187563831926]);


% Set up the system under test
sut = myEchoPlugin;
setSampleRate(sut,fileReader.SampleRate);
sut.Gain = 1.48747;

% Open parameterTuner for interactive tuning during simulation
tuner = parameterTuner(sut);

% Stream processing loop
nUnderruns = 0;
while ~isDone(fileReader)
    % Read from input, process, and write to output
    in = fileReader();
    in = repmat(in,1,2);
    out = process(sut,in);
    nUnderruns = nUnderruns + deviceWriter(out);
    
    % Visualize input and ouput data in scopes
    timeScope([in(:,1),out(:,1)]);
    specScope([in(:,1),out(:,1)]);
    
    % Process parameterTuner callbacks
    drawnow limitrate
end

% Clean up
release(fileReader)
release(deviceWriter)
release(timeScope)
release(specScope)
