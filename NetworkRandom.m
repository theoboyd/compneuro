function CIJ = NetworkRandom(N,p)
% Creates a random network with N nodes and probability of connection p

CIJ = zeros(N,N);

for i = 1:N
   for j = i:N
      if i ~= j
         CIJ(i,j) = rand < p;
         CIJ(j,i) = CIJ(i,j);
      end
   end
end