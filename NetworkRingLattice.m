function CIJ = NetworkRingLattice(N,k)
% Creates a ring lattice with N nodes and neighbourhood size k

CIJ = zeros(N,N);

for i = 1:N
   for j = i:N
      if i ~= j && min(abs(i-j),N-abs(i-j)) <= k/2
         CIJ(i,j) = 1;
         CIJ(j,i) = CIJ(i,j);
      end
   end
end