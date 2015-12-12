%% Firstly clear all
clc;   clear all;   close all;

%==========================================================================

%% Initialize

% a little change
%$ set constants
xField = 1000;       % in meters
yField = 1000;       % in meters
sens = 200;          % in meters
comm = 100;          % in meters
reject = 20;        % in meters
numOfObjects = 4;   % number of robots
Pt = 100;           % in decibel(db)
freq = 2000000000;	% in hertz =>2Gigahertz
CONST_C = 299792458;    % speed of light (m/s)
sigmaNoise = 2;     % standard deviation parameter of the gaussian noise

%===================================

%% Create objects
for i = 1: numOfObjects;
    check = 1;
    randX = sens+rand()*(xField-2*sens);
    randY = sens+rand()*(yField-2*sens);
    if i > 1
       while (check == 1)
           check = 0;
            randX = sens+rand()*(xField-2*sens);
            randY = sens+rand()*(yField-2*sens);
           for j = 1:i-1;
               result = (randX-robot(j).getX)^2 + (randY-robot(j).getY)^2 - (reject*2)^2;
              if ( result < 0 )
                  check = 1;
              end
           end
       end
       robot(i) = Robot(randX, randY, sens, comm, reject);
    else
        robot(i) = Robot(randX, randY, sens, comm, reject);
    end
    
end

%==========================================================================

%% Display
field = figure(1);
set(field,'position',[200,200,xField*1.1,yField*1.1]); % set window size

 
plot(0)
hold on;
for i = 1: numOfObjects;
    drawAll(robot(i));
    
end
hold off;

set (gca,'xlim',[0 xField],'ylim',[0 yField], ...
    'xtick', 0:50:xField, 'ytick', 0:50:yField); % set the limit of the plot


%% get signal in each robot
signalStrength = zeros(numOfObjects,numOfObjects,4);
for i = 1:numOfObjects
    for j = 1:numOfObjects
        if (i ==j)
            continue
        end
        signalStrength(i,j,:) = getStrength(robot(i),robot(j));
    end
end

%% ==========================================================================
    p1 = raylpdf(x,0.5);
    p2 = raylpdf(x,1);
    p3 = raylpdf(x,2);
    plot(x,p1,x,p2,x,p3);
%%
%rayleigh distrubution simulate
pd=makedist('Rayleigh');
hold on;
 for x1 = 1: 1001;
    y(x1)=random(pd); 
 end
 plot(x,y+sin(x));
hold off;

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

%% plot distance vs power plot

t = [0:0.1:200];
y= -27.25-20*log10(t/d0) + 1*randn(size(t));
plot(t,y);
