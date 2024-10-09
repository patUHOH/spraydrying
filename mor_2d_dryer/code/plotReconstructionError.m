% plot the reconstruction error over time

figure();
subplot(2,1,1);
deltaT = 0.05;
timeInstancesWithoutParticles = 0:deltaT:(size(temperatureDataWithoutParticles,2)-1)*deltaT;
plot(timeInstancesWithoutParticles, timeErrorWithoutParticles,'DisplayName','Pure DMD');
hold on;
plot(timeInstancesWithoutParticles, timeErrorWithoutParticlesKF,'DisplayName','DMD with KF');
xlabel('Time (s)');
ylabel('RMSE reconstruction w/o particles');
legend()
grid on;
subplot(2,1,2);
timeInstancesWithParticles = 0:deltaT:(size(temperatureData,2)-1)*deltaT;
plot(timeInstancesWithParticles, timeErrorWithParticles,'DisplayName','Pure DMD');
hold on;
plot(timeInstancesWithParticles, timeErrorWithParticlesKF,'DisplayName','DMD with KF');
xlabel('Time (s)');
ylabel('RMSE reconstruction w/ particles');
legend()
grid on;