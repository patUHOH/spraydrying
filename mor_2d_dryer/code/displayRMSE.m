figure;
subplot(3,2,1)
semilogy(reducedOrders,rmseAllTemperature,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseAllKFTemperature,'o-','DisplayName','ROM+KF')
legend()
title('Temperature all')
subplot(3,2,3)
semilogy(reducedOrders,rmseWithoutParticlesTemperature,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseWithoutParticlesKFTemperature,'o-','DisplayName','ROM+KF')
legend()
title('Temperature without particles')
subplot(3,2,5)
semilogy(reducedOrders,rmseWithParticlesTemperature,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseWithParticlesKFTemperature,'o-','DisplayName','ROM+KF')
legend()
title('Temperature with particles')
subplot(3,2,2)
semilogy(reducedOrders,rmseAllHumidity,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseAllKFHumidity,'o-','DisplayName','ROM+KF')
legend()
title('Humidity all')
subplot(3,2,4)
semilogy(reducedOrders,rmseWithoutParticlesHumidity,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseWithoutParticlesKFHumidity,'o-','DisplayName','ROM+KF')
legend()
title('Humidity without particles')
subplot(3,2,6)
semilogy(reducedOrders,rmseWithParticlesHumidity,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseWithParticlesKFHumidity,'o-','DisplayName','ROM+KF')
legend()
title('Humidity with particles')
exportPlots('RMSE')