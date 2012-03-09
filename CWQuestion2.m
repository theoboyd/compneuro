function CWQuestion2

TRIALS = 10; % Number of trials
C = zeros(TRIALS, 2);

f4 = figure;
clf
xlabel('Rewiting probability p')
xlim([0.1 0.5])
ylabel('Neural complexity')
ylim([0 0.01])
title('Neural complexity')

for xx=1:TRIALS
    rewireProb = 0.1 + (0.4).*rand(); % Random value between 0.1 and 0.5
    CWConnect2L(rewireProb);
    C(xx, :) = [rewireProb CWComplexityRun(6000)];     %TODO make 60000
end
scatter(C(:,1), C(:,2), 'x')

%draw now
saveas(f4, ['CWQuestion2.fig'], 'fig')