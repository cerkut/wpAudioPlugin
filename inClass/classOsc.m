classdef classOsc < audioPlugin
    properties
        FRQ = 440
        AMP = 1
    end
    
    properties (Constant)
       PluginInterface = audioPluginInterface( ...
            audioPluginParameter('AMP', 'Mapping',{'lin',0,2}), ...
            audioPluginParameter('FRQ', 'Mapping',{'log',44,8800}), ...
            'OutputChannels',1)
    end
    
    methods
        function out = process(obj,in)
            fs = obj.getSampleRate;
            nn = max(size(in)); % We get the buffer size, by default it is 1024 samples
            out = obj.AMP*sin(2*pi*obj.FRQ*(0:nn-1)'/fs); % This needs to be fixed! 
            % Hint: For a contunious sine, you either need contunious
            % time index, or a constant phase shift.
        end
    end
end