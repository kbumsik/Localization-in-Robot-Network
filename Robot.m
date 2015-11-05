classdef Robot
   properties
      sensory
      communication
      reject
      x
      y
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
             obj.x = x_pos;
         else
             error('Value must be numeric')
         end
         if isnumeric(y_pos)
             obj.y = y_pos;
         else
             error('Value must be numeric')
         end
      end

      function drawSensory(obj)
         drawCircle(obj.x, obj.y, obj.sensory);
      end

      function drawCommunication(obj)
         drawCircle(obj.x, obj.y, obj.communication);
      end

      function drawReject(obj)
         drawCircle(obj.x, obj.y, obj.reject);
      end

      function drawAll(obj)
         drawSensory(obj);
         drawCommunication(obj);
         drawReject(obj);
      end
   end
end