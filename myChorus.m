classdef myChorus < audioPlugin
%Chorus Add chorus effect to an audio signal.
%
%   CHORUS = audiopluginexample.Chorus() returns an object CHORUS with
%   properties set to their default values.
%
%   Chorus methods:
%
%   Y = process(CHORUS, X) adds chorus effect to the audio input X based on
%   the properties specified in the object CHORUS and returns it as output
%   Y. Each column of X is treated as individual input channels.
%
%   Chorus properties:
%
%   Delay       - Base delay in seconds
%   Depth1      - Amplitude of first sine wave modulator
%   Rate1       - Frequency of first sine wave modulator
%   Depth2      - Amplitude of second sine wave modulator
%   Rate2       - Frequency of second sine wave modulator
%   WetDryMix   - Wet to dry signal ratio
%
%   See also: audiopluginexample.Echo, audiopluginexample.Flanger

%   Copyright 2015-2016 The MathWorks, Inc.
%#codegen
    
    properties
        %Delay Base delay
        %   Specify the base delay for chorus effect as positive scalar
        %   value in seconds. Base delay value must be in the range between
        %   0 and 0.1 seconds. The default value of this property is 0.02.
        Delay = 0.02
    end
        
    properties (Dependent)
        %Depth1 Amplitude of first sine wave modulator
        %   Specify the amplitude of first modulating sine wave as a
        %   positive scalar value. The sinewave are added to the base delay
        %   value to make the delay sinusoidally modulating. This value
        %   must range between 0 to 10. The default value of this property
        %   is 0.01
        Depth1 = 0.01
        
        %Rate1 Frequency of first sine wave modulator
        %   Specify the frequency of the first sine wave as a positive
        %   scalar value in Hz. This property controls the chorus rate.
        %   This value must range from 0 to 10 Hz. The default value of
        %   this property is 0.01.
        Rate1 = 0.01
        
        %Depth2 Amplitude of second sine wave modulator
        %   Specify the amplitude of second modulating sine wave as a
        %   positive scalar value. The sinewave are added to the base delay
        %   value to make the delay sinusoidally modulating. This value
        %   must range between 0 to 10. The default value of this property
        %   is 0.03
        Depth2 = 0.03
        
        %Rate2 Frequency of second sine wave modulator
        %   Specify the frequency of the second sine wave as a positive
        %   scalar value in Hz. This property controls the chorus rate.
        %   This value must range from 0 to 10 Hz. The default value of
        %   this property is 0.02.
        Rate2 = 0.02
    end
    
    properties        
        %WetDryMix Wet/dry mix
        %   Specify the wet/dry mix ratio as a positive scalar. This value
        %   ranges from 0 to 1. For example, for a value of 0.6, the
        %   ratio will be 60% wet to 40% dry signal (Wet - Signal that has
        %   effect in it. Dry - Unaffected signal). The default value of
        %   this property is 0.5.
        WetDryMix = 0.5
    end
    
    properties (Constant)
        % audioPluginInterface manages the number of input/output channels
        % and uses audioPluginParameter to generate plugin UI parameters.
        PluginInterface = audioPluginInterface(...
            'InputChannels',2,...
            'OutputChannels',2,...
            'PluginName','Chorus',...
            'VendorName','',...
            'VendorVersion','3.1.4',...
            'UniqueId','ipsg',...
            audioPluginParameter('Delay','DisplayName','Base delay','Label','s','Mapping',{'lin' 0 0.2}),...
            audioPluginParameter('Depth1','DisplayName','Tap 1 Depth of modulation','Label','','Mapping',{'lin' 0 10}),...
            audioPluginParameter('Rate1','DisplayName','Tap 1 Rate of modulation','Label','Hz','Mapping',{'lin' 0 10}),...
            audioPluginParameter('Depth2','DisplayName','Tap 2 Depth of modulation','Label','','Mapping',{'lin' 0 10}),...
            audioPluginParameter('Rate2','DisplayName','Tap 2 Rate of modulation','Label','Hz','Mapping',{'lin' 0 10}),...
            audioPluginParameter('WetDryMix','DisplayName','Wet/dry mix','Label','','Mapping',{'lin' 0 1}));
    end
    
    %----------------------------------------------------------------------
    % Private properties
    %----------------------------------------------------------------------
    properties (Access = private, Hidden)
        %pFractionalDelay DelayFilter objects for fractional delay with
        %linear interpolation
        pFractionalDelay1
        pFractionalDelay2
        
        %pSine1 and pSine2 Oscillators
        pSine1
        pSine2
        
        %pSR Sample rate
        pSR
    end
    
    %----------------------------------------------------------------------
    % public methods
    %----------------------------------------------------------------------
    methods
        function obj = myChorus
            fs = getSampleRate(obj);
            
            % Create the modulators
            obj.pSine1 = audioOscillator('Frequency', 0.01,...
                'Amplitude', 0.01, 'SampleRate', fs);
            obj.pSine2 = audioOscillator('Frequency', 0.02,...
                'Amplitude', 0.03, 'SampleRate', fs);
            
            % Create fractional delay
            obj.pFractionalDelay1 = dsp.VariableFractionalDelay(...
                'MaximumDelay',65000);
            obj.pFractionalDelay2 = dsp.VariableFractionalDelay(...
                'MaximumDelay',65000);
            
            obj.pSR = fs;
        end

        %% Accessors for dependent properties    
        function set.Depth1(obj, val)
            obj.pSine1.Amplitude = val;
        end
        function val = get.Depth1(obj)
            val = obj.pSine1.Amplitude;
        end
        
        function set.Rate1(obj, val)
            obj.pSine1.Frequency = val;
        end
        function val = get.Rate1(obj)
            val = obj.pSine1.Frequency;
        end
        
        function set.Depth2(obj, val)
            obj.pSine2.Amplitude = val;
        end
        function val = get.Depth2(obj)
            val = obj.pSine2.Amplitude;
        end
        
        function set.Rate2(obj, val)
            obj.pSine2.Frequency = val;
        end
        function val = get.Rate2(obj)
            val = obj.pSine2.Frequency;
        end
        
        %% RESET
        function reset(obj)
            % Reset sample rate
            fs = getSampleRate(obj);
            obj.pSR = fs;
            
            % Reset oscillators
            obj.pSine1.SampleRate = fs;
            obj.pSine2.SampleRate = fs;
            reset(obj.pSine1);
            reset(obj.pSine2);
            
            % Reset delay
            reset(obj.pFractionalDelay1);  
            reset(obj.pFractionalDelay2);
        end
        
        function y = process(obj, x)
            
            fs = obj.pSR;
            oscillator1 = obj.pSine1;
            oscillator2 = obj.pSine2;
            
            numSamples = size(x,1);

            % Compute the base delay value in samples
            delayInSamples = obj.Delay*fs;
            
            % Set frame size of oscillator objects
            oscillator1.SamplesPerFrame = numSamples;
            oscillator2.SamplesPerFrame = numSamples;
            
            % Create modulated delay vectors
            delayVector1 = zeros(size(x));
            delayVector2 = zeros(size(x));
            delayVector1(:,[1,2]) = repmat(delayInSamples+oscillator1(),1,2);
            delayVector2(:,[1,2]) = repmat(delayInSamples+oscillator2(),1,2);
            
            % Get delayed input
            y1 = obj.pFractionalDelay1(x,delayVector1);
            y2 = obj.pFractionalDelay2(x,delayVector2);

            % Calculating output by adding wet and dry signal in
            % appropriate ratio
            mix = obj.WetDryMix;
            y = ((1-mix).*x) + (mix.*(y1+y2));
        end
    end
end