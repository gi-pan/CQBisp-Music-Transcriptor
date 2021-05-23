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

function spectra = do_dft(buf_out, faxis, param, opt)

spectra = [];
y = [];
f = sort(faxis,'descend');
guard_bins = 3;

for id = 1 : size(buf_out,1)

    Fc = param.fc / (2^(id - 1));
    sig = buf_out(id,:);
    n = length(sig);
    if opt == 'h'
        sig_w = sig .* param.win';
    elseif opt == 'r'
        sig_w = sig .* ramp_gen(param.block_length/2, param.block_length/2);  
    end
    sig_w = sig_w - mean(sig_w);
    t = (0:n-1) * 1/Fc;
    freq = f((id-1)*12*guard_bins+1 : id*12*guard_bins);
    freq = sort(freq);
    for j = 1:length(freq)
        y(j) = sum(sig_w.*exp(-1i*2*pi*freq(j)*t));
    end
    spectra = [y spectra];
    
end

spectra = spectra ./ sum(param.win);

return