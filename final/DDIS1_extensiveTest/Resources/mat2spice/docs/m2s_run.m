function m2s = m2s_run(m2s);function m2s_outstr = m2s_arg2str(m2s_instr);m2s_outstr = m2s_instr;for m2s_I=1:length(m2s_instr);if isnumeric(m2s_instr{m2s_I});if length(m2s_instr{m2s_I})>1m2s_outstr{m2s_I} = mat2str(m2s_instr{m2s_I},8);m2s_outstr{m2s_I} = m2s_outstr{m2s_I}(2:end-1);else;m2s_outstr{m2s_I} = num2str(m2s_instr{m2s_I},8);end;elseif islogical(m2s_instr{m2s_I});m2s_outstr{m2s_I} = num2str(m2s_instr{m2s_I});end;end;end;function m2s_outstr=m2s_cell2str(m2s_instr);m2s_outstr=cell2mat(cellfun(@(m2s_x) [m2s_x sprintf('\n')],m2s_instr,'UniformOutput',0));m2s_outstr=m2s_outstr(1:end-1);end;function varargout = m2s_emptyfn(varargin);throwAsCaller(MException('M2S:FnErr','function called before it has been initialized with $include, $insert or $import'));end;sec=@m2s_emptyfn; m2s.mat2spice2.fn.sec = struct('ID',0,'inst',struct('outstr',{},'argvals',{}));subsec=@m2s_emptyfn; m2s.mat2spice2.fn.subsec = struct('ID',0,'inst',struct('outstr',{},'argvals',{}));subsubsec=@m2s_emptyfn; m2s.mat2spice2.fn.subsubsec = struct('ID',0,'inst',struct('outstr',{},'argvals',{}));createTOC=@m2s_emptyfn; m2s.toc.fn.createTOC = struct('ID',0,'inst',struct('outstr',{},'argvals',{}));addEntry=@m2s_emptyfn; m2s.toc_helper.fn.addEntry = struct('ID',0,'inst',struct('outstr',{},'argvals',{}));getTOC=@m2s_emptyfn; m2s.toc_helper.fn.getTOC = struct('ID',0,'inst',struct('outstr',{},'argvals',{}));
m2s_file_mat2spice2();
function m2s_file_mat2spice2(); m2s.mat2spice2.currentline = 0;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s.mat2spice2.currentline=m2s.mat2spice2.currentline+1;m2s.mat2spice2.outstr{m2s.mat2spice2.currentline}=sprintf(m2s_format,m2s_args{:});end;sec=@m2s_FN_sec;subsec=@m2s_FN_subsec;subsubsec=@m2s_FN_subsubsec;
%==================================================================================================
% File written by Pieter Nuyts (pieter.nuyts@esat.kuleuven.be, pieter.nuyts@ieee.org)
% 
% July 2010
%==================================================================================================
%
% Note: if you have only this file (i.e. the .m2html file and not the .html file):
% 
% 1) Open Matlab and make sure Mat2spice is on your path
% 2) cd to the directory where this file is
% 3) Enter
% 
%      >> mat2spice filename.m2html somedir
%    
%    replacing 'filename.m2html' with the name of this file and somedir with any directory
%    name (note that files may be produced or overwritten inside this directory).  If the
%    directory does not exist, it will be created.
%
% 4) A valid HTML file should have been generated at 'somedir/filename.html'.  Open it
%    with your web browser.
%
%==================================================================================================

%==================================================================================================
% HEADER FOR RESULTING HTML FILE
%==================================================================================================
m2s_write('<!--',{});
m2s_write('    This file was generated using MAT2SPICE v2.0, running on mat2spice2.m2html.',{});
m2s_write('    ',{});
m2s_write('    If you want to update this file, please try to find the source file mat2spice2.m2html, and the files it depends on, such as toc.m2s.  It will be less work to update these since the files contain functions and macros that automatically take care of a lot of linking, header formatting, and the table of contents.  Also it will keep the M2HTML file up to date so that people who will edit it after you can also use the M2HTML file.',{});
m2s_write('    ',{});
m2s_write('    After updating the M2HTML file, you can use MAT2SPICE to produce new HTML files.',{});
m2s_write('    ',{});
m2s_write('    Original source file was written by Pieter Nuyts',{});
m2s_write('    (pieter.nuyts@esat.kuleuven.be, pieter.nuyts@ieee.org)',{});
m2s_write('    ',{});
m2s_write('    Version 2.0.1, July 2010',{});
m2s_write('    ',{});
m2s_write('    (First two version numbers refer to Mat2spice version; third number is documentation version)',{});
m2s_write('-->',{});
%
%==================================================================================================
% INITIALISATION SECTION
%==================================================================================================
m2s_write('',{});
m2s_file_toc_helper();
m2s_write('',{});
   current_sec    = 'top';
   current_subsec = 'top';
m2s_write('',{});
m2s_write('$m2s_FN_instances mat2spice2 sec',{});function [out] = m2s_FN_sec(str,label);m2s_currentID=0; m2s_currentline = 0;function ID=m2s_getID;if ~m2s_currentID;m2s_currentID = find(cellfun(@(m2s_x) isequal(m2s_x,{str,label}),{m2s.mat2spice2.fn.sec.inst.argvals}));if isempty(m2s_currentID);m2s.mat2spice2.fn.sec.ID=m2s.mat2spice2.fn.sec.ID+1;m2s_currentID=m2s.mat2spice2.fn.sec.ID;m2s.mat2spice2.fn.sec.inst(m2s_currentID).argvals={str,label};end;end;ID=m2s_currentID;end;function str=m2s_generateInstName;str=sprintf('sec_%d',m2s_getID);end;function str=m2s_getParsedText;str=m2s_cell2str(m2s.mat2spice2.fn.sec.inst(m2s_getID).outstr);end;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s_currentline=m2s_currentline+1;m2s.mat2spice2.fn.sec.inst(m2s_getID).outstr{m2s_currentline}=sprintf(m2s_format,m2s_args{:});end;
       out = [' <h2><a href=#top name=' label '>' str '</a></h2> '];
       current_sec    = label;
       current_subsec = label;
       
       addEntry(0, str, label);
   end
m2s_write('',{});
m2s_write('$m2s_FN_instances mat2spice2 subsec',{});function [out] = m2s_FN_subsec(str,label);m2s_currentID=0; m2s_currentline = 0;function ID=m2s_getID;if ~m2s_currentID;m2s_currentID = find(cellfun(@(m2s_x) isequal(m2s_x,{str,label}),{m2s.mat2spice2.fn.subsec.inst.argvals}));if isempty(m2s_currentID);m2s.mat2spice2.fn.subsec.ID=m2s.mat2spice2.fn.subsec.ID+1;m2s_currentID=m2s.mat2spice2.fn.subsec.ID;m2s.mat2spice2.fn.subsec.inst(m2s_currentID).argvals={str,label};end;end;ID=m2s_currentID;end;function str=m2s_generateInstName;str=sprintf('subsec_%d',m2s_getID);end;function str=m2s_getParsedText;str=m2s_cell2str(m2s.mat2spice2.fn.subsec.inst(m2s_getID).outstr);end;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s_currentline=m2s_currentline+1;m2s.mat2spice2.fn.subsec.inst(m2s_getID).outstr{m2s_currentline}=sprintf(m2s_format,m2s_args{:});end;
       out = [' <h3><a href=#' current_sec ' name=' label '>' str '</a></h3> '];
       current_subsec = label;
       
       addEntry(1, str, label);
   end
m2s_write('',{});
m2s_write('$m2s_FN_instances mat2spice2 subsubsec',{});function [out] = m2s_FN_subsubsec(str,label);m2s_currentID=0; m2s_currentline = 0;function ID=m2s_getID;if ~m2s_currentID;m2s_currentID = find(cellfun(@(m2s_x) isequal(m2s_x,{str,label}),{m2s.mat2spice2.fn.subsubsec.inst.argvals}));if isempty(m2s_currentID);m2s.mat2spice2.fn.subsubsec.ID=m2s.mat2spice2.fn.subsubsec.ID+1;m2s_currentID=m2s.mat2spice2.fn.subsubsec.ID;m2s.mat2spice2.fn.subsubsec.inst(m2s_currentID).argvals={str,label};end;end;ID=m2s_currentID;end;function str=m2s_generateInstName;str=sprintf('subsubsec_%d',m2s_getID);end;function str=m2s_getParsedText;str=m2s_cell2str(m2s.mat2spice2.fn.subsubsec.inst(m2s_getID).outstr);end;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s_currentline=m2s_currentline+1;m2s.mat2spice2.fn.subsubsec.inst(m2s_getID).outstr{m2s_currentline}=sprintf(m2s_format,m2s_args{:});end;
       out = [' <h4><a href=#' current_subsec ' name=' label '>' str '</a></h4> '];
       
       addEntry(2, str, label);
   end
m2s_write('',{});

    % Include piece of code within a line of text
    code = @(str) ['<code>' str '</code>'];
    
    % Include block of code (cell array with 1 element per line of code)
    pre  = @(arr) [sprintf('\n<pre>\n') sprintf('%s\n', arr{:}) sprintf('</pre>\n')];
    
    % Shortcuts
    mat2spice   = code('mat2spice');
    dollar      = code('$');
    percent     = code('%');
    mcomment    = code('$%');
    oinl        = code('$&lt;'); % Open inline expression
    cinl        = code('&gt;$'); % Close inline expression
    oic         = '$&lt;';
    cic         = '&gt;$';
    oblock      = code('${'); % Open Matlab block
    cblock      = code('}$'); % Close Matlab block
    obus        = code('$['); % Open short bus block
    ctbus       = code(']['); % Continue short bus block
    cbus        = code(']');  % Close short bus block


m2s_write('',{});
%==================================================================================================
% START OF MAT2HTML CODE
%==================================================================================================
m2s_write('',{});
m2s_write('<html>',{});
m2s_write('<head>',{});
m2s_write('',{});
m2s_write('<title>Mat2spice version 2 documentation</title>',{});
m2s_write('',{});
m2s_write('</head>',{});
m2s_write('<body>',{});
m2s_write('',{});
m2s_write('<a name=top />',{});
m2s_write('',{});
m2s_write('<h1>Mat2spice version 2 documentation</h1>',{});
m2s_write('',{});
m2s_write('<p>The %s function preprocesses text files in which Matlab code is added to generate part of the text or code.  While intended primarily for preprocessing Spice and Spectre netlists, it can be used to generate any type of code.  It was e.g. used to generate part of the HTML code for this documentation.',{mat2spice});
m2s_write('',{});
m2s_write('<P>This document explains how to use %s.  It assumes the reader has good knowledge of the Matlab programming language.  Although most examples use Spice as the target language, knowledge of Spice is not really needed to understand this document, since from a preprocessor point of view, the Spice code is just text that needs to be processed, regardless of what it means.',{mat2spice});
m2s_write('',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('How to navigate through this document', 'navigation')});
m2s_write('',{});
m2s_write('<P>Clicking the title of a section brings you back to the top of the document.  Clicking the title of a subsection brings you back to the top of the section, etc.',{});
m2s_write('',{});
m2s_write('<P>You can use the table of contents below to go to the desired section.',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Table of contents', 'toc')});
m2s_write('',{});
m2s_file_toc(); m2s_write(m2s.toc.outstr,{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('General description', 'general_description')});
m2s_write('',{});
m2s_write('<P>The %s function is a code preprocessor.  An input file consists of any kind of code or ASCII text, in which Matlab commands and expressions occur, marked by escape characters.  Several types of escaped Matlab code can occur.  All escape sequences are based on the dollar sign (%s).',{mat2spice,dollar});
m2s_write('',{});
m2s_write('<P>%s will create an output file in which the code from the input file is copied literally, except for any escaped Matlab code, which will be processed as described <a href=#basic_escaped_sequences>below</a>.',{mat2spice});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Calling syntax', 'calling_syntax')});
m2s_write('',{});
m2s_write('<P> %s is a Matlab function and can thus be called from the Matlab command line or from another Matlab function or script.  It is called using the syntax',{mat2spice});

    arr = {
        'mat2spice(inputfile, outputpath, ...)'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('<P> %s is a %s input file (see below for the syntax of such a file).  Its extension must start with %s and add at least one letter.  The file may be specified as an absolute path, or relative to the current directory. ',{code('inputfile'),mat2spice,code('.m2')});
m2s_write('',{});
m2s_write('<P> %s is the directory where the resulting output file will be generated.  This may also be either an absolute path or relative to the current directory.  If the output directory does not exist yet, it will be created.  If it does exist, files in it might be overwritten.  This is typically the',{code('outputpath')});
m2s_write('desired behaviour if the directory was created by a previous run of %s, but using a directory',{mat2spice});
m2s_write('that also contains some non-autogenerated files is not a good idea.',{});
m2s_write('',{});
m2s_write('<P>The main output file will have the same name as the input file, but with the %s removed from the extension.  For example, if the input is called %s, then the output file will be called %s.  There is one exception: if the extension is %s (which stands for %s), the output file''s extension will be %s.',{code('m2'),code('system.m2scs'),code('system.scs'),code('.m2s'),mat2spice,code('.sp')});
m2s_write('',{});
m2s_write('<P>The input file may include other %s input files (i.e. also with an extension starting with %s), which will also be processed.  Depending on which include directive is used (see <a href=#include_insert_import>below</a>), they may produce separate output files, which will normally be in some subdirectory of the output directory (although this is not guaranteed, see <a href=#include_second_argument>here</a> for more info on the second argument to the include directives).',{mat2spice,code('.m2')});
m2s_write('',{});
m2s_write('<P>The input arguments %s and %s are mandatory.  After these two arguments, zero or more additional input arguments may be given.  These will be explained <a href=#global_parameters>later</a>. ',{code('inputfile'),code('outputpath')});
m2s_write('',{});
m2s_write('<P> %s does not return any output arguments.',{mat2spice});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Basic types of escaped Matlab sequences', 'basic_escaped_sequences')});
m2s_write('',{});
m2s_write('%s',{subsec('Inline Matlab expression', 'inline_matlab_expression')});
m2s_write('',{});
m2s_write('<P>Inline Matlab expressions enclosed between %s and %s can occur anywhere in the code.  %s will evaluate the expression and put the result where the escaped expression was.',{oinl,cinl,mat2spice});
m2s_write('',{});
m2s_write('For example, the code',{});
m2s_write('',{});

    arr = {
        '* Number of bits'
        '.param nbits = $&lt;2^5&gt;$'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('will be expanded to',{});
m2s_write('',{});

    arr = {
        '* Number of bits'
        '.param nbits = 32'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('The result of the expression may be any kind of number, logical, or array (in which case it will be converted to a string in some way) or it may be a string (in which case it will just be used as it is).',{});
m2s_write('',{});
m2s_write('%s',{subsec('Single Matlab line', 'single_matlab_line')});
m2s_write('',{});
m2s_write('<P>A line that starts with a %s sign is interpreted as a full Matlab command line (except if the %s sign is followed by %s, which denotes an <a href=#inline_matlab_expression>inline Matlab expression</a>).  The whole line, without the %s, is executed like a normal Matlab line.  It does not produce any text in the output file.  If the Matlab command would normally print anything in the command window, this will still go to the command window, not to your output file.',{dollar,dollar,code('&lt;'),dollar});
m2s_write('',{});
m2s_write('For example,',{});

    arr = {
        '* The line below will not show up in the output'
        '$ nbits = 2^5;'
        '* but it WILL have an effect'
        ''
        '* Number of bits'
        '.param nbits = $&lt;nbits&gt;$'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('will be expanded to',{});

    arr = {
        '* The line below will not show up in the output'
        '* but it WILL have an effect'
        ''
        '* Number of bits'
        '.param nbits = 32'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('<P>If you would forget the semicolon after %s, you would get the output',{code('nbits = 2^5')});

    arr = {
        ''
        'nbits ='
        ''
        '    32'
        ''
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('in your Matlab terminal, but the output file would still be unchanged.  Note that there is no link whatsoever between the Spice parameter %s and the Matlab variable with the same name.  For Matlab, the Spice parameter %s is just a part of a string.',{code('nbits'),code('nbits')});
m2s_write('',{});
m2s_write('<P><i>Note that the %s sign must really be the first character on the input line; any whitespace before it is not allowed.</i> After the %s sign, any number of whitespaces (including 0) is allowed.',{dollar,dollar});
m2s_write('',{});
m2s_write('%s',{subsec('Matlab comment line', 'matlab_comment_line')});
m2s_write('',{});
m2s_write('<P>A special case of a single Matlab line is a Matlab comment line, which starts with %s (Spaces between the %s and the %s sign are allowed).  Such a line is executed without the %s, and since it then starts with a %s, it is ignored.',{mcomment,dollar,percent,dollar,percent});
m2s_write('',{});
m2s_write('<P>E.g., resuming the previous example, if the code had been',{});

    arr = {
        '$% The line below will not show up in the output'
        '$ nbits = 2^5;'
        '$% but it WILL have an effect'
        ''
        '* Number of bits'
        '.param nbits = $&lt;nbits&gt;$'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('the output would have been',{});

    arr = {
        ''
        '* Number of bits'
        '.param nbits = 32'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('i.e. the comment lines would no longer appear in the output file.  Since in the previous example, the line was a Spice comment line, this would not affect the actual Spice simulation, but it may be cleaner to use %s comments for comments that only make sense with the Matlab code present, and that are not useful in the Spice code.',{mcomment});
m2s_write('',{});
m2s_write('<P> Furthermore, note that if the Spice comment contains a %s sign, Matlab will consider it as an escape sign and try to expand it.  This may be the desired behaviour, but if it is not, it can be avoided by using a %s comment.',{dollar,mcomment});
m2s_write('',{});
m2s_write('%s',{subsec('Inline Matlab expression: short syntax', 'inline_matlab_expression_short_syntax')});
m2s_write('',{});
m2s_write('<P>A shorter syntax exists for inline Matlab expressions: it consists of a %s sign followed by an expression that does not contain any whitespace.  Although it is most suitable for single-variable expressions (e.g. instead of %s, you could as well write %s) or function calls (such as %s), it can be used for any expression as long as it does not contain any whitespace.  For example, %s is equivalent to %s.',{dollar,code([oic 'nbits' cic]),code('$nbits'),code('$abs(i)'),code('$-2*max(a,b)'),code([oic '-2*max(a,b)' cic])});
m2s_write('',{});
m2s_write('<P>Even though this syntax is convenient for very short expressions, it has to be used with care:',{});
m2s_write('<ul>',{});
m2s_write('    <li><b>No</b> whitespace at all is allowed within the expression, even if it is between brackets or within a string.  For example, %s is correct code and is equivalent to %s, but in %s, the expression will end at the whitespace and the code will be equivalent to %s.  This will produce an error since %s is not a valid Matlab expression.',{code('$max(a,b)'),code([oic 'max(a,b)' cic]),code('$max(a, b)'),code([oic 'max(a,' cic ' b)']),code('max(a,')});
m2s_write('    ',{});
m2s_write('    <li>The expression is delimited <B>only</B> by whitespace or a newline character, not by any symbols or special characters.  For example, if %s is equal to 5, then',{code('a')});

    arr = {
        '.param nbits = $a'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    will be expanded to',{});

    arr = {
        '.param nbits = 5'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    as expected.  However, the code',{});

    arr = {
        '.param nbits = ''3*$a'''
    };

m2s_write('%s',{pre(arr)});
m2s_write('    will be expanded to',{});

    arr = {
        '.param nbits = ''3*5'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    i.e., the final quote will be missing.  This is because the evaluated Matlab expression is not %s but %s, which is the complex-conjugate transpose of the matrix [3] and thus evaluates to 3.  This can be solved by writing either ',{code('3'),code('3''')});

    arr = {
        '.param nbits = ''3*$&lt;a&gt;$'''
    };

m2s_write('%s',{pre(arr)});
m2s_write('    or',{});

    arr = {
        '.param nbits = ''3*$a '''
    };

m2s_write('%s',{pre(arr)});
m2s_write('    ',{});
m2s_write('    <li>This syntax cannot be used at the very beginning of a line, since in this case, the %s sign will be interpreted as the beginning of a Matlab line (as described <a href=#single_matlab_line>above</a>).  Thus, the code ',{dollar});

    arr = {
        '$ string = ''test'';'
        ' $string'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    (i.e. with a space before the second %s sign) will be expanded to',{dollar});

    arr = {
        ' test'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    whereas the code',{});

    arr = {
        '$ string = ''test'';'
        '$string'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    will not produce any text in the output file but it will print',{});

    arr = {
        ''
        'string ='
        ''
        'test'
        ''
    };

m2s_write('%s',{pre(arr)});
m2s_write('    in the Matlab terminal.',{});
m2s_write('    ',{});
m2s_write('    <li>It is also not possible to use this syntax if the character immediately after the %s sign is a %s or %s, since %s and %s start different types of escape sequences, as described in the following sections.',{dollar,code('{'),code('['),oblock,obus});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('In case of problems, a safe solution is to use the syntax with %s and %s as delimiters.',{oinl,cinl});
m2s_write('',{});
m2s_write('%s',{subsec('Matlab code block', 'matlab_code_block')});
m2s_write('',{});
m2s_write('<P>A Matlab code block is delimited by %s and %s.  Each of these markers must be on a single line and cannot have any text before or after them, and no whitespace is allowed before the %s sign or between the %s sign and the brace.  All lines between them are interpreted as Matlab lines.  They will be executed but they will not produce any text in the output file.',{oblock,cblock,dollar,dollar});
m2s_write('  ',{});
m2s_write('<P>This is a more convenient alternative for the single Matlab line syntax (lines starting with %s) in case you need a lot of subsequent Matlab lines.',{dollar});
m2s_write('',{});
m2s_write('<P>For example, the code',{});

    arr = {
        '${'
        '    % This is Matlab code'
        '    a = 3;'
        '    b = 5;'
        '    d = a + 2*b;'
        '}$'
    };

m2s_write('%s',{pre(arr)});
m2s_write('is equivalent to',{});

    arr = {
        '$ % This is Matlab code'
        '$ a = 3;'
        '$ b = 5;'
        '$ d = a + 2*b;'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('%s',{subsec(['The ' code('bus') ' function and the short bus notation'], 'bus')});
m2s_write('%s',{subsubsec(['The ' code('bus') ' function'], 'bus_function')});
m2s_write('',{});
m2s_write('<P>Large electronic circuits, especially digital ones, often include multibit buses, which have to be represented as separate nodes in Spice or Spectre.  In order to facilitate using buses, %s supports the use of a %s function.',{mat2spice,code('bus')});
m2s_write('',{});
m2s_write('<P>Several implementations of such a function are possible, so you have to check the documentation of the %s function you use (or write one yourself), but the functionality should normally be something like this: The function''s first argument is the name of the bus, and the next arguments are indices that specify which nodes should be created.  The function will then return a string containing all the generated nodes, separated by spaces.',{code('bus')});
m2s_write('',{});
m2s_write('<P>For example, the call',{});
m2s_write('%s',{pre({'bus(''in'', 0:5)'})});
m2s_write('might return',{});
m2s_write('%s',{pre({'in0 in1 in2 in3 in4 in5'})});
m2s_write('or',{});
m2s_write('%s',{pre({'in_0 in_1 in_2 in_3 in_4 in_5'})});
m2s_write('or',{});
m2s_write('%s',{pre({'in[0] in[1] in[2] in[3] in[4] in[5]'})});
m2s_write('or something similar, depending on which syntax you prefer and which syntax your simulator supports (e.g. the %s syntax may not be supported by all simulators).',{code('[]')});
m2s_write('',{});
m2s_write('<P>You may also want your %s function to support multi-dimensional buses, e.g.',{code('bus')});
m2s_write('%s',{pre({'bus(''in'', 0:5, 0:2)'})});
m2s_write('might return',{});

    arr = {
        'in[0][0] in[0][1] in[0][2] in[1][0] in[1][1] in[1][2] in[2][0] in[2][1] in[2][2]'
        '+ in[3][0] in[3][1] in[3][2] in[4][0] in[4][1] in[4][2] in[5][0] in[5][1] in[5][2]'
    };

m2s_write('%s',{pre(arr)});
m2s_write('(Note that the %s function used here has a special feature that breaks a line if it becomes to long.  Apart from producing more readable Spice code, this may also be necessary because some simulators limit the maximum length of a line to e.g. 1024 characters).',{code('bus')});
m2s_write('',{});
m2s_write('<P>It may even be useful to support also string arguments, which could be passed e.g. in cell arrays: the code ',{});
m2s_write('%s',{pre({'bus(''in'', {'''', ''bar''}, 0:2)'})});
m2s_write('might return',{});
m2s_write('%s',{pre({'in0 in1 in2 inbar0 inbar1 inbar2'})});
m2s_write('',{});
m2s_write('%s',{subsubsec('The short bus notation', 'short_bus_notation')});
m2s_write('',{});
m2s_write('<P>%s provides a short notation for the %s function.  In order for this to work, the function must be called %s and be in a file called %s.  This file must be somewhere in your Matlab path.',{mat2spice,code('bus'),code('bus'),code('bus.m')});
m2s_write('',{});
m2s_write('<P>The short bus syntax looks like this:',{});
m2s_write('%s',{pre({['in$' '[0:5][0:2]']})});
m2s_write('No spaces are allowed before the %s sign, between the %s and the first %s, or between the first %s and the second %s.  The word before the %s sign (i.e. starting from the last whitespace character or otherwise the beginning of the line) is considered to be the bus name (i.e. the first argument to %s).  Whatever is between a pair of square brackets is considered to be one of the following arguments, including the square brackets themselves (this usually does not make a difference).  Thus, the above code is equivalent to',{dollar,dollar,code('['),code(']'),code('['),dollar,code('bus')});
m2s_write('%s',{pre({[oic 'bus(''in'', [0:5], [0:2])' cic]})});
m2s_write('',{});
m2s_write('<P>%s does not impose any restrictions on the types of the arguments (they may be numbers, arrays, strings, cell arrays, objects, etc., and different arguments may have different types), nor on the number of arguments (you can add as many %s pairs as you want). It will just pass on all arguments to the %s function.  However, the %s function you use might not support all types or numbers of arguments.',{mat2spice,code('[]'),code('bus'),code('bus')});
m2s_write('',{});
m2s_write('<P>Note that a remark similar to the one made for the <a href=#inline_matlab_expression_short_syntax>short inline expression syntax</a> can be made here: The bus name is delimited on the left side <B>only</B> by whitespace, not by any other symbols.  This is normally not really a problem since node names are typically surrounded by spaces. ',{});
m2s_write('',{});
m2s_write('%s',{subsec(['Escaping the ' dollar ' sign'], 'escaping_dollar_sign')});
m2s_write('',{});
m2s_write('The dollar sign (%s) can be escaped as %s.  However, the double %s sign that occurs when two inline expressions occur directly next to each other (such as %s) will not be changed to one %s sign.',{dollar,code(['$' '$']),dollar,code([oic 'a' cic oic 'b' cic]),dollar});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('How it works', 'how_it_works')});
m2s_write('',{});
m2s_write('<P>While all the above features can perfectly be used without knowing how %s works, for some of the more complex features, as well as for debugging, it may be practical to have some understanding of how it works.  This section is not intended to give a detailed and exact overview of the implementation of %s; it only tries to give some basic understanding.',{mat2spice,mat2spice});
m2s_write('',{});
m2s_write('<P>The preprocessor basically works as follows:  It runs over the code and converts it to a Matlab file called %s (it will normally be in the directory where the input file is).',{code('m2s_run.m')});
m2s_write('',{});
m2s_write('<P>All Matlab lines and Matlab code blocks are simply copied into this Matlab-file (without the %s, %s and %s delimiters of course).',{dollar,oblock,cblock});
m2s_write('',{});
m2s_write('<P>All lines without any Matlab code are turned into calls to a Matlab function named %s with the original code line as a string argument.  The function %s basically writes its argument to a line in the output file.',{code('m2s_write'),code('m2s_write')});
m2s_write('',{});
m2s_write('<P>Lines with inline Matlab expressions are treated the same way, except that the inline expressions are first evaluated, converted to strings, and put at the right place in the string to be written.',{});
m2s_write('',{});
m2s_write('<P>The result of this preprocessing is an executable M-file which contains',{});
m2s_write('<ul>',{});
m2s_write('    <li>function calls to %s,',{code('m2s_write')});
m2s_write('    <li>other Matlab statements resulting from Matlab lines or code blocks,',{});
m2s_write('    <li>some other things such as function definitions, which serve to implement functionality that will be described later on.',{});
m2s_write('</ul>',{});
m2s_write('%s then executes this M-file which produces the output file(s).',{mat2spice});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Conditional and loop constructs', 'conditional_and_loop_constructs')});
m2s_write('',{});
m2s_write('<P>Most of the power of basic %s code is in the fact that it allows conditional and loop constructs to be used.  ',{mat2spice});
m2s_write('',{});
m2s_write('For example, you can write',{});

    arr = {
        '$ if include_parasitics'
        'Cpar in gnd 1f'
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('In this case, the %s call (see <a href=#how_it_works>above</a> for more information on %s) that will write the line %s will be between the %s and %s statements and thus the line will appear in the output file only if the Matlab variable %s is true.  ',{code('m2s_write'),code('m2s_write'),code('Cpar in gnd 1f'),code('if'),code('end'),code('include_parasitics')});
m2s_write('',{});
m2s_write('<P>It is also possible to include Matlab lines within the %s clause, which will also  be executed only if the condition is true.',{code('if')});
m2s_write('',{});
m2s_write('<P>Clearly, the %s statement can also be complemented with %s and/or %s statements.',{code('if'),code('elseif'),code('else')});
m2s_write('',{});
m2s_write('<P>Switch statements can also be used: the following code selects whether an inverter, a NAND gate or a NOR gate should be used as an inverter, based on the Matlab variable %s:',{code('invtype')});

    arr = {
        '$ switch invtype'
        '$  case ''inv'''
        'Xinv in out vdd vss inv'
        '$  case ''nand'''
        'Xinv in in out vdd vss nand'
        '$  case ''nor'''
        'Xinv in in out vdd vss nor'
        '$  otherwise'
        '$      error(''Invalid inverter type: %s'', invtype);'
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('<P>You can also use %s and %s loops.  For example, the code',{code('for'),code('while')});

    arr = {
        '$ for i = 0:3'
        'Xinv_$i node_$i node_$i+1 vdd vss inv size=$<4^i>$'
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('will produce',{});

    arr = {
        'Xinv_0 node_0 node_1 vdd vss inv size=1'
        'Xinv_1 node_1 node_2 vdd vss inv size=4'
        'Xinv_2 node_2 node_3 vdd vss inv size=16'
        'Xinv_3 node_3 node_4 vdd vss inv size=64'
    };

m2s_write('%s',{pre(arr)});
m2s_write('which is a very powerful way to generate the large regular structures that are often used in digital hardware.',{});
m2s_write('',{});
m2s_write('<P>Note that in most cases it is probably best to combine the use of %s loops with the %s function, which is described <a href=#bus>here</a>.  This means it is better to write',{code('for'),code('bus')});

    arr = {
        '$ for i = 0:3'
        'Xinv$[i] node$[i] node$[i+1] vdd vss inv size=$<4^i>$'
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('instead of the code shown above.  Even though the %s function produces only one node here, this ensures the names of the node are always compatible with names generated with the %s function.  For example, it is very likely that the nodes %s through %s will be referenced somewhere using the bus function, i.e. as %s.  If the %s function uses the underscore syntax, both fragments will work, but if you change the %s function to use e.g. the square bracket syntax, the upper code fragment will no longer work, while the lower one still will.',{code('bus'),code('bus'),code('node_0'),code('node_4'),code(['node$' '[0:4]']),code('bus'),code('bus')});
m2s_write(' ',{});
m2s_write('<P> In examples in the remaining part of this text, the %s function will be assumed to use the underscore syntax, i.e. %s will produce %s. ',{code('bus'),code(['a$' '[2][3]']),code('a_2_3')});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec([code('$include') ', ' code('$insert') ' and ' code('$import')], 'include_insert_import')});
m2s_write('',{});
m2s_write('<P>Three keywords exist for including other input files: %s, %s and %s.  All of these will be referenced here as "include directives".  They all take a filename as argument and cause this file to be processed by %s as well.',{code('$include'),code('$insert'),code('$import'),mat2spice});
m2s_write('',{});
m2s_write('<P>All included files must have an extension starting with %s, and if they produce an output file (this is the case if the %s directive is used) it will have the same name and another extension, in the same way as for the general input file (see <a href=#calling_syntax>above</a>).  If no extension is specified, %s will add the default extension %s.  (Note that if you have no extension but the filename contains a period for some reason, everything starting from the last period will be considered to be the extension).',{code('.m2'),code('$include'),mat2spice,code('.m2s')});
m2s_write('',{});
m2s_write('<P>An include directive should look like this:',{});

    arr = {
        '$include path/to/some/file.m2something second/argument'
    };

m2s_write('%s',{pre(arr)});
m2s_write('with no space before or after the %s sign (the %s must be the first character of the line), and similar for %s and %s.  More information about the second argument is given below.',{dollar,dollar,code('$insert'),code('$import')});
m2s_write('',{});
m2s_write('<P>The file is specified as a path relative to the file where the include directive is.  In the remainder of this section, the file where the include directive is will be called the "parent file", and the file given as the argument will be called the "child file".  The %s input files will then be called "parent input file" and "child input file" and the output files will be called "parent output file" and "child output file" (the latter does not always exist).',{mat2spice});
m2s_write('',{});
m2s_write('<P>Each file should be included or imported only once.  It is not allowed to include or import a file several times, even with different include directives (%s and %s) and/or from different parent files.',{code('$include'),code('$import')});
m2s_write('',{});
m2s_write('<P>It is not possible to conditionally include or import a file, e.g. from inside an %s block.  This is because %s first scans the whole file for include directives, and only afterwards processes the rest of the file.',{code('if'),mat2spice});
m2s_write('',{});
m2s_write('<P>However, it is allowed to use the %s directive several times, as well as inside conditional statements.  See <a href=#insert>below</a> for more information. ',{code('$insert')});
m2s_write('',{});
m2s_write('%s',{subsec(['The ' code('$include') ' directive'], 'include')});
m2s_write('',{});
m2s_write('<P>The %s directive processes the child input file and writes the resulting output to a separate file (the child output file).  In the parent output file, %s will put an appropriate include statement to include the child output file.  If the parent file is a Spice file, this will be a %s statement, unless the child file is a Spice VEC file.  In this case it will be a %s statement.  If the parent file is a Spectre file, an %s statement will be produced.',{code('$include'),mat2spice,code('.include'),code('.vec'),code('include')});
m2s_write('',{});
m2s_write('<P>The type of an input file is determined as follows:',{});
m2s_write('<ul>',{});
m2s_write('    <li>Files ending in %s, %s or %s are considered to be Spice files.',{code('.m2s'),code('.m2cir'),code('.m2tit')});
m2s_write('    <li>Files ending in %s are considered to be Spectre files.',{code('.m2scs')});
m2s_write('    <li>Files ending in %s are considered to be Spice VEC files.',{code('.m2vec')});
m2s_write('    <li>Files ending in %s are considered to be MDL files.  ',{code('.m2mdl')});
m2s_write('    <li>All other files are considered to be "unknown" files. ',{});
m2s_write('</ul>',{});
m2s_write('Currently, unknown and MDL files are treated in exactly the same way as Spice files.',{});
m2s_write('',{});
m2s_write('<P><a name=include_second_argument />By default, %s will put the child output file at the same place relative to the parent output file as the child input file is relative to the parent input file.',{mat2spice});
m2s_write('',{});
m2s_write('<P>For example, if the parent input file is %s and the parent output file is %s and the parent input file contains the directive',{code('~/m2s/parent.m2s'),code('~/m2s/output/parent.sp'),});
m2s_write('%s',{pre({'$include subdir/child.m2s'})});
m2s_write('then this means the child input file should be %s and the child output file will be %s.',{code('~/m2s/subdir/child.m2s'),code('~/m2s/output/subdir/child.m2s')});
m2s_write('',{});
m2s_write('<P>While this is mostly convenient, it may be quite annoying if the relative path contains ".." one or more times:  Suppose the directive was',{});
m2s_write('%s',{pre({'$include ../some_far_away_library/child.m2s'})});
m2s_write('then the child input file should be %s, which is equal to %s.  The child output file will now be %s, which is equal to %s, so it is not in the output directory, which is mostly not desired.',{code('~/m2s/../some_far_away_library/child.m2s'),code('~/some_far_away_library/child.m2s'),code('~/m2s/output/../some_far_away_library/child.m2s'),code('~/m2s/some_far_away_library/child.m2s')});
m2s_write('',{});
m2s_write('<P>This can be solved using the second argument to %s.  This argument specifies a path for the child output file, relative to the parent output file.  Thus, by writing',{code('$include')});
m2s_write('%s',{pre({'$include ../some_far_away_library/child.m2s library'})});
m2s_write('the child output file will be %s.  Any files included from the child input file will then use the directory %s as the starting point for their relative paths.',{code('~/m2s/output/library/child.m2s'),code('~/m2s/output/library/')});
m2s_write('',{});
m2s_write('%s',{subsec(['The ' code('$insert') ' directive'], 'insert')});
m2s_write('',{});
m2s_write('<P>The %s directive also processes the child input file, but does not create a separate output file.  Instead, all output from the child input file is inserted in the parent output file, at the point where the %s directive was given.',{code('$insert'),code('$insert')});
m2s_write('',{});
m2s_write('<P>If the %s directive appears several times with the same filename, the <i>complete</i> output from this file will be inserted at all the points where the %s directive appears.  This should only be done if the inserted file does not contain functions; if it does, inserting it several times would insert <i>all</i> of the generated subcircuits <i>every time,</i> which would result in Spice errors because several subcircuits with the same name are declared.',{code('$insert'),code('$insert')});
m2s_write('',{});
m2s_write('<P>Note that the output for the inserted file is re-generated everytime a %s directive for the file is encountered.  If a global variable changes before the next %s directive is encountered, the next %s directive may produce different output.  Functions may exhibit unexpected behavior in such case, which is another reason not to use them with multiple %s directives.',{code('$insert'),code('$insert'),code('$insert'),code('$insert')});
m2s_write('',{});
m2s_write('<P>Even though there is no child output file, the %s directive does support the second argument.  This will only be used in case the child input file itself contains some %s statement.  Then the second argument will be used as a starting point for the resulting output file.',{code('$insert'),code('$include')});
m2s_write(' ',{});
m2s_write('%s',{subsec(['The ' code('$import') ' directive'], 'import')});
m2s_write('',{});
m2s_write('<P>The %s directive also processes the child input file, but the output is not written to any file; it is just discarded.  Therefore, %s the import directive is only useful in combination with <a href=#functions>functions</a> using the <a href=#m2s_getParsedText>%s</a> helper function.  It also supports the second argument for the same reason mentioned above.',{code('$import'),code('$import'),code('m2s_getParsedText')});
m2s_write('',{});
m2s_write('%s',{subsec('Summary', 'include_insert_import_summary')});
m2s_write('',{});
m2s_write('<P>A file can be included in one of the following ways:',{});
m2s_write('<ol>',{});
m2s_write('    <li>It can be included <I>once</I> and <I>unconditionally</I> using the %s directive.',{code('$include')});
m2s_write('    <li>It can be included <I>once</I> and <I>unconditionally</I> using the %s directive.',{code('$import')});
m2s_write('    <li>If it contains functions, it can be included <I>once</I> and <I>unconditionally</I> using the %s directive.',{code('$insert')});
m2s_write('    <li>If it does not contain functions, it can be included <I>once or more</I>, possibly conditionally, using the %s directive.',{code('$insert')});
m2s_write('</ol>',{});
m2s_write('',{});
m2s_write('<P>Combining different directives for a single file is never allowed.',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Mat2spice functions', 'functions')});
m2s_write('',{});
m2s_write('<P> %s allows using special %s functions to generate circuits or other code.  A %s function is a Matlab function written on Matlab %s lines and/or %s %s code blocks, with Spice code in between.  Depending on the parameters passed to the function, it will generate different Spice code.',{mat2spice,mat2spice,mat2spice,dollar,oblock,cblock});
m2s_write('',{});
m2s_write('<P>Like a Matlab function, a %s function may have any number of input and output arguments.',{mat2spice});
m2s_write('',{});
m2s_write('<P>Typically, a function will generate a Spice or Spectre subcircuit and return the subcircuit name (and possibly other information).  If called again with different parameters, it will generate a different version of the subcircuit.  However, if called again with the same parameters, it will recognize this and, even though it will still execute all of the code (in order to produce all the output arguments) and generate the Spice code again, it will not write the code to the output file anymore, since it already exists.',{});
m2s_write('',{});
m2s_write('<P>Like normal Matlab functions, %s functions start with the keyword %s and end with %s.  Any function declared in a %s input file is a %s function.  Note that the %s and %s keywords that delimit the function must be on a line starting with a %s sign.  If they are within a %s %s Matlab block, the function will not be recognized as a %s function. ',{mat2spice,code('function'),code('end'),mat2spice,mat2spice,code('function'),code('end'),dollar,oblock,cblock,mat2spice});
m2s_write('',{});
m2s_write('<P>An example of a %s function is shown below.  It creates a buffer consisting of %s inverters, where the first has size 1 and every following inverter is a factor of %s larger than the previous one.',{mat2spice,code('N'),code('factor')});
m2s_write('<a name=buffer_function_example />',{});

    arr = {
        '$ function name = buffer(N, factor)'
        '$     name = sprintf(''buffer_%i_%i'', N, factor);'
        '.subckt $name in out vdd vss'
        ''
        '.connect in  n$[0]'
        '.connect out n$[N-1]'
        ''
        '$     for i = 0:N-1'
        'Xinv n$[i] n$[i+1] vdd vss inv size=$&lt;factor^i&gt;$'
        '$     end % for i'
        ''
        '.ends'
        ''
        '$ end % function'
        ''
        ''
        '$% Test some function calls'
        'Xbuf1 in1 out1 vdd vss $&lt;buffer(3, 3)&gt;$'
        'Xbuf2 in2 out2 vdd vss $&lt;buffer(4, 2)&gt;$'
        'Xbuf3 in3 out3 vdd vss $&lt;buffer(3, 3)&gt;$'
    };

m2s_write('%s',{pre(arr)});
m2s_write('This will result in the following code:',{});

    arr = {
        '.subckt buffer_3_3 in out vdd vss'
        ''
        '.connect in  n[0]'
        '.connect out n[2]'
        ''
        'Xinv n[0] n[1] vdd vss inv size=1'
        'Xinv n[1] n[2] vdd vss inv size=3'
        'Xinv n[2] n[3] vdd vss inv size=9'
        ''
        '.ends'
        ''
        '.subckt buffer_4_2 in out vdd vss'
        ''
        '.connect in  n[0]'
        '.connect out n[3]'
        ''
        'Xinv n[0] n[1] vdd vss inv size=1'
        'Xinv n[1] n[2] vdd vss inv size=2'
        'Xinv n[2] n[3] vdd vss inv size=4'
        'Xinv n[3] n[4] vdd vss inv size=8'
        ''
        '.ends'
        ''
        ''
        ''
        'Xbuf1 in1 out1 vdd vss buffer_3_3'
        'Xbuf2 in2 out2 vdd vss buffer_4_2'
        'Xbuf3 in3 out3 vdd vss buffer_3_3'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('<P>There is no restriction on the type and number of input and output arguments of a %s function.  It is also allowed to provide fewer input arguments than are present in the heading, on the condition that your function implementation supports this.',{mat2spice});
m2s_write('',{});
m2s_write('<P>Several ways exist to create the subcircuit name:',{});
m2s_write('<ul>',{});
m2s_write('    <li>You can write your own code to generate a name as shown in the above example.  This has the advantage that you have all control over the name.  However, you have to guarantee yourself that every possible set of input parameters produces a unique subcircuit name.  Otherwise, the function may produce two different subcicuits with the same name, which will produce an error in the Spice simulator.',{});
m2s_write('    <li>You can use one of the helper functions <a href=#m2s_getID>%s</a> or <a href=#m2s_generateInstName>%s</a>, which are explained below.',{code('m2s_getID'),code('m2s_generateInstName')});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('<P><B>Some remarks:</B>',{});
m2s_write('<ul>',{});
m2s_write('   <!--NOT CORRECT <li>Even if a %s function does not contain any non-Matlab lines, it still is not necessarily the same: the function will still store every set of inputs together with the resulting output.  While a Matlab function would recalculate its result every time it is called, the %s function would look up the result in its lookup table of previous calls and return it.  This obviously takes more memory, and probably more CPU as well, since it has to search linearly through the lookup table, and since %s functions are implemented as function handles, which are less efficient than functions.  Furthermore, a Matlab function does not necessarily give the same output every time it is called with the same inputs (it might e.g. have some memory or a random number generation inside).  This is not possible with %s functions.  Thus, when writing a function without non-Matlab code, it is probably better to write it as a Matlab function, save it in an M-file and add it to the Matlab path so it can be called from anywhere.-->',{mat2spice,mat2spice,mat2spice,mat2spice});
m2s_write('    ',{});
m2s_write('    <li>While Matlab functions with string arguments can be called using command syntax (e.g. you can write %s instead of %s), this is not allowed for %s functions.  This is because they are implemented as Matlab function handles, which do not support the command syntax.',{code('cd somedir'),code('cd(''somedir'')'),mat2spice});
m2s_write('    ',{});
m2s_write('    <li>Every %s function stores a table of previous input arguments and the corresponding output arguments.  Everytime a %s function is called, it will search this table for an occurence of the current input arguments.  The larger the table, the longer this will take.  If you use functions only for high-level circuits, this overhead will be negligible.  However, if you decide to turn every subcircuit into a function and replace all Spice parameters by %s function arguments (which has certain advantages when mapping your netlist to a chip layout), you might e.g. have a function %s that will have a lot of entries in its table, one for each set of parameters that is used anywhere in your system.  In such cases it might be useful to pay some attention to performance.  For example, instead of writing',{mat2spice,mat2spice,mat2spice,code('inverter(size, pmos_nmos_ratio, n_fingers)')});

    arr = {
        '$ for i = 0:255'
        'Xinv$[i] in$[i] inbar$[i] vdd vss $&lt;inverter(1, 2, 1)&gt;$'
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    you could write',{});

    arr = {
        '$ inv = inverter(1, 2, 1);'
        '$ for i = 0:255'
        'Xinv$[i] in$[i] inbar$[i] vdd vss $inv'
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    which would reduce the number of function calls from 256 to 1.',{});
m2s_write('    ',{});
m2s_write('    <li> %s functions cannot be nested, i.e. it is not allowed to declare a %s function within another %s function.  They can, however, be used recursively, i.e. they are allowed to call themselves.',{mat2spice,mat2spice,mat2spice});
m2s_write('    ',{});
m2s_write('    <li><P>It is allowed to pass fewer arguments to a function than are present in the function header.  However, the function body must compensate for this by setting default values for all uninitialised parameters, even if they will never be used.  The reason for this is that %s needs all argument values in order to determine whether it should produce new output text or just return without writing any text. ',{mat2spice});
m2s_write('    ',{});
m2s_write('    <P>All arguments must be initialised <i>before</i> any non-Matlab line occurs, and before any of the helper functions presented <a href=#helper_functions>below</a> is called.  A non-Matlab line is any line that does not start with a %s and is not between %s and %s.  Note that this also includes blank lines.',{dollar,oblock,cblock});
m2s_write('       ',{});
m2s_write('    <P>For example, if you declare a function',{});

    arr = {
        '$ function myfunc(a, b)'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    you can call it as %s on the condition that the function body checks that %s has not been initialised (you can use %s to check the number of arguments) and assigns a value to it.  The code could for example look like this:',{code('myfunc(3)'),code('b'),code('nargin')});

    arr = {
        '$ function myfunc(a, b)'
        '$    if nargin &lt; 2'
        '$        b = 0;'
        '$    end'
        '$% Spice code or blank lines are not allowed before this line'
        ''
        '&lt;subcircuit implementation&gt;'
        ''
        '$ end'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    <P>Because every argument always needs to be initialised, it is not allowed to use %s.',{code('varargin')});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('%s',{subsec('Helper functions', 'helper_functions')});
m2s_write('',{});
m2s_write('<P>Within each %s function, three helper functions are automatically defined: <a href=#m2s_getID>%s</a>, <a href=#m2s_generateInstName>%s</a> and <a href=#m2s_getParsedText>%s</a>, which are described below.  None of them takes any arguments.',{mat2spice,code('m2s_getID'),code('m2s_generateInstName'),code('m2s_getParsedText')});
m2s_write('',{});
m2s_write('%s',{subsubsec(code('m2s_getID'), 'm2s_getID')});
m2s_write('',{});
m2s_write('<P>The %s function returns a positive integer number that is based on the values of the parameters that were passed to the %s function in which %s is called.  This helper function guarantees that for the same set of parameter values, the same number will always be returned, and that for two different sets of parameter values, a different number will always be returned.  Thus, this number can be used to generate a unique and reproducible subcircuit name for each subcircuit the function produces.',{code('m2s_getID'),mat2spice,code('m2s_getID')});
m2s_write('',{});
m2s_write('<P>No other guarantees are given about the number returned.  Furthermore, it is only guaranteed that a certain set of parameter values will produce the same number <i>within a single run of %s</i>.  When you run %s again after making some modifications to your code, the same set of parameter values may result in a different value, even if you did not change anything to the function itself.',{mat2spice,mat2spice});
m2s_write('',{});
m2s_write('<P>For example: the %s function shown <a href=#buffer_function_example>above</a> can be rewritten as follows (the only line that was changed is the second line):',{code('buffer')});
m2s_write('<a name=buffer_function_example_m2s_getID />',{});

    arr = {
        '$ function name = buffer(N, factor)'
        '$     name = sprintf(''buffer_%i'', m2s_getID);'
        '.subckt $name in out vdd vss'
        ''
        '.connect in  n$[0]'
        '.connect out n$[N-1]'
        ''
        '$     for i = 0:N-1'
        'Xinv n$[i] n$[i+1] vdd vss inv size=$&lt;factor^i&gt;$'
        '$     end % for i'
        ''
        '.ends'
        ''
        '$ end % function'
        ''
        ''
        '$% Test some function calls'
        'buffer(3, 3)'
        'buffer(4, 2)'
        'buffer(3, 3)'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('<P>Since %s needs to know the values of all parameters, it is required that all parameters have been initialised at the time %s is called.  For example, in the above function you might want to introduce the option to pass only the first argument (%s) and have the %s argument default to 4.  This is allowed, but in this case, the default value must be assigned to %s <i>before</i> %s is called.',{code('m2s_getID'),code('m2s_getID'),code('N'),code('factor'),code('factor'),code('m2s_getID')});
m2s_write('',{});
m2s_write('%s',{subsubsec(code('m2s_generateInstName'), 'm2s_generateInstName')});
m2s_write('',{});
m2s_write('<P>The %s function generates a complete subcircuit name by starting from the function name (%s in the <a href=#buffer_function_example_m2s_getID>above</a> example) and adding an underscore (%s) and the number returned by <A href=#m2s_getID>%s</a>.',{code('m2s_generateInstName'),code('buffer'),code('_'),code('m2s_getID')});
m2s_write('',{});
m2s_write('<P>For example, in the <a href=#buffer_function_example_m2s_getID>above</a> example, the line',{});

    arr = {
         '$     name = sprintf(''buffer_%i'', m2s_getID);'
    };

m2s_write('%s',{pre(arr)});
m2s_write('could be rewritten as',{});

    arr = {
         '$     name = m2s_generateInstName;'
    };

m2s_write('%s',{pre(arr)});
m2s_write('',{});
m2s_write('<P>Since %s calls %s it can also be called only after all parameters have been initialised.',{code('m2s_generateInstName'),code('m2s_getID'),});
m2s_write('',{});
m2s_write('%s',{subsubsec(code('m2s_getParsedText'), 'm2s_getParsedText')});
m2s_write('',{});
m2s_write('<P>The %s function returns all the text that was produced during the run of the function.  In the <a href=#buffer_function_example_m2s_getID>above</a> example, this would be the buffer subcircuit that was generated.',{code('m2s_getParsedText')});
m2s_write(' ',{});
m2s_write('<P>This function is useful mainly when a file is included using the %s directive.  In this case, the generated code is not written to any output file, but can be accessed using %s in order to be e.g. returned by the %s function.  Note that in this case the %s function should normally be called after the last non-Matlab line, since any non-Matlab lines that appear after this call are just discarded.',{code('$import'),code('m2s_getParsedText'),mat2spice,code('m2s_getParsedText')});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec(['Scope of variables in ' mat2spice], 'scope_of_variables')});
m2s_write('',{});
m2s_write('<P>Each %s input file has its own scope, i.e. all variables declared in a file are accessible from within that file only.',{mat2spice});
m2s_write('',{});
m2s_write('<P>Each %s function has its own scope, but also shares the scope of the file in which the function is defined. This means that ',{mat2spice});
m2s_write('<ul>',{});
m2s_write('    <li>all variables declared inside a %s function are accessible only from within that function,',{mat2spice});
m2s_write('    <li>all variables declared in a file but outside any function, can also be accessed from within all %s functions in that file.  This can be convenient to implement an instance count:',{mat2spice});

    arr = {
        '$ instcount = 0;'
        ''
        '$ function name=createInst(param)'
        '$     name = m2s_generateInstName;'
        ''
        '&lt;instance body&gt;'
        ''
        '$     instcount = instcount+1;'
        '$ end'
        ''
        '$ function out = getInstCount()'
        '$     out = instcount;'
        '$ end'
        ''
        'Xinst1 n1 n2 $createInst(1)'
        'Xinst2 n2 n3 $createInst(2)'
        'Xinst3 n3 n4 $createInst(3)'
        ''
        '* this circuit has generated $getInstCount() instances'
    };

m2s_write('%s',{pre(arr)});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('%s',{subsec(['Global variables'], 'global_variables')});
m2s_write('',{});
m2s_write('<P>If you want a variable to be accessible from any %s file, you can declare it global using the Matlab keyword %s.  However, it is recommended not to use this approach, but instead pass global parameters externally with the %s function call, as explained <a href=#global_parameters>below</a>.',{mat2spice,code('global'),mat2spice});
m2s_write(' ',{});
m2s_write('%s',{subsec(['Global ' mat2spice ' parameters'], 'global_parameters')});
m2s_write('',{});
m2s_write('<P>Apart from the first two arguments, which are mandatory (see <a href=#calling_syntax>above</a> for their meaning), %s supports an arbitrary number of additional arguments.  Each of these arguments will be turned into a variable that will be readable and writable from any %s input file.  The variables will have the same names they had in the scope that %s was called from.  For example, if you write',{mat2spice,mat2spice,mat2spice});

    arr = {
         'a = 3;'
         ''
         'mat2spice(''inputfile.m2s'', ''outputpath/'', a);'
    };

m2s_write('%s',{pre(arr)});
m2s_write('then in every %s input file, a variable %s will exist with value 3.  If you would have written',{mat2spice,code('a')});

    arr = {
         'b = 3;'
         ''
         'mat2spice(''inputfile.m2s'', ''outputpath/'', b);'
    };

m2s_write('%s',{pre(arr)});
m2s_write('then the variable will be called %s.  Writing',{code('b')});

    arr = {

         'mat2spice(''inputfile.m2s'', ''outputpath/'', 3);'
    };

m2s_write('%s',{pre(arr)});
m2s_write('will produce an error since %s cannot determine a name for the variable.',{mat2spice});
m2s_write('',{});
m2s_write('<P>Obviously, it is a good idea to use nontrivial names for this kind of variables in order to avoid overwriting them by accident (e.g. by writing %s).  A good way to do this is to group parameters into one or more structures.',{code('$for a = 0:5; ...')});
m2s_write('',{});
m2s_write('<P>Be careful to change global variables in mat2spice input files, this could lead sometimes to unexpected results when a forgotten file alters a certain value.  Furthermore, the order in which the Matlab statements are executed depends on the order of the include directives and may therefore be unclear, especially when using %s directives, since they can occur several times and produce different output if a global variable was changed between to %s directives.',{code('$insert'),code('$insert')});
m2s_write('',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Error handling', 'error_handling')});
m2s_write('',{});
m2s_write('%s',{subsec([mat2spice ' errors'], 'mat2spice_errors')});
m2s_write('',{});
m2s_write('<P>%s errors can occur e.g. if wrong arguments are passed to the %s function, or if an included file cannot be found.  They are relatively rare and will be reported by %s like any other Matlab function may report errors.',{mat2spice,mat2spice,mat2spice});
m2s_write('',{});
m2s_write('%s',{subsec('Matlab errors', 'matlab_errors')});
m2s_write('',{});
m2s_write('<P>Matlab errors are errors in the Matlab code that is in one of your input files.  Any code (whether correct or not) will be copied by %s into the %s file (see the <a href=#how_it_works>How it works</a> section for more information on this file).  Errors in the Matlab code will only occur at the time Matlab executes the %s file.',{mat2spice,code('m2s_run.m'),code('m2s_run.m')});
m2s_write('',{});
m2s_write('<P>Without any special measures, Matlab would just report an error on some line in the %s file.  This is mostly an extremely long file (since it contains all your input files plus some extra code) and often contains very hard-to-read code, which may make it hard to find the error.',{code('m2s_run.m')});
m2s_write('',{});
m2s_write('<P>In order to solve this, %s will catch the error and report it with some extra information, showing not only the line in the %s file where the error occurred, but also the corresponding line in one of the %s input files.  In most cases, it will be easier to go to the mentioned line in the input file (if you use Matlab''s graphical environment, you can do this by clicking on the error message).',{mat2spice,code('m2s_run.m'),mat2spice});
m2s_write('',{});
m2s_write('<P><FONT size=2>(This error handling is the reason that on some places in the %s file there is lots of code on one single line: by ensuring that each line in %s corresponds to exactly one line in one of the input files, %s is always able to find on which line the error occurred).</FONT>',{code('m2s_run.m'),code('m2s_run.m'),mat2spice});
m2s_write('',{});
m2s_write('<P>Some syntax errors, however, such as e.g. forgetting and %s or forgetting to close a bracket or a string etc., may mess up the Matlab code in %s so much that it is no longer clear on which line the error is exactly.  In this case, %s might not be able to show the correct line.  In order to solve this kind of errors, it might be necessary to look into %s.',{code('end'),code('m2s_run.m'),mat2spice,code('m2s_run.m')});
m2s_write('',{});
m2s_write('%s',{subsec('Errors in generated code', 'errors_gen_code')});
m2s_write('',{});
m2s_write('<P>Errors in your generated code will of course not be signalled by %s, since it is only a preprocessor; it does not understand the code it generates.',{mat2spice});
m2s_write('',{});
m2s_write('<P>Typically, you will write a script that first runs %s and then runs e.g. a Spice simulator on the produced code.  Spice errors will then be reported by the Spice simulator after %s finishes.',{mat2spice,mat2spice});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Known issues and limitations', 'known_issues')});
m2s_write('',{});
m2s_write('%s',{subsec('Limitations and technicalities', 'limitations')});
m2s_write('',{});
m2s_write('<ul>',{});
m2s_write('    <li>%s stores all of its working data into a struct variable named %s.  Because of technical reasons, this variable can be read and written from any %s input file.',{mat2spice,code('m2s'),mat2spice});
m2s_write('    <ul>',{});
m2s_write('        <li>Do not change anything to this variable unless you know what you are doing.',{});
m2s_write('        <li>Do not try to create local variables called %s.  Instead of creating a new variable, you will just change %s.',{code('m2s'),code('m2s')});
m2s_write('        <li>Do not create functions called %s as this may conflict with the %s variable.',{code('m2s'),code('m2s')});
m2s_write('        <li>%s also defines a lot of functions whose names start with %s.  Therefore, you should avoid creating any variables or functions starting with %s in order to avoid conflicts. ',{mat2spice,code('m2s'),code('m2s')});
m2s_write('    </ul>',{});
m2s_write('    ',{});
m2s_write('    <li>All %s input files that are included in a single %s run must have different names, even if they are in different directories and/or have different extensions.  This is because %s creates a function for each input file, and this function''s name does not include the path or extension of the file.',{mat2spice,mat2spice,mat2spice});
m2s_write('    ',{});
m2s_write('    <li>As mentioned before, the lines',{});

    arr = {
         '$alfa'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    (with the %s as the first character of the line) and',{dollar});

    arr = {
         ' $alfa'
    };

m2s_write('%s',{pre(arr)});
m2s_write('    (with a space before the dollar) are not the same: the first is a <a href=#single_matlab_line>single Matlab line</a>, while the second is the <a href=#inline_matlab_expression_short_syntax>short notation for an inline Matlab expression</a> that happens to be at the beginning of a line.',{});
m2s_write('    ',{});
m2s_write('    <li><P>%s uses a lot of regular expressions to recognize escape sequences.  Therefore it may get confused if sequences occur that look like escape sequences but should not be interpreted that way in the given context.  For example, the inline expression %s, which is expected to result in the text %s, will be parsed wrongly since the regular expression searching for code included between %s and %s will match with the text %s and ignore what comes next.  Thus a Matlab error will be given since %s is not a valid Matlab expression.',{mat2spice,code([oic '''' cic '''' cic]),code(['>' char(36)]),oinl,cinl,code([oic '''' cic]),code('''')});
m2s_write('    <P>Depending on the specific situation, several ways exist to solve this kind of problems:',{});
m2s_write('    <ul>',{});
m2s_write('        <li>Store the string you need in a variable first.  This can be done in a Matlab block or on a single Matlab line.  Since these are much easier to parse, this will probably not cause any problems.  For example, in this case, you could write',{});

    arr = {
         '$ gtdollar = ''>$'';'
    };

m2s_write('%s',{pre(arr)});
m2s_write('        and then just use %s or %s instead of %s.',{code([oic 'gtdollar' cic]),code([dollar 'gtdollar']),code([oic '''' cic '''' cic])});
m2s_write('        ',{});
m2s_write('        <li>Split up the string that causes the problems into different strings that you concatenate using array notation in Matlab, or by just putting several inline Matlab expressions next to each other.  In our example, the inline expression %s would then be replaced by either %s or %s.',{code([oic '''' cic '''' cic]),code([oic '[''>'',''$'']' cic]),code([oic '''>''' cic oic '''$''' cic])});
m2s_write('        ',{});
m2s_write('        <li>If the dollar sign still causes troubles, it may be good to know that its ASCII value is 36 (decimal notation) so the Matlab expression %s is equivalent to the string %s.  This expression will never raise any parsing problems since it does not contain any escape characters.',{code('char(36)'),code('''$''')});
m2s_write('    </ul>',{});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('%s',{subsec('Reported/suspected bugs', 'bugs')});
m2s_write('',{});
m2s_write('<ul>',{});
m2s_write('    <li>It has been found that a percent sign (%s) on a non-Matlab line sometimes causes the parsing of the file in question to end at the point where the percent sign is.  The percent sign and all following text are discarded.  However, in the vast majority of cases, percent signs do not cause any troubles.  Thus far it has not been possible to deliberately trigger this bug. If it occurs, it can probably be solved by escaping the character as e.g. %s. In this case the %s sign occurs within a Matlab expressions and such cases are not known to ever produce any problems. If this still doesn''t work, you can write %s, which should definitely produce the %% sign. ',{code('%'),code([oinl '''%''' cinl]),code('%'),code([oinl 'char(37)' cinl])});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('<!--',{});
m2s_write('known issues:',{});
% Parser uses regexes and may get confused with expressions as $<'$<blabla>$'>$ since it may see the first > $ as the end of the inline expression
m2s_write('dollar_include requires extension if filename contains period',{});
m2s_write('-->',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Reporting bugs', 'reporting_bugs')});
m2s_write('',{});
m2s_write('<P>Bug reports can be sent to <a href=mailto:daniels.jorg@gmail.com>daniels.jorg@gmail.com</a>.',{});
m2s_write('',{});
m2s_write('<P>If the bug cannot be found and/or solved directly, please also put it in the list of known bugs on the <a href=https://securehomes.esat.kuleuven.be/~micwiki/wiki/Software/Mat2spice />Micas wiki</a> (if you are working at Micas).',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Example files', 'example_files')});
m2s_write('',{});
m2s_write('<ul>',{});
m2s_write('    <li>This file was generated from the files <a href=mat2spice2.m2html><code>mat2spice2.m2html</code></a> (the top file), <a href=toc.m2s><code>toc.m2s</code></a> and <a href=toc_helper.m2s><code>toc_helper.m2s</code></a>.  While these are not typical Spice-related %s files, they can be interesting as an example of what else %s can do.  If desired, you can also have a look at the generated Matlab-script <a href=m2s_run.m><code>m2s_run.m</code></a>, although this is probably not very informative.',{mat2spice,mat2spice});
m2s_write('    ',{});
m2s_write('    <li>More example files can be found on the <a href=https://securehomes.esat.kuleuven.be/~micwiki/wiki/Software/Mat2spice />Micas wiki</a>.',{});
m2s_write('</ul>',{});
m2s_write('',{});
m2s_write('<!--===========================================================================================-->',{});
m2s_write('%s',{sec('Author and version information', 'author')});
m2s_write('',{});
m2s_write('Code written by Jorg Daniels',{});
m2s_write('<ul>',{});
m2s_write('    <li>First version created September 15, 2006',{});
m2s_write('    <li>Latest revision of version 2: July 2010',{});
m2s_write('    <li>License information can be found in the source code file.  Extracted from there on Jul 26, 2010:',{});
m2s_write('<pre>',{});
m2s_write('%%  This software is free to use and distribute. ',{});
m2s_write('%%  Bug reports go to daniels.jorg@gmail.com.',{});
m2s_write('%%  You are free to modify the source code but I appreciate if you send me a ',{});
m2s_write('%%  copy of any significant modifications or additions to the code.',{});
m2s_write('%%  This text must be included in all copies or future versions.',{});
m2s_write('</pre>',{});
m2s_write('</ul>',{});
m2s_write('<par>',{});
m2s_write('',{});
m2s_write('<P>Documentation for version 2.0 written by Pieter Nuyts, July 2010.',{});
m2s_write('',{});
m2s_write('<p>Changelog of the code:',{});
m2s_write('<table cellspacing=20>',{});
m2s_write('    <tr><td>v1.0</td><td>15/09/06</td><td>by Jorg Daniels</td><td>first version</td></tr>',{});
m2s_write('    <tr><td>v1.5</td><td>01/02/08</td><td>by Jorg Daniels</td><td>included error handling</td></tr>',{});
m2s_write('    <tr><td>v2.0</td><td>26/07/10</td><td>by Jorg Daniels</td><td>Major revision.  Several bugfixes and new features such as separate workspaces for each m2s file, support for matlab functions in m2s-style, added syntax such as the %s short notation, bus notation,...</td></tr>',{code('$var')});
m2s_write('    <tr><td>v2.0.1</td><td>03/01/11</td><td>by Pieter Nuyts</td><td>(a) Replaced opening Matlab block delimiter ''%s'' with ''%s'' in two error messages <BR> (b) If argument %s starts with %s or %s, %s is no longer prepended.</td></tr>',{code('{$'),code('${'),code('outpath'),code('/'),code('~'),code('''./''')});
m2s_write('</table>',{});
m2s_write('',{});
m2s_write('</body>',{});
m2s_write('',{});
m2s_write('</html>',{});
m2s_write('',{});
%==================================================================================================
% GENERATE TABLE OF CONTENTS
%==================================================================================================
 createTOC();
end
function m2s_file_toc(); m2s.toc.currentline = 0;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s.toc.currentline=m2s.toc.currentline+1;m2s.toc.outstr{m2s.toc.currentline}=sprintf(m2s_format,m2s_args{:});end;createTOC=@m2s_FN_createTOC;
% This file serves to generate a table of contents for an .m2html file.
% This file should be included in the .m2html file using the $insert directive at the location
% where the table of contents should be.
% 
% Usage: Add entries to the table of contents using the addEntry function defined in
% toc_helper.m2s.  When all entries have been added, call createTOC() with no arguments.
m2s_write('',{});
m2s_write('',{});
% Generates the table of contents
% 
% This function should be called AFTER all the entries are added.
m2s_write('$m2s_FN_instances toc createTOC',{});function m2s_FN_createTOC;m2s_currentID=0; m2s_currentline = 0;function ID=m2s_getID;if ~m2s_currentID;m2s_currentID = find(cellfun(@(m2s_x) isequal(m2s_x,{}),{m2s.toc.fn.createTOC.inst.argvals}));if isempty(m2s_currentID);m2s.toc.fn.createTOC.ID=m2s.toc.fn.createTOC.ID+1;m2s_currentID=m2s.toc.fn.createTOC.ID;m2s.toc.fn.createTOC.inst(m2s_currentID).argvals={};end;end;ID=m2s_currentID;end;function str=m2s_generateInstName;str=sprintf('createTOC_%d',m2s_getID);end;function str=m2s_getParsedText;str=m2s_cell2str(m2s.toc.fn.createTOC.inst(m2s_getID).outstr);end;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s_currentline=m2s_currentline+1;m2s.toc.fn.createTOC.inst(m2s_getID).outstr{m2s_currentline}=sprintf(m2s_format,m2s_args{:});end;
   toc = getTOC();
 
   if isempty(toc)
       error('Table of contents is empty.');
   end % if
   
   for i = 1:length(toc)
       indent = repmat('&emsp;', 1, toc(i).level);
       line = [indent '<a href=#' toc(i).label '>' toc(i).title '</a><br>'];
m2s_write('%s',{line});
   end % for i
 end % function
end
function m2s_file_toc_helper(); m2s.toc_helper.currentline = 0;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s.toc_helper.currentline=m2s.toc_helper.currentline+1;m2s.toc_helper.outstr{m2s.toc_helper.currentline}=sprintf(m2s_format,m2s_args{:});end;addEntry=@m2s_FN_addEntry;getTOC=@m2s_FN_getTOC;
% This file serves to generate a table of contents for an .m2html file.
% This file should be included in the .m2html file using the $import directive prior to adding any
% entries to the table of contents.
% 
% Usage: Add entries to the table of contents using the addEntry function.  When all entries have
% been added, call createTOC() (defined in toc.m2s) with no arguments.
m2s_write('',{});
% Variable for storing the table of contents (initialised here as an empty structure array)
 toc = struct('level', {}, 'title', {}, 'label', {}); 
m2s_write('',{});
% Adds an entry to the table of contents
% 
% LEVEL:   0 = section
%          1 = subsection
%          2 = subsubsection
%          ...
%      Used for indenting the TOC
%
% TITLE:   Title of the section
% 
% LABEL:   HTML label (without the #) that the TOC should link to
m2s_write('$m2s_FN_instances toc_helper addEntry',{});function m2s_FN_addEntry(level,title,label);m2s_currentID=0; m2s_currentline = 0;function ID=m2s_getID;if ~m2s_currentID;m2s_currentID = find(cellfun(@(m2s_x) isequal(m2s_x,{level,title,label}),{m2s.toc_helper.fn.addEntry.inst.argvals}));if isempty(m2s_currentID);m2s.toc_helper.fn.addEntry.ID=m2s.toc_helper.fn.addEntry.ID+1;m2s_currentID=m2s.toc_helper.fn.addEntry.ID;m2s.toc_helper.fn.addEntry.inst(m2s_currentID).argvals={level,title,label};end;end;ID=m2s_currentID;end;function str=m2s_generateInstName;str=sprintf('addEntry_%d',m2s_getID);end;function str=m2s_getParsedText;str=m2s_cell2str(m2s.toc_helper.fn.addEntry.inst(m2s_getID).outstr);end;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s_currentline=m2s_currentline+1;m2s.toc_helper.fn.addEntry.inst(m2s_getID).outstr{m2s_currentline}=sprintf(m2s_format,m2s_args{:});end;

    entry.level = level;
    entry.title = title;
    entry.label = label;
    
    toc(end+1) = entry;

 end % function
m2s_write('',{});
% Returns the table of contents as a struct array
% 
% Should normally be called only by the createTOC function
m2s_write('$m2s_FN_instances toc_helper getTOC',{});function [TOC] = m2s_FN_getTOC;m2s_currentID=0; m2s_currentline = 0;function ID=m2s_getID;if ~m2s_currentID;m2s_currentID = find(cellfun(@(m2s_x) isequal(m2s_x,{}),{m2s.toc_helper.fn.getTOC.inst.argvals}));if isempty(m2s_currentID);m2s.toc_helper.fn.getTOC.ID=m2s.toc_helper.fn.getTOC.ID+1;m2s_currentID=m2s.toc_helper.fn.getTOC.ID;m2s.toc_helper.fn.getTOC.inst(m2s_currentID).argvals={};end;end;ID=m2s_currentID;end;function str=m2s_generateInstName;str=sprintf('getTOC_%d',m2s_getID);end;function str=m2s_getParsedText;str=m2s_cell2str(m2s.toc_helper.fn.getTOC.inst(m2s_getID).outstr);end;function m2s_write(m2s_format,m2s_args);m2s_args=m2s_arg2str(m2s_args);if iscell(m2s_format);m2s_format=m2s_cell2str(m2s_format);end;m2s_currentline=m2s_currentline+1;m2s.toc_helper.fn.getTOC.inst(m2s_getID).outstr{m2s_currentline}=sprintf(m2s_format,m2s_args{:});end;
   TOC = toc;
 end
end
end