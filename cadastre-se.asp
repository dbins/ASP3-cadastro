<!--#include file="conexao.asp"-->
<!--#include file="cadastros_gerais.asp"-->
<%
CPF= Session("TMP_CPF")
Set banco=Banco_de_Dados()
if not Session("entidade") ="" then
	'Carregando os campos
	StrSQL = "SELECT * FROM CADASTROS WHERE cad_COD = "& Session("entidade")
	Set rs1 = banco.execute(StrSQL)
	if not rs1.eof then
		acao = "atualizar"
		Codigo = rs1.fields("cad_cod")
		Nome = Server.HTMLEncode(rs1.fields("cad_nome"))
		CPF = rs1.fields("cad_cpf")
		RG = rs1.fields("cad_rg")
		Data_Nascimento = rs1.fields("cad_data_nasc")
		Senha = rs1.fields("cad_senha")
		
		'Padronizando a data de nascimento
		if not (IsNULL(Data_Nascimento) OR Data_Nascimento="") then
			tmp_dia = Day(Data_Nascimento)
			if len(tmp_dia) = 1 then
				tmp_dia = "0" & tmp_dia
			end if
			tmp_mes = Month(Data_Nascimento)
			if len(tmp_mes) = 1 then
				tmp_mes = "0" & tmp_mes
			end if
			tmp_ano = Year(Data_Nascimento)
			Data_Nascimento = tmp_dia & "/" & tmp_mes & "/" & tmp_ano
		end if
			
		Email = rs1.fields("cad_email")

		'Carregando o endereco
		StrSQL = "SELECT * FROM ENDERECOS WHERE END_TIPO = 1 AND END_ENTIDADE = " & rs1.fields("cad_cod")
		Set rs2 = banco.execute(StrSQL)
		if not rs2.eof then
			Endereco_Residencial = Server.HTMLEncode(rs2.fields("end_rua"))
			Numero_Residencial = rs2.fields("end_numero")
			Bairro = Server.HTMLEncode(rs2.fields("end_bairro"))
			complemento_residencial = rs2.fields("end_compl")
			Cidade = rs2.fields("end_cidade")
			Estado = rs2.fields("end_estado")
			CEP = rs2.fields("end_cep")
		end if
			
		'Carregando os telefones
		StrSQL = "SELECT * FROM TELEFONES WHERE TEL_ENTIDADE = "  & rs1.fields("cad_cod") 
		Set rs3 = banco.execute(StrSQL)
		Do While not rs3.eof
			if rs3.fields("tel_tipo") = "1" then 'Residencial
				Telefone_Residencial = rs3.fields("tel_numero")
				DDD_Residencial = rs3.fields("tel_ddd")
			end if
			if rs3.fields("tel_tipo") = "2" then 'Celular
				Celular = rs3.fields("tel_numero")
				DDD_Celular = rs3.fields("tel_ddd")
			end if
		rs3.movenext
		Loop
	else
		acao = "inserir"
	end if
else
	acao = "inserir"
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Cadastre-se </title>
<script language="JavaScript" src="site.js" charset="iso-8859-1"></script>
</head>
<body>
        
  <form id="form1" name="form1" method="post" action="cadastro_concluido.asp" onSubmit="return checkform_cadastro(this);" >
  
   <div id="1">
   
	<div style="float:left; margin:10px; width:98%; border-bottom:1px solid #CCC"><span class="font">Dados pessoais</span></div><!--titulos-->  
	<div style="float:left; margin:10px; width:60%;">
	<label class="font">Nome<span style="color:#F00">*</span></label>
	<input type="text" name="Nome" size="40" value="<%=Nome%>"/>
	</div>
   
   
	<div style="float:left; margin:10px; width:32%;">
	<label class="font">Data de Nascimento<span style="color:#F00">*</span></label>
	<input type="text" name="Data_Nascimento" size="40" maxlength="10" value="<%=Data_Nascimento%>"/>
	</div>
	
	<div style="float:left; margin:10px; width:30%;">
	<label class="font">CPF<span style="color:#F00">*</span></label>
	<input type="text" name="CPF" size="40" value="<%=cpf%>" maxlength="11"cad_ onkeypress="return isNumberKey(event)"/>
	</div>
	
	<div style="float:left; margin:10px; width:30%;">
	<label class="font">RG<span style="color:#F00">*</span></label>
	<input type="text" name="RG" size="40" value="<%=rg%>"/>
	</div>
	
	<div class="clear"></div>
	
	<div style="float:left; margin:10px; width:30%;">
	<label class="font">Senha<span style="color:#F00">*</span></label>
	<input type="password" name="senha" id="senha"cad_ maxlength="8" value="<%=Senha%>"/>
	</div>
	
	<div style="float:left; margin:10px; width:30%;">
	<label class="font">Confirmar Senha<span style="color:#F00">*</span></label>
	<input type="password" name="confirmar_senha" id="confirmar_senha"cad_ maxlength="8" value="<%=Senha%>"/>
	</div>
	
	<div class="clear"></div>

	<div  style="float:left; width:55%; margin:10px;">
	<label class="font">Endere&ccedil;o Residencial<span style="color:#F00">*</span></label>
	<input name="endereco_residencial" type="text" id="endereco_residencial" value="<%=endereco_residencial%>" size="70" maxlength="40" />
	</div>
	
	<div  style="float:left; width:25%; margin:10px;">
	<label class="font">CEP<span style="color:#F00">*</span></label>
	<input name="CEP" type="text" id="CEP" value="<%=CEP%>" size="70" maxlength="40"/>
	</div>
	
	<div  style="float:left; width:10%; margin:10px;">
	 <label class="font">N&uacute;mero<span style="color:#F00">*</span></label>
	<input name="numero_residencial" type="text" id="numero_residencial" size="9"  onkeypress="return isNumberKey(event)" value="<%=numero_residencial%>" />
	</div>
	
	<div  style="float:left; width:25%; margin:10px;">
	<label class="font">Complemento</label>
	<input name="complemento_residencial" type="text" id="complemento_residencial" value="<%=complemento_residencial%>"/>
	</div>
	
   <div  style="float:left; width:25%; margin:10px;">
	<label class="font">Bairro<span style="color:#F00">*</span></label>
	<input name="bairro" type="text" id="bairro" value="<%=bairro%>"/>
	</div>
   
				
   <div  style="float:left; width:25%; margin:10px;">
	<label class="font">Cidade<span style="color:#F00">*</span></label>
	<input name="cidade" type="text" id="cidade" value="<%=cidade%>"/>
	</div>
	
	
	<div  style="float:left; width:10%; margin:10px;">
	<label class="font">Estado<span style="color:#F00">*</span></label>
	<input name="estado" type="text" id="estado" value="<%=estado%>" />
	</div>    

	<div style="float:left; margin:10px; width:35%;">
	<label class="font">E-mail<span style="color:#F00">*</span></label>
	<input type="text" name="Email" size="40" value="<%=email%>"/>
	</div>
	
	 <div style="float:left; width:25%; margin:10px 0px 10px 10px;">
	 <label class="font">Telefone Residencial<span style="color:#F00">*</span></label><br />
	 <input name="DDD_residencial" type="text" id="DDD_residencial" size="2" maxlength="2"  value="<%=DDD_residencial%>"  onkeypress="return isNumberKey(event)" class="boxsmall">&nbsp;
	 <input name="telefone_residencial" type="text" size="10" maxlength="9"  value="<%=Telefone_Residencial%>"  onkeypress="return isNumberKey(event)" class="boxmedio"/></h3>
	 <span style=" margin:2px; font-size:10px">(somente números)</span>
	 </div>
	 
	<div style="float:left; width:25%; margin:10px 0px 10px 10px;">
	 <label class="font">Telefone Celular<span style="color:#F00">*</span></label><br />
	 <input name="DDD_celular" type="text" id="DDD_celular" size="2" maxlength="2"  value="<%=DDD_celular%>"  onkeypress="return isNumberKey(event)" class="boxsmall">&nbsp;
	 <input name="celular" type="text" size="10" maxlength="9"  value="<%=celular%>"  onkeypress="return isNumberKey(event)" class="boxmedio"/></h3>
	 <span style=" margin:2px; font-size:10px">(somente números)</span>
	 </div>
	 
	 
	<div style="float:right; width:12%; margin:5px 18px 0 10px;">
	<input type= "submit" name="submit" value="ENVIAR" class="btenviar"/>
	<input type="hidden" name="acao" value="<%=acao%>" />
	<input type="hidden" name="codigo" value="<%=codigo%>" />
	</div>
   
	</div> <!--id1-->
   </form><!--contact-->
		
</body>
</html>
