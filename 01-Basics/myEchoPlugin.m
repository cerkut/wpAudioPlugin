classdef myEchoPlugin < audioPlugin
    properties
        Gain = 1.5;
        Delay = 0.5;
    end
    properties (Access = private)
        CircularBuffer = zeros(192001,2);
        BufferIndex = 1;
        NSamples = 0;
    end
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('Gain',...
            'DisplayName','Echo Gain',...
            'Mapping',{'lin',0,3}),...
            audioPluginParameter('Delay',...
            'DisplayName','Echo',...
            'Label','seconds'))
    end
    methods
        function out = process(plugin, in)
            out = zeros(size(in));
            writeIndex = plugin.BufferIndex;
            readIndex = writeIndex - plugin.NSamples;
            if readIndex <= 0
                readIndex = readIndex + 192001;
            end
            
            for i = 1:size(in,1)
                plugin.CircularBuffer(writeIndex,:) = in(i,:);
                
                echo = plugin.CircularBuffer(readIndex,:);
                out(i,:) = in(i,:) + echo*plugin.Gain;
                
                writeIndex = writeIndex + 1;
                if writeIndex > 192001
                    writeIndex = 1;
                end
                
                readIndex = readIndex + 1;
                if readIndex > 192001
                    readIndex = 1;
                end
            end
            plugin.BufferIndex = writeIndex;
        end
        function set.Delay(plugin, val)
            plugin.Delay = val;
            plugin.NSamples = floor(getSampleRate(plugin)*val);
        end
        function reset(plugin)                                          %<---
            plugin.CircularBuffer = zeros(192001,2);                    %<---
            plugin.NSamples = floor(getSampleRate(plugin)*plugin.Delay);%<---
        end                                                             %<---
    end
end