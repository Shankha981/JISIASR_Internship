R0 = 0.02;   %From Curve fitting
R1 = 0.01;
R2 = 0.035;
C1 = 1450;
C2 = 2285.7;

f = logspace(-3,5,10000);
w = 2*pi*f;

Z = R0 + R1./(1 + 1j*w*R1*C1) ...
       + R2./(1 + 1j*w*R2*C2);

figure
plot(real(Z),-imag(Z),'LineWidth',1)
xlabel('Z'' (\Omega){Resistance}')
ylabel('-Z'''' (\Omega){Reactance}')
title('Nyquist Plot (2RC Model)')
grid on
axis equal