function PlotConnectivity(CIJ,nodenames)
% Displays a network with connectivity matrix CIJ
% Assumes undirected edges

clf

% Compute node positions
N = length(CIJ);
set(gca,'XTickLabel',[])
angle = (2*pi)/N;
X = zeros(N,1); Y = zeros(N,1);
for i=1:N
    X(i) = cos(angle*(N-(i-1))+pi/2);
    Y(i) = sin(angle*(N-(i-1))+pi/2);
end

% Plot edges
[to,from] = find(CIJ);
for i=1:length(to),
    xf = X(from(i)); yf = Y(from(i));
    xt = X(to(i)); yt = Y(to(i));
    h = line([xf xt],[yf yt]);
    set(h,'LineWidth',1);
    set(h,'Color',[0 0 1]); % blue
end

% Plot nodes
hold on
for i=1:N
    h=plot(X(i),Y(i),'.');
    set(h,'Color',[1 0 0]);
    set(h,'MarkerSize',20);
    % hold on;
end

% Label nodes
XX=X*1.15;
YY=Y*1.15;
for i=1:N
    if(isempty(nodenames))
        h = text(XX(i),YY(i),num2str(i),'HorizontalAlignment','center');
    else
        h = text(XX(i),YY(i),nodenames{i},'HorizontalAlignment','center');
    end
    set(h,'FontSize',11)
end

set(gca,'Box','off')
axis('square')
axis off
xlim([-1.2 1.2]);
ylim([-1.2 1.2]);
