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

function buf_out = windec2(buf, win_size)

sig_length = size(buf,2);
size_buf = size(buf,1);
n_frame = floor(sig_length / win_size);
centre_fr = floor(win_size/2);

buf_out = [];
wind_buf_out = cell(size_buf,n_frame);

for buf_row = 1:size_buf
    
    delta = 2^(buf_row-1);
    
    for nf =  centre_fr : win_size : n_frame*win_size-centre_fr
     
        id = ((nf - centre_fr)/win_size)+1;
        indici = nf - centre_fr*delta +1 : delta : nf - centre_fr*delta + win_size*delta;
        ind_neg = find(indici < 1);
        ind_pos = find(indici >= 1 & indici <= sig_length);
        ind_out = find(indici > sig_length);
        samples = [zeros(1,length(ind_neg)) buf(buf_row, indici(ind_pos)) zeros(1,length(ind_out))];
        wind_buf_out{buf_row,id} = samples;                             
        
    end
    
end

for i = 1:size_buf
    buf_out(i,:) = horzcat(wind_buf_out{i,:});
end

return