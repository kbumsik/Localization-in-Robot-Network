%% Firstly clear all
clc;   clear all;   close all;

%==========================================================================

%% Initialize

% a little change
%$ set constants
xField = 600;       % in meters
yField = 600;       % in meters
sens = 80;          % in meters
comm = 50;          % in meters
reject = 40;        % in meters
numOfObjects = 2;   % number of robots
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
<<<<<<< HEAD

%%
%rayleigh distrubution simulate
load hospital

x = [0:0.01:10];
p1 = raylpdf(x,0.5);
p2 = raylpdf(x,1);
p3 = raylpdf(x,2);
pd=fitdist(x,'Rayleigh')
hold on;
plot(x,p1,'--',x,p2,'--',x,p3,'--');
%plot(x,sin(x),'d');

hold off;
=======
set (gca,'xlim',[0 xField],'ylim',[0 yField], ...
    'xtick', 0:50:xField, 'ytick', 0:50:yField); % set the limit of the plot


%==========================================================================

%% Calculate the signal strength
distance = norm(robot(1).position-robot(2).position);
line([robot(1).getX robot(2).getX], [robot(1).getY robot(2).getY]);

%  Measureing power of signal using path loss
Pr = Pt -20*log10(distance)-20*log10(freq)-20*log10(4*pi/CONST_C);

% Adding Additive gaussian noise
Pr = Pr + normrnd(0,2) % adding a random number from normal distribution
>>>>>>> origin/master
