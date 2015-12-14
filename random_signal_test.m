%% ==========================================================================
x = [0:0.01:10];
    p1 = raylpdf(x,0.5);
    p2 = raylpdf(x,1);
    p3 = raylpdf(x,2);
    plot(x,p1,x,p2,x,p3);
%%
%rayleigh distrubution simulate
pd=makedist('Rayleigh');

 for x1 = 1: 1001
    y(x1)=random(pd); 
 end
 figure(3);
 hold on;
for x1 = 1: 1001
    plot(x1,y(x1));
end
 hold off;