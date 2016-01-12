function result = getSignalStrength( distance )
    %%
    % P?total loss)=P(path-loss)+           P(rayleigh-fading)+   a*P(noise)
    %           20log(d)+20log(f)-147.55                       a*variance^2
    % freq=2.4GHz 
    f=2.4*10^9;
    
    %% power from the path loss
    % equation in db:PL(d) = PL(d0) + 10 *y* log (d/d0)
    % Parameters{
    d0 = 1.8;        % Reference distance
    Pld0 = -27.25;  % Pl(d0) : reference power
    %}
    Pl = Pld0-20*log10(distance/d0);
    
    %% Gaussian White Noise
    % SNR = (mean of signal)/(standard deviation of the noise)
    % It can be expressed in this way because signal strength is constant
    % Refer: https://en.wikipedia.org/wiki/Signal-to-noise_ratio#Alternative_definition
    % Parameters{
    SNR=10; % in dB
    %noise_sigma = 1;
    %}
    % SNR = (Power of signal)/(standard deviation of the noise)
    % SNR_db = 10*log10(SNR) = 10*log10(P_linear/sigma)
    %       = P_db - sigma_db, therefore,
    % sigma_db = P_db - SNRdb
    sigma_db = Pl - SNR;
    % sigma_linear = 10^( sigma_db/10)
    sigma = power(10, sigma_db/10);
    % normal distribution with 0 mean and sigma_linear standard deviation
    Pg = normrnd(0, sigma);
        %take 100 samples average as final Pg
        for i = 1: 99
            Pg = Pg + normrnd(0, sigma);
        end
        Pg = Pg/100;
    % Because output is in db, we should add P_inear with Pg
    Pg = Pg+ power(10, Pl/10);
    % Then convert to db again
    Pg = 10*log10(Pg);
    % Lastly, subtract P_db
    Pg = Pl-Pg;
    
    %% Rayleigh Fading Effect
    pd=makedist('Rayleigh');
    Pr=0.4*random(pd);
    %take 100 samples average as final Pr
        for i = 1: 99
            Pr = Pr + 0.4*random(pd);
        end
        Pr = Pr/100;
    %% Get the result
    result = Pl + Pg + Pr;
end