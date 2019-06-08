classdef myFFTBoost < audioPlugin
    %myFFTBoost Control the amplitude of an FFT Bin in real-time
    %   Detailed explanation goes here
    
    properties
        Width = 1;
        Bin = 1;
    end
    
    properties (Constant)
      PluginInterface = audioPluginInterface( ...
            audioPluginParameter('Width', 'Mapping',{'lin',0,20}), ...
            audioPluginParameter('Bin', 'Mapping',{'int',1,512}))
    end
    methods
        function out = process(obj,in)
          [m,n] = size(in);
          X = fft(in,m*2);
          XHalf       = X(1:m+1,:);
          out = zeros(m,n);
          
          for i = 1:n % Channels
             YmagHalf     = abs(XHalf(:,i));
             YmagHalf(obj.Bin)  = YmagHalf(obj.Bin)*obj.Width;
             YHalf        = YmagHalf.*exp(1i*angle(XHalf(:,i)));
             reverseYHalf = flipud( conj(YHalf(2:end-1)) );
             Y            = [YHalf;reverseYHalf];
             y            = real(ifft(Y));
             out(:,i)     = y(1:m);
          end
           
        end
    end
    
end
