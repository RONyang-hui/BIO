#limma 包可以处理多组实验数据的整合分析，例如在不同实验条件下的基因表达差异分析，同时考虑到实验批次效应等因素
if (!requireNamespace("BiocManager", quietly = TRUE))
             install.packages("BiocManager")
BiocManager::install("limma")


       library(limma)      #引用包
      geneCol=2           #基因名称列号
expCol=6            #表达数据列号
setwd("D:\\BaiduNetdiskDownload\\01bioinformic\\02GEOhighth\\05sampleData")    #设置工作目录

#读取目录下的文件
files=dir()
files=grep(".txt$",files,value=T)

geneList=list()
expList=list()
#循环读取文件，对输入文件整理
for(i in files){
	#如果文件名为expMatrix.txt，则跳过
	if(i=="expMatrix.txt"){
		next
	}
	#读取文件,并对输入文件整理
	sampleName=i
	sampleName=gsub("\\.txt","",sampleName)
	rt=read.table(i,sep="\t",header=T,check.names=F)
	rt=rt[,c(geneCol,expCol,expCol)]
	rt=as.matrix(rt)
	rownames(rt)=rt[,1]
	exp=rt[,2:ncol(rt)]
	rowNames=rownames(exp)
	colNames=colnames(exp)
	dimnames=list(rowNames,colNames)
	data=matrix(as.numeric(as.matrix(exp)),nrow=nrow(exp),dimnames=dimnames)
	data=avereps(data)
	colnames(data)[1]=sampleName
	geneList[[sampleName]]=row.names(data)
	expList[[sampleName]]=data
}

#数据合并
#计算出interGenes，即intersect函数的结果
interGenes=Reduce(intersect,geneList)
#创建一个空的data.frame
outTab=data.frame()
#计数器
count=0
#遍历expList中的每一个元素
for(j in names(expList)){
	#计数器自增
	count=count+1
	#获取矩阵
	matrix=expList[[j]]
	#如果是第一次循环，则将矩阵赋值给outTab
	if(count==1){
		outTab=matrix[interGenes,]
	#否则，将矩阵和outTab进行拼接
	}else{
		outTab=cbind(outTab,matrix[interGenes,])
	}
}

#输出结果表格
#从outTab中取出第一列，并将其赋值给out
outTab=outTab[,seq(1,ncol(outTab),2)]
out=cbind(ID=row.names(outTab),outTab)
#将out写入文件，文件名为expMatrix.txt，分隔符为\t，不引用，行名不显示
write.table(out,file="expMatrix.txt",sep="\t",quote=F,row.names=F)

