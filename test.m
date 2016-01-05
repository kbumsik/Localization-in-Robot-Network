%%
x=[0 1 1 1],
y = fft(x),
[p,w] = pmusic(y,1);
plot(w,p);

% get the index of maximum power
[temp, iMax] = max(p);
% get the angle of the maximum power
DoA = radtodeg(w(iMax)),