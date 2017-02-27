classdef myMobileWidth < audioPlugin
    %myWidth Stereo expension by center and side channels
    %   Detailed explanation goes here
    
    properties
        Width = 1
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface( audioPluginParameter('Width', 'Mapping',{'pow',4,0,16}))
    end
    
    properties (Access = private)        
    pMobile
    end

    methods

    function obj = myMobileWidth()
      obj.pMobile = mobiledev;
      obj.pMobile.Logging = 1;
    end

    function out = process (plugin, in)
           mid = 0.5*(in(:,1) + in(:,2));
           sid = 0.5*(in(:,1) - in(:,2));
           sid = plugin.pMobile.Acceleration(3) * sid;
           out = [mid+sid mid-sid];
        end
    end
    
end

