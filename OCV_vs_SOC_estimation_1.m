data = readtable("OCV_vs_SOC_Lookup_Table.xlsx");
[SOC_c, idx1] = unique(data.SOC_Charging,'stable');
OCV_c = data.OCV_Charging(idx1);

[SOC_d, idx2] = unique(data.SOC_Discharging, 'stable');
SOC_d = SOC_d(1:572,:);
OCV_d = data.OCV_Discharging(idx2);
OCV_d = OCV_d(1:572,:);

table_chrg.SOC_c= SOC_c;
table_chrg.OCV_c=OCV_c;

table_dischrg.SOC_d= SOC_d;
table_dischrg.OCV_d=OCV_d;

writetable(struct2table(table_dischrg),"OCV_vs_SOC_Discharge.xlsx");
writetable(struct2table(table_chrg),"OCV_vs_SOC_Charge.xlsx");

