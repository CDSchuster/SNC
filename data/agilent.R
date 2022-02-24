library("limma")
library("ggplot2")
library("ggrepel")
library("ggfortify")
library("heatmap3")
library("a4")
library("biomaRt")
library("dplyr")
#READING THE DATA
targets=read.csv2("targets.csv", sep=",")
raw_data=read.maimages(targets[,1], source="agilent")

#QUALITY CONTROL
#Density plot
plotDensities(raw_data)

#MAplots
plotMA3by2(raw_data) #All in 1
#1 by 1
MA=MA.RG(raw_data)
plotMA(MA, array=7)
lines(lowess(MA$M~MA$A, delta = 1), col="red")

#Normalization
bg_data=backgroundCorrect(raw_data, method="normexp", offset=20)
norm_data=normalizeWithinArrays(bg_data, method = 'loess')
nba_norm=normalizeBetweenArrays(norm_data, method="Aquantile")

#DENSITIES AND MA-PLOTS
plotMA3by2(nba_norm)
plotDensities(nba_norm)
plotMA(nba_norm, array=1)
lines(lowess(MA$M~MA$A, delta = 1), col="red")

nba_norm.avg <- avereps(
  nba_norm,
  ID = nba_norm$genes$ProbeName)

norm_data.avg <- avereps(
  norm_data,
  ID = norm_data$genes$ProbeName)


#PCA
transposed_matrix=t(nba_norm.avg$M)
vec_matrix=cbind(transposed_matrix, targets["Pheno"])
pca=prcomp(transposed_matrix)
ggplot2::autoplot(pca, data=vec_matrix, label=FALSE, colour="Pheno", width=20, height=20, dpi=1000)+geom_text_repel(aes(label = rownames(transposed_matrix)))

#Linear model and contrasts

#Tumores vs. lineas celulares
design <- model.matrix(~ 0 + factor(targets$Pheno, levels = c("A", "B")))
colnames(design) <- c("A", "B")

project.fitmodel <- lmFit(nba_norm.avg, design)
project.fitmodel.eBayes <- eBayes(project.fitmodel)

#DE
CaseControl <- makeContrasts(CaseControl = c("A-B"), levels = design)
CaseControl.fitmodel <- contrasts.fit(project.fitmodel.eBayes, CaseControl)
CaseControl.fitmodel.eBayes <- eBayes(CaseControl.fitmodel)
top_table=limma::topTable(CaseControl.fitmodel.eBayes, adjust = 'BH', coef = 1, number = 99999, lfc=1.5)

#Volcano plot

volcanoplot(CaseControl.fitmodel.eBayes, 1, highlight = 0)

#Heatmap
heatmap_plot <- function(tops, norm_matrix){
  #Receives a DE matrix and an expression matrix and plots a heatmap
  print("Plotting heatmap")
  top_matrix=subset(norm_matrix, rownames(norm_matrix) %in% rownames(tops))
  top_matrix=top_matrix[, order(colnames(top_matrix)), drop=F]
  png("heatmap.png")
  par(mar=c(10,10,10,10))
  heatmap3(top_matrix,
           Colv=NA,
           showColDendro=F,
           showRowDendro=T,
           balanceColor = T,
           xlab="Samples",
           ylab="Genes",
           labRow=FALSE,
           labCol = colnames(top_matrix),
           cex.main = 1,
           cexRow = 5,
           cexCol = 1,
           margins=c(7,2))
  dev.off()
}

heatmap_plot(top_table, nba_norm.avg$M)

M_matrix=nba_norm.avg$M
genes=nba_norm.avg$genes
rownames(M_matrix)=genes$ProbeName
M_matrix_cells=M_matrix[,6:8]
colnames(M_matrix_cells)=c("Serum free", "IGF1 24 h", "IGF1 + OSI906 24 h")
write.csv2(M_matrix, sep = ",", file="expression_matrix.csv")
write.csv2(M_matrix_cells, sep = ",", file="probes.csv")

ensembl = useMart("ensembl", dataset = "hsapiens_gene_ensembl")

## Should return all the agilent probe ids in biomaRt
agilent = getBM(attributes=c('agilent_sureprint_g3_ge_8x60k', "refseq_mrna", "hgnc_symbol", "ensembl_gene_id", "external_gene_name", "entrezgene_accession"), values="*", mart= ensembl)
M_matrix2=M_matrix
agilent2=agilent[agilent$agilent_sureprint_g3_ge_8x60k!="",]
agilent3=agilent2[agilent2$refseq_mrna!="",]

a=c(rownames(M_matrix) %in% agilent2$agilent_sureprint_g3_ge_8x60k)

rownames(agilent3)=agilent3$agilent_sureprint_g3_ge_8x60k

#################################################################

names=read.csv2("GPL21185-21174.txt", sep="\t")

rownames(M_matrix)=names$REFSEQ
refseq_matrix=M_matrix[rownames(M_matrix)!="",]

rownames(M_matrix)=names$GB_ACC
gb_matrix=M_matrix[rownames(M_matrix)!="",]

rownames(M_matrix)=names$GENE_SYMBOL
symbol_matrix=M_matrix[rownames(M_matrix)!="",]

rownames(M_matrix)=names$ENSEMBL_ID
ensembl_matrix=M_matrix[rownames(M_matrix)!="",]

rownames(M_matrix)=names$GENE_NAME
genename_matrix=M_matrix[rownames(M_matrix)!="",]

write.csv2(refseq_matrix, sep = ",", file="refseq_matrix.csv")
write.csv2(gb_matrix, sep = ",", file="gb_matrix.csv")
write.csv2(symbol_matrix, sep = ",", file="symbol_matrix.csv")
write.csv2(ensembl_matrix, sep = ",", file="ensembl_matrix.csv")
write.csv2(genename_matrix, sep = ",", file="genename_matrix.csv")
