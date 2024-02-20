# 生物信息培训
## 一、公共数据挖掘热点介绍：
1. 生物标志分子（单基因、多基因）
2. 可变剪切
3. 肿瘤免疫
4. 多组学
5. 选择性多聚腺苷酸化（APA）
6. 泛癌分析
7. 铁死亡
   - 转录组数据下载
   - merge.pl文件合并
           - 打开命令提示符（注意转换盘符）
         - perl merge.pl+metadat.json(粘贴自GSE下载矩阵文件)=normal count+tumor count  =sympel.txt
8. 细胞焦亡
9. 缺氧
10. 自噬
11. 网络药理学及分子对接
12. 代谢
13. 单细胞测序
14. m6A
15. 环状RNA
16. 突变
17. WGCNA 分析
18. ceRNA 网络
19. RBP(RNA 结合蛋白)
20. DNA 甲基化
21. 人工智能研究在病理切片识别上的应用
22. 人工智能多组学数据整合分析
## 二、常用生物医学数据库实践操作：
1. 常用数据库介绍
   - 综合数据库
       - TCGA：https://portal.gdc.cancer.gov/ 肿瘤数据库(购物车)
          - 临床数据
          - microRNA
          - perl merge.pl=sympol.txt(相当于matrix)
          -07.biotype:分成mRNA+lincRNA
      - GENEcard 
      - 铁死亡相关基因（R包）
      - 铁死亡lincRNA的表达（R包）
      - 差异分析（R包）
     - EGA
     - SRA
     - dbGAP
     - ICGC
     - CCLE
     - UCSC
     - cBioPortal
   - 转录谱数据库
     - GEO
     - Oncomine
     - ArrayExpress
     - miRCaner
   - 突变数据库
     - COSMIC
     - OMIM
     - ClinVar
     - SNP
   - 表观数据库
     - ENCODE
   - 注释数据库
     - DAVID
     - STRING
     - KEGG
2. 可以直接生成发表级图表的数据库
   - 差异分析
     - ONCOMINE
     - TIMER
     - GEPIA
     - HPA
   - 临床意义
     - KM plotter
     - prognoscan
     - TISIDB
   - 机制研究
     - 基因组学：cBio-portal
     - 甲基化：UALCAN
     - 互作分析：STRING
     - 功能分析：DAVID
## 三、R语言
1. R 语言简介
2. R 语言安装及配置
3. R 语言数据结构
4. R 语言数据处理
5. R 语言绘图
## 四、生物信息SCI实践操作：
1. 数据下载
   - GDC Data Transfer Tool 的使用
   - edgeR 包使用
2. 差异基因筛选
   - limma 包的使用
     - 装包
     - 改参数
     - 看目录
   - GEO2R 的使用
     - 下载数据
     - 整理数据：1.p值选项；2.logFC范围；3.不等于空，删除重复值
   - venn图绘制
     - https://bioinformatics.psb.ugent.be/webtools/Venn/
   - 火山图的解读
      - X轴：以log2(FC)=1(T/C=2表示上调);log2(FC)=-1(T/C=1/2表示下调)
      - y轴：-log10(Pvalue=0.01),y轴＞2说明小于0.01有意义
3. 功能富集分析
   - Gene Ontology 基因本体论富集分析
      - CC细胞组分
      - MF分子功能
      - BP 生物进程
   - KEGG 通路富集分析
   - topGO，Gostat，Rgraphviz 包的使用
   - DAVID，Pather，Gostat 在线工具的使用
      - DAVID输入officer gene symbol

   - GSEA 的使用
   - BiNGO，ClueGO，CluePedia 插件的使用(基因注释)
4. 聚类分析
   - gplots 包的使用
   - pheatmap 包的使用
   - 聚类图的绘制
      - 热图的做法
      - 气泡图的做法(根据DAVID制作的BP,CP,MP，制作气泡图imageGP网站，整理KEGG.txt数据)
          - 整理数据-视图-分割
5. 网络分析
   - Interaction 网络
   - Co-expression 网络
   - 常用分子互作数据库：String，HPRD，BIND 等
      - string（setting去掉单个的点）
   - 常用共表达分析工具：cBioPortal，WGCNA
      - cBioPortal选择
         - 突变
         - 共表达
   - gepia网络研究
   - 网络可视化工具：Cytoscape，VisANT
      - Cytoscape软件（导入string中的结果）
         - MCODE, cytohubba核心基因分析
         - BiNGO，ClueGO，CluePedia 基因注释
   - 网络拓扑结构分析、关键基因识别
6. 临床信息关联分析
      - TCGA临床数据下载：clinic+bcr=添加到购物车（400多文件夹，一个文件一个样本）
      - 数据整理： 打开命令提示符（注意转换盘符）perl getclinic.pl=clinic.xls
      - 区分mRNA和lincRNA
      - 铁死亡相关基因提取
      - 铁死亡相关lincRNA
      - 差异分析:    - FerrGeneExp.txt++FerrLncExp.txt+相应的R代码(FerrLnc10.diff.R)=gene.all.xls+gene.diff.txt+gene.diff.xls/linc....
      - GO分析:gene.diff.txt+R包
      - KEGG分析：gene.diff.txt+R包
      - lncRNA的表达和生存数据的合并=risk.txt
      - 预后相关的lincRNA 型
      - 相关性检验
      - 生存分析：clinic.txt+time.txt+lncRNA.diffExp.txt=expTime.txt
      - 线性回归：单因素expTime.txt+R包
      - 多因素：expTime.txt+uniSigExp.txt+R包
      - 生存分析risk.txt+R包
      - 风险曲线:risk.txt+R包
      - 独立预后分析：clinic.xls(改格式0/1)+risk.txt+R包
      - ROC曲线：clinic.xls(改格式0/1)+risk.txt+R包
      - 决策曲线
      - 列线图（1年，2年，5年）
      - 
      lasso 分析
## 五、分子生物信息SCI 
1. 数据下载和整理（表达数据和临床数据）
     - 04.矩阵数据整理
       - 下载文件后整理成sample1（control）和sample2+expMatrix.txt
     - 05.单个样品文件数据整理
     - 06.ensembl数据整理
        - 打开命令提示符（注意转换盘符）
         - perl geoSeq06.ensembl2symbol.pl+ensemble.txt(粘贴自GSE下载矩阵文件)+human.gtf=expMatrix
     - 07.gene数据整理
        - 打开命令提示符（注意转换盘符cd/d D:/）
         - geoSeq07.id2symbol.pl（切换盘符）+id.txt(粘贴自GSE下载文件)+ref.txt=expMatrix
2. 提取科学问题相关基因表达量
3. 差异分析
     - 08.整数-原始count差异分析（fdr）
       - sample1+sample2+expMatrix.txt+相应的R代码=all.xls+diff.txt+diff.xls+diffGeneExp.txt+heatmap.pdf，edgeR包
     - 09.整数-原始count差异分析（pvalue），edgeR包
     - 10.小数-normalize数据差异分析(fdr过滤)，lima包
     - 11.小数-normalize数据差异分析(pvalue过滤)，lima包
4. GO 和KEGG 分析
   - 气泡图
5. 共表达预测科学问题相关分子
6. 预后相关分子筛选
7. 构建预后模型
   - y = k1x1+k2x2...
8. 生存曲线和ROC 曲线的绘制
9. 风险曲线
10. 独立预后分析
11. 决策曲线（DCA）的绘制
12. 列线图的绘制
13. 其他关联分析
## 六、多组学数据联合分析：
1. 甲基化与转录组整合分析思路演练
   1. 甲基化数据预处理
   2. 差异甲基化位点及区域识别
   3. 甲基化与转录组数据联合分析
   4. 公共表观数据库：ENCODE、regulomeDB
2. lncRNA-miRNA-mRNA 全转录组整合分析思路演练
   1. lncRNA 表达谱数据获取
   2. miRNA 靶基因分析
   3. lncRNA 与mRNA 表达相关性分析
   4. ceRNA 网络构建及结果可视化


