X=[422.4534 254.1967 255.3988 575.3597 345.7797 345.6264 516.3976 329.0326];
Y=[367.2416 556.0389 654.7167 445.9846 546.2687 446.5271 365.9746 329.0326];

X=[200 300 250 250 250 250 250 250];
Y=[800 800 800-50*sqrt(3) 700-50*sqrt(3) 600-50*sqrt(3) 500-50*sqrt(3) 400-50*sqrt(3) 300-50*sqrt(3)];
n=1000000;
counter=0;
xField=1000;
yField=1000;
radius=100;
for i=1:n
    randX=rand()*xField;
    randY=rand()*yField;
    for j=1:8
        if sqrt( (randX-X(j))^2 + (randY-Y(j))^2  ) < radius
            counter=counter+1;
            break;
        end
    end
end
xField*yField*( counter/n ) % 1.5883e+05

overlap=getOverLapof2Circle(100);%=>1.2284*10^4
overlap_small=getOverLapof2Circle( sqrt(50^2+(100+50*sqrt(3))^2)  );
% ideal range: 1.6058e+05
ideal_range=pi*radius^2 * 8 - (8*overlap) + ( pi*radius^2/6-100*50*sqrt(3)/2 )*3+ 100*50*sqrt(3)/2 + overlap_small*2  


%coverage diff= 1.09%