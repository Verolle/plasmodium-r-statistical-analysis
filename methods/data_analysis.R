
# Install packages 
install.packages("dplyr")
install.packages("ggplot2")
install.packages("lme4")
install.packages("lmerTest")
install.packages("effects")


#import plamodium data and ELISA Data
plasmodium<-read.csv("Plasmodium2025.csv")
plasmodium
cor<-read.csv("ELISA_Corticosterone.csv")
cor
crp<-read.csv("ElISA_CRP.csv")
crp
IgY<-read.csv("ELISA_IgY.csv")
IgY


#change the grouped variable in factors 
#plasmodium_data
library(dplyr)
plasmodium<-plasmodium %>%
  mutate(Birdtag=factor(Birdtag),
         Stimulation=factor(Stimulation),Time=factor(Time))
str(plasmodium)


#COR_dat
cor<-cor%>%
  mutate(Stimulation=factor(Stimulation),
         Birdtag=factor(Birdtag), Time=factor(Time))
str(cor)

crp<-crp%>%
  mutate(Stimulation=factor(Stimulation),
         Birdtag=factor(Birdtag), Time=factor(Time))
str(crp)

IgY<-IgY%>%
  mutate(Stimulation=factor(Stimulation),
         Birdtag=factor(Birdtag),Time.afterbite.=factor(Time.afterbite.))
str(IgY)

# does parasites differentiates between the two mosquito species Culex and Anopheles ,
# such that it reacts just to the competent vector  Culex in order to spread itself 
#or is he dumb and reacts to every bites including anopheles?

#calculate realtive change of gametocytaemia and LOGplasmides in each Birdtag group

rel_change<-plasmodium %>%
  group_by(Birdtag) %>%
  mutate(LOGplasmid_change=LOGplasmides-LOGplasmides[Time==0], 
         gamete_change=Gametocytaemia-Gametocytaemia[Time==0])%>%
  ungroup()
rel_change

#Calculate relative change in corticosterone in each bird group
deltaCorticosterone<-cor%>%
  group_by(Birdtag)%>%
  mutate(cortico_change=Corticosterone-Corticosterone[Time=="D0bef"])%>%
  ungroup()
deltaCorticosterone

#relative change in CRP in each Bird group
deltaCRP<-crp%>%
  group_by(Birdtag)%>%
  mutate(crp_change=CRP-CRP[Time=="D0"])%>%
  ungroup()
deltaCRP

#relative change in IgY in each Bird group
deltaIgY<-IgY%>%
  group_by(Birdtag)%>%
  mutate(IgY_change=IgY-IgY[Time.afterbite.=="D0"])%>%
  ungroup()
deltaIgY

#check if the selection and change effectively worked
rel_change %>%
  filter(Birdtag=="BleuFonce")%>%
  select(LOGplasmides,Gametocytaemia,LOGplasmid_change,gamete_change)%>%
  ungroup()

# visualize the  change in plsmid with time for each stimulation group
library(ggplot2)

ggplot(rel_change, aes(x=Time,y=LOGplasmid_change, color=Stimulation,group=Stimulation))+
  stat_summary(fun=mean, geom="line", size=1)+
  stat_summary(fun.data=mean_cl_normal,geom="errorbar", width=0.2)+
  labs(title="Relative Parasitaemia Dynamics",
       y="log10( DeltaParasitaemia Px-p0)",
       x="Time of post_exposure")+
  theme_minimal()

# visualize the  change in  gametes with time for each stimulation group
ggplot(rel_change,aes(x=Time,y=gamete_change,color=Stimulation, group=Stimulation))+
  stat_summary(fun=mean,geom="line",size=1)+
  stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2)+
  labs(title="Relative Gametocytaemia Dynamics with 95%CI",
       y="DeltaGametocytaemia Gx-G0",
       x="Time_post_exposure")+
  theme_minimal()

#observing these both graphs i realised that 
#the mosquito does not increases its gametocyteproduction after a mosquito byte 
#be it  anopheles or culex. 
#the plasmid change and gametocyte change in anopheles are always highest in anopheles

#visualize the change  in corticosterone  with time for each stimulation group
ggplot(deltaCorticosterone, aes(x=Time, y=cortico_change,color=Stimulation,group=Stimulation))+
  stat_summary(fun=mean,geom="line",size=1)+
  stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2)+
  labs(title="Relative corticostereone Dynamics with 95%CI",
       y="DeltaCorticosterone(ng/ml)",
       x="Time after exposure(days)")+
  theme_minimal()

# visualize the change in  CRP  with time for each stimulation type
ggplot(deltaCRP, aes(x=Time, y=crp_change,color=Stimulation,group=Stimulation))+
  stat_summary(fun=mean,geom="line",size=1)+
  stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2)+
  labs(title="Relative CRP Dynamics with 95%CI",
       y="DeltaCRP(ng/ml)",
       x="Time after exposure(days)")+
  theme_minimal()



# visualize the change in  IgY with time for each stimulation type
ggplot(deltaIgY, aes(x=Time.afterbite., y=IgY_change,color=Stimulation,group=Stimulation))+
  stat_summary(fun=mean,geom="line",size=1)+
  stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2)+
  labs(title="Relative IgY Dynamics with 95%CI",
       y="DeltaIgY(ng/ml)",
       x="Time after exposure(days)")+
  theme_minimal()






#we use the lmm model due to group measurements to prove the  spike significance

library(lme4)
library(lmerTest)
library(effects)
#model for  Parasitaemia
model_para<-lmer(LOGplasmid_change~Stimulation*Time+(1|Birdtag),
                 data=rel_change)
summary_para<-summary(model_para)
summary_para

#check if the Birdtag random effect is significant
ranova(model_para)
#check if time, stimulation and the  interaction is significant
anova(model_para)

#check residual plots
plot(model_para)


#does interaction effect match biological expectation
plot(allEffects(model_para))


#Model for Gametocytaemia
model_gameto<-lmer(gamete_change~Stimulation*Time +(1|Birdtag),data=rel_change)
summary_gameto<-summary(model_gameto)
summary_gameto

#check if the Birdtag random effect is significant
ranova(model_gameto)
#check if time, stimulation and the  interaction is significant
anova(model_gameto)
#check residual plots
plot(model_gameto)

#check if effect matches biological expectation
plot(allEffects(model_gameto))



#Model for  corticosterone
model_cor<-lmer(cortico_change~Stimulation*Time +(1|Birdtag),data=deltaCorticosterone)
summary(model_cor)

#check if the Birdtag random effect is significant
ranova(model_cor)
#check if time, stimulation and the  interaction is significant
anova(model_cor)
#check residual plots
plot(model_cor)
#check if effect matches biological expectation
plot(allEffects(model_cor))



# Check missing data pattern
table(deltaCRP$Stimulation, deltaCRP$Time, is.na(deltaCRP$crp_change))

# Remove D3 because CQ group has 100% missing data at this time point
deltaCRP <- deltaCRP %>% filter(Time != "D3")
# Remove D3 from factor levels so R doesn't try to use it in the model
deltaCRP$Time <- factor(deltaCRP$Time)

# visualize the change in CRP(without D3) with time for each stimulation type 
ggplot(deltaCRP, aes(x=Time, y=crp_change,color=Stimulation,group=Stimulation))+
  stat_summary(fun=mean,geom="line",size=1)+
  stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2)+
  labs(title="Relative CRP Dynamics with 95%CI (D3 excluded)",
       y="DeltaCRP(ng/ml)",
       x="Time after exposure(days)")+
  theme_minimal()

##Model for CRP with clean data
model_crp<-lmer(crp_change~Stimulation*Time +(1|Birdtag), data=deltaCRP)
summary(model_crp)

#check if the Birdtag random effect is significant
ranova(model_crp)
#check if time, stimulation and the  interaction is significant
anova(model_crp)
#check residual plots
plot(model_crp)

#check if effect matches biological expectation
plot(allEffects(model_crp))

#model for IgY
model_IgY<-lmer(IgY_change~Stimulation*Time.afterbite.+(1|Birdtag), data=deltaIgY)
summary(model_IgY)

#check if the Birdtag random effect is significant
ranova(model_IgY)
#check if time, stimulation and the  interaction is significant
anova(model_IgY)
#check residual plots
plot(model_IgY)
#check if effect matches biological expectation
plot(allEffects(model_IgY))


