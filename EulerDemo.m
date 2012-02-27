function EulerDemo
% Solves the ODE dy/dt=y (exact solution: y(t)=exp(t)), by numerical
% simulation using the Euler method, for two different step sizes

dt1 = 0.5; % large step size
dt2 = 0.1; % smaller step size

% Time points
Tmin = 0;
Tmax = 5;
T1 = Tmin:0.001:Tmax;
T2 = Tmin:dt1:Tmax;
T3 = Tmin:dt2:Tmax;

% Exact solution
y1(1) = exp(Tmin); % initial value
for t = 1:length(T1)-1
   
   y1(t+1) = exp(T1(t+1));
      
end

% Euler method with large step size
y2(1) = exp(Tmin); % initial value
for t = 1:length(T2)-1
   
   y2(t+1) = y2(t) + dt1*y2(t);
      
end

% Euler method with smaller step size
y3(1) = exp(Tmin); % initial value
for t = 1:length(T3)-1
   
   y3(t+1) = y3(t) + dt2*y3(t);   
      
end

% Plot the results
hold on
plot(T1,y1,'Color','Blue')
plot(T2,y2,'Color','Green')
plot(T3,y3,'Color','Red')
xlabel('t')
ylabel('y')
legend('Exact solution of y = e^t','Euler method \delta t = 0.5','Euler method \delta t = 0.1',...
   'Location','Best')
