function simulation_move()
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
SNR = 34;
%when factor_rayleigh=0.001, filtered:   will be much slower
%SNR=   30 : 90% sucess (9 out of 10)

%when factor_rayleigh=0.001, not filtered:
%SNR=   34 : 90% sucess (9 out of 10)


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
sig_comm = getBoundingRSSI(signal,1);
sig_sense = getBoundingRSSI(signal,2);
sig_reject = getBoundingRSSI(signal,3);
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
set (field, 'position', [100 100 xField*0.6*2.6 yField*0.6]);
                     
%% set variable for algorithm
robots_group = zeros(1, numOfObjects);
robots_following = zeros(1, numOfObjects);
robots_childern = zeros(numOfObjects);
robots_leader = zeros(1, numOfObjects);
robots_not_change = zeros(1, numOfObjects);
group_index = 1;

%% get number of pairs
DoA = zeros(numOfObjects);
for i = 1:numOfObjects  %i is index of transmiter
    for j = 1:numOfObjects  %j is index of receiver
        if i==j
            continue;
        else           
            y = fft(signalStrength(j,i,:));  
            [s,w]=pmusic(y,1);
            [temp, iMax] = max(s);
            DoA(j,i) = mod(w(iMax)+(7*pi)/4, 2*pi) *180/pi;
        end
     end
end
%DoA(:,:)

%merge DOA, if less than 10, set second DOA to 900 so that it will never in
%pairs(kind like merge it)
for i = 1:numOfObjects  %i is index of transmiter
    for j = 1:numOfObjects  %j is index of receiver
        if i==j
            %nothing
        else    
            for z = j+1: numOfObjects
                if abs(DoA(j,i)-DoA(z,i))<20
                    DoA(z,i)=900;
                end
            end       
        end
     end
end

pairs_number = zeros(1,numOfObjects); %array that store pair number for each robot
for i = 1:numOfObjects  %i is index of transmiter
    for j = 1:numOfObjects  %j is index of receiver
        if i==j
            %do nothing
        else 
            for z = j+1: numOfObjects
                a_max = max([DoA(j,i) DoA(z,i)]);
                a_min = min([DoA(j,i) DoA(z,i)]);
                if (a_max - a_min) > 160 &&  (a_max - a_min < 220) && z ~= i
                    pairs_number(i)= pairs_number(i)+1;
                end
            end   
        end
     end
end
pairs_number(:) %just see first 8 values
%set the biggest as group 1 and setting leader
[temp, iMax] = max(pairs_number);
robots_group(iMax) = group_index;
robots_leader(iMax) = 1;
robots_not_change(iMax) = 1;
group_index = group_index +1;

%% animation loop
distance = zeros(1,2);
DoA = zeros(numOfObjects,numOfObjects);
DoA_true = zeros(numOfObjects,numOfObjects);
DoA_difference = zeros(numOfObjects,numOfObjects);

while (true)
    %% get signal in each robot
    signalStrength = zeros(numOfObjects,numOfObjects,4);
    trueStrength = zeros(numOfObjects,numOfObjects,4);
    % calculate Signal strength
    for i = 1:numOfObjects
        for j = 1:numOfObjects
            if (i ==j)
                % set lowest
                signalStrength(i,j,:) = -1000;
                continue
            end
            signalStrength(i,j,:) = getNoisedStrength(robot(i),robot(j), signal);
            trueStrength(i,j,:)= getTureStrength(robot(i),robot(j), signal);
        end
    end
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
 %   DoA_true(:,:)
    
    % mark "following"
    for i = 1:numOfObjects  %i is index of transmiter
        if (robots_not_change(i) ~= 1)
            iMax = 0;
            valueMax = signalStrength(i,i,1);
            for j = 1:numOfObjects
                if ( valueMax < signalStrength(i,j,1))
                    if (robots_group(i) == 0)
                        iMax = j;
                        valueMax = signalStrength(i,j,1);
                    elseif (robots_group(i) ~= robots_group(j))
                        iMax = j;
                        valueMax = signalStrength(i,j,1);
                    end
                end
            end
            robots_following(i) = iMax;
        end
    end
    
    % move the robots
    for i = 1:numOfObjects  %i is index of transmiter
        if (robots_following(i) ~= 0)
            robot(i).velocity(1) = 10*cosd(DoA_true(i,robots_following(i)));
            robot(i).velocity(2) = 10*sind(DoA_true(i,robots_following(i)));
        else
            robot(i).velocity(1) = 0;
            robot(i).velocity(2) = 0;
        end
    end
    for i = 1:numOfObjects  %i is index of transmiter 
        move_trigger = true;
        if (robots_following(i) > 0)
            if (signalStrength(i,robots_following(i),1) > sig_comm)
                    move_trigger= false;
            end
        end
        if (move_trigger)
            robot(i).move();
        end
    end
    
    % check if the robots are in comm. range
    for i = 1:numOfObjects
        for j = 1:numOfObjects
            if ((signalStrength(i,j,1) > sig_comm) && (robots_not_change(i) ~= 1))
                % case 4
                if(robots_group(i) == 0 && robots_group(j) == 0)
                    robots_group(i) = group_index;
                    robots_group(j) = group_index;
                    group_index = group_index +1;
                    robots_leader(i) = 1;
                    robots_following(j) = i;
                    robots_not_change(j) = 1;
                elseif ( (robots_group(i) > 0) && (robots_group(j) ==0) )
                    robots_group(j) = robots_group(i);
                    robots_following(j) = i;
                    robots_not_change(j) = 1;
                elseif ( (robots_group(i)) == 0 && (robots_group(j) > 0) )
                    robots_group(i) = robots_group(j);
                    robots_following(i) = j;
                    robots_not_change(i) = 1;
                elseif ((robots_group(i) > 0) && (robots_group(j) > 0) && (robots_leader(i) == 1) && (robots_group(i) ~= robots_group(j)))
                % case 5
                    % TODO: check
                    group_i = robots_group(i);
                    group_j = robots_group(j);
                    if (group_i <= group_j)
                        i_low = group_i;
                        robots_leader(j) = 0;
                        robots_following(j) = i;
                        robots_not_change(j) = 1;
                    else
                        i_low = group_j;
                        robots_leader(i) = 0;
                        robots_following(i) = j;
                        robots_not_change(i) = 1;
                    end
                    %merge
                    for temp = 1:numOfObjects  %i is index of transmiter
                        if ( (robots_group(temp) == group_i) || (robots_group(temp) == group_j) )
                            robots_group(temp) = i_low;
                        end
                    end
                end
            end
        end
    end % comm. range case end
    
%{    
    %get each distance
dis = zeros(numOfObjects,numOfObjects);
for i = 1:numOfObjects  %i is index of transmiter
        for j = 1:numOfObjects
            if (i ==j)
                % set lowest
                dis(i,j) = 0;
                continue
            end
            dis(i,j) = getDistance(robot(j),robot(i));          
        end
end
dis(:,:)
%get overlap area of 2 circles
areaOf2 = zeros(numOfObjects,numOfObjects);
for j = 1:numOfObjects  
      for i = j+1:numOfObjects  %i is index of transmiter
          areaOf2(i,j)=getOverLapof2Circle(dis(j,i));
      end
end
areaOf2(:,:)
%}
    %show location of robots
  for i = 1:numOfObjects
      disp(['x' num2str(i) '='  num2str(robot(i).getX())]);
      disp(['y' num2str(i) '='  num2str(robot(i).getY())]);
  end
  
    
    % =============== first plot =========================
    clf; % Clear drawing
    plot = subplot(2,2,[1 3]);
    hold on;
    
    axis([0,xField, 0, yField]); % limit the size of axis
    % Draw all robots
    for i = 1: numOfObjects;
      drawAll(robot(i));
      % Add description
      str = ['Robot ',num2str(i)];
      text(robot(i).getX()+pointOffset,robot(i).getY()+pointOffset,str,'HorizontalAlignment','left','fontsize',12);
    end
    % draw lines
    for i = 1:numOfObjects
        if (robots_following(i) ~= 0)
  %          drawLine(robot(i),robot(robots_following(i)),signal);
        end
    end
    hold off;
    
    % =============== second plot =========================
    subplot(2,2,2);
    hold on;
    for i = 1:numOfObjects
        if (robots_following(i) ~= 0)
            drawLine(robot(i),robot(robots_following(i)),signal);
        end
    end
    hold off;
    % =====================================================
    %draw
    pause (0.2);
    drawnow;
end
end

function add_child()
end

