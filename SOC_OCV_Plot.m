table_dis=readtable("OCV_vs_SOC_Discharge.xlsx");
table_chrg=readtable("OCV_vs_SOC_Charge.xlsx");

OCV_c=table_chrg.OCV_c;
SOC_c=table_chrg.SOC_c;

OCV_d=table_dis.OCV_d;
SOC_d=table_dis.SOC_d;

plot(SOC_c,OCV_c);
hold on
plot(SOC_d,OCV_d);
legend('charging','discharge');
