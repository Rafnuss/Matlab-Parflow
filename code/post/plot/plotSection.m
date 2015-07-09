function plotSection(d)
warning('off','all');
t=1;
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




h{4}=uicontrol('Style','text','Position',[750 40 100 20],'String',datestr(d.date(t)));
uicontrol('Style','text','Position',[950 40 100 20],'String',datestr(max(d.date)));
uicontrol('Style','text','Position',[550 40 100 20],'String',datestr(min(d.date)));

h{5}=uicontrol(fig,'style','slider','units','pix','Position',[600 10 400 20],'Value',1 ...
    ,'min',1,'max',d.time.nt+1,'SliderStep',[0.01 0.01],'parent', fig,'callback',{@funtime,ax,Y,Z,d,h});


k=1;
for i=1:1:d.time.nt+1
    set(h{5},'Value',i);
    fig=funtime(h{5},'event',ax,Y,Z,d,h);
    %F(k)=getframe(fig);
    j=get(h{5},'Value');
    if j~=i
        return
    end
    k=k+1;
end
 cd(d.path.save);
% save('frameplotSection','F')
% movie2avi(F,'movieplotSection')

end

function fig=funtime(hObj,event,ax,Y,Z,d,h)

t = round(get(hObj,'Value'));


subplot(ax{1});cla; hold on; box on;
%contour(Y,Z,reshape(d.pressure(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','ShowText','on');
h{6}=pcolor(Y,Z,reshape(d.pressure(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))');
set(h{6}, 'EdgeColor', 'none');
contour(Y,Z,reshape(d.head(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))',10,'k','ShowText','on');
plot(d.y(d.yy),d.dem(d.coupe(1),d.yy),'k','lineWidth',2)
plot(d.y(d.yy),d.wlevelextrap(d.coupe(1),d.yy,t),'b','lineWidth',2)
xlabel('y[m]');ylabel('elevation [m]');title('Pressure (surf) and Head (line)')
axis([min(d.y) max(d.y) min(d.z) max(d.z)]);colorbar

subplot(ax{2});cla; hold on; box on;
%contourf(Y,Z,reshape(d.saturation(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','ShowText','on');
flow=log10(abs(reshape(d.flow(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))'));
flow(flow>-7)=NaN;h{7}=pcolor(Y,Z,flow);set(h{7}, 'EdgeColor', 'none');
contour(Y,Z,reshape(d.saturation(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','k','ShowText','on');
colorbar
plot(d.y(d.yy),d.top.level(d.coupe(1),d.yy),'k','lineWidth',2)
plot(d.y(d.yy),d.wlevelextrap(d.coupe(1),d.yy,t),'b','lineWidth',2)
xlabel('y[m]');ylabel('elevation [m]');title('Velocity (surf) and Saturation (line)')


set(h{1},'XData',[datenum(d.date(t)) datenum(d.date(t))])
set(h{2},'XData',[datenum(d.date(t)) datenum(d.date(t))])


drawnow
set(h{3},'String',datestr(d.date(t)))
fig=gcf;
end