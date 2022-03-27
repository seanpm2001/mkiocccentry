/* vim: set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab : */
/* json_parser - flex grammar
 *
 * XXX This is VERY incomplete but the .info.json and .author.json files
 * generated by mkiocccentry do not cause any errors. Nothing is done with the
 * parsing but passing the input of .info.json or .author.json to this program
 * and you'll end up seeing e.g.:
 *
 *	./json_parser test_work/12345678-1234-4321-abcd-1234567890ab-2/.info.json
 *
 *	[...]
 *	Now at end of input.
 *	Shifting token end of file ()
 *	Entering state 17
 *	Stack now 0 7 17
 *	Stack now 0 7 17
 *	Cleanup: popping token end of file ()
 *	Cleanup: popping nterm json ()
 *
 * In addition to the parser not doing anything there is missing grammar and
 * there might be some grammar that's not correct. Not all actions are complete
 * and some that have been added do not yet check for errors.
 *
 * Additionally the memory returned by strdup() in the JSON_STRING action will
 * not yet be freed in the parser but since the parser doesn't do anything but
 * just finishes until a parse error or EOF this is not a problem.
 *
 * I'm not sure when I will be adding more and I won't add all at once but
 * rather a bit each time. This is a work in progress!
 *
 */

/* Section 1: Declarations and option settings */

/*
 * This prevents needing to link in the flex(1) library which means those
 * without flex can compile the code. Even if everyone had flex(1) though under
 * macOS you have to pass -ll to the compiler to link in the flex library
 * whereas in other systems you have to use -lfl which would cause a lot of
 * problems. Another way is to provide 'int yywrap() { return 1; }' but this is
 * unnecessary.
 */
%option noyywrap

/*
 * currently disabled but this might be an idea when everything is in working
 * order.
 *
 * %option nodefault
 */

%{
/* Declarations etc. go here.
 *
 * Code is copied verbatim near the top of the generated code.
 */

#include <stdio.h>

#include "util.h"
#include "dbg.h"

/* this is generated by bison */
#include "jparse.tab.h"
void yyerror(char *s, ...);
void print_newline(void);
extern int oldstate;
YY_BUFFER_STATE bp;
extern FILE *yyin;
extern unsigned num_errors;		/* > 0 number of errors encountered */
extern bool output_newline;		/* true ==> -n not specified, output new line after each arg processed */
extern int token_type;			/* for braces, brackets etc.: '{', '}', '[', ']', ':' and so on */
%}

/*
 * Section 2: Patterns (regular expressions) and actions.
 *
 * NOTE: There are likely errors here and it's probably incomplete as well.
 */
JSON_WHITESPACE         [ \t\r\n]+
JSON_STRING		\"[^"\n]*\"
JSON_DIGIT		[0-9]
JSON_DIGITS		{JSON_DIGIT}+
JSON_EXPONENT		[Ee][-+]?[0-9]+
JSON_INTMAX		-?{JSON_DIGITS}
JSON_UINTMAX		{JSON_DIGITS}
JSON_LONG_DOUBLE	-?{JSON_DIGITS}"."{JSON_DIGITS}{JSON_EXPONENT}?
JSON_LETTER		[a-zA-Z]
JSON_BOOLEAN		"true"|"false"
JSON_NULL		"null"
JSON_OPEN_BRACE		"{"
JSON_CLOSE_BRACE	"}"
JSON_OPEN_BRACKET	"["
JSON_CLOSE_BRACKET	"]"
JSON_COLON		":"
JSON_COMMA		","

/* Actions.
 *
 * For now we just print out what it is and return the type. Once again this is
 * incomplete!
 *
 * A word about previous versions which had (that is returned) JSON_WHITESPACE.
 * This caused problems in that the parser expected whitespace in specific
 * places which means that a lot of different combinations would have to be
 * added to the rules to get every possible combination. It might be that
 * whitespace has to be added to this file but I'm not sure of this yet.
 * Whitespace does exist as a type (above) but we don't do anything with it here
 * with actions because returning it to the parser causes parser errors; instead
 * it's just ignored. I'm not sure if there will be a need to change this but
 * for now it's not used.
 *
 */
%%
{JSON_STRING}		    { printf("string: '%s'\n", yytext); yylval.string = strdup(yytext); return JSON_STRING; }
{JSON_UINTMAX}		    { printf("uintmax: '%s'\n", yytext); yylval.uintmax = string_to_uintmax(yytext); return JSON_UINTMAX; }
{JSON_INTMAX}		    { printf("intmax: '%s'\n", yytext); yylval.intmax = string_to_intmax(yytext); return JSON_INTMAX; }
{JSON_LONG_DOUBLE}	    { printf("long double: '%s'\n", yytext); yylval.ldouble = string_to_float(yytext); return JSON_LONG_DOUBLE; }
{JSON_NULL}		    { printf("null: '%s'\n", yytext); return JSON_NULL; }
{JSON_BOOLEAN}		    { printf("true: '%s'\n", yytext); yylval.boolean = string_to_bool(yytext); return JSON_BOOLEAN; }
{JSON_OPEN_BRACE}	    { printf("open brace: '%c'\n", *yytext); token_type = '{'; return JSON_OPEN_BRACE; }
{JSON_CLOSE_BRACE}	    { printf("close brace: '%c'\n", *yytext); token_type = '}'; return JSON_CLOSE_BRACE;}
{JSON_OPEN_BRACKET}	    { printf("open bracket: '%c'\n", *yytext); token_type = '['; return JSON_OPEN_BRACKET; }
{JSON_CLOSE_BRACKET}	    { printf("close bracket: '%c'\n", *yytext); token_type = ']'; return JSON_CLOSE_BRACKET; }
{JSON_COLON}		    { printf("equals/colon: '%c'\n", *yytext); token_type = ':'; return JSON_COLON; }
{JSON_COMMA}		    { printf("comma: '%c'\n", *yytext); token_type = ','; return JSON_COMMA; }
%%

/* Section 3: Code that's copied to the generated scanner */


/* parse_json_string	    - parse string as a JSON block
 *
 * given:
 *
 *	string	    - the string to parse as JSON
 *
 * NOTE: Until the JSON parser is finished this only parses the string (and not
 * necessarily correctly) but it does not build a parse tree.
 */
void
parse_json_string(char const *string)
{
    /*
     * firewall
     */
    if (string == NULL) {
	/* this should never happen */
	warn(__func__, "passed NULL string");
	++num_errors;
	return;
    } else if (*string == '\0') /* strlen(string) == 0 */ {
	warn(__func__, "passed empty string");
	++num_errors;
	return;
    }

    bp = yy_scan_string(string);
    if (bp == NULL) {
	warn(__func__, "unable to scan string");
	++num_errors;
	return;
    }
    yyparse();

    yy_delete_buffer(bp);
    bp = NULL;

    print_newline();
}


/* parse_json_file	    - parses file file
 *
 * given:
 *
 *	filename    - filename to parse
 *
 * If filename is NULL or the filename is not a readable file (or is empty) or
 * if the file is not a C string or if read_all() returns NULL the function
 * warns but does nothing else.
 *
 * NOTE: Until the JSON parser is finished this only parses the file (and not
 * necessarily correctly) but it does not build a parse tree.
 */
void
parse_json_file(char const *filename)
{
    bool is_stdin = false;	/* true if reading from stdin (filename == "-") */
    char *data = NULL;		/* used to determine if there are NUL bytes in the file */
    size_t len = 0;		/* length of data read */
    int ret;

    /*
     * firewall
     */
    if (filename == NULL) {
	/* this should actually never happen */
	warn(__func__, "passed NULL filename");
	++num_errors;
	return;
    } else if (*filename == '\0') { /* strlen(filename) == 0 */
	warn(__func__, "passed empty filename");
	++num_errors;
	return;
    }

    is_stdin = !strcmp(filename, "-");
    if (!is_stdin && !is_file(filename)) {
	warn(__func__, "passed filename that's not actually a file: %s", filename);
	++num_errors;
	return;
    } else if (!is_stdin && !is_read(filename)) {
	warn(__func__, "passed filename not readable file: %s", filename);
	++num_errors;
	return;
    }

    errno = 0;
    yyin = is_stdin ? stdin : fopen(filename, "r");
    if (yyin == NULL) {
	warnp(__func__, "couldn't open file %s, ignoring", filename);
	++num_errors;
	return;
    }

    data = read_all(yyin, &len);
    if (data == NULL) {
	warn(__func__, "couldn't read in %s", is_stdin?"stdin":filename);
	++num_errors;
	return;
    }
    if (!is_string(data, len + 1)) {
	warn(__func__, "found embedded NUL byte in %s", is_stdin?"stdin":filename);
	++num_errors;
	return;
    }

    free(data);
    data = NULL;
    rewind(yyin);

    yyrestart(yyin);
    yyparse();

    if (yyin == stdin)
	clearerr(yyin);
    else {
	errno = 0;
	ret = fclose(yyin);
	if (ret != 0) {
	    warnp(__func__, "error in fclose on file %s", filename);
	}
    }
    print_newline();
}

/* print_newline	- prints a newline to stdout if -n not specified
 *
 * NOTE: We have this in a function because the same code is used every time we
 * print something out as long as -n was not specified.
 */
void
print_newline(void)
{
    int ret;

    if (output_newline) {
	errno = 0;		/* pre-clear errno for errp() */
	ret = putchar('\n');
	if (ret != '\n') {
	    errp(37, __func__, "error while writing newline");
	    not_reached();
	}
    }
}
