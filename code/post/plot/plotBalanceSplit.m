function plotBalanceSplit(d,choice)

if strcmp(choice,'all')
    choice={'P','ET','R','S','I','SS','SSS','TA','TG','TS'};
end
n=numel(choice);



% Evap flux
Egrnd   = reshape(mean(mean(d.flux.E.grnd(d.xx,d.yy,:))),d.time.nt+1,1);
Esoil   = reshape(mean(mean(d.flux.E.soil(d.xx,d.yy,:))),d.time.nt+1,1);
Eveg    = reshape(mean(mean(d.flux.E.veg(d.xx,d.yy,:))),d.time.nt+1,1);
Etr     = reshape(mean(mean(d.flux.E.tr(d.xx,d.yy,:))),d.time.nt+1,1);
Et      = reshape(mean(mean(d.flux.E.t(d.xx,d.yy,:))),d.time.nt+1,1);

Et2     = Egrnd + Eveg;

% Energy
Lv      = reshape(mean(mean(d.energy.Lv(d.xx,d.yy,:))),d.time.nt+1,1);
Lout    = reshape(mean(mean(d.energy.Lout(d.xx,d.yy,:))),d.time.nt+1,1);
H       = reshape(mean(mean(d.energy.H(d.xx,d.yy,:))),d.time.nt+1,1);
G       = reshape(mean(mean(d.energy.G(d.xx,d.yy,:))),d.time.nt+1,1);
Sin 	= d.energy.Sin(:);
Lin     = d.energy.Lin(:);

Rn1     = Lin + Sin - Lout;
Rn2     = H + Lv + G;

%Water flux [m/hr]
P       = d.flux.P;
I       = reshape(mean(mean(d.flux.I(d.xx,d.yy,:))),d.time.nt+1,1);
R       = reshape(mean(mean(d.flux.R(d.xx,d.yy,:))),d.time.nt+1,1);


% Water storage
S    	= reshape(mean(mean(d.snow(d.xx,d.yy,:))),d.time.nt+1,1);           % amount snow
SS      = d.surface.sum;                                             % amount surf storage
SSS     = d.subsurface.sum;                                          % amount sub storage
ST      = SS+S+SSS;                                                         % amount total storage
DSS     = SS-SS(1);                                                         % difference of surf
DSSS    = SSS-SSS(1);                                                       % difference of sub
DST     = ST-ST(1);                                                          % difference of total
Etc     = Et;                                                                   
Etc(Et<0)=0;  % remove the negative (ie condensation) not taking into mass balance


DSSt    = cumsum(d.pond.area.*P-d.pond.Et.*Et);%-d.pond.I');                                          % cum sum of flux in surf
DSSSt   = cumsum((1-d.pond.area).*P-(1-d.pond.Et).*Et);%-(I-d.pond.I'));                                                   % cum sum of flux in sub
DSTt    = cumsum(P-R-Etc); % precipitation - runoff - evaporation above zero (ie remove condensation)


% Temperature
Ta  = d.temp.a;
Tg  = reshape(mean(mean(d.temp.grnd(d.xx,d.yy,:))),d.time.nt+1,1);
Ts  = reshape(mean(mean(mean(d.temp.soil(d.xx,d.yy,1:10,:)))),d.time.nt+1,1);

figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:n
    if n<5
        subplot(2,2,i);
    elseif n<7
        subplot(3,2,i);
    elseif n<9
        subplot(3,3,i);
    else
        subplot(3,4,i);
    end
    box on
    switch choice{i}
        case 'P'
            plot(d.date,P,'b');ylabel('Precipitation');
        case 'ET'
            plot(d.date,Et,'g');ylabel('Evaporation');
        case 'S'
            plot(d.date,S,'k');ylabel('Snow');
        case 'R'
            plot(d.date,R,'r');ylabel('Surface runoff');
        case 'I'
            plot(d.date,I,'y');ylabel('Infiltration');
        case 'SS'
            plot(d.date,SS,'g');ylabel('Surface Storage');
        case 'SSS'
            plot(d.date,SSS,'r');ylabel('Subsurface Storage');
        case 'TA'
            plot(d.date,Ta,'b');ylabel('Air Temperature');
        case 'TS'
            plot(d.date,Ts,'g');ylabel('Soil Temperature');
        case 'TG'
            plot(d.date,Tg,'r');ylabel('Ground Temperature');
    end
end
end