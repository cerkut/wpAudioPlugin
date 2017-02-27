classdef myModulator < audioPlugin
       % myModulator audioPlugin by using audioOscillator class
       
    properties (Dependent) % These are the properties of audioOscillator, therefore dependent.
        ff  = 1000    % This will be the fm
    end
    
    properties
        AMP = 1 % This will be the "I" now.
    end
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('AMP','DisplayName','ModIndex I','Mapping',{'lin',0,2}), ...
            audioPluginParameter('ff','DisplayName','ModFreq f_m','Label','Hz','Mapping',{'log',10,100000}) , ...
            'InputChannels',1, 'OutputChannels',1)
     end
     
     properties (Access = private, Hidden)
        pOSC;    
     end
    
    methods
        function obj = myModulator()
            obj.pOSC = audioOscillator('sine', 'Frequency', 1000); % Check this class with help audioOscillator
        end
        
        % We need to implement the accessors only for modulation frequency fm.
        function set.ff(obj, val)
            obj.pOSC.Frequency = val;
        end
        
        function val = get.ff(obj)
            val = obj.pOSC.Frequency;
        end
        
        % End of accessors to ensure that slider values processed. 
        
        function out = process (plugin, in)
           plugin.pOSC.SamplesPerFrame = size(in,1); % We are deriving SamplesPerFrame from the input frame!
           out = (1 + plugin.AMP * plugin.pOSC()).* in ;
        end
    end
    
end