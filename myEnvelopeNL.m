classdef myEnvelopeNL < audioPlugin
%myEnvelopeNL Envelope following by a NL-filter with rectification.
%   NOTE I've learned this from Perry R. Cook and used in 
%   Leevi Peltola, Cumhur Erkut, Perry R Cook, and Vesa Välimäki. 2007. 
%   Synthesis of hand clapping sounds. IEEE/ACM Transactions on Audio, Speech and Language Processing 15, 3: 1021–1029. 
%   http://doi.org/10.1109/TASL.2006.885924      
%   Envelope is returned as an audio signal, which must be downsampled.
%   FOR DEMO PURPOSES ONLY! NOT AN EFFICIENT IMPLEMENTATION.
% TODO check audiopluginexample visualizations, especially audiopluginexample.SpeechPitchDetector
% TODO     
    properties
       b_up = 0.9
       b_do = 0.995
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('b_up','Mapping',{'lin', 0, 1.0}), ...
            audioPluginParameter('b_do','Mapping',{'lin', 0, 1.0}), ...
            'InputChannels',1, 'OutputChannels',1)
    end
    
    properties
        % Filter internal states
        b = 0.9
        z = 0
    end
 
    
    methods
        function reset(p)
            p.z = 0;
            p.b = p.b_up;
        end
        
        function out = process (p,in) 
            n = size(in,1);
            out = zeros(n,1);
            out(1) = p.z;
            for idx = 2:n
                m = abs(in(idx));
                if m >= out(idx-1)
                    p.b = p.b_up; 
                else
                    p.b = p.b_do; 
                end
                out(idx) = (1-p.b)*m + p.b*out(idx-1);
            end
            p.z = out(n);
        end
    end
end

