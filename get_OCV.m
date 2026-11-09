function [OCV,dOCV] = get_OCV(SOC_query,mode)

% mode = 1  -> Charging
% mode = -1 -> Discharging

persistent SOC_c SOC_d OCV_c OCV_d dOCV_c dOCV_d

if isempty(SOC_c)

    data_c = readtable("OCV_vs_SOC_Charge.xlsx");
    data_d = readtable("OCV_vs_SOC_Discharge.xlsx");

    % Charging data
    SOC_c = data_c.SOC_c;
    OCV_c = data_c.OCV_c;

    % Discharging data
    SOC_d = data_d.SOC_d;
    OCV_d = data_d.OCV_d;

    % Remove NaNs
    idx_c = ~(isnan(SOC_c) | isnan(OCV_c));
    idx_d = ~(isnan(SOC_d) | isnan(OCV_d));

    SOC_c = SOC_c(idx_c);
    OCV_c = OCV_c(idx_c);

    SOC_d = SOC_d(idx_d);
    OCV_d = OCV_d(idx_d);

    [SOC_c,idx] = sort(SOC_c);
    OCV_c = OCV_c(idx);

    [SOC_d,idx] = sort(SOC_d);
    OCV_d = OCV_d(idx);

    % Slopes
    dOCV_c = gradient(OCV_c)./gradient(SOC_c);
    dOCV_d = gradient(OCV_d)./gradient(SOC_d);

    % Plateau regions
    eps_slope = 1e-6;

    dOCV_c(abs(dOCV_c) < eps_slope) = eps_slope;
    dOCV_d(abs(dOCV_d) < eps_slope) = eps_slope;

end

if mode == 1

    OCV = interp1(SOC_c,OCV_c,SOC_query,'pchip');

    dOCV = interp1(SOC_c,dOCV_c,SOC_query,'pchip');

elseif mode == -1

    OCV = interp1(SOC_d,OCV_d,SOC_query,'pchip');

    dOCV = interp1(SOC_d,dOCV_d,SOC_query,'pchip');

else

    error('Mode must be 1 (charge) or -1 (discharge)');

end

end