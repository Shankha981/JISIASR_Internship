data = readtable("NVP_Full_Cycling_0to100.xlsx");
data=data(11:end,:);
Cn=data.NVP_mAh_g;
Cycle=data.Cycle;
CE=data.NVP_CE__;

theta0 = [88 -0.1];
model = @(theta,Cycle) theta(1)+theta(2).*Cycle;
cost = @(theta)sum((Cn - model(theta,Cycle)).^2);
options = optimset('Display','iter', 'MaxIter',10000,'MaxFunEvals',100000);

theta_opt = fminsearch(cost,theta0,options);

Q0=theta_opt(1);
k=theta_opt(2);

fprintf('Q0= %.3f\n',Q0);
fprintf("k=%.3f\n",k);

Cn_fit=model(theta_opt,Cycle);




%subplot(2,1,1);
plot(Cycle,Cn_fit);
hold on;
plot(Cycle,Cn);
grid on;
legend('Curve Fit','Actual Data');
xlabel("Cycle num.");
ylabel("Nominal Capcity(mAh)");

%subplot(2,1,2);
%plot(Cycle,CE);
%grid on;
%xlabel("Cycle num.");
%ylabel("Coulombic Efficiency");