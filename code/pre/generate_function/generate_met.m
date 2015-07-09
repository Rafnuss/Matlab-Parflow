function d=generate_met(d,type)
tic
% generate_met() generate the met forcing data for the following data:
%       - Short wave radiation      [W/m^2]
%       - Long wave radiation       [W/m^2]
%       - Precipitation rate        [mm/s]
%       - Air temperature           [K]
%       - East‐west wind speed      [m/s]
%       - North‐south wind speed    [m/s]
%       - Air pressure              [Pa]
%       - Specific humidity         [kg/kg]



switch type
    
    
    
    
    case 'Summer2012'
        T=readtable('Summer2012.xlsx','Sheet',2); %1->2011 | 2-> 2012 | 3-> 2013
        
        
    case 'Combine'
        cd /home/raphael/Dropbox/MScProject/Data_St_Denis/Run
        metload=load('alldata-withoutgap-HOUR.mat');
        
        init = find(metload.met.date-1/24/60<d.time.init & d.time.init<metload.met.date+1/24/60);
        vecin = init:d.time.ts:init+d.time.st/d.time.loop;
        vecout=init:d.time.dt:init+d.time.st/d.time.loop;
        d.date=datetime(metload.met.date(vecout),'ConvertFrom','datenum');
        
       % initialize vectors
         met.DSWR=nan(length(vecin)-1,1);met.DLWR=nan(length(vecin)-1,1);met.APCP=nan(length(vecin)-1,1);met.Temp=nan(length(vecin)-1,1);
         met.UGRD=nan(length(vecin)-1,1);met.VGRD=nan(length(vecin)-1,1);met.Press=nan(length(vecin)-1,1);met.SPFH=nan(length(vecin)-1,1);
         
         d.energy.Soutobs=nan(length(vecout),1);d.energy.Loutobs=nan(length(vecout),1);d.energy.Hobs=nan(length(vecout),1);d.energy.Lvobs=nan(length(vecout),1);d.energy.Rnobs=nan(length(vecout),1);d.temp.aobs=nan(length(vecout),1);
         d.energy.Sin=nan(length(vecout),1);d.energy.Lin=nan(length(vecout),1);d.flux.P=nan(length(vecout),1);d.temp.a=nan(length(vecout),1);d.windspeed.NS=nan(length(vecout),1);d.windspeed.EW=nan(length(vecout),1);d.air.pressure=nan(length(vecout),1);d.air.SH=nan(length(vecout),1);
        %

        for i=1:length(vecin)-1
            met.DSWR(i)    = mean(metload.met.energy.Sin(vecin(i)+1:vecin(i+1)));                               % Short wave radiation [W/m^2]
            met.DLWR(i)    = mean(metload.met.energy.Lin(vecin(i)+1:vecin(i+1)));                               % Long wave radiation [W/m^2]
            met.APCP(i)    = mean(metload.met.flux.P(vecin(i)+1:vecin(i+1)));                          % Precipitation rate [mm/s] from [mm/30min]
            met.Temp(i)    = mean(metload.met.temp.a(vecin(i)+1:vecin(i+1)));                        % Air temperature  [K] from [°C]
            met.UGRD(i)    = mean(metload.met.windspeed.EW(vecin(i)+1:vecin(i+1)));   % East‐west wind speed [m/s]
            met.VGRD(i)    = mean(metload.met.windspeed.NS(vecin(i)+1:vecin(i+1)));   % North‐south wind speed [m/s]
            met.Press(i)   = mean(metload.met.air.pressure(vecin(i)+1:vecin(i+1)));                         % Air pressure [Pa] from [kPa]
            met.SPFH(i)    = mean(metload.met.air.SH(vecin(i)+1:vecin(i+1)));
        end
        
        for u=2:length(vecout)
            d.energy.Sin(u)        = nanmean(metload.met.energy.Sin(vecout(u-1)+1:vecout(u)));
            d.energy.Lin(u)        = nanmean(metload.met.energy.Lin(vecout(u-1)+1:vecout(u)));
            d.flux.P(u)            = nanmean(metload.met.flux.P(vecout(u-1)+1:vecout(u)));
            d.temp.a(u)            = nanmean(metload.met.temp.a(vecout(u-1)+1:vecout(u)));
            d.windspeed.EW(u)      = nanmean(metload.met.windspeed.EW(vecout(u-1)+1:vecout(u)));
            d.windspeed.NS(u)      = nanmean(metload.met.windspeed.NS(vecout(u-1)+1:vecout(u)));
            d.air.pressure(u)      = nanmean(metload.met.air.pressure(vecout(u-1)+1:vecout(u)));
            d.air.SH(u)            = nanmean(metload.met.air.SH(vecout(u-1)+1:vecout(u)));
            d.air.RH(u)            = nanmean(metload.met.air.RH(vecout(u-1)+1:vecout(u)));
        end 
        
        
        metload2=load('metSRC-withoutgap-DAY.mat');
        
        init = find(metload2.met.date-1/24/60<d.time.init & d.time.init<metload2.met.date+1/24/60);
        
        met.APCP = metload2.met.P(init:init+numel(met.APCP)-1)';
        d.flux.P = [NaN; metload2.met.P(init:init+numel(d.flux.P)-2)'];
        d.flux.Ps = [NaN; metload2.met.Ps(init:init+numel(d.flux.P)-2)'];
        d.flux.Pr = [NaN; metload2.met.Pr(init:init+numel(d.flux.P)-2)'];
        d.flux.S = [NaN; metload2.met.S(init:init+numel(d.flux.P)-2)'];
        %d.temp.a2 =[NaN; metload2.met.T(init:init+numel(d.flux.P)-2)'+273.15];
        
        
        metload3=load('airport-hourly.mat');
        
        init = find(metload3.met.date-1/24/60<d.time.init & d.time.init<metload3.met.date+1/24/60);
        vecout=init:d.time.dt:init+d.time.st/d.time.loop;
        
        for u=2:length(vecout)
            %d.temp.a2(u)            = nanmean(metload3.met.temp.a(vecout(u-1)+1:vecout(u)));
            %d.windspeed.EW2(u)      = nanmean(metload3.met.windspeed.EW(vecout(u-1)+1:vecout(u)));
            %d.windspeed.NS2(u)      = nanmean(metload3.met.windspeed.NS(vecout(u-1)+1:vecout(u)));
            d.air.SH(u)            = nanmean(metload3.met.air.SH(vecout(u-1)+1:vecout(u)));
            %d.air.RH2(u)            = nanmean(metload3.met.air.RH(vecout(u-1)+1:vecout(u)));
            %d.air.pressure2(u)      = nanmean(metload3.met.air.pressure(vecout(u-1)+1:vecout(u)));
        end
        
        %figure; hold on;
        %plot(d.date,d.air.pressure2)
        %plot(d.date,d.air.pressure)
        
        
    case 'year2012'
        T=readtable('year2012_estier.xlsx','Sheet',2); %1->2011 | 2-> 2012 | 3-> 2013
        
        
        
        
        
    case '2011-2013'
        cd /home/raphael/Dropbox/MScProject/Data_St_Denis/Run
        metload=load('2011-2013-withoutgap-HOUR.mat');
     
        init = find(metload.met.date-1/24/60<d.time.init & d.time.init<metload.met.date+1/24/60);
        vecin = init:d.time.ts:init+d.time.st/d.time.loop;
        vecout=init:d.time.dt:init+d.time.st/d.time.loop;
        
        
        d.date=datetime(metload.met.date(vecout),'ConvertFrom','datenum');
        
       % initialize vectors
         met.DSWR=nan(length(vecin)-1,1);met.DLWR=nan(length(vecin)-1,1);met.APCP=nan(length(vecin)-1,1);met.Temp=nan(length(vecin)-1,1);
         met.UGRD=nan(length(vecin)-1,1);met.VGRD=nan(length(vecin)-1,1);met.Press=nan(length(vecin)-1,1);met.SPFH=nan(length(vecin)-1,1);
         
         d.energy.Soutobs=nan(length(vecout),1);d.energy.Loutobs=nan(length(vecout),1);d.energy.Hobs=nan(length(vecout),1);d.energy.Lvobs=nan(length(vecout),1);d.energy.Rnobs=nan(length(vecout),1);d.temp.aobs=nan(length(vecout),1);
         d.energy.Sin=nan(length(vecout),1);d.energy.Lin=nan(length(vecout),1);d.flux.P=nan(length(vecout),1);d.temp.a=nan(length(vecout),1);d.windspeed.NS=nan(length(vecout),1);d.windspeed.EW=nan(length(vecout),1);d.air.pressure=nan(length(vecout),1);d.air.SH=nan(length(vecout),1);
        %
        for i=1:length(vecin)-1
            met.DSWR(i)    = mean(metload.met.energy.Sin(vecin(i)+1:vecin(i+1)));                               % Short wave radiation [W/m^2]
            met.DLWR(i)    = mean(metload.met.energy.Lin(vecin(i)+1:vecin(i+1)));                               % Long wave radiation [W/m^2]
            met.APCP(i)    = mean(metload.met.flux.P(vecin(i)+1:vecin(i+1)));                          % Precipitation rate [mm/s] from [mm/30min]
            met.Temp(i)    = mean(metload.met.temp.a(vecin(i)+1:vecin(i+1)));                        % Air temperature  [K] from [°C]
            met.UGRD(i)    = mean(metload.met.windspeed.EW(vecin(i)+1:vecin(i+1)));   % East‐west wind speed [m/s]
            met.VGRD(i)    = mean(metload.met.windspeed.NS(vecin(i)+1:vecin(i+1)));   % North‐south wind speed [m/s]
            met.Press(i)   = mean(metload.met.air.pressure(vecin(i)+1:vecin(i+1)));                         % Air pressure [Pa] from [kPa]
            met.SPFH(i)    = mean(metload.met.air.SH(vecin(i)+1:vecin(i+1)));
        end
        d.flux.Ps       =[d.flux.Ps(1); repmat(d.flux.Ps(2:end),d.time.loop,1)];
        for u=2:length(vecout)
            d.energy.Soutobs(u)    = nanmean(metload.met.energy.Soutobs(vecout(u-1)+1:vecout(u)));
            d.energy.Loutobs(u)    = nanmean(metload.met.energy.Loutobs(vecout(u-1)+1:vecout(u)));
            d.energy.Hobs(u)       = nanmean(metload.met.energy.Hobs(vecout(u-1)+1:vecout(u)));
            d.energy.Lvobs(u)      = nanmean(metload.met.energy.Lvobs(vecout(u-1)+1:vecout(u)));
            d.energy.Rnobs(u)      = nanmean(metload.met.energy.Rn(vecout(u-1)+1:vecout(u)));
            d.temp.aobs(u)         = nanmean(metload.met.temp.a(vecout(u-1)+1:vecout(u)));
            
            d.energy.Sin(u)        = nanmean(metload.met.energy.Sin(vecout(u-1)+1:vecout(u)));
            d.energy.Lin(u)        = nanmean(metload.met.energy.Lin(vecout(u-1)+1:vecout(u)));
            d.flux.P(u)            = nanmean(metload.met.flux.P(vecout(u-1)+1:vecout(u)));
            d.temp.a(u)            = nanmean(metload.met.temp.a(vecout(u-1)+1:vecout(u)));
            d.windspeed.EW(u)      = nanmean(metload.met.windspeed.EW(vecout(u-1)+1:vecout(u)));
            d.windspeed.NS(u)      = nanmean(metload.met.windspeed.NS(vecout(u-1)+1:vecout(u)));
            d.air.pressure(u)      = nanmean(metload.met.air.pressure(vecout(u-1)+1:vecout(u)));
            d.air.SH(u)            = nanmean(metload.met.air.SH(vecout(u-1)+1:vecout(u)));
        end
        
        %         figure;hold on; box on
        %         plot(d.date,d.flux.P)
        %         plot(datetime(metload.met.date(vecin(2:end)),'ConvertFrom','datenum'),met.APCP)
        %         plot(datetime(metload.met.date(vecin(1):vecin(end)),'ConvertFrom','datenum'),metload.met.flux.P(vecin(1):vecin(end)))
        
        
        
        
        
        
        
    case 'alldata'
        cd /home/raphael/Dropbox/MScProject/Data_St_Denis/Run
        metload=load('alldata-withoutgap-HOUR.mat');
        
        init = find(metload.met.date-1/24/60<d.time.init & d.time.init<metload.met.date+1/24/60);
        
        vecin = init:d.time.ts:init+d.time.st/d.time.loop;
        vecout=init:d.time.dt:init+d.time.st/d.time.loop;
        
        d.date=datetime(metload.met.date(vecout),'ConvertFrom','datenum');
        
       % initialize vectors
         met.DSWR=nan(length(vecin)-1,1);met.DLWR=nan(length(vecin)-1,1);met.APCP=nan(length(vecin)-1,1);met.Temp=nan(length(vecin)-1,1);
         met.UGRD=nan(length(vecin)-1,1);met.VGRD=nan(length(vecin)-1,1);met.Press=nan(length(vecin)-1,1);met.SPFH=nan(length(vecin)-1,1);
         
         d.energy.Soutobs=nan(length(vecout),1);d.energy.Loutobs=nan(length(vecout),1);d.energy.Hobs=nan(length(vecout),1);d.energy.Lvobs=nan(length(vecout),1);d.energy.Rnobs=nan(length(vecout),1);d.temp.aobs=nan(length(vecout),1);
         d.energy.Sin=nan(length(vecout),1);d.energy.Lin=nan(length(vecout),1);d.flux.P=nan(length(vecout),1);d.temp.a=nan(length(vecout),1);d.windspeed.NS=nan(length(vecout),1);d.windspeed.EW=nan(length(vecout),1);d.air.pressure=nan(length(vecout),1);d.air.SH=nan(length(vecout),1);
        %

        for i=1:length(vecin)-1
            met.DSWR(i)    = mean(metload.met.energy.Sin(vecin(i)+1:vecin(i+1)));                               % Short wave radiation [W/m^2]
            met.DLWR(i)    = mean(metload.met.energy.Lin(vecin(i)+1:vecin(i+1)));                               % Long wave radiation [W/m^2]
            met.APCP(i)    = mean(metload.met.flux.P(vecin(i)+1:vecin(i+1)));                          % Precipitation rate [mm/s] from [mm/30min]
            met.Temp(i)    = mean(metload.met.temp.a(vecin(i)+1:vecin(i+1)));                        % Air temperature  [K] from [°C]
            met.UGRD(i)    = mean(metload.met.windspeed.EW(vecin(i)+1:vecin(i+1)));   % East‐west wind speed [m/s]
            met.VGRD(i)    = mean(metload.met.windspeed.NS(vecin(i)+1:vecin(i+1)));   % North‐south wind speed [m/s]
            met.Press(i)   = mean(metload.met.air.pressure(vecin(i)+1:vecin(i+1)));                         % Air pressure [Pa] from [kPa]
            met.SPFH(i)    = mean(metload.met.air.SH(vecin(i)+1:vecin(i+1)));
        end
        
        for u=2:length(vecout)
            d.energy.Sin(u)        = nanmean(metload.met.energy.Sin(vecout(u-1)+1:vecout(u)));
            d.energy.Lin(u)        = nanmean(metload.met.energy.Lin(vecout(u-1)+1:vecout(u)));
            d.flux.P(u)            = nanmean(metload.met.flux.P(vecout(u-1)+1:vecout(u)));
            d.temp.a(u)            = nanmean(metload.met.temp.a(vecout(u-1)+1:vecout(u)));
            d.windspeed.EW(u)      = nanmean(metload.met.windspeed.EW(vecout(u-1)+1:vecout(u)));
            d.windspeed.NS(u)      = nanmean(metload.met.windspeed.NS(vecout(u-1)+1:vecout(u)));
            d.air.pressure(u)      = nanmean(metload.met.air.pressure(vecout(u-1)+1:vecout(u)));
            d.air.SH(u)            = nanmean(metload.met.air.SH(vecout(u-1)+1:vecout(u)));

        end 
end


% Loop input data
met.DSWR=repmat(met.DSWR,d.time.loop,1);
met.DLWR=repmat(met.DLWR,d.time.loop,1);
met.APCP=repmat(met.APCP,d.time.loop,1);
met.Temp=repmat(met.Temp,d.time.loop,1);
met.UGRD=repmat(met.UGRD,d.time.loop,1);
met.VGRD=repmat(met.VGRD,d.time.loop,1);
met.Press=repmat(met.Press,d.time.loop,1);
met.SPFH=repmat(met.SPFH,d.time.loop,1);

d.energy.Sin	=[d.energy.Sin(1); repmat(d.energy.Sin(2:end),d.time.loop,1)];
d.energy.Lin	=[d.energy.Lin(1); repmat(d.energy.Lin(2:end),d.time.loop,1)];
d.flux.P        =[d.flux.P(1); repmat(d.flux.P(2:end),d.time.loop,1)];
d.flux.Ps       =[d.flux.Ps(1); repmat(d.flux.Ps(2:end),d.time.loop,1)];
d.flux.Pr       =[d.flux.Pr(1); repmat(d.flux.Pr(2:end),d.time.loop,1)];
d.flux.S       =[d.flux.S(1); repmat(d.flux.S(2:end),d.time.loop,1)];
d.temp.a        =[d.temp.a(1); repmat(d.temp.a(2:end),d.time.loop,1)];
d.windspeed.EW	=[d.windspeed.EW(1); repmat(d.windspeed.EW(2:end),d.time.loop,1)];
d.windspeed.NS  =[d.windspeed.NS(1); repmat(d.windspeed.NS(2:end),d.time.loop,1)];
d.air.pressure	=[d.air.pressure(1); repmat(d.air.pressure(2:end),d.time.loop,1)];
d.air.SH        =[d.air.SH(1); repmat(d.air.SH(2:end),d.time.loop,1)];
d.date          = d.date(1):d.time.dt/24:(d.date(1)+d.time.nt*d.time.dt/24);

d.flux.P=d.flux.P*d.ConvMmSMHr;
d.flux.Ps=d.flux.Ps*d.ConvMmSMHr;
d.flux.Pr=d.flux.Pr*d.ConvMmSMHr;
d.temp.a=d.temp.a-d.ConvKD;





%% Generate the txt file
cd([d.path.save '/input']);

fileID = fopen('met.0.txt','w');
for i=1:d.time.Nt
    fprintf(fileID,'%.10f\t',met.DSWR(i));
    fprintf(fileID,'%.10f\t',met.DLWR(i));
    fprintf(fileID,'%.10f\t',met.APCP(i));
    fprintf(fileID,'%.10f\t',met.Temp(i));
    fprintf(fileID,'%.10f\t',met.UGRD(i));
    fprintf(fileID,'%.10f\t',met.VGRD(i));
    fprintf(fileID,'%.10f\t',met.Press(i));
    fprintf(fileID,'%.10f\t',met.SPFH(i));
    fprintf(fileID,'\n');
end
fclose(fileID);


cd([d.path.core '/pre/generate_function'])
disp(['2.3. Met created  in ' round(num2str(toc)) ' sec'])
end

