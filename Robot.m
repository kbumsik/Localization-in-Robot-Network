classdef Robot
   properties
      sensory
      communication
      reject
      position %contains [x,y]
      transmitter
      receiver
   end
   methods
      function obj = Robot(x_pos, y_pos, sen, com, rej)
         if isnumeric(sen)
             obj.sensory = sen;
         else
             error('Value must be numeric')
         end
         if isnumeric(com)
             obj.communication = com;
         else
             error('Value must be numeric')
         end
         if isnumeric(rej)
             obj.reject = rej;
         else
             error('Value must be numeric')
         end
         if isnumeric(x_pos)
             obj.position(1) = x_pos;
         else
             error('Value must be numeric')
         end
         if isnumeric(y_pos)
             obj.position(2) = y_pos;
         else
             error('Value must be numeric')
         end
         
         % Create transmitter
         obj.transmitter = Tranceiver(x_pos, y_pos, sen, com, rej);
         
         % Create the first receiver
         obj.receiver = Tranceiver(x_pos-0.3, y_pos+0.3, sen, com, rej);
         obj.receiver(2) = Tranceiver(x_pos+0.3, y_pos+0.3, sen, com, rej);
         obj.receiver(3) = Tranceiver(x_pos+0.3, y_pos-0.3, sen, com, rej);
         obj.receiver(4) = Tranceiver(x_pos-0.3, y_pos-0.3, sen, com, rej);
         
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
      function rStrength = getStrength(obj, targetRobot)
          rStrength = getSignalStrength(pdist2(obj.receiver(1).position,targetRobot.position,'euclidean'));
          rStrength(2) = getSignalStrength(pdist2(obj.receiver(2).position,targetRobot.position,'euclidean'));
          rStrength(3) = getSignalStrength(pdist2(obj.receiver(3).position,targetRobot.position,'euclidean'));
          rStrength(4) = getSignalStrength(pdist2(obj.receiver(4).position,targetRobot.position,'euclidean'));
      end
      
      % Draw line between two robot
      function drawLine(obj, targetRobot)
          plot([obj.getX(), targetRobot.getX()],[obj.getY(), targetRobot.getY()]);
          % Add description
          str = ['Avg. Str.', num2str(mean(getStrength(obj, targetRobot))), 'db'];
          annotation('textarrow',mean([obj.getX(), targetRobot.getX()]),mean([obj.getY(), targetRobot.getY()]),'String',str,'FontSize', 18);
      end
      
   end
end