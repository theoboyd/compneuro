function C = CWComplexityRun(simTime)
% Simulates two layers (imported from saved file) of Izhikevich neurons


load('Network.mat','layer');

N1 = layer{1}.rows;
M1 = layer{1}.columns;

N2 = layer{2}.rows;
M2 = layer{2}.columns;

Dmax = 21; % Maximum propagation delay

Ib = 0; % Base current

MODULES = 8; % Number of modules
NpM = 100; % (Excitatory) neurons per module

% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end

% Simulate
for t = 1:simTime
   
   % Display time every 50ms
   if mod(t,50) == 0
      t
   end
   
   % Deliver a constant base current to layer 1
   layer{1}.I = Ib*ones(N1,M1);
   layer{2}.I = zeros(N2,M2);
   
   % Update all the neurons
   for lr=1:length(layer)
      layer = IzNeuronUpdate(layer,lr,t,Dmax);
      randomFires = find(poissrnd(0.001, [1 layer{lr}.rows])>0);
      for item=1:length(randomFires)
          layer{lr}.firings = [layer{lr}.firings ; [t randomFires(item)]];
      end
   end

   v1(t,1:N1*M1) = layer{1}.v;
   v2(t,1:N2*M2) = layer{2}.v;
   
   u1(t,1:N1*M1) = layer{1}.u;
   u2(t,1:N2*M2) = layer{2}.u;
      
end


firings1 = layer{1}.firings;
firings2 = layer{2}.firings;

% Add Dirac pulses (mainly for presentation)
if ~isempty(firings1)
   v1(sub2ind(size(v1),firings1(:,1),firings1(:,2))) = 30;
end
if ~isempty(firings2)
   v2(sub2ind(size(v2),firings2(:,1),firings2(:,2))) = 30;
end

winSize = 20;
windows = simTime/winSize;
bucket = zeros(MODULES, windows); % Buckets for each module
% movAvgBucket = zeros(MODULES, 1);
for window=50:(windows-1) % discard a full second at the start
    for firing=1:length(firings1)
        start = (window*winSize) + 1;
        t = firings1(firing, 1);
        if ismember(t, start:(start + winSize))
           % Time is within the range of the window
           neuron = firings1(firing,2);
           bucket(ceil(neuron/NpM), window + 1) = bucket(ceil(neuron/NpM), window + 1) + 1;
        end
    end
end

differenced = aks_diff(bucket); % Difference once
differenced = aks_diff(differenced)'; % Difference twice

C = neuralComplexity(differenced);

end

function sum = neuralComplexity(S)
    sum = 0;
    [q n] = size(S);
    for xx=1:n
       sum = sum + MI(S(:, xx), S) - I(S);
    end
end

function output = MI(X, S)
    output = H(X) + H(setdiff(S(:), [X])) - H(S);
end

function output = H(S)
    [q n] = size(S);
    abscovar =  det(cov(S));
    logpart = log(2 * pi * exp(1)) .^n;
    output = 0.5 * logpart * abscovar;
end

function sum = I(S)
    sum = 0;
    [q n] = size(S);
    for xx=1:n
        sum = sum + H(S(:, xx)) - H(S);
    end
end