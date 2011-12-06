combinations =
function(n, r, fun = NULL)
{
  total = choose(n, r)

  if(!missing(fun)) {

    .Call("R_combinationEvent", as.integer(c(n, r, total)), as.function(fun), NULL)

  } else {

    ans = matrix(as.integer(-1), total, r)
    .C("R_combinations", as.integer(c(n, r, total)), ans = ans, DUP = FALSE)$ans

  }
}

