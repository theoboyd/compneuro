function [firings1, firings3] = Sync2Run


load('Network.mat','layer')


N1 = layer{1}.rows;
M1 = layer{1}.columns;
MN = M1*N1;

N2 = layer{2}.rows;
M2 = layer{2}.columns;


Dmax = 10; % maximum propagation delay

Tmax = 1000; % simulation time per episode


% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end


% SIMULATE

sec = 1;

Ib = 5; % was 5

while sec <= 1


   for t = 1:Tmax

      % Display time every 10ms
      if mod(t,10) == 0
         t
      end

      % Deliver base current
      layer{1}.I = Ib*randn(N1,M1);
      layer{2}.I = Ib*randn(N2,M2);
      if t > 12 % delay the onset of activity for the second population
         layer{3}.I = Ib*randn(N1,M1);
         layer{4}.I = Ib*randn(N2,M2);
      else
         layer{3}.I = zeros(N1,M1);
         layer{4}.I = zeros(N2,M2);
      end
      

%       % Deliver a Poisson spike stream
%       lambda = 0.01; % was 0.001
%       layer{1}.I = 15*(poissrnd(lambda*15,N1,M1) > 0);
%       layer{2}.I = 15*(poissrnd(lambda*15,N2,M2) > 0);

%       % Deliver a single spike to a single neuron
%       if t == 1
%          i = ceil(rand*N1);
%          j = ceil(rand*M1);
%          layer{1}.I(i,j) = 15;
%       end
% 

      % Update all the neurons
      for lr=1:length(layer)
         layer = IzNeuronUpdate(layer,lr,t,Dmax);
      end
   

   end
      
          
   firings1 = layer{1}.firings;
   firings2 = layer{2}.firings;
   firings3 = layer{3}.firings;
   firings4 = layer{4}.firings;
   

   % Moving averages of firing rates in Hz for excitatory population
   ws = 10; % window size - must be greater than or equal to Dmax
   ds = 1; % slide window by ds
   MF1 = zeros(1,ceil(Tmax/ds));
   MF3 = zeros(1,ceil(Tmax/ds));
   % MF(i,j) is the firing rate for the ith largest module for the
   % ws data points up to but not including j
   for j = 1:ds:Tmax
         MF1(1,ceil(j/ds)) = sum(firings1(:,1) >= j-ws & ...
            firings1(:,1) < j) / (ws*MN) * Tmax;
         MF3(1,ceil(j/ds)) = sum(firings3(:,1) >= j-ws & ...
            firings3(:,1) < j) / (ws*MN) * Tmax;
   end
   

   figure(1)
   clf

   % Raster plots of firings
   subplot(2,1,1)
   if ~isempty(firings1)
      plot(firings1(:,1),firings1(:,2),'.')
   end
   xlabel(['Time (ms) + ',num2str(sec-1),'s'])
   xlim([0 Tmax])
   ylabel('Neuron number')
   ylim([0 N1*M1+1])
   set(gca,'YDir','reverse')
   
   subplot(2,1,2)
   if ~isempty(firings3)
      plot(firings3(:,1),firings3(:,2),'.')
   end
   xlabel(['Time (ms) + ',num2str(sec-1),'s'])
   xlim([0 Tmax])
   ylabel('Neuron number')
   ylim([0 N1*M1+1])
   set(gca,'YDir','reverse')
   

   figure(2)
   clf

   % Plot mean firing rates
   % subplot(2,1,1);
   plot(1:ds:Tmax,[MF1 ; MF3])
   xlabel(['Time (ms) + ',num2str(sec-1),'s'])
   ylabel('Mean firing rate');

%    subplot(2,1,2);
%    plot(1:ds:Tmax,MF3)
%    xlabel(['Time (ms) + ',num2str(sec-1),'s'])
%    ylabel('Mean firing rate');

   drawnow
   
   
   % Preserve firings for last ws milliseconds
   ind = find(firings1(:,1) >= Tmax+1-ws);
   layer{1}.firings = [firings1(ind,1)-Tmax, firings1(ind,2)];
   ind = find(firings2(:,1) >= Tmax+1-ws);
   layer{2}.firings = [firings2(ind,1)-Tmax, firings2(ind,2)];
   ind = find(firings3(:,1) >= Tmax+1-ws);
   layer{3}.firings = [firings3(ind,1)-Tmax, firings3(ind,2)];
   ind = find(firings4(:,1) >= Tmax+1-ws);
   layer{4}.firings = [firings4(ind,1)-Tmax, firings4(ind,2)];
   
   
   sec = sec+1;
   
   
end
