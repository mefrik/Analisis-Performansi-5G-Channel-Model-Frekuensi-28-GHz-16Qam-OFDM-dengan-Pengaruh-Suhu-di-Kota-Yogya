clear all;
close all;
clc;

direk = uigetdir('*.*', 'Pilih folder datasets');
nomor = 1;

if ~isequal(direk,0)
    
    a = dir(fullfile(direk, '*.*'));
%     A = struct2table(a);
%     sortedT = sortrows(A, 'date');
%     ambil_data = table2struct(sortedT);
    ambil_data = a;

    cek1 = "MAKSIMUM";
    cek2 = "MINIMUM";
    if contains(direk,cek1)
        out_folder = 'Tahap_1_Excel_PDP_MAKSIMUM';
        if ~exist(out_folder, 'dir')
            mkdir(out_folder);
        end
    elseif contains(direk,cek2)
        out_folder = 'Tahap_1_Excel_PDP_MINIMUM';
        if ~exist(out_folder, 'dir')
            mkdir(out_folder);
        end
    end
    
    for n = 3 : numel(ambil_data)
        
        nama_data = ambil_data(n).name;
        f_data = fullfile(direk, nama_data);
        data = importdata(f_data);
        
        detik = [];
        dnum = [];
        
        % Max power
        dmax = max(data(:,2));
        % Normalisasi
        normd = data(:,2) - dmax;
        
        for m = 1 : size(data, 1)
            
            % Calculate Numerik
            dnum(m) = 10^(normd(m)/10);
            
            % Calculate OMNI
            tempdelay1 = data(m);
            if tempdelay1 == data(1,1)
                detik(m) = 1;
                tempdelay2 = data(m + 1);
            elseif m ~= size(data,1)
                tempdelay2 = data(m + 1);
            end
            
            if size(data,1) == detik(1)
                continue
            elseif tempdelay1 > tempdelay2
                detik(m + 1, 1) = tempdelay1 - tempdelay2;
            elseif tempdelay1 < tempdelay2
                detik(m + 1, 1) = tempdelay2 - tempdelay1;
            end
            
            if m >= 2 && m <= size(data,1) - 1
                detik(m + 1, 1) = detik(m) + detik(m + 1);
            end
            
            
        end
        detik = round(detik);
        
        % Grouping
        alpha = 40;
        ke = 1;
        ne = 1;
        g = [];
        for l = 1 : size(detik,1);
            temp = detik(l);
            ne = 1;
            
            nilaid = round(max(detik) / alpha);
            if nilaid == 0
                nilaid = size(data,2);
            end
            
            for u = 1 : nilaid
                if temp <= u * alpha
                    g(l) = ke;
                    
                    break
                elseif temp >= u*alpha && temp <= (u + 1)*alpha
                    g(l) = ke + ne;
                    break
                end
                
                ne = ne + 1;
            end
        end
        
        out_folder = 'Tahap_1_Excel_PDP';
        if ~exist(out_folder, 'dir')
            mkdir(out_folder);
        end
        
        T = table(data(:,1), data(:,2), dnum', detik, g');
        T.Properties.VariableNames = {'DELAY' 'POWER' 'Numerik' 'OMNI' 'Grouping_index'};
        
        nama_data = sprintf('PDP_%d.xlsx', nomor);
        full_data = fullfile(out_folder, nama_data);
        writetable(T, full_data);
        
        fprintf('Proses data ke-%d \n', nomor);
        nomor = nomor + 1;
        pause(1);
    end
    fprintf('Proses selesai');
end