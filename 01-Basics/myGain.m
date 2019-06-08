classdef myGain < audioPlugin
    %myWidth Stereo expension by center and side channels
    %   Defines a property <width> which is tuned by a slider.
    
    properties
        Width = 1
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('Width', 'Mapping',{'lin',0,4}))
    end
    
    methods
        function out = process (plugin, in)
        %% MORE TO COME HERE --->
        out =  plugin.Width * in;
        end
    end
    
end

