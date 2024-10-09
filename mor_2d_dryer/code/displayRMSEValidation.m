figure;
subplot(1,2,1)
semilogy(reducedOrders,rmseValidationTemperature,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseValidationKFTemperature,'o-','DisplayName','ROM+KF')
legend()
title('Temperature all')
subplot(1,2,2)
semilogy(reducedOrders,rmseValidationHumidity,'o-','DisplayName','ROM')
hold on; grid on;
semilogy(reducedOrders,rmseValidationKFHumidity,'o-','DisplayName','ROM+KF')
legend()
title('Humidity')
sgtitle('Validation Dataset')
exportPlots('RMSEValidation')