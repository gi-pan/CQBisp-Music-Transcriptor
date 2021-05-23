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

function out_cell = f0_frame_by_frame (list, param, pat_out)

[dim_v dim_h] = size(list);
b_out_cell = {};
out_cell = {};

if ~isempty(list)
    lim = max(list(:,2));
else
    b_out_cell = [];
end

for i = 1:lim
     b_out_cell{i} = [];
end

for id = 1:dim_v
    for id2 = 1:list(id,2) - list(id,1) + 1
%         out_cell{list(id,1) + id2 - 1} = [out_cell{list(id,1) + id2}    list(id,3)];
        b_out_cell{list(id,1) + id2 - 1} = [b_out_cell{list(id,1) + id2 - 1}    list(id,3)];
    end
end
       
for n = 1:lim
    b_out_cell{n} = unique(b_out_cell{n});
end

len = size(b_out_cell,2);
v = (1:len).*(220/441);

count = 0;
o = 1;
while o < len
    count = count + 1;
    if mod(o,441) ~= 0
        out_cell{1,count} = union(b_out_cell{1,o},b_out_cell{1,o+1});
        o = o + 2;
    else
        out_cell{1,count} = union(b_out_cell{1,o} , union(b_out_cell{1,o+1},b_out_cell{1,o+2}));
        o = o + 3;
    end
end


% OUTPUT MULTIPLE F0-ESTIMATION (ON FRAME BASIS) FILE CREATION ---------------------

%str = [pat_out param.wavname '_F0_frame_by_frame.txt'];
str = char(strcat(pat_out, '\', param.wavname, '_F0_frame_by_frame.txt')); % MATLAB R2017a
fid = fopen(str, 'w', 'n');
fprintf(fid, datestr(now));
% fprintf(fid, '\r\n\r\nFRAME TIME\tACTIVE F0s\r\n\');
for l = 1:size(out_cell,2)
%    time_frame = param.dt * l;
   time_frame = 441/44100 * l;
   fprintf(fid, '\r\n%6.3f\t', time_frame);
   if ~isempty(out_cell{l})
       for m = 1:length(out_cell{l})
           fprintf(fid, '%6.3f\t', out_cell{l}(m));
       end
   end
end
fclose(fid);

% str = [pat_out param.wavname '_F0_frame_by_frameB.txt'];
% fid2 = fopen(str, 'w', 'n');
% fprintf(fid2, datestr(now));
% % fprintf(fid2, '\r\n\r\nFRAME TIME\tACTIVE F0s\r\n\');
% for l = 1:lim
%    time_frame = param.dt * l;
% %    time_frame = 441/44100 * l;
%    fprintf(fid2, '\r\n%6.3f\t', time_frame);
%    if ~isempty(b_out_cell{l})
%        for m = 1:length(b_out_cell{l})
%            fprintf(fid2, '%6.3f\t', b_out_cell{l}(m));
%        end
%    end
% end
% fclose(fid2);

% ----------------------------------------------------------------------------------

return