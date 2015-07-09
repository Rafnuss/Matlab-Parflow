function Mayboom1D(d)

pt.a =[1 1 d.zz(2)];
pt.b =[1 1 d.zz(end/2)];
pt.c =[1 1 d.zz(end-2)];


%% plot the point (head)

fig=figure('units','normalized','outerposition',[0 0 1 1]);
hold on; grid on; box on


plot(d.date,reshape(d.head(pt.a(1),pt.a(2),pt.a(3),:),d.time.nt+1,1))
plot(d.date,reshape(d.head(pt.b(1),pt.b(2),pt.b(3),:),d.time.nt+1,1))
plot(d.date,reshape(d.head(pt.c(1),pt.c(2),pt.c(3),:),d.time.nt+1,1))

legend([num2str(pt.a(3)*d.grid.dz) ' mAD'],[num2str(pt.b(3)*d.grid.dz) ' mAD'],[num2str(pt.c(3)*d.grid.dz) ' mAD'])
ylabel('Head [mAD]')

cd([d.info.chemin '/post/save']);
screen2jpeg('Mayboom1D')
saveas(fig,'Mayboom1D.fig')
cd([d.info.chemin '/post/plot']);