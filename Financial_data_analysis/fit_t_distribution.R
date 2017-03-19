data(Capm,package="Ecdat")
write.csv(Capm$rf, file = "D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\ex5_3.csv",
          row.names = FALSE)
x = diff(Capm$rf)
library(MASS)
fitdistr(x,"t") # The numbers in parentheses are the standard errors.
library(fGarch)
n = length(x)
start = c(mean(x),sd(x),5)
loglik_t = function(beta) sum( - dt((x-beta[1])/beta[2],
                                    beta[3],log=TRUE) + log(beta[2]) )    
fit_t = optim(start,loglik_t,hessian=T,method="L-BFGS-B",
              lower = c(-1,.001,1))                                 
AIC_t = 2*fit_t$value+2*3
BIC_t = 2*fit_t$value+log(n)*3
sd_t = sqrt(diag(solve(fit_t$hessian)))
options(digits=3)
fit_t$par
sd_t
options(digits=5)
AIC_t
BIC_t
loglik_std = function(beta) sum( - dstd(x,mean=beta[1],
                                        sd=beta[2],nu=beta[3],log=TRUE) )
fit_std = optim(start,loglik_std,hessian=T,method="L-BFGS-B",
                lower = c(-.1,.01,2.1))                                   
AIC_std = 2*fit_std$value+2*3
BIC_std = 2*fit_std$value+log(n)*3
sd_std = sqrt(diag(solve(fit_std$hessian)))
fit_std$par
sd_std
AIC_std
BIC_std
0.04585 * sqrt(3.332/(3.332-2))