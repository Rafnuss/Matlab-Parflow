clc;
clear all;

allname={'Evergreen needleleaf forests','Evergreen broadleaf forests',...
    'Deciduous needleleaf forests','Deciduous broadleaf forests',...
    'Mixed forests','Closed shrublands','Open shrublands','Woody savannas',...
    'Savannas','Grasslands','Permanent wetlands',...
    'Croplands','Urban and builtup lands','Cropland/natural vegetation mosaic',...
    'Snow and ice','Barren','Water bodies','Bare Soil '};

list=[7 10 11 12 14 15 16 17 18];

u=1;
for i=list
    load([num2str(i) '.mat']);
    
    name{u}=allname{i};
    I(u,:)=reshape(mean(mean(d.flux.I,2),1),366,1);
    S(u,:)=reshape(mean(mean(d.snow,2),1),366,1);
    R(u,:)=d.flux.Rsum;
    Et(u,:)=reshape(mean(mean(d.flux.E.t,2),1),366,1);
    Egrnd(u,:)=reshape(mean(mean(d.flux.E.grnd,2),1),366,1);
    Eveg(u,:)=reshape(mean(mean(d.flux.E.veg,2),1),366,1);
    Tgrnd(u,:)=reshape(mean(mean(d.temp.grnd,2),1),366,1);
    Tsoil(u,:,:)=reshape(mean(mean(d.temp.soil,2),1),366,10);
    Wlev(u,:)=reshape(mean(mean(d.wlevelextrap,2),1),366,1);
    sub(u,:)=d.subsurface.sum;
    surf(u,:)=d.surface.sum;
    
    u=u+1;
end
Sobs=d.flux.S;

P=d.flux.P;
Ps=d.flux.Ps;
Pr=d.flux.Pr;

%%
boxplot(I')
boxplot(Et','extrememode','compress','labels',name,'plotstyle','compact')
bar(nanmean(I')/nanmean(P))

plot(Wlev')
bar(mean(Wlev'))
bar(nanmean(R')/nanmean(P))







for i=1:size(Tsoil,1)
    for j=1:size(Tsoil,2)
        if any(Tsoil(i,j,:)<0)
            return
            depthfreez(i,j)=find(Tsoil(i,j,:)<0);
        else
            depthfreez(i,j)=0;
        end
    end
end






figure;  box on; hold on
boxplot(Tgrnd')
set(gca, 'XTickLabel',name, 'XTick',1:numel(name),'XTicklabelRotation',15); ylabel('C');







figure;  box on;hold on
bar([nanmean(P)*ones(9,1) nanmean(I')' nanmean(R')' nanmean(Et')']*24*365*1000)
%errorbar(1:9,nanmean(Et')',nanstd(Et')','xk','LineWidth',2)
%errorbar(1:9+0.9,nanmean(Eveg')',nanstd(Eveg')','xk','LineWidth',2)
set(gca, 'XTickLabel',name, 'XTick',1:numel(name),'XTicklabelRotation',15)
legend('Precipitation','Infiltration','Runoff','EvaporationT'); ylabel('mm/yr');






figure;  box on;hold on
Evegc     = Eveg;Evegnc     = Eveg;
Evegc(Eveg<0)=0; Evegnc(Eveg>0)=0; 
Egrndc     = Egrnd;Egrndnc     = Egrnd;
Egrndc(Egrnd<0)=0; Egrndnc(Egrnd>0)=0;
Etc     = Et;Etnc     = Et;
Etc(Et<0)=0; Etnc(Et>0)=0; 

stackData(:,1,1)=nanmean(Evegc')';
stackData(:,1,2)=nanmean(Evegnc')';
stackData(:,2,1)=nanmean(Egrndc')';
stackData(:,2,2)=nanmean(Egrndnc')';
stackData(:,3,1)=nanmean(Etc')';
stackData(:,3,2)=nanmean(Etc')';
plotBarStackGroups(stackData*24*365*1000, name)

bar([nanmean(Etnc')' nanmean(Etc')' nanmean(Evegnc')' ...
    nanmean(Evegc')' nanmean(Egrndc')']*24*365*1000)
set(gca, 'XTickLabel',name, 'XTick',1:numel(name),'XTicklabelRotation',15)
legend('Total dew','Total','Vegetation dew','Vegetation','Ground'); ylabel('mm/yr');title('Evaporation')








figure; subplot(2,1,1);hold on; grid on; box on;
plot(d.date,S'); plot(d.date,Sobs,'--k'); plot(d.date,cumsum([0;Ps(2:end)*24*1000]),'k')
axis tight; ylabel('mm');legend([name 'Snow observated','cumulative Snow Precipitation'],'location','Best');xlabel('date')
subplot(2,1,2);hold on; grid on; box on;
plot(d.date,Tgrnd'); axis tight


cd([d.path.core '/post/plot']);
filename='snow';
screen2image






figure; hold on; grid on; box on;
subplot(2,1,1);plot(d.date,sub');title('Subsurface Storage')
axis tight; ylabel('m');legend(name,'location','Best');xlabel('date')
subplot(2,1,2);plot(d.date,Wlev');title('Water table level')
axis tight; ylabel('m');legend(name,'location','Best');xlabel('date')
cd([d.path.core '/post/plot']);
filename='sub-wtlev';
screen2image

