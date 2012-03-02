function ouput = CW(NE, NEM, NI, p)
% NE: number of excitatory neurons in a module
% NEM: number of excitarory neuron modules
% NI: number of inhibitory neurons total
% p: Rewiring probability
% Allowing neurons to connect to themselves

% Generate randomly wired communities

%for i = 1:NEM
%   excitatoryCommunity = NetworkRandom(NE, p);
%end

%inhibitoryCommunity = CWCompleteNet(NI, 1)

% Coursework constants
NEEC = 500; % number of excitatory-excitatory connections in a module

% Make blank brain
total = NI + (NE * NEM);
connectivityMatrix = CWCompleteNet(total, 0);
neuronArray = zeros(1, total);

% Create NE modules
probNEEC = NEEC / (NE*NE);
for m = 1:NEM
    for i = ((m-1)*NE + 1):((m)*NE)
       for j = ((m-1)*NE + 1):((m)*NE)
          connectivityMatrix(i, j) = rand < probNEEC;
       end
    end
end

% Create NI module
startNI = (NE * NEM) + 1
endNI = total
NENEM = NE*NEM;

connectivityMatrix(startNI:endNI, 1:total) = ones(endNI-startNI+1, total);

% Build incoming connections to inhibitory
counter = 0;
for i = startNI:endNI
   for j = 1:total
       % Bring in connections from four excitatory neurons from one module
       moduleOffset = 100 * randi([0, (NEM - 1)]); % Pick a random module
       

   end
   
   for n = 1:4
      neuron = moduleOffset + randi([1, NE]);
      % Find one of this neuron's ex-ex connections to rewire
      indices = find(connectivityMatrix(1:NENEM, neuron));
      indices = indices';
      [~, length] = size(indices);
      if length == 0
          n = n - 1;
      else
          index = randi([1, length]);
          % Rewire to our inhibitory neuron
          counter = counter + 1
          connectivityMatrix(indices(index), neuron) = 0;     
          connectivityMatrix(j, neuron) = 1;
      end
   end
end

ouput = connectivityMatrix;