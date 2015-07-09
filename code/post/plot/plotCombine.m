function plotCombine(d)
t=1;
warning('off','all');

ax=cell(4,1);
fig=figure('units','normalized','outerposition',[0 0 1 1]);

ax{1}=subplot(2,3,1); hold on; box on;
    [Y,Z]=meshgrid(d.y,d.z); perm=d.perm; perm(d.mask==0)=NaN;cover=min(perm(:)) + (max(perm(:))-min(perm(:))) .* (d.cover-min(d.cover(:))) ./ (max(d.cover(:)) -min(d.cover(:)));
    h{10}=pcolor(Y,Z,reshape(perm(d.coupe(1),d.yy,d.zz),numel(d.yy),numel(d.zz))'); shading interp;set(h{10}, 'EdgeColor', 'none');
    %contour(Y,Z,reshape(d.perm(d.coupe(1),d.yy,d.zz),numel(d.yy),numel(d.zz))',10.^logspace(min(min(perm(d.coupe(1),d.yy,d.zz))), max(max(log(perm(d.coupe(1),d.yy,d.zz)))) ,5) ,'k','ShowText','on');
    cli=get(gca,'CLim');
    if std(d.perm(:))>1
    contour(Y,Z,reshape(d.perm(d.coupe(1),d.yy,d.zz),numel(d.yy),numel(d.zz))',logspace(round(log(cli(1))),round(log(cli(2))),10) ,'k','ShowText','on');
    end
    plot(d.y,d.dem(d.coupe(1),:),'Color',[102/255 51/255 0],'lineWidth',2)
    pcolor([d.y(d.yy) ;d.y(d.yy)], repmat([d.grid.uz; d.grid.uz-1],1,numel(d.yy)),...
        repmat(cover(d.coupe(1),d.yy),2,1));
    xlabel('y[m]');title('Hydraulic conductivity [m/hr]')
    ylim([d.grid.lz d.grid.uz])
    
ax{2}=subplot(2,3,[2 3]);
A=d.head(d.coupe(1),d.yy,d.zz,:);
caxis([min(A(:)) max(A(:))]);
ax{3}=subplot(2,3,4);

ax{4}=subplot(2,3,[5 6]);hold on; box on;
    bar(datenum(d.date),d.flux.P,'b');
    plot(d.date,reshape(mean(mean(d.flux.R(d.xx,d.yy,:))),d.time.nt+1,1),'r');
    plot(d.date,reshape(mean(mean(d.flux.E.t(d.xx,d.yy,:))),d.time.nt+1,1),'y');
    h{3}=plot([d.date(1) d.date(1)],get(gca,'Ylim'),'r');
    legend('Precipitation ','Runoff','Evapotranspiration');
    title('Flux'); ylabel('m/hr');xlabel('Time [d]');

h{2}=uicontrol('Style','text','Position',[750 40 100 20],'String',datestr(d.date(t)));
uicontrol('Style','text','Position',[950 40 100 20],'String',datestr(max(d.date)));
uicontrol('Style','text','Position',[550 40 100 20],'String',datestr(min(d.date)));

h{1}=uicontrol(fig,'style','slider','units','pix','Position',[600 10 400 20],'Value', 1 ...
    ,'min',1,'max',d.time.nt+1,'SliderStep',[0.01 0.01],'parent', fig,'callback',{@funtime,ax,d,h});

k=1;
for i=1:10:d.time.nt+1
    set(h{1},'Value',i);
    fig=funtime(h{1},'event',ax,d,h);
    F(k)=getframe(fig);
    
    j=get(h{1},'Value');
    if j~=i
        return
    end
    k=k+1;
end
cd(d.path.save);
save('frameplotCombine','F')
movie2avi(F,'movieplotCombine')
end

function fig=funtime(hObj,event,ax,d,h)
tic
t = round(get(hObj,'Value'));


subplot(ax{2});cla; hold on; box on;
[Y,Z]=meshgrid(d.y,d.z);
%contourf(Y,Z,reshape(d.pressure(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','ShowText','on');
h{4}=pcolor(Y,Z,reshape(d.head(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))'); 
set(h{4}, 'EdgeColor', 'none');
plot(d.y,d.wlevelextrap(d.coupe(1),:,t),'Color','b','lineWidth',2);
contour(Y,Z,reshape(d.head(d.coupe(1),d.yy,d.zz,t),numel(d.yy),numel(d.zz))','k','ShowText','on');
plot(d.y(d.yy),d.dem(d.coupe(1),d.yy),'k','lineWidth',2);
xlabel('y[m]');ylabel('elevation [m]');title('Head [m]');
drawnow



subplot(ax{3});cla;box on;
[X2,Y2] =ndgrid(d.x,d.y);
h{5}=surf(X2,Y2,d.dem,'EdgeColor', 'none'); hold on;
surf(X2,Y2,d.wlevelextrap(:,:,t));
h{6}=fill3([d.x(d.coupe(1)) * ones(4,1)],[d.y(1) d.y(end) d.y(end) d.y(1)],[min(d.wlevelextrap(:)) min(d.wlevelextrap(:)) d.z(end) d.z(end)],'r');
alpha(h{5},0.7);alpha(h{6},0.25)


set(h{3},'XData',[datenum(d.date(t)) datenum(d.date(t))])


drawnow;
set(h{2},'String',datestr(d.date(t)));
fig=gcf;
end