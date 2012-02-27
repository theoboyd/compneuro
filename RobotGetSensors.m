function [SL SR SC] = RobotGetSensors(Env,x,y,w,xmax,ymax)
% Return the current values of the robot's sensors given its position (x,y)
% and orientation w in the environment Env. SL is the left sensor, SR is
% the right sensor, SC is a central forward-directed sesnor.
% All geometry is calculated on a torus whose limits are xmax and ymax


SL = 0;
SR = 0;
SC = 0;

Range = 25; % Sensor range - was 20

for i = 1:length(Env.Obs)
   
   Ob = Env.Obs(i);
   
   x2 = Ob.x;
   y2 = Ob.y;
   
   % Find shortest x distance on torus
   if abs(x2+xmax-x) < abs(x2-x)
      x2 = x2+xmax;
   elseif abs(x2-xmax-x) < abs(x2-x)
      x2 = x2-xmax;
   end
   
   % Find shortest y distance on torus
   if abs(y2+ymax-y) < abs(y2-y)
      y2 = y2+ymax;
   elseif abs(y2-ymax-y) < abs(y2-y)
      y2 = y2-ymax;
   end
   
   dx = x2-x;
   dy = y2-y;
   
   z = sqrt(dx^2+dy^2); % distance from robot to object centre
   
   if z < Ob.size+Range && z > Ob.size % object is close (but not too close)
      
      v = atan2(dy,dx); % bearing of object wrt robot
      if v < 0
         v = 2*pi+v;
      end
      
      dw = v-w; % angular difference between robot's heading and object
      
      % Stimulus strength depends on distance to object boundary
      S = (Range-(z-Ob.size))/Range;
      
      if (dw >= pi/8 && dw < pi/2) || (dw < -1.5*pi && dw >= -2*pi+pi/8)
         % centre of object is to left
         SL = max(S,SL); % use nearest object
      elseif (dw > 1.5*pi && dw <= 2*pi-pi/8) || (dw <= -pi/8 && dw > -pi/2)
         % centre of object is to right
         SR = max(S,SR); % use nearest object
      elseif (dw > - pi/8 && dw < pi/8) || (dw < - 7/8*2*pi && dw > -2*pi+pi/8)
         % centre of object is ahead
         SC = max(S,SC); % use nearest object
      end
      
   end
      
end