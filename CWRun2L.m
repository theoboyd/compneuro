function CWRun2L(rewireProb, simTime)
% Simulates two layers (imported from saved file) of Izhikevich neurons


load('Network.mat','layer');

N1 = layer{1}.rows;
M1 = layer{1}.columns;

N2 = layer{2}.rows;
M2 = layer{2}.columns;

Dmax = 21; % Maximum propagation delay

Ib = 0; % Base current

MODULES = 8; % Number of modules
NpM = 100; % (Excitatory) neurons per module

% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end

% Simulate
for t = 1:simTime
   
   % Display time every 50ms
   if mod(t,50) == 0
      t
   end
   
   % Deliver a constant base current to layer 1
   layer{1}.I = Ib*ones(N1,M1);
   layer{2}.I = zeros(N2,M2);
   
   % Update all the neurons
   for lr=1:length(layer)
      layer = IzNeuronUpdate(layer,lr,t,Dmax);
      randomFires = find(poissrnd(0.001, [1 layer{lr}.rows])>0);
      for item=1:length(randomFires)
          layer{lr}.firings = [layer{lr}.firings ; [t randomFires(item)]];
      end
   end

   v1(t,1:N1*M1) = layer{1}.v;
   v2(t,1:N2*M2) = layer{2}.v;
   
   u1(t,1:N1*M1) = layer{1}.u;
   u2(t,1:N2*M2) = layer{2}.u;
      
end


firings1 = layer{1}.firings;
firings2 = layer{2}.firings;

% Add Dirac pulses (mainly for presentation)
if ~isempty(firings1)
   v1(sub2ind(size(v1),firings1(:,1),firings1(:,2))) = 30;
end
if ~isempty(firings2)
   v2(sub2ind(size(v2),firings2(:,1),firings2(:,2))) = 30;
end

% Matrix connectivity plot
ca = [-1.0 1.0];
f1 = figure(1);
clf

subplot(2,2,1)
imagesc(layer{1}.S{1}); caxis(ca)
title('Excitatory to excitatory')

subplot(2,2,2)
imagesc(layer{2}.S{1}); caxis(ca)
title('Excitatory to inhibitory')

subplot(2,2,3)
imagesc(layer{1}.S{2}); caxis(ca)
title('Inhibitory to excitatory')

subplot(2,2,4)
imagesc(layer{2}.S{2}); caxis(ca)
colorHandle = colorbar('SouthOutside');
title('Inhibitory to inhibitory')

set(colorHandle, 'Position', [0.468 0.495 0.1 0.04]);
suptitle('Matrix connectivity plot')

% Raster plots of firings
f2 = figure(2);
clf

subplot(2,1,1)
if ~isempty(firings1)
   plot(firings1(:,1),firings1(:,2),'.')
end
% xlabel('Time (ms)')
xlim([0 simTime])
ylabel('Neuron number')
ylim([0 N1*M1+1])
set(gca,'YDir','reverse')
title('Excitatory neuron firings')

subplot(2,1,2)
if ~isempty(firings2)
   plot(firings2(:,1),firings2(:,2),'.')
end
xlabel('Time (ms)')
xlim([0 simTime])
ylabel('Neuron number')
ylim([0 N2*M2+1])
set(gca,'YDir','reverse')
title('Inhibitory neuron firings')


% Mean firing rate plot
f3 = figure(3);
clf
winSize = 20;
windows = simTime/winSize;
bucket = zeros(MODULES, windows); % Buckets for each module
% movAvgBucket = zeros(MODULES, 1);
for window=0:(windows-1)
    for firing=1:length(firings1)
        start = (window*winSize) + 1;
        t = firings1(firing, 1);
        if ismember(t, start:(start + winSize))
           % Time is within the range of the window
           neuron = firings1(firing,2);
           bucket(ceil(neuron/NpM), window + 1) = bucket(ceil(neuron/NpM), window + 1) + 1;
        end
    end
end

% for module=1:MODULES
%     movAvgBucket(module) = tsmovavg(bucket(module), 's', 20, 1);
% end

for module=1:MODULES
    %plot(1:windows, movAvgBucket(module))
    %plot(1:windows, timeseries(bucket(module))
    plot(1:windows, bucket((module-1)*windows+1 : module*windows))
    hold all
end
xlabel('Time (ms)')
% xlim([0 windows*winSize])
% ticks = 10;
% xl = get(gca,'XLim'); 
% set(gca, 'XTick', linspace(xl(1), xl(2), ticks)) 
set(gca, 'XTickLabel', [0:windows*2:simTime]);
ylabel('Firings (Hz)')
title('Module mean firing rates')
hold off

drawnow

saveas(f1, ['CWQuestion1a-p', num2str(rewireProb), '.fig'], 'fig')
saveas(f2, ['CWQuestion1b-p', num2str(rewireProb), '.fig'], 'fig')
saveas(f3, ['CWQuestion1c-p', num2str(rewireProb), '.fig'], 'fig')