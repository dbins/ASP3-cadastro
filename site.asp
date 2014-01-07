<%
'FUNCOES UTEIS
Function PrimeiroNome(ByRef Nome)
	espaco = InStr(Nome, " ")
	resposta = left(Nome, espaco)
	resposta = trim(resposta)
	PrimeiroNome = resposta
End Function

Function CleanX(strString)
	Set regEx = New RegExp
	regEx.Pattern = "[^a-z0-9 ]+"
	regEx.IgnoreCase = True
	regEx.Global = True
	CleanX = regEx.Replace(strString, "")
End Function

Function RemoveAcentos(ByVal Texto)   
    Dim ComAcentos   
    Dim SemAcentos   
    Dim Resultado   
    Dim Cont   
    'Conjunto de Caracteres com acentos   
    ComAcentos = "ÁÍÓÚÉÄÏÖÜËÀÌÒÙÈÃÕÂÎÔÛÊáíóúéäïöüëàìòùèãõâîôûêÇç"  
    'Conjunto de Caracteres sem acentos   
    SemAcentos = "AIOUEAIOUEAIOUEAOAIOUEaioueaioueaioueaoaioueCc"  
    Cont = 0   
    Resultado = Texto   
    Do While Cont < Len(ComAcentos)   
    Cont = Cont + 1   
    Resultado = Replace(Resultado, Mid(ComAcentos, Cont, 1), Mid(SemAcentos, Cont, 1))   
    Loop  
    RemoveAcentos = Resultado   
End Function  

function ereg_replace(strOriginalString, strPattern, strReplacement)
dim objRegExp : set objRegExp = new RegExp
with objRegExp
	.Pattern = strPattern
	.IgnoreCase = True 'Case insensitive - FALSE (match is case sensitive)
	.Global = True
	.Multiline = True
end with
ereg_replace = objRegExp.replace(strOriginalString, strReplacement)
set objRegExp = nothing
end function

Function CriarDicionario()
dim dctDados
' Cria dicionário global
set dctDados = Server.CreateObject("Scripting.Dictionary")
' Chaves "case insensitive"
' Preenche dicionário global
Set CriarDicionario = PreencheComRequest(dctDados)
End function

Function FormatarNumero(ByRef Numero, ByRef Casas)
resposta = 0
if not (IsNULL(Numero) or Numero = "") then
	resposta = FormatNumber(Numero, Casas)
end if
FormatarNumero = resposta
End Function

' Copia os valores do Request (POST e GET) para um dicionário (primeiro POST
' e depois GET).
' Parâmetros:
' - dctDados dictionary: destino dos dados
Function PreencheComRequest (ByRef dctDados)

	dim f, i

	' Valores POST
	for each f in Request.Form
			for i = 1 to Request.Form(f).Count
			  dctDados.add f, Request.Form(f)(i)
			next

	next

	' Valores GET
	for each f in Request.QueryString
			for i = 1 to Request.QueryString(f).Count
				if dctDados.Exists(f)= false then
				dctDados.add f, Request.QueryString(f)(i)
				end if
			next
	next
Set PreencheComRequest=dctDados
end function

'FUNCOES PARA O CADASTRO/ATUALIZACAO DE CLIENTES
Function GravarEntidadeCliente(ByRef dctDados, ByVal Conexao)
	
	'Alterado para evitar de apagar o nome e o CPF, por serem travados para edio por parte dos funcionrios.
	if not (dctDados("Nome")="" OR dctDados("CPF")="") then
		StrSQL="UPDATE cadastros SET cad_cpf = '"& dctDados("CPF") &"', cad_rg = '"& dctDados("RG") &"', "
		StrSQL = StrSQL & " cad_nome = '"&replace(dctDados("Nome"), "'", "")&"', cad_data_nasc = convert(datetime,'"&dctDados("Data_Nascimento")&"',103),  "
		StrSQL = StrSQL & " cad_email = '"&lcase(dctDados("Email"))&"',  cad_data_atu=convert(datetime,getdate(),103), "
		StrSQL = StrSQL & " cad_senha = '"& dctDados("senha") &"' "
		StrSQL = StrSQL & " WHERE cad_cod =" &  dctDados("codigo")
		Conexao.execute(StrSQL)
	end if
	'response.write(StrSQL)

	'Carregando o endereço
	StrSQL =  "SELECT * FROM ENDERECOS WHERE END_TIPO = 1 "
	StrSQL = StrSQL & " AND END_ENTIDADE = " & dctDados("codigo") & " AND END_RUA = '"& dctDados("endereco_residencial") & "' AND END_BAIRRO = '"& dctDados("bairro") &"' AND END_CIDADE = '"&  dctDados("cidade") &"' AND END_ESTADO = '"& dctDados("estado") &"' AND END_NUMERO = " & dctDados("numero_residencial") & " AND END_COMPL = '"& dctDados("complemento_residencial") &"'"
	'response.write(StrSQL)
	Set rs2 = Conexao.execute(StrSQL)
	if not rs2.eof then	
		'Não faz nada porque é o mesmo endereço
		StrSQL = "UPDATE ENDERECOS SET END_DATA_ATU = CONVERT(DATETIME, GETDATE(),103) WHERE END_COD = " & rs2.fields("end_cod")
		Conexao.execute(StrSQL)
	else
		end1  = InserirEndereco(dctDados("codigo"), 1, dctDados("endereco_residencial"), dctDados("numero_residencial"), ValidarDados(dctDados("complemento_residencial")), ValidarDados(dctDados("CEP")), dctDados("bairro"), dctDados("cidade"), dctDados("estado"), Conexao)
	end if	

	'Carregando os telefones
	StrSQL = "SELECT * FROM TELEFONES WHERE TEL_TIPO = 1 AND TEL_ENTIDADE = "  & dctDados("codigo")
	Set rs3 = Conexao.execute(StrSQL)
	if not rs3.eof then
		if not ValidarDados(dctDados("DDD_residencial")) = "" then
			tel1 = AtualizarTelefone(rs3.fields("tel_cod"), dctDados("codigo"), 1, dctDados("DDD_residencial"), dctDados("telefone_residencial"), Conexao)
		end if	
	else
		tel1 = GravarTelefone(dctDados("codigo"), 1, dctDados("DDD_residencial"), dctDados("telefone_residencial"), Conexao)
	end if
	
	StrSQL = "SELECT * FROM TELEFONES WHERE TEL_TIPO = 2 AND TEL_EXCLUIDO <> 'S' AND TEL_ENTIDADE = "  & dctDados("codigo")
	Set rs3 = Conexao.execute(StrSQL)
	if not rs3.eof then
		if not ValidarDados(dctDados("DDD_celular")) = "" then
			tel3 = AtualizarTelefone(rs3.fields("tel_cod"), dctDados("codigo"), 2, dctDados("DDD_celular"), dctDados("celular"), Conexao)
		end if
	else
		tel3 = GravarTelefone(dctDados("codigo"), 2, dctDados("DDD_celular"), dctDados("celular"), Conexao)
	end if
	
Set rsGravar = Conexao.execute(StrSQL)
GravarEntidadeCliente = "Dados atualizados com sucesso"
End Function

Function InserirEntidadeCliente2(ByRef dctDados, ByVal Conexao)

StrSQL="INSERT INTO cadastros (cad_cod_ext, "
StrSQL = StrSQL & " cad_cpf, cad_rg, cad_nome, cad_data_nasc, cad_nacion, cad_email, cad_data_cad, "
StrSQL = StrSQL & " cad_senha) VALUES "
StrSQL = StrSQL & " ('"& dctDados("CPF") &"',  '"& dctDados("CPF") &"','"& dctDados("RG") &"',"
StrSQL = StrSQL & " '"&UCase(dctDados("Nome"))&"',  '"&FormataData(dctDados("Data_Nascimento"))&"', 2173, "
StrSQL = StrSQL & " '"&dctDados("Email")&"', convert(datetime, getdate(), 103), '"& dctDados("senha") &"', "
StrSQL = StrSQL & ")"
'response.write(StrSQL)
'On error resume next
Set rsGravar = Conexao.execute(StrSQL)

'Recuperando o codigo da entidade gravada para gerar a conta e o cartao
StrSQL="SELECT MAX(cad_cod) as codigo FROM cadastros WHERE cad_doc01 = '"& dctDados("CPF") &"'"
Set rsTmp1 = Conexao.execute(StrSQL)
if not rsTmp1.eof then
codigo_entidade = rsTmp1.fields("codigo")
end if

'Criando o Endereco
'codigo 32 - tipo de endereco residencial
GravarEndereco = InserirEndereco(codigo_entidade, 1, dctDados("endereco_residencial"), dctDados("numero_residencial"), dctDados("complemento_residencial"), replace(dctDados("CEP"), "-", ""), dctDados("bairro"), dctDados("cidade"), dctDados("estado"), Conexao)

'Criando o telefone
'codigo 727 - tipo de telefone celular
IF NOT dctDados("DDD_celular")="" then
	IF NOT dctDados("celular") = "" then
		IF NOT dctDados("celular") = "0" then
			InserirTelefone = GravarTelefone(codigo_entidade, 2, dctDados("DDD_celular"), dctDados("celular"), Conexao)
		end if
	end if
end if

'codigo 515 - tipo de telefone residencial
IF NOT dctDados("DDD_residencial") = "" then
	IF NOT dctDados("telefone_residencial") = "" then
		IF NOT dctDados("telefone_residencial") = "0" then
			InserirTelefone = GravarTelefone(codigo_entidade, 1, dctDados("DDD_residencial"), dctDados("telefone_residencial"), Conexao)
		end if
	end if
end if

InserirEntidadeCliente2 = "O seu cadastro froi efetuado com sucesso!."
End Function

Function GravarTelefone(ByRef tel_entidade, ByRef tel_tipo, ByRef tel_ddd, ByRef tel_numero, ByVal Conexao)
DataCadastro = Now()
On Error resume Next
if not (tel_ddd = "" OR tel_numero = "") then
	if not (IsNull(tel_ddd) OR IsNull(tel_numero)) then
		StrSQL="INSERT INTO telefones (tel_entidade, tel_tipo, tel_ddd, tel_numero, tel_data_cad) VALUES ("&tel_entidade&","&tel_tipo&", "&tel_ddd&", "&tel_numero&", convert(datetime,'"&Data_Cadastro&"',103)) "
		Conexao.execute(StrSQL)
	end if
end if
GravarTelefone="O numero de telefone fornecido foi armazenado em nosso sistema"
End Function

Function AtualizarTelefone(ByRef tel_cod, ByRef tel_entidade, ByRef tel_tipo, ByRef tel_ddd, ByRef tel_numero, ByVal Conexao)
DataAtualizacao = Now()
StrSQL = "SELECT * FROM TELEFONES WHERE TEL_TIPO = " & tel_tipo & " AND TEL_DDD = " & tel_ddd & " and tel_numero = " & tel_numero & " AND tel_entidade = " & tel_entidade
Set rsVerTel = Conexao.execute(StrSQL)
if rsVerTel.eof then
	StrSQL="UPDATE telefones SET tel_entidade = " & tel_entidade &", tel_tipo = " & tel_tipo &",tel_ddd = " & tel_ddd &", tel_numero = " & tel_numero &", tel_data_atu = convert(datetime,'"& DataAtualizacao &"',103)  WHERE tel_cod = " & tel_cod
	Set rsTemp=Conexao.execute(StrSQL)
	
	if tel_tipo = 1 then
		varTipoTel = "RESIDENCIAL"
	end if
	if tel_tipo = 2 then
		varTipoTel = "CELULAR"
	end if
else
	'Não faz nada
end if
AtualizarTelefone="O numero de telefone fornecido foi atualizado em nosso sistema"
End Function

Function AtualizarEndereco(ByRef Codigo, ByRef end_entidade, ByRef end_tipo, ByRef end_rua, ByRef end_numero, ByRef end_compl, ByRef end_cep, ByRef end_bairro, ByRef end_cidade, ByRef end_estado, ByVal Conexao)
Data_Atualizacao=now()
StrSQL="UPDATE enderecos SET end_entidade="&end_entidade&", end_tipo="&end_tipo&", end_rua='"& replace(end_rua, "'", " ") &"', end_numero="&end_numero&", end_compl='"&replace(end_compl, "'", " ") &"', end_cep='"&end_cep&"', end_bairro='"& replace(end_bairro, "'", " ") &"', end_cidade='"& replace(end_cidade, "'", " ") &"', end_estado='"&end_estado&"', end_data_atu = convert(datetime,'"& Data_Atualizacao &"',103)  WHERE end_cod = " & Codigo
Set rsTemp=Conexao.execute(StrSQL)
AtualizarEndereco="O endereco foi atualizado em nosso sistema"
End Function

Function InserirEndereco(ByRef end_entidade, ByRef end_tipo, ByRef end_rua, ByRef end_numero, ByRef end_compl, ByRef end_cep, ByRef end_bairro, ByRef end_cidade, ByRef end_estado, ByVal Conexao)
Data_Cadastro=Now()
StrSQL="INSERT INTO enderecos(end_entidade, end_tipo, end_rua, end_numero, end_compl, end_cep, end_bairro, end_cidade, end_estado, end_data_cad, end_excluido) VALUES ("&end_entidade&", "&end_tipo&", '"&UCase(replace(end_rua, "'", " "))&"', '"&end_numero&"', '"&UCase(replace(end_compl, "'", " "))&"', '"&end_cep&"', '"&UCase(replace(end_bairro, "'", " "))&"', '"&UCase(replace(end_cidade, "'", " "))&"', '"&UCase(end_estado)&"', convert(datetime,'"&Data_Cadastro&"',103), 'N') "
Conexao.execute(StrSQL)
InserirEndereco="O endereco foi gravado em nosso sistema"
End Function
%>
