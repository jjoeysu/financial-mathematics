clear;clc;tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S0=100;
X=105;
r=0.05;
u=1.1;
d=0.9;
t=3;
[v,sp_bt,op_bt]=eur_q(S0,X,u,d,r,t,'u')

%欧式期权定价
%输入参数：
%S0：当前股票价格  X：交割价格  u:股价上涨系数  d:股价下跌系数
%r：无风险利率  t：期权的期数  class：期权类型（‘u’为看涨期权，‘d’为看跌期权）
%输出参数：
%v：期权定价  sp_bt：股价二叉树（矩阵）  op_bt：期权价格二叉树（矩阵）
function[v,sp_bt,op_bt]=eur_q(S0,X,u,d,r,t,class)
q=(exp(r)-d)/(u-d);
n=t+1;
m=2*t+1;
sp_bt=zeros(m,n);
op_bt=zeros(m,n);
sp_bt((m+1)/2,1)=S0;
for j=2:n
    if mod(j,2)==1
    ku=(m+1)/2;
    kd=(m+1)/2;
    lu1=floor(j/2);
    lu2=lu1;ld1=lu1;ld2=lu1;
    while ku>(m+1)/2-j
        sp_bt(ku,j)=S0*u^(lu1)*d^(ld1);
        sp_bt(kd,j)=S0*u^(lu2)*d^(ld2);
        ku=ku-2;
        kd=kd+2;
        lu1=lu1+1;
        lu2=lu2-1;
        ld1=ld1-1;
        ld2=ld2+1;
    end
    else
    ku=(m+1)/2-1;
    kd=(m+1)/2+1;
    lu1=j/2;
    lu2=lu1-1;
    ld1=lu2;
    ld2=lu1;
    while ku>(m+1)/2-j
        sp_bt(ku,j)=S0*u^(lu1)*d^(ld1);
        sp_bt(kd,j)=S0*u^(lu2)*d^(ld2);
        ku=ku-2;
        kd=kd+2;
        lu1=lu1+1;
        lu2=lu2-1;
        ld1=ld1-1;
        ld2=ld2+1;
    end
    end
end
for i=1:m
    if class=='u'
    op_bt(i,n)=max(sp_bt(i,n)-X,0);
    else
        op_bt(i,n)=max(X-sp_bt(i,n),0);
    end
end
for j=n-1:-1:1
    for i=2:m-1
        op_bt(i,j)=exp(-r)*(q*op_bt(i-1,j+1)+(1-q)*op_bt(i+1,j+1));
    end
end

op_bt(sp_bt==0)=0;
v=op_bt((m+1)/2,1);
end

    
    
    