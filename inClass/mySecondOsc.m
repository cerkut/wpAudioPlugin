classdef mySecondOsc < audioPlugin
    %mySecondOsc Mono Sine OSC from scratch, with adding
    %   Created for MED4 Session 3 in class 20.2.2017
    
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
           out = obj.AMP*sin(2*pi*obj.FRQ*((obj.k*nn)+(0:nn-1))'/obj.getSampleRate);
           obj.k = obj.k+1;
        end
    end
    
end

