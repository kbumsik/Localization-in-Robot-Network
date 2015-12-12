function power = getSignalStrength( distance )
    %%
    % P?total loss)=P(path-loss)+           P(rayleigh-fading)+   a*P(noise)
    %           20log(d)+20log(f)-147.55                       a*variance^2
    %in db:L(d) = L(d0) + 10 *y* log (d/d0), d0=refrence distance=1.8m
    %L(d0)=-27.25 db
    % assume Pt=100db=10^10W   freq=2.4GHz   
    %L(d0)=27.25;
    f=2.4*10^9;
    d=900;
    d0=1.8;
    P= -27.25-20*log10(d/d0) + 0.05*1;

    %% get power

    power= -27.25-20*log10(distance/d0) + 1*randn(size(distance));
end