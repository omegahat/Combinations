#
# In this example, we start with a simple population
# of 50 values

pop = rpois(50, 5)

# We want to find out how many 2s there are in each of the possible samples of size 10
# So we will build a frequency table with the counts for the different possible number
# of 2s in the sample, i.e. 0, 1, 2, 3, 4, 5, ..., 50

ans = integer(51) 

fun = function(idx) {
         val = sum(pop[idx] == 2)
         ans[ val + 1] <<- ans[val + 1] + 1
       }

combinations(50, 48, fun)

# The critical thing here is that we are collapsing down to a smaller
# number of values in the answer so that they will fit into a regular
# vector in R.




generator =
   function(val, popn) {
    ans = integer(length(popn) + 1) 
    function(idx) {
         val = sum(popn[idx] == val)
         ans[ val + 1] <<- ans[val + 1] + 1
       }
  }

f = generator()
combinations(50, 48, f)
environment(f)$ans


# or we can use the CombinationGeneratorCallback class to simplify
# access to the callback's environment and getting the results.
f = new("CombinationGeneratorCallback", generator(2, pop))
combinations(50, 48, f)
f$ans

