function CWPlotMatrix(matrix)
M = matrix';
[x, y] = size(M);

figure;
hold on;
xlim([1 x])
ylim([1 y])
for i = 1:x
   for j = 1:y
      if M(i, j)
          scatter(i, y-j+1);
      end
   end
end