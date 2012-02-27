function Connect2L
% Constructs two layers of Izhikevich neurons and connects them together


% Layers are N by M arrays of neurons

N1 = 4;
M1 = 1;

N2 = 4;
M2 = 1;

F = 50/sqrt(N1*M1); % scaling factor

D = 5; % conduction delay


% Neuron parameters
% Each layer comprises a heterogenous set of neurons, with a small spread
% of parameter values, so that they exhibit some dynamical variation
% (To get a homogenous population of canonical "regular spiking" neurons,
% multiply r by zero.)

% Layer 1 (regular spiking)
r = rand(N1,M1);
layer{1}.rows = N1;
layer{1}.columns = M1;
layer{1}.a = 0.02*ones(N1,M1);
layer{1}.b = 0.2*ones(N1,M1);
layer{1}.c = -65+15*r.^2;
layer{1}.d = 8-6*r.^2;

% Layer 2 (regular spiking)
r = rand(N2,M2);
layer{2}.rows = N2;
layer{2}.columns = M2;
layer{2}.a = 0.02*ones(N2,M2);
layer{2}.b = 0.2*ones(N2,M2);
layer{2}.c = -65+15*r.^2;
layer{2}.d = 8-6*r.^2;


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

layer{2}.S{1} = ones(N2*M2,N1*M1); % all to all connections

layer{2}.factor{1} = F; % scaling factor

layer{2}.delay{1} = ones(N2*M2,N1*M1)*D; % conduction delays


save('Network.mat','layer');
