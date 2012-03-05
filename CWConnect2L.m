function CWConnect2L(rewireProb)
% Constructs two layers of Izhikevich neurons and connects them together

% Layers are N by M arrays of neurons
MODULES = 8;                    % Number of modules
NpM = 100;                      % (Excitatory) neurons per module

NEEC = 1000;                     % Number of excitatory-to-excitatory connections per module
probNEEC = NEEC / (NpM*NpM);    % Probability of a possible intra-module connection being made

ENs = NpM*MODULES;              % How many excitatory neurons?
INs = 200;                      % How many inhibitory neurons?

EN = 1; % Layer labels
IN = 2;

SFSF = 1/sqrt(EN*IN); % Scaling-factor scaling factor


% Neuron parameters
% Each layer comprises a heterogenous set of neurons, with a small spread
% of parameter values, so that they exhibit some dynamical variation
% (To get a homogenous population of canonical "regular spiking" neurons,
% multiply r by zero.)

% Layer 1 (regular spiking)
r = rand(ENs,1);
layer{EN}.rows = ENs;
layer{EN}.columns = 1;
layer{EN}.a = 0.02*ones(ENs,1);
layer{EN}.b = 0.2*ones(ENs,1);
layer{EN}.c = -65+15*r.^2;
layer{EN}.d = 8-6*r.^2;

% Layer 2 (inh spiking)
r = rand(INs,1);
layer{IN}.rows = INs;
layer{IN}.columns = 1;
layer{IN}.a = 0.02*ones(INs,1);
layer{IN}.b = 0.25*ones(INs,1);
layer{IN}.c = -65+15*r.^2;
layer{IN}.d = 2-6*r.^2;


% Connectivity matrix (synaptic weights)
% layer{i}.S{j} is the connectivity matrix from layer j to layer i
% s(i,j) is the strength of the connection from neuron j to neuron i

% Clear connectivity matrices (YAY GLOBALS D:)
L = length(layer);
for i=1:L
   for j=1:L
      layer{i}.S{j} = [];
      layer{i}.factor{j} = [];
      layer{i}.delay{j} = [];
   end
end

% Excitatory to excitatory
layer{EN}.factor{EN} = 17*SFSF;
layer{EN}.delay{EN} = rand(ENs,ENs)*20;
layer{EN}.S{EN} = zeros(ENs,ENs);
for module=0:(MODULES-1)
    offset = module*NpM;
    for n1=1:NpM
        for n2=1:NpM
            if rand()<probNEEC
                if rand()<rewireProb
                    layer{EN}.S{EN}(randi([1 ENs]), n2+offset) = 1; % As if it's been randomly rewired to a new destination (anywhere!)
                else
                    layer{EN}.S{EN}(n1+offset, n2+offset) = 1;      % Normal intra-cluster connection
                end
            end
        end
    end
end

% Excitatory to inhibitory
layer{IN}.factor{EN} = 50*SFSF;
layer{IN}.delay{EN} = ones(INs,ENs);
layer{IN}.S{EN} = zeros(INs,ENs);
for inh=1:INs
    module=randi([0 MODULES-1]);
    for xx=1:4
        layer{IN}.S{EN}(inh, module*NpM + randi([1 NpM])) = rand(); % TODO Could pick the same source exc. neuron twice! (fix plz)
    end
end

% Inhibitory to excitatory
layer{EN}.factor{IN} = 2*SFSF;
layer{EN}.delay{IN} = ones(ENs,INs);
layer{EN}.S{IN} = -1*rand(ENs,INs); % all to all connections

% Inhibitory to inhibitory
layer{IN}.factor{IN} = 1*SFSF;
layer{IN}.delay{IN} = ones(INs,INs);
layer{IN}.S{IN} = -1*rand(INs, INs); % all to all connections

save('Network.mat','layer');
