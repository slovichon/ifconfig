/*
 * Copyright 2004 Jared Yanovich <jjy2@pitt.edu>.  All rights reserved.
 *
 * This software is public domain.
 */

%token IMK8022 IMK8022TR IMK8023 IMKETHERII IMKADVBASE IMKADVSKEW
%token IMKALIAS IMKANYCAST IMKARP IMKBROADCAST IMKDEBUG IMKDELETE
%token IMKDELETETUNNEL IMKDOWN IMKEUI64 IMKTUNNEL IMKINSTANCE
%token IMKLINK0 IMKLINK1 IMKLINK2 IMKMAXUPD IMKMEDIA IMKMEDIAOPT
%token IMKMETRIC IMKMTU IMKNETMASK IMKNSELLENGTH IMKNWID IMKNWKEY
%token IMKPASS IMKPERSIST IMKPHASE IMKPLTIME IMKPOWERSAVE
%token IMKPOWERSAVESLEEP IMKPREFIXLEN IMKRANGE IMKSNAP IMKSNPAOFFSET
%token IMKSTATE IMKSYNCIF IMKTENTATIVE IMKTRAILERS IMKTUNNEL
%token IMKUP IMKVHID IMKVLAN IMKVLANDEV IMKVLTIME

%token IFACE NUMBER IP4ADDR IPV6ADDR

%{
#include "y.tab.h"

/* Interface modifiers (must be sorted). */
struct ifcmod {
	char *name;	/* Keyword name. */
	int inet6:1;	/* INET6-only. */
	int notinet:1;	/* Part of INET. */
	int neg:1;	/* Whether option can be negated (-opt). */
	int val;	/* yacc value. */
} ifcmods[] = {
	{ "802.2",		0, 1, 0, IMK8022		},
	{ "802.2tr",		0, 1, 0, IMK8022TR		},
	{ "802.3",		0, 1, 0, IMK8023		},
	{ "EtherII",		0, 1, 0, IMKETHERII		},
	{ "advbase",		0, 1, 0, IMKADVBASE		},
	{ "advskew",		0, 1, 0, IMKADVSKEW		},
	{ "alias",		0, 0, 1, IMKALIAS		},
	{ "anycast",		1, 0, 1, IMKANYCAST		},
	{ "arp",		0, 0, 1, IMKARP			},
	{ "broadcast",		0, 0, 0, IMKBROADCAST		},
	{ "debug",		0, 0, 1, IMKDEBUG		},
	{ "delete",		0, 0, 0, IMKDELETE		},
	{ "deletetunnel",	0, 0, 0, IMKDELETETUNNEL	},
	{ "down",		0, 0, 0, IMKDOWN		},
	{ "eui64",		1, 0, 0, IMKEUI64		},
	/* Backwards compatibility. */
	{ "giftunnel",		0, 0, 0, IMKTUNNEL		},
	{ "instance",		0, 0, 0, IMKTUNNEL		},
	{ "inst",		0, 0, 0, IMKINSTANCE		},
	{ "ipdst",		0, 0, 0, IMKINSTANCE		},
	{ "link0",		0, 0, 1, IMKLINK0		},
	{ "link1",		0, 0, 1, IMKLINK1		},
	{ "link2",		0, 0, 1, IMKLINK2		},
	{ "maxupd",		0, 1, 0, IMKMAXUPD		},
	{ "media",		0, 0, 0, IMKMEDIA		},
	{ "mediaopt",		0, 0, 1, IMKMEDIAOPT		},
	{ "metric",		0, 0, 0, IMKMETRIC		},
	{ "mtu",		0, 0, 0, IMKMTU			},
	{ "netmask",		0, 0, 0, IMKNETMASK		},
	{ "nsellength",		0, 1, 0, IMKNSELLENGTH		},
	{ "nwid",		0, 0, 0, IMKNWID		},
	{ "nwkey",		0, 0, 1, IMKNWKEY		},
	{ "pass",		0, 1, 0, IMKPASS		},
	{ "persist",		0, 0, 0, IMKPERSIST		},
	{ "phase",		0, 1, 0, IMKPHASE		},
	{ "pltime",		1, 0, 0, IMKPLTIME		},
	{ "powersave",		0, 0, 1, IMKPOWERSAVE		},
	{ "powersavesleep",	0, 0, 0, IMKPOWERSAVESLEEP	},
	{ "prefixlen",		0, 0, 0, IMKPREFIXLEN		},
	{ "range",		0, 1, 0, IMKRANGE		},
	{ "snap",		0, 1, 0, IMKSNAP		},
	{ "snpaoffset",		0, 1, 0, IMKSNPAOFFSET		},
	{ "state",		0, 1, 0, IMKSTATE		},
	{ "syncif",		0, 1, 1, IMKSYNCIF		},
	{ "tentative",		1, 0, 1, IMKTENTATIVE		},
	{ "trailers",		0, 0, 1, IMKTRAILERS		},
	{ "tunnel",		0, 0, 0, IMKTUNNEL		},
	{ "up",			0, 0, 0, IMKUP			},
	{ "vhid",		0, 1, 0, IMKVHID		},
	{ "vlan",		0, 1, 0, IMKVLAN		},
	{ "vlandev",		0, 1, 1, IMKVLANDEV		},
	{ "vltime",		1, 0, 0, IMKVLTIME		}
};
#define NIFCMOD (sizeof(ifcmods) / sizeof(ifcmods[0]))
%}

%token DIMKCOPY DIMKCREATE DIMKDESTROY

%{
/* Dynamic interface modifiers (must be sorted). */
struct dynifcmod {
	char *name;	/* Keyword. */
	int val;	/* yacc value. */
} dynifcmods[] = {
	{ "copy",	DIMKCOPY	},
	{ "create",	DIMKCREATE	},
	{ "destroy",	DIMKDESTROY	}
};
#define NDYNIFCMOD (sizeof(dynifcmods) / sizeof(dynifcmods[0]))
%}

%%

cmd:		dynifmod {
		}
	|	ifmod {
		}
	|	ifpr {
		}
	|	ifpra {
		}
	|	ifprcr {
		};

ifmod:		IFACE af addr dstaddr stparams {
		}
	|	IFACE addr dstaddr stparams {
		}
	|	IFACE af addr stparams {
		}
	|	IFACE stparams {
		}
	|	IFACE addr stparams {
		};

dynifmod:	IFACE dynparams

ifpr:		"-m" IFACE
	|	IFACE {
		}

ifpra:		CIFPRAOPTS {
		}
	|	CIFPRAOPTS af {
		};

ifprcr:		"-C" {
		};

dstaddr:	addr

dynparams:	DIMKCOPY IFACE {
		}
	|	DIMKCREATE {
		}
	|	DIMKDESTROY {
		};

stparams:	
	|	stparamsr;

stparamsr:	stparam
	|	stparam stparamsr;

stparam:	IMK8022 {
		}
	|	IMK8022TR {
		}
	|	IMK8023 {
		}
	|	IMKETHERII {
		}
	|	IMKADVBASE NUMBER {
		}
	|	IMKADVSKEW NUMBER {
		}
	|	IMKALIAS {
		}
	|	IMKANYCAST {
		}
	|	IMKARP {
		}
	|	IMKBROADCAST IP4ADDR {
			
		}
	|	IMKDEBUG {
		}
	|	IMKDELETE {
		}
	|	IMKDELETETUNNEL {
		}
	|	IMKDOWN {
		}
	|	IMKEUI64 {
		}
	|	IMKTUNNEL {
		}
	|	IMKINSTANCE {
		}
	|	IMKLINK0 {
		}
	|	IMKLINK1 {
		}
	|	IMKLINK2 {
		}
	|	IMKMAXUPD {
		}
	|	IMKMEDIA {
		}
	|	IMKMEDIAOPT {
		}
	|	IMKMETRIC {
		}
	|	IMKMTU {
		}
	|	IMKNETMASK {
		}
	|	IMKNSELLENGTH {
		}
	|	IMKNWID {
		}
	|	IMKNWKEY {
		}
	|	IMKPASS {
		}
	|	IMKPERSIST {
		}
	|	IMKPHASE {
		}
	|	IMKPLTIME {
		}
	|	IMKPOWERSAVE {
		}
	|	IMKPOWERSAVESLEEP {
		}
	|	IMKPREFIXLEN {
		}
	|	IMKRANGE {
		}
	|	IMKSNAP {
		}
	|	IMKSNPAOFFSET {
		}
	|	IMKSTATE {
		}
	|	IMKSYNCIF {
		}
	|	IMKTENTATIVE {
		}
	|	IMKTRAILERS {
		}
	|	IMKTUNNEL {
		}
	|	IMKUP {
		}
	|	IMKVHID {
		}
	|	IMKVLAN {
		}
	|	IMKVLANDEV {
		}
	|	IMKVLTIME {
		};

%%

int
lookup(char *keyword)
{
	struct ifcmod *m;
	int hi, lo, mid;
	char *k;
	
	/* Ignore negation (-opt) while finding keyword. */
	k = keyword[0] == '-' ? keyword + 1 : keyword;

	lo = 0;
	hi = NIFCMOD-1;
	while (lo <= hi) {
		mid = (hi + lo) / 2;
		switch (strcmp(k, ifcmods[mid].name)) {
		case 1:
			/* Target is less than middle; lower hi. */
			hi = mid-1;
			break;
		case 0:
			m = ifcmods + mid;
			goto success;
			/* NOTREACHED */
		case -1:
			lo = mid+1;
			break;
		}
	}

	errx(1, "unknown modifier: %s", keyword);

success:
#ifndef INET6
	if (m->inet6)
		errx(1, "'%s' only available in inet6", keyword);
#endif

#ifdef INET_ONLY
	if (m->notinet)
		errx(1, "'%s' not available when only inet", keyword);
#endif
	
	if ((keyword[0] == '-') && (m->neg == 0))
		errx(1, "unknown modifier: %s", keyword);
	
	return m->val;
}
