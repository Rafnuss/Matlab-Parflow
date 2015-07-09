%function d=load_data(d)
tic;

At=d.grid.dx*d.grid.nx*d.grid.dy*d.grid.ny; %total air At=dx*nx*dy*ny;
Ac=d.grid.dx*d.grid.dy; % by cell;
A3c=d.grid.dx*d.grid.dy*d.grid.dz;


%% Load Data

disp('Geometry info loading... 2/7')
d.mask                  = open_SA('mask',d,true,false,0);                   % 3D 1 for soil,0 for air
d.top.level             = (open_SA('top',d,false,false,0)+1)*d.grid.dz;         % 1D level of the ground [m] datum=lowerZ 
%d.dem                   = open_SA('dem',d,false,false,0);                   % 2D real level imported [m] datum=local datum
d.slope.x               = open_SA('slopex',d,false,false,0); 
d.slope.y               = open_SA('slopey',d,false,false,0); 
d.depth                 = open_SA('depth',d,false,true,0);                  % 2D time depth below GW [m]



disp('Soil info loading... 3/7')
d.perm                  = open_SA('perm',d,true,false,0);                   % 3D K value in [m/hr]







disp('PARFLOW info loading... 5/7')
d.saturation            = open_SA('saturation',d,true,true,0);              % 3D time of saturation 0->1 [-]  1=watertable
d.pressure              = open_SA('pressure',d,true,true,0);                % 3D time of pressure [m] 0=watertable+cap. fringe
d.head                  = open_SA('head',d,true,true,0);                    % 2D time of head [m] H=P+z;
d.flow                  = open_SA('flux',d,true,true,0); 
maskT=repmat(d.mask,1,1,1,d.time.nt+1);
d.pressure(maskT==0)=NaN;
d.saturation(maskT==0)=NaN;
d.head(maskT==0 | d.head<0)=NaN;
d.flow(maskT==0)=NaN;
clear maskT

d.top.saturation        = open_SA('top_saturation',d,false,true,0);         % 2D time saturation at the surface (top.level)
d.top.pressure          = open_SA('top_pressure',d,false,true,0);           % 2D time pressure at the surface (top.level)
d.top.head              = open_SA('top_head',d,false,true,0);               % 2D time head at the surface (top.level)





disp('Computed stuff loading... 6/7')
subsurfsto              = open_SA('subsurface_storage',d,true,true,0);     % 3D time volume in subsurface [m^3] per grid -> [m]
d.subsurface.storage    =  reshape(nansum(subsurfsto,3),d.grid.nx,d.grid.ny,d.time.nt+1)/Ac; clear subsurfsto
d.surface.storage       = open_SA('surface_storage',d,false,true,0)/Ac;        % 2D time volume in surface [m^3] per grid -> [m]
d.flux.R                = open_SA('surface_runoff',d,false,true,0)/Ac/d.time.dt;         % 2D time [m^3] per grid -> [m]

cd(d.path.output);
fileID = fopen('storage.txt');sum=textscan(fileID,'%f %f %f');fclose(fileID);clear fileID

d.subsurface.sum    = sum{1}/At;                                         % total volume [m³] per time -> [m] per time
d.surface.sum       = sum{2}/At;                                               % total volume [m³] per time -> [m] per time
d.flux.Rsum         = sum{3}/At;                                                 % total volume [m³] per time -> [m] per time

cd([d.path.core '/post/post_processing']); clear sum

ttt=0;
d.wlevel=nan(d.grid.nx,d.grid.ny,d.time.nt+1);d.wlevelext=nan(d.grid.nx,d.grid.ny,d.time.nt+1);
for t=1:d.time.nt+1
    for x=1:d.grid.nx
        for y=1:d.grid.ny
            if t==1
                P=reshape(d.pressure(x,y,:,t),1,d.grid.nz);tic
            else
            P=reshape(d.pressure(x,y,1:min(d.wlevel(x,y,t-1)+5,d.grid.nz),t),1,min(d.wlevel(x,y,t-1)+5,d.grid.nz));tic
            end
            %P(abs(nanmean(P)-P)/nanstd(P)>5)=NaN;ttt=ttt+toc;
%             if all(diff(P(~isnan(P)))<0)
%                 pfirst=numel(P(~isnan(P)));
%             else
%                 pfirst=find(diff(P(~isnan(P)))<0,1);
%             end
%                 d.wlevel(x,y,t)=floor(interp1(P(1:pfirst),d.zz(1:pfirst),0,'linear','extrap'));
%                 d.wlevelextrap(x,y,t)=interp1(P(1:pfirst),d.z(1:pfirst),0,'linear','extrap');
            p = polyfit(P(~isnan(P)),d.zz(~isnan(P)),1);
            d.wlevel(x,y,t) = floor(polyval(p,0));
            p = polyfit(P(~isnan(P)),d.z(~isnan(P)),1);
            d.wlevelextrap(x,y,t) = polyval(p,0);
        end
    end
end
clear x y P








disp('CLM info loading... 7/7')
d.energy.Lv     = open_SA('eflx_lh_tot',d,false,true,1);                      % 2D time Latent heat [W/m^2]
d.energy.Lout   = open_SA('eflx_lwrad_out',d,false,true,1);                   % 2D time Long wave [W/m^2]
d.energy.H      = open_SA('eflx_sh_tot',d,false,true,1);                      % 2D time sensible heat [W/m^2]
d.energy.G      = open_SA('eflx_soil_grnd',d,false,true,1);                   % 2D time ground heat [W/m^2]
d.temp.grnd     = open_SA('t_grnd',d,false,true,1)-d.ConvKD;                  % 2D time temperature in ground [K]->[°C]
d.temp.soil     = open_SA('t_soil',d,true,true,1)-d.ConvKD;                   % 3D (10 layers) time temperature in soil [K]->[°C]
d.temp.soil     = d.temp.soil(:,:,1:10,:);
d.flux.E.grnd   = open_SA('qflx_evap_grnd',d,false,true,1)*d.ConvMmSMHr;         % 1D time evaporation ground no sublimation [mm/s]->[m/hr]
d.flux.E.soil   = open_SA('qflx_evap_soi',d,false,true,1)*d.ConvMmSMHr;          % 1D time evaporation ground [mm/s]->[m/hr]
d.flux.E.t      = open_SA('qflx_evap_tot',d,false,true,1)*d.ConvMmSMHr;          % 1D time evaporation total [mm/s]->[m/hr]
d.flux.E.veg    = open_SA('qflx_evap_veg',d,false,true,1)*d.ConvMmSMHr;          % 1D timeevaporation canopy [mm/s]->[m/hr]
d.flux.E.tr     = open_SA('qflx_tran_veg',d,false,true,1)*d.ConvMmSMHr;          % 1D timetranspiration [mm/s]->[m/hr]
d.flux.I        = open_SA('qflx_infl',d,false,true,1)*d.ConvMmSMHr;              % 1D timeinfiltration [mm/s]->[m/hr]
d.snow          = open_SA('swe_out',d,false,true,1)/1000;                        % 1D time snow [mm]->[m]

d.flux.E.Pt=PenmanMonteith(d)/1000;

d.temp.grnd(:,:,1)=0;
d.temp.soil(:,:,:,1)=0;


d.pond.area=zeros(d.time.nt+1,1);
d.pond.Et=zeros(d.time.nt+1,1);
d.pond.I=zeros(d.time.nt+1,1);
for i=1:d.time.nt+1; % this compute the ET, I of the ponding surface
    mask =d.surface.storage(:,:,i)>0 ;
    d.pond.area(i)=nansum(nansum(mask))/numel(mask);
    E=d.flux.E.t(:,:,i); % [m]
    I=d.flux.I(:,:,i); % [m]
    d.pond.Et(i)=nanmean(nanmean(E(mask)))/nanmean(mean(E));
    d.pond.I(i)=nanmean(nanmean(I(mask)))/nanmean(mean(I));
end;clear i E I mask
d.pond.Et(isnan(d.pond.Et))=0;
d.pond.I(isnan(d.pond.I))=0;



cd([d.path.core '/post/post_processing']);
d.new.et                = open_SA('et',d,false,true,1)/Ac*d.time.ts;
d.new.evaptrans         = open_SA('evaptrans',d,false,true,1)/Ac;
d.new.evaptranssum      = open_SA('evaptranssum',d,false,true,1)/Ac;
d.new.obf               = open_SA('obf',d,false,true,1);
d.new.overland_bcflux   = open_SA('overland_bcflux.obf',d,false,true,1);
d.new.overlandsum       = open_SA('overlandsum',d,true,true,1);

disp(['11. Data loaded in ' num2str(toc) ' sec'])
clear A3c Ac At
%end