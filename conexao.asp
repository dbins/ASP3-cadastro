<%
Function Banco_de_Dados()
Set Conexao = Server.CreateObject("ADODB.Connection")
Conexao.CommandTimeout = 0
Conexao.Open "Provider=SQLOLEDB; Network Library=dbmssocn; Data Source=xxx.xxx.xxx.xxx; User ID=xx; Password=xxxxxxx; Initial Catalog=xxxxx;"
Set Banco_de_Dados=Conexao
End Function

Sub Fechar_Banco(ByVal Conexao)
Conexao.close
Set Conexao=nothing
End Sub
%>
