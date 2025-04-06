
// Data block for the input sequence and binary responses
data {

  // Define the number of datapoints this is defined by an integer
  
  int N;
  
  // Define a vector that is as long as the number of datapoints of real numbers (the stimulus sequence)  

  array[N] int binary_resp;

  // Define an array that is as long as the number of datapoints of integers (the binary responses)

  vector[N] x;
    
}

// This is the parameters block. Here we define the free parameters.
parameters {
  // Define the threshold
  real alpha;
  // Define the slope
  real<lower=0> beta;
  // Define the lapse rate
  real<lower=0, upper = 0.5> lambda;
  // remember constraints on the parameters!
  
}

// This is the model block here we define how we believe the model is and the priors of the parameters.

model {
  // priors
  
  // threshold prior
  alpha ~ normal(0,10);
  // slope prior
  beta ~ normal(0,10);  
  // lapse rate prior
  lambda ~ normal(0,0.1);

  // Remember constraints on the parameters, either one relies on the definition of the parameters or use prior-distributions that only allow    // the right domain!
  
  // the model and the likelihood:
    
  // bernoulli() is a function in stan as well as erf() and Phi().
  binary_resp ~ bernoulli(lambda + (1-2*lambda) * Phi((x-alpha)/sqrt(2) * beta));
    
}
