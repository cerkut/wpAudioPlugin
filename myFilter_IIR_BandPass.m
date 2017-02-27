classdef myFilter_IIR_BandPass < audiopluginexample.private.SecondOrderIIRFilter
%BandPassIIRFilter Bandpass second-order IIR filter
%  Second-order bandpass IIR filter with tunable center frequency and Q
%  factor. 
%
%  This audio plug-in inherits from SecondOrderIIRFilter which does most
%  of the heavy lifting.
 
%   Copyright 2016 The MathWorks, Inc.

 
    %#codegen 
    properties (Dependent)
        % Center frequency in Hz
        CenterFrequency = 20;  
    end
    properties (Constant)
        % Define the plugin interface
        PluginInterface = audioPluginInterface( ...
            'PluginName','BandPass IIR Filter',...
            audioPluginParameter('CenterFrequency', ...
            'DisplayName',  'Center Frequency', ...
            'Label',  'Hz', ...
            'Mapping', { 'log', 20, 20000}),...
             audioPluginParameter('Q', ...
            'DisplayName',  'Q', ...            
            'Mapping', { 'log', 0.01, 200}));        
    end
    methods
        function plugin = myFilter_IIR_BandPass            
            % Call superclass constructor
            plugin = plugin@audiopluginexample.private.SecondOrderIIRFilter;
        end
        function set.CenterFrequency(plugin,Fc)
            plugin.f0 = Fc;            
        end
        
        function Fc = get.CenterFrequency(plugin)
            Fc = plugin.f0;            
        end
    end
    
    methods (Access = protected)
        function num = calculateNum(~,alpha,norm,~)
            num = alpha*norm * [1 0 -1];
        end
        function str = visualTitle(~)
            str = 'BandPass Filter';
        end
    end
  
end