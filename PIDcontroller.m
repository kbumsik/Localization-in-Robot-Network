classdef PIDcontroller
    %PIDCONTROL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lastTime;
        errSum;
        lastErr;
        kp, ki, kd;
    end
    
    methods
        function obj = PIDcontroller(Kp, Ki, Kd)
            obj.kp = Kp;
            obj.ki = Ki;
            obj.kd = Kd;
            obj.lastErr = 0;
        end
        
        function output = PIDconputeWithTimeInterval(obj, setpoint, input, interval)
            timeChange = interval;
            error = setpoint - input;
            obj.errSum = obj.errSum + (error * timeChange);
            dErr = (error - obj.lastErr) / timeChange;
            obj.lastErr = error;
            output = obj.kp*error + obj.ki*obj.errSum + obj.kd*dErr;
        end
        
    end
    
end

