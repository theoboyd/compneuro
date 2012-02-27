function RobotDrawEnv(Env)
% Draw all the object in the environment Env. Each object is drawn as a
% circle of the appropriate radius

xmax = Env.xmax;
ymax = Env.ymax;

xlim([1 xmax])
ylim([1 ymax])

if xmax == ymax
   axis square
end

for i = 1:length(Env.Obs)
   
   Ob = Env.Obs(i);
   
   x = Ob.x-Ob.size;
   y = Ob.y-Ob.size;
   
   w = Ob.size*2;
   h = Ob.size*2;
   
   % Draw nine circles - to account for wrapping on torus
   
   rectangle('Position',[x y w h], ...
      'Curvature',[1 1],'FaceColor','g')
   
   rectangle('Position',[x y-ymax w h], ...
      'Curvature',[1 1],'FaceColor','g')
  
   rectangle('Position',[x y+ymax w h], ...
      'Curvature',[1 1],'FaceColor','g')
   
   rectangle('Position',[x+xmax y w h], ...
      'Curvature',[1 1],'FaceColor','g')
   
   rectangle('Position',[x+xmax y-ymax w h], ...
      'Curvature',[1 1],'FaceColor','g')
  
   rectangle('Position',[x+xmax y+ymax w h], ...
      'Curvature',[1 1],'FaceColor','g')
   
   rectangle('Position',[x-xmax y w h], ...
      'Curvature',[1 1],'FaceColor','g')
   
   rectangle('Position',[x-xmax y-ymax w h], ...
      'Curvature',[1 1],'FaceColor','g')
  
   rectangle('Position',[x-xmax y+ymax w h], ...
      'Curvature',[1 1],'FaceColor','g')   

end