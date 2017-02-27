classdef myFirstOsc < audioPlugin
    %myFirstOsc Mono Sine OSC from scratch, with index counting
    %   Created for MED4 Session 2: Better way is ofcourse to use
    %   audioOscillator class (check myOsc)
    
    properties
        AMP = 1
        FRQ = 440
        k = 0
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('AMP', 'Mapping',{'lin',0,1}), ...
            audioPluginParameter('FRQ', 'Mapping',{'log',44,8800}), ...
            'OutputChannels',1)
    end
    
    methods
        function out = process (obj, in)
           nn = max(size(in));
           out = obj.AMP*sin(2*pi*obj.FRQ*(obj.k:obj.k+nn-1)'/obj.getSampleRate);
           obj.k = obj.k+nn;
        end
    end
    
end

