function SynchronisationIndex(firings1,firings2,MN,Tmax)
% Computes the synchronisation index between two populations given firing
% data firings1 and firings2, where MN is the total number of neurons in
% each population and Tmax is the length of the run that produced the data


% Moving averages of firing rates in Hz
ws = 10; % window size
disp = floor(ws/2); % extent of window is centre plus or minus disp 
ds = 1; % slide window by ds1
MF1 = zeros(1,Tmax);
MF2 = zeros(1,Tmax);
for j = disp+1:ds:Tmax-disp
   MF1(ceil(j/ds)) = sum(firings1(:,1) >= j-disp & ...
      firings1(:,1) <= j+disp) / (ws*MN) * 1000;
   MF2(ceil(j/ds)) = sum(firings2(:,1) >= j-disp & ...
      firings2(:,1) <= j+disp) / (ws*MN) * 1000;
end


% Centre time series on zero
MF1 = MF1 - mean(MF1);
MF2 = MF2 - mean(MF2);


% Pick out second half of time series only
MF1 = MF1(Tmax/2+1:Tmax);
MF2 = MF2(Tmax/2+1:Tmax);
Tmax = Tmax/2;


% Calculate phase using Hilbert transform
phase1 = angle(hilbert(MF1));
phase2 = angle(hilbert(MF2));


% Calculate synchronisation index
phi = abs( ( exp(sqrt(-1)*phase1)+exp(sqrt(-1)*phase2) ) / 2 );


display(mean(phi))


figure(1)
clf

% Plot mean firing rates
subplot(3,1,1)
plot(1:ds:Tmax,[MF1 ; MF2])
xlabel('Time (ms)')
ylabel('Mean firing rate');

% Plot phase
subplot(3,1,2)
plot(1:ds:Tmax,phase1,'Color','r')
hold on
plot(1:length(phase1),phase2,'Color','m')
xlabel('Time (ms)')
ylabel('Phase')

% Plot synchronisation index
subplot(3,1,3)
plot(1:ds:Tmax,phi,'Color',[0.75,0,0.75])
xlabel('Time (ms)')
ylabel('Sync. index')