classdef myFFTAcorr < audioPlugin
    %MYFFTACCOR Simple FFT-based autocorrelation
    %   More like a template class, to code further.
    %   No windows.
    
    properties
        gain = 1;
        bin = 1;
        Scope
    end


    properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('gain', 'Mapping',{'lin',0,20}), ...
            audioPluginParameter('bin', 'Mapping',{'int',1,512}))
    end

    methods

       function out = process (plugin,in)
           x = fft(in);
           y = real(ifft(x.*conj(x)));
           out = real(ifft(x));
           plugin.Scope(xcorr(x),y);
       end
       
       function visualize(plugin)

        %   visualize(pitchDetector) opens both the pitch contour plotter
        %   and the pitch meter display.
        %
        %   The visualization methods can only be used in the MATLAB environment.
        
            plugin.Scope = dsp.TimeScope( ...
                'SampleRate',getSampleRate(plugin), ...
                'TimeSpan',2, ...
                'BufferLength',getSampleRate(plugin)*2, ...
                'LayoutDimensions',[2,1], ...
                'NumInputPorts',2);
            plugin.Scope.ActiveDisplay = 2;
            plugin.Scope.YLimits  = [-100,100];
            show(plugin.Scope)
    end
    end
end