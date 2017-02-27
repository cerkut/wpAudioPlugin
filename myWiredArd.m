classdef myWiredArd < audioPlugin
    %MYWIRE Stereo throughput
    %   Detailed explanation goes here
    %   For learning how to handle enums at GUI 
    %   edit audioexample.StrobeFillEnum audiopluginexample.Strobe
    
    properties
         gain = 1
         pArd = arduino();
    end
    
    methods
        function y = process (obj,x)
            % CHANGE THE GAIN EVERY 1024 samples
            y = zeros(size(x)); 
            numFrames = size(x,1);
            for idx = 1:ceil(numFrames/1024)
                endIdx = min(idx*1024, numFrames);
                y((idx-1)*1024+1:endIdx,:) = readVoltage(obj.pArd,'A0')*x((idx-1)*1024+1:endIdx,:);   
            end
        end
    end
end
