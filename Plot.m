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
numOfObjects = 8;   % number of robots
Pt = 100;           % in decibel(db)
freq = 2000000000;	% in hertz =>2Gigahertz
CONST_C = 299792458;    % speed of light (m/s)
sigmaNoise = 2;     % standard deviation parameter of the gaussian noise

% constants for drawing
pointOffset = 5;

% constants for signal
SNR = 10;
factor_rayleigh = 0.2;

%===================================

%% Signal Object
signal = Signal(SNR, factor_rayleigh);

%% Display
figure();
%% plot the True distance vs power plot

 
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
        drawLine(robot(i),robot(j),signal);
    end
end

hold off;

set (gca,'xlim',[0 xField],'ylim',[0 yField], ...
    'xtick', 0:50:xField, 'ytick', 0:50:yField); % set the limit of the plot


%% plot distance vs power plot
subplot(2,2,1);
t = [1:1:600];
y = zeros(size(t));
for i = 1: length(t)
    y(i) = signal.getTrue(t(i));
end
plot(t,y);
subplot(2,2,1);

%% plot the Noised without filtering distance vs power plot

subplot(2,2,2);
t = [1:1:600];
y = zeros(size(t));
for i = 1: length(t)
    y(i) = signal.getNoised(t(i));
end
plot(t,y);
subplot(2,2,2);


%% plot distance vs power plot
subplot(2,2,3);
t = [1:1:600];
y = zeros(size(t));
for i = 1: length(t)
    y(i) = signal.getFilteredSignalStrength(t(i));
end
plot(t,y);
subplot(2,2,3);


