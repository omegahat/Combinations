setClass("CallbackFunction", "function")

setMethod("$", "CallbackFunction",
            function(x, name) {
              get(name, envir = environment(x)) 
            })


#if(!isGeneric("names"))
#  setGeneric("names", function(x) standardGeneric("names"))

setMethod("names", "CallbackFunction", 
            function(x) 
              objects(envir = environment(x)))

setClass("CombinationGeneratorCallback",
         "CallbackFunction",
           validity =
             function(object) {
               a = formals(object)
               tmp = sapply(a[-1], function(x) is.symbol(x))
               if(any(tmp)) {
                  warning("CombinationGeneratorCallback expects to have a single argument. ", 
                           paste((names(a)[-1])[tmp], collapse = ", ", ), 
                           " has no default. Relying on lazy evaluation.")
               }
               TRUE
             })
