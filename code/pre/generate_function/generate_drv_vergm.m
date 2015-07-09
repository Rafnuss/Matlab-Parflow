function d=generate_drv_vergm(d,zone1,zone2,zone3)
tic


lat =   52.210;%*ones(d.grid.nx,d.grid.ny);
long =  -106.091;%*ones(d.grid.nx,d.grid.ny);
sand =  0.16;%*ones(d.grid.nx,d.grid.ny);
clay =  0.265;%*ones(d.grid.nx,d.grid.ny);
color = 2;%*ones(d.grid.nx,d.grid.ny);

%                       ,,ggddY""""Ybbgg,,
%  zone 3           ,agd""'              `""bg,
%               ,gdP"        zone 2         "Ybg,
%             ,dP"                             "Yb,
%           ,dP"         _,,ddP"""Ybb,,_         "Yb,
%          ,8"         ,dP"'         `"Yb,         "8,
%         ,8'        ,d"                 "b,        `8,
%        ,8'        d"       zone 1        "b        `8,
%        d'        d'                       `b        `b
%        8         8                 r1      8         8
%        8         8           +------------>8         8
%        8         8           |             8         8
%        8         Y,          |            ,P         8
%        Y,         Ya         |           aP         ,P
%        `8,         "Ya       |r2       aP"         ,8'
%         `8,          "Yb,_   |     _,dP"          ,8'
%          `8a           `""Ybb|ggddP""'           a8'
%           `Yba               |                 adP'
%             "Yba             |               adY"
%               `"Yba,         |           ,adP"'
%                  `"Y8ba,     v       ,ad8P"'
%                       ``""YYbaaadPP""''


% FROM CLM use guide
% 6   Closed Shrublands Land with shrub canopy d.cover > 60%; With woody vegetation
%         less than 2 meters tall; The shrub foliage can be either
%         evergreen or deciduous.
% 7   Open Shrublands Land with shrub canopy d.cover between 10 – 60%; With woody
%         vegetation less than 2 meters tall; The shrub foliage can be
%         either evergreen or deciduous.
% 10  Grasslands Tree and shrub cover is less than 10%; With herbaceous types
%         of cover.
% 11  Permanent Wetlands Land with a permanent mixture of water and herbaceous or
%         woody vegetation; the vegetation can be present in either salt,
%         brackish, or fresh water.
% 12  Croplands Lands d.covered with temporary crops followed by harvest and
%         bare soil period (e.g., single and multiple cropping systems).
%         Note that perennial woody crops will be classified as the
%         appropriate forest or shrub land d.cover typ
% 14  Lands with a mosaic of croplands, forests, shrubland, and grasslands in 
%         which no one component comprises more than 60% of the landscape.
% 17  Water Bodies Oceans, seas, lakes, reservoir, and rivers. Can be either fresh or
%         salt-water bodies
% 18  Bare Soil Bare soil throughout the years

%zone1 = 17;
%zone2 = 7;
%zone3 = 12;


z12=0.15;
z23=0.3;

d.cover = zone3*ones(d.grid.nx,d.grid.ny); 


d.cover((d.dem-min(d.dem(:)))./ (max(d.dem(:))-min(d.dem(:)))<z23)=zone2;
d.cover((d.dem-min(d.dem(:)))./ (max(d.dem(:))-min(d.dem(:)))<z12)=zone1;


surf(d.cover)



% %mincover = imregionalmin(d.dem);
% [~,I] = min(d.dem(:));
% mincover = zeros(d.grid.nx,d.grid.ny);
% mincover(I) =1;
% d.cover = zone3*ones(d.grid.nx,d.grid.ny); 
% 
% r1=1;
% r2=r1+1;
% Dd=r2-r1;
% 
% cover2=d.cover;
% 
% for i=r1+1:d.grid.nx-r1
%     for j=r1+1:d.grid.ny-r1
%         if mincover(i,j)== 1
%             cover2(i-r1:i+r1,j-r1:j+r1)=zone1;
%         end
%     end
% end
% 
% for i=Dd+1:d.grid.nx-Dd
%     for j=Dd+1:d.grid.ny-Dd
%         if cover2(i,j)==zone1
%             d.cover(i-Dd:i+Dd,j-Dd:j+Dd)=zone2;
%         end
%     end
% end
% 
% 
% d.cover(cover2==zone1)=zone1;




% % VERSION "RAYON"
% dr= 12;  % r2-r1; in m
% [x,y]=meshgrid(d.x-d.grid.dux/2,d.y-d.grid.duy/2);
%        % Zone 3 (background)
% r1 = d.grid.ny/2-find(round(d.dem(d.grid.nx/2,1:d.grid.ny/2)/0.25)*0.25<d.grid.dICPressVal,1);
% r2 = r1 + dr/d.grid.ddy;
% if ~isempty(r2)
%     d.cover(sqrt((x).^2+(y).^2)<r2*d.grid.ddx) = zone2;
% end
% if ~isempty(r1)
%     d.cover(sqrt((x).^2+(y).^2)<r1*d.grid.ddx) = zone1;             % Zone 1 (waterbodies)
% end


cd([d.path.save '/input']);
fileID = fopen('drv_vegm.dat','w');
fprintf(fileID,'%s	%s	%s	%s	%s	%s	%s	%s\n','x','y','lat','lon','sand','clay','color','fractional d.coverage of grid by vegetation class (Must/Should Add to 1.0)');
fprintf(fileID,'%s	%s	%s	%s	%s	%s	%s	%s	\n','','','(deg)','(deg)','(%)','(%)','index',num2str(1:18));
for i=1:d.grid.nx
    for j=1:d.grid.ny
        fprintf(fileID,'% 4d% 4d  % 7.3f % 8.3f% 3.2f% 2.3f% 4.0d',i,j,lat,long,sand,clay,color);
        a=zeros(1,18);
        a(d.cover(i,j))=1;
        fprintf(fileID,'  %1.1f',a);
        fprintf(fileID,'\n');
    end
end


cd([d.path.core '/pre/generate_function'])
disp(['2.4. drv_gergm created  in ' round(num2str(toc)) ' sec'])
fclose(fileID);