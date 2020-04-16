## after https://tgmstat.wordpress.com/2013/11/21/introduction-to-principal-component-analysis-pca/
# and
## https://tgmstat.wordpress.com/2013/11/28/computing-and-visualizing-pca-in-r/
# and
## https://www.analyticsvidhya.com/blog/2016/03/pca-practical-guide-principal-component-analysis-python/

# approach used to decide the most important bioclimatic variables associating with the geographical distribution of LHY haplotypes for Arabidopsis 1001 genomes ecotypes
# used to prepare Figure 4b and Suppl. Figures S6b, S7 of James et al. 2018 Plant Cell & Environ 41(7): 1524-1538)

# final plot is a ggbiplot in ggplot2. Manually grab ggbiplot
# see https://github.com/vqv/ggbiplot/issues/53

source("/Users/Allan/PCA_Bioclim_Arabidopsis/ggbiplot.r")

# had used these previously but now get errors:
# library(devtools)
# install_github("ggbiplot","vqv")
# library(ggbiplot)

# load csv file of Arabidopsis accessions with haplotype decsriptions and bioclimatic continuous variables

# this dataframe has ecotype information (including latitude and longitude), LHY haplotype assignation,
# and numerical values for a series of 19 WorldClim bioclimatic variables for 932 ecotypes at their geographic locations.
# this larger dataset for Suppl. Figures S6b and S7a
# WRLDacc<-read.csv('LHY SNP WRLD_ran50 dataset',header=TRUE)

# or a dataset for a random selection of 50 each of the 4 LHY haplotypes (200 ecotypes)
# this smaller dataset for Figure 4b and Suppl. Figure S7b
WRLD_50_ran<-read.csv('LHY SNP WRLD_ran50 dataset.csv',header=TRUE)

# select the continuous variables: Bioclim BIO1-BIO19, and altitude
# PCA_WRLDacc<-WRLDacc[,27:46]
PCA_WRLD_50_ran<-WRLD_50_ran[,27:46]

# define column with different haplotypes
# PCA_WRLDacc.genotype_comp<-WRLDacc[,26]
PCA_WRLD_50_ran.genotype_comp<-WRLD_50_ran[,26]

# Use prcomp() to perform PCA
# parameter scale. = T normalises the variables to have SD = 1
# prin_compWRLDacc<-prcomp(PCA_WRLDacc,scale.=TRUE)
prin_compWRLD_50_ran<-prcomp(PCA_WRLD_50_ran,scale.=TRUE)

# summary(prin_compWRLD_50_ran)
# summary(prin_compWRLDacc)
# names(prin_compWRLD_50_ran) # 5 measures "sdev", "rotation","center","scale","x"
# names(prin_compWRLDacc)

# outputs the mean of variables
# prin_compWRLD_50_ran$center
# prin_compWRLDacc$center

# outputs the standard deviation of variables
# prin_compWRLD_50_ran$scale
# prin_compWRLDacc$scale

# rotation measure provides the principal component loading
# prin_compWRLD_50_ran$rotation
# prin_compWRLDacc$rotation

# ?? second number will tell the number of principal components ??
# dim(prin_compWRLD_50_ran$x)
# dim(prin_compWRLDacc$x)

# simple biplot of the principal components
# the parameter scale = 0 ensures that arrows are scaled to represent the loadings
# biplot(prin_compWRLD_50_ran,scale=0)
# biplot(prin_compWRLDacc,scale=0)

# compute standard deviation of each principal component
# st_devWRLD_50_ran<-prin_compWRLD_50_ran$sdev
# st_devWRLDacc<-prin_compWRLDacc$sdev

# compute variance
# pr_varWRLD_50_ran<-st_devWRLD_50_ran^2
# pr_varWRLDacc<-st_devWRLDacc^2

# check variance of first 10 components
# pr_varWRLD_50_ran[1:10]
# pr_varWRLDacc[1:10]

# compute the proportion of variance explained by each component, divide the variance by sum of total variance
# proportion of variance explained
# prop_varexWRLD_50_ran<-pr_varWRLD_50_ran/sum(pr_varWRLD_50_ran)
# prop_varexWRLDacc<-pr_varWRLDacc/sum(pr_varWRLDacc)

# see variance of first 20 components
# prop_varexWRLD_50_ran[1:20]
# prop_varexWRLDacc[1:20]

# and plot variances to see contribution of components to overall variance
# plot(prop_varexWRLD_50_ran,xlab='Principal Component',ylab='Proportion of Var. Explained',type='b')
# plot(prop_varexWRLDacc,xlab='Principal Component',ylab='Proportion of Var. Explained',type='b')

# and/or
# plot a cumulative variance plot
# plot(cumsum(prop_varexWRLD_50_ran),xlab='Principal Component',ylab='Cumulative Propn. of Var. Explained',type='b')
# plot(cumsum(prop_varexWRLDacc),xlab='Principal Component',ylab='Cumulative Propn. of Var. Explained',type='b')

g<-ggbiplot(prin_compWRLD_50_ran,obs.scale=1,var.scale=1,groups= PCA_WRLD_50_ran.genotype_comp,ellipse=TRUE,varname.size=2.5,alpha=0.5)
# g<-ggbiplot(prin_compWRLDacc,obs.scale=1,var.scale=1,groups= PCA_WRLDacc.genotype_comp,ellipse=TRUE,varname.size=2.5,alpha=0.5)

# to plot other components
# g<-ggbiplot(prin_compWRLD_50_ran,choices=2:3,obs.scale=1,var.scale=1,groups= PCA_WRLD_50_ran.genotype_comp,ellipse=TRUE,varname.size=2.5,alpha=0.5)

gs<-g+scale_color_manual(values=c("dodgerblue1","chartreuse4","firebrick1","darkgoldenrod2"),name='')

gst<-gs+theme(legend.background = element_rect(fill="gray 90"),legend.title=element_blank())+theme(legend.justification = c(1,0),legend.position = c(1,0))+theme(legend.background = element_rect(colour="black",size=0.25))

ggsave('PCA_ggbiplot.png')
