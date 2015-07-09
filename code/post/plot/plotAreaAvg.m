function plotAreaAvg(d,choice)
warning('off','all');
if strcmp(choice,'all')
    choice={'Et','Eveg','R','S','I','SS','SSS','TopL','TopP','TopS','TopH','TempG'};
end

n=numel(choice);
t=1;
fig=figure('units','normalized','outerposition',[0 0 1 1]);

[X,Y] = meshgrid(d.x,d.y);

for i=1:n
    if n<5
        subplot(2,2,i);
    elseif n<7
        subplot(3,2,i);
    elseif n<10
        subplot(3,3,i);
    elseif n<13;
        subplot(3,4,i);
    end

    switch choice{i}
        case 'Et'
            h=pcolor(X,Y,mean(d.flux.E.t,3)');ylabel('Evaporation');
        case 'Eveg'
            h=pcolor(X,Y,mean(d.flux.E.veg,3)');ylabel('Evaporation');
        case 'Etr'
            h=pcolor(X,Y,mean(d.flux.E.tr,3)');ylabel('Evaporation');
        case 'Egrnd'
            h=pcolor(X,Y,mean(d.flux.E.grnd,3)');ylabel('Evaporation');
        case 'Esoil'
            h=pcolor(X,Y,mean(d.flux.E.soil,3)');ylabel('Evaporation');
        case 'S'
            h=pcolor(X,Y,mean(d.snow,3)');ylabel('Snow');
        case 'R'
            h=pcolor(X,Y,mean(d.flux.R,3));ylabel('Surface runoff');
        case 'I'
            h=pcolor(X,Y,mean(d.flux.I,3)');ylabel('Infiltration');
        case 'SS'
            h=pcolor(X,Y,mean(d.surface.storage,3)');ylabel('Surface storage');
        case 'SSS'
            h=pcolor(X,Y,reshape(mean(d.subsurface.storage(:,:,max(end-365,1):end),3),d.grid.nx,d.grid.ny));ylabel('Subsurface storage');
        case 'TopL'
            surf(d.top.level);ylabel('Top level');
        case 'TopS'
            h=pcolor(X,Y,mean(d.top.saturation,3));ylabel('Top saturation');
        case 'TopP'
            h=pcolor(X,Y,mean(d.top.pressure,3));ylabel('Top pressure');
        case 'TopH'
            h=pcolor(X,Y,mean(d.top.head,3));ylabel('Top head');
        case 'TempG'
            h=pcolor(X,Y,mean(d.temp.grnd,3));ylabel('Ground temperature');
        case 'TempS'
            h=pcolor(X,Y,mean(d.temp.soil(:,:,end,:),4)');ylabel('Soil temperature');
        case 'Wlevel'
            h=pcolor(X,Y,mean(d.wlevelextrap,3));ylabel('waterlevel')
        case 'cover'
            h=pcolor(X,Y,mean(d.cover(:,:),3));ylabel('cover')
        case 'dem'
            h=pcolor(X,Y,mean(d.dem,3));ylabel('DEM')
        case 'et'
            h=pcolor(X,Y,mean(d.new.et,3));ylabel('et')
        case 'evaptrans'
            h=pcolor(X,Y,mean(d.new.evaptrans,3));ylabel('evaptrans')
        case 'evaptranssum'
            h=pcolor(X,Y,mean(d.new.evaptranssum,3));ylabel('evaptranssum')
        case 'obf'
            h=pcolor(X,Y,mean(d.new.obf,3));ylabel('obf')
        case 'overland_bcflux'
            h=pcolor(X,Y,mean(d.new.overland_bcflux,3));ylabel('overland_bcflux')
    end
    colorbar%('location','South')
    set(h, 'EdgeColor', 'none');
    axis tight
    axis equal
        %xlabel('hour')
end

end
