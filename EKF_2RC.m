R0 = 0.02;   %From Curve fitting
Rp1 = 0.01;
Rp2 = 0.035;
Cp1 = 1450;
Cp2 = 2285.7;

Cn=4.426; %mAh

data=readtable("Finalised_Data.xlsx");
Im=(-1)*data.x_I__mA;
Vm=data.Ecell_V;
t=data.timestamp;
N=height(data);

z=zeros(3,N); %state vector estimate
z(1,1)=0.01;
z(2,1)=0;
z(3,1)=0;
P=diag([1, 1, 1]); %Error Cov Mat
Q=diag([1e-8 1e-5 1e-5]);  %process noise
R=0.01;   %Measurement Noise

SOC_est=zeros(N,1);
Vc1_est=zeros(N,1);
Vc2_est=zeros(N,1);
V_est=zeros(N,1);
V_t=zeros(N,1);
mode=1;
for k=2:N

    dt = t(k)-t(k-1);
    SOC=z(1,k-1);
    Vc1=z(2,k-1);
    Vc2=z(3,k-1);
    SOC_est=SOC-((1/3600*Cn)*dt*Im(k));
    Vc1_est=Vc1+dt*(Im(k)/Cp1 - Vc1/(Rp1*Cp1));
    Vc2_est=Vc2+dt*(Im(k)/Cp2 - Vc2/(Rp2*Cp2));
    z_est=[SOC_est;Vc1_est;Vc2_est];

    F=[1, 0, 0; 0, 1-dt/(Rp1*Cp1),0; 0, 0 ,1-dt/(Rp2*Cp2);]; %Jacobian 

    P_est=F*P*F'+Q; %Error Cov Mat Estimate
    
    if(Im(k)~=0)
    mode=sign(Im(k));
    end
    [OCV, dOCV]=get_OCV(SOC_est,mode);
    V_est=OCV-Im(k)*R0-Vc1_est-Vc2_est;
    H=[dOCV -1 -1];   %Measurement Jacobian

    K=P_est*H'/(H*P_est*H'+R);  %Kalman Gain

    e=Vm(k)-V_est; %calculate error

    z(:,k)=z_est+K*e;  %Update or Correction step
    P=(eye(3)-K*H)*P_est;  %Update Error Cov Mat

    z(1,k)=max(0,min(1,z(1,k)));

V_t(k)=OCV-Im(k)*R0-z(2,k)-z(3,k);
end



subplot(2,1,1);
plot(t,z(1,:))
hold on;
plot(t,(3 - data.x)/1.7589)
legend('EKF','Reference')
xlabel('time');
ylabel('SOC');

subplot(2,1,2)
plot(t(100:1255),V_t(100:1255))
hold on;
plot(t,Vm)
legend("EKF",'Reference');
xlabel('time');
ylabel('term volt');
