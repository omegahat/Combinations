#include <stdio.h>
#include <stdlib.h>

#define R
#include <Rdefines.h>

#define ODD(x)  (x&1)

int combinationEvent(int n, int k, unsigned long N, unsigned long ctr, int *indices, SEXP f, SEXP userData);
SEXP createUserInfo(SEXP f, int n);

SEXP
R_combinationEvent(SEXP inputs, SEXP f, SEXP userData)
{
    int i, n, k,  r, *a, *w;
    unsigned long N;

    SEXP userInfo;

    int ctr = 0;
    n = INTEGER(inputs)[0];
    k = INTEGER(inputs)[1];
    N = INTEGER(inputs)[2];

    if(n < 1)
	return(R_NilValue);

    a = (int *) S_alloc( n, sizeof( int ) );
    w = (int *) S_alloc( (n+1), sizeof( int ) );
    r = n-k;

    for (i=0; i < r; i++) { a[i] = 0; w[i] = 1; }
    for (i=r; i < n; i++) { a[i] = 1; w[i] = 1; }

    w[n] = 1;


    userInfo = createUserInfo(f, n);
    R_PreserveObject(userInfo);

    for (;;)
    {
	if(!combinationEvent(n, k, N, ctr, a, f, userInfo)) {
	    R_ReleaseObject(userInfo);
	    return(R_NilValue);
	}
	ctr++;

	for (i=r; w[i] == 0; i++) w[i] = 1;
	if (i == n) {
	    R_ReleaseObject(userInfo);
	    return(R_NilValue);
	}
	w[i] = 0;

	if (a[i] != 0)
	{
	    a[i] = 0;
	    if (ODD(i) || a[i-2] != 0)
            {
		a[i-1] = 1;
		if (r == i-1) r = i;
		else if (r == i && i > 1) r = i-1;
            }
	    else
            {
		a[i-2] = 1;
		if (r == i-2) r = i-1;
		else if (r == i)
		{
		    if (i > 3) r = i-2;
		    else r = 1;
		}
            }
	}
	else
	{
	    a[i] = 1;
	    if (ODD(i) && a[i-1] == 0)
            {
		a[i-2] = 0;
		if (r == i-2) r = i;
		else if (r == i-1) r = i-2;
            }
	    else
            {
		a[i-1] = 0;
		if (r == i-1) r = i;
		else if (r == i && i > 1) r = i-1;
            }
	}
    }

    R_ReleaseObject(userInfo);
    return(R_NilValue);
}

SEXP
createUserInfo(SEXP f, int n)
{
    SEXP e, vals;

    PROTECT(e = allocVector(LANGSXP, 2));
    SETCAR(e, f);
    PROTECT(vals = NEW_LOGICAL(n));
    SETCAR(CDR(e), vals);

    UNPROTECT(2);

    return(e);
}

int
combinationEvent(int n, int k, unsigned long N, unsigned long ctr, int *indices, SEXP f, SEXP e)
{
    memcpy(INTEGER(CAR(CDR(e))), indices, sizeof(int) * n);
    Rf_eval(e, R_GlobalEnv);

    return(1);
}
