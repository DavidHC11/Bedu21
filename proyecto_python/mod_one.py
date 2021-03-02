import pandas as pd
import numpy as np
import plotly
from plotly.offline import plot,iplot
pd.options.plotting.backend = "plotly"
import plotly.graph_objects as go
import numpy as np
import cufflinks as cf
import re
import unicodedata
import plotly.express as px
import nltk
from nltk.corpus import stopwords
from nltk import FreqDist
from PIL import Image
import matplotlib.pyplot as plt
from scipy import stats
import itertools
from scipy.stats import chisquare
cf.go_offline()

# Gráficos
def bar(df,col,title,top,x_title="",y_title=""):
    layout = go.Layout(font_family="Arial",
    font_color="black",title_text=title,title_font_size=27,xaxis= {"title": {"text": x_title,"font": {"family": 'Arial',"size": 18,
        "color": '#000000'}}},yaxis= {"title": {"text": y_title,"font": {"family": 'Arial',"size": 18,
        "color": '#000000'}}},title_font_family="Arial",title_font_color="#000000",template="ggplot2")
    g_aux=pd.DataFrame(df[col].value_counts().head(top)).reset_index().rename(columns={"index":"conteo"})
    fig=g_aux.iplot(kind='bar',x="conteo",y=col,title=title,asFigure=True,barmode="overlay",sortbars=True,color="#2F789C",layout=layout)
    fig.update_layout(width=600)
    fig.update_traces(marker_color='#2F789C')
    return fig
def box(df,col,title):
    layout = go.Layout(font_family="Arial",
    font_color="black",title_text=title,title_font_size=30,xaxis= {"title": {"font": {"family": 'Arial',"size": 18,
        "color": '#002e4d'}}},title_font_family="Arial",title_font_color="#004878",template="plotly_white")
    fig=df[[col]].iplot(kind='box',title=title,asFigure=True,theme="white",layout=layout,color="#2F789C")
    return fig

def histogram(df,col,bins,title):
    layout = go.Layout(font_family="Arial",
    font_color="black",title_text=title,title_font_size=30,xaxis= {"title": {"font": {"family": 'Arial',"size": 18,
        "color": '#002e4d'}}},title_font_family="Arial",title_font_color="#004878",template="plotly_white")
    fig=df[[col]].iplot(kind='histogram',x=col,bins=bins,title=title,asFigure=True,theme="white",layout=layout,color="#2F789C")
    fig.update_traces(opacity=0.90)
    return fig

def pie(df,col,title,x_title="",y_title=""):
    layout = go.Layout(template="plotly_white")
    colors=[ "#2F789C","#60D394","#AAF683","#FFD97D","#FF9B85","#00569c","#005ba3","#0061a9","#1567af","#226cb6","#2c72bc", "#0061a9","#4c79b7","#7492c6","#98acd4","#bbc7e2","#dde3f1","#ffffff"
]
    aux=pd.DataFrame(df[col].value_counts()).reset_index().rename(columns={"index":"conteo"})
    fig=aux.iplot(kind='pie',labels="conteo",values=col,title=title,asFigure=True,theme="white")
    
    fig.update_traces(textfont_size=10,
                  marker=dict(colors=colors, line=dict(color='#000000', width=2)))
    fig.update_traces(textposition='inside', textinfo='percent+label')
    fig.update_layout(font_family="Arial",
    font_color="black",title_text=title,title_font_size=30,title_font_family="Arial",title_font_color="#004878",template="plotly_white")
    return fig

#Funciones
def clean_text(text, pattern="[^a-zA-Z0-9]"):
    cleaned_text = unicodedata.normalize('NFD', text).encode('ascii', 'ignore')
    cleaned_text = re.sub(pattern, " ", cleaned_text.decode("utf-8"), flags=re.UNICODE)
    cleaned_text = u' '.join(cleaned_text.lower().strip().split())
    return cleaned_text

def completitud(data):
    cp=pd.DataFrame(data.isnull().sum())
    cp.reset_index(inplace=True)
    cp=cp.rename(columns={"index":"columna",0:"total"})
    cp["completitud"]=(1-cp["total"]/data.shape[0])
    cp=cp.sort_values(by="completitud")
    cp=cp[cp['total']>0]
    cp.reset_index(drop=True,inplace=True)
    return cp

def clean(data,col):
    data=data[data[col]!='']
    data.reset_index(drop=True,inplace=True)
    lista_stopwords_es = stopwords.words("spanish")
    lista_stopwords_en = stopwords.words("english")
    data[col]=data[col].map(lambda x:" ".join(list(filter(lambda x:x not in lista_stopwords_es,x.split()))).strip())
    data[col]=data[col].map(lambda x:" ".join(list(filter(lambda x:x not in lista_stopwords_en,x.split()))).strip())
    data=data[data[col]!='']
    data.reset_index(drop=True,inplace=True)
    corpus=' '.join(data[col].values)
    fdist=nltk.FreqDist(corpus.split())
    list_hapaxes=fdist.hapaxes()
    data[col]=data[col].map(lambda text:' '.join([x for x in text.split(' ') if x not in list_hapaxes]))
    data=data[data[col]!='']
    data.reset_index(drop=True,inplace=True)
    return data

def OUTLIERS(df,cols):
    results=pd.DataFrame()
    data_iqr=df.copy()
    data_per=df.copy()
    total=[]
    total_per=[]
    indices_=[]

    for col in cols:
        #IQR
        Q1=df[col].quantile(0.25)
        Q3=df[col].quantile(0.75)
        IQR=Q3-Q1
        INF=Q1-1.5*(IQR)
        SUP=Q3+1.5*(IQR)
    
        
        n_outliers=df[(df[col] < INF) | (df[col] > SUP)].shape[0]
        total.append(n_outliers)
        indices_iqr=list(df[(df[col] < INF) | (df[col] > SUP)].index)
        
        #Percentiles
        INF_pe=np.percentile(df[col].dropna(),5)
    
        SUP_pe=np.percentile(df[col].dropna(),95)
        n_outliers_per=df[(df[col] < INF_pe) | (df[col] > SUP_pe)].shape[0]
        total_per.append(n_outliers_per)
        indices_per=list(df[(df[col] < INF_pe) | (df[col] > SUP_pe)].index)
        
        
        indices_.append(aux_outliers(indices_iqr,indices_per))
        
    results["features"]=cols
    results["n_outliers_IQR"]=total
    results["n_outliers_Percentil"]=total_per
    results["n_outliers_IQR_%"]=round((results["n_outliers_IQR"]/df.shape[0])*100,2)
    results["n_outliers_Percentil_%"]=round((results["n_outliers_Percentil"]/df.shape[0])*100,2)
    results["indices"]=indices_
    results["total_outliers"]=results["indices"].map(lambda x:len(x))
    results["%_outliers"]=results["indices"].map(lambda x:round(((len(x)/df.shape[0])*100),2))
    results=results[['features', 'n_outliers_IQR', 'n_outliers_Percentil',
                     'n_outliers_IQR_%', 'n_outliers_Percentil_%','total_outliers', '%_outliers','indices']]
    return results

def aux_outliers(a,b):
    a=set(a)
    b=set(b)
    
    a_=a.intersection(b)

    b_=b.intersection(a)


    outliers_index=list(set(list(a_)+list(b_)))
    return outliers_index

def tableoutliers(df,outliers):
    data=df.copy()
    lista=[df.shape[0]]
    lista_ca=["Inicial"]
    for col in list(outliers["features"].values):
        indices=list(itertools.chain(*list(outliers[outliers["features"]==col]["indices"].values))) 
        data=data[~data.index.isin(indices)]
        lista.append(data.shape[0])
        lista_ca.append(col)
    tabla_registros=pd.DataFrame()
    tabla_registros["v_feature"]=lista_ca
    tabla_registros["c_n_rows"]=lista
    
    return tabla_registros

def dropoutliers(df,outliers):
    indices = list(set(list(itertools.chain(*list(outliers["indices"].values)))))
    df_new=df[~df.index.isin(indices)].reset_index(drop=True)
    return df_new

def mode_miss(X_train,X_test,col,df):
    moda=X_train[col].value_counts().index[0]
    X_train[col]=X_train[col].fillna(moda)
    X_test[col]=X_test[col].fillna(moda)
    x_i=df[col].fillna(moda).value_counts()
    k=x_i.sum()
    p_i=df[col].dropna().value_counts(1)
    m_i=k*p_i
    chi=chisquare(f_obs=x_i,f_exp=m_i)
    p_val=chi.pvalue
    alpha=0.05
    if p_val<alpha:
        a=print("Rechazamos HO(La porporción de categorias es la misma que la general)")
    else:
        a=print("Aceptamos HO(La porporción de categorias es la misma que la general)")
    return a

def missings_digit(x):
    if sum([y.isdigit() for y in str(x)])>0:
        result=np.nan
    else:
        result=x
    return result  


def transform_white_backgroud(png_path):
    picture = Image.open(png_path).convert("RGBA")
    image = Image.new("RGB", picture.size, "WHITE")
    image.paste(picture, (0, 0), picture)

    plt.imshow(image)
    
    mask = np.array(image)
    
    return mask  
