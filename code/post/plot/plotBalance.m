function plotBalance(d,choice)

if strcmp(choice,'all')
    choice={'Energy','Evaporation','WaterFlux','Storage','Temperature'};
end

n=numel(choice);



% Evap flux
Egrnd   = reshape(mean(mean(d.flux.E.grnd(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Esoil   = reshape(mean(mean(d.flux.E.soil(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Eveg    = reshape(mean(mean(d.flux.E.veg(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Etr     = reshape(mean(mean(d.flux.E.tr(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Et      = reshape(mean(mean(d.flux.E.t(d.xx,d.yy,:),1),2),d.time.nt+1,1);
EP      = d.flux.E.Pt;

Et2     = Egrnd + Eveg;

% Energy
Lv      = reshape(mean(mean(d.energy.Lv(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Lout    = reshape(mean(mean(d.energy.Lout(d.xx,d.yy,:),1),2),d.time.nt+1,1);
H       = reshape(mean(mean(d.energy.H(d.xx,d.yy,:),1),2),d.time.nt+1,1);
G       = reshape(mean(mean(d.energy.G(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Sin 	= d.energy.Sin(:);
Lin     = d.energy.Lin(:);

Rn1     = Lin + Sin - Lout;
Rn2     = H + Lv + G;

%Water flux [m/hr]
P       = d.flux.P;
Ps      = d.flux.Ps;
I       = reshape(mean(mean(d.flux.I(d.xx,d.yy,:),1),2),d.time.nt+1,1);
R       = d.flux.Rsum;

% Water storage
S    	= reshape(mean(mean(d.snow(d.xx,d.yy,:),1),2),d.time.nt+1,1);       % amount snow
SS      = d.surface.sum;                                                    % amount surf storage
SSS     = d.subsurface.sum;                                                 % amount sub storage
ST      = SS+S+SSS;                                                         % amount total storage
DST     = ST-ST(1);                                                         % difference of totalEt
%Etc(Et<0)=0;  % remove the negative (ie condensation) not taking into mass balance                                                 % cum sum of flux in sub
Pnan   = P;Pnan(isnan(P))=0;

% Temperature
Ta  = d.temp.a;
Tg  = reshape(mean(mean(d.temp.grnd(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Ts  = reshape(mean(mean(mean(d.temp.soil(d.xx,d.yy,1:10,:),1),2),3),d.time.nt+1,1);




figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:n
    subplot(n,1,i);
    box on; hold on;
    
    switch choice{i}
        case 'Energy'
            
            plot(d.date,Lv,'m');    plot(d.date,H,'g'); plot(d.date,G,'b');plot(d.date,Sin,'v-c');
            plot(d.date,Lin,'v-y'); plot(d.date,Lout,'^-y');plot(d.date,Rn1,'r'); plot(d.date,Rn2,'or');
            
            legend('Latent Heat (Lv)','Sensible heat (H)','GroundW heat flux (G)',...
                'Short-wave IN','Long-wave IN','Long-wave out',...
                'Rn1= Lin + Sin - Lout','Rn2 = H + Lv + G')
            xlabel('Time [d]'); ylabel('[W/m^2]'); title('Forcing of evaporation');axis tight
            
            
            
            
            
        case 'Evaporation'
            
            plot(d.date,Egrnd,'r');  plot(d.date,Esoil,'y');  plot(d.date,Eveg,'g');  plot(d.date,Etr,'b')
            plot(d.date,Et,'k'); plot(d.date,Et2,'ok'); %plot(d.date,EP,'m');%,'Potentiel'

            legend('Ground E','Soil E','Vegetation E','Vegetation Transpiration','Total','Total2=grnd+veg','Location','Best')
            xlabel('Time [d]'); ylabel('[m/hr]'); title('Different type of Evaporation');axis tight
            
            
            
            
            
        case 'WaterFlux'
            
            bar(datenum(d.date),P,'b')
            bar(datenum(d.date),Ps,'k')
            plot(d.date,I,'g')
            plot(d.date,R,'r')
            plot(d.date,Et,'y')
            %plot(d.date,et)
            %plot(d.date,evaptrans)
            %plot(d.date,evaptranssum)
            
            legend(['Precipitation ' sprintf('(%.0f [mm/yr])',nanmean(P)*24*365*1000)],...
                ['Snow ' sprintf('(%.0f [mm/yr])',nanmean(d.flux.Ps)*24*365*1000)],...
                ['Infiltration' sprintf('(%.0f [mm/yr])',nanmean(I)*24*365*1000)],...
                ['Runoff' sprintf('(%.0f [mm/yr])',nanmean(R)*24*365*1000)],...
                ['Evapotranspiration' sprintf('(%.0f [mm/yr])',nanmean(Et)*24*365*1000)],...
                'Location','Best')
            title('Flux'); ylabel('m/hr'); xlabel('Time [d]'); axis tight
            
            
            
            
            
            
            
        case 'Storage'
            
            plot(d.date,S-S(1),'k')
            plot(d.date,SS-SS(1),'g')
            plot(d.date,SSS-SSS(1),'m')
            plot(d.date,ST-ST(1),'r')
            plot(d.date,[NaN;cumsum(Pnan(2:end)-R(2:end)-Et(2:end))*d.time.dt],'or');
            plot(d.date,abs([NaN; diff(ST)]-(Pnan-R - Et).*d.time.dt)./ST,'xk')
            legend('S_{Snow}',...
                ['S_{surf} ' sprintf('(S_{surf,0}=%3.3f)',SS(1))],...
                ['S_{sub}' sprintf('(S_{sub,0}=%3.3f)',SSS(1))],...
                ['S_{total}= (S_{surf} +S_{sub} +S_{snow})' sprintf('(S_{total,0}=%3.3f)',ST(1))],...
                'S_{flux}=sum (P-R-Et) \Delta t',...
                'Error',...
                'Location','Best')
            title('Storage');xlabel('Time [d]');ylabel('m');axis tight

            
            
            
            
        case 'Temperature'
            
            plot(d.date,Ta,'b')
            plot(d.date,Tg,'r')
            plot(d.date,Ts,'g')
            plot([d.date(1) d.date(end)], [0 0],'--k')
            ylabel('[C]');xlabel('Time [d]'); legend('Air','Ground','Soil','Location','Best')
            title('Temperature');axis tight
            
    end
    %xlim([datenum(d.date(1)) datenum(d.date(end))])
end
end
% function data=cumresh(data,d.xx,d.yy,z)
% t=size(data,ndims(data));
% if ndims(data)==4
%     data=data(d.xx,d.yy,z,:);
%     data=reshape(mean(mean(mean(data,1),2),3),t,1);
% elseif ndims(data) ==3
%     data=data(d.xx,d.yy,:);
%     data=reshape(mean(mean(data,1),2),t,1);
% else
%     printf('error')
% end
% end