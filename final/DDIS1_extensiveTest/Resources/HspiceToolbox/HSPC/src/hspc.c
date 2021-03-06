/**************************************************************************
 * FILE : hspice_conv.c
 * 
 * AUTHOR : Mike Perrott
 * 
 * DESCRIPTION : converts Cadence hspice netlist into an hspice input
 *   file, allowing for vector inputs and file manipulation.
 * 
 * REVISION HISTORY : 
 * 
 * Date       Author        Tag     Description
 * ---------  -----------   ------  -----------------------
 * 5-26-96    Gary Hall     GAR01   Added '!' symbol to append lines at end
 * 5-27-96    Gary Hall     GAR02   Fixed glitch in PWL voltage source 'R'
 *                                  vectors starting and ending with '1'
 **************************************************************************/

#include <stdio.h>
#include "matrix_func.h"
#define LINESIZE 2000
#define LENGTH_PAR_LIST 50  /* don't make this more than 100 */
#define LENGTH_PAR 200
#define MAX_CHAR_LENGTH 202  /* MAX_CHAR_LENGTH should be LENGTH_PAR+2 */
#define MAX_ARG 1000
#define MAX_NUM_ARGS 500
#define MAX_NUM_LINES 25000
#define MAX_NUM_SKEW_PARAM 4
#define MAX_NUM_SKEW_ARGS 10
#define LENGTH_MODEL_LIST 50
#define LENGTH_MODEL_NAME 50

typedef struct  
  {  
   int main_par_length, global_par_length, nest_length;
   char main_par_list[LENGTH_PAR_LIST][LENGTH_PAR];
   double main_par_val[LENGTH_PAR_LIST];
   double nest_val[LENGTH_PAR_LIST];
   int param_not_found;
} PARAM;


typedef struct
  {
  int num_of_args;
  char arg_array[MAX_NUM_ARGS][MAX_ARG];
} ARGUMENT;

typedef struct
  {
  int num_of_lines;
  char line_array[MAX_NUM_LINES][LINESIZE];
} LINE;
 
typedef struct
  {
   int n_model_list_length,p_model_list_length;

   char n_model_list[LENGTH_MODEL_LIST][LENGTH_MODEL_NAME];
   double n_model_list_sizes[LENGTH_MODEL_LIST][4];

   char p_model_list[LENGTH_MODEL_LIST][LENGTH_MODEL_NAME];
   double p_model_list_sizes[LENGTH_MODEL_LIST][4];

   double out_diff_size,in_diff_size;
   char mode_diff_string[30];
   int calc_diff_flag,four_sided_perimeter_flag;
 } MODEL;

void extract_cap(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list);
void add_appended_line(LINE *appended_lines, char *in_string);
void obtain_skew_parameters(FILE *in, 
     char process[][MAX_CHAR_LENGTH], int *num_processes, 
     char temp[][MAX_CHAR_LENGTH], int *num_temps,
     char param_name[][MAX_CHAR_LENGTH], int *num_param_names,
     char param_value[][MAX_NUM_SKEW_ARGS][MAX_CHAR_LENGTH], int *num_param_values);
int process_deck(char *deck_filename, LINE *deleted_lines, LINE *added_lines,
  PARAM *param_list, MODEL *model_list, int mismatch_flag, FILE *out);
LINE *include_input_lines(LINE *input_lines,PARAM *param_list, 
         char *par_filename, LINE *added_lines);
LINE *add_one_input(char *name, matrix *data, matrix *time_inc_vector,
    char timing_info[][MAX_CHAR_LENGTH], char *par_filename, 
    int linecount, LINE *added_lines);
LINE *add_one_phase_input(char *name, matrix *phase_data, matrix *data, int num_periods_per_step,
     char timing_info[][MAX_CHAR_LENGTH], char *par_filename, int linecount, LINE *added_lines);
int extract_descriptor(ARGUMENT *args, int arg_num, char *desc_name, 
          char *filename,LINE *line_set,PARAM *param_list,double *desc_value);
int extract_text_descriptor(ARGUMENT *args, int arg_num, char *desc_name, 
          char *filename, LINE *line_set,char *desc_value);
void send_line_set_to_output(LINE *line_set, FILE *out);
void send_line_set_to_std_output(LINE *line_set);
int extract_arguments(LINE *line_set, char *filename, int linecount, ARGUMENT *args);
int extract_par_arguments(LINE *line_set, int line_number, char *filename, 
			  ARGUMENT *args);
double convert_exponent(char *input, char *filename, LINE *line_set, char *full_string);
double convert_string(char *input, char *filename, LINE *line_set, int *error_flag);
void extract_mos(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list, MODEL *model_list);
void extract_mos_mismatch(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list, MODEL *model_list);
void extract_res(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list);
double eval_no_paren_expr(char *input, char *file_name, LINE *line_set, 
                          PARAM *par_list);
LINE *init_line();
ARGUMENT *init_argument();
PARAM *init_param();
double eval_paren_expr(char *input, char *file_name, LINE *line_set,
                        PARAM *par_list);
MODEL *obtain_model_and_par_list(char *model_file_name,PARAM *par_list,
	      MODEL *models, LINE *added_lines, LINE *appended_lines,
              LINE *deleted_lines, LINE *input_lines, int *mismatch_flag,
              char *case_string, int ngspice_flag);
char *choose_model(char *netlist_model, double width_value, 
     double length_value, char *filename, int linecount, 
     MODEL *model_list, char *model_name);
MODEL *init_model();
       

main(int argc,char *argv[])
{
FILE *out;
char case_string[100];
int remove_end_flag, mismatch_flag, ngspice_flag;
LINE *added_lines,*deleted_lines,*input_lines;
LINE *appended_lines;   /* GAR01 - add lines to end of file - '>' */
PARAM *param_list;
MODEL *model_list;


added_lines = init_line();
appended_lines = init_line(); /* GAR01 */
input_lines = init_line();
deleted_lines = init_line();
param_list = init_param();
model_list = init_model();
mismatch_flag = 0;
ngspice_flag = 0;


if (argc != 4 && argc != 5)
  {
   printf("ERROR:  need 3 or 4 arguments\n");
   printf("        %s input_spice_file output_spice_file mod/par_file [case_string OR ngspice]\n",argv[0]);
   exit(1);
 }

if ((out = fopen(argv[2],"w")) == NULL)
  {
   printf("error in %s: can't open spice output file '%s'\n",argv[0],
             argv[2]);
   exit(1);
}
if (argc == 5)
  {
   if (strncmp(argv[4],"ngspice",7) == 0)
     {
      ngspice_flag = 1;
      case_string[0] = '\0';
     }
   else
     {
      sprintf(case_string,"%s",argv[4]);
     }
  }
else
   {
   case_string[0] = '\0';
   }

/* if you include .param lines for hdin and hdout, want to
   include them at the first part of the "added" netlist.  So, reserve
   the space for them now */
sprintf(added_lines->line_array[0],"\n");
sprintf(added_lines->line_array[1],"\n");
added_lines->num_of_lines = 2;

obtain_model_and_par_list(argv[3],param_list,model_list,added_lines,
   	        appended_lines,deleted_lines,input_lines, &mismatch_flag,
                case_string, ngspice_flag);

include_input_lines(input_lines,param_list,argv[3],added_lines);

remove_end_flag = process_deck(argv[1],deleted_lines, added_lines,
                    param_list, model_list, mismatch_flag, out);

/* send parameter file lines to output */
/*  NOTE:  if a .alter statement was placed in spice deck, added
           lines were already dumped in process_deck routine, in
           which case the following line will be a no-op.
*/
send_line_set_to_output(added_lines,out);

/* insure that carriage return occurs */
added_lines->num_of_lines = 1;
sprintf(added_lines->line_array[0],"\n");
send_line_set_to_output(added_lines,out); 

/* append the last lines - GAR01 */
if (appended_lines->num_of_lines > 0)
  send_line_set_to_output(appended_lines,out);

/* took ".END" out of lineset... GAR01 */
if (remove_end_flag == 1)
  {
   added_lines->num_of_lines = 1;
   sprintf(added_lines->line_array[0],".end\n");
   send_line_set_to_output(added_lines,out); 
  }

/* insure that carriage return occurs */
added_lines->num_of_lines = 1;
sprintf(added_lines->line_array[0],"\n");
send_line_set_to_output(added_lines,out); 


free(added_lines);
free(appended_lines);
free(input_lines);
free(deleted_lines);
free(param_list);
free(model_list);
fclose(out);
return(0);
}    

void add_appended_line(LINE *appended_lines, char *in_string)
  {
  if (appended_lines->num_of_lines < MAX_NUM_LINES)
    {
    sprintf(appended_lines->line_array[appended_lines->num_of_lines],"%s",
      in_string);
    appended_lines->num_of_lines++;
    }
  else
    {
    printf("error: ran out of appended lines!!! \n");
    printf(" need to increase MAX_NUM_LINES\n");
    exit(1);
    }
  }

int process_deck(char *deck_filename, LINE *deleted_lines, LINE *added_lines,
  PARAM *param_list, MODEL *model_list, int mismatch_flag, FILE *out)
{
FILE *in;
char include_filename[MAX_ARG];
int first_char,remove_end_flag;
int i,j,linecount,end_of_file_flag;
LINE *line_set,*temp_lines;
ARGUMENT *args,*deleted_args;

if ((in = fopen(deck_filename,"r")) == NULL)
  {
   printf("error in %s:  can't open spice file:  '%s'\n","hspc",deck_filename);
   exit(1);
 }

line_set = init_line();
temp_lines = init_line();
args = init_argument();
deleted_args = init_argument();

remove_end_flag = 0;
linecount = 0;
end_of_file_flag = 0;

if ((first_char = fgetc(in)) == EOF)
  {
    printf("error in '%s':  input file '%s' is empty!\n",
	   "hspc",deck_filename);
    exit(1);
  }
while(end_of_file_flag == 0)
  {
   line_set->num_of_lines = 0;
   while(1)
     {
     linecount++;
     line_set->line_array[line_set->num_of_lines][0] = (char) first_char;
     line_set->line_array[line_set->num_of_lines][1] = '\0';
     if (fgets(&(line_set->line_array[line_set->num_of_lines][1]),LINESIZE-1,in) == NULL)
       {
       end_of_file_flag = 1;
       break;
       }
     if ((first_char = fgetc(in)) == EOF)
       {
       end_of_file_flag = 1;
       break;
       }
     for (i = 0; line_set->line_array[line_set->num_of_lines][i] != '\0'; i++)
       if (line_set->line_array[line_set->num_of_lines][i] == '&')
          if (line_set->line_array[line_set->num_of_lines][i+1] == '\n' ||
	      line_set->line_array[line_set->num_of_lines][i+1] == '\0' ||
              line_set->line_array[line_set->num_of_lines][i+1] == ' ')
              break;

     if (line_set->line_array[line_set->num_of_lines][i] == '&')
       {
	 line_set->line_array[line_set->num_of_lines][i] = ' ';
	 line_set->num_of_lines++;
	 if (line_set->num_of_lines >= MAX_NUM_LINES)
	   {
	     printf(" error in '%s':  too many '& lines' encountered\n","hspc");
	     printf(" error occurred in input file '%s' on line %d\n",deck_filename,
                    linecount);
	     printf("   to fix, change MAX_NUM_LINES in source code\n");
	     printf("   (current value of MAX_NUM_LINES is %d)\n",MAX_NUM_LINES);
	     exit(1);
	   }
       }
     else if (first_char == (int) '+')
       {
        line_set->num_of_lines++;
        if (line_set->num_of_lines >= MAX_NUM_LINES)
	  {
           printf(" error in '%s':  too many '+ lines' encountered\n","hsps");
           printf(" error occurred in input file '%s' on line %d\n",deck_filename,
                    linecount);
           printf("   to fix, change MAX_NUM_LINES in source code\n");
           printf("   (current value of MAX_NUM_LINES is %d)\n",MAX_NUM_LINES);
           exit(1);
	  }
       }
     else
       break;
     }
   line_set->num_of_lines++;
   extract_arguments(line_set,deck_filename,linecount,args);

   /*     printf("\n");
   for (i = 0; i < line_set->num_of_lines; i++)
      printf("line[%d] = %s\n",i,line_set->line_array[i]);  */

/* remove lines designated in parameter file */
   temp_lines->num_of_lines=1;
   j = -1;
   for (i = 0; i < deleted_lines->num_of_lines; i++)
     {
      sprintf(temp_lines->line_array[0],"%s",deleted_lines->line_array[i]);
      extract_arguments(temp_lines,deck_filename,linecount,deleted_args);
      for (j = 0; j < deleted_args->num_of_args 
	       && j < args->num_of_args; j++)
	{
         if (strcmp(deleted_args->arg_array[j],args->arg_array[j]) != 0)
            break;
       }
      if (j == deleted_args->num_of_args)
         break;
    }
   if (j == deleted_args->num_of_args)
      continue;

/* Modify lines in spice file */

/* in SunOS gcc, blank lines (i.e. lines only containing '\n')
   are appended to the beginning of nonempty lines */
   for (i = 0; line_set->line_array[0][i] == ' ' ||
               line_set->line_array[0][i] == '\n'; i++);
   switch(line_set->line_array[0][i])
     {
     case 'm':
     case 'M':
       if (mismatch_flag == 0)
         extract_mos(line_set,"hspc",deck_filename,linecount,param_list,model_list);
       else
         extract_mos_mismatch(line_set,"hspc",deck_filename,linecount,param_list,model_list);
       break;
     case 'r':
     case 'R':
       extract_res(line_set,"hspc",deck_filename,linecount,param_list);
       break;
     case 'c':
     case 'C':
       extract_cap(line_set,"hspc",deck_filename,linecount,param_list);
       break;
     case '.':
       if (strcmp(args->arg_array[0],".include") == 0 ||
           strcmp(args->arg_array[0],".INCLUDE") == 0)
	 {
          if (args->num_of_args != 2)
	    {
             printf("error in 'hspc':  file '%s' has a .include line\n",
                    deck_filename);
             printf("   with the wrong number of arguments\n");
             exit(1);
	    }
          for (j = 0; args->arg_array[1][j] == ' ' || args->arg_array[1][j] == '\'';
               j++);
          strncpy(include_filename,&(args->arg_array[1][j]),MAX_ARG-1);
          for (j = 0; include_filename[j] != '\0'; j++)
             if (include_filename[j] == '\'')
                include_filename[j] = '\0';
	  /*          printf("include_filename = %s\n",include_filename); */
          line_set->num_of_lines = 1;
          sprintf(line_set->line_array[0],"**** including file '%s' ****\n",
              include_filename);
          send_line_set_to_output(line_set,out);
          line_set->num_of_lines = 0;

          process_deck(include_filename, deleted_lines, added_lines,
                  param_list, model_list, mismatch_flag, out);
	 }
      else if (strcmp(args->arg_array[0],".alter") == 0 ||
               strcmp(args->arg_array[0],".ALTER") == 0)
	{
          send_line_set_to_output(added_lines,out);
          added_lines->num_of_lines = 0;
	}
     /* just in case of appending, remove the .END line - GAR01 */
       if ( strncmp(&line_set->line_array[0][i],".END",4) == 0 ||
          strncmp(&line_set->line_array[0][i],".end",4) == 0)
          {
          if (strncmp(&line_set->line_array[0][i],".ENDS",5) != 0 &&
             strncmp(&line_set->line_array[0][i],".ends",5) != 0 &&
             strncmp(&line_set->line_array[0][i],".ENDD",5) != 0 &&
             strncmp(&line_set->line_array[0][i],".endd",5) != 0)
	    {
            remove_end_flag = 1;
            line_set->num_of_lines=0;
	    }
          }
       break;
     } 
   send_line_set_to_output(line_set,out);
  }

free(line_set);
free(temp_lines);
free(args);
free(deleted_args);
fclose(in);
return(remove_end_flag);
}







LINE *include_input_lines(LINE *input_lines,PARAM *param_list, 
         char *par_filename, LINE *added_lines)
{
int i,j,k,timing_flag,first_col;
int num_periods_per_step;
ARGUMENT *par_args,*name_args,*pattern_args;
LINE *temp_lines;
/* double delay,transition_time,time_inc,vlow,vhigh; */
char timing_info[5][MAX_CHAR_LENGTH];
matrix *input_data,*one_input,*one_phase_input,*time_inc_vector;


par_args = init_argument();
name_args = init_argument();
pattern_args = init_argument();
temp_lines = init_line();
input_data = init("input_data");
one_input = init("one_input");
one_phase_input = init("one_phase_input");
time_inc_vector = init("time_inc_vector");

timing_flag = 0;
for (i = 0; i < input_lines->num_of_lines; i++)
  {
    extract_par_arguments(input_lines, i, par_filename, par_args);
    if (strcmp(par_args->arg_array[0],"timing") == 0)
      {
        timing_flag = 1;
	if (par_args->num_of_args != 6)
	  {
           printf("error in 'include_input_lines':  need 6 arguments\n");
           printf("  when using the %% command 'timing'\n");
           printf("Error occured on %% line %d of par file '%s'\n",i+1
		  ,par_filename);
	   printf("  number of args = %d\n",par_args->num_of_args);
           printf("  line reads: %s\n",input_lines->line_array[i]);
           printf(" correct format:  timing delay transition_time time_inc vlow vhigh\n");
           exit(1);
	 }
        sprintf(timing_info[0],"%s",par_args->arg_array[1]);
        sprintf(timing_info[1],"%s",par_args->arg_array[2]);
        sprintf(timing_info[2],"%s",par_args->arg_array[3]);
        sprintf(timing_info[3],"%s",par_args->arg_array[4]);
        sprintf(timing_info[4],"%s",par_args->arg_array[5]);
      }
    else if (strcmp(par_args->arg_array[0],"phase") == 0)
      {
	if (par_args->num_of_args != 5)
	  {
           printf("error in 'include_input_lines':  need 4 arguments\n");
           printf("  when using the %% command 'phase'\n");
           printf("Error occured on %% line %d of par file '%s'\n",i+1,
		  par_filename);
	   printf("  number of args = %d\n",par_args->num_of_args);
           printf("  line reads: %s\n",input_lines->line_array[i]);
           printf(" correct format:  phase [input_name(s)] num_periods_per_step [phase pattern] [data pattern]\n"); 
           exit(1);
	 }
	if (timing_flag != 1)
	  {
           printf("error in 'include_input_lines':  no 'timing' command\n");
           printf("  was used before the command 'phase'\n");
           printf("Error occured on %% line %d of par file '%s'\n",i+1,
		  par_filename);
           printf("  line reads: %s\n",input_lines->line_array[i]);
           exit(1);
	 }
	temp_lines->num_of_lines = 1;
        sprintf(temp_lines->line_array[0],"%s",par_args->arg_array[1]);
	extract_par_arguments(temp_lines,0, par_filename,name_args);

        num_periods_per_step = (int) eval_paren_expr(par_args->arg_array[2], 
                        par_filename,temp_lines, param_list); 
        
        sprintf(temp_lines->line_array[0],"%s",par_args->arg_array[3]);
	extract_par_arguments(temp_lines,0, par_filename,pattern_args);
	
        if (strcmp(pattern_args->arg_array[0],"phase") == 0)
	  {
            conform_matrix(pattern_args->num_of_args-1,1,one_phase_input);
            for (j = 1, k = 0; j < pattern_args->num_of_args; j++,k++)
                one_phase_input->elem[k][0] = 
                      (double) atoi(pattern_args->arg_array[j]);
	  }
	else
	  {
	    printf("error in 'include_input_lines':  don't recognize\n");
	    printf("the %% command '%s'\n",pattern_args->arg_array[0]);
	    printf("  error occured in par file '%s' on %% line %d\n",
		   par_filename,i+1);
	    exit(1);
	  }

        sprintf(temp_lines->line_array[0],"%s",par_args->arg_array[4]);
	extract_par_arguments(temp_lines,0, par_filename,pattern_args);

        if (strcmp(pattern_args->arg_array[0],"data") == 0)
	  {
            conform_matrix(pattern_args->num_of_args-1,1,one_input);
            for (j = 1, k = 0; j < pattern_args->num_of_args; j++,k++)
                one_input->elem[k][0] = 
                      (double) atoi(pattern_args->arg_array[j]);
	  }
	else
	  {
	    printf("error in 'include_input_lines':  don't recognize\n");
	    printf("the %% command '%s'\n",pattern_args->arg_array[0]);
	    printf("  error occured in par file '%s' on %% line %d\n",
		   par_filename,i+1);
	    exit(1);
	  }

	for (j = 0; j < name_args->num_of_args; j++)
            add_one_phase_input(name_args->arg_array[j],one_phase_input,
                     one_input,num_periods_per_step,timing_info,par_filename,i+1,added_lines);
      }
    else if (strcmp(par_args->arg_array[0],"input") == 0)
      {
	if (par_args->num_of_args != 3)
	  {
           printf("error in 'include_input_lines':  need 3 arguments\n");
           printf("  when using the %% command 'input'\n");
           printf("Error occured on %% line %d of par file '%s'\n",i+1,
		  par_filename);
	   printf("  number of args = %d\n",par_args->num_of_args);
           printf("  line reads: %s\n",input_lines->line_array[i]);
           printf(" correct format:  input [input_name(s)] [pattern]\n"); 
           exit(1);
	 }
	if (timing_flag != 1)
	  {
           printf("error in 'include_input_lines':  no 'timing' command\n");
           printf("  was used before the command 'input'\n");
           printf("Error occured on %% line %d of par file '%s'\n",i+1,
		  par_filename);
           printf("  line reads: %s\n",input_lines->line_array[i]);
           exit(1);
	 }
	temp_lines->num_of_lines = 1;
        sprintf(temp_lines->line_array[0],"%s",par_args->arg_array[1]);
	extract_par_arguments(temp_lines,0, par_filename,name_args);

        sprintf(temp_lines->line_array[0],"%s",par_args->arg_array[2]);
	extract_par_arguments(temp_lines,0, par_filename,pattern_args);
	
        if (strcmp(pattern_args->arg_array[0],"file") == 0)
	  {
	    if (pattern_args->num_of_args != 3)
	      {
               printf("error in 'include_input_lines':  need three and only\n");
               printf("  three arguments when using the %% command 'file'\n");
               printf("   i.e. [file filename first_column]\n");
               printf("   note that column numbering starts with 0\n");
	       printf("  error occured in par file '%s' on %% line %d\n",
		      par_filename,i+1);
               exit(1);
	     }
	    load(pattern_args->arg_array[1],input_data);
	    first_col = (int) eval_paren_expr(pattern_args->arg_array[2], 
					      par_filename,temp_lines,
                                              param_list); 
            if (first_col < 0)
	      {
		printf("error in 'include_input_lines':  first_col must be > 0\n");
		printf("   specified first_col:  %d\n",first_col);
		printf("  error occured in par file '%s' on %% line %d\n",
		       par_filename,i+1);
		exit(1);
              }
            if (input_data->cols - first_col < name_args->num_of_args)
	      {
		printf("error in 'include_input_lines':  number of input names\n");
		printf("is more than the number of columns (minus first_col) in the specified file\n");
		printf("   number of input names:  %d\n",name_args->num_of_args);
		printf("   first_col: %d, number of columns in file '%s':  %d\n",
		       first_col,pattern_args->arg_array[1],input_data->cols);
		printf("  error occured in par file '%s' on %% line %d\n",
		       par_filename,i+1);
		exit(1);
	      }
	    for (j = 0, k = first_col; j < name_args->num_of_args; j++,k++)
	      {
	       p_of_m(input_data,0,k,input_data->rows-1,k,one_input);
               s_to_m(1.0,one_input->rows,1,time_inc_vector);
               add_one_input(name_args->arg_array[j],one_input,time_inc_vector,
                             timing_info,par_filename,i+1,added_lines);
	     }
	  }
        else if (strcmp(pattern_args->arg_array[0],"set") == 0)
	  {
            conform_matrix(pattern_args->num_of_args-1,1,one_input);
            s_to_m(1.0,one_input->rows,1,time_inc_vector);
            for (j = 1, k = 0; j < pattern_args->num_of_args; j++,k++)
	      {
		if (strcmp(pattern_args->arg_array[j],"1") == 0)
		    one_input->elem[k][0] = 1.0;
		else if (strcmp(pattern_args->arg_array[j],"0") == 0)
		    one_input->elem[k][0] = 0.0;
                else if (pattern_args->arg_array[j][0] == '(')
		  {
                   if (pattern_args->arg_array[j+3][0] != ')')
		     {
                      printf("error in 'include_input_lines': unmatched parenthesis\n");
                      printf("you must have two, and only two, numbers between parenthesis\n");
                      printf("   error occured in par file '%s' on %% line %d\n",par_filename,i+1);
                      exit(1);
		     }
                   j++;
		   if (strcmp(pattern_args->arg_array[j],"1") == 0)
		      one_input->elem[k][0] = 1.0;
		   else if (strcmp(pattern_args->arg_array[j],"0") == 0)
		      one_input->elem[k][0] = 0.0;
         	   else 
		      {
		       printf("error in 'include_input_lines':  'set' symbol\n");
		       printf("encountered within ( ) that is not recognized\n");
		       printf("   'set' symbol:  %s\n",pattern_args->arg_array[j]);
		       printf("   acceptable symbols:  0 1\n");
		       printf("  error occured in par file '%s' on %% line %d\n",
			   par_filename,i+1);
		       exit(1);
		     }
                   j++;
                   time_inc_vector->elem[k][0] = 
                            eval_paren_expr(pattern_args->arg_array[j], 
                                            par_filename,temp_lines,
                                            param_list);
                   j++;
		  }                   
		else if (strcmp(pattern_args->arg_array[j],"R") == 0)
		  {
		    if (j < 3)
		      {
                       printf("error in 'include_input_lines':  when using 'set',\n");
		       printf("you must have at least two 0 or 1 symbols before an R symbol\n");
		       printf("  error occured in par file '%s' on %% line %d\n",
			      par_filename,i+1);
		       exit(1);
		     }
		    one_input->elem[k++][0] = -1.0;
                    break;
		  }
		else 
		  {
		    printf("error in 'include_input_lines':  'set' symbol\n");
		    printf("encountered that is not recognized\n");
		    printf("   'set' symbol:  %s\n",pattern_args->arg_array[j]);
		    printf("   acceptable symbols:  0 1 R\n");
		    printf("  error occured in par file '%s' on %% line %d\n",
			   par_filename,i+1);
		    exit(1);
		  }
	      }
            p_of_m(one_input,0,0,k-1,0,one_input);
            p_of_m(time_inc_vector,0,0,k-1,0,time_inc_vector);
	    for (j = 0; j < name_args->num_of_args; j++)
	      {
               add_one_input(name_args->arg_array[j],one_input,time_inc_vector,
                             timing_info,par_filename,i+1,added_lines);
	     }
	  }
	else
	  {
	    printf("error in 'include_input_lines':  don't recognize\n");
	    printf("the %% command '%s'\n",pattern_args->arg_array[0]);
	    printf("  error occured in par file '%s' on %% line %d\n",
		   par_filename,i+1);
	    exit(1);
	  }
      }
    else
      {
       printf("error in 'include_input_lines':  don't recognize\n");
       printf("the %% command '%s'\n",par_args->arg_array[0]);
       printf("  error occured in par file '%s' on %% line %d\n",
	      par_filename,i+1);
       exit(1);
     }
  }
free(par_args);
free(name_args);
free(pattern_args);
free(temp_lines);
free_matrix(input_data);
free_matrix(one_input);
free_matrix(one_phase_input);
free_matrix(time_inc_vector);
return(added_lines);
}

LINE *add_one_input(char *name, matrix *data, matrix *time_inc_vector, 
     char timing_info[][MAX_CHAR_LENGTH], char *par_filename, 
     int linecount, LINE *added_lines)
{
int i,k,repeat_flag;
char delay[MAX_CHAR_LENGTH],transition_time[MAX_CHAR_LENGTH];
char base_time_inc[MAX_CHAR_LENGTH], vlow[MAX_CHAR_LENGTH], vhigh[MAX_CHAR_LENGTH];
char time_inc[2*MAX_CHAR_LENGTH];
char v_value[MAX_CHAR_LENGTH];
char last_value[MAX_CHAR_LENGTH];

repeat_flag = 0;
sprintf(delay,"%s",timing_info[0]);
sprintf(transition_time,"%s",timing_info[1]);
sprintf(base_time_inc,"%s",timing_info[2]);
sprintf(vlow,"%s",timing_info[3]);
sprintf(vhigh,"%s",timing_info[4]);

if (data->rows <= 1)
  {
    printf("error in 'add_one_input':  number of data points must be > 1\n");
    printf(" error encountered while incorporating input '%s'\n",name);
    printf("  error occurred in model/par file '%s',%% line %d\n",
	   par_filename,linecount);
    printf("  number of data points = %d\n",data->rows);
    exit(1);
  }
if (time_inc_vector->rows != data->rows)
  {
    printf("error in 'add_one_input':  time_inc_vector->rows != data->rows\n");
    printf("  this should not be possible - check source code\n");
    exit(1);
  }

i = 0;
for (k = 0; k < data->rows; k++)
  {
    sprintf(time_inc,"(%s)",base_time_inc);
    if (added_lines->num_of_lines >= MAX_NUM_LINES)
      {
	printf("error in 'add_one_input':	 too many added_lines\n");
	printf(" encountered while incorporating input '%s'\n",name);
	printf("  error occurred in model/par file '%s',%% line %d\n",
	       par_filename,linecount);
	printf("  added_lines count:	%d\n",added_lines->num_of_lines);
        printf("   to fix, increase MAX_NUM_LINES in source code\n");
	exit(1);
      }
    if (data->elem[k][0] > 0.5)
       sprintf(v_value,"%s",vhigh);
    else if (data->elem[k][0] > -0.5)
       sprintf(v_value,"%s",vlow);
    else
       repeat_flag = 1;

    if (i == 0)
      {
        /* changed code to start a Vsource at it's final value when
         * repeating the sequence.
         * otherwise, a [1 1 1 1 R] source will dip to 0 when it
         * repeats.  This corrects a glitch.
         */
        if (data->elem[data->rows-1][0] < -0.5)
	  {
	    /*  R is last value, so use the data value before it */
           if (data->elem[data->rows-2][0] > 0.5)
              sprintf(last_value,"%s",vhigh);
           else
              sprintf(last_value,"%s",vlow);
	  }
        else
	  {
            /* R is not last value, so don't try to correct for glitch
               by using the last value.  Instead, just use the initial
               value */
           sprintf(last_value,"%s",v_value);
	  }
	sprintf(added_lines->line_array[added_lines->num_of_lines],
		"\nv_%s %s 0 pwl '%d*%s' '%s'\n+, '%d*%s+%s' '%s', '%d*%s' '%s'\n",
		name,name,
                i,time_inc, last_value,
                i,time_inc, transition_time, v_value,
                i+((int) time_inc_vector->elem[k][0]),time_inc, v_value);
	added_lines->num_of_lines++;
        i += ((int) time_inc_vector->elem[k][0]);
      }
    else
      {
          if (repeat_flag == 0)
	    {
	      sprintf(added_lines->line_array[added_lines->num_of_lines],
                      "+, '%d*%s+%s' '%s', '%d*%s' '%s'\n",
                      i, time_inc,transition_time, v_value,
                      i+((int) time_inc_vector->elem[k][0]), 
                      time_inc, v_value);
	      added_lines->num_of_lines++;
              i += ((int) time_inc_vector->elem[k][0]);
	    }
	  else
	      break;
      }

  }
if (repeat_flag == 1)
   sprintf(added_lines->line_array[added_lines->num_of_lines],"+, R, TD='%s'\n",
	delay);
else
   sprintf(added_lines->line_array[added_lines->num_of_lines],"+, TD='%s'\n",
	delay);
added_lines->num_of_lines++;
return(added_lines);
}

LINE *add_one_phase_input(char *name, matrix *phase_data, matrix *data, int num_periods_per_step,
     char timing_info[][MAX_CHAR_LENGTH], char *par_filename, int linecount, LINE *added_lines)
{
int i,k,j;
int trans_flag;
char delay[MAX_CHAR_LENGTH],transition_time[MAX_CHAR_LENGTH];
char base_time_inc[MAX_CHAR_LENGTH], vlow[MAX_CHAR_LENGTH], vhigh[MAX_CHAR_LENGTH];
char time_inc[2*MAX_CHAR_LENGTH];
char v_value[MAX_CHAR_LENGTH];
char last_value[MAX_CHAR_LENGTH];

sprintf(delay,"%s",timing_info[0]);
sprintf(transition_time,"%s",timing_info[1]);
sprintf(base_time_inc,"%s",timing_info[2]);
sprintf(vlow,"%s",timing_info[3]);
sprintf(vhigh,"%s",timing_info[4]);


if (phase_data->rows <= 1)
  {
    printf("error in 'add_one_phase_input':  number of phase_data points must be > 1\n");
    printf(" error encountered while incorporating input '%s'\n",name);
    printf("  error occurred in model/par file '%s',%% line %d\n",
	   par_filename,linecount);
    printf("  number of phase_data points = %d\n",data->rows);
    exit(1);
  }
if (data->rows <= 1)
  {
    printf("error in 'add_one_phase_input':  number of data points must be > 1\n");
    printf(" error encountered while incorporating input '%s'\n",name);
    printf("  error occurred in model/par file '%s',%% line %d\n",
	   par_filename,linecount);
    printf("  number of data points = %d\n",data->rows);
    exit(1);
  }

j = 0;
if (data->elem[j][0] > 0.5)
    sprintf(v_value,"%s",vhigh);
else if (data->elem[j][0] > -0.5)
    sprintf(v_value,"%s",vlow);
j++;
trans_flag = 0;


sprintf(time_inc,"(%s)",base_time_inc);
/* print(phase_data); */

for (i = 0, k = -1; i < phase_data->rows*num_periods_per_step; i++)
  {
    if (added_lines->num_of_lines >= MAX_NUM_LINES)
      {
	printf("error in 'add_one_phase_input':	 too many added_lines\n");
	printf(" encountered while incorporating input '%s'\n",name);
	printf("  error occurred in model/par file '%s',%% line %d\n",
	       par_filename,linecount);
	printf("  added_lines count:	%d\n",added_lines->num_of_lines);
        printf("   to fix, increase MAX_NUM_LINES in source code\n");
	exit(1);
      }
    if (j >= data->rows)
      j = 0;
    sprintf(last_value,"%s",v_value);
    if (data->elem[j][0] > 0.5)
       sprintf(v_value,"%s",vhigh);
    else if (data->elem[j][0] > -0.5)
       sprintf(v_value,"%s",vlow);
    j++;


    if (i % num_periods_per_step == 0)
       k++;
    sprintf(time_inc,"(%s)",base_time_inc);
    if (i == 0)
      {
	sprintf(added_lines->line_array[added_lines->num_of_lines],
		"\nv_%s %s 0 pwl '%d*%s+%5.3f*(%s)' '%s'\n+, '%d*%s+%s+%5.3f*(%s)' '%s', '%d*%s+%5.3f*(%s)' '%s'\n",
		name,name,
                i,time_inc,phase_data->elem[k][0]/100.0, base_time_inc, last_value,
                i,time_inc, transition_time, phase_data->elem[k][0]/100.0,base_time_inc,
                v_value,
                i+1,time_inc, phase_data->elem[k][0]/100.0, base_time_inc, v_value);
	added_lines->num_of_lines++;
      }
    else
      {
	   sprintf(added_lines->line_array[added_lines->num_of_lines],
                      "+, '%d*%s+%s+%5.3f*(%s)' '%s', '%d*%s+%5.3f*(%s)' '%s'\n",
                      i, time_inc,transition_time,phase_data->elem[k][0]/100.0,
                      base_time_inc, v_value,
                      i+1, time_inc, phase_data->elem[k][0]/100.0, base_time_inc, v_value);
	   added_lines->num_of_lines++;
      }
  }

sprintf(added_lines->line_array[added_lines->num_of_lines],"+, R, TD='%s'\n",
	delay);
added_lines->num_of_lines++;
return(added_lines);
}

   

void send_line_set_to_output(LINE *line_set, FILE *out)
{
int i;

for (i = 0; i < line_set->num_of_lines; i++)
    fprintf(out,"%s",line_set->line_array[i]);
}

int extract_arguments(LINE *line_set, char *filename, int linecount, ARGUMENT *args)
{
char *inpline;
int i,j,line_set_count;

line_set_count = 0;
inpline = line_set->line_array[line_set_count];
/* in SunOS gcc, blank lines (i.e. lines only containing '\n')
   are appended to the beginning of nonempty lines */
for (i = 0 ; inpline[i] == ' ' || inpline[i] == '\n'; i++);
for (args->num_of_args = 0; args->num_of_args < MAX_NUM_ARGS; args->num_of_args++)
  {   
   for (    ; inpline[i] == ' '; i++);
   for (j = 0; inpline[i] != ' ' && inpline[i] != '\n' && inpline[i] != '\0'; i++,j++)
     {
      if (j-1 >= MAX_ARG)
        {
         printf("error in 'extract_arguments':  max argument size exceeded\n");
         printf("     in spice file '%s' on line %d\n",filename,linecount);
         printf("      to fix error, change MAX_ARG in source code\n");
         exit(1);
       }
      args->arg_array[args->num_of_args][j] = inpline[i];
    }
   args->arg_array[args->num_of_args][j] = '\0';
   if (inpline[i] == ' ')
      for (    ; inpline[i] == ' '; i++);
   if (inpline[i] == '\0' || inpline[i] == '\n')
     {
      if (++line_set_count < line_set->num_of_lines)
	{
         inpline = line_set->line_array[line_set_count];
         if (line_set->line_array[line_set_count][0] == '+')
            i = 1;
         else
            i = 0;
         continue;
	}
      else
         break;
     }
  }
args->num_of_args++;
if (args->num_of_args > MAX_NUM_ARGS)
  {
   printf("error in 'extract_arguments':  max number of arguments exceeded\n");
   printf("error occurred in spice file '%s' on line %d\n",filename,linecount);
   printf("   MAX_NUM_ARGS specifed in source code as '%d'\n",MAX_NUM_ARGS);
   exit(1);
  }

return(args->num_of_args);
}

/* note that `extract_par_arguments' allows the use of '[' and
   ']' to group arguments */

int extract_par_arguments(LINE *line_set, int line_number, char *filename, 
			  ARGUMENT *args)
{
char *inpline;
int i,j,line_set_count;

inpline = line_set->line_array[line_number];
/* in SunOS gcc, blank lines (i.e. lines only containing '\n')
   are appended to the beginning of nonempty lines */
for (i = 0 ; inpline[i] == ' ' || inpline[i] == '\n'; i++);
for (args->num_of_args = 0; args->num_of_args < MAX_NUM_ARGS; args->num_of_args++)
  {   
   if (inpline[i] == '[')
     {
       for (i++; inpline[i] == ' '; i++);
       for (j = 0; inpline[i] != ']' && inpline[i] != '\n' && inpline[i] != '\0';
                   i++,j++)
	 {
	   if (j-1 >= MAX_ARG)
	     {
	       printf("error in 'extract_par_arguments':  max argument size exceeded\n");
	       printf("     in par file '%s' on %% line %d\n",filename,
		      line_number+1);
	       printf("      to fix error, change MAX_ARG in source code\n");
	       exit(1);
	     }
	   args->arg_array[args->num_of_args][j] = inpline[i];
	 }
       if (inpline[i] != ']')
	 {
         printf("error in 'extract_par_arguments':  a closing ']' was not found!\n");
	 printf("     in par file '%s' on %% line %d\n",filename,
		      line_number+1);
         exit(1);
         }
       i++;
     }
   else
     {
       for (j = 0; inpline[i] != ' ' && inpline[i] != '\n' && inpline[i] != '\0'
                                    && inpline[i] != '('  && inpline[i] != ')'; 
                                    i++,j++)
	 {
	   if (j-1 >= MAX_ARG)
	     {
	       printf("error in 'extract_par_arguments':  max argument size exceeded\n");
	       printf("     in par file '%s' on %% line %d\n",filename,
		      line_number+1);
	       printf("      to fix error, change MAX_ARG in source code\n");
	       exit(1);
	     }
	   args->arg_array[args->num_of_args][j] = inpline[i];
	 }
     }
   args->arg_array[args->num_of_args][j] = '\0';
   if (inpline[i] == ')' || inpline[i] == '(')
      {
       if (j > 0)
          args->num_of_args++;
       args->arg_array[args->num_of_args][0] = inpline[i];
       args->arg_array[args->num_of_args][1] = '\0';
       i++;
      }
   for (    ; inpline[i] == ' '; i++);
   if (inpline[i] == '\n' || inpline[i] == '\0')
      break;
  }
args->num_of_args++;
if (args->num_of_args > MAX_NUM_ARGS)
  {
   printf("error in 'extract_par_arguments':  max number of arguments exceeded\n");
   printf("error occurred in par file '%s' on %% line %d\n",filename,
	  line_number+1);
   printf("   MAX_NUM_ARGS specifed in source code as '%d'\n",MAX_NUM_ARGS);
   exit(1);
  }

return(args->num_of_args);
}


void extract_res(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list)
{
ARGUMENT *args;
int from_instance_flag;
char desc_name[MAX_ARG];
char desc_text[MAX_ARG];
char temp[MAX_ARG];
char res_val[MAX_ARG];
char model_text[MAX_ARG];
char w_val[MAX_ARG], l_val[MAX_ARG], m_val[MAX_ARG];
int res_flag, model_flag, w_flag, l_flag, m_flag;
int i, desc_flag;

from_instance_flag = 0;
res_flag = 0;
m_flag = 0;
w_flag = 0;
l_flag = 0;

args = init_argument();
extract_arguments(line_set,prog_name,linecount,args);

if (args->num_of_args < 4)
  {
    printf("error in 'extract_res':  need at least 4 arguments for resistors\n");
    printf("  line reads:\n");
    send_line_set_to_std_output(line_set);
    exit(1);
  }

/************ just use the following for Terason project *************/

    sprintf(line_set->line_array[0],"%s",args->arg_array[0]);
    for (i = 1; i < 4; i++)
      {
      sprintf(temp," %s",args->arg_array[i]);
      strcat(line_set->line_array[0],temp);
      }
   strcat(line_set->line_array[0],"\n");
   return;

/*********************************************************************/

param_list->param_not_found = 0;  // don't abort on unknown variables
eval_paren_expr(args->arg_array[3],filename,line_set,param_list);
if (param_list->param_not_found == 1)
   from_instance_flag = 1;
param_list->param_not_found = -1; // revert back to aborting on unknown vars

if (from_instance_flag == 0)
  {
    sprintf(line_set->line_array[0],"%s",args->arg_array[0]);
    for (i = 1; i < args->num_of_args; i++)
      {
      sprintf(temp," %s",args->arg_array[i]);
      strcat(line_set->line_array[0],temp);
      }
   strcat(line_set->line_array[0],"\n");
   return;
  }

/*  only do the following if resistor is obtained from instance form */
   
for (i = 4; i < args->num_of_args; i++)
  {
    desc_flag = extract_text_descriptor(args,i,desc_name,filename,
                                    line_set,desc_text);
    if (desc_flag == 0)
      {
	printf("error in 'extract_res': can only have parameters\n");
        printf("   for arguments beyond the fourth argument\n");
	printf("   the line reads:\n");
	send_line_set_to_std_output(line_set);
      }

    if (strcmp(desc_name,"r") == 0 || strcmp(desc_name,"R") == 0)
      {
        res_flag = 1;
        if (desc_flag == 1)
           strcpy(res_val,desc_text);
        else
           sprintf(res_val,"\'%s\'",desc_text);
      }
    else if (strcmp(desc_name,"model") == 0 || strcmp(desc_name,"MODEL") == 0)
      {
	model_flag = 1;
        strcpy(model_text,desc_text);
      }
    else if (strcmp(desc_name,"m") == 0 || strcmp(desc_name,"M") == 0)
      {
        m_flag = 1;
        if (desc_flag == 1)
           strcpy(m_val,desc_text);
        else
           sprintf(m_val,"\'%s\'",desc_text);
      }
    else if (strcmp(desc_name,"w") == 0 || strcmp(desc_name,"W") == 0)
      {
        w_flag = 1;
        if (desc_flag == 1)
           strcpy(w_val,desc_text);
        else
           sprintf(w_val,"\'%s\'",desc_text);
      }
    else if (strcmp(desc_name,"l") == 0 || strcmp(desc_name,"L") == 0)
      {
        l_flag = 1;
        if (desc_flag == 1)
           strcpy(l_val,desc_text);
        else
           sprintf(l_val,"\'%s\'",desc_text);
      }
  }
if (res_flag == 0)
   {
     printf("error in 'extract_res':  missing resistance value\n");
     printf("  line reads:\n");
     send_line_set_to_std_output(line_set);
     exit(1);
   }
line_set->num_of_lines = 1;
sprintf(line_set->line_array[0],"%s %s %s",args->arg_array[0],
         args->arg_array[1],args->arg_array[2]);
if (model_flag == 1)
  {
    sprintf(temp," %s",model_text);
    strcat(line_set->line_array[0],temp);
  }
if (res_flag == 1)
  {
    sprintf(temp," r=%s",res_val);
    strcat(line_set->line_array[0],temp);
  }
if (m_flag == 1)
  {
    sprintf(temp," m=%s",m_val);
    strcat(line_set->line_array[0],temp);
  }
if (w_flag == 1)
  {
    sprintf(temp," w=%s",w_val);
    strcat(line_set->line_array[0],temp);
  }
if (l_flag == 1)
  {
    sprintf(temp," l=%s",l_val);
    strcat(line_set->line_array[0],temp);
  }
strcat(line_set->line_array[0],"\n");

free(args);
}

void extract_cap(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list)
{
ARGUMENT *args;
int from_instance_flag;
char desc_name[MAX_ARG];
char desc_text[MAX_ARG];
char temp[MAX_ARG];
char cap_val[MAX_ARG];
char model_text[MAX_ARG];
char w_val[MAX_ARG], l_val[MAX_ARG], m_val[MAX_ARG];
int cap_flag, model_flag, w_flag, l_flag, m_flag;
int i, desc_flag;

from_instance_flag = 0;
cap_flag = 0;
m_flag = 0;
w_flag = 0;
l_flag = 0;

args = init_argument();
extract_arguments(line_set,prog_name,linecount,args);

if (args->num_of_args < 4)
  {
    printf("error in 'extract_cap':  need at least 4 arguments for caps\n");
    printf("  line reads:\n");
    send_line_set_to_std_output(line_set);
    exit(1);
  }

/************ just use the following for Terason project *************/

    sprintf(line_set->line_array[0],"%s",args->arg_array[0]);
    for (i = 1; i < 4; i++)
      {
      sprintf(temp," %s",args->arg_array[i]);
      strcat(line_set->line_array[0],temp);
      }
   strcat(line_set->line_array[0],"\n");
   return;

/*********************************************************************/

param_list->param_not_found = 0;  // don't abort on unknown variables
eval_paren_expr(args->arg_array[3],filename,line_set,param_list);
if (param_list->param_not_found == 1)
   from_instance_flag = 1;
param_list->param_not_found = -1; // revert back to aborting on unknown vars

if (from_instance_flag == 0)
  {
    sprintf(line_set->line_array[0],"%s",args->arg_array[0]);
    for (i = 1; i < args->num_of_args; i++)
      {
      sprintf(temp," %s",args->arg_array[i]);
      strcat(line_set->line_array[0],temp);
      }
   strcat(line_set->line_array[0],"\n");
   return;
  }

/*  only do the following if cap is obtained from instance form */
   
for (i = 4; i < args->num_of_args; i++)
  {
    desc_flag = extract_text_descriptor(args,i,desc_name,filename,
                                    line_set,desc_text);
    if (desc_flag == 0)
      {
	printf("error in 'extract_cap': can only have parameters\n");
        printf("   for arguments beyond the fourth argument\n");
	printf("   the line reads:\n");
	send_line_set_to_std_output(line_set);
      }

    if (strcmp(desc_name,"c") == 0 || strcmp(desc_name,"C") == 0)
      {
        cap_flag = 1;
        if (desc_flag == 1)
           strcpy(cap_val,desc_text);
        else
           sprintf(cap_val,"\'%s\'",desc_text);
      }
    else if (strcmp(desc_name,"model") == 0 || strcmp(desc_name,"MODEL") == 0)
      {
	model_flag = 1;
        strcpy(model_text,desc_text);
      }
    else if (strcmp(desc_name,"m") == 0 || strcmp(desc_name,"M") == 0)
      {
        m_flag = 1;
        if (desc_flag == 1)
           strcpy(m_val,desc_text);
        else
           sprintf(m_val,"\'%s\'",desc_text);
      }
    else if (strcmp(desc_name,"w") == 0 || strcmp(desc_name,"W") == 0)
      {
        w_flag = 1;
        if (desc_flag == 1)
           strcpy(w_val,desc_text);
        else
           sprintf(w_val,"\'%s\'",desc_text);
      }
    else if (strcmp(desc_name,"l") == 0 || strcmp(desc_name,"L") == 0)
      {
        l_flag = 1;
        if (desc_flag == 1)
           strcpy(l_val,desc_text);
        else
           sprintf(l_val,"\'%s\'",desc_text);
      }
  }
if (cap_flag == 0)
   {
     printf("error in 'extract_cap':  missing cap value\n");
     printf("  line reads:\n");
     send_line_set_to_std_output(line_set);
     exit(1);
   }
line_set->num_of_lines = 1;
sprintf(line_set->line_array[0],"%s %s %s",args->arg_array[0],
         args->arg_array[1],args->arg_array[2]);
if (model_flag == 1)
  {
    sprintf(temp," %s",model_text);
    strcat(line_set->line_array[0],temp);
  }
if (cap_flag == 1)
  {
    sprintf(temp," c=%s",cap_val);
    strcat(line_set->line_array[0],temp);
  }
if (m_flag == 1)
  {
    sprintf(temp," m=%s",m_val);
    strcat(line_set->line_array[0],temp);
  }
if (w_flag == 1)
  {
    sprintf(temp," w=%s",w_val);
    strcat(line_set->line_array[0],temp);
  }
if (l_flag == 1)
  {
    sprintf(temp," l=%s",l_val);
    strcat(line_set->line_array[0],temp);
  }
strcat(line_set->line_array[0],"\n");

free(args);
}

void extract_mos(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list, MODEL *model_list)
{
int i,j;
char desc_name[MAX_ARG], model_name[LENGTH_MODEL_NAME],desc_text[MAX_ARG];
double desc_value;
int geo_value;
char width[MAX_ARG],length[MAX_ARG],m_value[MAX_ARG],fingers[MAX_ARG];
char pr_width[MAX_ARG], pr_length[MAX_ARG];
char as_ad_ps_pd[4][MAX_ARG];
ARGUMENT *args;
int desc_flag, length_flag, width_flag, fingers_flag, as_flag, ad_flag;
int ps_flag, pd_flag, m_flag, geo_flag;
char temp[MAX_ARG];

length_flag = 0;
width_flag = 0;
as_flag = 0;
ad_flag = 0;
ps_flag = 0;
pd_flag = 0;
m_flag = 0;
fingers_flag = 0;
geo_flag = 0;

args = init_argument();
extract_arguments(line_set,prog_name,linecount,args);

if (args->num_of_args < 8)
  {
    printf("error in 'extract MOS':  need at least 8 arguments\n");
    printf("  line reads:\n");
    send_line_set_to_std_output(line_set);
    for (i = 0; i < args->num_of_args; i++)
      printf("arg[%d] = '%s'\n",i,args->arg_array[i]);
    exit(1);
  }

/* remove dummy devices */

if (strcmp(args->arg_array[1],args->arg_array[2]) == 0 &&
    strcmp(args->arg_array[3],args->arg_array[4]) == 0 &&
    strcmp(args->arg_array[1],args->arg_array[3]) == 0)
  {
   line_set->num_of_lines = 0;
   free(args);
   return;
  }
   

for (i = 6; i < args->num_of_args; i++)
  {
    desc_flag = extract_text_descriptor(args,i,desc_name,filename,
                                    line_set,desc_text);
    if (desc_flag != 0)
      {
	if (strcmp(desc_name,"L") == 0 || strcmp(desc_name,"l") == 0)
	  {
	    length_flag = 1;
            if (desc_flag == 1)
	      {
               strcpy(length,desc_text);
  	       strcpy(pr_length,desc_text);
	      }
            else
	      {
               sprintf(length,"(%s)",desc_text);
               sprintf(pr_length,"\'%s\'",desc_text);
	      }
	  }
        else if (strcmp(desc_name,"W") == 0 || strcmp(desc_name,"w") == 0)
	  {
	    width_flag = 1;
            if (desc_flag == 1)
	      {
               strcpy(width,desc_text);
   	       strcpy(pr_width,desc_text);
	      }
            else
	      {
               sprintf(width,"(%s)",desc_text);
               sprintf(pr_width,"\'%s\'",desc_text);
	      }
	  }
        else if (strcmp(desc_name,"M") == 0 || strcmp(desc_name,"m") == 0)
	  {
	    m_flag = 1;
	    /*  modify to allow for the influence of fingers (look below)
            if (desc_flag == 1)
  	       strcpy(m_value,desc_text);
            else
               sprintf(m_value,"\'%s\'",desc_text);
	    */
  	    strcpy(m_value,desc_text);
	  }
        else if (strcmp(desc_name,"fingers") == 0 || 
                 strcmp(desc_name,"FINGERS") == 0)
	  {
	    fingers_flag = 1;
            if (desc_flag == 1)
  	       strcpy(fingers,desc_text);
            else
               sprintf(fingers,"\'%s\'",desc_text);
	  }
        else if (strcmp(desc_name,"GEO") == 0 || strcmp(desc_name,"geo") == 0)
	  {
	    geo_flag = 1;
            geo_value = (int)
                eval_paren_expr(desc_text,filename,line_set, param_list); 
	  }
        else if (strcmp(desc_name,"AD") == 0 || strcmp(desc_name,"ad") == 0)
	  {
	    ad_flag = 1;
            sprintf(as_ad_ps_pd[1],"'%s'",desc_text);
	  }
        else if (strcmp(desc_name,"AS") == 0 || strcmp(desc_name,"as") == 0)
	  {
	    as_flag = 1;
            sprintf(as_ad_ps_pd[0],"'%s'",desc_text);
	  }
        else if (strcmp(desc_name,"PD") == 0 || strcmp(desc_name,"pd") == 0)
	  {
	    pd_flag = 1;
            sprintf(as_ad_ps_pd[3],"'%s'",desc_text);
	  }
        else if (strcmp(desc_name,"PS") == 0 || strcmp(desc_name,"ps") == 0)
	  {
	    ps_flag = 1;
            sprintf(as_ad_ps_pd[2],"'%s'",desc_text);
	  }
      }
  }
if (length_flag == 0 || width_flag == 0)
  {
   printf("error in 'extract_mos':  either a width or length\n"); 
   printf(" descriptor is missing on line %d of spice file '%s'\n",linecount,
           filename);
   exit(1);
  }
if (geo_flag == 0)
   geo_value = 0;
if (m_flag == 0)
   strcpy(m_value,"1");
if (fingers_flag == 1)
   sprintf(temp,"\'%s*%s\'",m_value,fingers);
else
   sprintf(temp,"\'%s\'",m_value);
strcpy(m_value,temp);

if (as_flag == 1 || ad_flag == 1 || ps_flag == 1 || pd_flag == 1)
  {
   if (as_flag == 0 || ad_flag == 0 || ps_flag == 0 || pd_flag == 0)
     {
       printf("error in 'extract_mos':  either as, ad, ps, or pd\n"); 
       printf(" descriptors were listed on line %d of spice file '%s'\n",
             linecount,filename);
       printf("  but not all of them!\n");
       printf("  line reads:\n");
       send_line_set_to_std_output(line_set);
       exit(1);
     }
  }
else if (model_list->calc_diff_flag == 1)
  {
/********** set_mode_diff can be used to override geo settings ***/
   if (strcmp(model_list->mode_diff_string,"conservative") == 0)
      geo_value = 0;
   else if (strcmp(model_list->mode_diff_string,"drain_smaller") == 0)
      geo_value = 1;
   else if (strcmp(model_list->mode_diff_string,"source_smaller") == 0)
      geo_value = 2;
/*********** calculate drain and source ********/
/*************  areas and perimeters  **********/
   if (geo_value == 0)
     {
      sprintf(as_ad_ps_pd[0],"'hdout*%s'",width);
      sprintf(as_ad_ps_pd[1],"'hdout*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+2*%s'",width);
         sprintf(as_ad_ps_pd[3],"'2*hdout+2*%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+%s'",width);
         sprintf(as_ad_ps_pd[3],"'2*hdout+%s'",width);
	}
     }
   else if (geo_value == 1)
     {
      sprintf(as_ad_ps_pd[0],"'hdout*%s'",width);
      sprintf(as_ad_ps_pd[1],"'0.5*hdin*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+2*%s'",width);
         sprintf(as_ad_ps_pd[3],"'hdin+%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+%s'",width);
         sprintf(as_ad_ps_pd[3],"hdin");
	}
     }
   else if (geo_value == 2)
     {
      sprintf(as_ad_ps_pd[0],"'0.5*hdin*%s'",width);
      sprintf(as_ad_ps_pd[1],"'hdout*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'hdin+%s'",width);
         sprintf(as_ad_ps_pd[3],"'2*hdout+2*%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"hdin");
         sprintf(as_ad_ps_pd[3],"'2*hdout+%s'",width);
	}
     }
   else if (geo_value == 3)
     {
      sprintf(as_ad_ps_pd[0],"'0.5*hdin*%s'",width);
      sprintf(as_ad_ps_pd[1],"'0.5*hdin*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'hdin+%s'",width);
         sprintf(as_ad_ps_pd[3],"'hdin+%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"hdin");
         sprintf(as_ad_ps_pd[3],"hdin");
	}
     }
    /* override previous geo setting */
    geo_value = 0;
  }

              
/*************  choose model ***************/
strcpy(model_name,args->arg_array[5]);
/*
need to evaluate length and width before you can use this - creates
   a problem when width and length are parameterized!

    choose_model(args->arg_array[5],width_value, length_value, filename,
                           linecount, model_list,model_name);
*/

line_set->num_of_lines = 4;
sprintf(line_set->line_array[0],"%s %s %s %s %s\n",
	args->arg_array[0],args->arg_array[1],args->arg_array[2],
        args->arg_array[3],args->arg_array[4]);

if (geo_value != 0.0)
   sprintf(line_set->line_array[1],"+    %s l=%s w=%s m=%s geo=%d\n", 
        model_name, length, width, m_value, (int) geo_value);
else
   sprintf(line_set->line_array[1],"+    %s l=%s w=%s m=%s\n", 
        model_name, pr_length, pr_width, m_value);
if (ad_flag == 1 || model_list->calc_diff_flag == 1)
  {
  sprintf(line_set->line_array[2],"+    ad=%s as=%s\n",as_ad_ps_pd[1],
           as_ad_ps_pd[0]);
  sprintf(line_set->line_array[3],"+    pd=%s ps=%s\n",as_ad_ps_pd[3],
           as_ad_ps_pd[2]);
  }
else
  line_set->num_of_lines = 2;
free(args);
}


void extract_mos_mismatch(LINE *line_set, char *prog_name, char *filename, int linecount, PARAM *param_list, MODEL *model_list)
{
int i,j;
char desc_name[MAX_ARG], model_name[LENGTH_MODEL_NAME],desc_text[MAX_ARG];
double desc_value;
int geo_value;
char width[MAX_ARG],length[MAX_ARG],m_value[MAX_ARG];
char pr_width[MAX_ARG], pr_length[MAX_ARG];
char as_ad_ps_pd[4][MAX_ARG];
ARGUMENT *args;
int desc_flag, length_flag, width_flag, as_flag, ad_flag;
int ps_flag, pd_flag, m_flag, geo_flag;

length_flag = 0;
width_flag = 0;
as_flag = 0;
ad_flag = 0;
ps_flag = 0;
pd_flag = 0;
m_flag = 0;
geo_flag = 0;

args = init_argument();
extract_arguments(line_set,prog_name,linecount,args);

if (args->num_of_args < 8)
  {
    printf("error in 'extract MOS':  need at least 8 arguments\n");
    printf("  error occured in input file '%s' on line %d\n",
	   filename, linecount);
    exit(1);
  }

/* remove dummy devices */

if (strcmp(args->arg_array[1],args->arg_array[2]) == 0 &&
    strcmp(args->arg_array[3],args->arg_array[4]) == 0 &&
    strcmp(args->arg_array[1],args->arg_array[3]) == 0)
  {
   line_set->num_of_lines = 0;
   free(args);
   return;
  }
   

for (i = 6; i < args->num_of_args; i++)
  {
    desc_flag = extract_text_descriptor(args,i,desc_name,filename,
                                    line_set,desc_text);
    if (desc_flag != 0)
      {
	if (strcmp(desc_name,"L") == 0 || strcmp(desc_name,"l") == 0)
	  {
	    length_flag = 1;
            if (desc_flag == 1)
	      {
               strcpy(length,desc_text);
  	       strcpy(pr_length,desc_text);
	      }
            else
	      {
               sprintf(length,"(%s)",desc_text);
               sprintf(pr_length,"\'%s\'",desc_text);
	      }
	  }
        else if (strcmp(desc_name,"W") == 0 || strcmp(desc_name,"w") == 0)
	  {
	    width_flag = 1;
            if (desc_flag == 1)
	      {
               strcpy(width,desc_text);
   	       strcpy(pr_width,desc_text);
	      }
            else
	      {
               sprintf(width,"(%s)",desc_text);
               sprintf(pr_width,"\'%s\'",desc_text);
	      }
	  }
        else if (strcmp(desc_name,"M") == 0 || strcmp(desc_name,"m") == 0)
	  {
	    m_flag = 1;
            if (desc_flag == 1)
  	       strcpy(m_value,desc_text);
            else
               sprintf(m_value,"\'%s\'",desc_text);
	  }
        else if (strcmp(desc_name,"GEO") == 0 || strcmp(desc_name,"geo") == 0)
	  {
	    geo_flag = 1;
            geo_value = (int)
                eval_paren_expr(desc_text,filename,line_set, param_list); 
	  }
        else if (strcmp(desc_name,"AD") == 0 || strcmp(desc_name,"ad") == 0)
	  {
	    ad_flag = 1;
            sprintf(as_ad_ps_pd[1],"'%s'",desc_text);
	  }
        else if (strcmp(desc_name,"AS") == 0 || strcmp(desc_name,"as") == 0)
	  {
	    as_flag = 1;
            sprintf(as_ad_ps_pd[0],"'%s'",desc_text);
	  }
        else if (strcmp(desc_name,"PD") == 0 || strcmp(desc_name,"pd") == 0)
	  {
	    pd_flag = 1;
            sprintf(as_ad_ps_pd[3],"'%s'",desc_text);
	  }
        else if (strcmp(desc_name,"PS") == 0 || strcmp(desc_name,"ps") == 0)
	  {
	    ps_flag = 1;
            sprintf(as_ad_ps_pd[2],"'%s'",desc_text);
	  }
      }
  }
if (length_flag == 0 || width_flag == 0)
  {
   printf("error in 'extract_mos':  either a width or length\n"); 
   printf(" descriptor is missing on line %d of spice file '%s'\n",linecount,
           filename);
   exit(1);
  }
if (geo_flag == 0)
   geo_value = 0;
if (m_flag == 0)
   strcpy(m_value,"1");

if (as_flag == 1 || ad_flag == 1 || ps_flag == 1 || pd_flag == 1)
  {
   if (as_flag == 0 || ad_flag == 0 || ps_flag == 0 || pd_flag == 0)
     {
       printf("error in 'extract_mos':  either as, ad, ps, or pd\n"); 
       printf(" descriptors were listed on line %d of spice file '%s'\n",
             linecount,filename);
       printf("  but not all of them!\n");
       exit(1);
     }
  }
else if (model_list->calc_diff_flag == 1)
  {
/********** set_mode_diff can be used to override geo settings ***/
   if (strcmp(model_list->mode_diff_string,"conservative") == 0)
      geo_value = 0;
   else if (strcmp(model_list->mode_diff_string,"drain_smaller") == 0)
      geo_value = 1;
   else if (strcmp(model_list->mode_diff_string,"source_smaller") == 0)
      geo_value = 2;
/*********** calculate drain and source ********/
/*************  areas and perimeters  **********/
   if (geo_value == 0)
     {
      sprintf(as_ad_ps_pd[0],"'hdout*%s'",width);
      sprintf(as_ad_ps_pd[1],"'hdout*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+2*%s'",width);
         sprintf(as_ad_ps_pd[3],"'2*hdout+2*%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+%s'",width);
         sprintf(as_ad_ps_pd[3],"'2*hdout+%s'",width);
	}
     }
   else if (geo_value == 1)
     {
      sprintf(as_ad_ps_pd[0],"'hdout*%s'",width);
      sprintf(as_ad_ps_pd[1],"'0.5*hdin*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+2*%s'",width);
         sprintf(as_ad_ps_pd[3],"'hdin+%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"'2*hdout+%s'",width);
         sprintf(as_ad_ps_pd[3],"hdin");
	}
     }
   else if (geo_value == 2)
     {
      sprintf(as_ad_ps_pd[0],"'0.5*hdin*%s'",width);
      sprintf(as_ad_ps_pd[1],"'hdout*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'hdin+%s'",width);
         sprintf(as_ad_ps_pd[3],"'2*hdout+2*%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"hdin");
         sprintf(as_ad_ps_pd[3],"'2*hdout+%s'",width);
	}
     }
   else if (geo_value == 3)
     {
      sprintf(as_ad_ps_pd[0],"'0.5*hdin*%s'",width);
      sprintf(as_ad_ps_pd[1],"'0.5*hdin*%s'",width);
      if (model_list->four_sided_perimeter_flag == 1)
	{
         sprintf(as_ad_ps_pd[2],"'hdin+%s'",width);
         sprintf(as_ad_ps_pd[3],"'hdin+%s'",width);
	}
      else
	{
         sprintf(as_ad_ps_pd[2],"hdin");
         sprintf(as_ad_ps_pd[3],"hdin");
	}
     }
    /* override previous geo setting */
    geo_value = 0;
  }

              
/*************  choose model ***************/
strcpy(model_name,args->arg_array[5]);
/*
need to evaluate length and width before you can use this - creates
   a problem when width and length are parameterized!

    choose_model(args->arg_array[5],width_value, length_value, filename,
                           linecount, model_list,model_name);
*/

line_set->num_of_lines = 4;
sprintf(line_set->line_array[0],"X%s %s %s %s %s\n",
	args->arg_array[0],args->arg_array[1],args->arg_array[2],
        args->arg_array[3],args->arg_array[4]);

if (geo_value != 0.0)
   sprintf(line_set->line_array[1],"+    %s len=%s wid=%s mul=%s geom=%d\n", 
        model_name, length, width, m_value, (int) geo_value);
else
   sprintf(line_set->line_array[1],"+    %s len=%s wid=%s mul=%s\n", 
        model_name, pr_length, pr_width, m_value);
if (ad_flag == 1 || model_list->calc_diff_flag == 1)
  {
  sprintf(line_set->line_array[2],"+    adrain=%s asource=%s\n",as_ad_ps_pd[1],
           as_ad_ps_pd[0]);
  sprintf(line_set->line_array[3],"+    pdrain=%s psource=%s\n",as_ad_ps_pd[3],
           as_ad_ps_pd[2]);
  }
else
  line_set->num_of_lines = 2;
free(args);
}

/* note:  par_name should be a string of the same size as
          arg->arg_array[i] array since no error checking on 
          writing operations to this variable is done  */
int extract_descriptor(ARGUMENT *args, int arg_num, char *desc_name, 
          char *filename, LINE *line_set,PARAM *param_list,double *desc_value)
{
int i;

if (arg_num >= args->num_of_args)
  {
    printf("error in 'extract_descriptor':  cannot extract descriptor\n");
    printf("from argument number %d because the total number of\n",arg_num);
    printf("  arguments is only %d\n",args->num_of_args);
    exit(1);
  }
for (i = 0; args->arg_array[arg_num][i] != '='  && 
            args->arg_array[arg_num][i] != '\0' && 
            args->arg_array[arg_num][i] != ' '      ; i++)
  desc_name[i] = args->arg_array[arg_num][i];
desc_name[i] = '\0';
for (   ; args->arg_array[arg_num][i] == ' '; i++);
if (args->arg_array[arg_num][i] != '=')
   return(0);
/* note:  contents of args->arg_array[arg_num] are 
          destroyed by eval_paren_expr */
*desc_value = eval_paren_expr(&(args->arg_array[arg_num][i+1]),filename,
			    line_set, param_list); 
return(1);
}

/* note:  par_name should be a string of the same size as
          arg->arg_array[i] array since no error checking on 
          writing operations to this variable is done  */
int extract_text_descriptor(ARGUMENT *args, int arg_num, char *desc_name, 
          char *filename, LINE *line_set,char *desc_value)
{
int i,quote_flag;

quote_flag = 1;
if (arg_num >= args->num_of_args)
  {
    printf("error in 'extract_descriptor':  cannot extract descriptor\n");
    printf("from argument number %d because the total number of\n",arg_num);
    printf("  arguments is only %d\n",args->num_of_args);
    printf("  line reads:\n");
    send_line_set_to_std_output(line_set);
    exit(1);
  }
for (i = 0; args->arg_array[arg_num][i] != '='  && 
            args->arg_array[arg_num][i] != '\0' && 
            args->arg_array[arg_num][i] != ' '      ; i++)
  desc_name[i] = args->arg_array[arg_num][i];
desc_name[i] = '\0';
for (   ; args->arg_array[arg_num][i] == ' '; i++);
if (args->arg_array[arg_num][i] != '=')
   return(0);
/* note:  contents of args->arg_array[arg_num] are 
          destroyed by eval_paren_expr */
i++;
for (   ; args->arg_array[arg_num][i] == ' '; i++);
if (args->arg_array[arg_num][i] == '\'')
  {
  quote_flag = 2;
  i++;
  }
strcpy(desc_value,&(args->arg_array[arg_num][i]));
for (i = 0; desc_value[i] != '\0'; i++)
   if (desc_value[i] == '\'')
     {
      desc_value[i] = '\0';
      break;
     }
return(quote_flag);
}




/* looks for model provided in par file; if not found, netlist model
   remains unchanged */
char *choose_model(char *netlist_model, double width_value, 
     double length_value, char *filename, int linecount, 
     MODEL *model_list, char *model_name)
{
int i, found_right_model_flag;

found_right_model_flag = 0;

switch(netlist_model[0])
  {
  case 'p':
  case 'P':
     
    for (i = 0; i < model_list->p_model_list_length; i++)
      if (length_value >= model_list->p_model_list_sizes[i][0]  &&
	  length_value <= model_list->p_model_list_sizes[i][1]  &&
	  width_value >= model_list->p_model_list_sizes[i][2]  &&
	  width_value <= model_list->p_model_list_sizes[i][3])
	{
	  found_right_model_flag = 1;
	  sprintf(model_name,"%s",model_list->p_model_list[i]);
	}
    break;
  case 'n':
  case 'N':
    for (i = 0; i < model_list->n_model_list_length; i++)
      if (length_value >= model_list->n_model_list_sizes[i][0]  &&
	  length_value <= model_list->n_model_list_sizes[i][1]  &&
	  width_value >= model_list->n_model_list_sizes[i][2]  &&
	  width_value <= model_list->n_model_list_sizes[i][3])
	{
	  found_right_model_flag = 1;
	  sprintf(model_name,"%s",model_list->n_model_list[i]);
	}
    break;
  default:
    printf("error in 'choose_model':  netlist model name does not\n");
    printf("   begin with 'n' or 'p'\n");
    printf("   netlist model is '%s'\n",netlist_model);
    printf("  error occurred on line %d of spice file '%s'\n",linecount,
              filename);
    exit(1);
  }


if (found_right_model_flag == 0)
  {
   sprintf(model_name,"%s",netlist_model);
  }

return(model_name);
}


void obtain_skew_parameters(FILE *in, 
      char process[][MAX_CHAR_LENGTH], int *num_processes, 
      char temp[][MAX_CHAR_LENGTH], int *num_temps,
      char param_name[][MAX_CHAR_LENGTH], int *num_param_names,
      char param_value[][MAX_NUM_SKEW_ARGS][MAX_CHAR_LENGTH], int *num_param_values)
{
int first_char;
int i,j,end_of_file_flag;
LINE *line_set;
ARGUMENT *args;
int param_name_count;
int linecount;

*num_processes = 0;
*num_temps = 0;
*num_param_names = 0;
param_name_count = 0;

linecount = 0;
line_set = init_line();
args = init_argument();

end_of_file_flag = 0;

while(1)
  {
   line_set->num_of_lines = 0;
   if (fgets(line_set->line_array[line_set->num_of_lines],LINESIZE-1,in) == NULL)
       {
       printf("premature file end after a > skew command!\n");
       exit(1);
       }
   line_set->num_of_lines++;
   extract_arguments(line_set,"input file",linecount,args);

   if (strcmp(args->arg_array[0],">") != 0)
     {
      printf("error in 'obtain_skew_parameters':  > skew must\n");
      printf("  must be ended with > end_skew\n");
      printf(" line reads:  %s ...\n", args->arg_array[0]);
      exit(1);
     }
   if (strcmp(args->arg_array[1],"end_skew") == 0)
     {
      *num_param_names = param_name_count;
      break;
     }
   else if (strcmp(args->arg_array[1],"process") == 0)
     {
      if ((args->num_of_args-2) >= MAX_NUM_SKEW_ARGS)
	{
        printf("error in 'obtain_skew_parameters':  too many process args\n");
        printf("  must increase MAX_NUM_SKEW_ARGS\n");
        exit(1);
	}
      for (i = 2; i < args->num_of_args; i++)
         sprintf(process[i-2],"%s",args->arg_array[i]);
      *num_processes = i-2;
     }
   else if (strcmp(args->arg_array[1],"temp") == 0)
     {
      if ((args->num_of_args-2) >= MAX_NUM_SKEW_ARGS)
	{
        printf("error in 'obtain_skew_parameters':  too many temp args\n");
        printf("  must increase MAX_NUM_SKEW_ARGS\n");
        exit(1);
	}
      for (i = 2; i < args->num_of_args; i++)
         sprintf(temp[i-2],"%s",args->arg_array[i]);
      *num_temps = i-2;
     }
   else 
     {
      if (param_name_count >= MAX_NUM_SKEW_PARAM)
	{
         printf("error in 'obtain_skew_parameters':  max num parameters exceeded\n");
         printf("cannot have more than %d parameters when using > skew\n",
               MAX_NUM_SKEW_PARAM);
         printf("  last parameter name read:  %s\n",args->arg_array[1]);
         exit(1);
	}
      if ((args->num_of_args-2) >= MAX_NUM_SKEW_ARGS)
	{
        printf("error in 'obtain_skew_parameters':  too many args\n");
        printf(" for parameter '%s'\n",args->arg_array[1]);
        printf("  must increase MAX_NUM_SKEW_ARGS\n");
        exit(1);
	}
      sprintf(param_name[param_name_count],"%s",args->arg_array[1]);
      for (i = 2; i < args->num_of_args; i++)
         sprintf(param_value[param_name_count][i-2],"%s",args->arg_array[i]);
      num_param_values[param_name_count] = i-2;
      param_name_count++;
     }
  }


free(line_set);
free(args);
}


/*  This function uses my previous style of extracting arguments - not
    very elegant!  However, I don't feel like redoing it right now.   */

MODEL *obtain_model_and_par_list(char *model_file_name,PARAM *par_list,
	      MODEL *models, LINE *added_lines, LINE *appended_lines,
              LINE *deleted_lines, LINE *input_lines, int *mismatch_flag,
              char *case_string, int ngspice_flag)
{
FILE *model_file;
char inpline[LINESIZE],arg_list[6][MAX_ARG];
 int i,j,linecount,arg_count,error_flag,input_stimulus_flag,k;
int found_out_diff_flag,found_in_diff_flag,found_models_flag,ng_found_analysis_flag;
int found_mode_diff_flag,switch_flag;
char process[MAX_NUM_SKEW_ARGS][MAX_CHAR_LENGTH];
char temp[MAX_NUM_SKEW_ARGS][MAX_CHAR_LENGTH];
char param_name[MAX_NUM_SKEW_PARAM][MAX_CHAR_LENGTH];
char param_value[MAX_NUM_SKEW_PARAM][MAX_NUM_SKEW_ARGS][MAX_CHAR_LENGTH];
int num_processes, num_temps, num_param_names, num_param_values[MAX_NUM_ARGS];
int k0,k1,k2,k3;
char tempstring[LINESIZE], tempstring2[LINESIZE];
LINE *temp_lines;


if ((model_file = fopen(model_file_name,"r")) == NULL)
  {
   printf("error in 'obtain_model_and_par_list': can't open model/par file '%s'\n",
	       model_file_name);
   exit(1);
}

temp_lines = init_line();
linecount=0;
found_out_diff_flag=0;
found_in_diff_flag=0;
found_mode_diff_flag=0;
found_models_flag=0;
ng_found_analysis_flag=0;
models->four_sided_perimeter_flag=0;


while(1)
  {
    linecount++;
    if (fgets(inpline,LINESIZE-1,model_file) == NULL)
      break;
    arg_count = 0;
    for (i = 0; inpline[i] == ' '; i++);
    if (inpline[i] == '*' || inpline[i] == '\0' || inpline[i] == '\n')
      continue;
/*    digital stimulus lines */
    input_stimulus_flag = 0;
    if (inpline[i] == '>')
      {
	for (j = i+1; inpline[j] == ' '; j++);
	if (strncmp(&inpline[j],"timing",6) == 0 ||
            strncmp(&inpline[j],"input",5) == 0)
	  input_stimulus_flag = 1;
      }
    if (inpline[i] == '>' && input_stimulus_flag == 1)
      {
      if (input_lines->num_of_lines >= MAX_NUM_LINES)
	 {
	  printf("error in 'obtain_model_and_par_list':	 too many 'input' lines\n");
	  printf(" (i.e. lines starting with '>') encountered in model/par file\n");
	  printf("  error occurred in model/par file '%s', line %d\n",
		    model_file_name,linecount);
	  printf("  input_lines count:   %d\n",input_lines->num_of_lines);
	  printf("  line reads:	 %s\n",inpline);
	  exit(1);
	 }
      i++;
      for (   ; inpline[i] == ' '; i++);
      sprintf(input_lines->line_array[input_lines->num_of_lines],"%s",
	      &inpline[i]);
      input_lines->num_of_lines++;
      continue;
      }
/*    lines to be deleted from output file */
    else if (inpline[i] == '-' && inpline[i+1] == ' ')
      {
      if (deleted_lines->num_of_lines >= MAX_NUM_LINES)
	 {
	  printf("error in 'obtain_model_and_par_list':	 too many 'delete' lines\n");
	  printf(" (i.e. lines starting with '-') encountered in model/par file\n");
	  printf("  error occurred in model/par file '%s', line %d\n",
		    model_file_name,linecount);
	  printf("  deleted_lines count:   %d\n",deleted_lines->num_of_lines);
	  printf("  line reads:	 %s\n",inpline);
	  exit(1);
	 }
      i++;
      for (   ; inpline[i] == ' '; i++);
      sprintf(deleted_lines->line_array[deleted_lines->num_of_lines],"%s",
	      &inpline[i]);
      deleted_lines->num_of_lines++;
      continue;
      }
/*    lines to be appended to end of output file - GAR01 */
    else if (inpline[i] == '!')
      {
      if (appended_lines->num_of_lines >= MAX_NUM_LINES)
	 {
	  printf("error in 'obtain_model_and_par_list':	 too many append lines\n");
	  printf(" (i.e. lines starting with '&') encountered in model/par file\n");
	  printf("  error occurred in model/par file '%s', line %d\n",
		    model_file_name,linecount);
	  printf("  appended_lines count:	%d\n",appended_lines->num_of_lines);
	  printf("  line reads:	 %s\n",inpline);
	  exit(1);
	 }
      i++;
      for (   ; inpline[i] == ' '; i++);
      sprintf(appended_lines->line_array[appended_lines->num_of_lines],"%s",
	      &inpline[i]);
      appended_lines->num_of_lines++;
      continue;
      }
/* setting of out_diff_width, in_diff_width, variables, and model parameters */
    else if (inpline[i] == '>')
      {
	/* for debugging: */
      sprintf(temp_lines->line_array[0],"%s",inpline);
      temp_lines->num_of_lines = 1;
      /****************************/

    i++;
    for (    ; inpline[i] == ' '; i++);    
/*  pull off arguments */
    while(1)
      {   
        if (arg_count >= 6)
	  {
	    printf("error in 'obtain_model_and_par_list':  max number of arguments exceeded\n");
	    printf("     in model/par file '%s' on line %d\n",
                     model_file_name,linecount);
            printf(" line reads:  %s\n",inpline);
	    exit(1);
	  } 
	for (j = 0; inpline[i] != ' ' && inpline[i] != '\n' &&
                   inpline[i] != '\0'; i++,j++)
	  {
	    if (j-1 >= MAX_ARG)
	      {
		printf("error in 'obtain_model_and_par_list':  max argument size exceeded\n");
		printf("     in model/par file '%s' on line %d\n",
                     model_file_name,linecount);
		printf(" line reads:  %s\n",inpline);
		printf("      to fix error, change MAX_ARG in source code\n");
		exit(1);
	      }
	    arg_list[arg_count][j] = inpline[i];
	  }
	arg_list[arg_count][j] = '\0';
	if (inpline[i] == ' ')
	  for (    ; inpline[i] == ' '; i++);
	arg_count++;
	if (inpline[i] == '\0' || inpline[i] == '\n')
	  break;
      }

    /* printf("%s\n",arg_list[0]); */
/* check if 'model' command found */
    if (strcmp(arg_list[0],"model") == 0)
      {
       /*******************************************************************/
	/* models statement is no longer supported due to need to
           evaluate width and length of transistors */

        printf("error:  model statements are no longer supported\n'");
        exit(1);
       /*******************************************************************/
       found_models_flag=1;
       if (arg_count != 6)
	 {
          printf("error in 'obtain_model_and_par_list':  need 6 arguments total for\n");
          printf("  `model' statement in model/par file\n");
          printf("  error occurred in model/par file '%s', line %d\n",
                 model_file_name,linecount);
          printf("  argument count:  %d\n",arg_count);
          printf("  line reads:  %s\n",inpline);
          exit(1);
	}
       switch(arg_list[1][0])
	 {
	 case 'N':
	 case 'n':
	   if (models->n_model_list_length >= LENGTH_MODEL_LIST)
	     {
	       printf("error in 'obtain_model_and_par_list':  maximum allowable number of\n");
	       printf(" n `model' statements in model/par file exceeded\n");
	       printf("  error occurred in model/par file '%s', line %d\n",
		      model_file_name,linecount);
	       printf(" n model count:  %d\n",models->n_model_list_length+1);
	       printf("  line reads:  %s\n",inpline);
	       printf("   to fix, change LENGTH_MODEL_LIST in source code\n");
	       exit(1);
	     }
	   
	   sprintf(models->n_model_list[models->n_model_list_length],"%s",arg_list[1]);
	   for (i = 0; i < 4; i++)
	     {
	       models->n_model_list_sizes[models->n_model_list_length][i] = 
		 convert_string(arg_list[i+2],model_file_name,temp_lines,&error_flag);
	       if (error_flag == 1)
		 {
		   printf("error in 'obtain_model_and_par_list':  sizes in 'model' statements\n");
		   printf("  in model/par file must not contain variables\n");
		   printf("  error occurred in model/par file '%s', line %d\n",
			  model_file_name,linecount);
		   printf("  line reads:  %s\n",inpline);
		   exit(1);
		 }	   
	     }
	   models->n_model_list_length++;
	   break;

	 case 'P':
	 case 'p':
	   if (models->p_model_list_length >= LENGTH_MODEL_LIST)
	     {
	       printf("error in 'obtain_model_and_par_list':  maximum allowable numbqer of\n");
	       printf(" p `model' statements in model/par file exceeded\n");
	       printf("  error occurred in model/par file '%s', line %d\n",
		      model_file_name,linecount);
	       printf(" p model count:  %d\n",models->p_model_list_length+1);
	       printf("  line reads:  %s\n",inpline);
	       printf("   to fix, change LENGTH_MODEL_LIST in source code\n");
	       exit(1);
	     }
	   
	   sprintf(models->p_model_list[models->p_model_list_length],"%s",arg_list[1]);
	   for (i = 0; i < 4; i++)
	     {
	       models->p_model_list_sizes[models->p_model_list_length][i] = 
		 convert_string(arg_list[i+2],model_file_name,temp_lines,&error_flag);
	       if (error_flag == 1)
		 {
		   printf("error in 'obtain_model_and_par_list':  sizes in 'model' statements\n");
		   printf("  in model/par file must not contain variables\n");
		   printf("  error occurred in model/par file '%s', line %d\n",
			  model_file_name,linecount);
		   printf("  line reads:  %s\n",inpline);
		   exit(1);
		 }	   
	     }
	   models->p_model_list_length++;
	   break;
	 default:
	   printf("error in 'obtain_model_and_par_list':  hspice model names found in 'model'\n");
	   printf("     statements must start with either an n (NMOS) or p (PMOS)\n");
	   printf("     this rule was violated in model/par file '%s', line %d\n",
		  model_file_name,linecount);
	   printf("    line reads:  %s\n",inpline);
exit(1);
	 }

     }
/* check if 'set' command found */
    else if (strcmp(arg_list[0],"set") == 0)
      {
       if (arg_count != 3)
	 {
          printf("error in 'obtain_model_and_par_list':  need 3 arguments total for\n");
          printf("  `set' statement in model/par file\n");
          printf("  error occurred in model/par file '%s', line %d\n",
                 model_file_name,linecount);
          printf("  argument count:  %d\n",arg_count);
          printf("  line reads:  %s\n",inpline);
          exit(1);
	}
       if (par_list->main_par_length >= LENGTH_PAR_LIST)
	 {
          printf("error in 'obtain_model_and_par_list':  maximum allowable number of\n");
          printf("  `set' statements in model/par file exceeded\n");
          printf("  error occurred in model/par file '%s', line %d\n",
                 model_file_name,linecount);
          printf("  param count:  %d\n",par_list->main_par_length+1);
          printf("  line reads:  %s\n",inpline);
          printf("   to fix, change LENGTH_PAR_LIST in source code\n");
          exit(1);
	}
       sprintf(par_list->main_par_list[par_list->main_par_length],"%s",arg_list[1]);

       par_list->main_par_val[par_list->main_par_length] = 
	 convert_string(arg_list[2],model_file_name,temp_lines,&error_flag);
       if (error_flag == 1)
	 {
	   printf("error in 'obtain_model_and_par_list':  values in 'set' statements\n");
	   printf("  in model/par file must not contain variables\n");
	   printf("  error occurred in model/par file '%s', line %d\n",
		  model_file_name,linecount);
	   printf("  line reads:  %s\n",inpline);
	   exit(1);
	 }
       par_list->main_par_length++;	   
     }
/* check if 'set_mode_diff' command found */
    else if (strcmp(arg_list[0],"set_mode_diff") == 0)
      {
	found_mode_diff_flag=1;
	if (arg_count != 2)
	  {
	    printf("error in 'obtain_model_and_par_list':  need 2 arguments total for\n");
	    printf("  `set_mode_diff' statement in model/par file\n");
	    printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
	    printf("  argument count:  %d\n",arg_count);
	    printf("  line reads:  %s\n",inpline);
	    exit(1);
	  }
        if (strcmp(arg_list[1],"conservative") != 0 &&
            strcmp(arg_list[1],"drain_smaller") != 0 &&
            strcmp(arg_list[1],"source_smaller") != 0 &&
            strcmp(arg_list[1],"geo") != 0)
	  {
          printf("error in 'obtain_model_and_par_list':\n");
          printf("  set_mode_diff must be set to either\n");
          printf("  conservative, drain_smaller, source_smaller, or geo\n");
          printf("  in this case, the line reads: %s\n",inpline);
	  printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
          exit(1);
	  }
	sprintf(models->mode_diff_string,"%s",arg_list[1]);
      }
/* check if 'set_hdout' command found */
    else if (strcmp(arg_list[0],"set_hdout") == 0)
      {
	found_out_diff_flag=1;
	if (arg_count != 2)
	  {
	    printf("error in 'obtain_model_and_par_list':  need 2 arguments total for\n");
	    printf("  `set_out_diff' statement in model/par file\n");
	    printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
	    printf("  argument count:  %d\n",arg_count);
	    printf("  line reads:  %s\n",inpline);
	    exit(1);
	  }
	models->out_diff_size = 
	  convert_string(arg_list[1],model_file_name,temp_lines,&error_flag);
	if (error_flag == 1)
	  {
	    printf("error in 'obtain_model_and_par_list':  values in 'set_out_diff' statements\n");
	    printf("  in model/par file must not contain variables\n");
	    printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
	    printf("  line reads:  %s\n",inpline);
	    exit(1);
	  }	   
	/* space in added_lines was already reserved for this */
        sprintf(added_lines->line_array[0],
            ".param hdout=%5.3e\n",models->out_diff_size);
      }
/* check if 'set_hdin' command found */
    else if (strcmp(arg_list[0],"set_hdin") == 0)
      {
	found_in_diff_flag=1;
	if (arg_count != 2)
	  {
	    printf("error in 'obtain_model_and_par_list':  need 2 arguments total for\n");
	    printf("  `set_in_diff' statement in model/par file\n");
	    printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
	    printf("  argument count:  %d\n",arg_count);
	    printf("  line reads:  %s\n",inpline);
	    exit(1);
	  }
	models->in_diff_size = 
	  convert_string(arg_list[1],model_file_name,temp_lines,&error_flag);
	if (error_flag == 1)
	  {
	    printf("error in 'obtain_model_and_par_list':  values in 'set_in_diff' statements\n");
	    printf("  in model/par file must not contain variables\n");
	    printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
	    printf("  line reads:  %s\n",inpline);
	    exit(1);
	  }	   
	/* space in added_lines was already reserved for this */
        sprintf(added_lines->line_array[1],
              ".param hdin=%5.3e\n",models->in_diff_size);
      }
/* check if 'use_four_sided_perimeter' command found */
    else if (strcmp(arg_list[0],"use_four_sided_perimeter") == 0)
      {
	if (arg_count != 1)
	  {
	    printf("error in 'obtain_model_and_par_list':\n");
	    printf("  `use_four_sided_perimeter' statement in model/par file\n");
            printf("   should have no arguments following it\n");
	    printf("  error occurred in model/par file '%s', line %d\n",
		   model_file_name,linecount);
	    printf("  argument count:  %d\n",arg_count);
	    printf("  line reads:  %s\n",inpline);
	    exit(1);
	  }
	models->four_sided_perimeter_flag = 1; 
      }
/* check if 'case_switch' command found */
    else if (strcmp(arg_list[0],"case_switch") == 0)
      {
	/* printf("case = %s\n",case_string); */
      switch_flag = 0;
      while(1)
	{
        if (fgets(inpline,LINESIZE-1,model_file) == NULL)
          {
          printf("error in 'obtain_model_and_par_list':  file ends\n");
          printf("  after the statement 'begin_case' but before 'end_case'\n");
          exit(1);
          }
        linecount++;
        for (i = 0; inpline[i] == ' '; i++);
        if (inpline[i] == '*' || inpline[i] == '\0' || inpline[i] == '\n')
           continue;
	for (j = 0; inpline[i] != ' ' && inpline[i] != '\n' &&
                   inpline[i] != '\0'; i++,j++)
	  {
	    if (j-1 >= MAX_ARG)
	      {
		printf("error in 'obtain_model_and_par_list':  max argument size exceeded\n");
		printf("     in model/par file '%s' on line %d\n",
                     model_file_name,linecount);
		printf(" line reads:  %s\n",inpline);
		printf("      to fix error, change MAX_ARG in source code\n");
		exit(1);
	      }
	    arg_list[0][j] = inpline[i];
	  }
        arg_list[0][j] = '\0';
        if (arg_list[0][j-1] == ':')
	  {
           arg_list[0][j-1] = '\0';
           if (strcmp(arg_list[0],case_string) == 0)
              switch_flag = 1;
           else
              switch_flag = 0;
	  }
        else if (strcmp(arg_list[0],"end_case") == 0)
	  {
           break;
	  }
        else
	  {
           if (switch_flag == 1)
	     {
             if (added_lines->num_of_lines >= MAX_NUM_LINES)
	        {
	        printf("error in 'obtain_model_and_par_list':	 too many include lines\n");
	        printf("  encountered in model/par file\n");
	        printf("  error occurred in model/par file '%s', line %d\n",
		    model_file_name,linecount);
	        printf("  added_lines count:	%d\n",added_lines->num_of_lines);
	        printf("  line reads:	 %s\n",inpline);
	        exit(1);
	        }
             sprintf(added_lines->line_array[added_lines->num_of_lines],"%s",
 	         inpline);
             added_lines->num_of_lines++;
	     }
	  }
	}
      }


/* check if 'mismatch' command found */
    else if (strcmp(arg_list[0],"mismatch") == 0)
      {
       *mismatch_flag = 1;
      }

/* check if 'skew' command found */
    else if (strcmp(arg_list[0],"skew") == 0)
      {
       for (i = 0; i < MAX_NUM_ARGS; i++)
          num_param_values[i] = 0;
       obtain_skew_parameters(model_file, process, &num_processes,temp, &num_temps,
         param_name, &num_param_names,param_value,num_param_values);
       if (num_processes < 2)
	 {
         printf("error in 'obtain_model_and_par_list':  must\n");
         printf("   include library definition and specify at least\n");
         printf("   one process value when using > skew\n");
         printf("  example:  > process 'example.lib' ss\n");
         exit(1);
	 }
       if (num_temps < 1)
	 {
         printf("error in 'obtain_model_and_par_list':  must specify at least\n");
         printf("   one temp value when using > skew\n");
         printf("  example:  > temp 125\n");
         exit(1);
	 }

       /*       
       for (i = 0; i < 4; i++)
          printf("num_param[%d] = %d\n",i,num_param_values[i]);
       */

       /*  note:  num_param_names < MAX_NUM_SKEW_PARAM=4 */
       if (num_param_names == 0)
	 {
          for (i = 1; i < num_processes; i++) /* first process arg is library */
            for (j = 0; j < num_temps; j++)
	      {
               sprintf(tempstring,".alter (proc,temp)=(%s,%s)\n",process[i],temp[j]);
               add_appended_line(appended_lines,tempstring);
               sprintf(tempstring,".prot\n.lib %s %s\n.unprot\n",process[0],process[i]);
               add_appended_line(appended_lines,tempstring);
               sprintf(tempstring,".temp %s\n\n",temp[j]);
               add_appended_line(appended_lines,tempstring);
	      }
	 }
       else if (num_param_names == 1)
	 {
          for (i = 1; i < num_processes; i++) /* first process arg is library */
            for (j = 0; j < num_temps; j++)
              for (k0 = 0; k0 < num_param_values[0]; k0++)
	        {
                 sprintf(tempstring,".alter (proc,temp,%s)=(%s,%s,%s)\n",
                      param_name[0],process[i],temp[j],param_value[0][k0]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".prot\n.lib %s %s\n.unprot\n",process[0],process[i]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".temp %s\n",temp[j]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n\n",param_name[0],param_value[0][k0]);
                 add_appended_line(appended_lines,tempstring);
	        }
	 }
       else if (num_param_names == 2)
	 {
          for (i = 1; i < num_processes; i++) /* first process arg is library */
            for (j = 0; j < num_temps; j++)
              for (k0 = 0; k0 < num_param_values[0]; k0++)
              for (k1 = 0; k1 < num_param_values[1]; k1++)
	        {
                 sprintf(tempstring,".alter (proc,temp,%s,%s)=(%s,%s,%s,%s)\n",
                      param_name[0],param_name[1],
                      process[i],temp[j],
                      param_value[0][k0],param_value[1][k1]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".prot\n.lib %s %s\n.unprot\n",process[0],process[i]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".temp %s\n",temp[j]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n",param_name[0],param_value[0][k0]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n\n",param_name[1],param_value[1][k1]);
                 add_appended_line(appended_lines,tempstring);
	        }
	 }
       else if (num_param_names == 3)
	 {
          for (i = 1; i < num_processes; i++) /* first process arg is library */
            for (j = 0; j < num_temps; j++)
              for (k0 = 0; k0 < num_param_values[0]; k0++)
              for (k1 = 0; k1 < num_param_values[1]; k1++)
              for (k2 = 0; k2 < num_param_values[1]; k2++)
	        {
                 sprintf(tempstring,".alter (proc,temp,%s,%s,%s)=(%s,%s,%s,%s,%s)\n",
                      param_name[0],param_name[1],param_name[2],
                      process[i],temp[j],
                      param_value[0][k0],param_value[1][k1],param_value[2][k2]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".prot\n.lib %s %s\n.unprot\n",process[0],process[i]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".temp %s\n",temp[j]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n",param_name[0],param_value[0][k0]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n",param_name[1],param_value[1][k1]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n\n",param_name[2],param_value[2][k2]);
                 add_appended_line(appended_lines,tempstring);
	        }
	 }
       else if (num_param_names == 4)
	 {
          for (i = 1; i < num_processes; i++) /* first process arg is library */
            for (j = 0; j < num_temps; j++)
              for (k0 = 0; k0 < num_param_values[0]; k0++)
              for (k1 = 0; k1 < num_param_values[1]; k1++)
              for (k2 = 0; k2 < num_param_values[1]; k2++)
              for (k3 = 0; k3 < num_param_values[1]; k3++)
	        {
                 sprintf(tempstring,".alter (proc,temp,%s,%s,%s,%s)=(%s,%s,%s,%s,%s,%s)\n",
                      param_name[0],param_name[1],param_name[2],param_name[3],
                      process[i],temp[j],
                      param_value[0][k0],param_value[1][k1],param_value[2][k2],
                      param_value[3][k3]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".prot\n.lib %s %s\n.unprot\n",process[0],process[i]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".temp %s\n",temp[j]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n",param_name[0],param_value[0][k0]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n",param_name[1],param_value[1][k1]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n",param_name[2],param_value[2][k2]);
                 add_appended_line(appended_lines,tempstring);
                 sprintf(tempstring,".param %s = %s\n\n",param_name[3],param_value[3][k3]);
                 add_appended_line(appended_lines,tempstring);
	        }
	 }
       else
	 {
          printf("error in 'obtain_model_and_par_list':  num_param_names > 4 ???\n");
          exit(1);
	 }
      }
    else
      {
	printf("error in 'obtain_model_and_par_list':  unrecognized command found\n");
	printf("  in model/par file\n");
	printf("  error occurred in model/par file '%s', line %d\n",
	       model_file_name,linecount);
	printf("  line reads:  %s\n",inpline);
        printf(" acceptable commands:  set, model, set_out_diff\n");
	exit(1);
      }
      }
/*    lines to be included into output file */
    else
      {
      if (added_lines->num_of_lines >= MAX_NUM_LINES)
	 {
	  printf("error in 'obtain_model_and_par_list':	 too many include lines\n");
	  printf(" (i.e. lines starting with '!') encountered in model/par file\n");
	  printf("  error occurred in model/par file '%s', line %d\n",
		    model_file_name,linecount);
	  printf("  added_lines count:	%d\n",added_lines->num_of_lines);
	  printf("  line reads:	 %s\n",inpline);
	  exit(1);
	 }

      if (strncmp(&inpline[i],".probe",6) == 0 || strncmp(&inpline[i],".PROBE",6) == 0)
	{
	  strcpy(tempstring,inpline);
	  inpline[i+6] = '\0';
	  for (k = 0; tempstring[k] != ' ' && tempstring[k] != '\0' && tempstring[k] != '\n'; k++);
          for (     ; tempstring[k] == ' '; k++);
	  while (tempstring[k] != '\n' && tempstring[k] != '\0')
	    {
	     for (j = 0; tempstring[k] != ' ' && tempstring[k] != '\0' && tempstring[k] != '\n'; k++, j++)
	        tempstring2[j] = tempstring[k];
             for (     ; tempstring[k] == ' '; k++);
	     tempstring2[j] = '\0';
	     for (j = 0; tempstring2[j] != '\0' && tempstring2[j] != '(' && tempstring2[j] != ')' &&
		         tempstring2[j] != '[' && tempstring2[j] != ']' && tempstring2[j] != '@'; j++);
	     if (tempstring2[j] == '\0')
	       {
		 strcat(inpline," v(");
                 strcat(inpline,tempstring2);
                 strcat(inpline,")");
	       }
             else
	       {
		 strcat(inpline," ");
                 strcat(inpline,tempstring2);
	       }
	    }
	  strcat(inpline,"\n");
	}

      if (ngspice_flag == 1 && 
          (strncmp(&inpline[i],".probe",6) == 0 || strncmp(&inpline[i],".PROBE",6) == 0))
	{
	  inpline[i+1] = 's';
	  inpline[i+2] = 'a';
	  inpline[i+3] = 'v';
	  inpline[i+4] = 'e';
	  inpline[i+5] = ' ';
	} 
      else if (ngspice_flag == 1 && 
          (strncmp(&inpline[i],".tran",5) == 0 || strncmp(&inpline[i],".TRAN",5) == 0))
	{
	  if (ng_found_analysis_flag == 1)
	    {
	      ng_found_analysis_flag = 2;
	      printf("*WARNING: CppSimView (and loadsig) will only read one analysis (.tran, .ac, .noise, or .dc) per run*\n\n");  
	    }
          else if (ng_found_analysis_flag == 0)
	     ng_found_analysis_flag = 1;
	} 
      else if (ngspice_flag == 1 && 
          (strncmp(&inpline[i],".ac",3) == 0 || strncmp(&inpline[i],".AC",3) == 0))
	{
	  if (ng_found_analysis_flag == 1)
	    {
	      ng_found_analysis_flag = 2;
	      printf("*WARNING: CppSimView (and loadsig) will only read one analysis (.tran, .ac, .noise, or .dc) per run*\n\n");  
	    }
          else if (ng_found_analysis_flag == 0)
	     ng_found_analysis_flag = 1;
	} 
      else if (ngspice_flag == 1 && 
          (strncmp(&inpline[i],".noise",6) == 0 || strncmp(&inpline[i],".NOISE",6) == 0))
	{
	  if (ng_found_analysis_flag == 1)
	    {
	      ng_found_analysis_flag = 2;
	      printf("*WARNING: CppSimView (and loadsig) will only read one analysis (.tran, .ac, .noise, or .dc) per run*\n\n");  
	    }
          else if (ng_found_analysis_flag == 0)
	     ng_found_analysis_flag = 1;
	} 
      else if (ngspice_flag == 1 && 
          (strncmp(&inpline[i],".dc",3) == 0 || strncmp(&inpline[i],".DC",3) == 0))
	{
	  if (ng_found_analysis_flag == 1)
	    {
	      ng_found_analysis_flag = 2;
	      printf("*WARNING: CppSimView (and loadsig) will only read one analysis (.tran, .ac, .noise, or .dc) per run*\n\n");  
	    }
          else if (ng_found_analysis_flag == 0)
	     ng_found_analysis_flag = 1;
	} 
      sprintf(added_lines->line_array[added_lines->num_of_lines],"%s",
	      &inpline[i]);
      added_lines->num_of_lines++;
      continue;
      }
  }

if (found_out_diff_flag != 0 || found_mode_diff_flag != 0 || found_in_diff_flag != 0)
  {
   models->calc_diff_flag = 1;
   if (found_out_diff_flag == 0)
     {
      printf("error in 'obtain_model_and_par_list':  didn't find the command 'set_out_diff'\n");
      printf("   error occurred in model/par file '%s'\n",model_file_name);
      exit(1);
     }
   if (found_mode_diff_flag == 0)
     {
      printf("error in 'obtain_model_and_par_list':  didn't find the command 'set_mode_diff'\n");
      printf("   error occurred in model/par file '%s'\n",model_file_name);
      exit(1);
     }
   /*   if (found_in_diff_flag == 0) */
   if (strcmp(models->mode_diff_string,"conservative") != 0 
       && found_in_diff_flag == 0)
     {
      printf("error in 'obtain_model_and_par_list':  didn't find the command 'set_in_diff'\n");
      printf("   error occurred in model/par file '%s'\n",model_file_name);
      exit(1);
     }
  }
else
  {
   models->calc_diff_flag = 0;
  }

/* if (found_models_flag == 0)
  {
   printf("error in 'obtain_model_and_par_list':  didn't find any 'model' statements\n");
   printf("   error occurred in model/par file '%s'\n",model_file_name);
   exit(1);
   } */

fclose(model_file);

return(models);
}


LINE *init_line()
{   
LINE *A;   
   
if ((A = (LINE *) malloc(sizeof(LINE))) == NULL)   
   {   
   printf("error in 'init_line':  malloc call failed\n");   
   printf("out of memory!\n");   
   exit(1);   
  }   
A->num_of_lines = 0;
return(A);   
}   

ARGUMENT *init_argument()
{   
ARGUMENT *A;   
   
if ((A = (ARGUMENT *) malloc(sizeof(ARGUMENT))) == NULL)   
   {   
   printf("error in 'init_argument':  malloc call failed\n");   
   printf("out of memory!\n");   
   exit(1);   
  }   
A->num_of_args = 0;
return(A);   
}   


PARAM *init_param()
{   
PARAM *A;   
   
if ((A = (PARAM *) malloc(sizeof(PARAM))) == NULL)   
   {   
   printf("error in 'init_param':  malloc call failed\n");   
   printf("out of memory!\n");   
   exit(1);   
  }   
A->main_par_length = 0;
A->nest_length = 0;
A->param_not_found = -1;  // error checked - see eval_no_paren_expr()
return(A);   
}   


MODEL *init_model()
{   
MODEL *A;   
   
if ((A = (MODEL *) malloc(sizeof(MODEL))) == NULL)   
   {   
   printf("error in 'init_model':  malloc call failed\n");   
   printf("out of memory!\n");   
   exit(1);   
  }   
A->n_model_list_length = 0;
A->p_model_list_length = 0;

return(A);   
}   

double eval_paren_expr(char *input_in, char *file_name, LINE *line_set, 
                       PARAM *par_list)
{
int i,j,left_paren_count, right_paren_count;
int left_paren[LENGTH_PAR_LIST];
int curr_right_paren,curr_left_paren,nest_count;
char nest_val_string[3];
double return_value;
char input[MAX_ARG];

strncpy(input,input_in,MAX_ARG-1);
/* replace any negative signs following 'e' or 'E' by '!' */
/* this simplifies parsing when dealing with exponential notation */
for (i = 0; input[i] != '\0'; i++)
  {
   if (input[i] == 'e' || input[i] == 'E')
       if (input[i+1] == '-')
           input[i+1] = '!';
  }
left_paren_count = -1;
right_paren_count = -1;
for (i=0; input[i] != '\0'; i++)
  {
   switch(input[i])
     {
     case '(':
       left_paren_count++;
       if (left_paren_count >= LENGTH_PAR_LIST)
	 {
          printf("error in 'eval_paren_expr':  parenthesis nested too deep\n");
          printf("   in file '%s'\n",file_name);
          printf("   expression:  %s\n",input);
	  printf("   line reads:\n");
          send_line_set_to_std_output(line_set);
          exit(1);
	}
       left_paren[left_paren_count] = i;
       break;
     case ')':
       right_paren_count++;
     }
 }
if (right_paren_count != left_paren_count)
  {
    printf("error in 'eval_paren_expr':  parenthesis mismatch\n");
    printf("   in file '%s'\n",file_name);
    printf("   expression:  %s\n",input);
    printf("   line reads:\n");
    send_line_set_to_std_output(line_set);
    exit(1);
  }
par_list->nest_length = 0;

for (nest_count = 0; left_paren_count >= 0; left_paren_count--)
  {
    if (nest_count > 99)
      {
	printf("error in 'eval_paren_expr':  parenthesis nested too deep\n");
	printf("   in input file '%s'\n",file_name);
	printf("   expression:  %s\n",input);
	printf("  note:  LENGTH_PAR_LIST should not be set above 100!\n");
        printf("   line reads:\n");
        send_line_set_to_std_output(line_set);
	exit(1);
      }
    sprintf(nest_val_string,"%d",nest_count);
    curr_left_paren = left_paren[left_paren_count];
    for (i = curr_left_paren; input[i] != ')' && input[i] != '\0'; i++);
    if (input[i] == '\0')
      {
	printf("error in 'eval_paren_expr':  right and left parenthesis mismatch\n");
	printf("   in file '%s'\n",file_name);
	printf("   expression:  %s\n",input);
        printf("   line reads:\n");
        send_line_set_to_std_output(line_set);
	exit(1);
      }
    curr_right_paren = i;
    input[curr_right_paren] = '\0';
    
    par_list->nest_val[nest_count++] = eval_no_paren_expr(&input[curr_left_paren+1],
							  file_name,line_set,par_list);
    
    par_list->nest_length++;
    for (j = 0, i = curr_left_paren+1; j < 2; i++,j++)
      input[i] = nest_val_string[j];
    for (j = 0, i = curr_left_paren + 1; input[i] != '\0' && j < 2; i++,j++);
    for (   ; i <= curr_right_paren; i++)
      input[i] = ' ';
  }

return_value = eval_no_paren_expr(input,file_name,line_set,par_list);
return(return_value);
}


double eval_no_paren_expr(char *input, char *file_name, LINE *line_set,
                          PARAM *par_list)
{
int i,j,arg_num,oper_num,arg_flag,found_in_list_flag;
char arg_list[LENGTH_PAR_LIST][LENGTH_PAR];
double arg_value[LENGTH_PAR_LIST];
char oper_list[LENGTH_PAR_LIST];
int error_flag,negative_found_at_begin;
double exp_value;

arg_num = 0;
oper_num = 0;
negative_found_at_begin = 0;
for (i = 0; input[i] == ' '; i++);

if (input[i] == '-')
  {
   negative_found_at_begin = 1;
   for (i++; input[i] == ' '; i++);
 }

/*  parse expression */
while(1)
  {
    if (arg_num > LENGTH_PAR_LIST)
      {
	printf("error in 'eval_no_paren_expr':  too many strings \n");
	printf("   in file `%s'\n",file_name);
        printf("   expression = %s\n",input);
        printf("   line reads:\n");
        send_line_set_to_std_output(line_set);
	exit(1);
      }
    arg_flag = 0;
    for (j = 0; input[i] != ' ' && input[i] != '\0' && input[i] != '*' &&
	 input[i] != '+' && input[i] != '\n' && input[i] != '/' &&
	 input[i] != '-'; j++,i++)
      {
        arg_flag = 1;
	if (j >= LENGTH_PAR-1)
	  {
	    printf("error in 'eval_no_paren_expr':  string too long\n");
	    printf("   in file `%s'\n",file_name);
	    printf("   expression = %s\n",input);
            printf("   line reads:\n");
            send_line_set_to_std_output(line_set);
	    exit(1);
	  }
	arg_list[arg_num][j] = input[i];
      }
    if (arg_flag == 1)
      {
       arg_list[arg_num][j] = '\0';
       arg_num++;
      }
    if (input[i] == ' ')
       for (   ; input[i] == ' '; i++);
    if (input[i] == '\n' || input[i] == '\0')
        break;
    else if (input[i] == '+' || input[i] == '-' || input[i] == '*' ||
             input[i] == '/')
      {
       if (oper_num > LENGTH_PAR_LIST)
	 {
	   printf("error in 'eval_no_paren_expr':  too many operators \n");
	   printf("   in file `%s'\n",file_name);
	   printf("   expression = %s\n",input);
           printf("   line reads:\n");
           send_line_set_to_std_output(line_set);
	   exit(1);
	 }
       oper_list[oper_num] = input[i];
       oper_num++;
       for (i++; input[i] == ' '; i++);
      }
    else
      {
	printf("error in 'eval_no_paren_expr':  two arguments in a row\n");
	printf("   in file `%s'\n",file_name);
	printf("   expression = %s\n",input);
        printf("   line reads:\n");
        send_line_set_to_std_output(line_set);
	exit(1);
      }
  }
if (arg_num != oper_num + 1)
  {
    printf("error in 'eval_no_paren_expr':  operator and argument mismatch \n");
    printf("   in file `%s'\n",file_name);
    printf("   expression = %s\n",input);
    printf("   note:  if expression is blank, you probably have empty\n");
    printf("          set of parenthesis somewhere\n");
    printf("   line reads:\n");
    send_line_set_to_std_output(line_set);
    exit(1);
  }


/*  evaluate expression */


/*  first, convert all arguments to numbers */

/* exp_value = convert_string("4582.0",file_name,linecount,&error_flag);
 printf("exp_value = %12.8e, error flag = %d \n",exp_value,error_flag); 
  printf("decimal = %d\n",atoi("9"));
  exit(1);
par_list->nest_length = 12;
par_list->main_par_length = 3;
par_list->main_par_val[0] = 14.2;
par_list->main_par_val[1] = 7.45;
par_list->main_par_val[2] = -193e-3;
par_list->nest_val[0] = 23.9;
par_list->nest_val[11] = -67.5;
sprintf(par_list->main_par_list[0],"Weff");
sprintf(par_list->main_par_list[1],"Leff");
sprintf(par_list->main_par_list[2],"error");  */

for (i = 0; i < arg_num; i++)
  {
   exp_value = convert_string(arg_list[i],file_name,line_set,&error_flag);
   if (error_flag == 0)
      arg_value[i] = exp_value;
   else
     {
       /* check if parameter corresponds to a previously parsed expression
	  within parenthesis  */
      if (arg_list[i][0] == '(')
	{
         j = atoi(&arg_list[i][1]);
         if (j >= par_list->nest_length)
	   {
           printf("error in 'eval_no_paren_expr':  nested_arg_list exceeded\n");
           printf("   (this error shouldn't happen:  something wrong\n");
           printf("   with the net2cpp source code\n");
	   printf("   expression = %s\n",input);
           printf("   line reads:\n");
           send_line_set_to_std_output(line_set);
           exit(1);
	   }
         arg_value[i] = par_list->nest_val[j];
	}
      /* otherwise:
         parameter must correspond to variables defined within spice netlist */
      else
	{
          found_in_list_flag = 0;
	  for (j = 0; j < par_list->main_par_length; j++)
	    {
             if (strcmp(arg_list[i],par_list->main_par_list[j]) == 0)
	       {
                found_in_list_flag = 1;
                arg_value[i] = par_list->main_par_val[j];
                break;
	      }
	   }
          if (found_in_list_flag == 0)
	    {
            if (par_list->param_not_found == -1)
	       {
               printf("error in 'eval_no_paren_expr':  argument not defined\n");
               printf("   in file `%s'\n",file_name);
               printf("    arg = `%s'\n",arg_list[i]);
	       printf("   expression = %s\n",input);
               printf("   line reads:\n");
               send_line_set_to_std_output(line_set);
               exit(1);
	       }
             else
	       {
               par_list->param_not_found = 1;
               arg_value[i] = 0.0; // insert arbitrary value
	       }
	   }
	}
    }
 }

/*  now, perform operations and return value of expression */


/*   change sign of any arguments with - operating on them */

if (negative_found_at_begin == 1)
   arg_value[0] = -arg_value[0];
for (i = 0; i < oper_num; i++)
   if (oper_list[i] == '-')
      arg_value[i+1] = -arg_value[i+1];

/*   do multiplication and division from left to right */
for (i = 0; i < oper_num; i++)
  {
    switch(oper_list[i])
      {
      case '*':
	arg_value[i+1] *= arg_value[i];
        arg_value[i] = 0.0;
	break;
      case '/':
	arg_value[i+1] = arg_value[i] / arg_value[i+1];
        arg_value[i] = 0.0;
      }
  }

/*   add up the resulting arguments */
for (i = 0; i < oper_num; i++)
   arg_value[i+1] += arg_value[i];


return(arg_value[oper_num]);
}


double convert_string(char *input, char *filename, LINE *line_set, 
                      int *error_flag)
{
int i,dec_place;
double string_value,char_value,power_of_ten,units_value;

units_value = 1.0;
*error_flag = 0;
for (i = 0; input[i] != '\0'; i++)
  {
   if ((input[i] > '9' || input[i] < '0') && input[i] != '.')
     {
       if (i > 0)
	 {
	   switch(input[i])
	     {
	     case 'E':
             case 'e':
               units_value = convert_exponent(&input[i+1],filename,line_set,input);
               break;
	     case 'A':
	     case 'a':
	       units_value = 1.0e-18;
	       break;
	     case 'F':
	     case 'f':
	       units_value = 1.0e-15;
	       break;
	     case 'P':
	     case 'p':
	       units_value = 1.0e-12;
	       break;
	     case 'N':
	     case 'n':
	       units_value = 1.0e-9;
	       break;
	     case 'U':
	     case 'u':
	       units_value = 1.0e-6;
	       break;
	     case 'M':
	     case 'm':
	       if (input[i+1] == 'E' || input[i+1] == 'e')
		 {
		   if (input[i+2] == 'G' || input[i+2] == 'g')
		     units_value = 1.0e6;
		   else
		     {
		       printf("error in 'convert_string':  units value '%s'\n",
                             &input[i]);
		       printf("   not recognized in file '%s'\n",filename);
                       printf("   line reads:\n");
                       send_line_set_to_std_output(line_set);
		       exit(1);
		     }
		 }
	       else
		 units_value = 1.0e-3;
	       break;
	     case 'K':
	     case 'k':
	       units_value = 1.0e3;
	       break;
	     case 'G':
	     case 'g':
	       units_value = 1.0e9;
	       break;
	     case 'T':
	     case 't':
	       units_value = 1.0e12;
	       break;
	     default:
	       printf("error in 'convert_string':  units value '%s'\n",&input[i]);
	       printf("   not recognized in file '%s'\n",filename);
               printf("       notation must be with 'e' or 'E'\n");
               printf("       example:  1e9, 3.7e-9, 7.1E16, 2.3e-30\n");
               printf("   line reads:\n");
               send_line_set_to_std_output(line_set);
	       exit(1);
	     }
	   input[i] = '\0';
	 }
       else
	 {
	   *error_flag = 1;
	   return(0.0);
	 }
       break;
     }
 }
for (dec_place = 0; input[dec_place] != '.' && input[dec_place] != '\0';
         dec_place++);



i = dec_place;
string_value = 0.0;
power_of_ten = 1.0;
while(--i >= 0)
  {
   switch(input[i])
     {
      case '0':
        char_value = 0.0;
        break;
      case '1':
        char_value = 1.0;
        break;
      case '2':
        char_value = 2.0;
        break;
      case '3':
        char_value = 3.0;
        break;
      case '4':
        char_value = 4.0;
        break;
      case '5':
        char_value = 5.0;
        break;
      case '6':
        char_value = 6.0;
        break;
      case '7':
        char_value = 7.0;
        break;
      case '8':
        char_value = 8.0;
        break;
      case '9':
        char_value = 9.0;
      }
     string_value += char_value*power_of_ten;
     power_of_ten *= 10.0;
 }

if (input[dec_place] == '.')
  {
    power_of_ten = 1/10.0;
    for (i = dec_place + 1; input[i] != '\0'; i++)
      {
	switch(input[i])
	  {
	  case '0':
	    char_value = 0.0;
	    break;
	  case '1':
	    char_value = 1.0;
	    break;
	  case '2':
	    char_value = 2.0;
	    break;
	  case '3':
	    char_value = 3.0;
	    break;
	  case '4':
	    char_value = 4.0;
	    break;
	  case '5':
	    char_value = 5.0;
	    break;
	  case '6':
	    char_value = 6.0;
	    break;
	  case '7':
	    char_value = 7.0;
	    break;
	  case '8':
	    char_value = 8.0;
	    break;
	  case '9':
	    char_value = 9.0;
	  }
	string_value += char_value*power_of_ten;
	power_of_ten /= 10.0;
      }
  }
string_value *= units_value;

return(string_value);
}

/* note:  a negative sign in front of exponent is assumed to
          have been replaced with '!' in order to simplify parsing
          in other programs */
double convert_exponent(char *input, char *filename, LINE *line_set, char *full_string)
{
int i;
int string_value,char_value,power_of_ten,sign;
double output;

sign = 1;
for (i = 0; input[i] != '\0'; i++)
  {
    if (input[i] > '9' || input[i] < '0')
     {
       if (input[i] == '!' && i == 0)
	 sign = -1;
       else
	 {
	 printf("error in 'convert_exponent':  exponent term '%s'\n",input);
         printf("  within the string '%s'\n",full_string);
	 printf("   has unallowed characters in file '%s'\n",filename);
         printf("   line reads:\n");
         send_line_set_to_std_output(line_set);
	 exit(1);
	 }
     }
  }
if (i == 0)
  {
    printf("error in 'convert_exponent':  exponent term\n");
    printf("  within the string '%s'\n",full_string);
    printf("   has no value in file '%s'\n",filename);
    printf("   line reads:\n");
    send_line_set_to_std_output(line_set);
    exit(1);
  }


string_value = 0;
power_of_ten = 1;
while(--i >= 0 && input[i] != '!')
  {
   switch(input[i])
     {
      case '0':
        char_value = 0;
        break;
      case '1':
        char_value = 1;
        break;
      case '2':
        char_value = 2;
        break;
      case '3':
        char_value = 3;
        break;
      case '4':
        char_value = 4;
        break;
      case '5':
        char_value = 5;
        break;
      case '6':
        char_value = 6;
        break;
      case '7':
        char_value = 7;
        break;
      case '8':
        char_value = 8;
        break;
      case '9':
        char_value = 9;
      }
     string_value += char_value*power_of_ten;
     power_of_ten *= 10;
 }

output = 1.0;
if (sign > 0)
  {
   for (i = 0; i < string_value; i++)
      output *= 10.0;
  }
else
  {
   for (i = 0; i < string_value; i++)
      output *= 0.1;
  }

return(output);
}

void send_line_set_to_std_output(LINE *line_set)
{
int i;

if (line_set != NULL)
   {
    for (i = 0; i < line_set->num_of_lines; i++)
       printf("-> %s",line_set->line_array[i]);
   printf("\n");
   }
else
   printf(" ---> line is unknown - sorry!\n");
}
