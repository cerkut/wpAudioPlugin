classdef myFIR1 < audioPlugin
    %myFIR Assignment 10a in DSP First
    %%% TODO: automatic gain control with 1+p.b 
    
    properties (Constant)
        PluginInterface = audioPluginInterface(audioPluginParameter('b','Mapping',{'lin', 0, 2}))
    end
    
    properties
        % internal states
        b = 1.0
        z = 0
    end
    
    methods
        function out = process(p, in)
            [out, p.z] = filter([1 p.b], 1, in, p.z);
        end
        
        function reset(p)
           p.z = 0;
           p.b = 0.5;
        end
        
    end
    
end