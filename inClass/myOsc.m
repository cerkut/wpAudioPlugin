classdef myOsc < audioPlugin
    %myOsc audioPlugin by using audioOscillator class
    %   Detailed explanation goes here
    
    properties (Dependent) % These are the properties of audioOscillator, therefore dependent.
        ff = 440
        AMP = 1
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('AMP', 'Mapping',{'lin',0,2}), ...
            audioPluginParameter('ff', 'Mapping',{'log',44,8800}))
     end
     
     properties (Access = private) % An instance of the audioOscillator
        pOSC;    
     end
    
    methods
        function obj = myOsc()
            obj.pOSC = audioOscillator('sine'); % Check this class with help audioOscillator
        end
        
        % We need to implement setters/getters (accessors) for Dependent properties.
        function set.ff(obj, val)
            obj.pOSC.Frequency = val;
        end
        
        function val = get.ff(obj)
            val = obj.pOSC.Frequency;
        end
        
          function set.AMP(obj, val)
            obj.pOSC.Amplitude = val;
        end
        
        function val = get.AMP(obj)
            val = obj.pOSC.Amplitude;
        end
        % End of accessors to ensure that slider values processed. 
        
        
        function out = process (plugin, in)
           plugin.pOSC.SamplesPerFrame = size(in,1); % We are deriving SamplesPerFrame from the input frame!
           out = plugin.pOSC();
        end
    end
    
end

