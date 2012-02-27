function CIJ = CW(NE, NEM, NI, p)
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

% Make blank brain
completeBrain = CWCompleteNet(NI+NE, 0);

% Create NE modules
for m = 1:NEM
   for i = ((m-1)*NE + 1):((m)*NE + 1)
      for j = ((m-1)*NE + 1):((m)*NE + 1)
         completeBrain(i, j) = rand < p;
      end
   end
end

CIJ = completeBrain;