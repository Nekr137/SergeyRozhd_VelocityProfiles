clear variables;
% fin='0309_002p.000';
% fin='0409_000p.000';


%fin='0509_000p.000';
fin = 'task13_data/0309_002p.000';


ADCP=rdpadcp(fin,1,'ref','bottom','des','yes');%%'des',1 'ref','bottom',
% adcp = smooth(ADCP,0.1,'rloess');
Vn=ADCP.north_vel;
Ve=ADCP.east_vel;
Vz=ADCP.vert_vel;
t=ADCP.mtime;
L0=60; %last good cell

H0=ADCP.config.range+ADCP.config.adcp_depth;% FOR rdpadcp!!

% H0=ADCP.config.ranges+ADCP.depth(1);%FOR rdradcp!!

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
 Vn(L0+1:end,:)=[];Ve(L0+1:end,:)=[];Vz(L0+1:end,:)=[];%H(L+1:end)=[];
 H0(L0+1:end)=[];
% gout=[fin '.png'];

V=sqrt(Vn.*Vn+Ve.*Ve);%amplituda V
% sh=30425;%sdvig na nomer pervogo pinga
% t0=t;%ishodnaya data
% t=(t-t(1))*24;%vremya v chasah ot nachala realizacii
% tt=t;
% VV=V;
% VV(:,60000-sh:end)=[];VV(:,1:32000-sh)=[];%VV(:,47520-sh:48330-sh)=[];VV(:,42650-sh:44380-sh)=[];VV(:,40280-sh:41580-sh)=[];VV(:,39150-sh:37160-sh)=[];
% tt(:,60000-sh:end)=[];tt(:,1:32000-sh)=[];%tt(:,47520-sh:48330-sh)=[];tt(:,42650-sh:44380-sh)=[];tt(:,40280-sh:41580-sh)=[];tt(:,39150-sh:37160-sh)=[];
% VVe=Ve;
% VVe(:,60000-sh:end)=[];VVe(:,1:32000-sh)=[];%VV(:,47520-sh:48330-sh)=[];VV(:,42650-sh:44380-sh)=[];VV(:,40280-sh:41580-sh)=[];VV(:,39150-sh:37160-sh)=[];
% 
% VVn=Vn;
% VVn(:,60000-sh:end)=[];VVn(:,1:32000-sh)=[];
% 
% t00=t0;t00(:,60000-sh:end)=[];t00(:,1:32000-sh)=[];

% Vs=smoothdata(V,2,'movmean',73,'omitnan');
Ves=smoothdata(Ve,2,'movmean',73,'omitnan');
Vns=smoothdata(Vn,2,'movmean',73,'omitnan');
Vs=sqrt(Vns.*Vns+Ves.*Ves);

% L=(atan(abs(Ve./Vn)));
% a=(sign(Vn)+1)./2;
% b=(sign(Vn)-1)./2;
% c=sign(Ve);
% d=a.*L.*c+c.*b.*(L-pi().*c);%napravlenie v radianah
% D=rad2deg(d);%napravlenie v gradusah
D=90-rad2deg(atan2(Ve,Vn));
Ds2=smoothdata(D,2,'movmean',73,'omitnan');

% Ls=(atan(abs(Ves./Vns)));
% as=(sign(Vns)+1)./2;
% bs=(sign(Vns)-1)./2;
% cs=sign(Ves);
% ds=as.*Ls.*cs+cs.*bs.*(Ls-pi().*c);%napravlenie v radianah
% Ds=rad2deg(ds);%napravlenie v gradusah

% 03092019
% i=find(t>datenum('03-Sep-2019 13:35:38')&t<datenum('03-Sep-2019 15:39:20'));%0309 sec2 
% i=find(t>datenum('03-Sep-2019 09:44:53')&t<datenum('03-Sep-2019 12:08:10'));%0309 sec1

%04092019
% i=find(t>datenum('04-Sep-2019 09:59:03')&t<datenum('04-Sep-2019 11:49:14'));%0409 sec1
% i=find(t>datenum('04-Sep-2019 13:29:48')&t<datenum('04-Sep-2019 16:20:37'));%0409 sec2
% i=find(t>datenum('04-Sep-2019 18:10:58')&t<datenum('04-Sep-2019 20:28:53'));%0409 sec3

%05092019
% i=find(t>datenum('05-Sep-2019 08:55:33')&t<datenum('05-Sep-2019 10:45:51'));%0409 sec1
% i=find(t>datenum('05-Sep-2019 10:54:47')&t<datenum('05-Sep-2019 11:56:11'));%0409 sec2
i=find(t>datenum('05-Sep-2019 15:34:53')&t<datenum('05-Sep-2019 18:36:22'));%0409 sec3

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
tt=t-1/24*3;%Convert to UTC
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


ax1=subplot(2,1,1);
 sz=surface(tt(i),H0,Vs(:,i));
 
%  sz=surface(t,H0,V);
sz.LineStyle=('none');
set(gca,'CLim',[0 .5]); 
ylabel('H, ì');
xlabel('Âğåìÿ');
% xlim manual;
% ylim manual;
zlim([0 .5]);
set(gca,'ydir','reverse');
% xlim([t0(1) t0(22000)]);
% ylim([0 12]);
% xticks(737122:2:7737310);
 
 dateaxis('x',15);
 set(gca,'CLim',[0 .5]);
%  cm1=(0:0.1:1)';cm2=zeros(size(cm1));cm3=(1:-0.1:0)';cmap1=[cm1 cm2 cm3];colormap(ax1,cmap1); %blue-red
 cm2=(1:-0.1:0)';cm3=(1:-0.1:0)';cm1=(ones(size(cm2)));cmap1=[cm1 cm2 cm3];colormap(ax1,cmap1); %white-red
%  colormap(ax1,hsv); 
%  colormap(ax1,cm1); 
%  cmap=colormap(ax1);
%  cmap1=flipud(cmap);
%  colormap(ax1,cmap1);
% ytck = t(i(1)):1/24/6:t(end);
% ax.YTick=ytck;
% set(gca,'YTick',ytck,'xminortick','on');
cc2=colorbar;
 cc2.Label.String ='Ñêîğîñòü, ì/ñ';
 axis tight;
 
ax2=subplot(2,1,2);
  sz2=surface(tt(i),H0,Ds2(:,i));
 ylabel('H, ì');xlabel('Âğåìÿ');
%  sz=surface(t,H0,V);
sz2.LineStyle=('none');
set(gca,'CLim',[-90 270]); %-90 270
% xlim manual;
% ylim manual;
zlim([-90 270]);%-90 270
set(gca,'ydir','reverse');
% xlim([t0(1) t0(22000)]);
% ylim([0 12]);
% xticks(737122:2:7737310);
 
 dateaxis('x',15);
 set(gca,'CLim',[-90 270]);%-90 270
colormap(ax2,hsv); 
 cmap=colormap(ax2);
 cmap1=flipud(cmap);
 
 colormap(ax2,cmap1); 
 cc3=colorbar;
 cc3.Label.String ='Íàïğàâëåíèå, ãğàä';
 axis tight;
  

 %---------------------Vns and Ves fields
% subplot(2,1,1);
%  sz=surface(t(i),H0,Vns(:,i));
%  
% %  sz=surface(t,H0,V);
% sz.LineStyle=('none');
% set(gca,'CLim',[-0.6 .6]); 
% ylabel('H, ì');xlabel('Ñêîğîñòü, ì/ñ');
% % xlim manual;
% % ylim manual;
% zlim([-0.6 .6]);
% set(gca,'ydir','reverse');
% % xlim([t0(1) t0(22000)]);
% % ylim([0 12]);
% % xticks(737122:2:7737310);
%  
%  dateaxis('x',15);
%  set(gca,'CLim',[-0.6 .6]);
%  colorbar;
%  
% subplot(2,1,2);
%   sz2=surface(t(i),H0,Ves(:,i));
%  ylabel('H, ì');xlabel('Íàïğàâëåíèå, ãğàä');
% %  sz=surface(t,H0,V);
% sz2.LineStyle=('none');
% set(gca,'CLim',[-.6 .6]); %-270 90
% % xlim manual;
% % ylim manual;
% zlim([-.6 .6]);%-270 90
% set(gca,'ydir','reverse');
% % xlim([t0(1) t0(22000)]);
% % ylim([0 12]);
% % xticks(737122:2:7737310);
%  
%  dateaxis('x',15);
%  set(gca,'CLim',[-.6 .6]);
%  colorbar;