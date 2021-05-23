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

function adj_mat = adjust(mat)

adj_mat = mat;

i = 1;

while i < size(adj_mat,1)
    if size(mat,2) > 3
        
        if (adj_mat(i,3) == adj_mat(i+1,3)) && (adj_mat(i,6) - adj_mat(i+1,5) >= 4*(220/44100))
            adj_mat(i,6) = adj_mat(i+1,6);
            adj_mat(i+1,:) = [];
        else
            i = i + 1;
        end
        
    else
        
        if fix(mat(i,1)) == mat(i,1)
            d_step = 4;
        else
            d_step = 4*(220/44100);
        end
        
        if (adj_mat(i,3) == adj_mat(i+1,3)) && (adj_mat(i,2) - adj_mat(i+1,1) >= d_step)
            adj_mat(i,2) = adj_mat(i+1,2);
            adj_mat(i+1,:) = [];
        else
            i = i + 1;
        end
        
    end
end

if size(mat,2) > 3
    adj_mat = sortrows(adj_mat,5);
else
    adj_mat = sortrows(adj_mat,1);
end

return