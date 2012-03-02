function CWConnect2L
% Constructs two layers of Izhikevich neurons and connects them together


% Layers are N by M arrays of neurons

Width1 = 800;
Height1 = 1;

Width2 = 200;
Height2 = 1;

NEEC = 500;
NE = 100;
probNEEC = NEEC / (NE*NE);

F = 50/sqrt(Width1*Height1); % scaling factor

D = 5; % conduction delay


% Neuron parameters
% Each layer comprises a heterogenous set of neurons, with a small spread
% of parameter values, so that they exhibit some dynamical variation
% (To get a homogenous population of canonical "regular spiking" neurons,
% multiply r by zero.)

% Layer 1 (regular spiking)
r = rand(Width1,Height1);
layer{1}.rows = Width1;
layer{1}.columns = Height1;
layer{1}.a = 0.02*ones(Width1,Height1);
layer{1}.b = 0.2*ones(Width1,Height1);
layer{1}.c = -65+15*r.^2;
layer{1}.d = 8-6*r.^2;

% Layer 2 (regular spiking)
r = rand(Width2,Height2);
layer{2}.rows = Width2;
layer{2}.columns = Height2;
layer{2}.a = 0.02*ones(Width2,Height2);
layer{2}.b = 0.25*ones(Width2,Height2);
layer{2}.c = -65+15*r.^2;
layer{2}.d = 2-6*r.^2;


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

% Inhib to excit
layer{1}.S{2} = ones(Width1*Height1,Width2*Height2); % all to all connections

% Inhib to inhib
layer{2}.S{2} = ones(Width2*Height2, 1);

% Excitatory to excitatory
layer{1}.S{1} = rand(Width1*Height1,1)<; 

% Excitatory to inhibitory
layer{2}.S{1} = 

layer{2}.factor{1} = F; % scaling factor

layer{2}.delay{1} = ones(Width2*Height2,Width1*Height1)*D; % conduction delays


save('Network.mat','layer');
