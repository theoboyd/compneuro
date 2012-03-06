function Run2L
% Simulates two layers (imported from saved file) of Izhikevich neurons


load('Network.mat','layer');

N1 = layer{1}.rows;
M1 = layer{1}.columns;

N2 = layer{2}.rows;
M2 = layer{2}.columns;

Dmax = 21; % Maximum propagation delay

Tmax = 1000; % Simulation time

Ib = 0; % Base current

MODULES = 8; % Number of modules
PERMODULE = 100;

% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end


% SIMULATE

for t = 1:Tmax
   
   % Display time every 10ms
   if mod(t,10) == 0
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


% % Plot membrane potentials
% 
% figure(1)
% clf
% 
% subplot(2,1,1)
% plot(1:Tmax,v1)
% title('Population 1 membrane potentials')
% ylabel('Voltage (mV)')
% ylim([-90 40])
% % xlabel('Time (ms)')
% 
% subplot(2,1,2)
% plot(1:Tmax,v2)
% % plot(1:Tmax,v2(:,1))
% title('Population 2 membrane potentials')
% ylabel('Voltage (mV)')
% ylim([-90 40])
% xlabel('Time (ms)')
% 
% 
% % Plot recovery variable
% 
% figure(2)
% clf
% 
% subplot(2,1,1)
% plot(1:Tmax,u1)
% title('Population 1 recovery variables')
% % xlabel('Time (ms)')
% 
% subplot(2,1,2)
% plot(1:Tmax,u2)
% % plot(1:Tmax,u2(:,1))
% title('Population 2 recovery variables')
% xlabel('Time (ms)')


% Matrix connectivity plot

figure(1)
clf

subplot(2,2,1)
imagesc(layer{1}.S{1})
title('Excitatory to excitatory')

subplot(2,2,2)
imagesc(layer{2}.S{1})
title('Excitatory to inhibitory')

subplot(2,2,3)
imagesc(layer{1}.S{2})
title('Inhibitory to excitatory')

subplot(2,2,4)
imagesc(layer{2}.S{2})
title('Inhibitory to inhibitory')

% Raster plots of firings

figure(2)
clf

subplot(2,1,1)
if ~isempty(firings1)
   plot(firings1(:,1),firings1(:,2),'.')
end
% xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number')
ylim([0 N1*M1+1])
set(gca,'YDir','reverse')
title('Excitatory neuron firings')

subplot(2,1,2)
if ~isempty(firings2)
   plot(firings2(:,1),firings2(:,2),'.')
end
xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number')
ylim([0 N2*M2+1])
set(gca,'YDir','reverse')
title('Inhibitory neuron firings')


% Mean firing rate plot

figure(3)
clf

xlim([0 Tmax])
winSize = 20;
windows = 1000/winSize;
bucket = zeros(MODULES, windows); % Buckets for each module 
for window=1:(windows-1)
    for firing=1:length(firings1)
        start = window*winSize;
        t = firings1(firing,1);
        v = firings1(firing,2);
        if ismember(t, start:(start + 20))
           % Time is within the range of the window
           bucket(ceil(v/PERMODULE), window) = bucket(ceil(v/PERMODULE), window) + 1;

        end
    end
end
for module=1:MODULES
    plot(1:windows, bucket((module-1)*windows+1 : module*windows))
    hold all
end
title('Module mean firing rates')
hold off

drawnow
