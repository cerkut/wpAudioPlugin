ppclassdef myWire < audioPlugin
    %MYWIRE Stereo throughput
    %   Detailed explanation goes here
    %   For learning how to handle enums at GUI 
    %   edit audioexample.StrobeFillEnum audiopluginexample.Strobe
    % 
    
    
    %properties
    %end
    
    methods
        function out = process (~,in)
            out = in;
        end
    end
end

