classdef Tranceiver < handle
   properties
      sensory
      communication
      reject
      position %contains [x,y]
   end
   methods
      function obj = Tranceiver(x_pos, y_pos, sen, com, rej)
         obj.sensory = sen;
         obj.communication = com;
         obj.reject = rej;
         obj.position(1) = x_pos;
         obj.position(2) = y_pos;
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

      function setPosition(obj, input)
        obj.position = input;
      end
   end
end