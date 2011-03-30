<%

class mpago {
  Dim itens()
  Dim config()
  Dim cliente()
  '/**
  ' * MercadoPago
  ' * Função de inicialização
  ' * você pode passar os parâmetros alterando as informações padrão como o tipo de moeda e
  ' * os dados de configuração da sua conta no MercadoPago
  ' */
  
  Function mpago(args()) 
    'if (array <> gettype(args)) args() then
	  args(acc_id) = "",
      args(enc) = "",
	  args(url_process) = "",
	  args(url_succesfull) = "",
      args("currency") = "",
	  args(reseller_acc_id) = "", 
	  
      _config = args + default
	  
  End Function
  '/**
  ' * Retorna a mensagem de erro
  ' * @access public
  ' * @return string
  ' */
   
  Function error(msg)
    trigger_error(msg)
    'return this
  End Function
 ' /**
 '  * adicionar
 '  *
 '  * Adiciona um item ao carrinho de compras
 '  */
  Function adicionar(item) 

'   if (array <> gettype($item)) then
'      return this->error("Item precisa ser um array.")
    if(IsEmpty(item[0]))then
      for each item as elm 
        if(VarType(array) = VarType(elm)) then
           adicionar(elm) 
		end if
	end if
      'return 
	  
   End function   

    
      tipos("id") =   		array(1,"string",                @\w@         ),
      tipos("quantidade") = array(1,"string,integer",        @^\d+$@      ),
      tipos("valor") =      array(1,"double,string,integer", @^\d*\.?\d+$@),
      tipos("descricao") =  array(1,"string",                @\w@         ),
      tipos("frete") =      array(0,"string,integer",        @^\d+$@      ),
      tipos("peso") =       array(0,"string,integer",        @^\d+$@      ),
    

  for each(tipos as elm=valor)
      list(obrigatorio,validos,egexp)=valor
      if(IsEmpty(item[elm])) then
        if(strpos(validos,VarType(item[elm])) = false or
          (VarType(item[elm]) = "string" and !preg_match(regexp,item[elm]))) then
          return this->error("Valor invalido passado para elm.")
        end if
      else(obrigatorio) then
        return error("O item adicionado precisa conter elm")
	  end if	
      
    

    _itens[] = item;
    return _itens;
  }
  '/**
  ' * cliente
  ' *
  ' * Define o cliente a ser inserido no sistema.
  ' * Recebe como parametro um array associativo contendo os dados do cliente.
  ' *
  ' */
  Function cliente($args=array()) 
    if (array <> gettype(args)) then
		return
	end if
     _cliente = args;
  End Function
  '/**
  ' *
  ' * mostra
  ' *
  ' * Mostra o formulário de envio de post
  ' *
  ' * Configurar o objeto: você pode usar este método para mostrar o
  ' * formulário com todos os inputs necessários para enviar.
  ' *
  ' */
  Function mostra (args=array()) 
      array(print) = true
      array(open_form) = true
      array(close_form) = true
      array(show_submit) = true
      array(img_button) = false
      array(bnt_submit) = false
    )
    args = args+default;
    _input =  <input type="hidden" name="%s" value="%s"  />
    _form = array()
	
    if (args[open_form]) then
       form[] = <form target="mercadopago" action="https://www.mercadopago.com/mlb/buybutton" method="post">
	end if
    for each (_config as key=value)
      _form[] = sprintf (_input, key, value)
    for each (_cliente as key=value)
      _form[] = sprintf (_input, key, value)

	  assoc = array (id = item_id)
      assoc = array (descricao = item_desc)
      assoc = array (quantidade = item_quant)
    i=1
    for each (_itens as item) 
      for each (assoc as key = value) 
        sufixo=(_config[tipo]="CBR")?"":_.i
        _form[] = sprintf (_input, value.sufixo, item[key])
        unset(item[key])
      
      _form[] = str_replace (".", "", sprintf ("  <input type="hidden" name="%s" value="%.2f"  />", "item_valor$sufixo", item["valor"]))
      unset(item["valor"])

      for each (item as key=>value)
        _form[] = sprintf (_input, "item_{key}{sufixo}", value)
		
		i++
    
    if (args[show_submit]) then
      if (args[img_button]) then
        _form[] = sprintf(  <input type="image" src="%s" name="submit" alt="Mercado Pago"  />, args[img_button])
      else (args[btn_submit]) then
        switch (args[btn_submit]) 
            default: btn = buy_now_02_mlb.gif
        _form[] = sprintf (  <input type="image" src="https://www.mercadopago.com/org-img/MP3/buy_now_02_mlb.gif"  name="submit1" alt="Pagar" />, btn)
      else 
        _form[] =   <input type="submit" value="Pagar com o MercadoPago"  />
      end if  
    if(args[close_form]) _form[] = "</form>" then
		return = implode("\n", _form)
	end if	
    if (args[print]) print (retorno) then
		return retorno
	end if	
End Function
}

%>
