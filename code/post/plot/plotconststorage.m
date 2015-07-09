function plotconststorage(d)
ty=1:365*5;


fig=figure('units','normalized','outerposition',[0 0 1 1]);

subplot(2,3,[1 3]);box on; grid on; hold on;
    S    	= reshape(mean(mean(d.snow(d.xx,d.yy,:),1),2),d.time.nt+1,1);       % amount snow
    SS      = d.surface.sum;                                                    % amount surf storage
    SSS     = d.subsurface.sum;                                                 % amount sub storage
    ST      = SS+S+SSS;
    plot(d.date(ty),S(ty)-S(1),'k')
    plot(d.date(ty),SS(ty)-SS(1),'g')
    plot(d.date(ty),SSS(ty)-SSS(1),'m')
    plot(d.date(ty),ST(ty)-ST(1),'r')

    legend('S_{Snow}',...
        ['S_{surf} ' sprintf('(S_{surf,0}=%3.3f)',SS(1))],...
        ['S_{sub}' sprintf('(S_{sub,0}=%3.3f)',SSS(1))],...
        ['S_{total}= (S_{surf} +S_{sub} +S_{snow})' sprintf('(S_{total,0}=%3.3f)',ST(1))],...
        'Location','Best')
    title('Storage');xlabel('Time [d]');ylabel('m');axis tight


    
    

T(1)=datenum('1 september 2002');
T(2)=datenum('1 september 2004');
T(3)=datenum('31 August 2007');
t(1)=find(datenum(d.date)>T(1)-1/24 & datenum(d.date)<T(1)+1/24);
t(2)=find(datenum(d.date)>T(2)-1/24 & datenum(d.date)<T(2)+1/24);
t(3)=find(datenum(d.date)>T(3)-1/24 & datenum(d.date)<T(3)+1/24);

for u=1:3
subplot(2,3,3+u);box on; grid on; hold on;
    area(d.y,d.top.level(d.coupe(1),:),'FaceColor',[102/255 51/255 0])
    plot(d.y,d.z(d.wlevel(d.coupe(1),:,t(u))),'Color','b','lineWidth',2)
    xlabel('y[m]');xlabel('elevation [m]')
    ylim([d.grid.lz d.grid.uz])
    title(datestr(T(u)))
end
