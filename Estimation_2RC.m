clc
clear

data = readtable("Finalised_Data.xlsx");
data = data(1:150,:);

Vm = data.Ecell_V;
Im = data.x_I__mA/1000;
t  = data.timestamp;

SOC0 = (3 - data.x)/1.7589;
[OCV,~] = get_OCV(SOC0,1);

theta0 = [0.02 0.01 4.5 0.035 80];   %Rs Rp1 Cp1 Rp2 Cp2

model = @(theta,t) OCV...
    + Im.*theta(1) ...
    + Im.*theta(2).*(1-exp(-t./theta(3))) ...
    + Im.*theta(4).*(1-exp(-t./theta(5)));

cost = @(theta) ...
    sum((Vm - model(theta,t)).^2);

options = optimset( ...
    'Display','iter', ...
    'MaxIter',10000, ...
    'MaxFunEvals',100000);

theta_opt = fminsearch(cost,theta0,options);

Rs   = theta_opt(1);
Rp1  = theta_opt(2);
tau1 = theta_opt(3);

Rp2  = theta_opt(4);
tau2 = theta_opt(5);

Cp1 = tau1/Rp1;
Cp2 = tau2/Rp2;

fprintf('Rs  = %.6f\n',Rs)
fprintf('Rp1 = %.6f\n',Rp1)
fprintf('Cp1 = %.2f\n',Cp1)
fprintf('Rp2 = %.6f\n',Rp2)
fprintf('Cp2 = %.2f\n',Cp2)

Vm_fit = model(theta_opt,t);

figure
plot(t,Vm)
hold on
plot(t,Vm_fit)
grid on
legend('Measured','Fit')