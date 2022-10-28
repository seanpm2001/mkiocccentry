/*
 * chk_sem_info - check .info.json semantics
 *
 * "Because grammar and syntax alone do not make a complete language." :-)
 *
 * The concept of this file was developed by:
 *
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * and it was auto-generated by:
 *
 *	make chk_sem_info.h
 *
 * The JSON parser was co-developed by:
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


#if !defined(INCLUDE_CHK_SEM_INFO_H)
#    define  INCLUDE_CHK_SEM_INFO_H


/*
 * json_sem - JSON semantics support
 */
#include "json_sem.h"


#if !defined(SEM_INFO_LEN)

#define SEM_INFO_LEN (51)

extern struct json_sem sem_info[SEM_INFO_LEN+1];

extern bool chk_Makefile(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_author_JSON(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_c_src(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_extra_file(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_info_JSON(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_remarks(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_contest_id(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_contest(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_info_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_year(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_Makefile_override(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_abstract(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_chkentry_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_empty_override(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_entry_num(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_first_rule_is_all(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_fnamchk_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_formed_UTC(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_formed_timestamp(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_formed_timestamp_usec(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_found_all_rule(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_found_clean_rule(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_found_clobber_rule(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_found_try_rule(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_highbit_warning(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_iocccsize_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_manifest(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_min_timestamp(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_mkiocccentry_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_no_comment(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_nul_warning(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_rule_2a_mismatch(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_rule_2a_override(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_rule_2a_size(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_rule_2b_override(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_rule_2b_size(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_tarball(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_test_mode(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_timestamp_epoch(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_title(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_trigraph_warning(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_txzchk_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_ungetc_warning(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_wordbuf_warning(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);

#endif /* SEM_INFO_LEN */


#endif /* INCLUDE_CHK_SEM_INFO_H */
