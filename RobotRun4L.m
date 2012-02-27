function RobotRun4L
% Simualates the movement of a robot with differential wheels, under the
% control of a spiking neural network


% INITIALISE


% Create the environment
xmax = 100; % limit of torus on x-axis in cm
ymax = 100; % limit of torus on y-axis in cm
Env = RobotCreateEnv(15,5,5,xmax,ymax);
% Env = RobotTestEnv;

% Draw the environment
figure(2)
clf
hold on
RobotDrawEnv(Env)

load('Network.mat','layer'); % robot controller

L = length(layer);

% Sizes of neuron layers
for lr = 1:L
   N(lr) = layer{lr}.rows;
   M(lr) = layer{lr}.columns;
end

NM = N(3)*M(3); % number of neurons in motor layer

Rmax = 40; % estimated peak motor firing rate in Hz

Dmax = 5; % maximum propagation delay

% Initialise layers
for lr = 1:L
   layer{lr}.v = -65*ones(N(lr),M(lr));
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end

dt = 100; % robot step size in milliseconds

Tmax = 20000; % simulation time in milliseconds

T = 1:dt:Tmax; % time points

x(1) = 0; y(1) = 0; % initial co-ordinates
w(1) = pi/4; % initial orientation in radians - 0 = East, pi/2 = North

Umin = 0.025; % minimum wheel velocity in cm per ms - was 0.05
Umax = Umin+Umin/6; % maximum wheel velocity

% Initialise record of membrane potentials
for lr = 1:length(layer)
   v{lr} = zeros(dt,N(lr)*M(lr));
end


% SIMULATE


for t = 1:length(T)-1
   
   t
   
   % INPUT FROM SENSORS
   
   [SL SR SC] = RobotGetSensors(Env,x(t),y(t),w(t),xmax,ymax);
   
   
   % UPDATE NEURONS
   
   % Carry over firings that might not have reached their targets yet
   for lr = 1:L
      firings = layer{lr}.firings;
      if ~isempty(firings)
         firings = firings(firings(:,1) > dt-Dmax,:);
         if ~isempty(firings)
            firings(:,1) = firings(:,1)-dt;
         end
      end
      layer{lr}.firings = firings;
   end

   for t2 = 1:dt
      
      % Deliver stimulus as a Poisson spike stream
      layer{1}.I = poissrnd(SL*15,N(1),M(1));
      layer{2}.I = poissrnd(SR*15,N(2),M(2));
      
      % Deliver noisy base currents
      layer{3}.I = 5*randn(N(3),M(3));
      layer{4}.I = 5*randn(N(4),M(4));

      % Update all the neurons
      for lr = 1:L
         layer = IzNeuronUpdate(layer,lr,t2,Dmax);
      end

      % Maintain record of membrane potentials
      for lr = 1:L
         v{lr}(t2,1:N(lr)*M(lr)) = layer{lr}.v;
      end

   end
   
   % Discard carried over firings
   for lr = 1:L
      firings = layer{lr}.firings;
      if ~isempty(firings)
         firings = firings(firings(:,1) > 0,:);
      end
      layer{lr}.firings = firings;
   end
   
   % Add Dirac pulses (mainly for presentation)
   for lr = 1:L
      firings = layer{lr}.firings;
      if ~isempty(firings)
         v{lr}(sub2ind(size(v{lr}),firings(:,1),firings(:,2))) = 30;
      end
   end
   
   
   % OUTPUT TO MOTORS   
   
   % Calculate motor firing rates in Hz
   RL = length(layer{3}.firings)/dt/NM*1000;
   RR = length(layer{4}.firings)/dt/NM*1000;
   
   % Set wheel velocities (as fractions of Umax)
   UL = (Umin/Umax+RL/Rmax*(1-Umin/Umax)); % velocity of left wheel
   UR = (Umin/Umax+RR/Rmax*(1-Umin/Umax)); % velocity of left wheel
   
   
   % UPDATE ENVIRONMENT
   
   [x(t+1) y(t+1) w(t+1)] = RobotUpdate(x(t),y(t),w(t),...
      UL,UR,Umax,dt,xmax,ymax);
   
   
   % PLOTTING
   
   RobotPlot4L(v) % plot membrane potentials

   % Plot robot trajectory
   figure(2)
   hold on
   plot(x(t+1),y(t+1),'.')
   xlim([0 xmax])
   ylim([0 ymax])
   axis square
   set(gca,'Box','on')
   title('Robot controlled by spiking neurons')
   xlabel('X')
   ylabel('Y')
   
end

