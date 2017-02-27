classdef myWidth < audioPlugin
    %myWidth Stereo expension by center and side channels
    %   Detailed explanation goes here
    
    properties
        Width = 4
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('Width', 'Mapping',{'lin',0,4fft}))
    end
    
    methods
        function out = process (plugin, in)
           mid = 0.5*(in(:,1) + in(:,2));
           sid = 0.5*(in(:,1) - in(:,2));
           sid = plugin.Width * sid;
           out = [mid+sid mid-sid];
        end
    end
    
end

