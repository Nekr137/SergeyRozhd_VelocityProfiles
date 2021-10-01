fin='DPL6_000r.000';
ADCP=RDRADCP(fin,1,[1 7236]);%'des',1
fout=[fin '.txt'];
% adcp = smooth(ADCP,0.1,'rloess');
Vn=ADCP.north_vel;
Ve=ADCP.east_vel;
Vz=ADCP.vert_vel;
t=ADCP.mtime;
H0=ADCP.config.ranges+ADCP.depth(1);%cell depth=ADCP depth+ofcets
%-------------specific blok for moored adcp ---------------------
L=14;%last good cell for ADCP data
H=ADCP.config.ranges.*floor(2.*60./L./2)./2+ADCP.depth(1);%scale to have 60 m of data with step of 0.5 m
vn=zeros(size(Vn));ve=zeros(size(Vn));vz=zeros(size(Vn));
for i=1:L
    Vn(i,:) = smooth(Vn(i,:),0.005,'rloess');%filter with 0.5% window
    Ve(i,:) = smooth(Ve(i,:),0.005,'rloess');
    Vz(i,:) = smooth(Vz(i,:),0.005,'rloess');
end
%-------------------  end  -------------------------------
Vn(L+1:end,:)=[];Ve(L+1:end,:)=[];Vz(L+1:end,:)=[];H(L+1:end)=[];
Hm=H(:,ones(1,size(Vn,2)));%matrix of H
tm=t(ones(size(Vn,1),1),:);%matrix of t
Vnr=reshape(Vn,numel(Vn),1);
Ver=reshape(Ve,numel(Vn),1);
Vzr=reshape(Vz,numel(Vn),1);
Hmr=reshape(Hm,numel(Vn),1);
tmr=reshape(tm,numel(Vn),1);
out=[tmr Hmr Vnr Ver Vzr];
save(fout,'out','-ascii');
% datestr(ADCP.mtime(1:10));%ping date and time
% plot(t,Vn(10,:))
% tstool