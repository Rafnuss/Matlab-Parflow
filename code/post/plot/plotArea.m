function plotArea(d,choice)
warning('off','all');
if strcmp(choice,'all')
    choice={'Et','Eveg','R','S','I','SS','SSS','TopL','TopP','TopS','TopH','TempS','TempG'};
end

n=numel(choice);
ax=cell(n+2,1);
t=1;
fig=figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:n
    if n<5
        ax{i}=subplot(2,2,i);
    elseif n<7
        ax{i}=subplot(3,2,i);
    elseif n<10
        ax{i}=subplot(3,3,i);
    elseif n<13;
        ax{i}=subplot(3,4,i);
    end
end


subplot('Position',[0.01, 0.8, 0.1, 0.15]); box on; hold on
title('P [mm/s]')
plot(d.date,d.flux.P,'b');
h{1}=plot([d.date(t) d.date(t)],[0 max(d.flux.P)],'r','lineWidth',2);

subplot('Position',[0.01, 0.6, 0.1, 0.15]); box on; hold on;
title('Lin [W/m^2]')
plot(d.date,d.energy.Sin,'y');
h{1}=plot([d.date(t) d.date(t)],[0 max(d.energy.Sin)],'r','lineWidth',2);


h{3}=uicontrol('Style','text','Position',[750 40 100 20],'String',datestr(d.date(t)));
uicontrol('Style','text','Position',[950 40 100 20],'String',datestr(max(d.date)));
uicontrol('Style','text','Position',[550 40 100 20],'String',datestr(min(d.date)));

h{4}=uicontrol('Style','slider','Position',[600 40 400 20],'Value',1,...
    'min',1,'max',d.time.nt+1,'SliderStep',[0.01 0.01],'parent', fig,'callback',{@funtime,d,choice,h,ax});



for i=1:(d.time.nt-1)/10:d.time.nt
    set(h{4},'Value',i);
    funtime(h{4},'event',d,choice,h,ax);
    j=get(h{4},'Value');
    if j~=i
        return
    end
end

end

function funtime(hObj,event,d,choice,h,ax)
t = round(get(hObj,'Value'));


n=numel(choice);
for i=1:n
    subplot(ax{i})
    box on
    cla
    [X,Y] = meshgrid(d.x,d.y);
    switch choice{i}
        case 'Et'
           h{5}=pcolor(X,Y,d.flux.E.t(:,:,t));ylabel('Evaporation');
        case 'Eveg'
           h{5}=pcolor(X,Y,d.flux.E.veg(:,:,t));ylabel('Evaporation');
        case 'Etr'
           h{5}=pcolor(X,Y,d.flux.E.tr(:,:,t));ylabel('Evaporation');
        case 'Egrnd'
           h{5}=pcolor(X,Y,d.flux.E.grnd(:,:,t));ylabel('Evaporation');
        case 'Esoil'
           h{5}=pcolor(X,Y,d.flux.E.soil(:,:,t));ylabel('Evaporation');
        case 'S'
           h{5}=pcolor(X,Y,d.snow(:,:,t));ylabel('Snow');caxis([0 max(d.snow(:))])
        case 'R'
           h{5}=pcolor(X,Y,d.flux.R(:,:,t));ylabel('Surface runoff');
        case 'I'
           h{5}=pcolor(X,Y,d.flux.I(:,:,t));ylabel('Infiltration');
        case 'SS'
           h{5}=pcolor(X,Y,d.surface.storage(:,:,t));ylabel('Surface storage');
        case 'SSS'
           h{5}=pcolor(X,Y,reshape(sum(d.subsurface.storage(:,:,:,t),3),d.grid.nx,d.grid.ny));ylabel('Subsurface storage');
        case 'TopL'
            surf(d.top.level(:,:));ylabel('Top level');
        case 'TopS'
           h{5}=pcolor(X,Y,d.top.saturation(:,:,t));ylabel('Top saturation');
        case 'TopP'
           h{5}=pcolor(X,Y,d.top.pressure(:,:,t));ylabel('Top pressure');
        case 'TopH'
           h{5}=pcolor(X,Y,d.top.head(:,:,t));ylabel('Top head');
        case 'TempG'
           h{5}=pcolor(X,Y,d.temp.grnd(:,:,t));ylabel('Ground temperature');
        case 'TempS'
           h{5}=pcolor(X,Y,d.temp.soil(:,:,end,t));ylabel('Soil temperature');
        case 'Wlevel'
           h{5}=pcolor(X,Y,d.wlevel(:,:,t));ylabel('waterlevel')
        case 'cover'
           h{5}=pcolor(X,Y,d.cover(:,:));ylabel('cover')
        case 'dem'
           h{5}=pcolor(X,Y,d.dem);ylabel('DEM')
        case 'et'
           h{5}=pcolor(X,Y,d.new.et(:,:,t));ylabel('et')
        case 'evaptrans'
           h{5}=pcolor(X,Y,d.new.evaptrans(:,:,t));ylabel('evaptrans')
        case 'evaptranssum'
           h{5}=pcolor(X,Y,d.new.evaptranssum(:,:,t));ylabel('evaptranssum')
        case 'obf'
           h{5}=pcolor(X,Y,d.new.obf(:,:,t));ylabel('obf')
        case 'overland_bcflux'
           h{5}=pcolor(X,Y,d.new.overland_bcflux(:,:,t));ylabel('overland_bcflux')
    end
    colorbar%('location','South')
    set(h{5}, 'EdgeColor', 'none');
    axis tight
    axis equal
        %xlabel('hour')
end


h{1}.XData=[datenum(d.date(t)) datenum(d.date(t))];
h{2}.XData=[datenum(d.date(t)) datenum(d.date(t))];


drawnow
set(h{3},'String',datestr(d.date(t)))
end
