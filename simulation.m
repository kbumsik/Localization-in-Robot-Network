%% Firstly clear all
clc;   clear all;   close all;

% a little change
%$ set constants
xField = 600;
yField = 600;
sens = 80;
comm = 50;
reject = 40;
numOfObjects = 8;

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
               result = (randX-robot(j).x)^2 + (randY-robot(j).y)^2 - (reject*2)^2;
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

%% Display
field = figure(1);
set(field,'position',[200,200,xField,yField]);
plot(0)
hold on;
for i = 1: numOfObjects;
    drawAll(robot(i));
end
hold off;

%%
%rayleigh distrubution simulate

x = [0:0.01:10];
p1 = raylpdf(x,0.5);
p2 = raylpdf(x,1);
p3 = raylpdf(x,2);
hold on;
plot(x,p1,'--',x,p2,'--',x,p3,'--');
%plot(x,sin(x),'d');

hold off;