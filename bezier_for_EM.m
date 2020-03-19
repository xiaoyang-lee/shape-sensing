clc; clear; close all
%% import data
datafilename{1}='D:\学习\coding\SongShuang\Shape Building\14.csv';
raw_data=importdata(datafilename{1});   
dataheader=strtrim(raw_data.textdata);
data=raw_data.data; 

%% matrix trans

row=[50 300 500 700 900 1200 ];
index=6;

start_index=1;
end_idnex=index;

curve_len=130; %whole length
for i=start_index:1:end_idnex

q0=data(row(i),1:4);
%[r1,r2,r3]=quat2angle(q0, 'ZYX'); %四元数-欧拉角 ZYX 弧度
%r1=r1*180/pi;     %Z
%r2=r2*180/pi;     %Y
%r3=r3*180/pi;     %X
R0=quat2dcm(q0) %四元数-旋转矩阵
t0=data(row(i),5:7)
T0=[ R0,t0'; 0 0 0 1]
invT0=inv(T0)
q4=data(row(i),8:11)
R4=quat2dcm(q4) %四元数-旋转矩阵
t4=data(row(i),12:14)
T4=[ R4,t4'; 0 0 0 1]
invT4=inv(T4)
R41=invT0*T4*[0 1; 0 0; 0 0 ; 1 0;]

%% shape reconstruciton 

    
p0=[0,0,0];%+[rand(1,2)*0.2+0.5 0];  % start point
h0=[1 0 0];   %vector point
p3=R41(1:3,1)';%+[rand(1,2)*3-1.5 0];  %end point
h3=R41(1:3,2)';   %end vector

dis=(sum((p0-p3).^2))^0.5;

P=[p0;h0;p3;h3;curve_len 0 0];
k1k3=[dis/2,dis/2];
%k1k3=[dis/2];
options = optimset ('TolFun',1e-15,'TolX',1e-15);
k1k3=lsqnonlin(@findk1k3,k1k3,[],[],options,P);

 k1=k1k3(1);
 k3=k1k3(2);
    
 p1=p0+k1*h0;
 p2=p3-k3*h3;
 
 cntt=1;
 len=30
 for k=1:1:len
        t=(k-1)/(len-1);
        B(cntt,:)=p0*(1-t)^3+3*p1*t*(1-t)^2+3*p2*t^2*(1-t)+p3*t^3;
        %B(i,:)=p0*(1-t)^4+4*p1*t*(1-t)^3+6*p3*t^2*(1-t)^2+4*p2*t^3*(1-t)+p4*t^4;
        cntt=cntt+1;
 end
 
    plot3(B(:,1),B(:,2),B(:,3),'r*-','lineWidth',2);
    axis([0 150 0 150 0 150])
    set(gca,'Fontsize',20);
    %plot3(p1(1),p1(2),p1(3),'rO');
    %axis([0 300 -75 75 -150 150]);
    xlabel('X(mm)','fontsize',20);
    ylabel('Z(mm)','fontsize',20);
    zlabel('Y(mm)','fontsize',20);
    legend('Reconstruction Result')
    grid on
    hold on
end