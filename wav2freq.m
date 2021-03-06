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

function [STFT En_TF note_axis onsets] = wav2freq(param)

% 
%	function [STFT En_TF spectra_rid en_fund note_axis on_vect onsets] = wav2freq(param)
%	
% 
%   param: program parameters
%
%   STFT: signal Time x Frequency representation
%   En_TF : 2D Correlation Matrix
%	note_axis: vector containing note frequency values
%   onsets: value of estimated onset times
%


% ---------- ----------- GLOBALS ----------- -----------
global sys_TIME;
global sys_MODULE;
global sys_MSG;										
global sys_LOG;

sys_TIME 	= cell(0,0);
sys_MODULE 	= cell(0,0);
sys_MSG 	= cell(0,0);
sys_LOG 	= cell(0,0);


% ---------- ----------- LOCALS ----------- -----------

warning('off','all');

band_num_oct = 10;
temp_semit_num = 12;

load('low_oct_freq');
low_note_freqs = [];

for k = 1:temp_semit_num
    low_note_freqs = [low_note_freqs low_oct(3*(k-1) + 2)];
end

dft_val = [];
note_axis = [];
for k = 1:param.num_ottave
    dft_val = [dft_val low_oct .* 2^(band_num_oct - (param.num_ottave - k + 2))];
    note_axis = [note_axis low_note_freqs .* 2^(band_num_oct - (param.num_ottave - k + 2))];
end
              
size_spect = length(note_axis);
h = load('FIR_filter');

% ---------- ----------- I N I T ----------- -----------

disp(' '); logappend('CQBisp Music Transcriptor','INIT');

% ---------- ----------- ####### ----------- -----------

sct = 0;                     % frame counter

disp(' ');

logappend('Octave Filter Bank','START');
    
buf_out = OFB(param, h.lp_filter);    % Octave Filter Bank (OFB)

No_FRAMES = ceil(size(buf_out,2)/param.block_length);

STFT        = [];
En_TF       = [];
en_fund     = cell(1,No_FRAMES);
spectra_rid = cell(size_spect,No_FRAMES);
bispectrum  = cell(size_spect,No_FRAMES);
P_comp      = cell(size_spect,No_FRAMES);
S_comp      = cell(size_spect,No_FRAMES);

fprintf('%s', '            Spectral and Bispectral Analysis (Ctrl+C to abort): 0 %');

while sct < No_FRAMES       % START PROCESSING
 
    if ~isempty(buf_out)
        
        sct = sct + 1;
        spectra = do_dft(buf_out(:,param.block_length*(sct-1)+1:param.block_length*sct), dft_val, param, 'h');
        
        if ~isempty(spectra)
           spectra_rid{sct} = reduction(spectra);
           bispectrum{sct} = bisp_ofb(spectra_rid{sct}, size_spect, param.num_ottave);
           [P_comp{sct} S_comp{sct}] = norm_bicoherence_comp(spectra_rid{sct});
           STFT = [STFT abs(spectra_rid{sct})'];
        end	
        
    end
    
    percent_prg = floor((sct/No_FRAMES)*100);
    if percent_prg < 10
        fprintf('\b\b\b%d', percent_prg); fprintf('%s', ' %');
    elseif percent_prg >= 10
        fprintf('\b\b\b\b%d', percent_prg); fprintf('%s', ' %');
    end
    
end

fprintf('\b\b\b\b\b%s\n', 'Done !');
logappend('Octave Filter Bank','END');
disp(' ');

STFT_mean = mean(mean(STFT));
STFT_max = max(max(STFT)); 
dec_rule_value = STFT_mean/STFT_max;

logappend('ONSET Estimation','START');
[on_vect onsets] = onset_detect(STFT, param);       % Onset Times Estimation
logappend('ONSET Estimation','END');
disp(' ');

logappend('F0 Estimation','START');
fprintf('%s', '            Multi-F0-Estimation frame by frame (Ctrl+C to abort): 0 %');

for id = 3:sct-2
    
    bisp = (bispectrum{id-2} + bispectrum{id-1} + bispectrum{id} + bispectrum{id+1} + bispectrum{id+2}) ./ 5;
    
    P = (P_comp{id-2} + P_comp{id-1} + P_comp{id} + P_comp{id+1} + P_comp{id+2}) ./ 5;
    S = (S_comp{id-2} + S_comp{id-1} + S_comp{id} + S_comp{id+1} + S_comp{id+2}) ./ 5;
    
    bi_coherence = abs(bisp).^2 ./ (P * P' .* S);

    if isempty(find(isnan(bi_coherence), 1))

        if dec_rule_value > 0.01
            estim_flag = 1;
        else
            estim_flag = 2;
        end

        en_fund{id} = Multif0_estim(abs(spectra_rid{id}), abs(bi_coherence), estim_flag);
        En_TF = [En_TF en_fund{id}'];
        
    else 
        
        en_fund{id} = zeros(1,size_spect);
        En_TF = [En_TF en_fund{id}'];
        
    end
    
    percent_prg = floor((id/No_FRAMES)*100);
    if percent_prg < 10
        fprintf('\b\b\b%d', percent_prg); fprintf('%s', ' %');
    elseif percent_prg >= 10
        fprintf('\b\b\b\b%d', percent_prg); fprintf('%s', ' %');
    end

end

En_TF = [zeros(size_spect,2) En_TF zeros(size_spect,2)];
En_TF = TF_clean(En_TF, 0, param.dt_coeff);

fprintf('\b\b\b\b\b%s\n', 'Done !');
logappend('F0 Estimation','END');
disp(' ');

return
