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

function [TF_det_on onset_ok] = onset_detect(TF, param)

TF = abs(TF);
TF_on = [];

[dim2 dim]= size(TF);
eps = 1e-3;             % for Kullback - Liebler Divergence

for n = 2:dim
    on = [];
    for k = 1:dim2
        on(k) = log(1 + (TF(k,n)/(TF(k,n-1) + eps)));
    end
    on_id = sum(on);
    if n ~= 2
        TF_on = [TF_on on_id];
    else
        TF_on = on_id;
    end
end

% if var(TF_on ./ max(TF_on)) > 2.5e-2
%     TF_det_on = smooth(TF_on,15,'lowess');
%     ampl_var = 1.075;
% else
%     TF_det_on = smooth(TF_on,5,'lowess');
%     ampl_var = 1.01;
% end

TF_det_on = smooth(TF_on,5,'lowess');
ampl_var = 1.01;

% [peaks ampl_p] = find_peaks(TF_det_on);
[ampl_p peaks] = findpeaks(TF_det_on);      % syntax for Matlab R2009a

func = 1 - TF_det_on ./ max(TF_det_on);
% [valley ampl_v] = find_peaks(func);
[ampl_v valley] = findpeaks(func);          % syntax for Matlab R2009a

onsets(1) = floor(peaks(1)/2);
onset_ok = onsets(1);

peaks = peaks(2:end);
valley = valley(2:end);
flag = 0;

for k = 1:length(peaks)-1
    
    if (peaks(k) - onset_ok(end-flag) > param.dt_coeff) && (TF_det_on(peaks(k)) / TF_det_on(valley(k)) > ampl_var)
        onset_ok = [onset_ok peaks(k)];
        flag = 0;
    elseif k == 1
        continue;
    else
        flag = min(flag + 1 , length(onset_ok)-1);
    end
    
end
onset_ok = [onset_ok peaks(end)];

return