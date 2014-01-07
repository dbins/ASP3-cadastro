//funcoes para validacao
function alphanumeric(inputtxt) {    
	var letters = /^[0-9a-zA-Z]+$/;   
	if(inputtxt.value.match(letters)) {   
		return true;   
	} else {   
		return false;   
	}   
}  

function validatePassword (pw) {

	// enforce the no sequential, identical characters rule
	//if (/([\S\s])\1/.test(pw))
		//return false;
		
	if (/([\S\s])\1\1/.test(pw))
	return false;

	// enforce alphanumeric/qwerty sequence ban rules
		var	lower   = "abcdefghijklmnopqrstuvwxyz",
			badSequenceLength  = 0,
			upper   = lower.toUpperCase(),
			numbers = "0123456789",
			qwerty  = "qwertyuiopasdfghjklzxcvbnm",
			start   = badSequenceLength - 1,
			seq     = "_" + pw.slice(0, start);
		for (i = start; i < pw.length; i++) {
			seq = seq.slice(1) + pw.charAt(i);
			if (
				lower.indexOf(seq)   > -1 ||
				upper.indexOf(seq)   > -1 ||
				numbers.indexOf(seq) > -1 ||
				qwerty.indexOf(seq) > -1) {
				return false;
			}
		}

	// great success!
	return true;
}


function IsCEP(strCEP)
        {
  
	if (strCEP.length<8)
	return false;
  
	re = /#@?$%~|00000000|11111111|22222222|33333333|44444444|55555555|66666666|77777777|88888888|99999999/gi;
    if(re.test(strCEP)){
	     return false;
   }else{
     return true;
   }
}




function echeck(str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   //alert("Invalid E-mail ID")
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   //alert("Invalid E-mail ID")
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    //alert("Invalid E-mail ID")
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    //alert("Invalid E-mail ID")
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    //alert("Invalid E-mail ID")
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    //alert("Invalid E-mail ID")
		    return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		    //alert("Invalid E-mail ID")
		    return false
		 }

 		 return true					
	}

function checkMail(mail){
    var er = new RegExp(/^[A-Za-z0-9_\-\.]+@[A-Za-z0-9_\-\.]{2,}\.[A-Za-z0-9]{2,}(\.[A-Za-z0-9])?/);
    if(typeof(mail) == "string"){
        if(er.test(mail)){ return true; }
    }else if(typeof(mail) == "object"){
        if(er.test(mail.value)){ 
                    return true; 
                }
    }else{
        return false;
        }
}

function checaCPF (CPF) {
	if (CPF.length != 11 || CPF == "00000000000" || CPF == "11111111111" ||
		CPF == "22222222222" ||	CPF == "33333333333" || CPF == "44444444444" ||
		CPF == "55555555555" || CPF == "66666666666" || CPF == "77777777777" ||
		CPF == "88888888888" || CPF == "99999999999" || CPF == "01234567890")
		return false;
	soma = 0;
	for (i=0; i < 9; i ++)
		soma += parseInt(CPF.charAt(i)) * (10 - i);
	resto = 11 - (soma % 11);
	if (resto == 10 || resto == 11)
		resto = 0;
	if (resto != parseInt(CPF.charAt(9)))
		return false;
	soma = 0;
	for (i = 0; i < 10; i ++)
		soma += parseInt(CPF.charAt(i)) * (11 - i);
	resto = 11 - (soma % 11);
	if (resto == 10 || resto == 11)
		resto = 0;
	if (resto != parseInt(CPF.charAt(10)))
		return false;
       
	return true;
 }

function isNumberKey(evt)
{
 var charCode = (evt.which) ? evt.which : event.keyCode
 if (charCode > 31 && (charCode < 48 || charCode > 57))
	return false;

 return true;
}

function calculaIdade(dataNasc){ 
	var dataAtual = new Date();
	var anoAtual = dataAtual.getFullYear();
	var anoNascParts = dataNasc.split('/');
	var diaNasc =anoNascParts[0];
	var mesNasc =anoNascParts[1];
	var anoNasc =anoNascParts[2];
	var idade = anoAtual - anoNasc;
	var mesAtual = dataAtual.getMonth() + 1; 

//se mês atual for menor que o nascimento, nao fez aniversario ainda; (26/10/2009) 
	if(mesAtual < mesNasc){
		idade--; 
	} else {
		//se estiver no mes do nasc, verificar o dia
		if(mesAtual == mesNasc){ 
			if(dataAtual.getDate() < diaNasc ){ 
				//se a data atual for menor que o dia de nascimento ele ainda nao fez aniversario
				idade--; 
			}
		}
	} 
	return idade; 
}



//Validacoes do site
function checkform_cadastro ( form )
{
var continuar = true;
var mensagem = "Ocorreram os seguintes erros:\n"

		if (form.Nome.value == "") {
		mensagem = mensagem + 'Preencha o nome\n';
		form.Nome.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.CPF.value == "") {
		mensagem = mensagem + 'Preencha o CPF\n';
		form.CPF.style.backgroundColor='#FFFF99';
		continuar = false;
		} else {
			if (checaCPF (form.CPF.value)==false){
			mensagem = mensagem +  'O CPF foi preenchido de forma incorreta\n';
			continuar = false;
			} 		
		}
		
		if (form.Email.value == "") {
			mensagem = mensagem +  'Digite o endereço de e-mail\n';
			form.Email.style.backgroundColor='#FFFF99';
			continuar = false;
		} else {
			if (echeck(form.Email.value)==false){
				mensagem = mensagem + 'Preencha corretamente o endereço de e-mail\n';
				continuar = false;
			}
		}
		
		if (form.RG.value == "") {
		mensagem = mensagem + 'Preencha o RG\n';
		form.RG.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		
		if (form.Data_Nascimento.value == "") {
		mensagem = mensagem + 'Preencha a data de nascimento\n';
		form.Data_Nascimento.style.backgroundColor='#FFFF99';
		continuar = false;
		} else {
			var idade;
			idade = calculaIdade(form.Data_Nascimento.value);
			if (idade < 0) {
				//O ano de aniversario e maior que a data atual
				mensagem = mensagem + 'O ano da data de nascimento é maior que o ano da data atual\n';
				form.Data_Nascimento.style.backgroundColor='#FFFF99';
				continuar = false;
			} else {
				//Se a idade for menor de 18 anos, não permitir cadastrar
				if (idade < 18){
					mensagem = mensagem + 'Somente participantes maiores que 18 anos podem participar\n';
					form.Data_Nascimento.style.backgroundColor='#FFFF99';
					continuar = false;					
				}
			}
		}
		
		
		if (form.numero_residencial.value == "") {
		mensagem = mensagem + 'Preencha o número do endereço residencial\n';
		form.numero_residencial.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.numero_residencial.value == "0") {
		mensagem = mensagem + 'O número do endereço residencial não pode ser zero\n';
		form.numero_residencial.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.CEP.value == "") {
		mensagem = mensagem + 'Preencha o CEP\n';
		form.CEP.style.backgroundColor='#FFFF99';
		continuar = false;
		} else {
			if (IsCEP(form.CEP.value)) {
			// O CEP é válido;
			} else {
				mensagem = mensagem + 'O CEP esta preenchido de forma incorreta\n';
				form.CEP.style.backgroundColor='#FFFF99';
				continuar = false;
			}
		}
		
		if (form.CEP.value == "0") {
		mensagem = mensagem + 'O CEP nao pode ser zero\n';
		form.CEP.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.endereco_residencial.value == "") {
		mensagem = mensagem + 'Preencha o endereço residencial\n';
		form.endereco_residencial.style.backgroundColor='#FFFF99';
		continuar = false;
		} else {
			if (validatePassword (form.endereco_residencial.value)){
			//O endereço não possui dados sequenciais ou repetidos
			} else {
			mensagem = mensagem + 'O endereço residencial foi preenchido de forma incorreta\n';
			form.endereco_residencial.style.backgroundColor='#FFFF99';
			continuar = false;
			}
		}
		
		if (form.numero_residencial.value == "") {
		mensagem = mensagem + 'Preencha o número do endereço residencial\n';
		form.numero_residencial.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.numero_residencial.value == "0") {
		mensagem = mensagem + 'O número do endereço residencial não pode ser zero\n';
		form.numero_residencial.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.bairro.value == "") {
		mensagem = mensagem + 'Preencha o bairro\n';
		form.bairro.style.backgroundColor='#FFFF99';
		continuar = false;
		} else {
			if (validatePassword (form.bairro.value)){
			//O bairro não possui dados sequenciais ou repetidos
			} else {
			//mensagem = mensagem + 'O bairro foi preenchido de forma incorreta\n';
			//form.bairro.style.backgroundColor='#FFFF99';
			//continuar = false;
			}
		}	

		if (form.cidade.value == "") {
		mensagem = mensagem + 'Escolha a cidade\n';
		form.cidade.style.backgroundColor='#FFFF99';
		continuar = false;
		} else {
			if (form.cidade.value == "Escolha a cidade") {
			mensagem = mensagem + 'A cidade precisa ser informada\n';
			form.cidade.style.backgroundColor='#FFFF99';
			continuar = false;
			} 
		}
		
		if (form.estado.value=="") {
		mensagem = mensagem + 'O estado precisa ser informado\n';
		form.estado.style.backgroundColor='#FFFF99';
		continuar = false;
		}
		
		if (form.DDD_celular.value == "") {
			mensagem = mensagem + 'Preencha o DDD do telefone celular\n';
			form.DDD_celular.style.backgroundColor='#FFFF99';
			continuar = false;
		}
				
		if (form.celular.value == "") {
			mensagem = mensagem + 'Preencha o telefone celular\n';
			form.celular.style.backgroundColor='#FFFF99';
			continuar = false;
		}

		if (form.senha.value == "") {
			mensagem = mensagem + 'Informe a sua senha\n';
			form.senha.style.backgroundColor='#FFFF99';
			continuar = false;
		} else {
			if (form.senha.value.length < 6){
				mensagem = mensagem + 'A senha deve ter pelo menos 6 caracteres\n';
				form.senha.style.backgroundColor='#FFFF99';
				continuar = false;
			} else {
				if (alphanumeric(form.senha)){
					//Nao faz nada
				} else {
					mensagem = mensagem + 'A senha deve possuir apenas letras ou números!\n';
					form.senha.style.backgroundColor='#FFFF99';
					continuar = false;
				}
			}
		}
		
		if (form.confirmar_senha.value == "") {
			mensagem = mensagem + 'Informe a confirmação da senha\n';
			form.confirmar_senha.style.backgroundColor='#FFFF99';
			continuar = false;
		}

		if (form.senha.value == form.confirmar_senha.value) {
			//Validar o formato de senha, se necessário
		} else {
			mensagem = mensagem + 'A senha e a confirmação da senha devem ser iguais\n';
			form.senha.style.backgroundColor='#FFFF99';
			form.confirmar_senha.style.backgroundColor='#FFFF99';
			continuar = false;
		}
		
	if (continuar) {
		return true;
	} else {
		alert(mensagem);
		return false;
	}

}
