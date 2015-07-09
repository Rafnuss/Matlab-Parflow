function plotmovieSeasonHeadwatertable(d)
t=1;
fig=figure('units','normalized','outerposition',[0 0 1 1]);



ax1=subplot(3,1,1);

ax2=subplot(3,1,[2 3]);

h2=uicontrol('Style','text','Position',[750 40 100 20],'String',datestr(d.date(t)));
uicontrol('Style','text','Position',[950 40 100 20],'String',datestr(max(d.date)));
uicontrol('Style','text','Position',[550 40 100 20],'String',datestr(min(d.date)));

h=uicontrol(fig,'style','slider','units','pix','Position',[600 10 400 20],'Value',1 ...
    ,'min',1,'max',d.time.nt+1,'SliderStep',[0.01 0.01],'parent', fig,'callback',{@funtime,ax1,ax2,d,h2});


k=1;
for i=d.time.nt-365:1:d.time.nt
    set(h,'Value',i);
    funtime(h,'event',ax1,ax2,d,h2)
    F(k)=getframe(fig);
    j=get(h,'Value');
    if j~=i
        return
    end
    k=k+1;
end
cd(d.path.save);
save('frameplotCombine','F')
movie2avi(F,'moviewatertable','quality',50)

end

function funtime(hObj,event,ax1,ax2,d,h2)

t = round(get(hObj,'Value'));



y=8:18;
[Y,Z]=meshgrid(d.y(y),d.z);

subplot(ax1); cla;hold on
    plot(d.y(y),mean(d.flux.E.t(d.coupe(1),y,end-365:end),3),'-ok');
        plot(d.y(y),d.flux.E.t(d.coupe(1),y,t));
    xlabel('');ylabel('Avearge of Total evaporation [m/hr]');
    axis tight;title('Total evaporation');
    
subplot(ax2);cla;hold on
    plot(d.y(y),min(d.wlevelextrap(d.coupe(1),y,end-365:end),[],3),'--k');
    plot(d.y(y),max(d.wlevelextrap(d.coupe(1),y,end-365:end),[],3),'--k');
    plot(d.y(y),mean(d.wlevelextrap(d.coupe(1),y,end-365:end),3),'-ok');
        plot(d.y(y),d.wlevelextrap(d.coupe(1),y,t));
    plot(d.y(y),d.dem(d.coupe(1),y),'Color','k','lineWidth',2);title('Water table level');
    xlabel('Distence [m]');ylabel('Elevation [m]');
    axis tight


drawnow
set(h2,'String',datestr(d.date(t)))
end

