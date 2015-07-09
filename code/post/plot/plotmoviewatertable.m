function plotmoviewatertable(d)
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

subplot(ax1);cla;hold on
    plot(d.y(d.yy),d.flux.E.t(d.coupe(1),d.yy,t),'k')
    plot(d.y(d.yy),d.flux.E.veg(d.coupe(1),d.yy,t),'g')
    plot(d.y(d.yy),d.flux.E.grnd(d.coupe(1),d.yy,t),'r')
    ylim([0 max(max(d.flux.E.t(d.coupe(1),d.yy,:)))])
    xlabel('');ylabel('Evaporation [m/hr]');legend('Total','Vegetation','Ground')
    title('Total evaporation');


subplot(ax2);cla;box on; hold on;
    area(d.y,d.top.level(d.coupe(1),:),'FaceColor',[102/255 51/255 0])
    plot(d.y,d.z(d.wlevel(d.coupe(1),:,t)),'Color','b','lineWidth',2)
    xlabel('y[m]');xlabel('elevation [m]')
    ylim([d.grid.lz d.grid.uz])

drawnow
set(h2,'String',datestr(d.date(t)))
end

