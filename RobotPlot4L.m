function RobotPlot4L(v)
% Plot membrane potentials v

figure(1)
clf

subplot(2,2,1)
plot(1:length(v{1}),v{1})
title('Left sensory neurons')
ylabel('Voltage (mV)')
ylim([-90 40])
xlabel('Time (ms)')

subplot(2,2,2)
plot(1:length(v{2}),v{2})
title('Right sensory neurons')
ylabel('Voltage (mV)')
ylim([-90 40])
xlabel('Time (ms)')

subplot(2,2,3)
plot(1:length(v{3}),v{3})
title('Left motor neurons')
ylabel('Voltage (mV)')
ylim([-90 40])
xlabel('Time (ms)')

subplot(2,2,4)
plot(1:length(v{4}),v{4})
title('Right motor neurons')
ylabel('Voltage (mV)')
ylim([-90 40])
xlabel('Time (ms)')
