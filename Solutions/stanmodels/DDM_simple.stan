
// Data block for the input sequence and binary responses
data {

  // Define the number of datapoints this is defined by an integer
  int N;
  
  // Define a vector that is as long as the number of datapoints of real numbers (the response times)  
  vector[N] RT;
  
  // Define an array that is as long as the number of datapoints of integers (the binary responses)

  array[N] int binary_resp;

}

transformed data{
  real minRT = min(RT);
}

// This is the parameters block. Here we define the free parameters.
parameters {
  // Define the boundary
  real<lower=0> boundary;
  
  // Define the bias
  real<lower=0, upper = 1> bias;
  
  // Define the non-decision-time
  real<lower=0, upper = minRT> ndt;
  
  // Define the Drift-rate
  real drift;
  
  
}

// This is the model block here we define how we believe the model is and the priors of the parameters.

model {
  // priors
  
  // boundary prior
  boundary ~ normal(2,5);
  
  // bias prior
  bias ~ normal(0.5,1);
  
  // non-decision-time prior
  ndt ~ normal(0,0.4);
  
  // drift-rate prior
  drift ~ normal(0,5);

  // The model and the likelihood:

  for(t in 1:N){
    if(binary_resp[t] == 1){
      RT[t] ~ wiener(boundary,ndt,bias,drift);
    }else if(binary_resp[t] == 0){
      RT[t] ~ wiener(boundary,ndt,1-bias,-drift);
    }
  }
  
}
