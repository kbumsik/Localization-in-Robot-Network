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
        drawLine(robot(i),robot(j));
    end
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

%% Applying pmusic function
figure(2);
y1 = fft(signalStrength(1,2,:));
[s12,w12]=pmusic(y1,1);
plot(w12,s12);

figure(3);
y2 = fft(signalStrength(2,1,:));
[s21,w21]=pmusic(y2,1);
plot(w21,s21);

% get the index of maximum power
[temp, iMax12] = max(s12);
[temp, iMax21] = max(s21);
% get the angle of the maximum power
DoA12 = radtodeg(w12(iMax12)),
DoA21 = radtodeg(w21(iMax21)),

%% plot distance vs power plot
figure(4);
t = [0:0.1:600];
y= getSignalStrength(t);
plot(t,y);
