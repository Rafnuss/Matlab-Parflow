function Mayboom2(d)

depth1=1;
depth2=3;
depth3=5;
  
pt.pond{1} =[d.pt.pond max(0,round((d.dem(d.pt.pond(1),d.pt.pond(2))-depth1)/d.grid.dz))];
pt.pond{2} =[d.pt.pond max(0,round((d.dem(d.pt.pond(1),d.pt.pond(2))-depth2)/d.grid.dz))];
pt.mid{2} =[d.pt.mid max(0,round((d.dem(d.pt.mid(1),d.pt.mid(2))-depth2)/d.grid.dz))];


dmi=sqrt( (d.x(pt.pond{1}(1))-d.x(pt.pond{2}(1)))^2  +  (d.y(pt.pond{1}(2))-d.y(pt.pond{2}(2)))^2  +   (d.z(pt.pond{1}(3))-d.z(pt.pond{2}(3)))^2   );

dmk=sqrt( (d.x(pt.pond{1}(1))-d.x(pt.mid{2}(1)))^2  +  (d.y(pt.pond{1}(2))-d.y(pt.mid{2}(2)))^2  +   (d.z(pt.pond{1}(3))-d.z(pt.mid{2}(3)))^2   );



for i=unique(month(d.date))
    idx=find(month(d.date)==i);
    dhdx(i)=  ( mean(d.head(pt.pond{2}(1),pt.pond{2}(2),pt.pond{2}(3),idx))   - mean(d.head(pt.pond{1}(1),pt.pond{1}(2),pt.pond{1}(3),idx)) ) / (dmi);
    dhdz(i)=  ( mean(d.head(pt.pond{1}(1),pt.pond{1}(2),pt.pond{1}(3),idx))   - mean(d.head(pt.mid{2}(1),pt.mid{2}(2),pt.mid{2}(3),idx) )) / (dmk);
end



figure
h = animatedline;
axis([min(dhdx),max(dhdx),min(dhdz),max(dhdz)])
for t=1:d.time.nt
    addpoints(h,dhdx(t),dhdz(t));
    drawnow
end

fig=figure('units','normalized','outerposition',[0 0 1 1]);hold on; grid on; box on;
xlabel('dh/dx');ylabel('dh/dz')
plot(dhdx,dhdz,'--')
line([-10,10],[0 0],'LineStyle','-.','Color','k')
line([0 0],[-10,10],'LineStyle','-.','Color','k')
line([-10 10],[10,-10],'LineStyle',':','Color','k')
scatter(dhdx,dhdz,10,linspace(1,10,numel(dhdx)))
axis([min(dhdx),max(dhdx),min(dhdz),max(dhdz)])
%axis equal


