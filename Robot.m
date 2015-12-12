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
      end
      
      function x = getX(obj)
         x = obj.position(1);
      end
      
      function y = getY(obj)
         y = obj.position(2);
      end
   end
end