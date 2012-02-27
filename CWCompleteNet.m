function CIJ = CWCompleteNet(N, p)
CIJ = zeros(N,N);

for i = 1:N
   for j = i:N
      CIJ(i,j) = rand < p;
      CIJ(j,i) = CIJ(i,j);
   end
end