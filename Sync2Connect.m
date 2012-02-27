function Sync2Connect
% Constructs two populations of neurons (comprising two layers each) that
% oscillate in the gamma range using PING, and that can be couped together
% to study various synchronisation phenomena
%
% Coupling the excitatory populations causes the populations to synhronise
% 180 degrees out of phase with each other if they have the same natural
% frequency. Coupling the inhibitory populations causes complete
% synchronisation with zero phase lag, even if they have slightly different
% natural frequencies


% Layers are N by M arrays of neurons

N1 = 800;
M1 = 1;

N2 = 200;
M2 = 1;

% Conduction delays - 2 for 56Hz, 5 for 40Hz, 8 for 32Hz
D1 = 6;
D2 = 4;

D = 5; % conduction delay for inter-population connections


% Neuron parameters
% Each layer comprises a heterogenous set of neurons, with a small spread
% of parameter values, so that they exhibit some dynamical variation

% Layer 1 (excitatory - regular spiking)
r = rand(N1,M1);
% r = ones(N1,M1);
layer{1}.rows = N1;
layer{1}.columns = M1;
layer{1}.a = 0.02*ones(N1,M1);
layer{1}.b = 0.2*ones(N1,M1);
layer{1}.c = -65+15*r.^2;
layer{1}.d = 8-6*r.^2; 

% Layer 2 (inhibitory - low threshold spiking)
r = rand(N2,M2);
% r = ones(N2,M2);
layer{2}.rows = N2;
layer{2}.columns = M2;
layer{2}.a = 0.02+0.08*r;
layer{2}.b = 0.25-0.05*r;
layer{2}.c = -65*ones(N2,M2);
layer{2}.d = 2*ones(N2,M2);

% Layer 3 (excitatory - regular spiking)
r = rand(N1,M1);
% r = ones(N1,M1);
layer{3}.rows = N1;
layer{3}.columns = M1;
layer{3}.a = 0.02*ones(N1,M1);
layer{3}.b = 0.2*ones(N1,M1);
layer{3}.c = -65+15*r.^2;
layer{3}.d = 8-6*r.^2; 

% Layer 4 (inhibitory - low threshold spiking)
r = rand(N2,M2);
% r = ones(N2,M2);
layer{4}.rows = N2;
layer{4}.columns = M2;
layer{4}.a = 0.02+0.08*r;
layer{4}.b = 0.25-0.05*r;
layer{4}.c = -65*ones(N2,M2);
layer{4}.d = 2*ones(N2,M2);


% Connectivity matrix (synaptic weights)
% layer{i}.S{j} is the connectivity matrix from layer j to layer i
% s(i,j) is the strength of the connection from neuron j to neuron i

% Clear connectivity matrices
L = length(layer);
for i=1:L
   for j=1:L
      layer{i}.S{j} = [];
      layer{i}.factor{j} = [];
      layer{i}.delay{j} = [];
   end
end


% Excitatory to inhibitory connections

layer{2}.S{1} = rand(N2*M2,N1*M1);
layer{4}.S{3} = rand(N2*M2,N1*M1);


% Inhibitory to excitatory connections

layer{1}.S{2} = -rand(N1*M1,N2*M2);
layer{3}.S{4} = -rand(N1*M1,N2*M2);


% Excitatory to excitatory connections

CIJ = NetworkRandom(800,0.01);
layer{1}.S{1} = ones(N1*M1,N1*M1).*CIJ;

CIJ = NetworkRandom(800,0.01);
layer{3}.S{3} = ones(N1*M1,N1*M1).*CIJ;


% Inhibitory to inhibitory connections

layer{2}.S{2} = -rand(N2*M2,N2*M2);
layer{4}.S{4} = -rand(N2*M2,N2*M2);


% Coupling between populations (excitatory to excitatory)

CIJ1 = zeros(N1*M1,N1*M1);
CIJ2 = zeros(N1*M1,N1*M1);
for i = 1:N1*M1
   for j = 1:N1*M1
      if rand < 0.01
         CIJ1(i,j) = 1;
      end
      if rand < 0.01
         CIJ2(i,j) = 1;
      end
   end
end
layer{3}.S{1} = CIJ1;
layer{1}.S{3} = CIJ2;


% Coupling between populations (excitatory to inhibitory)

CIJ1 = zeros(N2*M2,N1*M1);
CIJ2 = zeros(N2*M2,N1*M1);
for i = 1:N2*M2
   for j = 1:N1*M1
      if rand < 0.01
         CIJ1(i,j) = 1;
      end
      if rand < 0.01
         CIJ2(i,j) = 1;
      end
   end
end
layer{4}.S{1} = CIJ1;
layer{2}.S{3} = CIJ2;



% Scaling factors

layer{2}.factor{1} = 2; % was 2

layer{1}.factor{2} = 2; % was 2

layer{1}.factor{1} = 17; % was 17 - use 5 if excitatory couplings exist

layer{2}.factor{2} = 2; % was 2


layer{4}.factor{3} = 2; % was 2

layer{3}.factor{4} = 2; % was 2

layer{3}.factor{3} = 17; % was 17 - use 5 if excitatory couplings exist

layer{4}.factor{4} = 2; % was 2


layer{3}.factor{1} = 0; % coupling strength - was 5

layer{1}.factor{3} = 0; % coupling strength - was 5


layer{4}.factor{1} = 12; % coupling strength - was 12

layer{2}.factor{3} = 12; % coupling strength - was 12



% Conduction delays
 
layer{2}.delay{1} = ones(N2*M2,N1*M1)*D1;

layer{1}.delay{2} = ones(N1*M1,N2*M2)*D1;

layer{1}.delay{1} = ones(N1*M1,N1*M1)*D1;

layer{2}.delay{2} = ones(N2*M2,N2*M2)*D1;


layer{4}.delay{3} = ones(N2*M2,N1*M1)*D2;

layer{3}.delay{4} = ones(N1*M1,N2*M2)*D2;

layer{3}.delay{3} = ones(N1*M1,N1*M1)*D2;

layer{4}.delay{4} = ones(N2*M2,N2*M2)*D2;


layer{3}.delay{1} = ones(N1*M1,N1*M1)*D;

layer{1}.delay{3} = ones(N1*M1,N1*M1)*D;


layer{4}.delay{1} = ones(N2*M2,N1*M1)*D;

layer{2}.delay{3} = ones(N2*M2,N1*M1)*D;


save('Network.mat','layer')
