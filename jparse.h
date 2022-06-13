/* vim: set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab : */
/*
 * jparse - JSON parser
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
 * stdin, the command line or a file, running yyparse() (actually ugly_parse())
 * on it. The grammar is incomplete, there are some things that are allowed that
 * are not valid JSON and many other things need to be done.
 *
 * This is very much a work in progress!
 */


#if !defined(INCLUDE_JPARSE_H)
#    define  INCLUDE_JPARSE_H


#include <stdio.h>

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
#include "json_parse.h"

/*
 * json_util - general JSON utility support functions
 */
#include "json_util.h"

/*
 * definitions
 */

/* NOTE: UGLY_DEBUG MUST be defined prior to #including jparse.tab.h! */
#define UGLY_DEBUG 1
#define UGLY__BUFFER_STATE YY_BUFFER_STATE /* see comments in jparse.l as to why we do this here */
#define UGLY_ABORT YYABORT  /* bison does not use the prefix for YYABORT so we do it for them */

/*
 * jparse.tab.h - generated by bison
 */
#include "jparse.tab.h"

/*
 * official JSON parser version
 */
#define JSON_PARSER_VERSION "0.8 2022-06-12"		/* format: major.minor YYYY-MM-DD */


/*
 * globals
 */
extern unsigned num_errors;		/* > 0 number of errors encountered */
extern char const *json_parser_version;	/* official JSON parser version */
/* lexer and parser specific variables */
extern int ugly_lineno;			/* line number in lexer */
extern char *ugly_text;			/* current text */
extern FILE *ugly_in;			/* input file lexer/parser reads from */
extern unsigned num_errors;		/* > 0 number of errors encountered */
extern struct json tree;		/* the parse tree */
extern int ugly_leng;


/*
 * lexer specific
 */
extern int ugly_lex(void);

/*
 * function prototypes for jparse.y
 */
extern void ugly_error(struct json *node, char const *format, ...);

/*
 * function prototypes for jparse.l
 */
extern struct json *parse_json(char const *ptr, size_t len, bool *is_valid, FILE *dbg_stream);
extern struct json *parse_json_file(char const *filename, bool *is_valid, FILE *dbg_stream);


#endif /* INCLUDE_JPARSE_H */
