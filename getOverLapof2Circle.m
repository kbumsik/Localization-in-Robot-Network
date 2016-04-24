function area=getOverLapof2Circle(D)

R = 100;  %com range
if(D<2*R && D>0)
    angle=acos(D/(2*R));  %in radius
    S2=pi*(R^2)* (2*angle)/(2*pi) ;
    Sp=4 * 1/2 * D/2 * sqrt(R^2-D^2/4);
    area=2*S2-Sp;
else
    area=0;
end

    
end
