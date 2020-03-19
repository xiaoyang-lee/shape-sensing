function f=findk1k3(x,P)

k1=x(1);
k3=x(2);
%k3=k1;

p0=P(1,:);
h0=P(2,:);
p3=P(3,:);
h3=P(4,:);

len=10; % number of section
curve_length=P(5,1);
%curve_length=135;

p1=p0+k1*h0;
p2=p3-k3*h3;

point1=p0+curve_length*h0/(len-1);
point2=p3-curve_length*h3/(len-1);

dis1=zeros(1,len+2);
dis2=dis1;

for i=1:1:len-1
    
    t=(i-1)/(len-1);
    B1=p0*(1-t)^3+3*p1*t*(1-t)^2+3*p2*t^2*(1-t)+p3*t^3;
    
    t=(i)/(len-1);
    B2=p0*(1-t)^3+3*p1*t*(1-t)^2+3*p2*t^2*(1-t)+p3*t^3;
    
    dis1(i)=(sum((B2-B1).^2))^0.5;
    dis2(i)=curve_length/(len-1);
    
    dis1(len)=dis1(len)+dis1(i);
    dis2(len)=dis2(len)+dis2(i);
    
end

 for k=1:1:len-1
     t=(k-1)/(len-1);
     B(k,:)=p0*(1-t)^3+3*p1*t*(1-t)^2+3*p2*t^2*(1-t)+p3*t^3;
 end
 
dis1(len+1)=sum((B(2,:)-point1).^2);
dis1(len+2)=sum((B(len-1,:)-point2).^2);

len_scale=9;

dis1(len)=dis1(len)*len_scale;
dis2(len)=dis2(len)*len_scale;

f=[(dis1-dis2).^2]
%f=(dis1(len:len+2)-dis2(len:len+2))
%f=[(dis1(len)-dis2(len))^2]