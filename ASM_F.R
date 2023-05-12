library(glmnet)
library(ggplot2)

# Load the data
data <- read.csv("chowdary.csv", header=TRUE)

# Split the data into training and testing sets
set.seed(123)
train <- sample(nrow(data), nrow(data)*0.7)
train_data <- data[train,]
test_data <- data[-train,]

# Define the response variable and convert it into binary classes
response <- ifelse(train_data$tumour == "C", 1, -1)

# Define the predictor variables
predictors <- as.matrix(train_data[,3:ncol(train_data)])

# Fit the Lasso model
lasso.fit <- cv.glmnet(predictors, response, family="binomial", type.measure="class", alpha=1)

# Extract the lambda and cross-validation error values
lambda <- lasso.fit$lambda
cv_error <- lasso.fit$cvm

# identify the best value of the regularization parameter
best.lambda <- lasso.fit$lambda.min

# Plot the cross-validation error as a function of the regularization parameter
ggplot(data.frame(lambda=lambda, cv_error=cv_error), aes(lambda, cv_error)) +
  geom_line() +
  geom_vline(xintercept = best.lambda, linetype="dashed", color="red") +
  xlab("Lambda") +
  ylab("Cross-validation error") +
  ggtitle(paste("Lasso Model Cross-validation Error (Best Lambda =", round(best.lambda, 4), ")"))+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major = element_blank(), panel.grid.minor = element_blank())


# fit the Lasso model using the best regularization parameter
lasso.fit.best <- glmnet(predictors, response, family="binomial", alpha=1, lambda=best.lambda)

# get the coefficient estimates
coef.estimates <- coef(lasso.fit.best)[-1,]

# identify the top 10 genes that most influence cancer type designation
top10_genes <- names(coef.estimates[order(abs(coef.estimates), decreasing=TRUE)][1:10])

print(top10_genes)

# interpret the nature of the relationship between these genes and cancer type designation
for (gene in top10_genes) {
  gene_coef <- coef.estimates[gene]
  if (gene_coef > 0) {
    cat(paste0("The gene ", gene, " is positively associated with cancer type designation.\n"))
  } else if (gene_coef < 0) {
    cat(paste0("The gene ", gene, " is negatively associated with cancer type designation.\n"))
  } else {
    cat(paste0("The gene ", gene, " is not associated with cancer type designation.\n"))
  }
}

# extract the gene expression data for the top 10 genes from the test dataset
gene_expr <- as.matrix(test_data[, top10_genes])

# create a heatmap of the gene expression levels
heatmap(gene_expr, Colv = NA, Rowv = NA, col = colorRampPalette(c("blue", "white", "red"))(256), 
        margins = c(5, 10), xlab = "", ylab = "",
        main = "Heatmap of Top 10 Genes", mar = c(10, 7, 3, 2),
        cexCol = 0.8)

# add a color legend to the heatmap
legend("topright", legend = c("Low Expression", "Medium Expression", "High Expression"), 
       fill = colorRampPalette(c("blue", "white", "red"))(3))

# predict on test set using lasso model
test_predict <- predict(lasso.fit.best, newx=as.matrix(test_data[,3:ncol(test_data)]), type="response")

# plot ROC curve
library(pROC)
library(ggplot2)

roc_curve <- roc(test_data$tumour, as.numeric(test_predict))
plot(roc_curve, main="ROC Curve", col="blue", lwd=2, print.auc=TRUE, xlab = "False Positive Rate", ylab = "True Positive Rate")

# get the indices of the rows for cancer type B and C in the test data
test_data_b <- test_data[test_data$tumour == "B",]
test_data_c <- test_data[test_data$tumour == "C",]

# create a data frame with the gene expression levels for the top 10 genes for cancer type B and C
gene_expression <- data.frame(
  gene = rep(top10_genes, 2),
  expression = c(
    unlist(test_data_b[, top10_genes]),
    unlist(test_data_c[, top10_genes])
  ),
  tumour_type = rep(c("B", "C"), each = 10)
)

# plot a box plot to show the distribution of gene expression levels for the top 10 genes in cancer type B and C
library(ggplot2)
ggplot(gene_expression, aes(x = gene, y = expression, fill = tumour_type)) +
  geom_boxplot(outlier.shape = NA) +
  ylim(0, 750) +  # set the y-axis limits to 0 and 1000
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        plot.title = element_text(size = 10)) +
  labs(x = "Genes", y = "Gene Expression Levels", fill = "Tumor Type") +
  ggtitle("Gene Expression Levels for Top 10 Genes in Cancer Types B and C")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  
ggplot(gene_expression, aes(x = expression, y = gene, fill = tumour_type)) +
  geom_boxplot(outlier.shape = NA) +
  xlim(0, 750) +  # set the y-axis limits to 0 and 1000
  scale_fill_manual(values = c("B" = "orange", "C" = "darkturquoise"))+
  theme(plot.title = element_text(size = 10)) +
  labs(y = "Genes", x = "Gene Expression Levels", fill = "Tumor Type") +
  ggtitle("Gene Expression Levels for Top 10 Genes in Cancer Types B and C")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()+
  coord_flip()+
  theme_bw())




