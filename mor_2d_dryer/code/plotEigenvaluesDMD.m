% plot eigenvalues
figure();
subplot(1,2,1)
plot(real(lambdasTemperature), imag(lambdasTemperature), 'kx', 'MarkerSize', 10,'DisplayName','DMD');
grid on;
hold on;
xlabel('Real Part of Eigenvalues');
ylabel('Imaginary Part of Eigenvalues');
title('Eigenvalues in Complex Plane');
% add unit circle to plot
hold on;
plot(cos(0:0.01:2*pi), sin(0:0.01:2*pi), 'k--');
axis equal;
hold off;
legend();
title('Temperature')

subplot(1,2,2)
plot(real(lambdasHumidity), imag(lambdasHumidity), 'kx', 'MarkerSize', 10,'DisplayName','DMD');
grid on;
hold on;
xlabel('Real Part of Eigenvalues');
ylabel('Imaginary Part of Eigenvalues');
title('Eigenvalues in Complex Plane');
% add unit circle to plot
hold on;
plot(cos(0:0.01:2*pi), sin(0:0.01:2*pi), 'k--');
axis equal;
hold off;
legend();
title('Humidity')