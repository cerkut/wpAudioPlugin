classdef myFilePan < audioPlugin 
    %myWidth Stereo expension by center and side channels
    %   Detailed explanation goes here
    
    properties 
        ff = 1;
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('ff', 'Mapping',{'lin',0,1}))
     end
     
     properties
        pOSC;    
     end
    
    methods
%         function obj = myFilePan()
%          frameLength = 1024;   
%          obj.pOSC = dsp.AudioFileReader('RockGuitar.wav');
%         end
%         
        
        function out = process (plugin, in)
           mono1 = 0.5*(in(:,1) + in(:,2));
           %%rigt = plugin.ff*plugin.pOSC();
           %%rigt = 0.5*(rigt(:,1) + rigt(:,2));
           
           out = [plugin.ff*mono1 (1-plugin.ff)*mono1];
        end
    end
    
end

