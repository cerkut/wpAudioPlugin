classdef myIIR1 < audioPlugin
    %myIIR Assignment 10a
    %   See myFIR. 
    properties (Constant)
        PluginInterface = audioPluginInterface(audioPluginParameter('a','Mapping',{'lin', 0, 1.0}))
    end
    
    properties
        % internal states
        a = 0.5;
        z = [0 0];
    end
    
    methods
        function out = process(p, in)
            [out, p.z] = filter(1-p.a, [1 -p.a], in, p.z);
        end
        
        function reset(p)
           p.z = [0 0];
           p.a = 0.5;
        end
        
    end
    
end
