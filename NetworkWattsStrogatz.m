function CIJ = NetworkWattsStrogatz(N,k,p)
% Creates a rign lattice with N nodes and neighbourhood size k, then
% rewires it according to the Watts-Strogatz procedure with probability p

CIJ = NetworkRingLattice(N,k);

for i = 1:N
   for j = i:N
      if CIJ(i,j) && rand < p
         CIJ(i,j) = 0;
         CIJ(j,i) = 0;
         h = mod(i+ceil(rand*(N-1))-1,N)+1;
         CIJ(i,h) = 1;
         CIJ(h,i) = 1;
      end
   end
end