clear all;
close all;
clc;

for s = 1 : 1000
    baca = sprintf ('PDP_%i.xlsx',s);
    x = readtable(baca);
    
    %% Ambil nilai yang terkandung dalam grouping index dan disimpan di 
    % Variable NoGi
    NoGi = unique(x.Grouping_index);
    
    %% Lakukan looping untuk setiap nilai yang sudah didapatkan di var NoGi
    % (nomor Grouping Index)
    inc = 1;
    for m = 1 : length(NoGi)
        
        %% Cari nilai NoGi pada var x. 
        % Untuk memastikan ada berapa dan dimana posisi
        % nilai NoGi tersebut di dalam var x.
        cek = find(x.Grouping_index == NoGi(m));
        
        %% Lokasi sudah diketahui didalam var cek.
        % Ambil nilai posisi untuk mengambil nilai numerik
        Nilai_numerik = x.Numerik(cek);
        
        %% Lalu kita buat kondisi, dimana nilai lokasi lebih dari 1, maka nilai
        % dari numerik akan dijumlahkan terlebih dahulu sebelum dibagi
        % dengan nilai 40.
        banyak_data_cek = length(cek);
        if banyak_data_cek > 1
            Total_N_Numerik(inc, 1) = (sum(Nilai_numerik)/banyak_data_cek) / 40;
            Total_N_Numerik(inc + (banyak_data_cek - 1), 1) = 0;
            inc = inc + banyak_data_cek;
        else
            Total_N_Numerik(inc, 1) = Nilai_numerik / 40;
            inc = inc + 1;
        end
    end
    
    avg = array2table(Total_N_Numerik,'Variablenames',{'average'});
    tahap2 = [x avg];
    out_folder = 'Tahap_2_Representatif_PDP';
    
    if ~exist(out_folder, 'dir')
        mkdir(out_folder);
    end
    
    hasil = sprintf('PDP_%i.xlsx', s)
    writetable(tahap2,(fullfile('Tahap_2_Representatif_PDP',hasil)));
    
    clc
    clear
end