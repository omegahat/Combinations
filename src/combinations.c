/* Algorithm by Donald Knuth. */
/* C implementation by Glenn C. Rhoads 
   Adapted for R by Duncan Temple Lang.
*/

#include <stdio.h>
#include <stdlib.h>

#define ODD(x)  (x&1)

#define R
#include <R_ext/Memory.h>


#define OUTPUT(ctr, i, val)  { if(val != 0) { ans[ *k * ]}
#define END_ITEM(ctr) ctr++

void R_combinations(int *inputs, int *ans)
{
    int i, n, k, N, r, *a, *w;

    int ctr = 0;
    n = inputs[0];
    k = inputs[1];
    N = inputs[2];

    a = (int *) S_alloc( n, sizeof( int ) );
    w = (int *) S_alloc( (n+1), sizeof( int ) );
    r = n-k;

    for (i=0; i < r; i++) { a[i] = 0; w[i] = 1; }
    for (i=r; i < n; i++) { a[i] = 1; w[i] = 1; }

    w[n] = 1;


    for (;;)
    {
        int col = 0;
	for (i = n - 1; i >= 0; i--) 
#ifdef R 
	{
	    if(a[i] != 0) {
                ans[ col + ctr] = i + 1;
                col += N;
	    }
	}
	ctr++;
#else
	printf( "%3d", a[i] );
	printf( "\n");
#endif

	for (i=r; w[i] == 0; i++) w[i] = 1;
	if (i == n) return;
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

    return;
}

