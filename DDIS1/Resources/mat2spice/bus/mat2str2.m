function str = mat2str2(mat)
%MAT2STR2 String representation of expression
%   Identical to MAT2STR, except that strings are returned without changes.

if ischar(mat)
    str = mat;
else
    str = mat2str(mat);
end
end