function plotEnergy(d)

Lv      = reshape(mean(mean(d.energy.Lv(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Lout    = reshape(mean(mean(d.energy.Lout(d.xx,d.yy,:),1),2),d.time.nt+1,1);
H       = reshape(mean(mean(d.energy.H(d.xx,d.yy,:),1),2),d.time.nt+1,1);
G       = reshape(mean(mean(d.energy.G(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Sin 	= d.energy.Sin(:);
Lin     = d.energy.Lin(:);

Rn1     = Lin + Sin - Lout;
Rn2     = H + Lv + G;

Ta  = d.temp.a;
Tg  = reshape(mean(mean(d.temp.grnd(d.xx,d.yy,:),1),2),d.time.nt+1,1);
Ts  = reshape(mean(mean(mean(d.temp.soil(d.xx,d.yy,1:10,:),1),2),3),d.time.nt+1,1);


fig=figure('units','normalized','outerposition',[0 0 1 1]);


subplot(3,4,[1 4]);hold on ; box on
plot(d.date,Rn1,'r'); plot(d.date,Rn2,'--r'); plot(d.date,d.energy.Rnobs,'O--r');
xlabel('Time'); ylabel('[W/m^2]');legend('Rn1= Lin + Sin - Lout','Rn2 = H + Lv + G','Rn obs')



subplot(3,4,5);hold on ; box on
plot(d.date,d.energy.Sin(:),'c');
xlabel('Time'); ylabel('[W/m^2]');legend('Shortwave IN')



subplot(3,4,6);hold on ; box on
plot(d.date,d.energy.Lin(:),'y');
xlabel('Time'); ylabel('[W/m^2]');legend('Longwave IN')



subplot(3,4,7);hold on ; box on
plot(d.date,Lv,'m'); plot(d.date,d.energy.Lvobs(:),'--m');
xlabel('Time'); ylabel('[W/m^2]');legend('Latent Heat')




subplot(3,4,8);hold on ; box on
plot(d.date,G,'b');
xlabel('Time'); ylabel('[W/m^2]');legend('Ground Heat')




subplot(3,4,9);hold on ; box on
 plot(d.date,d.energy.Soutobs(:),'--c');
xlabel('Time'); ylabel('[W/m^2]');legend('Shorwave OUT obs')




subplot(3,4,10);hold on ; box on
plot(d.date,Lout,'g'); plot(d.date,d.energy.Loutobs(:),'--g');
xlabel('Time'); ylabel('[W/m^2]');legend('Longwave OUT sim','Longwave OUT obs')




subplot(3,4,11);hold on ; box on
plot(d.date,H,'m'); plot(d.date,d.energy.Hobs(:),'--m');
xlabel('Time'); ylabel('[W/m^2]');legend('Sensible heat H','Sensible heat H obs')




subplot(3,4,12);hold on ; box on
plot(d.date,Ta,'b')
plot(d.date,Tg,'r')
plot(d.date,Ts,'g')
xlabel('Time'); ylabel('C]');

