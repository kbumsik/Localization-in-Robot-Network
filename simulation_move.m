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
numOfObjects = 2;   % number of robots
Pt = 100;           % in decibel(db)
freq = 2000000000;	% in hertz =>2Gigahertz
CONST_C = 299792458;    % speed of light (m/s)
sigmaNoise = 2;     % standard deviation parameter of the gaussian noise

% constants for drawing
pointOffset = 5;

% constants for signal
SNR = 50;
%when factor_rayleigh=0.001, filtered:
%SNR=   20 : 90% sucess (18 out of 20)
%       15 : 90% sucess (18 out of 20)
%       10 : 90% sucess (18 out of 20)
%       5  : 95% sucess (19 out of 20)
%when factor_rayleigh=0.001, not filtered:
%SNR=   20 : 30% sucess (3 out of 10)
%       30 : 60% sucess (6 out of 10)
%       40 : 70% sucess (7 out of 10)
%       50  : 50% sucess(5 out of 10)

% ==> SNR doesn't effect much?

factor_rayleigh = 0.001;
%factor_rayleigh(max)= 0.001(90%) (18 out of 20)
% when filtered: 0.001: 90% sucess
%  not filtered: 0.002  ==> 45% sucess if factor = 0.001
%                        new factor_rayleigh(max)= 0.0007 :85% sucess (17 out of 20)

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

%% Signal Object
signal = Signal(SNR, factor_rayleigh);

%==========================================================================


%% get signal in each robot
signalStrength = zeros(numOfObjects,numOfObjects,4);
trueStrength = zeros(numOfObjects,numOfObjects,4);
for i = 1:numOfObjects
    for j = 1:numOfObjects
        if (i ==j)
            continue
        end
        signalStrength(i,j,:) = getNoisedStrength(robot(i),robot(j), signal);
        trueStrength(i,j,:)= getTureStrength(robot(i),robot(j), signal);
    end
end

%% set plot

field = figure(1);
plot(0)
set (gca,'xlim',[0 xField],'ylim',[0 yField], ...
    'xtick', 0:50:xField, 'ytick', 0:50:yField); % set the limit of the plot
                                                 
%% animation
distance = zeros(1,2);


DoA = zeros(numOfObjects,numOfObjects);
DoA_true = zeros(numOfObjects,numOfObjects);
DoA_difference = zeros(numOfObjects,numOfObjects);

while (true)
    % move the robots
    distance(1) = robot(1).getDistanceX(robot(2));
    distance(2) = robot(1).getDistanceY(robot(2));
    
    % Calculate DoA
    for i = 1:numOfObjects  %i is index of transmiter
        for j = 1:numOfObjects  %j is index of receiver
            if i==j
                continue;
            end
            y = fft(signalStrength(j,i,:));   
            y2 = fft(trueStrength(j,i,:));  
            [s,w]=pmusic(y,1); 
            [s2,w2]=pmusic(y2,1);  
            [temp, iMax] = max(s);
            [temp2, iMax2] = max(s2);
            DoA(j,i) = mod(w(iMax)+(7*pi)/4, 2*pi) *180/pi;
            DoA_true(j,i) = mod(w2(iMax2)+(7*pi)/4, 2*pi) *180/pi;
        end
    end
    DoA_true(:,:)
    if (robot(1).getDistance(robot(2)) <= comm)
        break;
    end
    robot(1).velocity(1) = 10*cosd(DoA_true(1,2));
    robot(1).velocity(2) = 10*sind(DoA_true(1,2));
    robot(1).move();
    
    clf; % Clear drawing
    hold on;
    % Draw all robots
    for i = 1: numOfObjects;
      drawAll(robot(i));
      % Add description
      str = ['Robot ',num2str(i)];
      text(robot(i).getX()+pointOffset,robot(i).getY()+pointOffset,str,'HorizontalAlignment','left','fontsize',24);
    end
    % draw lines
    for i = 1:numOfObjects
        for j = i:numOfObjects
            if (i ==j)
                continue
            end
            drawLine(robot(i),robot(j),signal);
        end
    end

    %draw
    pause (0.2);
    drawnow;
end
