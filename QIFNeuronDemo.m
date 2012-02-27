function QIFNeuronDemo
% Simualates a quadratic integrate-and-fire neuron using the Euler method


dt = 0.2; % Euler method step size

Tmax = 50; % simulation time

T = 1:dt:Tmax; % time points


I = 20; % base current

% Parameters
R = 1;
tau = 5;
vr = -65;
vc = -50;
a = 0.2;


% Initial values
v(1) = -65;


% SIMULATE

for t = 1:length(T)-1
         
   % Update v
   v(t+1) = v(t)+dt*((a*(vr-v(t))*(vc-v(t))+R*I)/tau);
   
   % Reset the neuron if it has spiked
   if v(t+1) >= -30
      v(t) = 30; % Dirac pulse
      v(t+1) = vr;
   end      

end

plot(1:dt:Tmax,v)
xlabel('Time (ms)')
ylabel('Membrane potential v')
title('Quadratic Integrate-and-Fire Neuron')
