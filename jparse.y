/* vim: set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab : */

/* JSON parser - bison grammar
 *
 * XXX This is VERY incomplete but the .info.json and .author.json files
 * generated by mkiocccentry do not cause any errors. No parse tree is generated
 * yet and so no verification is done yet either.
 *
 * XXX Once the parser is done test older versions of both bison and flex to see
 * if they can generate the proper code.
 *
 * This is a work in progress but as of the past few days (it's 16 May 2022 as I
 * write this) much progress has been made!
 */

/* Section 1: Declarations */
/*
 * We enable verbose error messages during development but once the parser is
 * complete we will disable this as it's very verbose.
 *
 * NOTE: Previously we used the -D option to bison because the %define is not
 * POSIX Yacc portable but we no longer do that because we make use of another
 * feature that's not POSIX Yacc portable that we deem worth it as it produces
 * easier to read error messages.
 */
%define parse.error verbose
/*
 * We enable lookahead correction parser for improved errors
 */
%define parse.lac full


/*
 * We use our struct json (see json_parse.h for its definition) instead of bison
 * %union.
 */
%define api.value.type {struct json *}

/*
 * we need access to the node in parse_json() so we tell bison that ugly_parse()
 * takes a struct json *node.
 */
%parse-param { struct json *node }

/*
 * An IOCCC satirical take on bison and flex
 *
 * As we utterly object to the hideous code that bison and flex generate we
 * point it out in an ironic way by changing the prefix yy to ugly_ so that
 * bison actually calls itself ugly. This is satire for the IOCCC (although we
 * still believe that bison generates ugly code)!
 *
 * This means that to access the struct json's union type in the lexer we can do
 * (because the prefix is ugly_ as described above):
 *
 *	ugly_lval.type = ...
 *
 * A negative consequence here is that because of the api.prefix being set to
 * ugly_ there's a typedef that _might_ suggest that _our_ struct json is ugly:
 *
 *	typedef struct json UGLY_STYPE;
 *
 * At first glance this is a valid concern. However we argue that even if this
 * is so the struct might well have to be ugly because it's for a json parser; a
 * json parser necessarily has to be ugly due to the spec: one could easily be
 * forgiven for wondering if the authors of the json specification were on drugs
 * at the time of writing them!
 *
 * Please note that we're _ABSOLUTELY NOT_ saying that they were and we use the
 * term very loosely as well: we do not want to and we are not accusing anyone
 * of being on drugs (we rather find addiction a real tragedy and anyone with an
 * addiction should be treated well and given the help they need) but the fact
 * is that the JSON specification is barmy and those who are in favour of it
 * must surely be in the JSON Barmy Army (otherwise known as the Barmy Army
 * Jointly Staying On Narcotics :-)).
 *
 * Thus as much as we find the specification objectionable we rather feel sorry
 * for those poor lost souls who are indeed in the JSON Barmy Army and we
 * apologise to them in a light and fun way and with hope that they're not
 * terribly humour impaired. :-)
 *
 * BTW: If you want to see all the symbols (re?)defined to something ugly run:
 *
 *	grep -i '#[[:space:]]*define[[:space:]].*ugly_' *.c
 *
 * after generating the files; and if you want to see only what was changed from
 * yy or YY to refer to ugly_ or UGLY_:
 *
 *	grep -i '#[[:space:]]*define[[:space:]]*yy.*ugly_' *.c
 *
 * This will help you find the right symbols should you need them. If (as is
 * likely to happen) the parser is split into another repo for a json parser by
 * itself I will possibly remove this prefix: this is as satire for the IOCCC
 * (though we all believe that the generated code is in fact ugly).
 *
 * WARNING: Although we use the prefix ugly_ the scanner and parser will at
 * times refer to yy and YY and other times refer to ugly_ and UGLY_ (partly
 * because WE refer to ugly_ and UGLY_). So if you're trying to sift through
 * that ugly spaghetti code (which we strongly recommend you do not do as it will
 * likely cause nightmares and massive brain pain) you'll want to check yy/YY as
 * well as ugly_/UGLY_. But really you oughtn't try and go through that code so
 * you need only pay attention to the ugly_ and UGLY_ prefixes (in the *.l and
 * *.y files) which again are satire for the IOCCC. See also the apology in the
 * generated files or directly looking at sorry.tm.ca.h.
 */
%define api.prefix {ugly_}

%{
#include <inttypes.h>
#include <stdio.h>
#include <unistd.h> /* getopt */
#include "jparse.h"

unsigned num_errors = 0;		/* > 0 number of errors encountered */

char const *json_parser_version = JSON_PARSER_VERSION;	/* official JSON parser version */

/* debug information during development */
int ugly_debug = 1;

%}


/*
 * Terminal symbols (token kind)
 *
 * For most of the terminal symbols we use string literals to identify them as
 * this makes it easier to read error messages. This feature is not POSIX Yacc
 * compatible but we've decided that the benefit outweighs this fact.
 */
%token JSON_OPEN_BRACE "{"
%token JSON_CLOSE_BRACE "}"
%token JSON_OPEN_BRACKET "["
%token JSON_CLOSE_BRACKET "]"
%token JSON_COMMA ","
%token JSON_COLON ":"
%token JSON_NULL "null"
%token JSON_TRUE "true"
%token JSON_FALSE "false"
%token JSON_STRING
%token JSON_NUMBER

/*
 * The next token 'token' is a hack for better error messages with invalid
 * tokens.  Bison syntax error messages are in the form of:
 *
 *	    syntax error, unexpected <token name>
 *	    syntax error, unexpected <token name>, expecting } or JSON_STRING
 *
 * etc. where <token name> is whatever is returned in the lexer actions (e.g.
 * JSON_STRING) to the parser. But the problem is what do we call an invalid
 * token without knowing what what the token actually is? Thus we call it token
 * so that it will read literally as 'unexpected token' which removes any
 * ambiguity (it could be read as 'it's unexpected in this place but it is valid
 * in other contexts' but it's never actually valid: it's a catch all for
 * anything that's not valid.
 *
 * Then as a hack (or maybe kludge) in ugly_error() we refer to ugly_text in a
 * way that shows what the token is that caused the failure (whether it's a
 * syntax error or something else).
 */
%token token


/*
 * Section 2: Rules
 *
 * See https://www.json.org/json-en.html for the JSON specification. We have
 * tried to make the below grammar as close to the JSON specification as
 * possible for those who are familiar with it but there might be some minor
 * differences in order or naming. One that we do not have is whitespace but
 * that's not needed and would actually cause many complications and parsing
 * errors. There are some others we do not need to include as well.
 *
 * XXX All the rules should be here but not all those that need actions have
 * actions. We also don't use the struct json *node yet (from parse_json()) but
 * this will have to change down the road.
 *
 * The actions are very much subject to change!
 */
%%
json:

    json_element
    {
	/*
	 * $$ = $json
	 * $1 = $json_element
	 */

	/* pre action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json: starting: "
					 "json: json_element");
	json_dbg(JSON_DBG_MED, __func__, "under json: $json_element type: %s",
					 json_element_type_name($json_element));
	json_dbg(JSON_DBG_MED, __func__, "under json: about to perform: "
					 "$json = $json_element;");

	/* action */
	$json = $json_element; /* magic: json becomes the json_element type */

	/* post action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json: returning $json type: %s",
					 json_element_type_name($json));
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json: ending: "
					 "json: json_element");
    }
    ;

json_value:

    json_object
    {
	/*
	 * $$ = $json_value
	 * $1 = $json_object
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: json_object");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: $json_object type: %s",
					 json_element_type_name($json_object));
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = $json_object;");

	/* action */
	$json_value = $json_object;	/* magic: json_value becomes the json_object (JTYPE_OBJECT) type */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
					 json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: json_object");
    }
    |

    json_array
    {
	/*
	 * $$ = $json_value
	 * $1 = $json_array
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: json_array");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: $json_array type: %s",
					 json_element_type_name($json_array));
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = $json_array;");

	/* action */
	$json_value = $json_array;	/* magic: json_value becomes the json_array type (JTYPE_ARRAY) */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
					 json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: json_array");
    }
    |

    json_string
    {
	/*
	 * $$ = $json_value
	 * $1 = $json_string
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: json_string");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: $json_string type: %s",
					 json_element_type_name($json_string));
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = $json_string;");

	/* action */
	$json_value = $json_string; /* magic: json_value becomes the json_string type (JTYPE_STRING) */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
					 json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: json_string");
    }
    |

    json_number
    {
	/*
	 * $$ = $json_value
	 * $1 = $json_number
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: json_number");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: $json_number type: %s",
					 json_element_type_name($json_number));
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = $json_number;");

	/* action */
	$json_value = $json_number; /* magic: json_value becomes the json_number type (JTYPE_NUMBER) */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
					 json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: json_number");
    }
    |

    JSON_TRUE
    {
	/*
	 * $$ = $json_value
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: JSON_TRUE");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: ugly_text: <%s>", ugly_text);
	json_dbg(JSON_DBG_MED, __func__, "under json_value: ugly_leng: <%d>", ugly_leng);
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = parse_json_bool(ugly_text);");

	/* action */
	$json_value = parse_json_bool(ugly_text); /* magic: json_value becomes the JSON_TRUE type (JTYPE_BOOL) */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
				         json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: JSON_TRUE");
    }
    |

    JSON_FALSE
    {
	/*
	 * $$ = $json_value
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: JSON_FALSE");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: ugly_text: <%s>", ugly_text);
	json_dbg(JSON_DBG_MED, __func__, "under json_value: ugly_leng: <%d>", ugly_leng);
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = parse_json_bool(ugly_text);");

	/* action */
	$json_value = parse_json_bool(ugly_text); /* magic: json_value becomes the JSON_FALSE type (JTYPE_BOOL) */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
				         json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: JSON_FALSE");
    }
    |

    JSON_NULL
    {
	/*
	 * $$ = $json_value
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: starting: "
					 "json_value: JSON_NULL");
	json_dbg(JSON_DBG_MED, __func__, "under json_value: ugly_text: <%s>", ugly_text);
	json_dbg(JSON_DBG_MED, __func__, "under json_value: ugly_leng: <%d>", ugly_leng);
	json_dbg(JSON_DBG_MED, __func__, "under json_value: about to perform: "
					 "$json_value = parse_json_null(ugly_text);");

	/* action */
	$json_value = parse_json_null(ugly_text); /* magic: json_value becomes the JSON_NULL type (JTYPE_NULL) */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_value: returning $json_value type: %s",
				         json_element_type_name($json_value));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_value, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_value: ending: "
					 "json_value: JSON_NULL");
    }
    ;

json_object:

    JSON_OPEN_BRACE json_members JSON_CLOSE_BRACE
    {
	/*
	 * $$ = $json_object
	 * $1 = $json_members
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: starting: "
					 "json_object: JSON_OPEN_BRACE json_members JSON_CLOSE_BRACE");
	json_dbg(JSON_DBG_MED, __func__, "under json_object: $json_members type: %s",
					 json_element_type_name($json_members));
	json_dbg(JSON_DBG_MED, __func__, "under json_object: about to perform: "
					 "XXX - need more code here - XXX");

	/* action */
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: XXX - need more code here - XXX"); /* XXX */

	/* post-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: returning $json_object type: %s",
					 json_element_type_name($json_object));
	/* XXX - call json_dbg_tree_print when there is a value to process - XXX */
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: ending: "
					 "json_object: JSON_OPEN_BRACE json_members JSON_CLOSE_BRACE");
    }
    |

    JSON_OPEN_BRACE JSON_CLOSE_BRACE
    {
	/*
	 * $$ = $json_object
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: starting: "
					 "json_object: JSON_OPEN_BRACE JSON_CLOSE_BRACE");
	json_dbg(JSON_DBG_MED, __func__, "under json_object: about to perform: "
					 "$json_object = json_create_object();");

	/* action */
	$json_object = json_create_object(); /* json_object becomes JTYPE_OBJECT */

	/* post-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: returning $json_object type: %s",
					 json_element_type_name($json_object));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_object, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_object: ending: "
					 "json_object: JSON_OPEN_BRACE JSON_CLOSE_BRACE");
    }
    ;

json_members:

    json_member
    {
	/*
	 * $$ = $json_members
	 * $1 = $json_member
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_members: starting: "
					 "json_members: json_member");
	json_dbg(JSON_DBG_MED, __func__, "under json_members: $json_member type: %s",
					 json_element_type_name($json_member));
	json_dbg(JSON_DBG_MED, __func__, "under json_members: about to perform: "
					 "$json_members = $json_member;");

	/* action */
	$json_members = $json_member; /* magic: json_members becomes the json_member type */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_members: returning $json_members type: %s",
				         json_element_type_name($json_members));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_members, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_members: ending: "
					 "json_members: json_member");
    }
    |

    json_members JSON_COMMA json_member
    {
	/*
	 * $$ = $json_members
	 * $1 = $json_members
	 * $3 = $json_member
	 *
	 * NOTE: Cannot use $json_members due to ambiguity.
	 *       But we can use $3 for $json_member.
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_members: starting: "
					 "json_members: json_members JSON_COMMA json_member");
	json_dbg(JSON_DBG_MED, __func__, "under json_members: $1 ($json_members) type: %s",
					 json_element_type_name($1));
	json_dbg(JSON_DBG_MED, __func__, "under json_members: $3 ($json_member) type: %s",
					 json_element_type_name($3));
	json_dbg(JSON_DBG_MED, __func__, "under json_members: about to perform: "
					 "XXX - need more code here - XXX");

	/* action */
	json_dbg(JSON_DBG_LOW, __func__, "under json_members: XXX - need more code here - XXX"); /* XXX */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_members: returning $$ ($json_members) type: %s",
				         json_element_type_name($$));
	/* XXX - call json_dbg_tree_print when there is a value to process - XXX */
	json_dbg(JSON_DBG_LOW, __func__, "under json_members: ending: "
					 "json_members: json_members JSON_COMMA json_member");
    }
    ;

json_member:

    json_string JSON_COLON json_element
    {
	/*
	 * $$ = $json_member
	 * $1 = $json_string
	 * $3 = $json_element
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_member: starting: "
					 "json_member: json_string JSON_COLON json_element");
	json_dbg(JSON_DBG_MED, __func__, "under json_member: $json_string type: %s",
					 json_element_type_name($json_string));
	json_dbg(JSON_DBG_MED, __func__, "under json_member: $json_element type: %s",
					 json_element_type_name($json_element));
	json_dbg(JSON_DBG_MED, __func__, "under json_member: about to perform: "
					 "$json_member = parse_json_member($json_string, $json_element);");

	/* action */
	$json_member = parse_json_member($json_string, $json_element);

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_member: returning $json_member type: %s",
				         json_element_type_name($json_member));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_member, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_member: ending: "
					 "json_member: json_string JSON_COLON json_element");
    }
    ;

json_array:

    JSON_OPEN_BRACKET json_elements JSON_CLOSE_BRACKET
    {
	/*
	 * $$ = $json_array
	 * $2 = $json_elements
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_array: starting: "
					 "json_array: JSON_OPEN_BRACKET json_elements JSON_CLOSE_BRACKET");
	json_dbg(JSON_DBG_LOW, __func__, "under json_array: $json_elements type: %s",
					 json_element_type_name($json_elements));
	json_dbg(JSON_DBG_MED, __func__, "under json_array: about to perform: "
					 "XXX - need more code here - XXX");

	/* action */
	json_dbg(JSON_DBG_LOW, __func__, "under json_array: XXX - need more code here - XXX"); /* XXX */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_array: returning $json_array type: %s",
				         json_element_type_name($json_array));
	/* XXX - call json_dbg_tree_print when there is a value to process - XXX */
	json_dbg(JSON_DBG_LOW, __func__, "under json_array: ending: "
					 "json_array: JSON_OPEN_BRACKET json_elements JSON_CLOSE_BRACKET");
    }
    |

    JSON_OPEN_BRACKET JSON_CLOSE_BRACKET
    {
	/*
	 * $$ = $json_array
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_array: starting: "
					 "json_array: JSON_OPEN_BRACKET JSON_CLOSE_BRACKET");
	json_dbg(JSON_DBG_MED, __func__, "under json_array: about to perform: "
					 "$json_array = json_create_array();");

	/* action */
	$json_array = json_create_array();

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_array: returning $json_array type: %s",
				         json_element_type_name($json_array));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_array, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_array: ending: "
					 "json_array: JSON_OPEN_BRACKET JSON_CLOSE_BRACKET");
    }
    ;

json_elements:

    json_element
    {
	/*
	 * $$ = $json_elements
	 * $1 = $json_element
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_elements: starting: "
					 "json_elements: json_element");
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: $json_element type: %s",
					 json_element_type_name($json_element));
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: about to perform: "
					 "$json_elements = $json_element;");

	/* action */
	$json_elements = $json_element; /* magic: json_elements becomes the json_element type */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: returning $json_elements type: %s",
				         json_element_type_name($json_elements));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_elements, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_elements: ending: "
					 "json_elements: json_element");
    }
    |

    json_elements JSON_COMMA json_element
    {
	/*
	 * $$ = $json_elements
	 * $3 = $json_element
	 *
	 * NOTE: Cannot use $json_elements due to ambiguity.
	 *	 But we can use $3 for $json_element.
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_elements: starting: "
					 "json_elements: json_elements JSON_COMMA json_element");
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: $1 ($json_elements) type: %s",
					 json_element_type_name($1));
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: $3 ($json_element) type: %s",
					 json_element_type_name($3));
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: about to perform: "
					 "XXX - need more code here - XXX");

	/* action */
	json_dbg(JSON_DBG_LOW, __func__, "under json_elements: XXX - need more code here - XXX"); /* XXX */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_elements: returning $$ ($json_elements) type: %s",
				         json_element_type_name($$));
	/* XXX - call json_dbg_tree_print when there is a value to process - XXX */
	json_dbg(JSON_DBG_LOW, __func__, "under json_elements: ending: "
					 "json_elements: json_elements JSON_COMMA json_element");
    }
    ;

json_element:

    json_value
    {
	/*
	 * $$ = $json_element
	 * $1 = $json_value
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_element: starting: "
					 "json_element: json_value");
	json_dbg(JSON_DBG_MED, __func__, "under json_element: $json_value type: %s",
					 json_element_type_name($json_value));
	json_dbg(JSON_DBG_MED, __func__, "under json_element: about to perform: "
					 "$json_element = $json_value;");

	/* action */
	$json_element = $json_value; /* magic: json_element becomes the json_value type */

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_element: returning $json_element type: %s",
				         json_element_type_name($json_element));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_element, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_element: ending: "
					 "json_element: json_value");
    }
    ;

json_string:

    JSON_STRING
    {
	/*
	 * $$ = $json_string
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_string: starting: "
					 "json_string: JSON_STRING");
	json_dbg(JSON_DBG_MED, __func__, "under json_string: ugly_text: <%s>", ugly_text);
	json_dbg(JSON_DBG_MED, __func__, "under json_string: ugly_leng: <%d>", ugly_leng);
	json_dbg(JSON_DBG_MED, __func__, "under json_string: about to perform: "
					 "$json_string = parse_json_string(ugly_text, ugly_leng);");

	/* action */
	$json_string = parse_json_string(ugly_text, ugly_leng);

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_string: returning $json_string type: %s",
				         json_element_type_name($json_string));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_string, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_string: ending: "
					 "json_string: JSON_STRING");
    }
    ;

json_number:

    JSON_NUMBER
    {
	/*
	 * $$ = $json_number
	 */

	/* pre-action debugging */
	json_dbg(JSON_DBG_LOW, __func__, "under json_number: starting: "
					 "json_number: JSON_NUMBER");
	json_dbg(JSON_DBG_MED, __func__, "under json_number: ugly_text: <%s>", ugly_text);
	json_dbg(JSON_DBG_MED, __func__, "under json_number: ugly_leng: <%d>", ugly_leng);
	json_dbg(JSON_DBG_MED, __func__, "under json_number: about to perform: "
					 "$json_number = parse_json_number(ugly_text);");

	/* action */
	$json_number = parse_json_number(ugly_text);

	/* post-action debugging */
	json_dbg(JSON_DBG_MED, __func__, "under json_number: returning $json_number type: %s",
				         json_element_type_name($json_number));
	/* XXX - adjust JSON_DBG_LOW to higher once all JSON items are parsed - XXX */
	json_dbg_tree_print(JSON_DBG_LOW, __func__, $json_number, JSON_DEFAULT_MAX_DEPTH, stderr);
	json_dbg(JSON_DBG_LOW, __func__, "under json_number: ending: "
					 "json_number: JSON_NUMBER");
    }
    ;


%%


/* Section 3: C code */


/*
 * ugly_error	- generate an error message for the scanner/parser
 *
 * given:
 *
 *	node	    struct json * or NULL
 *	format	    printf style format string
 *	...	    optional parameters based on the format
 *
 */
void
ugly_error(struct json *node, char const *format, ...)
{
    va_list ap;		/* variable argument list */

    /*
     * we don't really need to do this (at least for now) but to demonstrate how
     * the function gets whatever the node from ugly_parse() (originating in
     * parse_json()) we just print out the node type.
     */
    if (node != NULL) {
	json_dbg(JSON_DBG_MED, __func__, "in ugly_error: node type: %s", json_element_type_name(node));
    }

    /*
     * stdarg variable argument list setup
     */
    va_start(ap, format);

    /*
     * We use fprintf and vfprintf instead of err() but in the future this might
     * use an error function of some kind, perhaps a variant of jerr() (a
     * variant because the parser cannot provide all the information that the
     * jerr() function expects). In the validation code we will likely use
     * jerr(). It's possible that the function jerr() will change as well but
     * this will be decided after the parser is complete.
     */
    fprintf(stderr, "\nJSON parser error on line %d: ", ugly_lineno);
    vfprintf(stderr, format, ap);

    /*
     * NB This is a (somewhat ugly - but that's perfect for both JSON and bison
     * as noted in the programmer's apology and comments about the prefix ugly_)
     * hack (or maybe a better word is kludge) to show the text that triggered
     * the error assuming it was a syntax error. This is an assumption but we
     * know that it is called in other cases too e.g. for memory exhaustion.
     *
     * However this is okay because it's useful to have the text being processed
     * when the error occurs. Error reporting can still be improved.
     *
     * One of the ways it's a hack or kludge is that we simply append to the
     * generated message:
     *
     *	    ": %s\n", ugly_text
     *
     * without any foreknowledge of what the message actually is. We do however
     * check that ugly_text is not NULL and *ugly_text is not NUL; if this is
     * not satisfied then we only print a newline. This does mean though that
     * if it's a NUL byte it won't even be added but it wouldn't be visible
     * anyway. We could use the fprint_str() function in that case but this
     * makes it simpler and usually there won't be a NUL byte outside of a
     * string so this is not really important.
     */
    if (ugly_text != NULL && *ugly_text != '\0')
	fprintf(stderr, ": %s\n", ugly_text);
    else
	fprintf(stderr, "\n");

    /*
     * stdarg variable argument list clean up
     */
    va_end(ap);
}
