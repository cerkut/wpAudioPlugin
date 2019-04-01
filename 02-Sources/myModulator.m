classdef myModulator < audioPlugin
% myModulator audioPlugin by using audioOscillator class
% Patterns: GUI Toggle controlled by Boolean
%           Gain control. 
%           audioOscillator with accessors, deriving SamplesPerFrame from the input frame.
    
    properties (Dependent) % These are the properties of audioOscillator we inherit, therefore dependent.
        ff  = 1000    % Modulator frequency
    end
    
    properties
        iAM = false % Boolean to determine AM (1) or Ring Modulation (0)
        AMP = 1 % The depth of the Modulation
    end
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('AMP','DisplayName','Mod Gain','Mapping',{'lin',0,2}), ...
            audioPluginParameter('ff','DisplayName','Mod Freq','Label','Hz','Mapping',{'log',10,100000}) ,...
            audioPluginParameter('iAM','DisplayName','Ring (0)/Amp (1) Modulation'), ...
            'InputChannels',1, 'OutputChannels',1)
     end
     
     properties (Access = private, Hidden)
        pOSC;    
     end
    
    methods
        function obj = myModulator()
            obj.pOSC = audioOscillator('sine', 'Frequency', 1000); % Check this class with help audioOscillator
        end
        
        % We need to implement the accessors only for modulation frequency.
        function set.ff(obj, val)
            obj.pOSC.Frequency = val;
        end
        
        function val = get.ff(obj)
            val = obj.pOSC.Frequency;
        end
        
        % End of accessors to ensure that slider values processed. 
        
        function out = process (plugin, in)
           plugin.pOSC.SamplesPerFrame = size(in,1); % We are deriving SamplesPerFrame from the input frame!
           out = 0.33*(plugin.iAM + plugin.AMP * plugin.pOSC()).* in ; % Scaled for AM (Max AMP=2)
        end
    end
    
end
