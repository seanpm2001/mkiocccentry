/*
 * chk_sem_auth - check .author.json semantics
 *
 * "Because grammar and syntax alone do not make a complete language." :-)
 *
 * The concept of this file was developed by:
 *
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * This file was auto-generated by:
 *
 *	make chk_sem_auth.c
 */


/* special comments for the seqcexit tool */
/*ooo*/ /* exit code out of numerical order - ignore in sequencing */
/*coo*/ /* exit code change of order - use new value in sequencing */


/*
 * chk_sem_auth - check .author.json semantics
 */
#include "chk_sem_auth.h"


struct json_sem sem_auth[SEM_AUTH_LEN] = {
/* depth    type        min     max   count  name_len validate  name */
  { 5,	JTYPE_NUMBER,	1,	5,	0,	0,	NULL,	NULL },
  { 5,	JTYPE_STRING,	21,	105,	0,	0,	NULL,	NULL },
  { 5,	JTYPE_BOOL,	2,	10,	0,	0,	NULL,	NULL },
  { 5,	JTYPE_NULL,	1,	25,	0,	0,	NULL,	NULL },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	11,	chk_affiliation,	"affiliation" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	13,	chk_author_handle,	"author_handle" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	13,	chk_author_number,	"author_number" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	14,	chk_default_handle,	"default_handle" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	5,	chk_email,	"email" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	6,	chk_github,	"github" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	13,	chk_location_code,	"location_code" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	13,	chk_location_name,	"location_name" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	4,	chk_name,	"name" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	11,	chk_past_winner,	"past_winner" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	7,	chk_twitter,	"twitter" },
  { 4,	JTYPE_MEMBER,	1,	5,	0,	3,	chk_url,	"url" },
  { 3,	JTYPE_OBJECT,	1,	5,	0,	0,	NULL,	NULL },
  { 2,	JTYPE_NUMBER,	6,	6,	0,	0,	NULL,	NULL },
  { 2,	JTYPE_STRING,	28,	28,	0,	0,	NULL,	NULL },
  { 2,	JTYPE_BOOL,	1,	1,	0,	0,	NULL,	NULL },
  { 2,	JTYPE_ARRAY,	1,	1,	0,	0,	NULL,	NULL },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	20,	chk_IOCCC_author_version,	"IOCCC_author_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	16,	chk_IOCCC_contest_id,	"IOCCC_contest_id" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	12,	chk_author_count,	"author_count" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	7,	chk_authors,	"authors" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	16,	chk_chkentry_version,	"chkentry_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	9,	chk_entry_num,	"entry_num" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	15,	chk_fnamchk_version,	"fnamchk_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	10,	chk_formed_UTC,	"formed_UTC" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	16,	chk_formed_timestamp,	"formed_timestamp" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	21,	chk_formed_timestamp_usec,	"formed_timestamp_usec" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	13,	chk_ioccc_contest,	"ioccc_contest" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	10,	chk_ioccc_year,	"ioccc_year" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	13,	chk_min_timestamp,	"min_timestamp" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	20,	chk_mkiocccentry_version,	"mkiocccentry_version" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	10,	chk_no_comment,	"no_comment" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	7,	chk_tarball,	"tarball" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	9,	chk_test_mode,	"test_mode" },
  { 1,	JTYPE_MEMBER,	1,	1,	0,	15,	chk_timestamp_epoch,	"timestamp_epoch" },
  { 0,	JTYPE_OBJECT,	1,	1,	0,	0,	NULL,	NULL },
};
