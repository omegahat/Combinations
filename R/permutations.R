permutations =
function(n, fun = NULL)
{
  if(missing(fun)) {
    ans = matrix(as.integer(0), n, gamma(n+1))
    .C("R_Perm", as.integer(n), ans, DUP = FALSE)

    t(ans)

  } else {
    .Call("R_PermApply", as.integer(n), as.function(fun), NULL)
    fun
  }
}

