/*
 * jnum_test - convert JSON integer strings
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


/* special comments for the seqcexit tool */
/* exit code out of numerical order - ignore in sequencing - ooo */
/* exit code change of order - use new value in sequencing - coo */

#include <sys/types.h>
#include <stdio.h>

#define JNUM_TEST

/*
 * json_parse - JSON parser support code
 */
#include "../json_parse.h"

/*
 * jnum_chk - tool to check JSON number string conversions
 */
#include "jnum_chk.h"


/*
 * NOTE: The file jnum_header.c contains the header for jnum_test.c
 *
 *	 The code below is auto-generated by the jnum_gen tool
 *	 via the make rebuild_jnum_test rule.
 */
