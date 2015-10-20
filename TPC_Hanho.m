clear

max1 = 0; % max average SINR of UE2 and the Tx power of E1 and E2 eNodeBs
min = 100; % min average SINR of UE2 and the Tx power of E1 and E2 eNodeBs

S_E1 = 0;
S_E2 = 0;

E1_lot = [289, 578]; % location of E1 eNodeB
E2_lot = [867, 578]; % location of E2 eNodeB

E1_Tx_Pwr = 46; % max Tx power of E1 eNodeB
E2_Tx_Pwr = 46; % max Tx power of E2 eNodeB
f = 500; % MHz
Hb = 15; % Height of base station antenna
Hm = 1.5; % Height of base station antenna
SINR_S = 0;
SINR_S_D = 0;
TH_S = 0;
TH_S_D = 0;

a = 0;
b = 1156;
r = a + (b-a)*rand(1,2);
%s_lot = randi(1156, 1, 2); % assignment of location points of UEs randomly
%s_lot = [289,478;578,578];
s_lot = r;

ss = size(s_lot);

e_lot(1,1) = 289; % pointing location of E1, E2 eNodeBs
e_lot(1,2) = 578;
e_lot(2,1) = 867;
e_lot(2,2) = 578;

Ch = 0.8+(1.1*log10(f)-0.7)*Hm-1.56*log10(f); % Hata Pathloss Model
n = -174+4+10*log10(10^6);
nr = db2pow(n);

for i = 1:ss
    for j = 1:ss
        lot1(i,1) = s_lot(i,1)-E1_lot(1,1);
        lot1(j,2) = s_lot(j,2)-E1_lot(1,2);
        lot2(i,1) = s_lot(i,1)-E1_lot(1,1);
        lot2(j,2) = s_lot(j,2)-E1_lot(1,2);
    end
end

for i = 1:ss
    E1_D(i,1) = sqrt(lot1(i,1)^2+lot1(i,2)^2);
    E2_D(i,1) = sqrt(lot2(i,1)^2+lot2(i,2)^2);
end

temp = 0;
E1_N = 0;
E2_N = 0;

for i = 26:E1_Tx_Pwr
    for j = 26:E2_Tx_Pwr
        temp = temp + 1;
        for k = 1:ss
            Lu1(k,1) = 69.55+26.16*log10(f)-13.82*log10(Hb)-Ch+(44.9-6.55*log10(Hb))*log10(0.001*E1_D(k,1));
            % Hata Pathloss Model
            Lu2(k,1) = 69.55+26.16*log10(f)-13.82*log10(Hb)-Ch+(44.9-6.55*log10(Hb))*log10(0.001*E2_D(k,1));
            % Hata Pathloss Model
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % The block below is to distinguish which signal is
            % interference
            if (i-Lu1(k,1))>=(j-Lu2(k,1))
                SINR(k,1) = 10*log10(db2pow(i-Lu1(k,1))/(db2pow(j-Lu2(k,1))+nr));
                TT(temp, k+10) = 10^6*log2(1+SINR(k,1));
                TT(temp, 1) = i;
                TT(temp, 2) = j;
                TT(temp, k+2) = SINR(k,1);
                E1_N = E1_N+1;
            elseif (1-Lu1(k,1))<(j-Lu2(k,1))
                SINR(k,1) = 10*log10(db2pow(j-Lu2(k,1))/(db2pow(i-Lu1(k,1))+nr));
                TT(temp, k+10) = 10^6*log2(1+SINR(k,1));
                TT(temp, 1) = i;
                TT(temp, 2) = j;
                TT(temp, k+2) = SINR(k,1);
                E2_N = E2_N+1;
            end
            TH_S = TT(temp, k+10) + TH_S;
            SINR_S = SINR(k,1) + SINR_S;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        TT(temp, 4+4) = SINR_S;
        TT(temp, 4+5) = SINR_S/2;
        TT(temp, 4+14) = TH_S;
        TT(temp, 4+15) = TH_S/2;
        TT(temp, 4+12) = E1_N;
        TT(temp, 4+13) = E2_N;
        SINR_S_D(i-25, j-25) = SINR_S/2; % To get average among UEs
        SINR_S_D2(i,j) = SINR_S/2;
        SINR_S = 0;
        TH_S = 0;
        E1_N = 0;
        E2_N = 0;
    end
end

min_ue(1,1) = 100;

for i = 1:2
    for j = 1:441
        if min_ue(1,1) > TT(j, 2+i)
            min_ue(1,1) = TT(j, 2+i);
            min_ue(1,2) = TT(j,1);
            min_ue(1,3) = TT(j,2);
        end
    end
end

tp = 0;

for  i = 1:441
    if TT(i,3)>TT(i,4)
        TT(i,21) = TT(i,4);
        tp(i,1) = TT(i,4);
        tp(i,2) = TT(i,1);
        tp(i,3) = TT(i,2);
    elseif TT(i,3)<TT(i,4)
        TT(i,21) = TT(i,3);
        tp(i,1) = TT(i,3);
        tp(i,2) = TT(i,1);
        tp(i,3) = TT(i,2);
    elseif TT(i,3)==TT(i,4)
        TT(i,21) = TT(i,3);
        TT(i,22) = 0955;
        tp(i,1) = TT(i,3);
        tp(i,2) = TT(i,1);
        tp(i,3) = TT(i,2);
        tp(i,4) = 0955;
    end
end

listup(1,1) = 0;

for i = 1:441
    if listup(1,1) < tp(i,1)
        listup(1,1) = tp(i,1);
        listup(1,2) = tp(i,2);
        listup(1,3) = tp(i,3);
    elseif listup(1,1) == tp(i,1)
        listup(1,1) = tp(i,1);
        listup(1,2) = tp(i,2);
        listup(1,3) = tp(i,3);
        listup(1,4) = 0955;
    end
end

for i = 1:21
    for j = 1:21
        if max1(1,1) < SINR_S_D(i,j)
            max1(1,1) = SINR_S_D(i,j);
            max1(1,2) = i;
            max1(1,3) = j;
        end
    end
end
max1(1,2) = max1(1,2)+25;
max1(1,3) = max1(1,3)+25;

for i = 1:21
    for j = 1:21
        if min(1,1) > SINR_S_D(i,j)
            min(1,1) = SINR_S_D(i,j);
            min(1,2) = i;
            min(1,3) = j;
        end
    end
end
min(1,2) = min(1,2)+25;
min(1,3) = min(1,3)+25;

plot(s_lot(1:ss), s_lot((ss+1):(ss*2)), 's', e_lot(1:2), e_lot(3:4), 'o', 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 10),grid;
ylim([0 1156]);
xlim([0 1156]);
            
