classdef myEcho < audioPlugin
%Echo Add echo effect to an audio signal.
%
%   ECHO = myEcho() returns an object ECHO with properties set to their default values.
%
%   Echo methods:
%
%   Y = process(ECHO, X) adds echo effect to the audio input X based on the
%   properties specified in the object ECHO and returns it as output Y.
%   Each column of X is treated as individual input channels.
%
%   Echo properties:
%
%   Delay         - Base delay in seconds
%   Gain          - Amplitude gain 
%   FeedbackLevel - Feedback gain 
%   WetDryMix     - Wet to dry signal ratio
%
%   See also: audiopluginexample.Chorus, audiopluginexample.Flanger

%   Copyright 2015-2016 The MathWorks, Inc.
%#codegen
    
    properties
        %Delay Base delay (s)
        %   Specify the base delay for echo effect as positive scalar
        %   value in seconds. Base delay value must be in the range between
        %   0 and 1 seconds. The default value of this property is 0.5.
        Delay = 0.5
        
        %Gain Gain of delay branch
        %   Specify the gain value as a positive scalar. This value must be
        %   in the range between 0 and 1. The default value of this
        %   property is 0.5.
        Gain = 0.5
    end
       
    properties (Dependent)
        %FeedbackLevel Feedback gain
        %   Specify the feedback gain value as a positive scalar. This
        %   value must range from 0 to 0.5. Setting FeedbackLevel to 0
        %   turns off the feedback. The default value of this property is
        %   0.35.
        FeedbackLevel = 0.35
    end
        
    properties
        %WetDryMix Wet/dry mix
        %   Specify the wet/dry mix ratio as a positive scalar. This value
        %   ranges from 0 to 1. For example, for a value of 0.6, the ratio
        %   will be 60% wet to 40% dry signal (Wet - Signal that has effect
        %   in it. Dry - Unaffected signal).  The default value of this
        %   property is 0.5.
        WetDryMix = 0.5
    end
    
    properties (Constant)
        % audioPluginInterface manages the number of input/output channels
        % and uses audioPluginParameter to generate plugin UI parameters.
        PluginInterface = audioPluginInterface(...
            'InputChannels',2,...
            'OutputChannels',2,...
            'PluginName','myEcho',...
            'VendorName', 'cer@create.aau.dk', ...
            'VendorVersion', '3.1.4', ...
            'UniqueId', '4pvz',...
            audioPluginParameter('Delay','DisplayName','Base delay','Label','s','Mapping',{'lin',0 1}),...
            audioPluginParameter('Gain','DisplayName','Gain','Label','','Mapping',{'lin',0 1}),...
            audioPluginParameter('FeedbackLevel','DisplayName','Feedback','Label','','Mapping',{'lin', 0 0.5}),...
            audioPluginParameter('WetDryMix','DisplayName','Wet/dry mix','Label','','Mapping',{'lin',0 1}));
    end
    
    properties (Access = private)        
        %pFractionalDelay DelayFilter object for fractional delay with linear interpolation
        pFractionalDelay
        
        %pSR Sample rate
        pSR
    end
    
    methods
        %% Constructor initializes both private properties
        function obj = myEcho()
            fs = getSampleRate(obj);
            obj.pFractionalDelay = audioexample.DelayFilter( ...
                'FeedbackLevel', 0.35, ...
                'SampleRate', fs);
            obj.pSR = fs;
        end
        
        %% Accessors for Feedback Level (Dependent property)
        function set.FeedbackLevel(obj, val)
            obj.pFractionalDelay.FeedbackLevel = val;
        end
        function val = get.FeedbackLevel(obj)
            val = obj.pFractionalDelay.FeedbackLevel;
        end
        
        %% reset to initialize 
        function reset(obj)
            % Reset sample rate
            fs = getSampleRate(obj);
            obj.pSR = fs;
            
            % Reset delay
            obj.pFractionalDelay.SampleRate = fs;
            reset(obj.pFractionalDelay);
        end
        
        %% PROCESS
        function y = process(obj, x)
            delayInSamples = obj.Delay*obj.pSR;
            
            % Delay the input
            xd = obj.pFractionalDelay(delayInSamples, x);
            
            % Calculate output by adding wet and dry signal in appropriate
            % ratio
            mix = obj.WetDryMix;
            y = (1-mix)*x + (mix)*(obj.Gain.*xd);
        end

    end
end