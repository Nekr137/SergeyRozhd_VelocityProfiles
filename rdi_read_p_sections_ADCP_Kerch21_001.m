clear variables;
fin='DATA_001p.000';
ADCP=rdpadcp(fin,1,'ref','bottom','des','yes');%%'des',1
% adcp = smooth(ADCP,0.1,'rloess');
Vn=ADCP.north_vel;
Ve=ADCP.east_vel;
Vz=ADCP.vert_vel;
t=ADCP.mtime;
H0=ADCP.config.range+ADCP.config.adcp_depth;%cell depth=ADCP depth+offsets
% H0=ADCP.config.ranges+ADCP.config.adcp_depth(1);%cell depth=ADCP depth+offsets
%-------------specific blok for moored adcp ---------------------
% L=80;%last good cell for ADCP data
% % H=ADCP.config.ranges.*floor(2.*60./L./2)./2+ADCP.depth(1);%scale to have 60 m of data with step of 0.5 m
% % vn=zeros(size(Vn));ve=zeros(size(Vn));vz=zeros(size(Vn));
% % for i=1:L
% %     Vn(i,:) = smooth(Vn(i,:),0.005,'rloess');%filter with 0.5% window
% %     Ve(i,:) = smooth(Ve(i,:),0.005,'rloess');
% %     Vz(i,:) = smooth(Vz(i,:),0.005,'rloess');
% % end
% %-------------------  end  -------------------------------
% Vn(L+1:end,:)=[];Ve(L+1:end,:)=[];Vz(L+1:end,:)=[];%H(L+1:end)=[];H0(L+1:end)=[];
% gout=[fin '.png'];

V=sqrt(Vn.*Vn+Ve.*Ve);%amplituda V
% sh=138367;%sdvig na nomer pervogo pinga
% t0=t;%ishodnaya data
% t=(t-t(1))*24;%vremya v chasah ot nachala realizacii
% tt=t;
% VV=V;
% VV(:,172380-sh:end)=[];VV(:,1:145555-sh)=[];
% VVe=Ve;
% VVe(:,172380-sh:end)=[];VVe(:,1:145555-sh)=[];
% VVn=Vn;
% VVn(:,172380-sh:end)=[];VVn(:,1:145555-sh)=[];
% tt(:,172380-sh:end)=[];tt(:,1:145555-sh)=[];
% t00=t0;
% t00(:,172380-sh:end)=[];t00(:,1:145555-sh)=[];

Vs=smoothdata(V,2,'movmean',73,'omitnan');
Ves=smoothdata(Ve,2,'movmean',73,'omitnan');
Vns=smoothdata(Vn,2,'movmean',73,'omitnan');

% L=(atan(abs(Ve./Vn)));
% a=(sign(Vn)+1)./2;
% b=(sign(Vn)-1)./2;
% c=sign(Ve);
% d=a.*L.*c+c.*b.*(L-pi().*c);%napravlenie v radianah
% D=rad2deg(d);%napravlenie v gradusah
D=90-rad2deg(atan2(Ve,Vn));
% D=D+90;
figure(3);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 14:01:11'),1);
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn17_adcp.dat','data','-ascii');

figure(4);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 14:44:05'),1);
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn18_adcp.dat','data','-ascii');


figure(5);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 15:07:14'),1)+1;%15:06:21
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn19_adcp.dat','data','-ascii');


figure(6);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 15:28:45'),1)+1;
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn20_adcp.dat','data','-ascii');


figure(7);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 16:11:54'),1);
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn21_adcp.dat','data','-ascii');


figure(8);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 16:35:25'),1);
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn22_adcp.dat','data','-ascii');


figure(9);
subplot(1,2,1);
i=find(t>datenum('24-Apr-2019 17:01:25'),1);
plot(V(:,i),-H0,'-r');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Скорость, м/с');
subplot(1,2,2);
plot(D(:,i),-H0,'-b');set(gca,'ydir','reverse');
ylabel('H, м');xlabel('Направление, град');
data=ones(size(H0,1),3);data(:,1)=-H0;data(:,2)=V(:,i);data(:,3)=D(:,i);data(35:end,:)=[];
save('stn23_adcp.dat','data','-ascii');


% figure(2)
% sz=surface(t00,-H0,Ves);
% sz.LineStyle=('none');
% dateaxis('x',15);
% set(gca,'CLim',[-0.5 .5]);
% 
% i0=find(t00>datenum('24-Apr-2019 14:20'),1);
% figure(4);
% plot(Ves(:,i0),-H0,'-b');hold on;plot(Vns(:,i0),-H0,'-r');ylabel('H, м');xlabel('Скорость, м/с');
% i1=find(t00>datenum('24-Apr-2019 14:52'),1);
% figure(5);
% plot(Ves(:,i1),-H0,'-b');hold on;plot(Vns(:,i1),-H0,'-r');ylabel('H, м');xlabel('Скорость, м/с');
% i2=find(t00>datenum('24-Apr-2019 15:10'),1);
% figure(6);
% plot(Ves(:,i2),-H0,'-b');hold on;plot(Vns(:,i2),-H0,'-r');ylabel('H, м');xlabel('Скорость, м/с');
% i3=find(t00>datenum('24-Apr-2019 15:30'),1);
% figure(7);
% plot(Ves(:,i3),-H0,'-b');hold on;plot(Vns(:,i3),-H0,'-r');ylabel('H, м');xlabel('Скорость, м/с');
% i4=find(t00>datenum('24-Apr-2019 16:10'),1);
% figure(8);
% plot(Ves(:,i4),-H0,'-b');hold on;plot(Vns(:,i4),-H0,'-r');ylabel('H, м');xlabel('Скорость, м/с');
% i5=find(t00>datenum('24-Apr-2019 16:33'),1);
% figure(9);
% plot(Ves(:,i5),-H0,'-b');hold on;plot(Vns(:,i5),-H0,'-r');ylabel('H, м');xlabel('Скорость, м/с');

%caxis([-0.6,0.6]);

% std=nanstd((Vn(:,3:end-2)),1,2);
% stdH=nanstd((Vn(:,3:end-2)),1,1);%std kazhdogo profilya
% plot(std,H);

% cmap_y=[0,0,0.8
%     0,0,0.6
%     0,0,0.4
%     0,0,0.2
%     1,1,1
%     0.2,0,0
%     0.4,0,0
%     0.6,0,0
%     0.8,0,0];

% contourf(t0(5536:9135),H0,Vy(:,5536:9135)); set(gca,'CLim',[-.5 .5]); zlim([-.5 .5]);%2-11.03.2018
% contourf(t0(7774:8030),H0,V(:,7774:8030)); set(gca,'CLim',[-.5 .5]); zlim([-.5 .5]);%8.03.2018
% dateaxis('x',6);
% colormap(cmap_y);

%Postroenie polei skorosti


% %----------VERTICAL-----------
% figure(1);
% sz=surface(t0(5536:9135),H0,Vz(:,5536:9135));
% sz.LineStyle=('none');
% set(gca,'CLim',[-.1 .1]); 
% xlim manual;
% ylim manual;
% zlim manual;
% zlim([-.1 .1]);
% xlim([t0(5536) t0(9135)]);
% ylim([0 12]);
% xticks(737122:2:7737310);
% dateaxis('x',6);
% daspect([50,250,1]);
% colorbar('westoutside');
% %----------Along (Y)-----------
% figure(2);
% sz=surface(t0(5536:9135),H0,Vy(:,5536:9135));
% sz.LineStyle=('none');
% set(gca,'CLim',[-.5 .5]); 
% xlim manual;
% ylim manual;
% zlim manual;
% zlim([-.5 .5]);
% xlim([t0(5536) t0(9135)]);
% ylim([0 12]);
% xticks(737122:2:7737310);
% dateaxis('x',6);
% daspect([50,250,1]);
% colorbar('westoutside');
% %----------Perpendicular (X)-----------
% figure(3);
% sz=surface(t0(5536:9135),H0,Vx(:,5536:9135));
% sz.LineStyle=('none');
% set(gca,'CLim',[-.5 .5]); 
% xlim manual;
% ylim manual;
% zlim manual;
% zlim([-.5 .5]);
% xlim([t0(5536) t0(9135)]);
% ylim([0 12]);
% xticks(737122:2:7737310);
% dateaxis('x',6);
% daspect([50,250,1]);
% colorbar('westoutside');
%----------Amplitude-----------
figure(4);
% sz=surface(t0(5536:9135),H0,V(:,5536:9135));
sz=surface(t00,H0,VV);
sz.LineStyle=('none');
set(gca,'CLim',[0 .5]); 
% xlim manual;
% ylim manual;
% zlim([0 .3]);
% xlim([t0(1) datenum('04-Apr-2019 12:00:00')]);
% ylim([0 12]);
% xticks(737122:2:7737310);
% ylabel('Расстояние от дна, м');
dateaxis('x',15);
datetick('x','mm/dd');
daspect([50,250,1]);
c=colorbar('westoutside');
c.Label.String = 'Скорость, м/с';


% Hm=H(:,ones(1,size(Vn,2)));%matrix of H
% tm=t(ones(size(Vn,1),1),:);%matrix of t
% latm=lat(ones(size(Vn,1),1),:);
% lonm=lon(ones(size(Vn,1),1),:);

% save(fout);

% data=[t0;V(1,:);V(21,:);V(41,:)];
%     dir_1800=360+90-rad2deg(atan2(Vn(1,:),Ve(1,:)));dir_1830=360+90-rad2deg(atan2(Vn(10,:),Ve(10,:)));dir_1850=360+90-rad2deg(atan2(Vn(14,:),Ve(14,:)));
%     data=[data;dir_1800;dir_1830;dir_1850];data=data';
%     save('adcp_ABH_moored_all_data4report.mat');
%     save('adcp_ABH_moored.dat','data','-ascii');
% datestr(ADCP.mtime(1:10));%ping date and time
% plot(t,Vn(10,:))
% tstool