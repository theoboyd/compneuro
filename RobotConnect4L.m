function RobotConnect4L
% Constructs four layers of Izhikevich neurons and connect them together
% Layers 1 and 2 comprise sensory neurons, while layers 3 and 4 comprise
% motor neurons. Sensory neurons excite contralateral motor neurons causing
% seeking behaviour. Layers are heterogenous populations of neurons


% Layers are N by M arrays of neurons

N1 = 4; % try 1, 4, and 8
M1 = 1;

N2 = 4; % try 1, 4, and 8
M2 = 1;

F = 50/sqrt(N1*M1); % scaling factor

D = 4; % conduction delay


% Neuron parameters
% Excitatory neurons are "regular spiking" (Izhikevich, 2003)
% Each layer comprises a heterogenous set of neurons, with a small spread
% of parameter values, so that they exhibit some dynamical variation
% (To get a homogenous population of canonical "regular spiking" neurons,
% multiply r by zero.)

% Layer 1 (left sensory neurons)
r = rand(N1,M1);
layer{1}.name = 'Layer 1';
layer{1}.rows = N1;
layer{1}.columns = M1;
layer{1}.a = 0.02*ones(N1,M1);
layer{1}.b = 0.2*ones(N1,M1);
layer{1}.c = -65+15*r.^2;
layer{1}.d = 8-6*r.^2;

% Layer 2 (right sensory neurons)
r = rand(N1,M1);
layer{2}.name = 'Layer 2';
layer{2}.rows = N1;
layer{2}.columns = M1;
layer{2}.a = 0.02*ones(N1,M1);
layer{2}.b = 0.2*ones(N1,M1);
layer{2}.c = -65+15*r.^2;
layer{2}.d = 8-6*r.^2;

% Layer 3 (left motor neurons)
r = rand(N2,M2);
layer{3}.name = 'Layer 3';
layer{3}.rows = N2;
layer{3}.columns = M2;
layer{3}.a = 0.02*ones(N2,M2);
layer{3}.b = 0.2*ones(N2,M2);
layer{3}.c = -65+15*r.^2;
layer{3}.d = 8-6*r.^2;

% Layer 4 (right motor neurons)
r = rand(N2,M2);
layer{4}.name = 'Layer 4';
layer{4}.rows = N2;
layer{4}.columns = M2;
layer{4}.a = 0.02*ones(N2,M2);
layer{4}.b = 0.2*ones(N2,M2);
layer{4}.c = -65+15*r.^2;
layer{4}.d = 8-6*r.^2;


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

% Connect 2 to 3 and 1 to 4 for seeking behaviour

layer{3}.S{2} = ones(N2*M2,N1*M1);
layer{4}.S{1} = ones(N2*M2,N1*M1);


% Scaling factors

layer{3}.factor{2} = F;
layer{4}.factor{1} = F;


% Conduction delays

layer{3}.delay{2} = ones(N2*M2,N1*M1)*D;
layer{4}.delay{1} = ones(N2*M2,N1*M1)*D;


save('Network.mat','layer');
