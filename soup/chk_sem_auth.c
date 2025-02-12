/*
 * chk_sem_auth - check .auth.json semantics
 *
 * "Because grammar and syntax alone do not make a complete language." :-)
 *
 * The concept of this file was developed by:
 *
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * and it was auto-generated by:
 *
 *	make mkchk_sem
 *
 * The JSON parser was co-developed in 2022 by:
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


/*
 * chk_sem_auth - check .auth.json semantics
 */
#include "chk_sem_auth.h"


struct json_sem sem_auth[SEM_AUTH_LEN+1] = {
/* depth    type        min     max   count   index  name_len validate  name */
  { 5,	JTYPE_NUMBER,	1,	5,	5,	0,	0,	NULL,	NULL },
  { 5,	JTYPE_STRING,	16,	114,	114,	1,	0,	NULL,	NULL },
  { 5,	JTYPE_BOOL,	2,	10,	10,	2,	0,	NULL,	NULL },
  { 5,	JTYPE_NULL,	0,	30,	30,	3,	0,	NULL,	NULL },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	4,	11,	chk_affiliation,	"affiliation" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	5,	13,	chk_author_handle,	"author_handle" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	6,	13,	chk_author_number,	"author_number" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	7,	14,	chk_default_handle,	"default_handle" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	8,	5,	chk_email,	"email" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	9,	6,	chk_github,	"github" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	10,	13,	chk_location_code,	"location_code" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	11,	13,	chk_location_name,	"location_name" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	12,	8,	chk_mastodon,	"mastodon" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	13,	4,	chk_name,	"name" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	14,	11,	chk_past_winner,	"past_winner" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	15,	3,	chk_url,	"url" },
  { 4,	JTYPE_MEMBER,	1,	5,	5,	16,	7,	chk_alt_url,	"alt_url" },
  { 3,	JTYPE_OBJECT,	1,	5,	5,	17,	0,	NULL,	NULL },
  { 2,	JTYPE_NUMBER,	6,	6,	6,	18,	0,	NULL,	NULL },
  { 2,	JTYPE_STRING,	28,	28,	28,	19,	0,	NULL,	NULL },
  { 2,	JTYPE_BOOL,	1,	1,	1,	20,	0,	NULL,	NULL },
  { 2,	JTYPE_ARRAY,	1,	1,	1,	21,	0,	NULL,	NULL },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	22,	18,	chk_IOCCC_auth_version,	"IOCCC_auth_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	23,	13,	chk_IOCCC_contest,	"IOCCC_contest" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	24,	16,	chk_IOCCC_contest_id,	"IOCCC_contest_id" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	25,	10,	chk_IOCCC_year,	"IOCCC_year" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	26,	12,	chk_author_count,	"author_count" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	27,	7,	chk_authors,	"authors" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	28,	16,	chk_chkentry_version,	"chkentry_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	29,	9,	chk_entry_num,	"entry_num" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	30,	15,	chk_fnamchk_version,	"fnamchk_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	31,	10,	chk_formed_UTC,	"formed_UTC" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	32,	16,	chk_formed_timestamp,	"formed_timestamp" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	33,	21,	chk_formed_timestamp_usec,	"formed_timestamp_usec" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	34,	13,	chk_min_timestamp,	"min_timestamp" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	35,	20,	chk_mkiocccentry_version,	"mkiocccentry_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	36,	10,	chk_no_comment,	"no_comment" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	37,	7,	chk_tarball,	"tarball" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	38,	9,	chk_test_mode,	"test_mode" },
  { 1,	JTYPE_MEMBER,	1,	1,	1,	39,	15,	chk_timestamp_epoch,	"timestamp_epoch" },
  { 0,	JTYPE_OBJECT,	1,	1,	1,	40,	0,	NULL,	NULL },
  { 0,	JTYPE_UNSET,	0,	0,	0,	-1,	0,	NULL,	NULL }
};
