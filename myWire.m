classdef myWire < audioPlugin
    %MYWIRE Stereo throughput
    %   Simply copy the in buffer to out
    %   Note that properties is optional, but process method is mandatory.
    
    %properties
    %end
    
    methods
        function out = process (~,in)
            out = in;
        end
    end
end

