function plotDem(d)
t=1;
fig=figure('units','normalized','outerposition',[0 0 1 1]);

subplot(2,2,1);box on;
surf(d.dem');xlabel('x');ylabel('y');title('d.dem');axis equal

subplot(2,2,2); 
surf(d.top.level');xlabel('x');ylabel('y');title('Ground Level elevation')
line([d.pt.hill(1) d.pt.hill(1)],[d.pt.hill(2) d.pt.hill(2)],[min(d.top.level(:)) max(d.top.level(:))],'Color','r','LineWidth',2)
line([d.pt.pond(1) d.pt.pond(1)],[d.pt.pond(2) d.pt.pond(2)],[min(d.top.level(:)) max(d.top.level(:))],'Color','r','LineWidth',2)
hold on;axis equal
fill3([d.coupe(1) d.coupe(1) d.coupe(1) d.coupe(1)],...
    [1 d.grid.ny d.grid.ny 1],...
    [d.grid.lz d.grid.lz d.grid.uz d.grid.uz],'r')


ax3=subplot(2,2,3);

ax4=subplot(2,2,4);

h2=uicontrol('Style','text','Position',[750 40 100 20],'String',datestr(d.date(t)));
uicontrol('Style','text','Position',[950 40 100 20],'String',datestr(max(d.date)));
uicontrol('Style','text','Position',[550 40 100 20],'String',datestr(min(d.date)));

h=uicontrol(fig,'style','slider','units','pix','Position',[600 10 400 20],'Value',1 ...
    ,'min',1,'max',d.time.nt+1,'SliderStep',[0.01 0.01],'parent', fig,'callback',{@funtime,ax3,ax4,d,h2});


k=1;
for i=1:1:d.time.nt
    set(h,'Value',i);
    funtime(h,'event',ax3,ax4,d,h2)
    F(k)=getframe(fig);
    j=get(h,'Value');
    if j~=i
        return
    end
    k=k+1;
end
cd(d.path.save);
save('frameplotCombine','F')
movie2avi(F,'movieplotCombine')

end

function funtime(hObj,event,ax3,ax4,d,h2)

t = round(get(hObj,'Value'));

subplot(ax3);cla;
mesh(d.top.level,'facecolor','none');hold on
surf(d.wlevel(:,:,t)*d.grid.dz); axis equal

subplot(ax4);cla;box on; hold on;
area(d.y,d.top.level(d.coupe(1),:),'FaceColor',[102/255 51/255 0])
plot(d.y,d.z(d.wlevel(d.coupe(1),:,t)),'Color','b','lineWidth',2)
xlabel('y[m]');xlabel('elevation [m]')
ylim([d.grid.lz d.grid.uz])

drawnow
set(h2,'String',datestr(d.date(t)))
end