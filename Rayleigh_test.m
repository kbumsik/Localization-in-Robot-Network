%% ==========================================================================
x = [0:0.01:10];
    p1 = raylpdf(x,0.5);
    p2 = raylpdf(x,1);
    p3 = raylpdf(x,2);
    plot(x,p1,x,p2,x,p3);
%%
%rayleigh distrubution simulate
 
pd=makedist('Rayleigh');

hold on;
x1 = 1:100;
 for i = x1;
    y(i)=random(pd); 
 end

% plot(x, sin(x));
% plot(x,y);
 plot(x1,y);
hold off;
