  
# /nlmusr/gchirn/linux/TOOLS/bin/R --no-restore --no-save --no-readline chrII:5797860-5798307 chrII:5797860-5798307.gen chrII:5797860-5798307-50-0-1


  args <- commandArgs();      # retrieve args
  arg_length=length(args)

  tab <- read.table(args[5],header=T)

  n_sample=(ncol(tab)-2)/2
n_sample
names(tab)[1]

  img_width=8
  img_high=11
  out_file_name=args[7]
  out_file_name=paste(out_file_name,".pdf",sep="",collapse=NULL)
# absminy=args[8]
# absmaxy=args[9]
#absminy
#absmaxy
  miny=min(tab[3:(n_sample*2+2)])
  maxy=max(tab[3:(n_sample*2+2)])


  miny_1=min(tab[3:((n_sample-1)*2+2)])
  maxy_1=max(tab[3:((n_sample-1)*2+2)])

  miny_2=min(tab[((n_sample-1)*2+3):((n_sample)*2+2)])
  maxy_2=max(tab[((n_sample-1)*2+3):((n_sample)*2+2)])

#miny_1=miny
#miny_2=miny
#maxy_1=maxy
#maxy_2=maxy
miny
maxy
# if(absminy<0){
#   miny=absminy
# }
# if(absmaxy>0){
#   maxy=absmaxy
# }
#miny
#maxy
  minx=min(tab[2])
  maxx=max(tab[2])
minx
maxx
tab[1,2]
  pdf(out_file_name,width=img_width,height=img_high)
  par(mfrow=c(n_sample,1),mar=c(0,0,1,0),oma=c(2,2,2,2))
#
# Make the coverage plot
#
  for(i in 1:(n_sample-1)){
    positive=0
    negative=0
#miny_1=min(tab[((i-1)*2+3):((i)*2+2)])
#maxy_1=max(tab[((i-1)*2+3):((i)*2+2)])
    plot(c(minx,maxx),c(miny_1,maxy_1),type='n',main=names(tab)[(i-1)*2+3],xlab="",ylab="",axes=FALSE)
    lines(c(minx,maxx),c(0,0),col="gray30",lwd=0.1)
    for(j in 1:nrow(tab)){
      if(tab[j,(i-1)*2+3]!=0){
        rect(tab[j,2],0,tab[j+1,2],tab[j,(i-1)*2+3],col="red",border=NA)
        positive=positive+tab[j,(i-1)*2+3]
      }
      if(tab[j,(i-1)*2+4]!=0){
        rect(tab[j,2],0,tab[j+1,2],tab[j,(i-1)*2+4],col="blue",border=NA)
        negative=negative+tab[j,(i-1)*2+4]
      }
    }
    axis(2,cex.axis=1)
    negative=0-negative
    total=positive+negative
    main=paste("positive=", sep="",round(positive, digits = 0))
    main=paste(main, sep=", negative=",round(negative, digits = 0))
    main=paste(main, sep=", total=",round(total, digits = 0))
    text(minx,miny_1,main,adj=c(0,0),cex =1)
  }

  for(i in n_sample:n_sample){
    positive=0
    negative=0
    plot(c(minx,maxx),c(miny_2,maxy_2),type='n',main=names(tab)[(i-1)*2+3],xlab="",ylab="",axes=FALSE)
    lines(c(minx,maxx),c(0,0),col="gray30",lwd=0.1)
    for(j in 1:nrow(tab)){
      if(tab[j,(i-1)*2+3]!=0){
        rect(tab[j,2],0,tab[j+1,2],tab[j,(i-1)*2+3],col="red",border=NA)
        positive=positive+tab[j,(i-1)*2+3]
      }
      if(tab[j,(i-1)*2+4]!=0){
        rect(tab[j,2],0,tab[j+1,2],tab[j,(i-1)*2+4],col="blue",border=NA)
        negative=negative+tab[j,(i-1)*2+4]
      }
    }
    axis(2,cex.axis=1)
    axis(1,cex.axis=1)
    negative=0-negative
    total=positive+negative
    main=paste("positive=", sep="",round(positive, digits = 0))
    main=paste(main, sep=", negative=",round(negative, digits = 0))
    main=paste(main, sep=", total=",round(total, digits = 0))
    text(minx,miny_2,main,adj=c(0,0),cex =1)
  }
#
#
# Make the gene structure plot
#
  gene_file_name=args[5]
  gene_file_name=paste(gene_file_name,".gen",sep="",collapse=NULL)
  gen <- read.table(gene_file_name,header=T)

  main=paste("Window size=", sep="",gen[1,3])
  main=paste(main, sep=", length=",gen[1,4])
  main=paste(main, sep=", ",gen[1,5])
# main=paste(main, sep=", filename:",out_file_name)
  text(maxx,miny_2,main,adj=c(1,0),cex =1)


# miny=min(gen[2])-1
# maxy=max(gen[2])+1
# plot(c(minx,maxx),c(miny-1,maxy+1),type='n',main="",xlab="",ylab="",axes=FALSE)
# axis(1,cex.axis=0.8)
# lines(c(minx,maxx),c(0,0),col="gray30",lwd=0.1)
# for(i in 1:nrow(gen)){
#   if(gen[i,1]==9){
#     main=paste("Window size=", sep="",gen[i,3])
#tep=gen[i,3]
#     main=paste(main, sep=", length=",gen[i,4])
#     main=paste(main, sep=", ",gen[i,5])
#     main=paste(main, sep=", filename:",out_file_name)
#     text(minx,miny-1,main,adj=c(0,0),cex =.70)
#   }
#   else if(gen[i,1]==0){
#     if(gen[i,2]>0){
#       lines(c(gen[i,3],gen[i,4]),c(gen[i,2],gen[i,2]),col="red",lwd=0.1)
#     }
#     else{
#       lines(c(gen[i,3],gen[i,4]),c(gen[i,2],gen[i,2]),col="blue",lwd=0.1)
#     }
#     text(gen[i,3],gen[i,2],gen[i,5],pos=2,adj=c(0,0),cex =.70)
#   }
#   else if(gen[i,1]==1){
#   }
#   else if(gen[i,1]==2){
#     if(gen[i,2]>0){
#       rect(gen[i,3],gen[i,2]-0.1,gen[i,4],gen[i,2]+0.1,col="red",border=NA)
#     }
#     else{
#       rect(gen[i,3],gen[i,2]-0.1,gen[i,4],gen[i,2]+0.1,col="blue",border=NA)
#     }
#   }
#   else if(gen[i,1]==3){
#     if(gen[i,2]>0){
#       rect(gen[i,3],gen[i,2]-0.2,gen[i,4],gen[i,2]+0.2,col="red",border=NA)
#     }
#     else{
#       rect(gen[i,3],gen[i,2]-0.2,gen[i,4],gen[i,2]+0.2,col="blue",border=NA)
#     }
#   }
# }

#
# Make the repeat structure plot
#
# rep_file_name=args[5]
# rep_file_name=paste(rep_file_name,".rep",sep="",collapse=NULL)
# rep <- read.table(rep_file_name,header=T)
# miny=min(rep[2])-2
# maxy=max(rep[2])+2
# plot(c(minx,maxx),c(miny-1,maxy+1),type='n',main="",xlab="",ylab="",axes=FALSE)
# axis(1,cex.axis=0.8)
# lines(c(minx,maxx),c(0,0),col="gray30",lwd=0.1)
# for(i in 1:nrow(rep)){
##text(minx,i,i,pos=2,adj=c(0,0),cex =.70)
#   if(gen[i,1]==9){
#     main=paste("Window size=", sep="",gen[i,3])
#     main=paste(main, sep=", length=",gen[i,4])
#     main=paste(main, sep=", ",gen[i,5])
#     main=paste(main, sep=", filename:",out_file_name)
#     text(minx,miny-1,main,adj=c(0,0),cex =.70)
##text(minx+100,i,i,pos=2,adj=c(0,0),cex =.70)
#   }
#   else if(rep[i,1]==0){
##text(minx+300,i,i,pos=2,adj=c(0,0),cex =.70)
##text(minx+(step+1)*10,i,rep[i,2],pos=2,adj=c(0,0),cex =.70)
#     if(rep[i,2]>0){
#       lines(c(rep[i,3],rep[i,4]),c(rep[i,2],rep[i,2]),col="red",lwd=0.1)
#     }
#     else{
#       lines(c(rep[i,3],rep[i,4]),c(rep[i,2],rep[i,2]),col="blue",lwd=0.1)
#     }
#     text(rep[i,3],rep[i,2],rep[i,5],pos=2,adj=c(0,0),cex =.70)
#   }
##text(minx+600,i,rep[i,1],pos=2,adj=c(0,0),cex =.70)
# }

q()
