/*
 */

%{
#include "y.tab.h"
%}

iface		[a-z]+[0-9]
number		[0-9]+
ip4addr		[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+
ip6addr		
atalkaddr	

%%

{iface}	{
		yylval.val.len = yyleng;
		if (yylval.val.buf = strdup(yytext))
			err(1, NULL);
		return IFACE;
	}

{number} {
		yylval.ulnum = strtoul(yytext, NULL, 10);
		return NUMBER;
	}

{ip4addr} {
		unsigned long v;
		char *s = yytext;
		for (;;) {
			if (v = strtoul(s, &s, 10) > 255)
				errx(1, "invalid IPv4 addr: %s", yytext);
			if (*s == '\0')
				break;
			s++;
		}
		return IP4ADDR;
	}

%%
