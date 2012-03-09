function CWQuestion2

rewireProb = 0.1 + (0.4).*rand(); % Random value between 0.1 and 0.5
CWConnect2L(rewireProb);
CWComplexityRun(60); %TODO make 60000
