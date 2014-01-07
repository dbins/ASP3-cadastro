<!--#include file="conexao.asp"-->
<!--#include file="site.asp"-->
<%
Set banco=Banco_de_Dados()
Set dados=CriarDicionario()
For Each k In dados.Keys
	dados(k) = ValidarDados(dados(k))
Next

if not (dados("Email") = "" OR IsNULL(dados("Email"))) then
	dados("Email")=RemoveAcentos(dados("Email"))
	dados("Email") = Trim(dados("Email"))
	dados("Email") = replace(dados("Email"), " ", "")
end if

acao = ValidarDados(request("acao"))
CPF = dados("CPF")
if acao = "inserir" then
	IF NOT CPF="" then
		'Verificando se o CPF existe na base de dados
		StrSQL = "SELECT * FROM cadastros WHERE cad_cpf = '"& CPF &"'"
		Set rsVerificar = banco.execute(StrSQL)
		if rsVerificar.eof then
				
			Senha = CPF
			GravarConexao = InserirEntidadeCliente2(dados, banco)
				
			'Mensagem = "Dados do cliente gravados com sucesso!"
			Mensagem = "Dados gravados com sucesso!"
			Status = "0"
		else
			Mensagem = "O CPF informado ja esta gravado em nosso sistema!"
			Status = "99"
		end if
	else
		Mensagem = "Nao foram postados dados para esta pagina"
		Status = "99"
	end if
end if

if acao = "atualizar" then
		Entidade = ValidarDados(request.form("codigo"))
		StrSQL = "SELECT * FROM cadastros WHERE cad_cpf = '"& CPF &"'"
		Set rsVerCPF = banco.execute(StrSQL)
		if rsVerCPF.eof then
			continuar_atualizacao = "OK"
		else
			'Verificando se o CPF já existe para o mesmo codigo. Se existir, continuar, caso contrário, erro
			StrSQL = "SELECT * FROM cadastros WHERE cad_cpf = '"& CPF &"' and cad_cod = " & dados("codigo")
			Set rsVerCPF2 = banco.execute(StrSQL)
			if NOT rsVerCPF2.eof then
				'Se existe o CPF para o mesmo código, é a atualização do cadastro existente
				continuar_atualizacao = "OK"
			else
				'O CPF informado existe para um cadasto diferente do atual. Recusar a atualização de dados.
				continuar_atualizacao = "ERRO"
			end if	
		end if
	
		if continuar_atualizacao = "OK" then
			cli = GravarEntidadeCliente(dados, banco)
			Mensagem = "Seus dados foram atualizados com sucesso!"
		else
			Mensagem = "O CPF que você informou já existe em outro cadastro. Não será possível atualizar os seus dados."	
		end if
end if

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Cadastro</title>
	</head>
<body>
	<%=Mensagem%>
</body>
</html>
