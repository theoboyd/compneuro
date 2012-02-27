function Env = RobotCreateEnv(Obs,MinSize,MaxSize,xmax,ymax)
% Create a new environment comprising a list of length Obs of objects. Each
% new object is assigned a random size (between MinSize and MaxSize) and a
% random location on a torus. xmax and ymax are the limits of the torus

Env.xmax = xmax;
Env.ymax = ymax;

Env.Obs = [];

for i = 1:Obs
   
   Ob.x = ceil(rand*xmax);
   Ob.y = ceil(rand*ymax);
   Ob.size = MinSize+floor(rand*(MaxSize-MinSize+1));
   Env.Obs = [Env.Obs ; Ob];
   
end