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

function wind_buf_out = OFB(param, filter)
 
buf_out = [];
h = {};
N = [];
sig_filt = {};

%input_string = [param.path_in param.wavname];
input_string = char(strcat(param.path_in,'\',param.wavname));   % MATLAB R2017a
input_sig = audioread(input_string);
 
if size(input_sig,2) > 1                                    % if .wav input file is stereo,
    input_sig = (input_sig(:,1) + input_sig(:,2)) ./ 2;     % a downmix from stereo to mono is made
end
 
fprintf('%s', '            LP Filtering and Decimation by 2: 0 %');
 
buf_out(1,:) = input_sig;
sig_filt{1} = input_sig;
length_sig = size(input_sig,1);
h{1} = 1;
 
for id = 2:param.num_ottave
    
    h{id} = conv(h{id-1},upsamp(filter,2^(id-2)));
    N(id) = length(h{id});
    sig_filt{id} = conv(upsamp(filter,2^(id-2)), sig_filt{id-1});
 
    buf_out(id,:) = sig_filt{id}((N(id)-1)/2 + 1 : (N(id)-1)/2 + length_sig);
    
    if id == 5 
        fprintf('\b\b\b%d', floor((2^id/511)*100)); fprintf('%s', ' %');
    elseif id > 5
        fprintf('\b\b\b\b%d', floor((2^id/511)*100)); fprintf('%s', ' %');
    end
 
end
 
wind_buf_out = windec2(buf_out, param.block_length);
 
fprintf('\b\b\b\b\b%s\n', 'Done !');
 
return