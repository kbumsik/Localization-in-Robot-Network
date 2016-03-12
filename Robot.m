classdef Robot < handle
   properties
      sensory
      communication
      reject
      position %contains [x,y]
      transmitter
      receiver
      velocity %contains [x,y]
      velPID   %contains [x,y]
   end
   methods
      function obj = Robot(x_pos, y_pos, sen, com, rej)
         obj.position(1) = x_pos;
         obj.position(2) = y_pos;
         obj.sensory = sen;
         obj.communication = com;
         obj.reject = rej;
         % Create transmitter
         obj.transmitter = Tranceiver(x_pos, y_pos, sen, com, rej);
         
         % Create the first receiver
         obj.receiver = Tranceiver(x_pos-0.3, y_pos+0.3, sen, com, rej);
         obj.receiver(2) = Tranceiver(x_pos+0.3, y_pos+0.3, sen, com, rej);
         obj.receiver(3) = Tranceiver(x_pos+0.3, y_pos-0.3, sen, com, rej);
         obj.receiver(4) = Tranceiver(x_pos-0.3, y_pos-0.3, sen, com, rej);
         
         % set velocity and PID
         obj.velocity = zeros(1,2);
         obj.velPID = PIDcontroller(0.8, 0.2, 0.2); %x
         obj.velPID(1) = PIDcontroller(0.8, 0.2, 0.2); %y
         
      end %end constructor

      function drawAll(obj)
         drawAll(obj.transmitter);
         drawAll(obj.receiver(1));
         drawAll(obj.receiver(2));
         drawAll(obj.receiver(3));
         drawAll(obj.receiver(4));
      end % drawAll
      
      function x = getX(obj)
         x = obj.position(1);
      end
      
      function y = getY(obj)
         y = obj.position(2);
      end
      
      % Return signal strength of each receivers
      function rStrength = getNoisedStrength(obj, targetRobot, signal)
          rStrength =    signal.getFilteredSignalStrength(pdist2(obj.receiver(1).position,targetRobot.position,'euclidean'));
          rStrength(2) = signal.getFilteredSignalStrength(pdist2(obj.receiver(2).position,targetRobot.position,'euclidean'));
          rStrength(3) = signal.getFilteredSignalStrength(pdist2(obj.receiver(3).position,targetRobot.position,'euclidean'));
          rStrength(4) = signal.getFilteredSignalStrength(pdist2(obj.receiver(4).position,targetRobot.position,'euclidean'));
      end

      % Return signal strength of each receivers
      function rStrength = getTureStrength(obj, targetRobot, signal)
          rStrength =    signal.getTrue(pdist2(obj.receiver(1).position,targetRobot.position,'euclidean'));
          rStrength(2) = signal.getTrue(pdist2(obj.receiver(2).position,targetRobot.position,'euclidean'));
          rStrength(3) = signal.getTrue(pdist2(obj.receiver(3).position,targetRobot.position,'euclidean'));
          rStrength(4) = signal.getTrue(pdist2(obj.receiver(4).position,targetRobot.position,'euclidean'));
      end
      
      % Draw line between two robot
      function drawLine(obj, targetRobot, signal)
          x = [obj.getX(), targetRobot.getX()];
          y = [obj.getY(), targetRobot.getY()];
          plot(x,y);
          % Add description
          str = ['Avg. Str.', num2str(mean(getNoisedStrength(obj, targetRobot, signal))), 'db'];
          text(mean(x),mean(y),str,'HorizontalAlignment','left','fontsize',18);
      end
      
      % get distance between two robots
      function distance = getDistance(obj, targetRobot)
          distance = pdist2(obj.position, targetRobot.position,'euclidean');
      end
      
      function distanceX = getDistanceX(obj, targetRobot)
          distanceX = obj.position(1) - targetRobot.position(1);
      end
      
      function distanceY = getDistanceY(obj, targetRobot)
          distanceY = obj.position(2) - targetRobot.position(2);
      end
      
      % move the object for one turn
      function move(obj)
          obj.position = obj.position + obj.velocity;
          obj.transmitter.setPosition(obj.transmitter.position + obj.velocity);
          obj.receiver(1).setPosition(obj.receiver(1).position + obj.velocity);
          obj.receiver(2).setPosition(obj.receiver(2).position + obj.velocity);
          obj.receiver(3).setPosition(obj.receiver(3).position + obj.velocity);
          obj.receiver(4).setPosition(obj.receiver(4).position + obj.velocity);
      end
   end
end