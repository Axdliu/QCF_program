
# two sample t-tests

# Two-sample t-tests are used to test hypotheses about the difference between
# two population means. The independent-samples t-test is used when we sample 
# independently from the two populations.

prices = read.csv("Stock_Bond.csv")
prices_Merck = prices[ , 11]
return_Merck = diff(log(prices_Merck))
prices_Pfizer = prices[ , 13]
return_Pfizer = diff(log(prices_Pfizer))
cor(return_Merck,return_Pfizer, method = c("pearson"))
t.test(return_Merck, return_Pfizer, paired = TRUE)
differences = return_Merck - return_Pfizer
n = length(differences)
confi_intval = mean(differences) + c(-1,1) * qt(0.025, n - 1, lower.tail = FALSE) * sd(differences) / sqrt(n)