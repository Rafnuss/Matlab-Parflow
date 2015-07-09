function ET=PenmanMonteith(d)

% Function to calculate the potential evaporation from the Penman Monteith
% equation, given in Allen et al, 1994, eqn 2.1

% Input variables:
% SRn - Net short wave radiation        (W/m2)
% LRn - Net long wave radiation         (W/m2)
% G - Soil heat flux                    (W/m2)
% P - Atmospheric pressure              (mbar) or(Pa)
% U - wind speed at 2m above GL         (m/s)
% r - relative humidity                 (%)
% T - Temperature                       (oC)
SRn=d.energy.Sin';
LRn=d.energy.Lin';
G=reshape(mean(mean(d.energy.G,2),1),1,d.time.nt+1);
P=d.air.pressure';
U=sqrt(d.windspeed.EW.^2+d.windspeed.NS.^2)';
T=d.temp.a';
Md = 0.028964; % Molar mass of dry air
Mw = 0.018016; % Molar mass of humid air
r   =  d.air.SH'  ./ (Mw./Md .*0.611   .*exp(  (T+273.15-273.15) ...
        .*17.3 ./  (T+273.15-35.85  ))  ./P.*1000);



%P=P.*100;               % Unit coversion - mbar to Pa

% Net radiation is sum of net short and long wave rad.
Rn=SRn+LRn;                                 % Eqn 1.35

% Specific heat of moist air, J/kg/oC
Cp=1013;                                    % Below eqn 1.4

% Latent heat of vapourisation, J/kg
lambda=(2.501-T.*0.002361).*1e6;            % Eqn 1.1

% Saturation vapour pressure, Pa
ea=611.*exp((17.27.*T)./(T+237.3));         % Eqn 1.10

% Actual vapour pressure, Pa
ed=ea.*r./100;                              % Eqn 1.17
ed(r>100)=ea(r>100);                        % Truncate such that r<=100%

% Slope of vapour pressure curve, Pa/oC
delta=4099.*ea./(T+237.3).^2;               % Eqn 1.3

% Virtual temperature, K
Tkv=1.01*(T+273).*(1-0.378.*ed./P).^-1;     % eqn 1.8

% Atmospheric density, kg/m3
rho=P./Tkv/287;                             % Eqn 1.7 scaled for units

% Psychrometric constant, Pa/oC
gamma=Cp.*P./0.622./lambda;                 % Eqn 1.4 scaled for units

% Surface resistance, for grass reference crop, s/m
rs=70;                                      % Eqn 2.5

% Aerodynamic resistance, for grass reference crop, s/m
ra=208./U;                                  % Eqn 2.10

% Latent heat flux density of evaporation, J/m2/s, eqn2.1 in SI units
numerator=delta.*(Rn-G)+rho.*Cp.*(ea-ed)./ra;
denominator=delta+gamma.*(1+rs./ra);
lambdaET=numerator./denominator;

% ET=lambdaET/lambda/rho_w
ET=lambdaET./lambda./1000;  % m/s
ET=ET.*1000.*3600;          % Convert units to mm/hr