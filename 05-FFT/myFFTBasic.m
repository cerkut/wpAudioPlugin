classdef myFFTBasic < audioPlugin
    %MYFFTBASIC Simple FFT Bin manipulation/filtering
    %   Detailed explanation goes here
    
    properties
        gain = 1;
        bin = 1;
    end


    properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('gain', 'Mapping',{'lin',0,20}), ...
            audioPluginParameter('bin', 'Mapping',{'int',1,512}))
    end

    methods

       function out = process (obj,in)
           x = fft(in);
           x(obj.bin,:) = x(obj.bin,:).*[obj.gain obj.gain];
           out = real(ifft(x));
       end
    end
end
