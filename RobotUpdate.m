function [x2 y2 w2] = RobotUpdate(x1,y1,w1,UL,UR,Umax,dt,xmax,ymax)
% Updates the position (x1,y1) and orientation w1 of the robot given
% wheel velocities UL (left) and UR (right), where Umax is the maximum
% wheel velocity, dt is the step size, and xmax and ymax are the limits of
% the torus

A = 1; % axle length


BL = UL*Umax; % distance moved by left wheel
BR = UR*Umax; % distance moved by right wheel
B = (BL+BR)/2; % distance moved by centre of axle
C = BR-BL;

dx = B*cos(w1); % change in x-co-ordinate
dy = B*sin(w1); % change in y co-ordinate
dw = atan2(C,A); % change in orientation

x2 = x1+dt*dx;
y2 = y1+dt*dy;
w2 = w1+dt*dw;

% Keep orientation in range 0 to 2pi
w2 = phmod(w2);
if w2 < 0
   w2 = 2*pi+w2;
end

% Wrap x and y axes - robot moves on a torus
if x2 > xmax
   x2 = x2-xmax;
end
if y2 > ymax
   y2 = y2-ymax;
end
if x2 < 0
   x2 = xmax+x2;
end
if y2 < 0
   y2 = ymax+y2;
end