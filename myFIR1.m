classdef myFIR1 < audioPlugin
    %myFIR Assignment 10a in DSP First, with auto-gain
    
    
    properties (Constant)
        PluginInterface = audioPluginInterface(audioPluginParameter('b','Mapping',{'lin', 0, 2}))
    end
    
    properties
        % internal states
        b = 1.0;
        z = [0 0];
    end
    
    methods
        function out = process(p, in)
            [out, p.z] = filter([1 p.b]/(1+p.b), 1, in, p.z);
        end
        
        function reset(p)
           p.z = [0 0];
           p.b = 1.0;
        end
        
    end
    
end
