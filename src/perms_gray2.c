/* Original version of this program by Frank Ruskey (1995) can be
   found at http://sue.uvic.ca/~cos/inf/perm/PermInfo.html -- a subpage of
   "The Combinatorial Object Server"
*/
#include <stdio.h>
#include <stdlib.h>

#define R
#include <Rdefines.h>


typedef struct _CallbackData CallbackData;

typedef void (*CallbackFun)(int *p, int N, CallbackData *data);

struct _CallbackData {
    int ctr;
    SEXP ans;
    CallbackFun fun;
    void *extra;
};

void simpleMatrixCallback(int *p, int N, CallbackData *data);
void applyFunctionCallback(int *p, int N, CallbackData *data);

void doPerm(int n, CallbackData *data);
void Perm(int n, int N, CallbackData *data, int *dir, int *p, int *pi);




void
R_Perm(int *num, int *els)
{
    CallbackData data = {0, NULL, &simpleMatrixCallback, NULL};
    data.extra = (void *) els;
    doPerm(*num, &data);
}

void 
doPerm(int n, CallbackData *data)
{
    int  *p, *pi;       /* The permutation and its inverse  */
    int  *dir;          /* The directions of each element   */
    int N;              /* returns permutations from 1 to N */
    int i;

    N = n;
    p   = (int *) S_alloc( (n+1), sizeof( int ) );
    pi  = (int *) S_alloc( (n+1), sizeof( int ) );
    dir = (int *) S_alloc( (n+1), sizeof( int ) );

    for (i=1; i <= n; ++i)
    {
      dir[i] = -1;
      p[i] = pi[i] = i;
    }

    Perm( 1, N, data, dir, p, pi);    
}




void
simpleMatrixCallback(int *p, int N, CallbackData *data)
{
    int i, *ans;

    ans = (int *) data->extra;
    ans += data->ctr * N;
    for (i=1; i <= N; ++i)
	ans[i-1] = p[i];
    (data->ctr)++;
}


void Perm(int n, int N, CallbackData *data,
             int *dir, int *p, int *pi)
{ 
   if (n > N)
       data->fun(p, N, data);
   else
   {
       int i, z, j, jd;       /* temporaries for swapping values  */
       Perm(n + 1, N, data, dir, p, pi);
       for (i=1; i <= n-1; i++)
       {
         j = pi[n];
         jd = j + dir[n];
         z = p[jd];
         p[j] = z;
         p[jd] = n;
         pi[z] = j;
         pi[n] = jd;
         Perm( n+1, N, data, dir, p, pi); 
       }
       dir[n] = -dir[n];
   }
}


SEXP
R_PermApply(SEXP n, SEXP fun, SEXP userData)
{
    CallbackData data = {0, NULL, &applyFunctionCallback, NULL};
    SEXP e, permi;
    PROTECT(e = allocVector(LANGSXP, 2));
    SETCAR(e, fun);
    SETCAR(CDR(e), permi = allocVector(INTSXP, INTEGER(n)[0]));
    data.ans = e;
    data.extra = (void *) INTEGER(permi);

    doPerm(INTEGER(n)[0],  &data);

    UNPROTECT(1);

    return(R_NilValue);
}


void 
applyFunctionCallback(int *p, int N, CallbackData *data)
{
    int i, *permi;

    permi = (int *) data->extra;
    for(i = 0; i < N; i++) {
	permi[i] = p[i+1];
    }
    Rf_eval(data->ans, R_GlobalEnv);
}


