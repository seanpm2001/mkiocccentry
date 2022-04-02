/* vim: set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab : */
/*
 * jparse - tool that parses a block of JSON input
 *
 * "Because sometimes even the IOCCC Judges need some help." :-)
 *
 * This tool is currently being worked on by:
 *
 *	@xexyl
 *	https://xexyl.net		Cody Boone Ferguson
 *	https://ioccc.xexyl.net
 *
 * NOTE: This is _very incomplete_ and right now all it does is reads from either
 * stdin, the command line or a file, running yyparse() on it. The grammar is
 * incomplete, there are some things that are allowed that are not valid JSON
 * and various other things need to be done.
 *
 * This is very much a work in progress!
 */


#if !defined(INCLUDE_JPARSE_H)
#    define  INCLUDE_JPARSE_H


/*
 * dbg - debug, warning and error reporting facility
 */
#include "dbg.h"


/*
 * util - utility functions and definitions
 */
#include "util.h"


/*
 * JSON functions supporting mkiocccentry code
 */
#include "json.h"

/*
 * sanity - reality checks
 */
#include "sanity.h"

/*
 * IOCCC size and rule related limitations
 */
#include "limit_ioccc.h"


/*
 * usage message
 *
 * Use the usage() function to print the these usage_msgX strings.
 */
static const char * const usage_msg =
    "usage: %s [-h] [-v level] [-q] [-V] [-T] [-s string] [-S] [file ...]\n"
    "\n"
    "\t-h\t\tprint help message and exit 0\n"
    "\t-v level\tset verbosity level (def level: %d)\n"
    "\t-q\t\tquiet mode, unless verbosity level > 0 (def: not quiet)\n"
    "\t-V\t\tprint version string and exit 0\n"
    "\t-T\t\tshow IOCCC toolkit release repository tag\n"
    "\t-n\t\tdo not output newline after decode output\n"
    "\t-s\t\tread arg as a string\n"
    "\t-S\t\tdecode using strict mode (def: not strict)\n"
    "\n"
    "\t[file]\t\tread and parse file (def: parse stdin)\n"
    "\t\t\tNOTE: - means read from stdin\n"
    "\n"
    "jparse version: %s\n";


/*
 * globals
 */
extern int verbosity_level;	/* debug level set by -v */
extern bool msg_output_allowed;		/* false ==> disable output from msg() */
extern bool dbg_output_allowed;		/* false ==> disable output from dbg() */
extern bool warn_output_allowed;	/* false ==> disable output from warn() and warnp() */
extern bool err_output_allowed;		/* false ==> disable output from err() and errp() */
extern bool usage_output_allowed;	/* false ==> disable output from vfprintf_usage() */
extern bool output_newline;		/* true ==> -n not specified, output new line after each arg processed */
extern unsigned num_errors;		/* > 0 number of errors encountered */
static bool quiet = false;		/* true ==> only show errors, and warnings if -v > 0 */
/* lexer and parser specific variables */
extern int yylineno;			/* line number in lexer */
extern char *yytext;			/* current text */
extern FILE *yyin;			/* input file lexer/parser reads from */
extern int oldstate;
extern unsigned num_errors;		/* > 0 number of errors encountered */
extern bool output_newline;		/* true ==> -n not specified, output new line after each arg processed */
extern int token_type;			/* for braces, brackets etc.: '{', '}', '[', ']', ':' and so on */

/*
 * function prototypes
 */
static void usage(int exitcode, char const *name, char const *str) __attribute__((noreturn));
/* lexer specific */
void yyerror(char const *s, ...);
int yylex(void);
/* parser specific */
void parse_json_file(char const *filename);
void parse_json_string(char const *string);

#endif /* INCLUDE_JPARSE_H */
