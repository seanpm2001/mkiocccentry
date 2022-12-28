#!/usr/bin/env make
#
# mkiocccentry and related tools - how to form an IOCCC entry
#
# For the mkiocccentry utility:
#
# Copyright (c) 2021,2022 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)
####

####
# For the iocccsize utility:
#
# This IOCCC size tool source file.  See below for the VERSION string.
#
# "You are not expected to understand this" :-)
#
# Public Domain 1992, 2015, 2018, 2019, 2021 by Anthony Howe.  All rights released.
# With IOCCC mods in 2019-2022 by chongo (Landon Curt Noll) ^oo^
####

####
# For the dbg facility:
#
# Copyright (c) 1989,1997,2018-2022 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)
####


#############
# utilities #
#############

# suggestion: List utility filenames, not paths.
#	      Do not list shell builtin (echo, cd, ...) tools.
#	      Keep the list in alphabetical order.
#
AWK= awk
CC= cc
CMP= cmp
CTAGS= ctags
DIFF= diff
GIT= git
GREP= grep
INDEPEND= independ
INSTALL= install
MAKE= make
PICKY= picky
RM= rm
RSYNC= rsync
SED= sed
SEQCEXIT= seqcexit
SHELL= bash
SHELLCHECK= shellcheck
SLEEP= sleep
TEE= tee
TR= tr


###########################
# Makefile directory name #
###########################

# The name of this directory
#
# This value is used to print the generic name of this directory
# so that various echo statements below can use this name
# to help distinguish themselves from echo statements used
# by Makefiles in other directories.
#
OUR_NAME= mkiocccentry


##################
# How to compile #
##################

# linker options
#
LDFLAGS=

# C source standards being used
#
# This repo supports c11 and later.
#
# NOTE: The use of -std=gnu11 is because there are a few older systems
#	in late 2021 that do not have compilers that (yet) support gnu17.
#	While there may be even more out of date systems that do not
#	support gnu11, we have to draw the line somewhere.
#
#	--------------------------------------------------
#
#	^^ the line is above :-)
#
# TODO - ###################################################################### - TODO #
# TODO - In 2023 we will will support only c17 so C_STD will become -std=gnu17  - TODO #
# TODO - ###################################################################### - TODO #
#
C_STD= -std=gnu11
#C_STD= -std=gnu17

# optimization and debug level
#
#C_OPT= -O3 -g3	# TODO - this will be the production release value - TODO #
C_OPT= -O0 -g

# Compiler warnings
#
#WARN_FLAGS= -Wall -Wextra	# TODO - this will be the production release value - TODO #
WARN_FLAGS= -Wall -Wextra -Werror


# how to compile
#
# We test by forcing warnings to be errors so you don't have to (allegedly :-) )
#
CFLAGS= ${C_STD} ${C_OPT} -pedantic ${WARN_FLAGS} ${LDFLAGS}


# NOTE: If you use ASAN, set this environment var:
#	ASAN_OPTIONS="detect_stack_use_after_return=1"
#
#CFLAGS= ${C_STD} -O0 -g -pedantic ${WARN_FLAGS} ${LDFLAGS} -fsanitize=address -fno-omit-frame-pointer


###############
# source code #
###############

# source files that are permanent (not made, nor removed)
#
C_SRC= mkiocccentry.c iocccsize.c fnamchk.c txzchk.c chkentry.c rule_count.c location.c sanity.c \
	entry_util.c entry_time.c
H_SRC= dbg/dbg.h chkentry.h limit_ioccc.h \
	mkiocccentry.h txzchk.h location.h utf8_posix_map.h jparse/jparse.h \
	dyn_array/dyn_array.h entry_util.h foo.h entry_time.h

# source files that do not conform to strict picky standards
#
LESS_PICKY_CSRC= utf8_posix_map.c foo.c
LESS_PICKY_HSRC= oebxergfB.h

# all shell scripts
#
SH_FILES= limit_ioccc.sh vermod.sh prep.sh reset_tstamp.sh hostchk.sh run_usage.sh bug_report.sh


######################
# intermediate files #
######################

# NOTE: intermediate files to make and removed by make clean
#
BUILT_C_SRC=
BUILT_H_SRC=
ALL_BUILT_SRC= ${BUILT_C_SRC} ${BUILT_H_SRC}

# NOTE: ${LIB_OBJS} are objects to put into a library and removed by make clean
#
LIB_OBJS=

# NOTE: ${OTHER_OBJS} are objects NOT put into a library and removed by make clean
#
OTHER_OBJS= mkiocccentry.o iocccsize.o fnamchk.o txzchk.o chkentry.o rule_count.o location.o sanity.o \
	  entry_util.o entry_time.o utf8_posix_map.o foo.o

# all intermediate files and removed by make clean
#
ALL_OBJS= ${LIB_OBJS} ${OTHER_OBJS}

# all source files
#
ALL_CSRC= ${C_SRC} ${LESS_PICKY_CSRC} ${BUILT_C_SRC}
ALL_HSRC= ${H_SRC} ${LESS_PICKY_HSRC} ${BUILT_H_SRC}
ALL_SRC= ${ALL_CSRC} ${ALL_HSRC} ${SH_FILES}


#######################
# install information #
#######################

# where to install
#
MAN1_DIR= /usr/local/share/man/man1
MAN3_DIR= /usr/local/share/man/man3
MAN8_DIR= /usr/local/share/man/man8
DEST_INCLUDE= /usr/local/include
DEST_LIB= /usr/local/lib
DEST_DIR= /usr/local/bin


#################################
# external Makefile information #
#################################

# may be used outside of this directory
#
EXTERN_H=
EXTERN_O=
EXTERN_MAN=
EXTERN_LIBA=
EXTERN_PROG= bug_report.sh chkentry fnamchk hostchk.sh iocccsize mkiocccentry prep.sh \
	reset_tstamp.sh run_usage.sh txzchk vermod.sh

# NOTE: ${EXTERN_CLOBBER} used outside of this directory and removed by make clobber
#
EXTERN_CLOBBER= ${EXTERN_O} ${EXTERN_LIBA} ${EXTERN_PROG}


######################
# target information #
######################

SH_TARGETS= limit_ioccc.sh

DSYMDIRS= mkiocccentry.dSYM iocccsize.dSYM fnamchk.dSYM txzchk.dSYM chkentry.dSYM
BUILD_LOG= build.log
TXZCHK_LOG= test_ioccc/txzchk_test.log

# NOTE: For valgrind, run with:
#
#	valgrind --leak-check=yes --track-origins=yes --leak-resolution=high --read-var-info=yes \
#           --leak-check=full --show-leak-kinds=all ./mkiocccentry ...
#
# NOTE: Replace mkiocccentry with whichever tool you want to test and the ...
# with the arguments and options you want.

ALL_SUBDIRS= all_dbg all_dyn_array all_jparse all_man all_soup all_test_ioccc

# where and what to install
#
TARGETS= ${ALL_SUBDIRS} mkiocccentry iocccsize fnamchk txzchk chkentry


############################################################
# User specific configurations - override Makefile values  #
############################################################

# The directive below retrieves any user specific configurations from makefile.local.
#
# The - before include means it's not an error if the file does not exist.
#
# We put this directive just before the first all rule so that you may override
# or modify any of the above Makefile variables.  To override a value, use := symbols.
# For example:
#
#	CC:= gcc
#
-include makefile.local


######################################
# all - default rule - must be first #
######################################

all: fast_hostchk just_all

# The original make all that bypasses running hostchk.sh
#
just_all: ${TARGETS}

# fast build environment sanity check
#
fast_hostchk: hostchk.sh
	@-./hostchk.sh -f -v 0; status="$$?"; if [ "$$status" -ne 0 ]; then \
	    ${MAKE} hostchk_warning; \
	fi

bug_report: bug_report.sh
	@-./bug_report.sh -v 1

# slower more verbose build environment sanity check
#
hostchk: hostchk.sh
	@-./hostchk.sh -v 1; status="$$?"; if [ "$$status" -ne 0 ]; then \
	    ${MAKE} hostchk_warning; \
	fi

# get the users attention when hostchk.sh finds a problem
#
hostchk_warning:
	@echo 1>&2
	@echo '=-= WARNING WARNING WARNING =-=' 1>&2
	@echo '=-= hostchk exited non-zero =-=' 1>&2
	@echo 1>&2
	@echo '=-= WARNING WARNING WARNING =-=' 1>&2
	@echo '=-= your build environment may not be able to compile =-=' 1>&2
	@echo '=-= mkiocccentry and friends =-=' 1>&2
	@echo 1>&2
	@echo '=-= WARNING WARNING WARNING =-=' 1>&2
	@echo '=-= For hints as to what might be wrong try running:' 1>&2
	@echo 1>&2
	@echo '    ./hostchk.sh -v 1' 1>&2
	@echo 1>&2
	@echo '=-= WARNING WARNING WARNING =-=' 1>&2
	@echo '=-= If you think this is a bug, consider filing a bug report via:' 1>&2
	@echo 1>&2
	@echo '    ./bug_report.sh' 1>&2
	@echo 1>&2
	@echo '=-= about to sleep 10 seconds =-=' 1>&2
	@echo 1>&2
	@${SLEEP} 10
	@echo '=-= Letting the compile continue in hopes it might be OK, =-=' 1>&2
	@echo '=-= even though we doubt it will be OK. =-=' 1>&2
	@echo 1>&2


#################################################
# .PHONY list of rules that do not create files #
#################################################

.PHONY: all just_all fast_hostchk hostchk hostchk_warning all_ref all_ref_ptch mkchk_sem bug_report.sh build \
	check_man clean clean_generated_obj clean_mkchk_sem clobber configure depend hostchk bug_report.sh \
	install test_ioccc legacy_clobber mkchk_sem parser parser-o picky prep prep_clobber \
        pull rebuild_jnum_test release reset_min_timestamp seqcexit shellcheck tags test test-chkentry use_ref \
	all_dbg all_dyn_array all_jparse all_man all_soup all_test_ioccc depend


####################################
# things to make in this directory #
####################################

rule_count.o: rule_count.c
	${CC} ${CFLAGS} -DMKIOCCCENTRY_USE rule_count.c -c

sanity.o: sanity.c
	${CC} ${CFLAGS} sanity.c -c

entry_util.o: entry_util.c
	${CC} ${CFLAGS} entry_util.c -c

entry_time.o: entry_time.c
	${CC} ${CFLAGS} entry_time.c -c

mkiocccentry.o: mkiocccentry.c
	${CC} ${CFLAGS} mkiocccentry.c -c

mkiocccentry: mkiocccentry.o rule_count.o entry_util.o \
	entry_time.o location.o utf8_posix_map.o sanity.o jparse/jparse.a dyn_array/dyn_array.a dbg/dbg.a
	${CC} ${CFLAGS} $^ -lm -o $@

iocccsize.o: iocccsize.c
	${CC} ${CFLAGS} -DMKIOCCCENTRY_USE iocccsize.c -c

iocccsize: iocccsize.o rule_count.o dbg/dbg.a
	${CC} ${CFLAGS} iocccsize.o rule_count.o dbg/dbg.a -o $@

fnamchk.o: fnamchk.c fnamchk.h
	${CC} ${CFLAGS} fnamchk.c -c

fnamchk: fnamchk.o jparse/jparse.a dyn_array/dyn_array.a dbg/dbg.a
	${CC} ${CFLAGS} $^ -o $@

txzchk.o: txzchk.c txzchk.h
	${CC} ${CFLAGS} txzchk.c -c

txzchk: txzchk.o location.o \
	utf8_posix_map.o sanity.o jparse/jparse.a dyn_array/dyn_array.a dbg/dbg.a
	${CC} ${CFLAGS} $^ -o $@

chkentry.o: chkentry.c chkentry.h jparse/jparse.h oebxergfB.h soup/chk_sem_info.h \
	soup/chk_sem_auth.h
	${CC} ${CFLAGS} chkentry.c -c

chkentry: chkentry.o entry_util.o foo.o location.o \
	entry_time.o jparse/jparse.a dyn_array/dyn_array.a dbg/dbg.a soup/soup.a
	${CC} ${CFLAGS} $^ -lm -o $@

foo.o: foo.c oebxergfB.h
	${CC} ${CFLAGS} foo.c -c

limit_ioccc.sh: limit_ioccc.h version.h dbg/dbg.h dyn_array/dyn_array.h jparse/jparse.h
	${RM} -f $@
	@echo '#!/usr/bin/env bash' > $@
	@echo '#' >> $@
	@echo '# Copies of select limit_ioccc.h and version.h values for shell script use' >> $@
	@echo '#' >> $@
	${GREP} -E '^#define (RULE_|MAX_|UUID_|MIN_|IOCCC_)' limit_ioccc.h | \
	    ${AWK} '{print $$2 "=\"" $$3 "\"" ;}' | ${TR} -d '[a-z]()' | \
	    ${SED} -e 's/"_/"/' -e 's/""/"/g' -e 's/^/export /' >> $@
	${GREP} -hE '^#define (.*_VERSION|TIMESTAMP_EPOCH|JSON_PARSING_DIRECTIVE_)' \
		     version.h limit_ioccc.h dbg/dbg.h dyn_array/dyn_array.h jparse/jparse.h | \
	    ${GREP} -v 'UUID_VERSION' | \
	    ${SED} -e 's/^#define/export/' -e 's/ "/="/' -e 's/"[	 ].*$$/"/' >> $@
	-if ${GREP} -q '^#define DIGRAPHS' limit_ioccc.h; then \
	    echo "export DIGRAPHS='yes'"; \
	else \
	    echo "export DIGRAPHS="; \
	fi >> $@
	-if ${GREP} -q '^#define TRIGRAPHS' limit_ioccc.h; then \
	    echo "export TRIGRAPHS='yes'"; \
	else \
	    echo "export TRIGRAPHS="; \
	fi >> $@


#########################################################
# rules that invoke Makefile rules in other directories #
#########################################################

all_dbg: dbg/Makefile
	@${MAKE} -C dbg all

all_dyn_array: dyn_array/Makefile
	@${MAKE} -C dyn_array all

all_jparse: jparse/Makefile
	@${MAKE} -C jparse all

all_man: man/Makefile
	@${MAKE} -C man all

all_soup: soup/Makefile
	@${MAKE} -C soup all

all_test_ioccc: test_ioccc/Makefile
	@${MAKE} -C test_ioccc all

dbg/dbg.h: dbg/Makefile
	@${MAKE} -C dbg extern_include

dbg/dbg.a: dbg/Makefile
	@${MAKE} -C dbg extern_liba

dbg/man/man3/dbg.3: dbg/Makefile
	@${MAKE} -C dbg extern_man

dbg/dbg_test: dbg/Makefile
	@${MAKE} -C dbg dbg_test

dyn_array/dyn_array.h: dyn_array/Makefile
	@${MAKE} -C dyn_array extern_include

dyn_array/dyn_array.a: dyn_array/Makefile
	@${MAKE} -C dyn_array extern_liba

dyn_array/man/man3/dyn_array.3: dyn_array/Makefile
	@${MAKE} -C dyn_array extern_man

jparse/jparse.h: jparse/Makefile
	@${MAKE} -C jparse extern_include

jparse/jparse.a: jparse/Makefile
	@${MAKE} -C jparse extern_liba

jparse/jparse: jparse/Makefile
	@${MAKE} -C jparse extern_prog

jparse/man/man1/jparse.1: jparse/Makefile
	@${MAKE} -C jparse extern_man

jparse/man/man8/jparse_test.8: jparse/Makefile
	@${MAKE} -C jparse extern_man

jparse/jsemtblgen: jparse/Makefile
	@${MAKE} -C jparse extern_prog

jparse/jsemcgen.sh: jparse/Makefile
	@${MAKE} -C jparse extern_prog

soup/soup.a: soup/Makefile
	@${MAKE} -C soup extern_liba

soup/chk_sem_info.h: soup/Makefile
	@${MAKE} -C soup extern_include

soup/chk_sem_auth.h: soup/Makefile
	@${MAKE} -C soup extern_include

soup/soup.h: soup/Makefile
	@${MAKE} -C soup extern_include

test_ioccc: test_ioccc/Makefile
	${MAKE} -C test_ioccc test_ioccc


####################################
# rules for use by other Makefiles #
####################################


###########################################################
# repo tools - rules for those who maintain the this repo #
###########################################################

# make build release pull
#
# Things to do before a release, forming a pull request and/or updating the
# GitHub repo.
#
# This runs through all of the prep steps, exiting on the first failure.
#
# NOTE: The reference copies of the JSON parser C code will NOT be used
# so if bison and/or flex is not found or too old THIS RULE WILL FAIL!
#
# NOTE: Please try this rule BEFORE make prep.
#
build release pull: prep.sh
	${RM} -f ${BUILD_LOG}
	@echo "./prep.sh -e -o 2>&1 | ${TEE} ${BUILD_LOG}"
	@./prep.sh -e -o 2>&1 | ${TEE} "${BUILD_LOG}"; \
	    EXIT_CODE="$${PIPESTATUS[0]}"; \
	    if [[ $$EXIT_CODE -ne 0 ]]; then \
		echo "=-=-=-=-= Warning: prep.sh error code: $$EXIT_CODE =-=-=-=-=" 1>&2; \
		echo 1>&2; \
		echo "NOTE: The above details were saved in the file: ${BUILD_LOG}"; \
		echo 1>&2; \
		exit 1; \
	    else \
		echo "NOTE: The above details were saved in the file: ${BUILD_LOG}"; \
	    fi

# make prep
#
# Things to do before a release, forming a pull request and/or updating the
# GitHub repo.
#
# This runs through all of the prep steps.  If some step failed along the way,
# exit non-zero at the end.
#
# NOTE: This rule is useful if for example you're not working on the parser and
# you're on a system without the proper versions of flex and/or bison but you
# still want to work on the repo. Another example use is if you don't have
# shellcheck and/or picky and you want to work on the repo.
#
# The point is: if you're working on this repo and make build fails, try this
# rule instead.
#
prep: prep.sh
	${RM} -f ${BUILD_LOG}
	@echo "./prep.sh 2>&1 | ${TEE} ${BUILD_LOG}"
	@-./prep.sh 2>&1 | ${TEE} "${BUILD_LOG}"; \
	    EXIT_CODE="$${PIPESTATUS[0]}"; \
	    if [[ $$EXIT_CODE -ne 0 ]]; then \
		echo "=-=-=-=-= Warning: prep.sh error code: $$EXIT_CODE =-=-=-=-=" 1>&2; \
		echo 1>&2; \
	    fi
	@echo NOTE: The above details were saved in the file: ${BUILD_LOG}

# make parser
#
# Force the rebuild of the JSON parser and then form the reference copies of
# JSON parser C code (if recent enough version of flex and bison are found).
#
parser: jparse/Makefile
	${MAKE} -C jparse parser

#
# make parser-o: Force the rebuild of the JSON parser.
#
# NOTE: This does NOT use the reference copies of JSON parser C code.
#
parser-o: jparse/Makefile
	${MAKE} -C jparse RUN_O_FLAG='-o' parser

# restore reference code that was produced by previous successful make parser
#
# This rule forces the use of reference copies of JSON parser C code.
#
use_ref: jparse/Makefile
	${MAKE} -C jparse use_ref

# sequence exit codes
#
seqcexit: ${ALL_CSRC}
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	@HAVE_SEQCEXIT="`type -P ${SEQCEXIT}`"; if [[ -z "$$HAVE_SEQCEXIT" ]]; then \
	    echo 'The seqcexit tool could not be found.' 1>&2; \
	    echo 'The seqcexit tool is required for this rule.'; 1>&2; \
	    echo ''; 1>&2; \
	    echo 'See the following GitHub repo for seqcexit:'; 1>&2; \
	    echo ''; 1>&2; \
	    echo '    https://github.com/lcn2/seqcexit'; 1>&2; \
	    echo ''; 1>&2; \
	    exit 1; \
	else \
	    echo "${SEQCEXIT} -D werr_sem_val -D werrp_sem_val -- ${ALL_CSRC}"; \
	    ${SEQCEXIT} -D werr_sem_val -D werrp_sem_val -- ${ALL_CSRC}; \
	fi
	@echo
	@echo "${OUR_NAME}: make $@ complete"

picky: ${ALL_SRC}
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	@if ! type -P ${PICKY} >/dev/null 2>&1; then \
	    echo "The picky tool could not be found." 1>&2; \
	    echo "The picky tool is required for this rule." 1>&2; \
	    echo "We recommend you install picky v2.6 or later" 1>&2; \
	    echo "from this URL:" 1>&2; \
	    echo 1>&2; \
	    echo "http://grail.eecs.csuohio.edu/~somos/picky.html" 1>&2; \
	    echo 1>&2; \
	    exit 1; \
	else \
	    echo "${PICKY} -w132 -u -s -t8 -v -e -- ${C_SRC} ${H_SRC}"; \
	    ${PICKY} -w132 -u -s -t8 -v -e -- ${C_SRC} ${H_SRC}; EXIT_CODE="$$?"; \
	    if [[ $$EXIT_CODE -ne 0 ]]; then echo "make $@: ERROR: CODE[1]: $$EXIT_CODE" 1>&2; exit 1; fi; \
	    echo "${PICKY} -w -u -s -t8 -v -e -8 -- ${SH_FILES}"; \
	    ${PICKY} -w -u -s -t8 -v -e -8 -- ${SH_FILES}; EXIT_CODE="$$?"; \
	    if [[ $$EXIT_CODE -ne 0 ]]; then echo "make $@: ERROR: CODE[2]: $$EXIT_CODE" 1>&2; exit 2; fi; \
	    echo "${PICKY} -w132 -u -s -t8 -v -e -8 -- ${LESS_PICKY_CSRC} ${LESS_PICKY_HSRC}"; \
	    ${PICKY} -w132 -u -s -t8 -v -e -8 -- ${LESS_PICKY_CSRC} ${LESS_PICKY_HSRC}; EXIT_CODE="$$?"; \
	    if [[ $$EXIT_CODE -ne 0 ]]; then echo "make $@: ERROR: CODE[3]: $$EXIT_CODE" 1>&2; exit 3; fi; \
	fi
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# inspect and verify shell scripts
#
shellcheck: ${SH_FILES} .shellcheckrc
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	@HAVE_SHELLCHECK="`type -P ${SHELLCHECK}`"; if [[ -z "$$HAVE_SHELLCHECK" ]]; then \
	    echo 'The shellcheck command could not be found.' 1>&2; \
	    echo 'The shellcheck command is required to run this rule.'; 1>&2; \
	    echo ''; 1>&2; \
	    echo 'See the following GitHub repo for shellcheck:'; 1>&2; \
	    echo ''; 1>&2; \
	    echo '    https://github.com/koalaman/shellcheck.net'; 1>&2; \
	    echo ''; 1>&2; \
	    echo 'Or use the package manager in your OS to install it.' 1>&2; \
	    exit 1; \
	else \
	    echo "${SHELLCHECK} -f gcc -- ${SH_FILES}"; \
	    ${SHELLCHECK} -f gcc -- ${SH_FILES}; EXIT_CODE="$$?"; \
	    if [[ $$EXIT_CODE -ne 0 ]]; then echo "make $@: ERROR: CODE[1]: $$EXIT_CODE" 1>&2; exit 1; fi; \
	fi
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# inspect and verify man pages
#
check_man: man/Makefile
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C man check_man
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# vi/vim tags
#
tags: ${ALL_CSRC} ${ALL_HSRC}
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	-${CTAGS} ${ALL_CSRC} ${ALL_HSRC} 2>&1 | \
	     ${GREP} -E -v 'Duplicate entry|Second entry ignored'
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# Only run this rule when you wish to invalidate all timestamps
# prior to now, such as when you make a fundamental change to a
# critical JSON format, or make a fundamental change the compressed
# tarball file structure, or make a critical change to limit_ioccc.h
# that is MORE restrictive.
#
# DO NOT run this rule simply for a new IOCCC!
#
# Yes, we make it very hard to run this rule for good reason.
# Only IOCCC judges can perform ALL the steps needed to complete this action.
#
reset_min_timestamp: reset_tstamp.sh
	./reset_tstamp.sh

# perform all of the mkiocccentry repo required tests
#
test: all
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	@echo
	@echo 'All tests PASSED'

# run test-chkentry on test_JSON files
#
test-chkentry: all chkentry test_ioccc/test-chkentry.sh
	./test_ioccc/test-chkentry.sh -v 1

# rule used by prep.sh and make clean
#
clean_generated_obj:
	${MAKE} -C jparse clean_generated_obj

# rule used by prep.sh
#
clean_mkchk_sem:
	${RM} -f soup/chk_sem_auth.c soup/chk_sem_auth.h soup/chk_sem_auth.o
	${RM} -f soup/chk_sem_info.c soup/chk_sem_info.h soup/chk_sem_info.o

# rule used by make clean
#
prep_clean: legacy_clean
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# rule used by prep.sh and make clobber
#
prep_clobber: prep_clean legacy_clobber
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	${RM} -f ${TARGETS}
	${RM} -f answers.txt
	${RM} -f tags
	${RM} -f jparse.output
	${RM} -f ${TXZCHK_LOG}
	${RM} -f legacy_os
	${RM} -rf legacy_os.dSYM
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# clean legacy code and files - files that are no longer needed
#
legacy_clean:
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	${RM} -f jint.o jint_gen.o
	${RM} -f jfloat.o jfloat_gen.o
	${RM} -f jauthchk.o jinfochk.o jnum_gen.o jsemtblgen.o jstrdecode.o jstrencode.o verge.o
	${RM} -f jparse.tab.o jparse_main.o json_parse.o
	@echo
	@echo "${OUR_NAME}: make $@ complete"

# clobber legacy code and files - files that are no longer needed
#
legacy_clobber: legacy_clean
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C jparse $@
	${MAKE} -C man $@
	${MAKE} -C soup $@
	${MAKE} -C test_ioccc $@
	${RM} -f jint jfloat
	${RM} -f jint.set.tmp jint_gen
	${RM} -f jfloat.set.tmp jfloat_gen
	${RM} -rf jint_gen.dSYM jfloat_gen.dSYM
	${RM} -f jnumber
	${RM} -rf jnumber.dSYM
	${RM} -f jauthchk
	${RM} -rf jauthchk.dSYM
	${RM} -f jinfochk
	${RM} -rf jinfochk.dSYM
	${RM} -rf ref
	${RM} -f chk.{auth,info}.{head,tail,ptch}.{c,h}
	${RM} -f chk_sem_auth.o chk_sem_info.o chk_validate.o
	${RM} -rf test_iocccsize test_src test_work
	${RM} -f dbg_test.c dbg_test.out
	${RM} -rf dyn_test.dSYM
	${RM} -f jparse_test.log chkentry_test.log txzchk_test.log
	${RM} -f test_ioccc.log chkentry_test.log jparse_test.log txzchk_test.log
	${RM} -f jnum_chk
	${RM} -rf jnum_chk.dSYM
	${RM} -rf test_iocccsize test_src test_work
	${RM} -f .exit_code.*
	${RM} -f dbg.out
	${RM} -rf ioccc_test test
	${RM} -f jparse.lex.h jparse.tab.c jparse.tab.h jparse.c
	@echo
	@echo "${OUR_NAME}: make $@ complete"


########################################################################
# external repositories - rules to help incorporate other repositories #
########################################################################

# This repo is designed to be a standalone repo.  Even though we use other
# repositories, we prefer to NOT clone them.  We want this repo to depend
# on a specific version of such code so that a change in the code of those
# external repositories will NOT impact this repo.
#
# For that reason, and others, we maintain a private copy of an external
# repository as clone.repo.  The clone.repo directory is excluded from
# out repo via the .gitignore file.  We copy clone.repo/ into repo/ and
# check in those file directly into this repo.
#
# The following rules are used by the people who maintain this repo.
# If you are not someone who maintains this repo, the rules in this section
# are probably not for you.

.PHONY: dbg.clone dbg.diff dbg.fetch dbg.reclone dbg.reload dbg.rsync dbg.status \
        dyn_array/dyn_array.clone dyn_array.diff dyn_array.fetch dyn_array.reclone dyn_array.reload \
	dyn_array.rsync dyn_array.status jparse.clone jparse.diff jparse.fetch jparse.reclone \
	jparse.reload jparse.rsync jparse.status all.clone all.diff all.fetch all.reclone \
	all.reload all.rsync all.status

# dbg external repo
#
dbg.clone:
	${GIT} clone https://github.com/lcn2/dbg.git dbg.clone

dbg.diff: dbg.clone/ dbg/ .exclude
	${DIFF} -u -r --exclude-from=.exclude dbg.clone dbg

dbg.fetch: dbg.clone/
	cd dbg.clone && ${GIT} fetch
	cd dbg.clone && ${GIT} fetch --prune --tags
	cd dbg.clone && ${GIT} merge --ff-only || ${GIT} rebase --rebase-merges
	${GIT} status dbg.clone

dbg.reclone:
	${RM} -rf dbg.clone
	${MAKE} dbg.clone

dbg.reload: dbg.clone/
	${RM} -rf dbg
	${MAKE} dbg.rsync

dbg.rsync: dbg.clone/ .exclude
	${RSYNC} -a -S -0 --delete -C --exclude-from=.exclude -v dbg.clone/ dbg

dbg.status: dbg.clone/
	${GIT} status dbg.clone

# dyn_array external repo
#
dyn_array/dyn_array.clone:
	@echo 'rule disabled, enable once dyn_array repo exists'
	@#${GIT} clone https://github.com/lcn2/dyn_array.git dyn_array/dyn_array.clone

dyn_array.diff: dyn_array/dyn_array.clone/ dyn_array/ .exclude
	@#${DIFF} -u -r --exclude-from=.exclude dyn_array/dyn_array.clone dyn_array

dyn_array.fetch: dyn_array/dyn_array.clone/
	@#cd dyn_array/dyn_array.clone && ${GIT} fetch
	@#cd dyn_array/dyn_array.clone && ${GIT} fetch --prune --tags
	@#cd dyn_array/dyn_array.clone && ${GIT} merge --ff-only || ${GIT} rebase --rebase-merges
	@#${GIT} status dyn_array/dyn_array.clone

dyn_array.reclone:
	@echo 'rule disabled, enable once dyn_array repo exists'
	@#${RM} -rf dyn_array/dyn_array.clone
	@#${MAKE} dyn_array/dyn_array.clone

dyn_array.reload: dyn_array/dyn_array.clone/
	@#${RM} -rf dyn_array
	@#${MAKE} dyn_array.rsync

dyn_array.rsync: dyn_array/dyn_array.clone/ .exclude
	@#${RSYNC} -a -S -0 --delete -C --exclude-from=.exclude -v dyn_array/dyn_array.clone/ dyn_array

dyn_array.status: dyn_array/dyn_array.clone/
	@#${GIT} status dyn_array/dyn_array.clone

# jparse external repo
#
jparse.clone:
	@echo 'rule disabled, enable once jparse repo exists'
	@#${GIT} clone https://github.com/xexyl/jparse.git jparse.clone

jparse.diff: jparse.clone/ jparse/ .exclude
	@#${DIFF} -u -r --exclude-from=.exclude jparse.clone jparse

jparse.fetch: jparse.clone/
	@#cd jparse.clone && ${GIT} fetch
	@#cd jparse.clone && ${GIT} fetch --prune --tags
	@#cd jparse.clone && ${GIT} merge --ff-only || ${GIT} rebase --rebase-merges
	@#${GIT} status jparse.clone

jparse.reclone:
	@echo 'rule disabled, enable once jparse repo exists'
	@#${RM} -rf jparse.clone
	@#${MAKE} jparse.clone

jparse.reload: jparse.clone/
	@#${RM} -rf jparse
	@#${MAKE} jparse.rsync

jparse.rsync: jparse.clone/ .exclude
	@#${RSYNC} -a -S -0 --delete -C --exclude-from=.exclude -v jparse.clone/ jparse

jparse.status: jparse.clone/
	@#${GIT} status jparse.clone


# rules to operate on all external repositories
#
all.clone: dbg.clone dyn_array/dyn_array.clone jparse.clone

all.diff: dbg.diff dyn_array.diff jparse.diff

all.fetch: dbg.fetch dyn_array.fetch jparse.fetch

all.reclone: dbg.reclone dyn_array.reclone jparse.reclone

all.reload: dbg.reload dyn_array.reload jparse.reload

all.rsync: dbg.rsync dyn_array.rsync jparse.rsync

all.status: dbg.status dyn_array.status jparse.status


###################################
# standard Makefile utility rules #
###################################

configure:
	@echo nothing to configure

clean: clean_generated_obj legacy_clean
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C test_ioccc $@
	${MAKE} -C soup $@
	${MAKE} -C man $@
	${MAKE} -C jparse $@
	@echo
	${RM} -f ${OTHER_OBJS} ${LESS_PICKY_OBJS}
	${RM} -rf ${DSYMDIRS}
	@echo
	@echo "${OUR_NAME}: make $@ complete"

clobber: clean prep_clobber
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	${MAKE} -C dbg $@
	${MAKE} -C dyn_array $@
	${MAKE} -C test_ioccc $@
	${MAKE} -C soup $@
	${MAKE} -C man $@
	${MAKE} -C jparse $@
	@echo
	${RM} -f ${BUILD_LOG}
	${RM} -f .all_ref.*
	${RM} -rf .hostchk.work.*
	${RM} -f .sorry.*
	${RM} -f .txzchk_test,*
	@echo
	@echo "${OUR_NAME}: make $@ complete"

install: all
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	@${MAKE} -C dbg $@
	@# we have to first make sure the directories exist!
	${INSTALL} -v -d -m 0755 ${DEST_DIR}
	${INSTALL} -v -m 0555 ${TARGETS} ${SH_TARGETS} ${DEST_DIR}
	${MAKE} -C man install
	@echo
	@echo "${OUR_NAME}: make $@ complete"


###############
# make depend #
###############

depend: ${ALL_CSRC} all
	@echo
	@echo "${OUR_NAME}: make $@ starting"
	@echo
	@${MAKE} -C dbg $@
	@${MAKE} -C dyn_array $@
	@${MAKE} -C test_ioccc $@
	@${MAKE} -C soup $@
	@${MAKE} -C man $@
	@${MAKE} -C jparse $@
	@echo
	@${SED} -i.orig -n -e '1,/^### DO NOT CHANGE MANUALLY BEYOND THIS LINE/p' Makefile
	${CC} ${CFLAGS} -MM -I. ${ALL_CSRC} | ${INDEPEND} >> Makefile
	@-if ${CMP} -s Makefile.orig Makefile; then \
	    ${RM} -f Makefile.orig; \
	else \
	    echo; \
	    echo "${OUR_NAME}: Makefile dependencies updated"; \
	    echo; \
	    echo "${OUR_NAME}: Previous version may be found in: Makefile.orig"; \
	fi
	@echo
	@echo "${OUR_NAME}: make $@ complete"

### DO NOT CHANGE MANUALLY BEYOND THIS LINE
chkentry.o: chkentry.c chkentry.h dbg/dbg.h foo.h jparse/../dbg/dbg.h \
    jparse/../dyn_array/../dbg/dbg.h jparse/../dyn_array/dyn_array.h \
    jparse/jparse.h jparse/jparse.tab.h jparse/json_parse.h \
    jparse/json_sem.h jparse/json_util.h jparse/util.h soup/../entry_util.h \
    soup/../jparse/json_sem.h soup/../jparse/json_util.h \
    soup/chk_sem_auth.h soup/chk_sem_info.h soup/chk_validate.h soup/soup.h \
    version.h
entry_time.o: dbg/dbg.h entry_time.c entry_time.h jparse/../dbg/dbg.h \
    jparse/../dyn_array/../dbg/dbg.h jparse/../dyn_array/dyn_array.h \
    jparse/jparse.h jparse/jparse.tab.h jparse/json_parse.h \
    jparse/json_sem.h jparse/json_util.h jparse/util.h limit_ioccc.h \
    version.h
entry_util.o: dbg/dbg.h entry_time.h entry_util.c entry_util.h \
    jparse/../dbg/dbg.h jparse/../dyn_array/../dbg/dbg.h \
    jparse/../dyn_array/dyn_array.h jparse/jparse.h jparse/jparse.tab.h \
    jparse/json_parse.h jparse/json_sem.h jparse/json_util.h jparse/util.h \
    limit_ioccc.h location.h version.h
fnamchk.o: dbg/dbg.h fnamchk.c fnamchk.h jparse/../dbg/dbg.h \
    jparse/../dyn_array/../dbg/dbg.h jparse/../dyn_array/dyn_array.h \
    jparse/jparse.h jparse/jparse.tab.h jparse/json_parse.h \
    jparse/json_sem.h jparse/json_util.h jparse/util.h limit_ioccc.h \
    utf8_posix_map.h version.h
foo.o: dbg/dbg.h foo.c foo.h oebxergfB.h
iocccsize.o: iocccsize.c iocccsize.h iocccsize_err.h
location.o: dbg/dbg.h jparse/../dbg/dbg.h jparse/../dyn_array/../dbg/dbg.h \
    jparse/../dyn_array/dyn_array.h jparse/jparse.h jparse/jparse.tab.h \
    jparse/json_parse.h jparse/json_sem.h jparse/json_util.h jparse/util.h \
    location.c location.h
mkiocccentry.o: dbg/dbg.h entry_util.h iocccsize.h jparse/../dbg/dbg.h \
    jparse/../dyn_array/../dbg/dbg.h jparse/../dyn_array/dyn_array.h \
    jparse/jparse.h jparse/jparse.tab.h jparse/json_parse.h \
    jparse/json_sem.h jparse/json_util.h jparse/util.h limit_ioccc.h \
    location.h mkiocccentry.c mkiocccentry.h sanity.h utf8_posix_map.h \
    version.h
rule_count.o: iocccsize.h iocccsize_err.h rule_count.c
sanity.o: dbg/dbg.h jparse/../dbg/dbg.h jparse/../dyn_array/../dbg/dbg.h \
    jparse/../dyn_array/dyn_array.h jparse/jparse.h jparse/jparse.tab.h \
    jparse/json_parse.h jparse/json_sem.h jparse/json_util.h jparse/util.h \
    limit_ioccc.h location.h sanity.c sanity.h utf8_posix_map.h version.h
txzchk.o: dbg/dbg.h entry_util.h jparse/../dbg/dbg.h \
    jparse/../dyn_array/../dbg/dbg.h jparse/../dyn_array/dyn_array.h \
    jparse/jparse.h jparse/jparse.tab.h jparse/json_parse.h \
    jparse/json_sem.h jparse/json_util.h jparse/util.h limit_ioccc.h \
    location.h sanity.h txzchk.c txzchk.h utf8_posix_map.h version.h
utf8_posix_map.o: dbg/dbg.h jparse/../dbg/dbg.h \
    jparse/../dyn_array/../dbg/dbg.h jparse/../dyn_array/dyn_array.h \
    jparse/jparse.h jparse/jparse.tab.h jparse/json_parse.h \
    jparse/json_sem.h jparse/json_util.h jparse/util.h limit_ioccc.h \
    utf8_posix_map.c utf8_posix_map.h version.h
