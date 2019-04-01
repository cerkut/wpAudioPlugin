classdef myFileMix < audioPlugin 
    %myFileMix Mix a dsp.AudioFileReader with an incoming signal
    %   Works only for dsp. default buffer size 1024
    
    properties 
        Mix = 0.5; %% LEFT for INPUT, RIGHT for FILE
    end
    
     properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('Mix', 'Mapping',{'lin',0,1}))
     end
     
     properties
        pOSC;    
     end
    
    methods
        function obj = myFileMix()  
         %% obj.pOSC = dsp.AudioFileReader('Counting-16-44p1-mono-15secs.wav'); % MONO
            obj.pOSC = dsp.AudioFileReader('audio48kHz.wav');                   % DIFFERNT FS
            obj.pOSC.PlayCount = inf;                 % LOOP, set a positive integer for count
            obj.pOSC.SamplesPerFrame = getSamplesPerFrame(obj);
        end
        
        function out = process (plugin, in)
           out = plugin.Mix*plugin.pOSC()+(1-plugin.Mix)*in;
        end
    end
    
end

