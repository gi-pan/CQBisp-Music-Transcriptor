%{
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
%}

function real_energy = Multif0_estim(spectra, Bisp, estim_flag)

len_spctr = length(spectra);
real_energy = zeros(1,len_spctr);
col_vect = {};
sub_bisp = {};

harm_pattern1D = [12 19 24 28 31];
nrg_patt = zeros(1,len_spctr);
nrg_patt_pk = zeros(1,len_spctr);
nrg_corr1 = zeros(1,len_spctr);
nrg_corr2 = zeros(1,len_spctr);
real_energy1 = zeros(1,len_spctr);
real_energy2 = zeros(1,len_spctr);
        
Bisp_peaks = ones .* imregionalmax(Bisp);

[id_row id_col] = find(Bisp ~= 0);
id_col = unique(id_col);

for i = 1:length(id_col)
    sub_bisp{i} = zeros(length(Bisp));
    sub_bisp_pk{i} = zeros(length(Bisp_peaks));
    xcorr_vect = [];
    col_vect{i} = id_col(i);
    difr = id_col - col_vect{i};
    add_col_id = find(ismember(difr,harm_pattern1D));
    if ~isempty(add_col_id)
        col_vect{i} = [col_vect{i} id_col(add_col_id)'];
    end
    for k = 1:length(col_vect{i})
        sub_bisp{i}(col_vect{i}(k) , col_vect{i}) = Bisp(col_vect{i}(k) , col_vect{i});
        sub_bisp_pk{i}(col_vect{i}(k) , col_vect{i}) = Bisp_peaks(col_vect{i}(k) , col_vect{i});
    end
end

    if ~isempty(col_vect)

        for i = 1:length(sub_bisp)

            nrg_spect(col_vect{i}(1)) = sum(spectra(col_vect{i}));
            nrg_patt(col_vect{i}(1)) = sum(sum(sub_bisp{i}));
            nrg_patt_pk(col_vect{i}(1)) = sum(sum(sub_bisp_pk{i}));
        end

        spec_max = zeros(1,length(spectra));
        spec_max(imregionalmax(spectra)) = spectra(imregionalmax(spectra));

        nrg_corr1 = nrg_patt .* nrg_patt_pk .* spec_max;
        nrg_corr2 = nrg_patt_pk .* spec_max;

        en_thres_corr1 = mean(nrg_corr1);
        en_thres_corr2 = 5*mean(nrg_corr2);

        if estim_flag == 0
            real_energy1(find(nrg_corr1 > en_thres_corr1)) = nrg_spect(find(nrg_corr1 > en_thres_corr1));
            real_energy2(find(nrg_corr2 > en_thres_corr2)) = nrg_spect(find(nrg_corr2 > en_thres_corr2));
        
            for o = 1:len_spctr
                real_energy(o) = max(real_energy1(o),real_energy2(o));
            end
        end
        
        if estim_flag == 1 
            real_energy(find(nrg_corr1 > en_thres_corr1)) = nrg_spect(find(nrg_corr1 > en_thres_corr1));
        elseif estim_flag == 2
            real_energy(find(nrg_corr2 > en_thres_corr2)) = nrg_spect(find(nrg_corr2 > en_thres_corr2));
        end 
        
    end  

return