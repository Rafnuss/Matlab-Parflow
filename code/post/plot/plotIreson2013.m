function plotIreson2013(d)


y=d.y(1:end/2);
[Y,Z]=meshgrid(y,d.z);

fig1=figure('units','normalized','outerposition',[0 0 1 1]);

subplot(3,1,1); hold on; box on;
    plot(y,mean(d.flux.E.t(d.coupe(1),1:numel(y),:),3),'--k')
    xlabel('');ylabel('Avearge of Total evaporation [m/hr]');


    
subplot(3,1,[2 3]); hold on; box on;
    plot(y,max(d.wlevelextrap(d.coupe(1),1:numel(y),:),[],3),'--k');
    plot(y,mean(d.wlevelextrap(d.coupe(1),1:numel(y),:),3),'-ok');
    h{1}=pcolor(Y,Z,reshape(max(d.saturation(d.coupe(1),1:numel(y),d.zz,:),[],4)-min(d.saturation(d.coupe(1),1:numel(y),d.zz,:),[],4),numel(d.yy(1:end/2)),numel(d.zz))'); 
    set(h{1}, 'EdgeColor', 'none');colormap('gray');colormap(flipud(colormap));    shading interp; 
    h{2}=colorbar('location','South');h{2}.Label.String = 'Seasonal change in water content [-]';
    plot(y,min(d.wlevelextrap(d.coupe(1),1:numel(y),:),[],3),'--k');
    plot(y,max(d.wlevelextrap(d.coupe(1),1:numel(y),:),[],3),'--k');
    plot(y,mean(d.wlevelextrap(d.coupe(1),1:numel(y),:),3),'-ok');
    plot(y,d.dem(d.coupe(1),1:end/2),'Color','k','lineWidth',2); ylim([8 15])
    xlabel('Distence [m]');ylabel('Elevation [m]');legend('Seasonal water table fluctuation zone','Mean water table')
    
    
    
fig2=figure('units','normalized','outerposition',[0 0 1 1]);
hold on; box on

%plot(d.date(1:4:end),reshape(d.wlevelextrap(d.coupe(1),1,1:4:end),(d.time.nt+1)/4,1),'vk')
%plot(d.date(1:4:end),reshape(d.wlevelextrap(d.coupe(1),numel(y),1:4:end),(d.time.nt+1)/4,1),'ok')
plot(d.date,reshape(dhomo.wlevelextrap(d.coupe(1),1,:),d.time.nt+1,1),'-b')
plot(d.date,reshape(dhomo.wlevelextrap(d.coupe(1),numel(y),:),d.time.nt+1,1),'-g')
plot(d.date,reshape(dexp.wlevelextrap(d.coupe(1),1,:),d.time.nt+1,1),'--b')
plot(d.date,reshape(dexp.wlevelextrap(d.coupe(1),numel(y),:),d.time.nt+1,1),'--g')
ylabel('Water table elevation [m]');xlabel('Time')
legend('Beneath hilltop homogeneous','Valley bottom homogeneous','Beneath hilltop exponential','Valley bottom exponential','location','South')










