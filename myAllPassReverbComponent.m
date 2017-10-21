classdef myAllPassReverbComponent < audioPlugin
    %Allpass/Comb of 512 samples delay
    %   Design pattern: Stereo filter state p.z, so that code generation
    %   works.
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('a','Mapping',{'lin', 0, 1.0}))
    end
    
    properties
        % internal states
        a = 0.5;
        delayInSamples = 512;
        z = zeros(513,2);
    end
    

    methods
        
        
        function out = process(p, in)
            [out, p.z] = filter([p.a zeros(1,p.delayInSamples) 1], [1 zeros(1,p.delayInSamples) p.a], in, p.z);
        end
        
        function reset(p)
           p.z = zeros(p.delayInSamples+1,2);
        end
        
    end
    
end
