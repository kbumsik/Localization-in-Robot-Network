classdef Signal
  properties
    %%
    % P?total loss)=P(path-loss)+           P(rayleigh-fading)+   a*P(noise)
    %           20log(d)+20log(f)-147.55                       a*variance^2
    % freq=2.4GHz 
    f=2.4*10^9
    d0 = 1.8        % Reference distance
    Pld0 = -27.25   % Pl(d0) : reference power
    SNR              % in Decibel
    factor_rayleigh
  end
  methods
    function obj = Signal(snr, rayleigh)
      obj.SNR = snr;
      obj.factor_rayleigh = rayleigh;
    end %end constructor

    function Pl = getPathLoss(obj, distance)
      
      %% power from the path loss
      % equation in db:PL(d) = PL(d0) + 10 *y* log (d/d0)
      % Parameters{
      % Reference distance
      % Pl(d0) : reference power
      %}
      Pl = obj.Pld0-20*log10(distance/obj.d0);
      
    end

    function Pg = getAGWN(obj, signal)
      %% Gaussian White Noise
      % SNR = (mean of signal)/(standard deviation of the noise)
      % It can be expressed in this way because signal strength is constant
      % Refer: https://en.wikipedia.org/wiki/Signal-to-noise_ratio#Alternative_definition
      % Parameters{
      obj.SNR; % in dB
      %noise_sigma = 1;
      %}
      % SNR = (Power of signal)/(standard deviation of the noise)
      % SNR_db = 10*log10(SNR) = 10*log10(P_linear/sigma)
      %       = P_db - sigma_db, therefore,
      % sigma_db = P_db - SNRdb
      sigma_db = signal - obj.SNR;
      % sigma_linear = 10^( sigma_db/10)
      sigma = power(10, sigma_db/10);
      % normal distribution with 0 mean and sigma_linear standard deviation
      Pg = normrnd(0, sigma);
      % Because output is in db, we should add P_inear with Pg
      Pg = Pg+ power(10, signal/10);
      % Then convert to db again
      Pg = 10*log10(Pg);
      % Lastly, subtract P_db
      Pg = signal-Pg;
      
    end

    function Pr = getRayleigh(obj)
      pd=makedist('Rayleigh');
      Pr=random(pd);
    end
    
    function result = getTrue(obj, distance)
      result = getPathLoss(obj, distance);
    end
    
    function result = getNoised(obj, distance)
      Pl = getPathLoss(obj, distance);
      Pg = getAGWN(obj, Pl);
      Pr = getRayleigh(obj);
      result = Pl + Pg + obj.factor_rayleigh*Pr;
    end
    
    function result = getFilteredSignalStrength(obj,distance)
      numOfSample = 100;
      sample = zeros(1,numOfSample);
      for i = 1: numOfSample
        sample(i) = getNoised(obj,distance);
      end
      % see tutorial http://www.mathworks.com/help/signal/ref/fir1.html#bulla9m
      blo = fir1(1,[0.1 0.4]);
      outlo = filter(blo,1,sample);
      
      result = outlo(numOfSample/2);
    end
    
  end
end
