!synclient HorizTwoFingerScroll=0
setenv('PARFLOW_DIR', '/home/raphael/parflow/parflow')

clear all;clc; tStart = tic; disp('-------------------- Script started--------------------')

%% 1. Set,create information about the run
disp('1. Setting up basic run information')
d.runname       = '1D2_simplecase_cropland';
d.familyname    = '1D2';
d.path.save     = ['/home/raphael/Dropbox/MScProject/PARFLOW/Run/' d.familyname '/save/' d.runname];
d.path.core     = '/home/raphael/Dropbox/MScProject/PARFLOW/CoreCodeVersion/Seventh';
d.path.output   = ['/home/raphael/Dropbox/MScProject/PARFLOW/Run/' d.familyname '/output'];
if ~exist(d.path.save,'dir'); mkdir(d.path.save); end
if ~exist([d.path.save '/input'],'dir'); mkdir([d.path.save '/input']); end
% Lower point (PF)
d.grid.lx         = 0;          %        __________                               
d.grid.ly         = 0;          %       /         /|                           
d.grid.lz         = 0;          %      /         / |                         
% Upper point (PF)              %     /_________/  |                    
d.grid.ux         = 150;        %     |         |  |                                
d.grid.uy         = 150;        %  dy |         |  /                           
d.grid.uz         = 5;          %     |         | /                              
% Number of point (PF)          %     |_________|/                                    
d.grid.nx         = 2;          %  lx,ly,lz     ux                               
d.grid.ny         = 2;          %     <-------->                                 
d.grid.nz         = 10;         %         nx                                     
% Grid size (PF)                                                        
d.grid.dx         = (d.grid.ux-d.grid.lx)/d.grid.nx;
d.grid.dy         = (d.grid.uy-d.grid.ly)/d.grid.ny;
d.grid.dz         = (d.grid.uz-d.grid.lz)/d.grid.nz;
% depth of the computed soil : z0 -> min(dem) (lowest elevation of the soil)
% BE CAREFULL : max(dem)-min(dem)+thickness < uz (upper z) otherwise you're outise the box !
d.x=linspace(d.grid.lx+d.grid.dx/2 , d.grid.ux-d.grid.dx/2,d.grid.nx); % position of the cell computed by PF
d.y=linspace(d.grid.ly+d.grid.dy/2 , d.grid.uy-d.grid.dy/2,d.grid.ny);
d.z=linspace(d.grid.lz+d.grid.dz/2 , d.grid.uz-d.grid.dz/2,d.grid.nz);
d.xx=1:d.grid.nx; % nb of the cell
d.yy=1:d.grid.ny; 
d.zz=1:d.grid.nz;

%************************     [hr]        0    1    2    3    4    5    6              9             12              15            18      
d.time.st     = 365*24;  %                  <----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|---->                                                                                                       
d.time.dt     = 24;      % timestep=3     <------------->|<------------>|<------------>|<------------>|<------------>|<------------>|                                                                    
d.time.ts     = 24;      % query to met                  x              x              x              x              x              x                                                       
d.time.init   = datenum('1 September 2002 00:00');
d.time.loop   = 1;
restarttime   = 0;
%****************************	                                                                                                    
d.thickness   = d.grid.uz;
d.ICPressVal  = d.thickness-3;
%***************************

d.time.st   = d.time.st*d.time.loop;
d.time.nt   = d.time.st/d.time.dt;
d.time.Nt   = d.time.st/d.time.ts;

d.time.out  = d.time.init:d.time.dt/24:d.time.init+(d.time.st)/24;
d.time.in  = d.time.init:d.time.ts/24:d.time.init+(d.time.st)/24;

d.pt.pond=[round(d.grid.nx/2) round(d.grid.ny/2)];
d.pt.hill=[2 2];
d.coupe=[round(d.grid.nx/2) NaN];
d.ConvMmSMHr = 60*60/1000;
d.ConvKD = 273.15;
d.snowini = 0;
ICpressurefilname=[d.runname '.out.press.' sprintf('%05.0f',restarttime) '.pfb'];



%% 2. Generate the required data for the run
disp('2. Generation of soil input data')
% Set the type of soil parameter:
d.soil.Ss                 = 1.0e-4;   % set the specific storage value (can only be cst) 708(-4) 529(-3) 901(-5) 690(-6)
d.soil.SRes               = 0.218;
d.soil.SSat               = 0.52;
d.soil.porosity           = d.soil.SSat-d.soil.SRes;                                             % set the porostiy (can only be a cst)
d.soil.alpha              = 0.0115*100; %[cm^-1]->[m^-1]
d.soil.n                  = 2.03;
d.soil.manning            = 0.03;

d.soil.Ks      = 31.6/100/24; % [cm/d]->[m/hr] NOT used if constent is not set in generate_perm
d.soil.wf_0    = 0.1;
d.soil.wf_inf  = 0;
d.soil.b       = -1;
d.soil.Kf      = 40;
d.soil.Km      = 10^-5;

cd([d.path.core '/pre/generate_function'])
%**********************************
d = generate_dem(d,'1D');   % this return the dem to be used later   ,'Pond109'
generate_perm(d,'constant')         %  constant
d=generate_met(d,'Combine');    % year2012
d=generate_drv_vergm(d,12,12,12); %    
generate_pfsol(d)                 %
%**********************************


% Export info.txt that will be read by PF
cd([d.path.save '/input']);
fileID = fopen('runinfo.txt','w');
    fprintf(fileID,'%s\n',d.runname);fprintf(fileID,'%s\n',d.path.save);...
    fprintf(fileID,'%d\n',d.grid.lx);fprintf(fileID,'%d\n',d.grid.ly);fprintf(fileID,'%d\n',d.grid.lz);...
    fprintf(fileID,'%d\n',d.grid.ux);fprintf(fileID,'%d\n',d.grid.uy);fprintf(fileID,'%d\n',d.grid.uz);...
    fprintf(fileID,'%d\n',d.grid.nx);fprintf(fileID,'%d\n',d.grid.ny);fprintf(fileID,'%d\n',d.grid.nz);...
    fprintf(fileID,'%f\n',d.grid.dx);fprintf(fileID,'%f\n',d.grid.dy);fprintf(fileID,'%f\n',d.grid.dz);...
    fprintf(fileID,'%d\n',d.time.st);fprintf(fileID,'%f\n',d.time.dt);fprintf(fileID,'%f\n',d.time.ts);fprintf(fileID,'%f\n',restarttime);...
    fprintf(fileID,'%f\n',d.ICPressVal);fprintf(fileID,'%s\n',ICpressurefilname);...
    fprintf(fileID,'%f\n',d.soil.SSat);fprintf(fileID,'%f\n',d.soil.SRes);fprintf(fileID,'%f\n',d.soil.alpha);fprintf(fileID,'%f\n',d.soil.n);...
    fprintf(fileID,'%f\n',d.soil.Ss);fprintf(fileID,'%f\n', d.soil.porosity);fprintf(fileID,'%f\n',d.soil.Ks);fprintf(fileID,'%f\n',d.soil.manning);
fclose(fileID);

cd([d.path.save '/input'])
fin = fopen([d.path.core '/pre/data_drv/drv_clmin.dat'],'r');
fout = fopen('drv_clmin.dat','w');
[Y, M, D, H, MN, S]=datevec(d.time.init);
while ~feof(fin)
    s = fgetl(fin);
    switch s(1:3)
        case 'sss'
            s(16:17)=sprintf('%02d',S);
        case 'smn'
            s(16:17)=sprintf('%02d',MN);
        case 'shr'
            s(16:17)=sprintf('%02d',H);
        case 'sda'
            s(16:17)=sprintf('%02d',D);
        case 'smo'
            s(16:17)=sprintf('%02d',M);
        case 'syr'
            s(16:19)=sprintf('%04d',Y);
        case 't_i'
            s(16:18)=sprintf('%03.0f',d.temp.a(2)+273.15);
        case 'h2o'
            s(16:17)=sprintf('%02d',d.snowini);
        case 'sta'
            if restarttime~=0
                s(16)='1';
            end
        case 'clm'
            if restarttime~=0
                s(16)='1';
            end
    end
    fprintf(fout,'%s\n',s);
end
fclose(fin);fclose(fout);
clear Y M D H MN S fin fout 
copyfile([d.path.core '/pre/data_drv/drv_vegp.dat'],[d.path.save '/input'])
copyfile([d.path.core '/TCL'],d.path.output)
copyfile([d.path.save '/input'],d.path.output)


%% 3. Run script
cd(['/home/raphael/Dropbox/MScProject/PARFLOW/Run/' d.familyname '/output']);tic

[status,cmdout]=system('tclsh run.tcl','-echo');
if status
    return
else
    disp(['4. Run.tcl finished in ' num2str(round(toc)) ' sec'])
end

%% 4. Load 
cd([d.path.core '/post/post_processing']);
run load_data.m

%% 5. Delete run
cd(d.path.output);tic        
system('rm *drv_*','-echo');
system('rm washita*','-echo');
system('rm *.pfb','-echo');
system('rm *.silo','-echo');
system('rm -r TXT *.out ','-echo');
disp(['5. delete.tcl finished in ' num2str(round(toc)) ' sec'])

%% 6. Save...
cd(d.path.save);
%d.description = 'first test, 24hr 100x100x120 no rain ET only';
filename='snow';
save([filename '-' datestr(now,'mm-dd-HH-MM-SS')],'d')
%screen2image
%beep on;pause; beep off

d.info.timeelaps=toc(tStart);
disp(['Overall Run finished in ' num2str(round(toc(tStart))) ' sec']);clear TStart status

%% Plot

cd([d.path.core '/post/plot']);


plotBalance(d,{'WaterFlux','Storage'})




plotTempSoilDist(d)

return

plotBalance(d,{'WaterFlux','Storage'})
plotBalance(d,{'Energy','Evaporation'})
plotCombine(d)

plotCombine(d)
plotBalance(d,{'Temperature'})

plotSection(d)
plotIreson2013(d)

Mayboom(d)


plotBalanceSplit(d,{'P','ET','R','S','I','SS','SSS'}) % 'P','ET','R','S','I','SS','SSS','TA','TG','TS'

plotArea(d,{'Eveg'});
%'ET','R','S','I','SS','SSS','TopL','TopP','TopS','TopH','TempS','TempG','cover','Wlevel'

plotDem(d) 

    
plotSection(d)
plotSection_flux(d)

plotTranchTime(d)


plotEnergy(d)

























subplot(2,2,1);hold on
contourf(d.wlevel(:,:,5));
contour(d.slope.x);xlabel('x');ylabel('y')
title('x slope (contour) over waterlevel (GW level + surface level) (contour fill)')

subplot(2,2,2)
contourf(d.slope.y);xlabel('x');ylabel('y');title('y slope')

subplot(2,2,3)
quiver(-d.slope.y,-d.slope.x);xlabel('x');ylabel('y');title('slope')

subplot(2,2,4)
surf(d.dem);xlabel('x');ylabel('y');title('dem')


x1=d.hill(1);y1=d.hill(2);
x2=d.pond(1);y2=d.pond(2);
z=22:26;
TranchOverTime(d.saturation,x1,y1,z,d.dem(x,y)-d.info.bottom_elev,reshape(d.perm(x1,y1,:),numel(d.perm(x,y,:)),1),d.info)  
TranchOverTime(d.pressure,x1,y1,z,d.dem(x,y)-d.info.bottom_elev,reshape(d.perm(x1,y1,:),numel(d.perm(x,y,:)),1),d.info)  




% Not updated...
%plotwaterlevel(d) % Boring... Not update
plotVolumeTime(d.saturation,d.pressure,d.head,d.info.tmax) % Only representation of volume Matlab gives... not very intresting...

% Met Forcing
plotMet(d.x,d.y,d)



