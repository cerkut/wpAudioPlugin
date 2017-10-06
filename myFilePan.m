classdef myFilePan < audioPlugin 
    %myFilePan Pan the input audio L/R
    %   Demonstrates how to mix down a stereo oinput to mono.
    
    properties 
        ff = 1;
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('ff', 'Mapping',{'lin',0,1}))
     end
         
    methods   
        function out = process (plugin, in)
           mono1 = 0.5*(in(:,1) + in(:,2));
           out = [plugin.ff*mono1 (1-plugin.ff)*mono1];
        end
    end
    
end

