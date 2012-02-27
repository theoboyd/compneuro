function LIFNeuronDemo
% Simualates a leaky integrate-and-fire neuron using the Euler method


dt = 0.2; % Euler method step size

Tmax = 50; % simulation time

T = 1:dt:Tmax; % time points


I = 20; % base current

% Parameters
R = 1;
tau = 5;
vr = -65;


% Initial values
v(1) = -65;


% SIMULATE

for t = 1:length(T)-1
         
   % Update v
%    v(t+1) = v(t)+dt*((-(v(t)-vr)+R*I)/tau);
   v(t+1) = v(t)+dt*((vr-v(t)+R*I)/tau);
   
   % Reset the neuron if it has spiked
   if v(t+1) >= -50
      v(t) = 30; % Dirac pulse
      v(t+1) = vr;
   end      

end

plot(1:dt:Tmax,v)
xlabel('Time (ms)')
ylabel('Membrane potential v')
title('Leaky Integrate-and-Fire Neuron')
