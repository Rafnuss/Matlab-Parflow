
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