/*
 * jparse - JSON parser
 *
 * "Because specs w/o version numbers are forced to commit to their original design flaws." :-)
 *
 * This JSON parser was co-developed in 2022 by:
 *
 *	@xexyl
 *	https://xexyl.net		Cody Boone Ferguson
 *	https://ioccc.xexyl.net
 * and:
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * "Because sometimes even the IOCCC Judges need some help." :-)
 *
 * "Share and Enjoy!"
 *     --  Sirius Cybernetics Corporation Complaints Division, JSON spec department. :-)
 */


#if !defined(INCLUDE_JPARSE_H)
#    define  INCLUDE_JPARSE_H


#include <stdio.h>

/*
 * dbg - info, debug, warning, error, and usage message facility
 */
#include "../dbg/dbg.h"

/*
 * util - entry common utility functions for the IOCCC toolkit
 */
#include "util.h"

/*
 * json_parse - JSON parser support code
 */
#include "json_parse.h"

/*
 * json_util - general JSON parser utility support functions
 */
#include "json_util.h"

/*
 * json_sem - JSON semantics support
 */
#include "json_sem.h"

/*
 * official jparse version
 */
#define JPARSE_VERSION "0.11 2022-07-04"		/* format: major.minor YYYY-MM-DD */


/*
 * definitions
 */
#define MAX_NUL_REPORTED (5)	/* do not report more than the first MAX_NUL_REPORTED NUL bytes */
#define MAX_LOW_REPORTED (5)	/* do not report more than the first MAX_LOW_REPORTED [\x01-\x08\x0e-\x1f] bytes */

/*
 * jparse.tab.h - generated by bison
 */
#if !defined(JPARSE_TAB_H_INCLUDED)
#define JPARSE_TAB_H_INCLUDED
#include "jparse.tab.h"
#endif

/*
 * official JSON parser version
 */
#define JSON_PARSER_VERSION "0.13 2023-01-21"		/* library version format: major.minor YYYY-MM-DD */


/*
 * globals
 */
extern const char *const json_parser_version;		/* library version format: major.minor YYYY-MM-DD */
extern const char *const jparse_version;		/* jparse version format: major.minor YYYY-MM-DD */
/* lexer and parser specific variables */
extern int yydebug;

struct json_extra
{
    char const *filename;	/* filename being parsed ("-" means stdin) */
};

/*
 * lexer specific
 */
extern int yylex(YYSTYPE *yylval_param, YYLTYPE *yylloc_param, yyscan_t scanner);

/*
 * function prototypes for jparse.y
 */
extern void yyerror(YYLTYPE *yyltype, struct json **tree, yyscan_t scanner, char const *format, ...);

/*
 * function prototypes for jparse.l
 */
extern struct json *parse_json(char const *ptr, size_t len, char const *filename, bool *is_valid);
extern struct json *parse_json_stream(FILE *stream, char const *filename, bool *is_valid);
extern struct json *parse_json_file(char const *name, bool *is_valid);


#endif /* INCLUDE_JPARSE_H */
