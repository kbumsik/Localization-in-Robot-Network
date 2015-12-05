classdef Tranceiver
   properties
      sensory
      communication
      reject
      position %contains [x,y]
   end
   methods
      function obj = Tranceiver(x_pos, y_pos, sen, com, rej)
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
      end

      function drawSensory(obj)
         drawCircle(obj.position(1), obj.position(2), obj.sensory);
      end

      function drawCommunication(obj)
         drawCircle(obj.position(1), obj.position(2), obj.communication);
      end

      function drawReject(obj)
         drawCircle(obj.position(1), obj.position(2), obj.reject);
      end

      function drawAll(obj)
         drawSensory(obj);
         drawCommunication(obj);
         drawReject(obj);
      end
      
      function x = getX(obj)
         x = obj.position(1);
      end
      
      function y = getY(obj)
         y = obj.position(2);
      end
   end
end