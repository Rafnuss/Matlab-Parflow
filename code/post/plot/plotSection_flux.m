function plotSection_flux(d)
t=1;
warning('off','all');

[Y,Z]=meshgrid(d.y(d.yy),d.z(d.zz));

ax=cell(4,1);
fig=figure('units','normalized','outerposition',[0 0 1 1]);

ax{1}=subplot(2,1,1); hold on; box on;
ax{2}=subplot(2,1,2); hold on; box on;
subplot('Position',[0.01, 0.8, 0.1, 0.15]);hold on; box on
	title('P [mm/s]'); plot(d.date,d.flux.P,'b');
    h{1}=plot([d.date(t) d.date(t)],[0 max(d.flux.P)],'r','lineWidth',2);

subplot('Position',[0.01, 0.6, 0.1, 0.15]);hold on; box on
    title('Lin [W/m^2]'); plot(d.date,d.energy.Sin,'y');
    h{2}=plot([d.date(t) d.date(t)],[0 max(d.energy.Sin)],'r','lineWidth',2);

subplot('Position',[0.1300, 0.46, 0.7750, 0.11]);box on
	h{3}= pcolor(d.y(d.yy), repmat([0; 1],1,numel(d.yy)),...
        repmat(d.cover(d.coupe(1),d.yy),2,1)); set(h{3}, 'EdgeColor', 'none');
	xlabel('');ylabel('Surface type'); legend('waterbody, light shrubland','cropland')


h{4}=uicontrol('Style','text','Position',[750 40 100 20],'String',datestr(d.date(t)));
uicontrol('Style','text','Position',[950 40 100 20],'String',datestr(max(d.date)));
uicontrol('Style','text','Position',[550 40 100 20],'String',datestr(min(d.date)));

h{5}=uicontrol(fig,'style','slider','units','pix','Position',[600 10 400 20],'Value',1 ...
    ,'min',1,'max',d.time.nt+1,'SliderStep',[0.01 0.01],'parent', fig,'callback',{@funtime,ax,Y,Z,d,h});



for i=1:d.time.nt/10:d.time.nt+1
    set(h{5},'Value',i);
    funtime(h{5},'event',ax,Y,Z,d,h)
    j=get(h{5},'Value');
    if j~=i
        return
    end
end


end

function funtime(hObj,event,ax,Y,Z,d,h)

t = round(get(hObj,'Value'));

subplot(ax{1});cla; hold on; box on;
    plot(d.y(d.yy),d.flux.E.grnd(d.coupe(1),d.yy,t),'r')
    plot(d.y(d.yy),mean(d.flux.E.grnd(d.coupe(1),d.yy,:),3),'--r')
    plot(d.y(d.yy),d.flux.E.soil(d.coupe(1),d.yy,t),'y')
    plot(d.y(d.yy),mean(d.flux.E.soil(d.coupe(1),d.yy,:),3),'--y')
    plot(d.y(d.yy),d.flux.E.veg(d.coupe(1),d.yy,t),'g')
    plot(d.y(d.yy),mean(d.flux.E.veg(d.coupe(1),d.yy,:),3),'--g')
    plot(d.y(d.yy),d.flux.E.tr(d.coupe(1),d.yy,t),'b')
    plot(d.y(d.yy),mean(d.flux.E.tr(d.coupe(1),d.yy,:),3),'--b')
    plot(d.y(d.yy),d.flux.E.t(d.coupe(1),d.yy,t),'k')
    plot(d.y(d.yy),mean(d.flux.E.t(d.coupe(1),d.yy,:),3),'--k')
    legend('Ground E','average Ground E','Soil E','avg Soil E','Vegetation E','average ','Vegetation Transpiration','average ','Total','average ','Total2=grnd+veg')
    xlabel('');ylabel('Flux [m/hr]');ylim([0 max(max(d.flux.E.t(d.coupe(1),d.yy,:)))])

subplot(ax{2});cla; hold on; box on;
    contourf(Y,Z,reshape(d.pressure(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','ShowText','on');
    contour(Y,Z,reshape(d.head(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))',5,'k','ShowText','on');
    plot(d.y(d.yy),d.dem(d.coupe(1),d.yy),'k','lineWidth',2)
    plot(d.y(d.yy),d.wlevelextrap(d.coupe(1),d.yy,t),'b','lineWidth',2)
    xlabel('y[m]');ylabel('Elevation [m]');legend('Pressure','Head','ground level','water level')

set(h{1},'XData',[datenum(d.date(t)) datenum(d.date(t))])
set(h{2},'XData',[datenum(d.date(t)) datenum(d.date(t))])


drawnow
set(h{4},'String',datestr(d.date(t)))
end