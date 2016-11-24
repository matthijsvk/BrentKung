function result = bus(name, varargin)
%BUS Inserts a bus of nodes into a Mat2spice netlist.
%   BUS(NAME, LIST_1, LIST_2, ...) creates a string of space-separated node
%   names consisting of the string given in NAME followed by an element of
%   LIST_1 between square brackets ('[' and ']'), then an element of LIST_2
%   between square brackets, etc.
%
%   LIST must be one of the following:
%   
%       - a numerical array, normally containing integers or fixed-point
%         decimal numbers.  Note that irrational, very large or very small
%         numbers will be rounded and displayed in exponential format (e.g.
%         '1.12255e+06' which may cause different numerical values to
%         result in the same string output.
%
%       - a logical array
%
%       - a cell array containing strings, numbers and/or logical values
%
%   Each element in LIST produces one node name.
%
%   Example:
%
%       bus('in', 0:5)
%
%   results in
%
%       in[0] in[1] in[2] in[3] in[4] in[5] 
%
%   while
%
%       bus('mybus', {'first', 'second', 3, 4, false})
%
%   results in
%
%       mybus[first] mybus[second] mybus[3] mybus[4] mybus[0]
%
%   If multiple arguments are used, BUS will iterate over all combinations
%   of elements from each of the arguments, and produce a node for each of
%   them, e.g.
%
%       bus('a', 0:3, 0:1)
%
%   results in
%
%       a[0][0] a[0][1] a[1][0] a[1][1] a[2][0] a[2][1] a[3][0] a[3][1]
%
%   After adding each node, BUS checks if the string is longer than 80
%   characters.  If so, the next node will be added on a new line, starting
%   with the Spice line continuation character ('+') and a space.  Thus,
%   every line is about 80 characters long, mostly somewhat longer since a
%   new line is started only after 80 characters have been exceeded.
%
%   Apart from improving readability in the output file, this is essential
%   for large buses since some simulators limit the maximum number of
%   characters on a line to e.g. 1024.
%
%   Example:
%
%       bus('test', 1:20)
%
%   results in
%
%       test[1] test[2] test[3] test[4] test[5] test[6] test[7] test[8] test[9] test[10] 
%       + test[11] test[12] test[13] test[14] test[15] test[16] test[17] test[18] test[19] 
%       + test[20] 
%
%   NOTE: Not all simulators support the use of square brackets in node
%   names.  However the code of this function can easily be altered to
%   produce another syntax like "test1" or "test_1" instead of "test[1]".
%   
%   Created Feb 3, 2010 by Pieter Nuyts
%   Documentation last updated July 26, 2010
%   Version 1.0
%
%   See also XBUS, MAT2SPICE

% CHANGELOG
% =========
% v1.0, 2010-02-03 -- First version
% ----, 2010-07-26 -- Improved documentation

indices = ones(1,length(varargin));
range = zeros(1,length(varargin));
for i=1:length(varargin)
    range(i) = length(varargin{i});
    if ischar(varargin{i})
        range(i) = 1;
    end
end

result = '';
resultline = '';

% Approximate text width.  Differs from standard wrapping width in that a
% new line is only started when the current line has TEXTWIDTH or more
% characters, so that almost every line will be slightly longer than 80
% instead of slightly shorter.  Also the first and last lines of the result
% may end up longer since the $<bus(...)>$ mat2spice command may not be
% alone on its line, so there may be more text before or after the
% approximately 80 characters.
% Set to Inf to disable wrapping.
textwidth = 80;
linecontchar = '+'; % Line continuation character

for i=1:prod(range)
    resultline = [resultline name]; %#ok<AGROW>
    for j=1:length(indices)
         set = varargin{j};
         if ischar(set)
             resultline = [resultline '[' set ']']; %#ok<AGROW>
         elseif iscell(set)
             resultline = [resultline '[' mat2str2(set{indices(j)}) ']']; %#ok<AGROW>
         else
             resultline = [resultline '[' mat2str2(set(indices(j))) ']']; %#ok<AGROW>
         end
    end
    indices(end) = indices(end)+1;
    for j=length(indices):-1:1
        if indices(j) > range(j)
            indices(j) = 1;
            if j ~= 1
                indices(j-1) = indices(j-1) + 1;
            else
                % Append last line to RESULT as well
                result = [result resultline]; %#ok<AGROW>
                
                % Now return
                return
            end
        end
    end
    
    if length(resultline) >= textwidth
        % Append current line to RESULT
        result = [result resultline sprintf('\n')]; %#ok<AGROW>
        
        % Empty RESULTLINE and start with a continuation character
        resultline = linecontchar;
    end
    resultline = [resultline ' ']; %#ok<AGROW>
end

% Append last line to RESULT as well
result = [result resultline];
