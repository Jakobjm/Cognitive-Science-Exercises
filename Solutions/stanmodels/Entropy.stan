
// Data block for the input sequence and binary responses
data {

  // Define the number of datapoints this is defined by an integer
  
  int N;
  
  // Define a vector that is as long as the number of datapoints of real numbers (the stimulus sequence)  
  vector[N] x;

  // Define a vector that is as long as the number of datapoints of real numbers (the response times)  
  vector[N] RT;


  // Define an array that is as long as the number of datapoints of integers (the binary responses)
  array[N] int binary_resp;



}

// This is the parameters block. Here we define the free parameters.
parameters {
  // Define the threshold
  real alpha;
  // Define the slope
  real<lower=0> beta;
  // Define the lapse rate
  real<lower=0, upper = 0.5> lambda;
  
  // Define the intercept of RT
  real rt_int;
  // Define the slope of RT
  real rt_beta;
  // Define the residual variance (normal distribution sd)
  real<lower=0> rt_sd;
  
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
  
  // threshold prior
  rt_int ~ normal(0,10);
  // slope prior
  rt_beta ~ normal(0,10);  
  // lapse rate prior
  rt_sd ~ normal(3,5);
  
  
  

  // Remember constraints on the parameters, either one relies on the definition of the parameters or use prior-distributions that only allow    // the right domain!
  
  // the model and the likelihood:
    
  vector[N] p = lambda + (1-2*lambda) * Phi((x-alpha)/sqrt(2) * beta);
    
  // bernoulli() is a function in stan as well as erf() and Phi().
  binary_resp ~ bernoulli(p);
 
  RT ~ normal(rt_int + rt_beta * (-p .* log(p) - (1-p)  .* log(1-p)), rt_sd);
    
}
