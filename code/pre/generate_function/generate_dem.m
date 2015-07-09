function d=generate_dem(d,type)
%% generate_d.dem() function load or create d.dem and export 'd.dem.sa'
tic
switch type
    case '1D'
        d.dem=[d.grid.uz d.grid.uz-0.1; d.grid.uz-.1 d.grid.uz-.2];
        
    case 'Pond109'
        % d.dem of st denis is store in the data_required
        cd /home/raphael/Dropbox/MScProject/Data_St_Denis/
        load DEM.mat
        
        % find the indice of the d.dem matrix of the right extend
        demxmin     = 425750;
        %demxmax     = 425900;
        demymin     = 5784900;
        %demymax     = 5784750;
        
        xmin=find(DEM.x>demxmin,1);
        %xmax=find(DEM.x>demxmax,1);
        ymin=find(DEM.y<demymin,1);
        %ymax=find(DEM.y<demymax,1);
        
        % Check right DEM extend
        % surf(DEM.z(ymin:ymax-1,xmin:xmax-1)); xlabel('x'); ylabel('y')
        
        %        Rotation
        %         A=mat2gray(demt)
        %         demt=DEM.z(ymin:ymax,xmin:xmax);
        %         B = imrotate(A,45)
        %         imshow(B)
        
        demt=DEM.z(ymin:ymin+149,xmin:xmin+149)-min(min(DEM.z(ymin:ymin+150,xmin:xmin+150)))+d.thickness;
        
        % reshape d.dem in a matrix format
        d.dem = zeros(d.grid.nx,d.grid.ny);
        for i=0:d.grid.nx-1
            for j=0:d.grid.ny-1
                d.dem(i+1,j+1)=mean(mean(demt((i*d.grid.dx)+(1:d.grid.dx),(j*d.grid.dy)+(1:d.grid.dy))));
            end
        end
        
        %d.dem(d.dem>Z)=Z;
        
    case 'singlehomemade'
        %d.dem = zeros(d.grid.ux-d.grid.lx,d.grid.uy-d.grid.ly); % initialise d.dem at lowest level of the d.dem (everythin will be added)
        %[X,Y]=meshgrid(linspace(d.grid.lx,d.grid.ux,d.grid.nx),linspace(d.grid.ly,d.grid.uy,d.grid.ny));
        % _____            _______    Z
        l=0;                %      \          /           ^
        L=d.grid.ux/2;        %       \        /            |
        z=d.thickness;      %        \______/           z |
        Z=d.grid.uz;                %           l-->            ^ |
        p=1.61;                %           L----->         | |
        
        [x,y]=meshgrid(d.x-d.grid.ux/2,d.y-d.grid.uy/2);
        
        %d.dem =  z  +  (Z-z)./(1+exp(-0.1.*(sqrt(x.^2+y.^2)-L/3+10)));
        d.dem = z + (Z-z)* (sqrt(x.^2+y.^2)/L).^p;
        
        d.dem(d.dem>Z)=Z;
        
        
        % compare to real pond 109
%         fig=figure('units','normalized','outerposition',[0 0 1 1]); hold on; grid on; box on;
%         surf(x,y,dem109); xlabel('x [m]'); ylabel('y [m]');zlabel('elevation [m]')
%         h=mesh(x,y,demsim,'facecolor','none','EdgeColor', 'k');

%         
%         % variation with p value
%         for p=1:6
%         plot(x(8,:),reshape(d.dem(p,8,:),15,1))
%         end
        
        
        
        
    case 'dualhomenade'
        
        zt1=d.grid.uz;
        zt2=d.grid.uz/2;
        d1=d.grid.uz/6;
        d2=d.grid.uz/4;
        L1=d.grid.ux/3;
        L2=d.grid.ux/3;
        
        
        [x,y]=ndgrid(d.x',d.y');
        
        dem = zt2 + y*(zt1-zt2)/d.grid.uy;
        
        [x1,y1]=ndgrid(d.x-d.grid.ux/2,d.y-d.grid.uy/4);
        dem1 =  d1-d1./(1+exp(-0.15.*(sqrt((x1).^2+(y1).^2)-L1+10)));
        
        [x2,y2]=ndgrid(d.x-d.grid.ux/2,d.y-3*d.grid.uy/4);
        dem2 =  d2-d2./(1+exp(-0.15.*(sqrt((x2).^2+(y2).^2)-L2+10)));
        
        d.dem=dem-dem2-dem1;
        
        d.thickness=floor(min(d.dem(:)));
        surf(d.dem);xlabel('x'); ylabel('y'); axis equal
        
        
    case 'dualhomenade2D'
        
      zt1=d.grid.uz;
        zt2=d.grid.uz/2;
        d1=d.grid.uz;
        d2=d.grid.uz;
        L1=d.grid.ux/3;
        L2=d.grid.ux/3;
        
        
        [x,y]=ndgrid(d.x',d.y');
        
        dem = zt2 + y*(zt1-zt2)/d.grid.uy;
        
        [x1,y1]=ndgrid(d.x-d.grid.ux/2,d.y-d.grid.uy/4);
        dem1 =  d1-d1./(1+exp(-0.15.*(sqrt((x1).^2+(y1).^2)-L1+10)));
        
        [x2,y2]=ndgrid(d.x-d.grid.ux/2,d.y-3*d.grid.uy/4);
        dem2 =  d2-d2./(1+exp(-0.15.*(sqrt((x2).^2+(y2).^2)-L2+10)));
        
        d.dem=dem-dem2-dem1;
        
        d.thickness=floor(min(d.dem(:)));
        surf(d.dem);xlabel('x'); ylabel('y'); axis equal
        
    case 'dualhomenade2Dsimple'
        
        z0=d.thickness;
        a=3
        ;
        alpha=atan((d.grid.uz-z0)/d.grid.uy);
        b=2*pi/ (d.grid.uy/2);
        z= z0 + d.y.*tan(alpha) + a .* (sin(b.*d.y./cos(alpha)))/(cos(alpha));
        plot(d.y,z)
        d.dem=[z;z];
end




%% 2. Export 'd.dem.SA'
cd([d.path.save '/input']);
demt=d.dem'; demrep=repmat(demt(:),d.grid.nz,1);

fileID = fopen('dem.sa','w');
fprintf(fileID,'%d %d %d \n',d.grid.nx,d.grid.ny,d.grid.nz);
fprintf(fileID,'%f \n',demrep);
fclose(fileID);

%% fin
cd([d.path.core '/pre/generate_function'])
disp(['2.1. d.dem created in ' round(num2str(toc)) ' sec'])
end
