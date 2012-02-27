function IzNeuronDemo
% Simualates Izhikevich's neuron model using the Euler method


dt = 0.2; % Euler method step size

Tmax = 200; % simulation time

T = 1:dt:Tmax; % time points

I = 10; % base current - use I = 0.8 for bursting

% Parameters of Izhikevich's model (regular spiking)
a = 0.02;
b = 0.2;
c = -65;
d = 8;

% Parameters of Izhikevich's model (bursting)
% a = 0.02;
% b = 0.25;
% c = -55;
% d = 0;


% Initial values
v(1) = -65;
u(1) = -1;


% SIMULATE

for t = 1:length(T)-1

   % Update v and u according to Izhikevich's equations
   v(t+1) = v(t) + dt*(0.04*v(t)^2+5*v(t)+140-u(t)+I);
   u(t+1) = u(t) + dt*(a*(b*v(t)-u(t)));
   
   % Reset the neuron if it has spiked
   if v(t+1) >= 30
      v(t) = 30; % Dirac pulse
      v(t+1) = c;
      u(t+1) = u(t+1)+d;
   end      

end

subplot(3,1,[1,2])
plot(1:dt:Tmax,v)
ylabel('Membrane potential v')
title('Izhikevich Neuron')

subplot(3,1,3)
plot(1:dt:Tmax,u)
xlabel('Time (ms)')
ylabel('Reset variable u')