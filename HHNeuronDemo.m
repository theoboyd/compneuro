function HHNeuronDemo
% Simualates the Hodgkin-Huxley neuron model using the Euler method,
% assuming a resting potential of 0mV, as in the 1952 paper. To get a
% realistic resting potential of -65mV, use the code in comments


dt = 0.01; % Euler method step size

Tmax = 100; % simulation time

T = 1:dt:Tmax; % time points


I = 10; % base current

% Parameters of the Hodgkin-Huxley model
gNa = 120;
gK = 36;
gL = 0.3;
ENa = 115;
EK = -12;
EL = 10.6;
% ENa = 115-65;
% EK = -12-65;
% EL = 10.6-65;
C = 1;


% Initial values
v(1) = -10;
% v(1) = -75;
m = 0;
n = 0;
h = 0;

% SIMULATE

for t = 1:length(T)-1
         
   % Update v according to Hodgkin-Huxley equations

   alphan = (0.1-0.01*v(t))/(exp(1-0.1*v(t))-1);
   alpham = (2.5-0.1*v(t))/(exp(2.5-0.1*v(t))-1);
   alphah = 0.07*exp(-v(t)/20);

   betan = 0.125*exp(-v(t)/80);
   betam = 4*exp(-v(t)/18);
   betah = 1/(exp(3-0.1*v(t))+1);
   
%    alphan = (0.1-0.01*(v(t)+65))/(exp(1-0.1*(v(t)+65))-1);
%    alpham = (2.5-0.1*(v(t)+65))/(exp(2.5-0.1*(v(t)+65))-1);
%    alphah = 0.07*exp(-(v(t)+65)/20);
% 
%    betan = 0.125*exp(-(v(t)+65)/80);
%    betam = 4*exp(-(v(t)+65)/18);
%    betah = 1/(exp(3-0.1*(v(t)+65))+1);


   m = m + dt*(alpham*(1-m)-betam*m);
   n = n + dt*(alphan*(1-n)-betan*n);
   h = h + dt*(alphah*(1-h)-betah*h);

   Ik = gNa*m^3*h*(v(t)-ENa) + gK*n^4*(v(t)-EK) + gL*(v(t)-EL);

   v(t+1) = v(t) + dt*(-Ik+I)/C;

end

plot(1:dt:Tmax,v)
xlabel('Time (ms)')
ylabel('Membrane potential (mV)')
title('Hodgkin-Huxley Neuron')
